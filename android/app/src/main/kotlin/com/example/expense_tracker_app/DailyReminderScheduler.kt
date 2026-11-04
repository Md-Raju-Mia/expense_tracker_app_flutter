package com.example.expense_tracker_app

import android.Manifest
import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import java.util.Calendar
import java.util.UUID

internal class DailyReminderScheduler(private val context: Context) {
    private val preferences = context.getSharedPreferences("daily_reminder", Context.MODE_PRIVATE)
    private val alarms = context.getSystemService(AlarmManager::class.java)
    private val notifications = context.getSystemService(NotificationManager::class.java)

    fun status() = mapOf(
        "enabled" to (token != null),
        "minutes" to minutes,
        "allowed" to canNotify(),
    )

    private val token get() = preferences.getString("token", null)
    private val minutes get() = preferences.getInt("minutes", 20 * 60)

    fun save(enabled: Boolean, minutes: Int) {
        require(minutes in 0 until 24 * 60)
        val oldToken = token
        val oldMinutes = this.minutes
        val newToken = if (enabled) UUID.randomUUID().toString() else null
        replace(newToken, minutes)
        if (!preferences.edit().putString("token", newToken).putInt("minutes", minutes).commit()) {
            preferences.edit().putString("token", oldToken).putInt("minutes", oldMinutes).commit()
            replace(oldToken, oldMinutes)
            error("Could not persist daily reminder")
        }
        if (!enabled) notifications.cancel(NOTIFICATION_ID)
    }

    fun restore() = replace(token, minutes)

    fun ensureScheduled() {
        if (token != null && operation(null, PendingIntent.FLAG_NO_CREATE) == null) {
            restore()
        }
    }

    private fun replace(token: String?, minutes: Int) {
        if (token == null) {
            operation(null, PendingIntent.FLAG_NO_CREATE)?.let {
                alarms.cancel(it)
                it.cancel()
            }
            return
        }

        val now = System.currentTimeMillis()
        val next = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, minutes / 60)
            set(Calendar.MINUTE, minutes % 60)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            if (timeInMillis <= now) {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, minutes / 60)
                set(Calendar.MINUTE, minutes % 60)
            }
        }
        val alarm = checkNotNull(operation(token, PendingIntent.FLAG_UPDATE_CURRENT))
        alarms.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next.timeInMillis, alarm)
    }

    private fun operation(token: String?, flags: Int): PendingIntent? =
        PendingIntent.getBroadcast(
            context,
            0,
            Intent(context, DailyReminderReceiver::class.java).setAction(ALARM)
                .putExtra("token", token),
            flags or PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_ONE_SHOT,
        )

    private fun canNotify(): Boolean {
        if (Build.VERSION.SDK_INT >= 33 &&
            context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
        ) return false
        if (Build.VERSION.SDK_INT >= 24 && !notifications.areNotificationsEnabled()) return false
        return Build.VERSION.SDK_INT < 26 ||
            notifications.getNotificationChannel(CHANNEL)?.importance != NotificationManager.IMPORTANCE_NONE
    }

    @Suppress("DEPRECATION")
    fun deliver(intent: Intent) {
        val currentToken = token ?: return
        if (intent.getStringExtra("token") != currentToken) return
        replace(currentToken, minutes)
        if (!canNotify()) return

        val title = context.getString(R.string.daily_reminder_title)
        val builder = if (Build.VERSION.SDK_INT >= 26) {
            notifications.createNotificationChannel(
                NotificationChannel(CHANNEL, title, NotificationManager.IMPORTANCE_DEFAULT),
            )
            Notification.Builder(context, CHANNEL)
        } else {
            Notification.Builder(context)
        }
        val launch = PendingIntent.getActivity(
            context, 0, Intent(context, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        notifications.notify(
            NOTIFICATION_ID,
            builder.setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle(title)
                .setContentText(context.getString(R.string.daily_reminder_message))
                .setContentIntent(launch)
                .setAutoCancel(true)
                .build(),
        )
    }

    companion object {
        const val ALARM = "com.example.expense_tracker_app.DAILY_REMINDER"
        private const val CHANNEL = "daily_reminder"
        private const val NOTIFICATION_ID = 1001
    }
}
