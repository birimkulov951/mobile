package uz.example.app

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull

import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability
import uz.paynet.app.ui.activities.SelectionActivity

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.jmrtd.lds.icao.MRZInfo
import uz.example.app.common.IntentData
import uz.example.app.common.IntentData.METHOD_CHANNEL_NFC_ARGUMENTS_USE_NFC
import uz.example.app.common.IntentData.METHOD_CHANNEL_NFC_INVOKE_WITH
import uz.example.app.common.IntentData.SELECTION_ACTIVITY_REQUEST_CODE

import uz.example.app.utils.AppUpdateStatus

import kotlin.Exception

class MainActivity : FlutterFragmentActivity(), MethodChannel.MethodCallHandler, Application {
    private lateinit var channel: MethodChannel
    private lateinit var result: MethodChannel.Result
    private lateinit var mrzInfo: MRZInfo

    override fun onCreate() {
        super.onCreate()
        YandexMetricaPush.init(applicationContext)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.paynet.uz.mc")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "check_update" -> {
                result.success(null)
                try {
                    val appUpdManager = AppUpdateManagerFactory.create(this)
                    val appUpdInfoTask = appUpdManager.appUpdateInfo

                    appUpdInfoTask.addOnCompleteListener { res ->
                        if (res.isSuccessful) {
                            if (res.result.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE &&
                                res.result.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)
                            ) {
                                appUpdManager.startUpdateFlowForResult(
                                    res.result,
                                    AppUpdateType.IMMEDIATE,
                                    this,
                                    2201
                                )
                                channel.invokeMethod(
                                    "going_to_upd",
                                    AppUpdateStatus.UPDATE_AVAILABLE.ordinal
                                )
                            } else
                                channel.invokeMethod(
                                    "going_to_upd",
                                    AppUpdateStatus.NO_UPDATE.ordinal
                                )
                        } else
                            channel.invokeMethod("going_to_upd", AppUpdateStatus.NO_UPDATE.ordinal)
                    }
                } catch (ex: Exception) {
                    //print(ex.message ?: "null exception")
                    channel.invokeMethod("going_to_upd", AppUpdateStatus.NO_UPDATE.ordinal)
                }
            }
            METHOD_CHANNEL_NFC_INVOKE_WITH -> {
                val withNfc = call.argument<Boolean>(METHOD_CHANNEL_NFC_ARGUMENTS_USE_NFC)
                val intent = Intent(this, SelectionActivity::class.java)
                intent.putExtra(METHOD_CHANNEL_NFC_INVOKE_WITH, withNfc)
                startActivityForResult(intent, SELECTION_ACTIVITY_REQUEST_CODE)
                this.result = result
            }
            else -> result.notImplemented()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        when (requestCode) {
            2201 -> channel.invokeMethod(
                "going_to_upd",
                if (resultCode == RESULT_OK) AppUpdateStatus.UPDATING.ordinal else AppUpdateStatus.UPDATE_CANCELED.ordinal
            )
            SELECTION_ACTIVITY_REQUEST_CODE -> {
                val list = arrayListOf<Any>()
                if (resultCode == Activity.RESULT_OK) {

                    val secondaryIdentifier = data!!.getStringExtra("secondaryIdentifier")

                    if (secondaryIdentifier == null) {
                        (data.getSerializableExtra(IntentData.KEY_MRZ_INFO) as MRZInfo).also {
                            mrzInfo = it
                        }
                        list.add(mrzInfo.primaryIdentifier)
                        list.add(mrzInfo.secondaryIdentifier)
                        result.success(list)
                    }

                }
            }
            else -> super.onActivityResult(requestCode, resultCode, data)
        }
    }
}