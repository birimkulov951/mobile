package uz.example.app.mlkit

import android.graphics.Bitmap
import android.media.Image
import com.google.firebase.ml.common.FirebaseMLException
import io.fotoapparat.preview.Frame
import java.nio.ByteBuffer

/** An inferface to process the images with different ML Kit detectors and custom image models.  */
interface VisionImageProcessor {

    /** Processes the images with the underlying machine learning models.  */
    @Throws(FirebaseMLException::class)
    fun process(data: ByteBuffer, frameMetadata: FrameMetadata):Boolean

    /** Processes the bitmap images.  */
    fun process(bitmap: Bitmap, rotation:Int):Boolean

    /** Processes the bitmap images.  */
    fun process(frame:Frame, rotation:Int):Boolean

    /** Processes the images.  */
    fun process(image: Image, rotation: Int):Boolean

    /** Stops the underlying machine learning model and release resources.  */
    fun stop()
}
