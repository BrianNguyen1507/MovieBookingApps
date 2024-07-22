package com.example.movie_booking_app

import android.app.Activity
import android.view.WindowManager

import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import io.flutter.plugin.common.MethodChannel
import android.content.BroadcastReceiver

object BrightnessActivity {
    fun setBrightness(activity: Activity, brightness: Float) {
        val layoutParams = activity.window.attributes
        layoutParams.screenBrightness = brightness
        activity.window.attributes = layoutParams
    }

    fun resetBrightness(activity: Activity) {
        val layoutParams = activity.window.attributes
        layoutParams.screenBrightness = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
        activity.window.attributes = layoutParams
    }
}

object InternetController {
  fun checkInternetConnection(context: Context): Boolean {
      val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
          val network = connectivityManager.activeNetwork ?: return false
          val activeNetwork = connectivityManager.getNetworkCapabilities(network) ?: return false
          return when {
              activeNetwork.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> true
              activeNetwork.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> true
              activeNetwork.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> true
              else -> false
          }
      } else {
          val networkInfo = connectivityManager.activeNetworkInfo
          return networkInfo?.isConnectedOrConnecting == true
      }
  }
}

class NetworkChangeReceiver(private val channel: MethodChannel) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val isConnected = InternetController.checkInternetConnection(context)
        channel.invokeMethod("networkStatusChanged", isConnected)
    }
}