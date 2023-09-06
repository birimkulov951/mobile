package uz.example.app.ui.activities

import android.content.Intent
import android.content.res.Configuration
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import uz.paynet.app.R
import uz.paynet.app.common.IntentData
import uz.paynet.app.ui.fragments.CameraMLKitFragment
import org.jmrtd.lds.icao.MRZInfo

class CameraActivity : AppCompatActivity(), CameraMLKitFragment.CameraMLKitCallback {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_camera)
        supportFragmentManager.beginTransaction()
                .replace(R.id.container, CameraMLKitFragment())
                .commit()
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            Toast.makeText(baseContext, "Landscape Mode", Toast.LENGTH_SHORT).show()
        } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
            Toast.makeText(baseContext, "Portrait Mode", Toast.LENGTH_SHORT).show()
        }
    }

    override fun onBackPressed() {
        setResult(RESULT_CANCELED)
        finish()
    }

    override fun onPassportRead(mrzInfo: MRZInfo) {
        val intent = Intent()
        intent.putExtra(IntentData.KEY_MRZ_INFO, mrzInfo)
        setResult(RESULT_OK, intent)
        finish()
    }

    override fun onError() {
        onBackPressed()
    }
}
