package org.tipitakapali.ekatimer

import android.content.Intent
import android.os.Bundle
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
            widgetTimerDuration = it.getIntExtra("widget_timer_duration", 0)
            widgetAction = it.getStringExtra("widget_action")
            widgetStatsPeriod = it.getStringExtra("widget_stats_period")
        }
    }
}
