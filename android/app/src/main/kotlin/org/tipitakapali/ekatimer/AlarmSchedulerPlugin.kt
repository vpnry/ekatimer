package org.tipitakapali.ekatimer

import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.BinaryMessenger.BinaryMessageHandler
import java.io.File

class AlarmSchedulerPlugin {
    companion object {
        private const val CHANNEL = "org.tipitakapali.ekatimer/alarm"
        private const val EVENT_CHANNEL = "org.tipitakapali.ekatimer/alarm_events"
        const val TAG = "AlarmSchedulerPlugin"

        // Unique request codes for each alarm type
        const val REQUEST_CODE_TIMED_END = 1001
        const val REQUEST_CODE_ENDAT_END = 1002
        const val REQUEST_CODE_WAKE_CHECK = 1003

        private var wakeLock: PowerManager.WakeLock? = null
        private var mediaPlayer: MediaPlayer? = null
        var eventSink: EventChannel.EventSink? = null
        private var permissionReceiver: ExactAlarmPermissionReceiver? = null
        private var appContext: Context? = null

        fun register(binaryMessenger: BinaryMessenger, context: Context) {
            appContext = context.applicationContext

            // Register broadcast receiver for exact alarm permission changes
            registerPermissionReceiver(context)

            // Set up event channel for native -> Flutter communication
            EventChannel(binaryMessenger, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.d(TAG, "EventChannel listener registered")
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Log.d(TAG, "EventChannel listener cancelled")
                }
            })

            MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                Log.d(TAG, "Method called: ${call.method} with args: ${call.arguments}")

