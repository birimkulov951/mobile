package uz.paynet.app.mlkit

import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import android.widget.Toast
import com.google.android.gms.tasks.Task
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.common.FirebaseVisionImage
import com.google.firebase.ml.vision.text.FirebaseVisionText
import com.google.firebase.ml.vision.text.FirebaseVisionTextRecognizer
import net.sf.scuba.data.Gender
import org.jmrtd.lds.icao.MRZInfo
import java.io.IOException
import java.util.*
import java.util.regex.Pattern

open class OcrMrzDetectorProcessor(private val callback: MRZCallback, private val context: Context) : VisionProcessorBase<FirebaseVisionText>() {

    private val detector: FirebaseVisionTextRecognizer = FirebaseVision.getInstance().onDeviceTextRecognizer
    var isSuccess = false

    override fun stop() {
        try {
            detector.close()
        } catch (e: IOException) {
            Log.e(TAG, "Exception thrown while trying to close Text Detector: $e")
        }

    }

    override fun detectInImage(image: FirebaseVisionImage): Task<FirebaseVisionText> {
        return detector.processImage(image)
    }


    override fun onSuccess(
            results: FirebaseVisionText,
            frameMetadata: FrameMetadata?,
            timeRequired: Long,
            bitmap: Bitmap
    ) {

        var fullRead = ""
        val blocks = results.textBlocks
        for (i in blocks.indices) {
            var temp = ""
            val lines = blocks[i].lines
            for (j in lines.indices) {
                temp += lines[j].text + "-"
            }
            temp = temp.replace("\r".toRegex(), "").replace(regex = "\n".toRegex(), replacement = "").replace("\t".toRegex(), "").replace(" ", "")
            fullRead += "$temp-"
        }
        fullRead = fullRead.toUpperCase(Locale.ROOT)
        Log.d(TAG, "Read: $fullRead")

        val patternLineSecond = Pattern.compile(SECOND_LINE)
        val matcherLineSecond = patternLineSecond.matcher(fullRead)
        val patternLineFirst = Pattern.compile(FIRST_LINE)
        val matcherLineFirst = patternLineFirst.matcher(fullRead)
        val patternLineOldPassportType = Pattern.compile(REGEX_OLD_PASSPORT)

        if (matcherLineSecond.find()) {
            Log.d("TTT1", matcherLineSecond.group(0))
            //Old passport format
            val line2 = matcherLineSecond.group(0)
            var documentNumber = matcherLineSecond.group(1)
            val dateOfBirthDay = cleanDate(matcherLineSecond.group(4))
            val expirationDate = cleanDate(matcherLineSecond.group(7))
            //As O and 0 and really similar most of the countries just removed them from the passport, so for accuracy I am formatting it
            documentNumber = documentNumber.replace("O".toRegex(), "0")

            if (matcherLineFirst.find()) {
                Log.d("TTT2", matcherLineFirst.group(0))
                if (!matcherLineFirst.group(0).startsWith("P<")) {
                    Log.d("TTT22", "Ошибка чтения, происходит перечитывание")
                    callback.onRecreate(true)
                    Toast.makeText(context, "Ошибка чтения, происходит перечитывание", Toast.LENGTH_SHORT).show()
                } else {
                    val lineOne = matcherLineFirst.group(0)
                    val lineTwo = matcherLineSecond.group(0)

                    val mrzInfo = createDummyMrz(documentNumber, dateOfBirthDay, expirationDate, lineOne, lineTwo)
                    isSuccess = true
                    callback.onMRZRead(mrzInfo, timeRequired)
                }
            } else {
                Log.d("TTT3", "Перечитывание продолжается")
                callback.onRecreate(true)
                Toast.makeText(context, "Перечитывание продолжается", Toast.LENGTH_SHORT).show()
            }
        } else {
            val patternLineIPassportTypeLine1 = Pattern.compile(REGEX_IP_PASSPORT_LINE_1)
            val matcherLineIPassportTypeLine1 = patternLineIPassportTypeLine1.matcher(fullRead)
            val patternLineIPassportTypeLine2 = Pattern.compile(REGEX_IP_PASSPORT_LINE_2)
            val matcherLineIPassportTypeLine2 = patternLineIPassportTypeLine2.matcher(fullRead)
            if (matcherLineIPassportTypeLine1.find() && matcherLineIPassportTypeLine2.find()) {
                val line1 = matcherLineIPassportTypeLine1.group(0)
                val line2 = matcherLineIPassportTypeLine2.group(0)
                var documentNumber = line1.substring(5, 14)
                val dateOfBirthDay = line2.substring(0, 6)
                val expirationDate = line2.substring(8, 14)
                documentNumber = documentNumber.replace("O".toRegex(), "0")

                val mrzInfo = createDummyMrz(documentNumber, dateOfBirthDay, expirationDate, "", "")
                callback.onMRZRead(mrzInfo, timeRequired)
            } else {
                callback.onMRZReadFailure(timeRequired)
            }
        }


    }

