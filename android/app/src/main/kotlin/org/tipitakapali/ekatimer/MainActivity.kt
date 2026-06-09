// android/app/src/main/kotlin/org/tipitakapali/ekatimer/MainActivity.kt

package org.tipitakapali.ekatimer

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val WIDGET_CHANNEL = "org.tipitakapali.ekatimer/widget"
    private var widgetTimerMode: String? = null
    private var widgetTimerDuration: Int? = null
    private var widgetAction: String? = null
    private var widgetStatsPeriod: String? = null
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (intent?.getIntExtra("from_alarm", -1) != -1) {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
            )
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        readWidgetIntent(intent)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            WIDGET_CHANNEL
        )
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "updateAllWidgets" -> {
                    val transparent = call.argument<Boolean>("transparent") ?: false
                    MeditationTimerWidget.updateAllWidgets(
                        applicationContext,
                        transparent
                    )
                    result.success(null)
                }
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
                    if (intent?.getIntExtra("from_alarm", -1) != -1) {
                        data["fromAlarm"] = true
                    }

                    widgetTimerMode = null
                    widgetTimerDuration = null
                    widgetAction = null
                    widgetStatsPeriod = null

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
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        readWidgetIntent(intent)
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
