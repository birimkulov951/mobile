package uz.paynet.app.mlkit

import android.graphics.Bitmap
import android.media.Image
import com.google.android.gms.tasks.Task
import com.google.firebase.ml.vision.common.FirebaseVisionImage
import com.google.firebase.ml.vision.common.FirebaseVisionImageMetadata
import uz.paynet.app.utils.ImageUtil
import io.fotoapparat.preview.Frame
import java.nio.ByteBuffer
import java.util.concurrent.atomic.AtomicBoolean

abstract class VisionProcessorBase<T> : VisionImageProcessor {

    private val shouldThrottle = AtomicBoolean(false)

    override fun process(
            data: ByteBuffer, frameMetadata: FrameMetadata): Boolean {
        if (shouldThrottle.get()) {
            return false
        }
        val metadata = FirebaseVisionImageMetadata.Builder()
                .setFormat(FirebaseVisionImageMetadata.IMAGE_FORMAT_NV21)
                .setWidth(frameMetadata.width)
                .setHeight(frameMetadata.height)
                .setRotation(frameMetadata.rotation)
                .build()

        return detectInVisionImage(
                FirebaseVisionImage.fromByteBuffer(data, metadata), frameMetadata)
    }

    override fun process(bitmap: Bitmap, rotation: Int): Boolean {
        val frameMetadata = FrameMetadata.Builder()
                .setWidth(bitmap.width)
                .setHeight(bitmap.height)
                .setRotation(rotation).build()
        val bitmapToProcess = when (rotation) {
            0 -> {
                bitmap
            }
            else -> {
                ImageUtil.rotateBitmap(bitmap, rotation.toFloat())
            }
        }

        return detectInVisionImage(image = FirebaseVisionImage.fromBitmap(bitmapToProcess), metadata = frameMetadata)
    }

    override fun process(frame: Frame, rotation: Int): Boolean {
        if (shouldThrottle.get()) {
            return false
        }

        var intFirebaseRotation = FirebaseVisionImageMetadata.ROTATION_0
        when (rotation) {
            0 -> {
                intFirebaseRotation = FirebaseVisionImageMetadata.ROTATION_0
            }
            90 -> {
                intFirebaseRotation = FirebaseVisionImageMetadata.ROTATION_90
            }
            180 -> {
                intFirebaseRotation = FirebaseVisionImageMetadata.ROTATION_180
            }
            270 -> {
                intFirebaseRotation = FirebaseVisionImageMetadata.ROTATION_270
            }
        }


        val frameMetadata = FrameMetadata.Builder()
                .setWidth(frame.size.width)
                .setHeight(frame.size.height)
                .setRotation(rotation).build()
        val metadata = FirebaseVisionImageMetadata.Builder()
                .setFormat(FirebaseVisionImageMetadata.IMAGE_FORMAT_NV21)
                .setWidth(frameMetadata.width)
                .setHeight(frameMetadata.height)
                .setRotation(intFirebaseRotation)
                .build()
        return detectInVisionImage(FirebaseVisionImage.fromByteArray(frame.image, metadata), frameMetadata)
    }

    override fun process(image: Image, rotation: Int): Boolean {
        if (shouldThrottle.get()) {
            return false
        }
        // This is for overlay display's usage
        val frameMetadata = FrameMetadata.Builder().setWidth(image.width).setHeight(image.height).build()
        val fbVisionImage = FirebaseVisionImage.fromMediaImage(image, rotation)
        return detectInVisionImage(fbVisionImage, frameMetadata)
    }

    private fun detectInVisionImage(
            image: FirebaseVisionImage,
            metadata: FrameMetadata?
    ): Boolean {
        val start = System.currentTimeMillis()
        val bitmapForDebugging = image.bitmap
        detectInImage(image)
                .addOnSuccessListener { results ->
                    shouldThrottle.set(false)
                    val timeRequired = System.currentTimeMillis() - start
                    this@VisionProcessorBase.onSuccess(results, metadata, timeRequired, bitmapForDebugging)
                }
                .addOnFailureListener { e ->
                    shouldThrottle.set(false)
                    val timeRequired = System.currentTimeMillis() - start
                    this@VisionProcessorBase.onFailure(e, timeRequired)
                }
        shouldThrottle.set(true)
        return true
    }

    override fun stop() {}

    protected abstract fun detectInImage(image: FirebaseVisionImage): Task<T>

    protected abstract fun onSuccess(
            results: T,
            frameMetadata: FrameMetadata?,
            timeRequired: Long,
            bitmap: Bitmap)

    protected abstract fun onFailure(e: Exception, timeRequired: Long)


}
