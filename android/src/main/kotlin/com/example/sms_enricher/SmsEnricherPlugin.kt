package com.example.sms_enricher

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.net.Uri
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.io.IOException
import org.json.JSONArray
import org.json.JSONObject
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

class SmsEnricherPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, RequestPermissionsResultListener {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sms_enricher")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "requestSmsPermissions" -> requestSmsPermissions(result)
      "retrieveSmsMessages" -> {
          val senderName = call.argument<String>("targetName")
          if (senderName != null) {
              fetchSmsBySender(senderName, result)
          } else {
              result.error("INVALID_ARGUMENT", "No sender name provided", null)
          }
      }
      else -> result.notImplemented()
    }
  }


  private fun requestSmsPermissions(result: Result) {
    if (ContextCompat.checkSelfPermission(activity!!, Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED) {
      ActivityCompat.requestPermissions(activity!!, arrayOf(Manifest.permission.READ_SMS), REQUEST_SMS_PERMISSION_CODE)
      // Callback is handled in onRequestPermissionsResult
    } else {
      result.success(true) // Permission already granted
    }
  }

  private fun fetchSmsBySender(senderName: String, result: Result) {
    val smsList = ArrayList<Map<String, String>>()
    val cursor = activity?.contentResolver?.query(
        Uri.parse("content://sms/inbox"),
        arrayOf("_id", "address", "date", "body"),
        "address LIKE ?",
        arrayOf("%$senderName%"),
        "date DESC"
    )

    cursor?.use {
        val indexAddress = it.getColumnIndex("address")
        val indexBody = it.getColumnIndex("body")
        val indexDate = it.getColumnIndex("date")

        while (it.moveToNext()) {
            val smsData = HashMap<String, String>()
            smsData["address"] = it.getString(indexAddress)
            smsData["body"] = it.getString(indexBody)
            smsData["date"] = it.getString(indexDate)
            smsList.add(smsData)
        }
        result.success(smsList)
    } ?: result.error("UNAVAILABLE", "Failed to retrieve SMS", null)
  }

  // ActivityAware Methods
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  // Permission Results Handling
  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
    if (requestCode == REQUEST_SMS_PERMISSION_CODE) {
        // This is where you would handle the user's response to the permission request.
        // For simplicity, we're not implementing this logic here.
        return true
    }
    return false
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  companion object {
    const val REQUEST_SMS_PERMISSION_CODE = 101
  }
}
