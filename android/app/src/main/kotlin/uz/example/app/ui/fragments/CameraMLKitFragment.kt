package uz.example.app.ui.fragments

import android.Manifest
import android.app.AlertDialog
import android.app.Dialog
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import uz.example.app.R
import uz.example.app.mlkit.OcrMrzDetectorProcessor
import uz.example.app.utils.MRZUtil
import org.jmrtd.lds.icao.MRZInfo
import io.fotoapparat.preview.Frame
import io.fotoapparat.view.CameraView
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.schedulers.Schedulers
import kotlinx.android.synthetic.main.fragment_camera_mrz.*

open class CameraMLKitFragment : CameraFragment() {
    private var cameraMLKitCallback: CameraMLKitCallback? = null
    private var frameProcessor: OcrMrzDetectorProcessor? = null
    private val mHandler = Handler(Looper.getMainLooper())
    var disposable = CompositeDisposable()

    private var isDecoding = false

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_camera_mrz, container, false)
    }

    override fun onResume() {
        MRZUtil.cleanStorage()
        frameProcessor = textProcessor
        super.onResume()
    }

    override fun onPause() {
        frameProcessor?.stop()
        frameProcessor = null

        super.onPause()
    }

    override fun onDestroyView() {
        if (!disposable.isDisposed) {
            disposable.dispose();
        }
        super.onDestroyView()
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        val activity = activity
        if (activity is CameraMLKitCallback) {
            cameraMLKitCallback = activity
        }
    }

    override fun onDetach() {
        cameraMLKitCallback = null
        super.onDetach()

    }


    fun recreateFragment(fragment: Fragment) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            fragmentManager?.beginTransaction()?.detach(fragment)?.commitNow()
            fragmentManager?.beginTransaction()?.attach(fragment)?.commitNow()
        } else {
            fragmentManager?.beginTransaction()?.detach(fragment)?.attach(fragment)?.commitNow()
        }
    }

    override val callbackFrameProcessor: io.fotoapparat.preview.FrameProcessor
        get() {
            val callbackFrameProcessor2 = object : io.fotoapparat.preview.FrameProcessor {
                override fun process(frame: Frame) {
                    try {
                        if (!isDecoding) {
                            isDecoding = true

                            if (frameProcessor != null) {
                                val subscribe = Single.fromCallable {
                                    (frameProcessor as OcrMrzDetectorProcessor).process(frame, 90)
                                }.subscribeOn(Schedulers.io())
                                        .observeOn(AndroidSchedulers.mainThread())
                                        .subscribe({ _ ->
                                        }, { error ->
                                            isDecoding = false
                                            Toast.makeText(requireContext(), "Error: $error", Toast.LENGTH_SHORT).show()
                                        })
                                disposable.add(subscribe)
                            }
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }

                }
            }
            return callbackFrameProcessor2
        }

    override val cameraPreview: CameraView
        get() {
            return camera_preview
        }

    override val requestedPermissions: ArrayList<String>
        get() {
            return ArrayList()
        }

    override fun onRequestPermissionsResult(permissionsDenied: ArrayList<String>, permissionsGranted: ArrayList<String>) {
    }

    protected val textProcessor: OcrMrzDetectorProcessor
        get() = OcrMrzDetectorProcessor(object : OcrMrzDetectorProcessor.MRZCallback {
            override fun onMRZRead(mrzInfo: MRZInfo, timeRequired: Long) {
                isDecoding = false
                if (!isAdded) {
                    return
                }
                mHandler.post {
                    try {
//                        status_view_top!!.text = getString(R.string.status_bar_ocr, mrzInfo.documentNumber, mrzInfo.dateOfBirth, mrzInfo.dateOfExpiry)
//                        status_view_bottom!!.text = getString(R.string.status_bar_success, timeRequired)
//                        status_view_bottom!!.setTextColor(resources.getColor(R.color.status_text))
                        if (cameraMLKitCallback != null) {
                            cameraMLKitCallback!!.onPassportRead(mrzInfo)
                        }

                    } catch (e: IllegalStateException) {
                        //The fragment is destroyed
                    }
                }
            }

            override fun onMRZReadFailure(timeRequired: Long) {
                isDecoding = false
                if (!isAdded) {
                    return
                }
                mHandler.post {
                    try {
//                        status_view_bottom!!.text = getString(R.string.status_bar_failure, timeRequired)
//                        status_view_bottom!!.setTextColor(Color.RED)
//                        status_view_top!!.text = ""
                    } catch (e: IllegalStateException) {
                        //The fragment is destroyed
                    }
                }
            }

            override fun onFailure(e: Exception, timeRequired: Long) {
                isDecoding = false
                if (!isAdded) {
                    return
                }
                e.printStackTrace()
                mHandler.post {
                    if (cameraMLKitCallback != null) {
                        cameraMLKitCallback!!.onError()
                    }
                }
            }

            override fun onRecreate(b: Boolean) {
                if (b) {
                    activity?.recreate()
                } else {
                    activity?.finish()
                }
            }
        }, requireContext())

    private fun requestCameraPermission() {
        if (shouldShowRequestPermissionRationale(Manifest.permission.CAMERA)) {
            ConfirmationDialog().show(childFragmentManager, FRAGMENT_DIALOG)
        } else {
            requestPermissions(arrayOf(Manifest.permission.CAMERA), REQUEST_CAMERA_PERMISSION)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>,
                                            grantResults: IntArray) {
        if (requestCode == REQUEST_CAMERA_PERMISSION) {
            if (grantResults.size != 1 || grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                ErrorDialog.newInstance(getString(R.string.permission_camera_rationale))
                        .show(childFragmentManager, FRAGMENT_DIALOG)
            }
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    private fun showToast(text: String) {
        val activity = activity
        activity?.runOnUiThread { Toast.makeText(activity, text, Toast.LENGTH_SHORT).show() }
    }

    class ErrorDialog : androidx.fragment.app.DialogFragment() {

        override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
            val activity = activity
            return AlertDialog.Builder(activity)
                    .setMessage(requireArguments().getString(ARG_MESSAGE))
                    .setPositiveButton(android.R.string.ok) { dialogInterface, i -> activity!!.finish() }
                    .create()
        }

        companion object {

            private const val ARG_MESSAGE = "message"

            fun newInstance(message: String): ErrorDialog {
                val dialog = ErrorDialog()
                val args = Bundle()
                args.putString(ARG_MESSAGE, message)
                dialog.arguments = args
                return dialog
            }
        }

    }

    class ConfirmationDialog : androidx.fragment.app.DialogFragment() {

        override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
            val parent = parentFragment
            return AlertDialog.Builder(activity)
                    .setMessage(R.string.permission_camera_rationale)
                    .setPositiveButton(android.R.string.ok) { dialog, which ->
                        parent!!.requestPermissions(arrayOf(Manifest.permission.CAMERA),
                                REQUEST_CAMERA_PERMISSION)
                    }
                    .setNegativeButton(android.R.string.cancel
                    ) { _, _ ->
                        val activity = parent!!.activity
                        activity?.finish()
                    }
                    .create()
        }
    }

    interface CameraMLKitCallback {
        fun onPassportRead(mrzInfo: MRZInfo)
        fun onError()
    }

    companion object {

        private val TAG = CameraMLKitFragment::class.java.simpleName

        private const val REQUEST_CAMERA_PERMISSION = 1
        private const val FRAGMENT_DIALOG = "CameraMLKitFragment"

        fun newInstance(): CameraMLKitFragment {
            return CameraMLKitFragment()
        }
    }


}
