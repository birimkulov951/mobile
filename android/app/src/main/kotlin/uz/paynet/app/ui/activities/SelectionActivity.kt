package uz.paynet.app.ui.activities

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import uz.paynet.app.R
import uz.paynet.app.common.IntentData
import uz.paynet.app.common.IntentData.METHOD_CHANNEL_NFC_INVOKE_WITH
import uz.paynet.app.ui.fragments.SelectionFragment
import org.jmrtd.lds.icao.MRZInfo

class SelectionActivity : AppCompatActivity(), SelectionFragment.SelectionFragmentListener {

    private var isNfc = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_camera)
        isNfc = intent.getBooleanExtra(METHOD_CHANNEL_NFC_INVOKE_WITH, false)
        if (null == savedInstanceState) {
            supportFragmentManager.beginTransaction()
                .replace(R.id.container, SelectionFragment(), TAG_SELECTION_FRAGMENT)
                .commit()
        }
    }

    private lateinit var mrzInfo: MRZInfo


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        var resultData = data
        if (resultData == null) {
            resultData = Intent()
        }
        when (requestCode) {
            REQUEST_MRZ -> {
                when (resultCode) {
                    Activity.RESULT_OK -> {
                        mrzInfo =
                            resultData.getSerializableExtra(IntentData.KEY_MRZ_INFO) as MRZInfo
                        setResult(Activity.RESULT_OK, resultData)
                        finish()
                    }
                    Activity.RESULT_CANCELED -> {
                        finish()
                    }
                    else -> {
                        finish()
                    }
                }
            }
        }
        super.onActivityResult(requestCode, resultCode, resultData)
    }


    override fun onMrzRequest() {
        val intent = Intent(applicationContext, CameraActivity::class.java)
        startActivityForResult(intent, REQUEST_MRZ)
    }


    companion object {
        private const val REQUEST_MRZ = 12
        private const val TAG_SELECTION_FRAGMENT = "TAG_SELECTION_FRAGMENT"
    }
}
