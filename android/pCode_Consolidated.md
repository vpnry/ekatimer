# Consolidated Code Report

Generated from: `android`
Date: 2026-06-07T08:01:59.763Z
Total files: 44

---

// .gitignore

gradle-wrapper.jar
/.gradle
/captures/
/gradlew
/gradlew.bat
/local.properties
GeneratedPluginRegistrant.java
.cxx/

# Remember to never publicly share your keystore.
# See https://flutter.dev/to/reference-keystore
key.properties
**/*.keystore
**/*.jks


---

// app/build.gradle.kts

import java.io.FileInputStream
import java.util.*

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties from key.properties file
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "org.tipitakapali.ekatimer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "org.tipitakapali.ekatimer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}


---

// app/pCode_Consolidated.md

# Consolidated Code Report

Generated from: `app`
Date: 2026-06-07T06:54:06.633Z
Total files: 39

---

// build.gradle.kts

import java.io.FileInputStream
import java.util.*

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties from key.properties file
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "org.tipitakapali.ekatimer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "org.tipitakapali.ekatimer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}


---

// src/debug/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>


---

// src/main/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />

    <application
        android:label="ekaTimer"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- Widget – 15m -->
        <receiver
            android:name=".Meditation15mWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_15m_info" />
        </receiver>

        <!-- Widget – 30m -->
        <receiver
            android:name=".Meditation30mWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_30m_info" />
        </receiver>

        <!-- Widget – 1H -->
        <receiver
            android:name=".Meditation1HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_1h_info" />
        </receiver>

        <!-- Widget – 1.5H -->
        <receiver
            android:name=".Meditation1_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_1_5h_info" />
        </receiver>

        <!-- Widget – 2H -->
        <receiver
            android:name=".Meditation2HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_2h_info" />
        </receiver>

        <!-- Widget – 2.5H -->
        <receiver
            android:name=".Meditation2_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_2_5h_info" />
        </receiver>

        <!-- Widget – 3H -->
        <receiver
            android:name=".Meditation3HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_3h_info" />
        </receiver>

        <!-- Widget – 3.5H -->
        <receiver
            android:name=".Meditation3_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_3_5h_info" />
        </receiver>

        <!-- Widget – 4H -->
        <receiver
            android:name=".Meditation4HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_4h_info" />
        </receiver>

        <!-- Widget – End At -->
        <receiver
            android:name=".MeditationEndAtWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_endat_info" />
        </receiver>

        <!-- Widget – Unlimited -->
        <receiver
            android:name=".MeditationUnlimitedWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_unlimited_info" />
        </receiver>

        <!-- Alarm receiver for timers (wakes device from doze) -->
        <receiver
            android:name=".AlarmReceiver"
            android:exported="false"
            android:enabled="true" />

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    <!-- Required to query activities that can process text, see:
         https://developer.android.com/training/package-visibility and
         https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

         In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>


---

// src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java

package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new xyz.luan.audioplayers.AudioplayersPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin audioplayers_android, xyz.luan.audioplayers.AudioplayersPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin device_info_plus, dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin flutter_local_notifications, com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new es.antonborri.home_widget.HomeWidgetPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin home_widget, es.antonborri.home_widget.HomeWidgetPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.github.dart_lang.jni.JniPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin jni, com.github.dart_lang.jni.JniPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.github.dart_lang.jni_flutter.JniFlutterPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin jni_flutter, com.github.dart_lang.jni_flutter.JniFlutterPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin package_info_plus, dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin shared_preferences_android, io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin sqflite_android, com.tekartik.sqflite.SqflitePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.benjaminabel.vibration.VibrationPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin vibration, com.benjaminabel.vibration.VibrationPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin wakelock_plus, dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin", e);
    }
  }
}


---

