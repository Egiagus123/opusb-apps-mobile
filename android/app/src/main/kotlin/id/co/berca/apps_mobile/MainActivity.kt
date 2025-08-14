package id.co.berca.apps_mobile

import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "tamper_check"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "checkSignature") {
                // Skip validasi saat debug mode
                if (BuildConfig.DEBUG) {
                    Log.d("TamperCheck", "Debug mode: skip signature validation")
                    result.success(true)
                    return@setMethodCallHandler
                }

                val actual = getSignatureHash()
                val expected = "52:03:4F:41:3A:71:6D:A7:CE:2B:32:8B:DE:B8:4D:F1:63:15:64:5E:DC:FB:CC:CE:9E:4A:3F:FB:9B:50:EB:1E"

                Log.d("TamperCheck", "Actual SHA-256: $actual")
                result.success(actual == expected)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSignatureHash(): String {
        return try {
            val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            val signatures = packageInfo.signingInfo?.apkContentsSigners

            if (signatures.isNullOrEmpty()) {
                Log.e("TamperCheck", "Signature not found")
                "INVALID_SIGNATURE"
            } else {
                val cert = signatures[0].toByteArray()
                val md = MessageDigest.getInstance("SHA-256")
                md.digest(cert).joinToString(":") { "%02X".format(it) }
            }
        } catch (e: Exception) {
            Log.e("TamperCheck", "Error fetching signature: ${e.message}")
            "INVALID_SIGNATURE"
        }
    }
}