                try {
                    when (call.method) {
                        "acquireCpuWakeLock" -> {
                            acquireCpuWakeLock(context)
                            result.success(true)
                        }
                        "releaseCpuWakeLock" -> {
                            releaseCpuWakeLock()
                            result.success(true)
                        }
                        "scheduleEndAlarm" -> {
                            val delaySeconds = call.argument<Int>("delaySeconds") ?: 0
                            val endTimeMillis = call.argument<Long>("endTimeMillis") ?: 0L
                            val requestCode = call.argument<Int>("requestCode") ?: REQUEST_CODE_TIMED_END
                            val soundPath = call.argument<String>("soundPath") ?: ""
                            scheduleEndAlarm(context, delaySeconds, endTimeMillis, requestCode, soundPath)
                            result.success(true)
                        }
                        "cancelEndAlarm" -> {
                            val requestCode = call.argument<Int>("requestCode") ?: REQUEST_CODE_TIMED_END
                            cancelEndAlarm(context, requestCode)
                            result.success(true)
                        }
                        "cancelAllAlarms" -> {
                            cancelAllAlarms(context)
                            result.success(true)
                        }
                        "playEndSound" -> {
                            val soundPath = call.argument<String>("soundPath") ?: ""
                            playEndSound(context, soundPath)
                            result.success(true)
                        }
                        "hasExactAlarmPermission" -> {
                            result.success(canScheduleExactAlarms(context))
                        }
                        "requestExactAlarmPermission" -> {
                            requestExactAlarmPermission(context)
                            result.success(true)
                        }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error handling method ${call.method}", e)
                    result.error("ALARM_ERROR", e.message, null)
                }
            }
        }

        private fun registerPermissionReceiver(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                permissionReceiver = ExactAlarmPermissionReceiver()
                val filter = IntentFilter(AlarmManager.ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    context.registerReceiver(permissionReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
                } else {
                    context.registerReceiver(permissionReceiver, filter)
                }
                Log.d(TAG, "Registered exact alarm permission receiver")
            }
        }

        private fun acquireCpuWakeLock(context: Context) {
            if (wakeLock?.isHeld == true) {
                Log.d(TAG, "CPU wake lock already held")
                return
            }
            val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = pm.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "ekatimer:cpu_wakelock"
            )
            wakeLock?.acquire(4 * 60 * 60 * 1000L) // Max 4 hours to prevent battery drain
            Log.d(TAG, "CPU wake lock acquired")
        }

        private fun releaseCpuWakeLock() {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
                wakeLock = null
                Log.d(TAG, "CPU wake lock released")
            }
        }

        private fun canScheduleExactAlarms(context: Context): Boolean {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                return am.canScheduleExactAlarms()
            }
            return true
        }

        private fun requestExactAlarmPermission(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                    data = Uri.fromParts("package", context.packageName, null)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(intent)
                Log.d(TAG, "Requested exact alarm permission via Settings intent")
            }
        }

        private fun scheduleEndAlarm(context: Context, delaySeconds: Int, endTimeMillis: Long, requestCode: Int, soundPath: String = "") {
            // Check exact alarm permission before scheduling
            if (!canScheduleExactAlarms(context)) {
                Log.w(TAG, "Exact alarm permission not granted, requesting...")
                requestExactAlarmPermission(context)
                return
            }

            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, AlarmReceiver::class.java).apply {
                action = "org.tipitakapali.ekatimer.END_ALARM"
                putExtra("requestCode", requestCode)
                putExtra("soundPath", soundPath)
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val triggerTime: Long
            if (endTimeMillis > 0) {
                triggerTime = endTimeMillis
            } else {
                triggerTime = System.currentTimeMillis() + (delaySeconds * 1000L)
            }

            Log.d(TAG, "Scheduling alarm: requestCode=$requestCode, triggerTime=$triggerTime, delaySec=$delaySeconds")

            // Use setAlarmClock on API 21+ for most reliable doze wake.
            // Unlike setExactAndAllowWhileIdle, AlarmManager.AlarmClockInfo is
            // guaranteed by Android to fire on time—it is treated as a user-facing
            // alarm clock and always wakes the device from deep doze.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val showIntent = Intent(context, AlarmReceiver::class.java).apply {
                    action = "org.tipitakapali.ekatimer.ALARM_SHOW"
                }
                val showPendingIntent = PendingIntent.getBroadcast(
                    context,
                    requestCode + 10000,
                    showIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                am.setAlarmClock(
                    AlarmManager.AlarmClockInfo(triggerTime, showPendingIntent),
                    pendingIntent
                )
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                am.setExact(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
            } else {
                am.set(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
            }

            // The Flutter side manages the CPU wake lock lifecycle via
            // acquireCpuWakeLock / releaseCpuWakeLock MethodChannel calls.
            // We do NOT acquire one here to avoid duplication.
        }

        private fun cancelEndAlarm(context: Context, requestCode: Int) {
            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

            // Cancel the main end alarm
            val intent = Intent(context, AlarmReceiver::class.java).apply {
                action = "org.tipitakapali.ekatimer.END_ALARM"
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            am.cancel(pendingIntent)
            pendingIntent.cancel()

            // Also cancel the associated ALARM_SHOW PendingIntent
            val showIntent = Intent(context, AlarmReceiver::class.java).apply {
                action = "org.tipitakapali.ekatimer.ALARM_SHOW"
            }
            val showPendingIntent = PendingIntent.getBroadcast(
                context,
                requestCode + 10000,
                showIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            am.cancel(showPendingIntent)
            showPendingIntent.cancel()

            Log.d(TAG, "Cancelled alarm: requestCode=$requestCode")
        }

        private fun cancelAllAlarms(context: Context) {
            cancelEndAlarm(context, REQUEST_CODE_TIMED_END)
            cancelEndAlarm(context, REQUEST_CODE_ENDAT_END)
            cancelEndAlarm(context, REQUEST_CODE_WAKE_CHECK)
            releaseCpuWakeLock()
            releaseMediaPlayer()
        }

        @JvmStatic
        fun playEndSound(context: Context, soundPath: String) {
            try {
                Log.d(TAG, "Playing end sound: $soundPath")
                releaseMediaPlayer()

                // Acquire CPU wake lock to ensure playback completes
                acquireCpuWakeLock(context)

                val uri: Uri
                if (soundPath.isNotEmpty() && !soundPath.startsWith("none")) {
                    if (soundPath.startsWith("assets/")) {
                        // Flutter assets are stored under "flutter_assets/" in the APK.
                        // Use AssetManager to open them directly rather than looking for raw resources.
                        try {
                            val assetPath = "flutter_assets/$soundPath"
                            val afd = context.assets.openFd(assetPath)
                            mediaPlayer = MediaPlayer().apply {
                                setAudioAttributes(
                                    AudioAttributes.Builder()
                                        .setUsage(AudioAttributes.USAGE_ALARM)
                                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                                        .build()
                                )
                                setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                                setOnPreparedListener { mp ->
                                    mp.start()
                                    Log.d(TAG, "MediaPlayer started playing end sound from assets")
                                }
                                setOnCompletionListener {
                                    Log.d(TAG, "MediaPlayer completed end sound")
                                    releaseMediaPlayer()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    true
                                }
                                prepareAsync()
                            }
                            return
                        } catch (e: Exception) {
                            Log.w(TAG, "Could not load asset via AssetManager, falling back to default: $soundPath", e)
                            // Fall through to default alarm sound
                        }
                    } else {
                        val file = File(soundPath)
                        if (file.exists()) {
                            mediaPlayer = MediaPlayer().apply {
                                setAudioAttributes(
                                    AudioAttributes.Builder()
                                        .setUsage(AudioAttributes.USAGE_ALARM)
                                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                                        .build()
                                )
                                setDataSource(context, Uri.fromFile(file))
                                setOnPreparedListener { mp ->
                                    mp.start()
                                    Log.d(TAG, "MediaPlayer started playing end sound from file")
                                }
                                setOnCompletionListener {
                                    Log.d(TAG, "MediaPlayer completed end sound")
                                    releaseMediaPlayer()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    true
                                }
                                prepareAsync()
                            }
                            return
                        }
                    }
                }

                // Fallback to default alarm sound
                val defaultUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                mediaPlayer = MediaPlayer().apply {
                    setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build()
                    )
                    setDataSource(context, defaultUri)
                    setOnPreparedListener { mp ->
                        mp.start()
                        Log.d(TAG, "MediaPlayer started playing default alarm sound")
                    }
                    setOnCompletionListener {
                        Log.d(TAG, "MediaPlayer completed default alarm sound")
                        releaseMediaPlayer()
                    }
                    setOnErrorListener { _, what, extra ->
                        Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                        releaseMediaPlayer()
                        true
                    }
                    prepareAsync()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Failed to play end sound", e)
                releaseMediaPlayer()
            }
        }

        private fun releaseMediaPlayer() {
            try {
                mediaPlayer?.apply {
                    if (isPlaying) stop()
                    reset()
                    release()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error releasing media player", e)
            }
            mediaPlayer = null
        }
    }
}

class AlarmReceiver : BroadcastReceiver() {
    companion object {
        // Track the alarm wake lock so we can release it when sound completes
        private var alarmWakeLock: PowerManager.WakeLock? = null

        fun releaseAlarmWakeLock() {
            try {
                if (alarmWakeLock?.isHeld == true) {
                    alarmWakeLock?.release()
                }
            } catch (e: Exception) {
                Log.e(AlarmSchedulerPlugin.TAG, "Error releasing alarm wake lock", e)
            }
            alarmWakeLock = null
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(AlarmSchedulerPlugin.TAG, "AlarmReceiver.onReceive: action=$action")

        // Handle the show intent from setAlarmClock (wake screen on alarm clock icon tap)
        if (action == "org.tipitakapali.ekatimer.ALARM_SHOW") {
            // Launch the main Flutter activity so the user sees the timer when
            // tapping the alarm clock icon in the status bar
            val launchIntent = context.packageManager.getLaunchIntentForPackage(
                context.packageName
            )?.apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
            }
            if (launchIntent != null) {
                try {
                    context.startActivity(launchIntent)
                } catch (e: Exception) {
                    Log.e(AlarmSchedulerPlugin.TAG, "Failed to launch activity for ALARM_SHOW", e)
                }
            }
            return
        }

        if (action == "org.tipitakapali.ekatimer.END_ALARM") {
            val requestCode = intent.getIntExtra("requestCode", -1)
            val soundPath = intent.getStringExtra("soundPath") ?: ""
            Log.d(AlarmSchedulerPlugin.TAG, "AlarmReceiver.onReceive: requestCode=$requestCode, soundPath=$soundPath")

            // 1. Acquire CPU wake lock to keep CPU awake and ensure sound plays
            val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            val wakeLock = pm.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "ekatimer:alarm_wakelock"
            )
            wakeLock.acquire(120000L) // 2 minute max for alarm sound
            alarmWakeLock = wakeLock

            // 2. Wake the screen and turn it on.
            //    We acquire a SCREEN_BRIGHT wake lock with ACQUIRE_CAUSES_WAKEUP
            //    to wake the display on all API levels.
            //    On API 27-34 we also use Intent.FLAG_ACTIVITY_TURN_SCREEN_ON.
            //    Note: FLAG_ACTIVITY_TURN_SCREEN_ON was removed in API 35+,
            //    so we use reflection to stay compatible.
            pm.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or
                PowerManager.ACQUIRE_CAUSES_WAKEUP or
                PowerManager.ON_AFTER_RELEASE,
                "ekatimer:screen_wakelock"
            ).acquire(5000L)

            val launchIntent = context.packageManager.getLaunchIntentForPackage(
                context.packageName
            )?.apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
                // Use reflection to add FLAG_ACTIVITY_TURN_SCREEN_ON since it
                // was removed from the SDK in API 35 but still exists at runtime
                // on API 27-34.
                try {
                    val field = Intent::class.java.getField("FLAG_ACTIVITY_TURN_SCREEN_ON")
                    val flag = field.getInt(null)
                    addFlags(flag)
                } catch (e: Exception) {
                    // Flag not available (API 35+) — the SCREEN_BRIGHT wake lock
                    // with ACQUIRE_CAUSES_WAKEUP above handles screen wakeup
                    Log.d(AlarmSchedulerPlugin.TAG, "FLAG_ACTIVITY_TURN_SCREEN_ON not available, using wake lock instead")
                }
                // Signal to MainActivity that this launch came from an alarm
                putExtra("from_alarm", requestCode)
            }
            if (launchIntent != null) {
                try {
                    context.startActivity(launchIntent)
                } catch (e: Exception) {
                    Log.e(AlarmSchedulerPlugin.TAG, "Failed to launch activity for END_ALARM", e)
                }
            }

            // 3. Play end sound directly from native — bypasses Flutter EventChannel
            //    which may not deliver events when Flutter isolate is paused.
            AlarmSchedulerPlugin.playEndSound(context, soundPath)

            // 4. Also send event back to Flutter via EventChannel so the app can update its UI
            val sink = AlarmSchedulerPlugin.eventSink
            if (sink != null) {
                val result = mapOf("requestCode" to requestCode)
                sink.success(result)
                Log.d(AlarmSchedulerPlugin.TAG, "Alarm fired, sent to Flutter via EventChannel, requestCode=$requestCode")
            } else {
                Log.w(AlarmSchedulerPlugin.TAG, "Alarm fired but no EventChannel sink available, requestCode=$requestCode")
            }

            // 5. Release the wake lock after a generous delay to let the sound play fully
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                releaseAlarmWakeLock()
            }, 120000L) // 2 minutes
        }
    }
}

/**
 * Broadcast receiver that listens for the exact alarm permission state change.
 * This is triggered when the user grants or revokes the SCHEDULE_EXACT_ALARM permission.
 * When granted, we notify Flutter via the EventChannel so it can retry scheduling.
 */
class ExactAlarmPermissionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == AlarmManager.ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val hasPermission = alarmManager.canScheduleExactAlarms()
            Log.d(AlarmSchedulerPlugin.TAG, "Exact alarm permission changed: hasPermission=$hasPermission")

            // Notify Flutter via EventChannel
            val sink = AlarmSchedulerPlugin.eventSink
            if (sink != null) {
                val result = mapOf(
                    "type" to "permission_changed",
                    "hasPermission" to hasPermission
                )
                sink.success(result)
                Log.d(AlarmSchedulerPlugin.TAG, "Sent permission_changed event to Flutter")
            } else {
                Log.w(AlarmSchedulerPlugin.TAG, "No EventChannel sink available to notify Flutter")
            }
        }
    }
}
