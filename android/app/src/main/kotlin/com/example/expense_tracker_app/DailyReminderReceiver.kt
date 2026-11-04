package com.example.expense_tracker_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class DailyReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val reminder = DailyReminderScheduler(context)
        when (intent.action) {
            DailyReminderScheduler.ALARM -> reminder.deliver(intent)
            Intent.ACTION_BOOT_COMPLETED, Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED, Intent.ACTION_MY_PACKAGE_REPLACED -> reminder.restore()
        }
    }
}
