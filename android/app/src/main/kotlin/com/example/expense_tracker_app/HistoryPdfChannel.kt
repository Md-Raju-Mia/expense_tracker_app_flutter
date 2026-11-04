package com.example.expense_tracker_app

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.ClipData
import android.content.Intent
import android.provider.DocumentsContract
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import kotlin.concurrent.thread

internal class HistoryPdfChannel(private val activity: Activity, messenger: BinaryMessenger) {
    private data class Export(val file: File, val result: MethodChannel.Result)
    private var pending: Export? = null

    init {
        MethodChannel(messenger, "expense_tracker/history_pdf").setMethodCallHandler { call, result ->
            if (call.method != "export" && call.method != "share") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            if (pending != null) {
                result.error("history_pdf", "An export is in progress", null)
                return@setMethodCallHandler
            }
            try {
                val report = call.arguments as Map<*, *>
                val directory = File(activity.cacheDir, "history-pdfs")
                directory.mkdirs()
                val cutoff = System.currentTimeMillis() - CACHE_RETENTION_MS
                directory.listFiles()?.filter { it.lastModified() < cutoff }?.forEach { it.delete() }
                val file = File.createTempFile("history-", ".pdf", directory)
                val export = Export(file, result)
                pending = export
                thread(name = "history-pdf") {
                    try {
                        HistoryPdfWriter(report).write(file)
                        activity.runOnUiThread {
                            if (call.method == "share") share(export) else chooseDestination(export)
                        }
                    } catch (error: Exception) {
                        activity.runOnUiThread { fail(export, error) }
                    }
                }
            } catch (error: Exception) {
                result.error("history_pdf", error.message, null)
            }
        }
    }

    private fun share(export: Export) {
        try {
            check(!activity.isFinishing && !activity.isDestroyed)
            val uri = FileProvider.getUriForFile(
                activity, "${activity.packageName}.history_pdf", export.file, FILE_NAME,
            )
            val send = Intent(Intent.ACTION_SEND).apply {
                type = MIME_TYPE
                putExtra(Intent.EXTRA_STREAM, uri)
                clipData = ClipData.newRawUri(FILE_NAME, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            activity.startActivity(Intent.createChooser(send, null))
            // The recipient may open the stream after the chooser returns.
            pending = null
            export.result.success(true)
        } catch (error: Exception) {
            fail(export, error)
        }
    }

    @Suppress("DEPRECATION")
    private fun chooseDestination(export: Export) {
        try {
            check(!activity.isFinishing && !activity.isDestroyed)
            val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                addCategory(Intent.CATEGORY_OPENABLE)
                type = MIME_TYPE
                putExtra(Intent.EXTRA_TITLE, FILE_NAME)
            }
            activity.startActivityForResult(intent, SAVE_REQUEST)
        } catch (error: Exception) {
            fail(export, error)
        }
    }

    fun onActivityResult(request: Int, result: Int, data: Intent?): Boolean {
        if (request != SAVE_REQUEST) return false
        val export = pending ?: return true
        if (result != Activity.RESULT_OK) {
            complete(export, false)
            return true
        }
        val uri = data?.data
        if (uri == null) {
            fail(export, IllegalStateException("The document picker returned no destination"))
            return true
        }
        thread(name = "history-pdf-save") {
            try {
                val resolver = activity.contentResolver
                checkNotNull(resolver.openOutputStream(uri, "wt")).use { output ->
                    export.file.inputStream().use { it.copyTo(output) }
                }
            } catch (error: Exception) {
                runCatching { DocumentsContract.deleteDocument(activity.contentResolver, uri) }
                activity.runOnUiThread { fail(export, error) }
                return@thread
            }
            activity.runOnUiThread {
                complete(export, true)
                if (!activity.isFinishing && !activity.isDestroyed) {
                    try {
                        activity.startActivity(Intent(Intent.ACTION_VIEW).apply {
                            setDataAndType(uri, MIME_TYPE)
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        })
                    } catch (_: ActivityNotFoundException) {
                        // The PDF was saved and can be opened from the selected location.
                    } catch (_: SecurityException) {
                        // Some document providers prevent forwarding their URI.
                    }
                }
            }
        }
        return true
    }

    private fun complete(export: Export, saved: Boolean) {
        export.file.delete()
        pending = null
        export.result.success(saved)
    }

    private fun fail(export: Export, error: Exception) {
        export.file.delete()
        pending = null
        export.result.error("history_pdf", error.message, null)
    }

    companion object {
        private const val SAVE_REQUEST = 3102
        private const val MIME_TYPE = "application/pdf"
        private const val FILE_NAME = "expense-history.pdf"
        private const val CACHE_RETENTION_MS = 24 * 60 * 60 * 1000L
    }
}

class HistoryPdfFileProvider : FileProvider()
