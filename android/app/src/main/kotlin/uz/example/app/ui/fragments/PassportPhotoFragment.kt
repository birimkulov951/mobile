package uz.example.app.ui.fragments

import android.content.Context
import android.graphics.Bitmap
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import uz.example.app.R
import uz.example.app.common.IntentData

class PassportPhotoFragment : androidx.fragment.app.Fragment() {

    private var passportPhotoFragmentListener: PassportPhotoFragmentListener? = null

    private var bitmap: Bitmap? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_photo, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val arguments = arguments
        if (arguments!!.containsKey(IntentData.KEY_IMAGE)) {
            bitmap = arguments.getParcelable(IntentData.KEY_IMAGE)
        } 
    }

    override fun onResume() {
        super.onResume()
        refreshData(bitmap)
    }

    private fun refreshData(bitmap: Bitmap?) {
        if (bitmap == null) {
            return
        }

    }


    override fun onAttach(context: Context) {
        super.onAttach(context)
        val activity = activity
        if (activity is PassportPhotoFragmentListener) {
            passportPhotoFragmentListener = activity
        }
    }

    override fun onDetach() {
        passportPhotoFragmentListener = null
        super.onDetach()

    }

    interface PassportPhotoFragmentListener

    companion object {

        fun newInstance(bitmap: Bitmap): PassportPhotoFragment {
            val myFragment = PassportPhotoFragment()
            val args = Bundle()
            args.putParcelable(IntentData.KEY_IMAGE, bitmap)
            myFragment.arguments = args
            return myFragment
        }
    }

}
