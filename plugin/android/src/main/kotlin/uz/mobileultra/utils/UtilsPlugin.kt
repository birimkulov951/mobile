package uz.mobileultra.utils

import android.app.Activity
import android.content.ContentUris
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.provider.ContactsContract
import android.util.Log
import androidx.annotation.NonNull
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import java.io.ByteArrayOutputStream
import java.io.IOException

class Contact(
    val name: String = "",
    val phone: String = "",
    val avatar: ByteArray = ByteArray(0)
) {
    fun toMap(): HashMap<String, Any> {
        val map = HashMap<String, Any>()

        map["name"] = name
        map["phone"] = phone
        map["photo"] = avatar

        return map
    }
}

/** UtilsPlugin */
class UtilsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "mobileultra.utils")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromActivity() = Unit

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = Unit

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        initWithContext()
    }

    override fun onDetachedFromActivityForConfigChanges() = Unit

    fun initWithContext() {
        SunMI.initPrinter(activity)
    }

    companion object {
        const val TAG = "UtilsPlugin"
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "mobileultra.utils")
            val plugin = UtilsPlugin()
            plugin.activity = registrar.activity()!!
            plugin.initWithContext()
            channel.setMethodCallHandler(plugin)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getContactList" -> {
                val avatars = HashMap<String, ByteArray>()
                val contactList = ArrayList<HashMap<String, Any>>()
                val phoneList = ArrayList<String>()

                //Log.d("paynet.log", "prefix: ${call.arguments?:""}")
                activity.apply {
                    val contentResolver = this.contentResolver

                    val phones = contentResolver.query(
                        ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                        null,
                        null,//"${ContactsContract.CommonDataKinds.Phone.NUMBER} LIKE ? OR ${ContactsContract.CommonDataKinds.Phone.NUMBER} LIKE ?",
                        null,/*arrayOf(
                        "+998_${call.arguments?:""}%",
                        "${call.arguments?:""}%"
                    ),*/
                        ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME
                    )

                    if (phones != null && phones.moveToFirst()) {
                        do {
                            try {
                                val photo = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI))?:""
                                val name = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME))?:""
                                var phone = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER))
                                        .replace(" ", "").replace("-", "").replace("+", "")

                                //Log.d("paynet.log", "$name $phone")

                                if (phone.length == 9)
                                    phone = "998$phone"

                                if (phone.length < 9 || !phone.startsWith("998"))
                                    continue

                                if ((call.arguments != null && phone.startsWith("998${call.arguments}")) || (call.arguments == null && phone.startsWith("998")))
                                {
                                    var avatar = ByteArray(0)

                                    if (avatars.containsKey(name))
                                        avatar = avatars[name] ?: ByteArray(0)
                                    else {
                                        if (photo.isNotEmpty()) {
                                            try {
                                                val uri = ContentUris.withAppendedId(
                                                    ContactsContract.Contacts.CONTENT_URI,
                                                    phones.getLong(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID))
                                                )

                                                val input = ContactsContract.Contacts.openContactPhotoInputStream(contentResolver, uri, false)

                                                if (input != null) {
                                                    val bmp = BitmapFactory.decodeStream(input)
                                                    input.close()

                                                    val stream: ByteArrayOutputStream = ByteArrayOutputStream()
                                                    bmp.compress(Bitmap.CompressFormat.PNG, 100, stream)

                                                    avatar = stream.toByteArray()
                                                    avatars[name] = avatar

                                                    stream.close()
                                                }

                                            }
                                            catch (except: IOException) {
                                                except.printStackTrace()
                                            }
                                        }
                                    }

                                    phoneList.add("+$phone")

                                    contactList.add(toMap(
                                        name = name,
                                        phone = phoneList.last(),
                                        avatar = avatar
                                    ))
                                }
                            }
                            catch (ex: Exception) {
                                Log.d("paynet.log", "get contact exception")
                            }
                        }
                        while (phones.moveToNext())
                    }

                    phones?.close()
                    avatars.clear()

                    //Log.d("paynet.log", "telegram_____________________________")

                    val telegramPhones = contentResolver.query(
                        ContactsContract.Data.CONTENT_URI,
                        arrayOf(
                            ContactsContract.Data.DATA1,
                            ContactsContract.Data.DATA3,
                            ContactsContract.Data.DISPLAY_NAME
                        ),
                        "${ContactsContract.Data.MIMETYPE} = 'vnd.android.cursor.item/vnd.org.telegram.messenger.android.profile'",
                        null,
                        null
                    )

                    if (telegramPhones != null && telegramPhones.moveToFirst()) {
                        do {
                            try {
                                var number = telegramPhones.getString(1).replace(" ", "").replace("-", "");
                                val name = telegramPhones.getString(2)?:""

                                if (number.isEmpty() || name.isEmpty())
                                    continue

                                val plusIndex = number.indexOf("+");
                                if (plusIndex != -1)
                                    number = number.substring(plusIndex + 1, number.length)

                                //Log.d("paynet.log", "----------------------------------")
                                //Log.d("paynet.log", "${telegramPhones.getString(2)?:""}")
                                //Log.d("paynet.log", "${telegramPhones.getString(1)?:""}")
                                //Log.d("paynet.log", "${telegramPhones.getString(0)?:""}")

                                if (number.length == 9)
                                    number = "998$number"

                                if (number.length < 9 || !number.startsWith("998"))
                                    continue

                                if ((call.arguments != null && number.startsWith("998${call.arguments}")) || (call.arguments == null && number.startsWith("998")))
                                {
                                    if (!phoneList.contains("+$number")) {
                                        phoneList.add("+$number")

                                        contactList.add(toMap(
                                            name = name,
                                            phone = "+$number",
                                            avatar = ByteArray(0)
                                        ))
                                    }
                                }
                            }
                            catch (ex: Exception) {
                                Log.d("paynet.log", "get telegram contact exception")
                            }
                        }
                        while (telegramPhones.moveToNext())
                    }

                    telegramPhones?.close()
                    phoneList.clear()

                    result.success(contactList)
                }
            }
            "checkUpdate" -> {
                /*activity.apply {
                    val appId = this.packageName
                    try {
                        val uri = Uri.parse("market://details?id=$appId")
                        this.startActivity(Intent(Intent.ACTION_VIEW, uri))
                    } catch (_: ActivityNotFoundException) {
                        val uri = Uri.parse("https://play.google.com/store/apps/details?id=$appId")
                        this.startActivity(Intent(Intent.ACTION_VIEW, uri))
                    }
                }*/
                try {
                    activity.apply {
                        val appUpdateManager = AppUpdateManagerFactory.create(this)
                        val appUpdateInfoTask = appUpdateManager.appUpdateInfo
                        appUpdateInfoTask.addOnSuccessListener { appUpdateInfo ->
                            if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE &&
                                    appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                                result.success(true)
                                
                                appUpdateManager.startUpdateFlowForResult(
                                    appUpdateInfo,
                                    AppUpdateType.IMMEDIATE,
                                    this,
                                    1001
                                )
                            }
                            else
                                result.success(false)
                        }
                    }
                }
                catch (ex: Exception) {
                    ex.printStackTrace()
                    result.success(false)
                }
            }
            "sunMIPrinterState" -> {
                result.success(SunMI.hasPrinter)
            }
            "printReceipt" -> {
                when {
                    SunMI.hasPrinter -> SunMI.printJsonData(activity, data = call.arguments as String)
                }
                result.success(1)
            }
            else -> result.notImplemented()
        }
    }

    private fun toMap(name: String, phone: String, avatar: ByteArray): HashMap<String, Any> {
        val map = HashMap<String, Any>()

        map["name"] = name
        map["phone"] = phone
        map["photo"] = avatar

        return map
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) = Unit
}
