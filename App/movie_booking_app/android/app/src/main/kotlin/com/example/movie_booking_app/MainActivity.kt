package com.example.movie_booking_app

import android.app.AlertDialog
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
import org.json.JSONException
import org.json.JSONObject
import vn.momo.momo_partner.AppMoMoLib

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
                            result.success("User Canceled")
                        }

                        override fun onPaymentError(zaloPayErrorCode: ZaloPayError?, zpTransToken: String?, appTransID: String?) {
                            Log.d("onPaymentError", "zaloPayErrorCode: ${zaloPayErrorCode.toString()}, zpTransToken: $zpTransToken, appTransID: $appTransID")
                            result.success("Payment failed")
                        }

                        override fun onPaymentSucceeded(transactionId: String, transToken: String, appTransID: String?) {
                            Log.d("onPaymentSucceeded", "TransactionId: $transactionId, TransToken: $transToken, appTransID: $appTransID")
                            result.success("Payment Success")
                        }
                    })
                } else {
                    result.error("INVALID_TOKEN", "zpToken is null or invalid", null)
                }
            } else {
                result.notImplemented()
            }
        }

        val momoChannel = "momo.payment"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, momoChannel).setMethodCallHandler { call, result ->
            if (call.method == "requestPayment") {
                val amount = call.argument<String>("amount")
                val fee = call.argument<String>("fee")
                val environment = call.argument<Int>("environment")
                val merchantName = call.argument<String>("merchantName")
                val merchantCode = call.argument<String>("merchantCode")
                val merchantNameLabel = call.argument<String>("merchantNameLabel")
                val description = call.argument<String>("description")
                val totalAmount = call.argument<Int>("totalAmount")
                val totalFee = call.argument<Int>("totalFee")
                val orderID = call.argument<String>("orderNumber")
                val extraData = call.argument<Map<String, Any>>("extraData")

                requestPayment(amount, fee, environment, merchantName, merchantCode, merchantNameLabel, description, totalAmount, totalFee, orderID, extraData)
                result.success("Payment requested")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun requestPayment(
        amount: String?,
        fee: String?,
        environment: Int?,
        merchantName: String?,
        merchantCode: String?,
        merchantNameLabel: String?,
        description: String?,
        totalAmount: Int?,
        totalFee: Int?,
        orderId: String?,
        extraData: Map<String, Any>?
    ) {
        AppMoMoLib.getInstance().setAction(AppMoMoLib.ACTION.PAYMENT)
        AppMoMoLib.getInstance().setActionType(AppMoMoLib.ACTION_TYPE.GET_TOKEN)
        AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.DEVELOPMENT)
        val eventValue = HashMap<String, Any>().apply {
            put("merchantname", merchantName ?: "")
            put("merchantcode", merchantCode ?: "")
            put("amount", totalAmount ?: 0)
            put("orderId", orderId ?: "")
            put("orderLabel", "Mã đơn hàng")
            put("merchantnamelabel", merchantNameLabel ?: "")
            put("fee", totalFee ?: 0)
            put("description", description ?: "")

            put("requestId", "${merchantCode ?: ""}-merchant_billId_${System.currentTimeMillis()}")
            put("partnerCode", merchantCode ?: "")

            if (extraData != null) {
                val objExtraData = JSONObject().apply {
                    for ((key, value) in extraData) {
                        try {
                            put(key, value)
                        } catch (e: JSONException) {
                            e.printStackTrace()
                        }
                    }
                }
                put("extraData", objExtraData.toString())
            } else {
                put("extraData", JSONObject().toString())
            }

            put("extra", "")
        }
        AppMoMoLib.getInstance().requestMoMoCallBack(this, eventValue)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == AppMoMoLib.getInstance().REQUEST_CODE_MOMO && resultCode == RESULT_OK) {
            data?.let {
                when (it.getIntExtra("status", -1)) {
                    0 -> {
                        val token = it.getStringExtra("data")
                        val phoneNumber = it.getStringExtra("phonenumber")
                        val env = it.getStringExtra("env") ?: "app"
                        if (token != null && token.isNotEmpty()) {
                            // TODO: send phoneNumber & token to your server side to process payment with MoMo server
                        } else {
                            // Handle token not received
                        }
                    }
                    1, 2 -> {
                        val message = it.getStringExtra("message") ?: "Thất bại"
                        // Handle token failure
                    }
                    else -> {
                        // Handle other failures
                    }
                }
            } ?: run {
                // Handle data null case
            }
        } else {
            // Handle other result codes
        }
    }
}