    private fun createDummyMrz(documentNumber: String, dateOfBirthDay: String, expirationDate: String, lineOne: String, lineTwo: String): MRZInfo {
        return MRZInfo(
                "P",
                "ESP",
                lineOne,
                lineTwo,
                documentNumber,
                "ESP",
                dateOfBirthDay,
                Gender.MALE,
                expirationDate,
                ""
        )
    }

    private fun cleanDate(date: String): String {
        var tempDate = date
        tempDate = tempDate.replace("I".toRegex(), "1")
        tempDate = tempDate.replace("L".toRegex(), "1")
        tempDate = tempDate.replace("D".toRegex(), "0")
        tempDate = tempDate.replace("O".toRegex(), "0")
        tempDate = tempDate.replace("S".toRegex(), "5")
        tempDate = tempDate.replace("G".toRegex(), "6")
        return tempDate
    }

    override fun onFailure(e: Exception, timeRequired: Long) {
        Log.w(TAG, "Text detection failed.$e")
        callback.onFailure(e, timeRequired)
    }

    interface MRZCallback {
        fun onMRZRead(mrzInfo: MRZInfo, timeRequired: Long)
        fun onMRZReadFailure(timeRequired: Long)
        fun onFailure(e: Exception, timeRequired: Long)
        fun onRecreate(b: Boolean)
    }

    companion object {

        private val TAG = OcrMrzDetectorProcessor::class.java.simpleName
        private val REGEX_OLD_PASSPORT = "(?<documentNumber>[A-Z0-9<]{9})(?<checkDigitDocumentNumber>[0-9ILDSOG]{1})(?<nationality>[A-Z<]{3})(?<dateOfBirth>[0-9ILDSOG]{6})(?<checkDigitDateOfBirth>[0-9ILDSOG]{1})(?<sex>[FM<]){1}(?<expirationDate>[0-9ILDSOG]{6})(?<checkDigitExpiration>[0-9ILDSOG]{1})"
        private val SECOND_LINE = "(?<documentNumber>[A-Z0-9<]{9})(?<checkDigitDocumentNumber>[0-9]{1})(?<nationality>[A-Z<]{3})(?<dateOfBirth>[0-9]{6})(?<checkDigitDateOfBirth>[0-9]{1})(?<sex>[FM<]){1}(?<expirationDate>[0-9]{6})(?<checkDigitExpiration>[0-9]{1})(?<g>[0-9]{14})(?<trash>[0-9]{2})"
        private val FIRST_LINE = "(?<trash>[A-Z<]{5})(?<fullName>[A-Z<]{39})"
        private val REGEX_IP_PASSPORT_LINE_1 = "\\bIP[A-Z<]{3}[A-Z0-9<]{9}[0-9]{1}"
        private val REGEX_IP_PASSPORT_LINE_2 = "[0-9]{6}[0-9]{1}[FM<]{1}[0-9]{6}[0-9]{1}[A-Z<]{3}"
    }
}
