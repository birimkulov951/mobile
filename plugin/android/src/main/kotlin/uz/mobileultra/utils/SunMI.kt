package uz.mobileultra.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.IBinder
import android.util.Log
import com.sunmi.peripheral.printer.*
import org.json.JSONArray

class SunMI {
    companion object {
        var hasPrinter = false
        var printerService: SunmiPrinterService? = null

        private val innerPrinterCallback = object: InnerPrinterCallback() {
            override fun onConnected(service: SunmiPrinterService?) {
                Log.d(UtilsPlugin.TAG, "SunMI.onConnected")
                printerService = service
                checkPrinterState()
            }

            override fun onDisconnected() {
                Log.d(UtilsPlugin.TAG, "SunMI.onDisconnected")
            }
        }

        private var printingCallBack = object: ICallback.Stub() {
            override fun onRunResult(isSuccess: Boolean) = Unit

            override fun onPrintResult(code: Int, msg: String?) = Unit

            override fun onReturnString(result: String?) = Unit

            override fun onRaiseException(code: Int, msg: String?) = Unit
        }

        private fun checkPrinterState() {
            printerService?.let {
                hasPrinter = try {
                    InnerPrinterManager.getInstance().hasPrinter(it)
                }
                catch (ex: InnerPrinterException) {
                    Log.e(UtilsPlugin.TAG, "SunMI: ${ex.message?:"Exception Unknown"}")
                    false
                }
            }
        }

        fun initPrinter(context: Context): Boolean {
            return InnerPrinterManager.getInstance().bindService(context, innerPrinterCallback)
        }

        private fun alignment(align: String): Int {
            return when (align) {
                "LEFT" -> 0
                "CENTER" -> 1
                else -> 2
            }
        }

        fun printJsonData(context: Context, data: String) {
            try {
                printerService?.let { printer ->
                    val bmp = BitmapFactory.decodeResource(
                        context.resources,
                        R.drawable.paynet_black
                    )

                    printer.setAlignment(1, printingCallBack)
                    printer.printBitmap(
                        Bitmap.createScaledBitmap(bmp, 312, 84, false),
                        printingCallBack
                    )
                    printer.printText("\n", printingCallBack)

                    val jsonArray = JSONArray(data)
                    for (i in 0 until jsonArray.length()) {
                        val jsonObject = jsonArray.getJSONObject(i)
                        when (jsonObject.getString("type")) {
                            "qrcode_from_link" -> {
                                printer.printQRCode(jsonObject.getString("info"), 6, 3, printingCallBack)
                            }
                            "qrcode" -> {
                                val byteArray = hexStringToByteArray(jsonObject.getString("info"))
                                val qr = BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size)
                                printer.setAlignment(1, printingCallBack)
                                printer.printBitmap(
                                    Bitmap.createScaledBitmap(qr, qr.width, qr.height, false),
                                    printingCallBack
                                )
                                printer.printText("\n", printingCallBack)
                            }
                            "data" -> {
                                printer.setAlignment(
                                    alignment(jsonObject.getString("align")),
                                     printingCallBack
                                )

                                printer.printTextWithFont(
                                    "${jsonObject.getString("info")}\n",
                                    "Tahoma",
                                    jsonObject.getInt("size").toFloat(),
                                    printingCallBack
                                )
                            }
                        }
                    }
                    printer.autoOutPaper(printingCallBack)
                }
            }
            catch (ex: Exception) {
                Log.e(UtilsPlugin.TAG, "SunMI.Printing: ${ex.message?:"Exception Unknown"}")
            }
        }

        private fun hexStringToByteArray(data: String): ByteArray {
            val array = ByteArray(data.length / 2)

            for (i in array.indices) {
                val index = i * 2
                val j = data.substring(index, index + 2).toInt(16)
                array[i] = j.toByte()
            }

            return array
        }
    }
}