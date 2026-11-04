package com.example.expense_tracker_app

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var permissionResult: MethodChannel.Result? = null

    override fun onStart() {
        super.onStart()
        try {
            DailyReminderScheduler(applicationContext).ensureScheduled()
        } catch (error: Exception) {
            Log.e("DailyReminder", "Could not restore reminder", error)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val reminder = DailyReminderScheduler(applicationContext)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "expense_tracker/daily_reminder")
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "load" -> {
                            reminder.ensureScheduled()
                            result.success(reminder.status())
                        }
                        "save" -> {
                            check(permissionResult == null)
                            val enabled = requireNotNull(call.argument<Boolean>("enabled"))
                            val minutes = requireNotNull(call.argument<Int>("minutes"))
                            val wasEnabled = reminder.status()["enabled"] == true
                            reminder.save(enabled, minutes)
                            if (enabled && !wasEnabled && Build.VERSION.SDK_INT >= 33 &&
                                checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
                            ) {
                                permissionResult = result
                                try {
                                    requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), REMINDER_PERMISSION)
                                } catch (error: Exception) {
                                    permissionResult = null
                                    result.success(reminder.status())
                                }
                            } else {
                                result.success(reminder.status())
                            }
                        }
                        else -> result.notImplemented()
                    }
                } catch (error: Exception) {
                    result.error("daily_reminder", error.message, null)
                }
            }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != REMINDER_PERMISSION) return
        val result = permissionResult
        permissionResult = null
        result?.success(DailyReminderScheduler(applicationContext).status())
    }

    companion object {
        private const val REMINDER_PERMISSION = 3101
    }
}
