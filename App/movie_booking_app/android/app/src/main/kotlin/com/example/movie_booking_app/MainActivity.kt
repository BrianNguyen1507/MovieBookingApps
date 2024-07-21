package com.example.movie_booking_app

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import vn.zalopay.sdk.Environment
import vn.zalopay.sdk.ZaloPayError
import vn.zalopay.sdk.ZaloPaySDK
import vn.zalopay.sdk.listeners.PayOrderListener

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ZaloPaySDK.init(2554, Environment.SANDBOX)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("newIntent", intent.toString())
        ZaloPaySDK.getInstance().onResult(intent)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channelPayOrder = "flutter.native/channelPayOrder"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelPayOrder).setMethodCallHandler { call, result ->
            if (call.method == "payOrder") {
                val token = call.argument<String>("zptoken")
                if (token != null) {
                    ZaloPaySDK.getInstance().payOrder(this@MainActivity, token, "demozpdk://app", object : PayOrderListener {
                        override fun onPaymentCanceled(zpTransToken: String?, appTransID: String?) {
                            Log.d("onPaymentCancel", "TransactionId: $zpTransToken, appTransID: $appTransID")
                            result.success(mapOf("result" to "User Canceled", "appTransID" to appTransID))
                        }

                        override fun onPaymentError(zaloPayErrorCode: ZaloPayError?, zpTransToken: String?, appTransID: String?) {
                            Log.d("onPaymentError", "zaloPayErrorCode: ${zaloPayErrorCode.toString()}, zpTransToken: $zpTransToken, appTransID: $appTransID")
                            result.success(mapOf("result" to "Payment failed", "appTransID" to appTransID))
                        }

                        override fun onPaymentSucceeded(transactionId: String, transToken: String, appTransID: String?) {
                            Log.d("onPaymentSucceeded", "TransactionId: $transactionId, TransToken: $transToken, appTransID: $appTransID")
                            result.success(mapOf("result" to "Payment Success", "appTransID" to transactionId))
                        }
                    })
                } else {
                    result.error("INVALID_TOKEN", "zpToken is null or invalid", null)
                }
            } else {
                result.notImplemented()
            }
        }

        val channelBrightness = "flutter.native/IncreaseBrightness"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelBrightness).setMethodCallHandler { call, result ->
            when (call.method) {
                "setMaxBrightness" -> {
                    BrightnessActivity.setBrightness(this@MainActivity, 1.0f)
                    result.success(null)
                }
                "resetBrightness" -> {
                    BrightnessActivity.resetBrightness(this@MainActivity)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
