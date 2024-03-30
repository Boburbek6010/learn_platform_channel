package com.pdp.learn_platform_channel
import android.annotation.TargetApi
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.HashMap
import android.util.Log

class MainActivity : FlutterActivity() {
    private val methodChannel: String = "com.pdp/battery";
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannel).setMethodCallHandler { call, result ->
            if(call.method == "getBatteryLevel"){
                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            }else if(call.method == "deviceInfo"){
                val info = deviceInfo()
                if(info != null){
                  result.success(info)
                }else{
                    result.error("UNAVAILABLE", "System Details not available.", null)
                }
            } else{
                result.notImplemented()
            }
        }
    }
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }

    @TargetApi(VERSION_CODES.DONUT)
    private fun deviceInfo(): String{
        return "Brand: ${Build.BRAND} \n" +
                "Model: ${Build.MODEL} \n"+
                "MANUFACTURER: ${Build.MANUFACTURER} \n"+
                "DEVICE: ${Build.DEVICE} \n"+
                "TYPE: ${Build.TYPE} \n"+
                "ID: ${Build.ID} \n"+
                "BOARD: ${Build.BOARD} \n"+
                "FINGERPRINT: ${Build.FINGERPRINT} \n"+
                "DISPLAY: ${Build.DISPLAY} \n"+
                "HOST: ${Build.HOST} \n"+
                "TAGS: ${Build.TAGS} \n"+
                "USER: ${Build.USER} \n"+
                "PRODUCT: ${Build.PRODUCT} \n"+
                "TIME: ${Build.TIME.toString()} \n"
    }

}
