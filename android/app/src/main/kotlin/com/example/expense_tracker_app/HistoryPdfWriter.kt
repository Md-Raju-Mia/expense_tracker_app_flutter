package com.example.expense_tracker_app

import android.graphics.Color
import android.graphics.Typeface
import android.graphics.pdf.PdfDocument
import android.text.StaticLayout
import android.text.TextPaint
import java.io.File

internal class HistoryPdfWriter(private val report: Map<*, *>) {
    private val title = report["title"] as String
    private val period = report["period"] as String
    private val count = report["count"] as String
    private val rows = report["rows"] as List<*>

    private var pageNumber = 0
    private var currentPage: PdfDocument.Page? = null
    private val page get() = checkNotNull(currentPage)
    private var y = MARGIN

    fun write(file: File) {
        val document = PdfDocument()
        try {
            startPage(document)
            for (entry in rows) {
                val row = entry as Map<*, *>
                val fields = listOf(
                    layout(row["title"] as String, 13f, INK, bold = true),
                    layout(row["details"] as String, 11f, MUTED),
                    layout(row["amount"] as String, 12f, TEAL, bold = true),
                )
                val height = fields.sumOf { it.height } + ROW_GAP
                if (y + height > BOTTOM && y > headerEnd) {
                    finishPage(document)
                    startPage(document)
                }
                fields.forEach { drawLines(document, it) }
                y += ROW_GAP
            }
            finishPage(document)
            file.outputStream().use(document::writeTo)
        } finally {
            currentPage?.let(document::finishPage)
            document.close()
        }
    }

    private var headerEnd = MARGIN

    private fun startPage(document: PdfDocument) {
        currentPage = document.startPage(PdfDocument.PageInfo.Builder(WIDTH, HEIGHT, ++pageNumber).create())
        y = MARGIN
        draw(layout(title, 22f, TEAL, bold = true))
        draw(layout("$period  •  $count", 11f, MUTED))
        y += 12
        page.canvas.drawLine(MARGIN.toFloat(), y.toFloat(), (WIDTH - MARGIN).toFloat(), y.toFloat(), paint(1f, TEAL))
        y += 12
        headerEnd = y
    }

    private fun finishPage(document: PdfDocument) {
        page.canvas.drawText(pageNumber.toString(), MARGIN.toFloat(), (HEIGHT - 24).toFloat(), paint(10f, MUTED))
        document.finishPage(page)
        currentPage = null
    }

    private fun drawLines(document: PdfDocument, layout: StaticLayout) {
        var start = 0
        while (start < layout.lineCount) {
            val top = layout.getLineTop(start)
            var end = start
            while (end < layout.lineCount && y + layout.getLineTop(end + 1) - top <= BOTTOM) {
                end++
            }
            if (end > start) {
                val height = layout.getLineTop(end) - top
                val canvas = page.canvas
                canvas.save()
                canvas.clipRect(MARGIN, y, WIDTH - MARGIN, y + height)
                canvas.translate(MARGIN.toFloat(), (y - top).toFloat())
                layout.draw(canvas)
                canvas.restore()
                y += height
                start = end
            }
            if (start < layout.lineCount) {
                finishPage(document)
                startPage(document)
            }
        }
    }

    private fun draw(layout: StaticLayout) {
        val canvas = page.canvas
        canvas.save()
        canvas.translate(MARGIN.toFloat(), y.toFloat())
        layout.draw(canvas)
        canvas.restore()
        y += layout.height
    }

    private fun layout(text: String, size: Float, color: Int, bold: Boolean = false) =
        StaticLayout.Builder.obtain(text, 0, text.length, paint(size, color, bold), WIDTH - 2 * MARGIN)
            .setBreakStrategy(0)
            .build()

    private fun paint(size: Float, ink: Int, bold: Boolean = false) = TextPaint(TextPaint.ANTI_ALIAS_FLAG).apply {
        textSize = size
        color = ink
        typeface = if (bold) Typeface.DEFAULT_BOLD else Typeface.DEFAULT
    }

    companion object {
        private const val WIDTH = 595
        private const val HEIGHT = 842
        private const val MARGIN = 40
        private const val BOTTOM = HEIGHT - MARGIN - 12
        private const val ROW_GAP = 12
        private const val INK = Color.BLACK
        private const val MUTED = 0xff455a64.toInt()
        private const val TEAL = 0xff075e55.toInt()
    }
}
