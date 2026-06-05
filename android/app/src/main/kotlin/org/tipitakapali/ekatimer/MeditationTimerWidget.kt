// android/app/src/main/kotlin/org/tipitakapali/ekatimer/MeditationTimerWidget.kt

package org.tipitakapali.ekatimer

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import org.json.JSONObject

/**
 * Base widget provider for meditation timer widgets.
 * Subclasses define the fixed layout type so the user gets the exact
 * widget they chose from the picker.
 */
open class MeditationTimerWidget : AppWidgetProvider() {

    /** Override in each subclass to define which layout and behaviour. */
    open val widgetConfig: WidgetConfig get() = WidgetConfig.QUICK_START_1H

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = buildWidgetViews(context, widgetConfig)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: android.os.Bundle?,
    ) {
        val views = buildWidgetViews(context, widgetConfig)
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    // ── Layout & Action Config ────────────────────────────────────────

    enum class WidgetConfig(
        val layoutRes: Int,
        val actionLabel: String,
        val timerMode: String,
        val timerDuration: Int,   // minutes; 0 means use mode-specific default
        val description: String,
    ) {
        QUICK_START_15M(
            R.layout.widget_quickstart,
            "15m", "timed", 15,
            "Start a 15-minute meditation"
        ),
        QUICK_START_30M(
            R.layout.widget_quickstart,
            "30m", "timed", 30,
            "Start a 30-minute meditation"
        ),
        QUICK_START_1H(
            R.layout.widget_quickstart,
            "1H", "timed", 60,
            "Start a 1-hour meditation"
        ),
        QUICK_START_1_5H(
            R.layout.widget_quickstart,
            "1.5H", "timed", 90,
            "Start a 1.5-hour meditation"
        ),
        QUICK_START_2H(
            R.layout.widget_quickstart,
            "2H", "timed", 120,
            "Start a 2-hour meditation"
        ),
        QUICK_START_2_5H(
            R.layout.widget_quickstart,
            "2.5H", "timed", 150,
            "Start a 2.5-hour meditation"
        ),
        QUICK_START_3H(
            R.layout.widget_quickstart,
            "3H", "timed", 180,
            "Start a 3-hour meditation"
        ),
        QUICK_START_3_5H(
            R.layout.widget_quickstart,
            "3.5H", "timed", 210,
            "Start a 3.5-hour meditation"
        ),
        QUICK_START_4H(
            R.layout.widget_quickstart,
            "4H", "timed", 240,
            "Start a 4-hour meditation"
        ),
        QUICK_START_END_AT(
            R.layout.widget_quickstart,
            "End", "endAt", 0,
            "Set an end-time meditation"
        ),
        QUICK_START_UNTIMED(
            R.layout.widget_quickstart,
            "∞", "unlimited", 0,
            "Start an unlimited meditation"
        );
    }

    // ── Build Views ───────────────────────────────────────────────────

    private fun buildWidgetViews(
        context: Context,
        config: WidgetConfig,
    ): RemoteViews {
        val views = RemoteViews(context.packageName, config.layoutRes)

        // Set the label on the shared quick-start layout
        views.setTextViewText(R.id.widget_action_label, config.actionLabel)

        // Open app on widget tap via launch intent with extras
        val intent = context.packageManager.getLaunchIntentForPackage(
            context.packageName
        ) ?: Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
        }

        intent.putExtra("widget_timer_mode", config.timerMode)
        intent.putExtra("widget_timer_duration", config.timerDuration)

        val pendingIntentFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            config.ordinal, // unique request code per widget type
            intent,
            pendingIntentFlags
        )
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

        return views
    }
}

// ── Concrete Widget Subclasses ───────────────────────────────────────

class Meditation15mWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_15M
}

class Meditation30mWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_30M
}

class Meditation1HWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_1H
}

class Meditation1_5HWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_1_5H
}

class Meditation2HWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_2H
}

class Meditation2_5HWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_2_5H
}

class Meditation3HWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_3H
}

class Meditation3_5HWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_3_5H
}

class Meditation4HWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_4H
}

class MeditationEndAtWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_END_AT
}

class MeditationUnlimitedWidget : MeditationTimerWidget() {
    override val widgetConfig get() = WidgetConfig.QUICK_START_UNTIMED
}