// src/main/kotlin/org/tipitakapali/ekatimer/AlarmSchedulerPlugin.kt

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
import androidx.core.app.NotificationCompat

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
                                setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                                    AlarmReceiver.releaseAlarmWakeLock()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    AlarmReceiver.releaseAlarmWakeLock()
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
                                setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                                    AlarmReceiver.releaseAlarmWakeLock()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    AlarmReceiver.releaseAlarmWakeLock()
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
                    setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                        AlarmReceiver.releaseAlarmWakeLock()
                    }
                    setOnErrorListener { _, what, extra ->
                        Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                        releaseMediaPlayer()
                        AlarmReceiver.releaseAlarmWakeLock()
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
        private const val ALARM_NOTIFICATION_CHANNEL = "alarm_channel"
        private var notificationChannelCreated = false

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

        /**
         * Show a full-screen intent notification to wake the screen and launch
         * the app. This is the proper Android 10+ approach for alarm-type events
         * — the system handles screen wake and activity launch reliably, unlike
         * startActivity() from a BroadcastReceiver which is blocked on API 29+.
         *
         * Requires USE_FULL_SCREEN_INTENT permission (declared in manifest).
         */
        private fun showAlarmNotification(context: Context, requestCode: Int) {
            // Create the alarm notification channel (once)
            if (!notificationChannelCreated && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    ALARM_NOTIFICATION_CHANNEL,
                    "Timer Alarms",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Alarms for meditation timer completion"
                    // We play our own sound via MediaPlayer, so silence the notification itself
                    setSound(null, null)
                    enableVibration(true)
                    enableLights(true)
                }
                val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                nm.createNotificationChannel(channel)
                notificationChannelCreated = true
                Log.d(AlarmSchedulerPlugin.TAG, "Alarm notification channel created")
            }

            // Build the full-screen PendingIntent that launches MainActivity
            val fullScreenIntent = context.packageManager.getLaunchIntentForPackage(
                context.packageName
            )?.apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
                putExtra("from_alarm", requestCode)
            }

            val fullScreenPendingIntent = PendingIntent.getActivity(
                context,
                requestCode,
                fullScreenIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Build and post the notification
            val notification = NotificationCompat.Builder(context, ALARM_NOTIFICATION_CHANNEL)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setFullScreenIntent(fullScreenPendingIntent, true)
                .setContentTitle("Meditation Complete")
                .setContentText("Your meditation session has ended.")
                .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
                .setAutoCancel(true)
                .setOngoing(false)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .build()

            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.notify(requestCode, notification)
            Log.d(AlarmSchedulerPlugin.TAG, "Alarm notification posted for requestCode=$requestCode")
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(AlarmSchedulerPlugin.TAG, "AlarmReceiver.onReceive: action=$action")

        // Handle the show intent from setAlarmClock (wake screen on alarm clock icon tap)
        if (action == "org.tipitakapali.ekatimer.ALARM_SHOW") {
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
            wakeLock.acquire(120000L)
            alarmWakeLock = wakeLock

            // 2. Show a full-screen notification to wake the screen and launch the app.
            //    This is the proper Android 10+ approach — replaces the unreliable
            //    SCREEN_BRIGHT wake lock + startActivity() pattern which is blocked
            //    on API 29+. The system handles screen wake and activity launch.
            showAlarmNotification(context, requestCode)

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

            // 5. Wake lock is released in playEndSound's setOnCompletionListener
            //    when the sound finishes, rather than after a fixed 2-minute timeout.
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


---

// src/main/kotlin/org/tipitakapali/ekatimer/MainActivity.kt

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

    companion object {
        private const val TAG = "MainActivity"
    }
}


---

// src/main/kotlin/org/tipitakapali/ekatimer/MeditationTimerWidget.kt

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


---

// src/main/res/drawable/launch_background.xml

<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>


---

// src/main/res/drawable/widget_bg.xml

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="?android:attr/colorBackground" />
    <corners android:radius="16dp" />
</shape>


---

// src/main/res/drawable-v21/launch_background.xml

<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="?android:colorBackground" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>


---

// src/main/res/layout/widget_preview_15m.xml

<!--
  ekaTimer – Quick-Start Widget Preview (15m)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="15m"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_1_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (1.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_1h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (1H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_2_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (2.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="2.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_2h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (2H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="2H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_30m.xml

<!--
  ekaTimer – Quick-Start Widget Preview (30m)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="30m"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_3_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (3.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="3.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_3h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (3H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="3H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_4h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (4H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="4H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_endat.xml

<!--
  ekaTimer – Quick-Start Widget Preview (End At)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="End"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_unlimited.xml

<!--
  ekaTimer – Quick-Start Widget Preview (Unlimited)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="∞"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_quickstart.xml

<!--
  ekaTimer – Quick-Start Widget Layout (1×1)
  Compact single-cell widget that shows just the timer duration label.
  Tapping opens the app and auto-starts the corresponding timer mode.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:id="@+id/widget_action_label"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/mipmap-anydpi-v26/ic_launcher.xml

<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@color/ic_launcher_background"/>
  <foreground>
      <inset
          android:drawable="@drawable/ic_launcher_foreground"
          android:inset="16%" />
  </foreground>
</adaptive-icon>


---

// src/main/res/values/colors.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>

---

// src/main/res/values/styles.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             the Flutter engine draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>


---

// src/main/res/values/widget_strings.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="widget_desc_15m">15 minutes meditation</string>
    <string name="widget_desc_30m">30 minutes meditation</string>
    <string name="widget_desc_1h">1 hour meditation</string>
    <string name="widget_desc_1_5h">1.5 hours meditation</string>
    <string name="widget_desc_2h">2 hours meditation</string>
    <string name="widget_desc_2_5h">2.5 hours meditation</string>
    <string name="widget_desc_3h">3 hours meditation</string>
    <string name="widget_desc_3_5h">3.5 hours meditation</string>
    <string name="widget_desc_4h">4 hours meditation</string>
    <string name="widget_desc_endat">End time meditation</string>
    <string name="widget_desc_unlimited">Unlimited meditation</string>
</resources>


---

// src/main/res/values-night/styles.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is on -->
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             the Flutter engine draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>


---

// src/main/res/xml/widget_15m_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_15m"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_15m"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_1_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_1_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_1_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_1h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_1h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_1h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_2_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_2_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_2_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_2h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_2h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_2h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_30m_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_30m"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_30m"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_3_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_3_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_3_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_3h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_3h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_3h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_4h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_4h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_4h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_endat_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_endat"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_endat"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_unlimited_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_unlimited"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_unlimited"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/profile/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>


---


---

// app/src/debug/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>


---

// app/src/main/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />

    <application
        android:label="ekaTimer"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- Widget – 15m -->
        <receiver
            android:name=".Meditation15mWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_15m_info" />
        </receiver>

        <!-- Widget – 30m -->
        <receiver
            android:name=".Meditation30mWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_30m_info" />
        </receiver>

        <!-- Widget – 1H -->
        <receiver
            android:name=".Meditation1HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_1h_info" />
        </receiver>

        <!-- Widget – 1.5H -->
        <receiver
            android:name=".Meditation1_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_1_5h_info" />
        </receiver>

        <!-- Widget – 2H -->
        <receiver
            android:name=".Meditation2HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_2h_info" />
        </receiver>

        <!-- Widget – 2.5H -->
        <receiver
            android:name=".Meditation2_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_2_5h_info" />
        </receiver>

        <!-- Widget – 3H -->
        <receiver
            android:name=".Meditation3HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_3h_info" />
        </receiver>

        <!-- Widget – 3.5H -->
        <receiver
            android:name=".Meditation3_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_3_5h_info" />
        </receiver>

        <!-- Widget – 4H -->
        <receiver
            android:name=".Meditation4HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_4h_info" />
        </receiver>

        <!-- Widget – End At -->
        <receiver
            android:name=".MeditationEndAtWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_endat_info" />
        </receiver>

        <!-- Widget – Unlimited -->
        <receiver
            android:name=".MeditationUnlimitedWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_unlimited_info" />
        </receiver>

        <!-- Alarm receiver for timers (wakes device from doze) -->
        <receiver
            android:name=".AlarmReceiver"
            android:exported="false"
            android:enabled="true" />

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    <!-- Required to query activities that can process text, see:
         https://developer.android.com/training/package-visibility and
         https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

         In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>


---

// app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java

package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new xyz.luan.audioplayers.AudioplayersPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin audioplayers_android, xyz.luan.audioplayers.AudioplayersPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin device_info_plus, dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin flutter_local_notifications, com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new es.antonborri.home_widget.HomeWidgetPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin home_widget, es.antonborri.home_widget.HomeWidgetPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.github.dart_lang.jni.JniPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin jni, com.github.dart_lang.jni.JniPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.github.dart_lang.jni_flutter.JniFlutterPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin jni_flutter, com.github.dart_lang.jni_flutter.JniFlutterPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin package_info_plus, dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin shared_preferences_android, io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin sqflite_android, com.tekartik.sqflite.SqflitePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.benjaminabel.vibration.VibrationPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin vibration, com.benjaminabel.vibration.VibrationPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin wakelock_plus, dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin", e);
    }
  }
}


---

// app/src/main/kotlin/org/tipitakapali/ekatimer/AlarmSchedulerPlugin.kt

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
import androidx.core.app.NotificationCompat

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
                        //
                        // NOTE: $soundPath is "assets/sounds/X.wav" (from _nativeSoundPath).
                        // Flutter places assets at flutter_assets/sounds/X.wav, NOT
                        // flutter_assets/assets/sounds/X.wav, so we must strip the "assets/" prefix.
                        try {
                            val relativePath = soundPath.removePrefix("assets/")
                            val assetPath = "flutter_assets/$relativePath"
                            val afd = context.assets.openFd(assetPath)
                            mediaPlayer = MediaPlayer().apply {
                                setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                                    AlarmReceiver.releaseAlarmWakeLock()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    AlarmReceiver.releaseAlarmWakeLock()
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
                                setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                                    AlarmReceiver.releaseAlarmWakeLock()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    AlarmReceiver.releaseAlarmWakeLock()
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
                    setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                        AlarmReceiver.releaseAlarmWakeLock()
                    }
                    setOnErrorListener { _, what, extra ->
                        Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                        releaseMediaPlayer()
                        AlarmReceiver.releaseAlarmWakeLock()
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
        private const val ALARM_NOTIFICATION_CHANNEL = "alarm_channel"
        private var notificationChannelCreated = false

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

        /**
         * Show a full-screen intent notification to wake the screen and launch
         * the app. This is the proper Android 10+ approach for alarm-type events
         * — the system handles screen wake and activity launch reliably, unlike
         * startActivity() from a BroadcastReceiver which is blocked on API 29+.
         *
         * Requires USE_FULL_SCREEN_INTENT permission (declared in manifest).
         */
        private fun showAlarmNotification(context: Context, requestCode: Int) {
            // Create the alarm notification channel (once)
            if (!notificationChannelCreated && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    ALARM_NOTIFICATION_CHANNEL,
                    "Timer Alarms",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Alarms for meditation timer completion"
                    // We play our own sound via MediaPlayer, so silence the notification itself
                    setSound(null, null)
                    enableVibration(true)
                    enableLights(true)
                }
                val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                nm.createNotificationChannel(channel)
                notificationChannelCreated = true
                Log.d(AlarmSchedulerPlugin.TAG, "Alarm notification channel created")
            }

            // Build the full-screen PendingIntent that launches MainActivity
            val fullScreenIntent = context.packageManager.getLaunchIntentForPackage(
                context.packageName
            )?.apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
                putExtra("from_alarm", requestCode)
            }

            val fullScreenPendingIntent = PendingIntent.getActivity(
                context,
                requestCode,
                fullScreenIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Build and post the notification
            val notification = NotificationCompat.Builder(context, ALARM_NOTIFICATION_CHANNEL)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setFullScreenIntent(fullScreenPendingIntent, true)
                .setContentTitle("Meditation Complete")
                .setContentText("Your meditation session has ended.")
                .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
                .setAutoCancel(true)
                .setOngoing(false)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .build()

            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.notify(requestCode, notification)
            Log.d(AlarmSchedulerPlugin.TAG, "Alarm notification posted for requestCode=$requestCode")
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(AlarmSchedulerPlugin.TAG, "AlarmReceiver.onReceive: action=$action")

        // Handle the show intent from setAlarmClock (wake screen on alarm clock icon tap)
        if (action == "org.tipitakapali.ekatimer.ALARM_SHOW") {
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
            wakeLock.acquire(120000L)
            alarmWakeLock = wakeLock

            // 2. Show a full-screen notification to wake the screen and launch the app.
            //    This is the proper Android 10+ approach — replaces the unreliable
            //    SCREEN_BRIGHT wake lock + startActivity() pattern which is blocked
            //    on API 29+. The system handles screen wake and activity launch.
            showAlarmNotification(context, requestCode)

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

            // 5. Wake lock is released in playEndSound's setOnCompletionListener
            //    when the sound finishes, rather than after a fixed 2-minute timeout.
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


---

// app/src/main/kotlin/org/tipitakapali/ekatimer/MainActivity.kt

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


---

// app/src/main/kotlin/org/tipitakapali/ekatimer/MeditationTimerWidget.kt

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


---

// app/src/main/res/drawable/launch_background.xml

<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>


---

// app/src/main/res/drawable/widget_bg.xml

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="?android:attr/colorBackground" />
    <corners android:radius="16dp" />
</shape>


---

// app/src/main/res/drawable-v21/launch_background.xml

<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="?android:colorBackground" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>


---

// app/src/main/res/layout/widget_preview_15m.xml

<!--
  ekaTimer – Quick-Start Widget Preview (15m)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="15m"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_1_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (1.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_1h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (1H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_2_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (2.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="2.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_2h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (2H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="2H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_30m.xml

<!--
  ekaTimer – Quick-Start Widget Preview (30m)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="30m"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_3_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (3.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="3.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_3h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (3H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="3H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_4h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (4H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="4H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_endat.xml

<!--
  ekaTimer – Quick-Start Widget Preview (End At)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="End"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_unlimited.xml

<!--
  ekaTimer – Quick-Start Widget Preview (Unlimited)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="∞"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_quickstart.xml

<!--
  ekaTimer – Quick-Start Widget Layout (1×1)
  Compact single-cell widget that shows just the timer duration label.
  Tapping opens the app and auto-starts the corresponding timer mode.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:id="@+id/widget_action_label"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml

<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@color/ic_launcher_background"/>
  <foreground>
      <inset
          android:drawable="@drawable/ic_launcher_foreground"
          android:inset="16%" />
  </foreground>
</adaptive-icon>


---

// app/src/main/res/values/colors.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>

---

// app/src/main/res/values/styles.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             the Flutter engine draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>


---

// app/src/main/res/values/widget_strings.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="widget_desc_15m">15 minutes meditation</string>
    <string name="widget_desc_30m">30 minutes meditation</string>
    <string name="widget_desc_1h">1 hour meditation</string>
    <string name="widget_desc_1_5h">1.5 hours meditation</string>
    <string name="widget_desc_2h">2 hours meditation</string>
    <string name="widget_desc_2_5h">2.5 hours meditation</string>
    <string name="widget_desc_3h">3 hours meditation</string>
    <string name="widget_desc_3_5h">3.5 hours meditation</string>
    <string name="widget_desc_4h">4 hours meditation</string>
    <string name="widget_desc_endat">End time meditation</string>
    <string name="widget_desc_unlimited">Unlimited meditation</string>
</resources>


---

// app/src/main/res/values-night/styles.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is on -->
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             the Flutter engine draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>


---

// app/src/main/res/xml/widget_15m_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_15m"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_15m"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_1_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_1_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_1_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_1h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_1h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_1h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_2_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_2_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_2_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_2h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_2h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_2h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_30m_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_30m"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_30m"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_3_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_3_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_3_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_3h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_3h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_3h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_4h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_4h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_4h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_endat_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_endat"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_endat"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_unlimited_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_unlimited"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_unlimited"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/profile/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>


---

// build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


---

// pCode_Consolidated.md

# Consolidated Code Report

Generated from: `android`
Date: 2026-06-07T07:49:30.299Z
Total files: 55

---

// .gitignore

gradle-wrapper.jar
/.gradle
/captures/
/gradlew
/gradlew.bat
/local.properties
GeneratedPluginRegistrant.java
.cxx/

# Remember to never publicly share your keystore.
# See https://flutter.dev/to/reference-keystore
key.properties
**/*.keystore
**/*.jks


---

// .idea/.gitignore

# Default ignored files
/shelf/
/workspace.xml


---

// .idea/AndroidProjectSystem.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="AndroidProjectSystem">
    <option name="providerId" value="com.android.tools.idea.GradleProjectSystem" />
  </component>
</project>

---

// .idea/caches/deviceStreaming.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="DeviceStreaming">
    <option name="deviceSelectionList">
      <list>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="Sony" />
          <option name="codename" value="A402SO" />
          <option name="id" value="A402SO" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Sony" />
          <option name="name" value="Xperia 10 VI" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2520" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="27" />
          <option name="brand" value="DOCOMO" />
          <option name="codename" value="F01L" />
          <option name="id" value="F01L" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="FUJITSU" />
          <option name="name" value="F-01L" />
          <option name="screenDensity" value="360" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1280" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="OnePlus" />
          <option name="codename" value="OP535DL1" />
          <option name="id" value="OP535DL1" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="OnePlus" />
          <option name="name" value="Nord CE 2 Lite 5G" />
          <option name="screenDensity" value="401" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2412" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="OnePlus" />
          <option name="codename" value="OP5552L1" />
          <option name="id" value="OP5552L1" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="OnePlus" />
          <option name="name" value="10T 5G" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2412" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="OPPO" />
          <option name="codename" value="OP573DL1" />
          <option name="id" value="OP573DL1" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="OPPO" />
          <option name="name" value="A79 5G" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="OPPO" />
          <option name="codename" value="OP5759L1" />
          <option name="id" value="OP5759L1" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="OPPO" />
          <option name="name" value="A38" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1612" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="realme" />
          <option name="codename" value="RE58C2" />
          <option name="id" value="RE58C2" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="realme" />
          <option name="name" value="C53" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="30" />
          <option name="brand" value="realme" />
          <option name="codename" value="RMX3231" />
          <option name="id" value="RMX3231" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="realme" />
          <option name="name" value="RMX3231" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="SC-53C" />
          <option name="id" value="SC-53C" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A53 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="28" />
          <option name="brand" value="DOCOMO" />
          <option name="codename" value="SH-01L" />
          <option name="id" value="SH-01L" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="SHARP" />
          <option name="name" value="AQUOS sense2 SH-01L" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2160" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="Lenovo" />
          <option name="codename" value="TB330FU" />
          <option name="formFactor" value="Tablet" />
          <option name="id" value="TB330FU" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Lenovo" />
          <option name="name" value="Tab M11" />
          <option name="screenDensity" value="240" />
          <option name="screenX" value="1200" />
          <option name="screenY" value="1920" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a03su" />
          <option name="id" value="a03su" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A03s" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a05s" />
          <option name="id" value="a05s" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A05s" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a06" />
          <option name="id" value="a06" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A06" />
          <option name="screenDensity" value="300" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a13" />
          <option name="id" value="a13" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A13" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2408" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a13x" />
          <option name="id" value="a13x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A13 5G" />
          <option name="screenDensity" value="300" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a14m" />
          <option name="id" value="a14m" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A14" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2408" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a14xmsq" />
          <option name="id" value="a14xmsq" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A14 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2408" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a14xmtfn" />
          <option name="id" value="a14xmtfn" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A14 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2408" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a15" />
          <option name="id" value="a15" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A15" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a15x" />
          <option name="id" value="a15x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A15 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a15x" />
          <option name="id" value="a15x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A15 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a15xtfn" />
          <option name="id" value="a15xtfn" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A15 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a16" />
          <option name="id" value="a16" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A16" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a16x" />
          <option name="id" value="a16x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A16 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a16x" />
          <option name="id" value="a16x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A16 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a16xeea" />
          <option name="id" value="a16xeea" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A16 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="31" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a21" />
          <option name="id" value="a21" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A21" />
          <option name="screenDensity" value="300" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a26x" />
          <option name="id" value="a26x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A26 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a32" />
          <option name="id" value="a32" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A32" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a34x" />
          <option name="id" value="a34x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A34 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a35x" />
          <option name="id" value="a35x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A35 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a35x" />
          <option name="id" value="a35x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A35 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a35x" />
          <option name="id" value="a35x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A35 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a36xq" />
          <option name="id" value="a36xq" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A36 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a36xq" />
          <option name="id" value="a36xq" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A36 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="a56x" />
          <option name="id" value="a56x" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy A56 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="google" />
          <option name="codename" value="akita" />
          <option name="id" value="akita" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 8a" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="google" />
          <option name="codename" value="akita" />
          <option name="id" value="akita" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 8a" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="motorola" />
          <option name="codename" value="arcfox" />
          <option name="id" value="arcfox" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="razr plus 2024" />
          <option name="screenDensity" value="360" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="1272" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="30" />
          <option name="brand" value="motorola" />
          <option name="codename" value="aruba" />
          <option name="id" value="aruba" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto e20" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="motorola" />
          <option name="codename" value="austin" />
          <option name="id" value="austin" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g 5G (2022)" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="b0q" />
          <option name="id" value="b0q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S22 Ultra" />
          <option name="screenDensity" value="600" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3088" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="b0q" />
          <option name="id" value="b0q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S22 Ultra" />
          <option name="screenDensity" value="600" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3088" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="b5qsqw" />
          <option name="id" value="b5qsqw" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Z Flip5" />
          <option name="screenDensity" value="340" />
          <option name="screenX" value="748" />
          <option name="screenY" value="720" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="b6q" />
          <option name="id" value="b6q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Z Flip6" />
          <option name="screenDensity" value="340" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2640" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="b6qsqw" />
          <option name="id" value="b6qsqw" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Z Flip6" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2640" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="blazer" />
          <option name="default" value="true" />
          <option name="id" value="blazer" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 10 Pro" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2410" />
          <option name="tags">
            <list>
              <option value="dda-default" />
            </list>
          </option>
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="32" />
          <option name="brand" value="google" />
          <option name="codename" value="bluejay" />
          <option name="id" value="bluejay" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 6a" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="c1q" />
          <option name="id" value="c1q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Note20 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="c1qksw" />
          <option name="id" value="c1qksw" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Note20 5G" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="c2q" />
          <option name="id" value="c2q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Note20 Ultra 5G" />
          <option name="screenDensity" value="560" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3088" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="google" />
          <option name="codename" value="caiman" />
          <option name="id" value="caiman" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9 Pro" />
          <option name="screenDensity" value="360" />
          <option name="screenX" value="960" />
          <option name="screenY" value="2142" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="google" />
          <option name="codename" value="caiman" />
          <option name="id" value="caiman" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9 Pro" />
          <option name="screenDensity" value="360" />
          <option name="screenX" value="960" />
          <option name="screenY" value="2142" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="google" />
          <option name="codename" value="comet" />
          <option name="id" value="comet" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9 Pro Fold" />
          <option name="screenDensity" value="390" />
          <option name="screenX" value="2076" />
          <option name="screenY" value="2152" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="google" />
          <option name="codename" value="comet" />
          <option name="id" value="comet" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9 Pro Fold" />
          <option name="screenDensity" value="390" />
          <option name="screenX" value="2076" />
          <option name="screenY" value="2152" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="comet" />
          <option name="id" value="comet" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9 Pro Fold" />
          <option name="screenDensity" value="390" />
          <option name="screenX" value="2076" />
          <option name="screenY" value="2152" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="motorola" />
          <option name="codename" value="cuscoi" />
          <option name="id" value="cuscoi" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g96 5G" />
          <option name="screenDensity" value="400" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="dm1q" />
          <option name="id" value="dm1q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S23" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="dm1q-SM-S911U" />
          <option name="id" value="dm1q-SM-S911U" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S23" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="dm1qcsx" />
          <option name="id" value="dm1qcsx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S23" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="dm2q" />
          <option name="id" value="dm2q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S23+" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="dm3q" />
          <option name="id" value="dm3q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S23 Ultra" />
          <option name="screenDensity" value="600" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3088" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="motorola" />
          <option name="codename" value="dubai" />
          <option name="id" value="dubai" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="edge 30" />
          <option name="screenDensity" value="405" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e1q" />
          <option name="id" value="e1q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e1q" />
          <option name="id" value="e1q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e1s" />
          <option name="id" value="e1s" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e2q" />
          <option name="id" value="e2q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24+" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e2s" />
          <option name="id" value="e2s" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24+" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e3q" />
          <option name="id" value="e3q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24 Ultra" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3120" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e3q" />
          <option name="id" value="e3q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24 Ultra" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3120" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e3qcsx" />
          <option name="id" value="e3qcsx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24 Ultra" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3120" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="e3qksx" />
          <option name="id" value="e3qksx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S24 Ultra" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3120" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="google" />
          <option name="codename" value="eos" />
          <option name="id" value="eos" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Eos" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="384" />
          <option name="screenY" value="384" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="google" />
          <option name="codename" value="felix" />
          <option name="id" value="felix" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel Fold" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="2208" />
          <option name="screenY" value="1840" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="google" />
          <option name="codename" value="felix" />
          <option name="id" value="felix" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel Fold" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="2208" />
          <option name="screenY" value="1840" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="felix" />
          <option name="id" value="felix" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel Fold" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="2208" />
          <option name="screenY" value="1840" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="google" />
          <option name="codename" value="felix_camera" />
          <option name="id" value="felix_camera" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel Fold (Camera-enabled)" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="2208" />
          <option name="screenY" value="1840" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="motorola" />
          <option name="codename" value="fogona" />
          <option name="id" value="fogona" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g play - 2024" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="motorola" />
          <option name="codename" value="fogorow" />
          <option name="id" value="fogorow" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g24" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1612" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="motorola" />
          <option name="codename" value="fogos" />
          <option name="id" value="fogos" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g34 5G" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="motorola" />
          <option name="codename" value="fogos" />
          <option name="id" value="fogos" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g34 5G" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="frankel" />
          <option name="default" value="true" />
          <option name="id" value="frankel" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 10" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2424" />
          <option name="tags">
            <list>
              <option value="dda-default" />
            </list>
          </option>
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="g0q" />
          <option name="id" value="g0q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S22+" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="g0q" />
          <option name="id" value="g0q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S22+" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="motorola" />
          <option name="codename" value="gnevan" />
          <option name="id" value="gnevan" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g stylus (2023)" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="gta9pwifi" />
          <option name="id" value="gta9pwifi" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Tab A9+" />
          <option name="screenDensity" value="240" />
          <option name="screenX" value="1200" />
          <option name="screenY" value="1920" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="gts7lwifi" />
          <option name="id" value="gts7lwifi" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Tab S7" />
          <option name="screenDensity" value="340" />
          <option name="screenX" value="1600" />
          <option name="screenY" value="2560" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="gts7xllite" />
          <option name="id" value="gts7xllite" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Tab S7 FE 5G" />
          <option name="screenDensity" value="340" />
          <option name="screenX" value="1600" />
          <option name="screenY" value="2560" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="gts8uwifi" />
          <option name="formFactor" value="Tablet" />
          <option name="id" value="gts8uwifi" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Tab S8 Ultra" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="1848" />
          <option name="screenY" value="2960" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="gts8wifi" />
          <option name="formFactor" value="Tablet" />
          <option name="id" value="gts8wifi" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Tab S8" />
          <option name="screenDensity" value="274" />
          <option name="screenX" value="1600" />
          <option name="screenY" value="2560" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="gts9fe" />
          <option name="id" value="gts9fe" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Tab S9 FE 5G" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="2304" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="gts9wifi" />
          <option name="id" value="gts9wifi" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Tab S9" />
          <option name="screenDensity" value="340" />
          <option name="screenX" value="1600" />
          <option name="screenY" value="2560" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="30" />
          <option name="brand" value="motorola" />
          <option name="codename" value="guamna" />
          <option name="id" value="guamna" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g play (2021)" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="30" />
          <option name="brand" value="motorola" />
          <option name="codename" value="guamp" />
          <option name="id" value="guamp" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g(9) play" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="google" />
          <option name="codename" value="husky" />
          <option name="id" value="husky" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 8 Pro" />
          <option name="screenDensity" value="390" />
          <option name="screenX" value="1008" />
          <option name="screenY" value="2244" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="google" />
          <option name="codename" value="husky" />
          <option name="id" value="husky" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 8 Pro" />
          <option name="screenDensity" value="390" />
          <option name="screenX" value="1008" />
          <option name="screenY" value="2244" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="30" />
          <option name="brand" value="motorola" />
          <option name="codename" value="java" />
          <option name="id" value="java" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="G20" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="motorola" />
          <option name="codename" value="kansas" />
          <option name="id" value="kansas" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g - 2025" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1604" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="google" />
          <option name="codename" value="komodo" />
          <option name="id" value="komodo" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9 Pro XL" />
          <option name="screenDensity" value="360" />
          <option name="screenX" value="1008" />
          <option name="screenY" value="2244" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="google" />
          <option name="codename" value="komodo" />
          <option name="id" value="komodo" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9 Pro XL" />
          <option name="screenDensity" value="360" />
          <option name="screenX" value="1008" />
          <option name="screenY" value="2244" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="motorola" />
          <option name="codename" value="lamul" />
          <option name="id" value="lamul" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g05" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1604" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="motorola" />
          <option name="codename" value="lion" />
          <option name="id" value="lion" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g04" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1612" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="google" />
          <option name="codename" value="lynx" />
          <option name="id" value="lynx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 7a" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="motorola" />
          <option name="codename" value="lyriq" />
          <option name="id" value="lyriq" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="edge 40" />
          <option name="screenDensity" value="400" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="m1q" />
          <option name="id" value="m1q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S26" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="m2q" />
          <option name="id" value="m2q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S26+" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="motorola" />
          <option name="codename" value="manaus" />
          <option name="id" value="manaus" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="edge 40 neo" />
          <option name="screenDensity" value="400" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="motorola" />
          <option name="codename" value="maui" />
          <option name="id" value="maui" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Motorola" />
          <option name="name" value="moto g play - 2023" />
          <option name="screenDensity" value="280" />
          <option name="screenX" value="720" />
          <option name="screenY" value="1600" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="mustang" />
          <option name="default" value="true" />
          <option name="id" value="mustang" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 10 Pro XL" />
          <option name="screenDensity" value="390" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2404" />
          <option name="tags">
            <list>
              <option value="dda-default" />
            </list>
          </option>
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="o1q" />
          <option name="id" value="o1q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S21 5G" />
          <option name="screenDensity" value="421" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="o1q" />
          <option name="id" value="o1q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S21 5G" />
          <option name="screenDensity" value="421" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="31" />
          <option name="brand" value="google" />
          <option name="codename" value="oriole" />
          <option name="id" value="oriole" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 6" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="p3q" />
          <option name="id" value="p3q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S21 Ultra 5G" />
          <option name="screenDensity" value="600" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3200" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="p3s" />
          <option name="id" value="p3s" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S21 Ultra 5G" />
          <option name="screenDensity" value="600" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3200" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="pa2q" />
          <option name="id" value="pa2q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S25+" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="pa2qxxx" />
          <option name="id" value="pa2qxxx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S25+" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="pa3q" />
          <option name="default" value="true" />
          <option name="id" value="pa3q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S25 Ultra" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
          <option name="tags">
            <list>
              <option value="dda-default" />
            </list>
          </option>
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="pa3q" />
          <option name="default" value="true" />
          <option name="id" value="pa3q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S25 Ultra" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
          <option name="tags">
            <list>
              <option value="dda-default" />
            </list>
          </option>
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="google" />
          <option name="codename" value="panther" />
          <option name="id" value="panther" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 7" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="psq" />
          <option name="id" value="psq" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S25 Edge" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3120" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="q4qksx" />
          <option name="id" value="q4qksx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Z Fold4" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1812" />
          <option name="screenY" value="2176" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="q5q" />
          <option name="id" value="q5q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Z Fold5" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1812" />
          <option name="screenY" value="2176" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="q5qksx" />
          <option name="id" value="q5qksx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Z Fold5" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1812" />
          <option name="screenY" value="2176" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="q6q" />
          <option name="id" value="q6q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Z Fold6" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1856" />
          <option name="screenY" value="2160" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="q7mq" />
          <option name="id" value="q7mq" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy Z TriFold" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="2160" />
          <option name="screenY" value="1584" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="r0q" />
          <option name="id" value="r0q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S22" />
          <option name="screenDensity" value="425" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="r0qcsx" />
          <option name="id" value="r0qcsx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S22" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="30" />
          <option name="brand" value="google" />
          <option name="codename" value="r11" />
          <option name="formFactor" value="Wear OS" />
          <option name="id" value="r11" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel Watch" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="384" />
          <option name="screenY" value="384" />
          <option name="type" value="WEAR_OS" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="r11q" />
          <option name="id" value="r11q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S23 FE" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="r11s" />
          <option name="id" value="r11s" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S23 FE" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="r8q" />
          <option name="id" value="r8q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S20 FE 5G" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="r8qksx" />
          <option name="id" value="r8qksx" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S20 FE 5G" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="r9q" />
          <option name="id" value="r9q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S21 FE 5G" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="samsung" />
          <option name="codename" value="r9q-SM-G990U" />
          <option name="id" value="r9q-SM-G990U" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S21 FE 5G" />
          <option name="screenDensity" value="480" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="rango" />
          <option name="default" value="true" />
          <option name="id" value="rango" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 10 Pro Fold" />
          <option name="screenDensity" value="390" />
          <option name="screenX" value="2076" />
          <option name="screenY" value="2152" />
          <option name="tags">
            <list>
              <option value="dda-default" />
            </list>
          </option>
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="30" />
          <option name="brand" value="google" />
          <option name="codename" value="redfin" />
          <option name="id" value="redfin" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 5" />
          <option name="screenDensity" value="440" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2340" />
          <option name="tags">
            <list>
              <option value="default" />
            </list>
          </option>
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="google" />
          <option name="codename" value="shiba" />
          <option name="id" value="shiba" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 8" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="shiba" />
          <option name="id" value="shiba" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 8" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="t2q" />
          <option name="id" value="t2q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S21+ 5G" />
          <option name="screenDensity" value="394" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="samsung" />
          <option name="codename" value="t2q" />
          <option name="id" value="t2q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S21+ 5G" />
          <option name="screenDensity" value="394" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2400" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="google" />
          <option name="codename" value="tangorpro" />
          <option name="formFactor" value="Tablet" />
          <option name="id" value="tangorpro" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel Tablet" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="1600" />
          <option name="screenY" value="2560" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="tangorpro" />
          <option name="formFactor" value="Tablet" />
          <option name="id" value="tangorpro" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel Tablet" />
          <option name="screenDensity" value="320" />
          <option name="screenX" value="1600" />
          <option name="screenY" value="2560" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="google" />
          <option name="codename" value="tegu" />
          <option name="id" value="tegu" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9a" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2424" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="google" />
          <option name="codename" value="tokay" />
          <option name="id" value="tokay" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2424" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="35" />
          <option name="brand" value="google" />
          <option name="codename" value="tokay" />
          <option name="id" value="tokay" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2424" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="36" />
          <option name="brand" value="google" />
          <option name="codename" value="tokay" />
          <option name="id" value="tokay" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Google" />
          <option name="name" value="Pixel 9" />
          <option name="screenDensity" value="420" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2424" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="34" />
          <option name="brand" value="samsung" />
          <option name="codename" value="xcover7" />
          <option name="id" value="xcover7" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy XCover7" />
          <option name="screenDensity" value="450" />
          <option name="screenX" value="1080" />
          <option name="screenY" value="2408" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="y2q" />
          <option name="id" value="y2q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S20+ 5G" />
          <option name="screenDensity" value="600" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3200" />
        </PersistentDeviceSelectionData>
        <PersistentDeviceSelectionData>
          <option name="api" value="33" />
          <option name="brand" value="samsung" />
          <option name="codename" value="z3q" />
          <option name="id" value="z3q" />
          <option name="labId" value="google" />
          <option name="manufacturer" value="Samsung" />
          <option name="name" value="Galaxy S20 Ultra 5G" />
          <option name="screenDensity" value="560" />
          <option name="screenX" value="1440" />
          <option name="screenY" value="3200" />
        </PersistentDeviceSelectionData>
      </list>
    </option>
  </component>
</project>

---

// .idea/compiler.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="CompilerConfiguration">
    <bytecodeTargetLevel target="21" />
  </component>
</project>

---

// .idea/deploymentTargetSelector.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="deploymentTargetSelector">
    <selectionStates>
      <SelectionState runConfigName="app">
        <option name="selectionMode" value="DROPDOWN" />
        <DialogSelection />
      </SelectionState>
    </selectionStates>
  </component>
</project>

---

// .idea/deviceManager.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="DeviceTable">
    <option name="columnSorters">
      <list>
        <ColumnSorterState>
          <option name="column" value="Name" />
          <option name="order" value="ASCENDING" />
        </ColumnSorterState>
      </list>
    </option>
  </component>
</project>

---

// .idea/gradle.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="GradleMigrationSettings" migrationVersion="1" />
  <component name="GradleSettings">
    <option name="linkedExternalProjectsSettings">
      <GradleProjectSettings>
        <compositeConfiguration>
          <compositeBuild compositeDefinitionSource="SCRIPT">
            <builds>
              <build path="$USER_HOME$/development/flutter/packages/flutter_tools/gradle" name="gradle">
                <projects>
                  <project path="$USER_HOME$/development/flutter/packages/flutter_tools/gradle" />
                </projects>
              </build>
            </builds>
          </compositeBuild>
        </compositeConfiguration>
        <option name="testRunner" value="CHOOSE_PER_TEST" />
        <option name="externalProjectPath" value="$PROJECT_DIR$" />
        <option name="modules">
          <set>
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/audioplayers_android-5.2.1/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/device_info_plus-13.1.0/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/flutter_local_notifications-21.0.0/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/home_widget-0.9.2/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/jni-1.0.0/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/jni_flutter-1.0.1/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/package_info_plus-10.1.0/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/shared_preferences_android-2.4.25/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/sqflite_android-2.4.3/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/vibration-3.1.8/android" />
            <option value="$USER_HOME$/.pub-cache/hosted/pub.dev/wakelock_plus-1.6.1/android" />
            <option value="$USER_HOME$/development/flutter/packages/flutter_tools/gradle" />
            <option value="$PROJECT_DIR$" />
            <option value="$PROJECT_DIR$/app" />
          </set>
        </option>
      </GradleProjectSettings>
    </option>
  </component>
</project>

---

// .idea/kotlinc.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="KotlinJpsPluginSettings">
    <option name="externalSystemId" value="Gradle" />
    <option name="version" value="2.3.0" />
  </component>
</project>

---

// .idea/misc.xml

<project version="4">
  <component name="ExternalStorageConfigurationManager" enabled="true" />
  <component name="ProjectRootManager" version="2" languageLevel="JDK_21" project-jdk-name="jbr-21" project-jdk-type="JavaSDK" />
  <component name="ProjectType">
    <option name="id" value="Android" />
  </component>
</project>

---

// .idea/runConfigurations.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="RunConfigurationProducerService">
    <option name="ignoredProducers">
      <set>
        <option value="com.intellij.execution.junit.AbstractAllInDirectoryConfigurationProducer" />
        <option value="com.intellij.execution.junit.AllInPackageConfigurationProducer" />
        <option value="com.intellij.execution.junit.PatternConfigurationProducer" />
        <option value="com.intellij.execution.junit.TestInClassConfigurationProducer" />
        <option value="com.intellij.execution.junit.UniqueIdConfigurationProducer" />
        <option value="com.intellij.execution.junit.testDiscovery.JUnitTestDiscoveryConfigurationProducer" />
        <option value="org.jetbrains.kotlin.idea.junit.KotlinJUnitRunConfigurationProducer" />
        <option value="org.jetbrains.kotlin.idea.junit.KotlinPatternConfigurationProducer" />
      </set>
    </option>
  </component>
</project>

---

// .idea/vcs.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="VcsDirectoryMappings">
    <mapping directory="$USER_HOME$/development/flutter" vcs="Git" />
    <mapping directory="$PROJECT_DIR$/.." vcs="Git" />
  </component>
</project>

---

// .idea/workspace.xml

<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="AutoImportSettings">
    <option name="autoReloadType" value="NONE" />
  </component>
  <component name="ChangeListManager">
    <list default="true" id="1dde7821-2cf2-4394-82f8-e42c9deb9feb" name="Changes" comment="">
      <change beforePath="$USER_HOME$/development/flutter/engine/src/flutter/flutter_frontend_server/test/fixtures/.dart_tool/package_config.json" beforeDir="false" />
      <change beforePath="$USER_HOME$/development/flutter/engine/src/flutter/tools/const_finder/test/fixtures/.dart_tool/package_config.json" beforeDir="false" />
      <change beforePath="$USER_HOME$/development/flutter/pubspec.lock" beforeDir="false" afterPath="$USER_HOME$/development/flutter/pubspec.lock" afterDir="false" />
      <change beforePath="$PROJECT_DIR$/../ios/Runner.xcodeproj/project.pbxproj" beforeDir="false" afterPath="$PROJECT_DIR$/../ios/Runner.xcodeproj/project.pbxproj" afterDir="false" />
    </list>
    <option name="SHOW_DIALOG" value="false" />
    <option name="HIGHLIGHT_CONFLICTS" value="true" />
    <option name="HIGHLIGHT_NON_ACTIVE_CHANGELIST" value="false" />
    <option name="LAST_RESOLUTION" value="IGNORE" />
  </component>
  <component name="ClangdSettings">
    <option name="formatViaClangd" value="false" />
  </component>
  <component name="ExecutionTargetManager" SELECTED_TARGET="device_and_snapshot_combo_box_target[LocalEmulator::path=/Users/py/.android/avd/10.05_Tablet.avd]" />
  <component name="ExternalProjectsData">
    <projectState path="$PROJECT_DIR$">
      <ProjectState />
    </projectState>
  </component>
  <component name="Git.Settings">
    <option name="RECENT_GIT_ROOT_PATH" value="$PROJECT_DIR$/.." />
  </component>
  <component name="GradleScriptDefinitionsStorage" workingDir="$PROJECT_DIR$" gradleHome="$USER_HOME$/.gradle/wrapper/dists/gradle-9.4.1-all/eckclv9s5vi9exbmnyvpg2a3h/gradle-9.4.1" javaHome="$APPLICATION_HOME_DIR$/jbr/Contents/Home" gradleVersion="9.4.1" />
  <component name="ProjectColorInfo">{
  &quot;customColor&quot;: &quot;&quot;,
  &quot;associatedIndex&quot;: 2
}</component>
  <component name="ProjectId" id="3EkXigPU9IQSigmB3U5aBDmoKzZ" />
  <component name="ProjectViewState">
    <option name="hideEmptyMiddlePackages" value="true" />
    <option name="showLibraryContents" value="true" />
  </component>
  <component name="PropertiesComponent">{
  &quot;keyToString&quot;: {
    &quot;ModuleVcsDetector.initialDetectionPerformed&quot;: &quot;true&quot;,
    &quot;RunOnceActivity.ShowReadmeOnStart&quot;: &quot;true&quot;,
    &quot;RunOnceActivity.cidr.known.project.marker&quot;: &quot;true&quot;,
    &quot;RunOnceActivity.readMode.enableVisualFormatting&quot;: &quot;true&quot;,
    &quot;cf.first.check.clang-format&quot;: &quot;false&quot;,
    &quot;cidr.known.project.marker&quot;: &quot;true&quot;,
    &quot;git-widget-placeholder&quot;: &quot;main&quot;,
    &quot;kotlin-language-version-configured&quot;: &quot;true&quot;
  }
}</component>
  <component name="RunManager">
    <configuration name="app" type="AndroidRunConfigurationType" factoryName="Android App" activateToolWindowBeforeRun="false">
      <module name="android.app" />
      <option name="ANDROID_RUN_CONFIGURATION_SCHEMA_VERSION" value="1" />
      <option name="DEPLOY" value="true" />
      <option name="DEPLOY_APK_FROM_BUNDLE" value="false" />
      <option name="DEPLOY_AS_INSTANT" value="false" />
      <option name="ARTIFACT_NAME" value="" />
      <option name="PM_INSTALL_OPTIONS" value="" />
      <option name="ALL_USERS" value="false" />
      <option name="ALWAYS_INSTALL_WITH_PM" value="false" />
      <option name="ALLOW_ASSUME_VERIFIED" value="false" />
      <option name="CLEAR_APP_STORAGE" value="false" />
      <option name="DYNAMIC_FEATURES_DISABLED_LIST" value="" />
      <option name="ACTIVITY_EXTRA_FLAGS" value="" />
      <option name="MODE" value="default_activity" />
      <option name="RESTORE_ENABLED" value="false" />
      <option name="RESTORE_FILE" value="" />
      <option name="RESTORE_FRESH_INSTALL_ONLY" value="false" />
      <option name="CLEAR_LOGCAT" value="false" />
      <option name="SHOW_LOGCAT_AUTOMATICALLY" value="false" />
      <option name="TARGET_SELECTION_MODE" value="DEVICE_AND_SNAPSHOT_COMBO_BOX" />
      <option name="DEBUGGER_TYPE" value="Auto" />
      <Auto>
        <option name="USE_JAVA_AWARE_DEBUGGER" value="false" />
        <option name="SHOW_STATIC_VARS" value="true" />
        <option name="WORKING_DIR" value="" />
        <option name="TARGET_LOGGING_CHANNELS" value="lldb process:gdb-remote packets" />
        <option name="SHOW_OPTIMIZED_WARNING" value="true" />
        <option name="ATTACH_ON_WAIT_FOR_DEBUGGER" value="false" />
      </Auto>
      <Hybrid>
        <option name="USE_JAVA_AWARE_DEBUGGER" value="false" />
        <option name="SHOW_STATIC_VARS" value="true" />
        <option name="WORKING_DIR" value="" />
        <option name="TARGET_LOGGING_CHANNELS" value="lldb process:gdb-remote packets" />
        <option name="SHOW_OPTIMIZED_WARNING" value="true" />
        <option name="ATTACH_ON_WAIT_FOR_DEBUGGER" value="false" />
      </Hybrid>
      <Java>
        <option name="ATTACH_ON_WAIT_FOR_DEBUGGER" value="false" />
      </Java>
      <Native>
        <option name="USE_JAVA_AWARE_DEBUGGER" value="false" />
        <option name="SHOW_STATIC_VARS" value="true" />
        <option name="WORKING_DIR" value="" />
        <option name="TARGET_LOGGING_CHANNELS" value="lldb process:gdb-remote packets" />
        <option name="SHOW_OPTIMIZED_WARNING" value="true" />
        <option name="ATTACH_ON_WAIT_FOR_DEBUGGER" value="false" />
      </Native>
      <Profilers>
        <option name="ADVANCED_PROFILING_ENABLED" value="false" />
        <option name="STARTUP_PROFILING_ENABLED" value="false" />
        <option name="STARTUP_CPU_PROFILING_ENABLED" value="false" />
        <option name="STARTUP_CPU_PROFILING_CONFIGURATION_NAME" value="Java/Kotlin Method Sample (legacy)" />
        <option name="STARTUP_NATIVE_MEMORY_PROFILING_ENABLED" value="false" />
        <option name="NATIVE_MEMORY_SAMPLE_RATE_BYTES" value="2048" />
      </Profilers>
      <option name="DEEP_LINK" value="" />
      <option name="ACTIVITY" value="" />
      <option name="ACTIVITY_CLASS" value="" />
      <option name="SEARCH_ACTIVITY_IN_GLOBAL_SCOPE" value="false" />
      <option name="SKIP_ACTIVITY_VALIDATION" value="false" />
      <method v="2">
        <option name="Android.Gradle.BeforeRunTask" enabled="true" />
      </method>
    </configuration>
  </component>
  <component name="TaskManager">
    <task active="true" id="Default" summary="Default task">
      <changelist id="1dde7821-2cf2-4394-82f8-e42c9deb9feb" name="Changes" comment="" />
      <created>1780723671350</created>
      <option name="number" value="Default" />
      <option name="presentableId" value="Default" />
      <updated>1780723671350</updated>
    </task>
    <servers />
  </component>
</project>

---

// app/build.gradle.kts

import java.io.FileInputStream
import java.util.*

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties from key.properties file
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "org.tipitakapali.ekatimer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "org.tipitakapali.ekatimer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}


---

// app/pCode_Consolidated.md

# Consolidated Code Report

Generated from: `app`
Date: 2026-06-07T06:54:06.633Z
Total files: 39

---

// build.gradle.kts

import java.io.FileInputStream
import java.util.*

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties from key.properties file
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "org.tipitakapali.ekatimer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "org.tipitakapali.ekatimer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}


---

// src/debug/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>


---

// src/main/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />

    <application
        android:label="ekaTimer"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- Widget – 15m -->
        <receiver
            android:name=".Meditation15mWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_15m_info" />
        </receiver>

        <!-- Widget – 30m -->
        <receiver
            android:name=".Meditation30mWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_30m_info" />
        </receiver>

        <!-- Widget – 1H -->
        <receiver
            android:name=".Meditation1HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_1h_info" />
        </receiver>

        <!-- Widget – 1.5H -->
        <receiver
            android:name=".Meditation1_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_1_5h_info" />
        </receiver>

        <!-- Widget – 2H -->
        <receiver
            android:name=".Meditation2HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_2h_info" />
        </receiver>

        <!-- Widget – 2.5H -->
        <receiver
            android:name=".Meditation2_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_2_5h_info" />
        </receiver>

        <!-- Widget – 3H -->
        <receiver
            android:name=".Meditation3HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_3h_info" />
        </receiver>

        <!-- Widget – 3.5H -->
        <receiver
            android:name=".Meditation3_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_3_5h_info" />
        </receiver>

        <!-- Widget – 4H -->
        <receiver
            android:name=".Meditation4HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_4h_info" />
        </receiver>

        <!-- Widget – End At -->
        <receiver
            android:name=".MeditationEndAtWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_endat_info" />
        </receiver>

        <!-- Widget – Unlimited -->
        <receiver
            android:name=".MeditationUnlimitedWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_unlimited_info" />
        </receiver>

        <!-- Alarm receiver for timers (wakes device from doze) -->
        <receiver
            android:name=".AlarmReceiver"
            android:exported="false"
            android:enabled="true" />

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    <!-- Required to query activities that can process text, see:
         https://developer.android.com/training/package-visibility and
         https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

         In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>


---

// src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java

package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new xyz.luan.audioplayers.AudioplayersPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin audioplayers_android, xyz.luan.audioplayers.AudioplayersPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin device_info_plus, dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin flutter_local_notifications, com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new es.antonborri.home_widget.HomeWidgetPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin home_widget, es.antonborri.home_widget.HomeWidgetPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.github.dart_lang.jni.JniPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin jni, com.github.dart_lang.jni.JniPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.github.dart_lang.jni_flutter.JniFlutterPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin jni_flutter, com.github.dart_lang.jni_flutter.JniFlutterPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin package_info_plus, dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin shared_preferences_android, io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin sqflite_android, com.tekartik.sqflite.SqflitePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.benjaminabel.vibration.VibrationPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin vibration, com.benjaminabel.vibration.VibrationPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin wakelock_plus, dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin", e);
    }
  }
}


---

// src/main/kotlin/org/tipitakapali/ekatimer/AlarmSchedulerPlugin.kt

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
import androidx.core.app.NotificationCompat

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
                                setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                                    AlarmReceiver.releaseAlarmWakeLock()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    AlarmReceiver.releaseAlarmWakeLock()
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
                                setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                                    AlarmReceiver.releaseAlarmWakeLock()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    AlarmReceiver.releaseAlarmWakeLock()
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
                    setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                        AlarmReceiver.releaseAlarmWakeLock()
                    }
                    setOnErrorListener { _, what, extra ->
                        Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                        releaseMediaPlayer()
                        AlarmReceiver.releaseAlarmWakeLock()
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
        private const val ALARM_NOTIFICATION_CHANNEL = "alarm_channel"
        private var notificationChannelCreated = false

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

        /**
         * Show a full-screen intent notification to wake the screen and launch
         * the app. This is the proper Android 10+ approach for alarm-type events
         * — the system handles screen wake and activity launch reliably, unlike
         * startActivity() from a BroadcastReceiver which is blocked on API 29+.
         *
         * Requires USE_FULL_SCREEN_INTENT permission (declared in manifest).
         */
        private fun showAlarmNotification(context: Context, requestCode: Int) {
            // Create the alarm notification channel (once)
            if (!notificationChannelCreated && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    ALARM_NOTIFICATION_CHANNEL,
                    "Timer Alarms",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Alarms for meditation timer completion"
                    // We play our own sound via MediaPlayer, so silence the notification itself
                    setSound(null, null)
                    enableVibration(true)
                    enableLights(true)
                }
                val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                nm.createNotificationChannel(channel)
                notificationChannelCreated = true
                Log.d(AlarmSchedulerPlugin.TAG, "Alarm notification channel created")
            }

            // Build the full-screen PendingIntent that launches MainActivity
            val fullScreenIntent = context.packageManager.getLaunchIntentForPackage(
                context.packageName
            )?.apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
                putExtra("from_alarm", requestCode)
            }

            val fullScreenPendingIntent = PendingIntent.getActivity(
                context,
                requestCode,
                fullScreenIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Build and post the notification
            val notification = NotificationCompat.Builder(context, ALARM_NOTIFICATION_CHANNEL)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setFullScreenIntent(fullScreenPendingIntent, true)
                .setContentTitle("Meditation Complete")
                .setContentText("Your meditation session has ended.")
                .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
                .setAutoCancel(true)
                .setOngoing(false)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .build()

            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.notify(requestCode, notification)
            Log.d(AlarmSchedulerPlugin.TAG, "Alarm notification posted for requestCode=$requestCode")
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(AlarmSchedulerPlugin.TAG, "AlarmReceiver.onReceive: action=$action")

        // Handle the show intent from setAlarmClock (wake screen on alarm clock icon tap)
        if (action == "org.tipitakapali.ekatimer.ALARM_SHOW") {
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
            wakeLock.acquire(120000L)
            alarmWakeLock = wakeLock

            // 2. Show a full-screen notification to wake the screen and launch the app.
            //    This is the proper Android 10+ approach — replaces the unreliable
            //    SCREEN_BRIGHT wake lock + startActivity() pattern which is blocked
            //    on API 29+. The system handles screen wake and activity launch.
            showAlarmNotification(context, requestCode)

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

            // 5. Wake lock is released in playEndSound's setOnCompletionListener
            //    when the sound finishes, rather than after a fixed 2-minute timeout.
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


---

// src/main/kotlin/org/tipitakapali/ekatimer/MainActivity.kt

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

    companion object {
        private const val TAG = "MainActivity"
    }
}


---

// src/main/kotlin/org/tipitakapali/ekatimer/MeditationTimerWidget.kt

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


---

// src/main/res/drawable/launch_background.xml

<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>


---

// src/main/res/drawable/widget_bg.xml

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="?android:attr/colorBackground" />
    <corners android:radius="16dp" />
</shape>


---

// src/main/res/drawable-v21/launch_background.xml

<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="?android:colorBackground" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>


---

// src/main/res/layout/widget_preview_15m.xml

<!--
  ekaTimer – Quick-Start Widget Preview (15m)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="15m"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_1_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (1.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_1h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (1H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_2_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (2.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="2.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_2h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (2H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="2H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_30m.xml

<!--
  ekaTimer – Quick-Start Widget Preview (30m)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="30m"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_3_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (3.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="3.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_3h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (3H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="3H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_4h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (4H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="4H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_endat.xml

<!--
  ekaTimer – Quick-Start Widget Preview (End At)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="End"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_preview_unlimited.xml

<!--
  ekaTimer – Quick-Start Widget Preview (Unlimited)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="∞"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/layout/widget_quickstart.xml

<!--
  ekaTimer – Quick-Start Widget Layout (1×1)
  Compact single-cell widget that shows just the timer duration label.
  Tapping opens the app and auto-starts the corresponding timer mode.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:id="@+id/widget_action_label"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// src/main/res/mipmap-anydpi-v26/ic_launcher.xml

<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@color/ic_launcher_background"/>
  <foreground>
      <inset
          android:drawable="@drawable/ic_launcher_foreground"
          android:inset="16%" />
  </foreground>
</adaptive-icon>


---

// src/main/res/values/colors.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>

---

// src/main/res/values/styles.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             the Flutter engine draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>


---

// src/main/res/values/widget_strings.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="widget_desc_15m">15 minutes meditation</string>
    <string name="widget_desc_30m">30 minutes meditation</string>
    <string name="widget_desc_1h">1 hour meditation</string>
    <string name="widget_desc_1_5h">1.5 hours meditation</string>
    <string name="widget_desc_2h">2 hours meditation</string>
    <string name="widget_desc_2_5h">2.5 hours meditation</string>
    <string name="widget_desc_3h">3 hours meditation</string>
    <string name="widget_desc_3_5h">3.5 hours meditation</string>
    <string name="widget_desc_4h">4 hours meditation</string>
    <string name="widget_desc_endat">End time meditation</string>
    <string name="widget_desc_unlimited">Unlimited meditation</string>
</resources>


---

// src/main/res/values-night/styles.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is on -->
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             the Flutter engine draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>


---

// src/main/res/xml/widget_15m_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_15m"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_15m"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_1_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_1_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_1_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_1h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_1h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_1h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_2_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_2_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_2_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_2h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_2h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_2h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_30m_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_30m"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_30m"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_3_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_3_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_3_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_3h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_3h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_3h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_4h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_4h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_4h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_endat_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_endat"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_endat"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/main/res/xml/widget_unlimited_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_unlimited"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_unlimited"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// src/profile/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>


---


---

// app/src/debug/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>


---

// app/src/main/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />

    <application
        android:label="ekaTimer"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- Widget – 15m -->
        <receiver
            android:name=".Meditation15mWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_15m_info" />
        </receiver>

        <!-- Widget – 30m -->
        <receiver
            android:name=".Meditation30mWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_30m_info" />
        </receiver>

        <!-- Widget – 1H -->
        <receiver
            android:name=".Meditation1HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_1h_info" />
        </receiver>

        <!-- Widget – 1.5H -->
        <receiver
            android:name=".Meditation1_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_1_5h_info" />
        </receiver>

        <!-- Widget – 2H -->
        <receiver
            android:name=".Meditation2HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_2h_info" />
        </receiver>

        <!-- Widget – 2.5H -->
        <receiver
            android:name=".Meditation2_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_2_5h_info" />
        </receiver>

        <!-- Widget – 3H -->
        <receiver
            android:name=".Meditation3HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_3h_info" />
        </receiver>

        <!-- Widget – 3.5H -->
        <receiver
            android:name=".Meditation3_5HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_3_5h_info" />
        </receiver>

        <!-- Widget – 4H -->
        <receiver
            android:name=".Meditation4HWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_4h_info" />
        </receiver>

        <!-- Widget – End At -->
        <receiver
            android:name=".MeditationEndAtWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_endat_info" />
        </receiver>

        <!-- Widget – Unlimited -->
        <receiver
            android:name=".MeditationUnlimitedWidget"
            android:exported="false">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_unlimited_info" />
        </receiver>

        <!-- Alarm receiver for timers (wakes device from doze) -->
        <receiver
            android:name=".AlarmReceiver"
            android:exported="false"
            android:enabled="true" />

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    <!-- Required to query activities that can process text, see:
         https://developer.android.com/training/package-visibility and
         https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

         In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>


---

// app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java

package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new xyz.luan.audioplayers.AudioplayersPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin audioplayers_android, xyz.luan.audioplayers.AudioplayersPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin device_info_plus, dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin flutter_local_notifications, com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new es.antonborri.home_widget.HomeWidgetPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin home_widget, es.antonborri.home_widget.HomeWidgetPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.github.dart_lang.jni.JniPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin jni, com.github.dart_lang.jni.JniPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.github.dart_lang.jni_flutter.JniFlutterPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin jni_flutter, com.github.dart_lang.jni_flutter.JniFlutterPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin package_info_plus, dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin shared_preferences_android, io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin sqflite_android, com.tekartik.sqflite.SqflitePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.benjaminabel.vibration.VibrationPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin vibration, com.benjaminabel.vibration.VibrationPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin wakelock_plus, dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin", e);
    }
  }
}


---

// app/src/main/kotlin/org/tipitakapali/ekatimer/AlarmSchedulerPlugin.kt

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
import androidx.core.app.NotificationCompat

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
                                setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                                    AlarmReceiver.releaseAlarmWakeLock()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    AlarmReceiver.releaseAlarmWakeLock()
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
                                setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                                    AlarmReceiver.releaseAlarmWakeLock()
                                }
                                setOnErrorListener { _, what, extra ->
                                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                                    releaseMediaPlayer()
                                    AlarmReceiver.releaseAlarmWakeLock()
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
                    setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
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
                        AlarmReceiver.releaseAlarmWakeLock()
                    }
                    setOnErrorListener { _, what, extra ->
                        Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                        releaseMediaPlayer()
                        AlarmReceiver.releaseAlarmWakeLock()
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
        private const val ALARM_NOTIFICATION_CHANNEL = "alarm_channel"
        private var notificationChannelCreated = false

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

        /**
         * Show a full-screen intent notification to wake the screen and launch
         * the app. This is the proper Android 10+ approach for alarm-type events
         * — the system handles screen wake and activity launch reliably, unlike
         * startActivity() from a BroadcastReceiver which is blocked on API 29+.
         *
         * Requires USE_FULL_SCREEN_INTENT permission (declared in manifest).
         */
        private fun showAlarmNotification(context: Context, requestCode: Int) {
            // Create the alarm notification channel (once)
            if (!notificationChannelCreated && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    ALARM_NOTIFICATION_CHANNEL,
                    "Timer Alarms",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Alarms for meditation timer completion"
                    // We play our own sound via MediaPlayer, so silence the notification itself
                    setSound(null, null)
                    enableVibration(true)
                    enableLights(true)
                }
                val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                nm.createNotificationChannel(channel)
                notificationChannelCreated = true
                Log.d(AlarmSchedulerPlugin.TAG, "Alarm notification channel created")
            }

            // Build the full-screen PendingIntent that launches MainActivity
            val fullScreenIntent = context.packageManager.getLaunchIntentForPackage(
                context.packageName
            )?.apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
                putExtra("from_alarm", requestCode)
            }

            val fullScreenPendingIntent = PendingIntent.getActivity(
                context,
                requestCode,
                fullScreenIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Build and post the notification
            val notification = NotificationCompat.Builder(context, ALARM_NOTIFICATION_CHANNEL)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setFullScreenIntent(fullScreenPendingIntent, true)
                .setContentTitle("Meditation Complete")
                .setContentText("Your meditation session has ended.")
                .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
                .setAutoCancel(true)
                .setOngoing(false)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .build()

            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.notify(requestCode, notification)
            Log.d(AlarmSchedulerPlugin.TAG, "Alarm notification posted for requestCode=$requestCode")
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(AlarmSchedulerPlugin.TAG, "AlarmReceiver.onReceive: action=$action")

        // Handle the show intent from setAlarmClock (wake screen on alarm clock icon tap)
        if (action == "org.tipitakapali.ekatimer.ALARM_SHOW") {
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
            wakeLock.acquire(120000L)
            alarmWakeLock = wakeLock

            // 2. Show a full-screen notification to wake the screen and launch the app.
            //    This is the proper Android 10+ approach — replaces the unreliable
            //    SCREEN_BRIGHT wake lock + startActivity() pattern which is blocked
            //    on API 29+. The system handles screen wake and activity launch.
            showAlarmNotification(context, requestCode)

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

            // 5. Wake lock is released in playEndSound's setOnCompletionListener
            //    when the sound finishes, rather than after a fixed 2-minute timeout.
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


---

// app/src/main/kotlin/org/tipitakapali/ekatimer/MainActivity.kt

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


---

// app/src/main/kotlin/org/tipitakapali/ekatimer/MeditationTimerWidget.kt

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


---

// app/src/main/res/drawable/launch_background.xml

<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>


---

// app/src/main/res/drawable/widget_bg.xml

<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="?android:attr/colorBackground" />
    <corners android:radius="16dp" />
</shape>


---

// app/src/main/res/drawable-v21/launch_background.xml

<?xml version="1.0" encoding="utf-8"?>
<!-- Modify this file to customize your launch splash screen -->
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="?android:colorBackground" />

    <!-- You can insert your own image assets here -->
    <!-- <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/launch_image" />
    </item> -->
</layer-list>


---

// app/src/main/res/layout/widget_preview_15m.xml

<!--
  ekaTimer – Quick-Start Widget Preview (15m)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="15m"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_1_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (1.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_1h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (1H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_2_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (2.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="2.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_2h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (2H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="2H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_30m.xml

<!--
  ekaTimer – Quick-Start Widget Preview (30m)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="30m"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_3_5h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (3.5H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="3.5H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_3h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (3H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="3H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_4h.xml

<!--
  ekaTimer – Quick-Start Widget Preview (4H)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="4H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_endat.xml

<!--
  ekaTimer – Quick-Start Widget Preview (End At)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="End"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_preview_unlimited.xml

<!--
  ekaTimer – Quick-Start Widget Preview (Unlimited)
  Static preview layout for the widget picker.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="∞"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/layout/widget_quickstart.xml

<!--
  ekaTimer – Quick-Start Widget Layout (1×1)
  Compact single-cell widget that shows just the timer duration label.
  Tapping opens the app and auto-starts the corresponding timer mode.
-->

<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg"
    android:gravity="center">

    <TextView
        android:id="@+id/widget_action_label"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:fontFamily="sans-serif-medium"
        android:text="1H"
        android:textColor="?android:attr/textColorPrimary"
        android:textSize="24sp"
        android:textStyle="bold" />

</FrameLayout>


---

// app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml

<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@color/ic_launcher_background"/>
  <foreground>
      <inset
          android:drawable="@drawable/ic_launcher_foreground"
          android:inset="16%" />
  </foreground>
</adaptive-icon>


---

// app/src/main/res/values/colors.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>

---

// app/src/main/res/values/styles.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             the Flutter engine draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>


---

// app/src/main/res/values/widget_strings.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="widget_desc_15m">15 minutes meditation</string>
    <string name="widget_desc_30m">30 minutes meditation</string>
    <string name="widget_desc_1h">1 hour meditation</string>
    <string name="widget_desc_1_5h">1.5 hours meditation</string>
    <string name="widget_desc_2h">2 hours meditation</string>
    <string name="widget_desc_2_5h">2.5 hours meditation</string>
    <string name="widget_desc_3h">3 hours meditation</string>
    <string name="widget_desc_3_5h">3.5 hours meditation</string>
    <string name="widget_desc_4h">4 hours meditation</string>
    <string name="widget_desc_endat">End time meditation</string>
    <string name="widget_desc_unlimited">Unlimited meditation</string>
</resources>


---

// app/src/main/res/values-night/styles.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is on -->
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             the Flutter engine draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>


---

// app/src/main/res/xml/widget_15m_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_15m"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_15m"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_1_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_1_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_1_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_1h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_1h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_1h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_2_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_2_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_2_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_2h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_2h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_2h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_30m_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_30m"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_30m"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_3_5h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_3_5h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_3_5h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_3h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_3h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_3h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_4h_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_4h"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_4h"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_endat_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_endat"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_endat"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/main/res/xml/widget_unlimited_info.xml

<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/widget_desc_unlimited"
    android:initialKeyguardLayout="@layout/widget_quickstart"
    android:initialLayout="@layout/widget_quickstart"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:minResizeWidth="40dp"
    android:minResizeHeight="40dp"
    android:previewLayout="@layout/widget_preview_unlimited"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="1"
    android:targetCellHeight="1"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />


---

// app/src/profile/AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>


---

// build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


---

// settings.gradle.kts

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.2.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

include(":app")


---


---

// settings.gradle.kts

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.2.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

include(":app")


---
