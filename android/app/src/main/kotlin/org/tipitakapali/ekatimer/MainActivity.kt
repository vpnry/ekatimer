// android/app/src/main/kotlin/org/tipitakapali/ekatimer/MainActivity.kt

package org.tipitakapali.ekatimer

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val WIDGET_CHANNEL = "org.tipitakapali.ekatimer/widget"
    private val ALARM_CHANNEL = "org.tipitakapali.ekatimer/alarm"
    private var widgetTimerMode: String? = null
    private var widgetTimerDuration: Int? = null
    private var widgetAction: String? = null
    private var widgetStatsPeriod: String? = null
    private var methodChannel: MethodChannel? = null
    private var lastExactAlarmPermissionState: Boolean? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Add screen-on & keyguard-dismiss flags if launched from an alarm.
        // This mirrors what the reference app (MeditationAssistant) does in
        // CompleteActivity.onCreate() with WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
        // and FLAG_DISMISS_KEYGUARD.
        if (intent?.getIntExtra("from_alarm", -1) != -1) {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
            )
        }

        // Record initial permission state
        lastExactAlarmPermissionState = canScheduleExactAlarms()
    }

    override fun onResume() {
        super.onResume()

        // Check if exact alarm permission state changed while away
        // (e.g., user went to Settings and granted/revoked permission)
        val currentPermissionState = canScheduleExactAlarms()
        if (lastExactAlarmPermissionState != currentPermissionState) {
            lastExactAlarmPermissionState = currentPermissionState
            Log.d(TAG, "Exact alarm permission changed in onResume: $currentPermissionState")

            // Notify Flutter via MethodChannel
            methodChannel?.invokeMethod("onExactAlarmPermissionChanged", currentPermissionState)
        }
    }

    private fun canScheduleExactAlarms(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            return alarmManager.canScheduleExactAlarms()
        }
        return true
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Read intent extras passed by widget taps
        readWidgetIntent(intent)

        // Expose widget data to Flutter via MethodChannel
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            WIDGET_CHANNEL
        )
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getWidgetAction" -> {
                    val data = mutableMapOf<String, Any>()
                    if (widgetTimerMode != null) {
                        data["timerMode"] = widgetTimerMode!!
                        data["timerDuration"] = widgetTimerDuration ?: 0
                    }
                    if (widgetAction != null) {
                        data["action"] = widgetAction!!
                        data["statsPeriod"] = widgetStatsPeriod ?: "week"
                    }
                    // Tell Flutter if this launch was from an alarm so it can
                    // skip the session restore check (the alarm handler already
                    // completed the session via EventChannel).
                    if (intent?.getIntExtra("from_alarm", -1) != -1) {
                        data["fromAlarm"] = true
                    }

                    // Clear cached variables after sending them to Flutter.
                    // This prevents re-triggering the widget action on normal app resume.
                    widgetTimerMode = null
                    widgetTimerDuration = null
                    widgetAction = null
                    widgetStatsPeriod = null

                    // Clear consumed intent extras.
                    intent?.removeExtra("widget_timer_mode")
                    intent?.removeExtra("widget_timer_duration")
                    intent?.removeExtra("widget_action")
                    intent?.removeExtra("widget_stats_period")
                    intent?.removeExtra("from_alarm")

                    result.success(data.ifEmpty { null })
                }
                else -> result.notImplemented()
            }
        }

        // Register the alarm scheduler plugin
        AlarmSchedulerPlugin.register(
            flutterEngine.dartExecutor.binaryMessenger,
            applicationContext
        )
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Update the current intent of the activity.
        // Without this call, getIntent() or the intent property retains
        // stale parameters from the original launch.
        setIntent(intent)

        // Re-read intent extras when app is brought to foreground (singleTop)
        // The Flutter side checks for actions on app resume via
        // WidgetsBindingObserver (doesChangeAppLifecycleState).
        readWidgetIntent(intent)

        // If this is an alarm-triggered re-launch (singleTop), re-apply window flags.
        if (intent.getIntExtra("from_alarm", -1) != -1) {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
            )
        }
    }

    private fun readWidgetIntent(intent: Intent?) {
        intent?.let {
            widgetTimerMode = it.getStringExtra("widget_timer_mode")
            widgetTimerDuration = if (it.hasExtra("widget_timer_duration")) {
                it.getIntExtra("widget_timer_duration", 0)
            } else {
                null
            }
            widgetAction = it.getStringExtra("widget_action")
            widgetStatsPeriod = it.getStringExtra("widget_stats_period")
        }
    }

    companion object {
        private const val TAG = "MainActivity"
    }
}
