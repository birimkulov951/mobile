package uz.paynet.app.utils.views

import android.annotation.TargetApi
import android.content.Context
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Matrix
import android.graphics.PointF
import android.graphics.RectF
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import android.os.Parcelable
import android.util.AttributeSet
import android.util.Log
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.ScaleGestureDetector
import android.view.View
import android.view.animation.AccelerateDecelerateInterpolator
import android.widget.OverScroller
import android.widget.Scroller
import androidx.appcompat.widget.AppCompatImageView

class TouchImageView : AppCompatImageView {

    var currentZoom: Float = 0.toFloat()
        private set

    private var matrixInternal: Matrix? = null
    private var prevMatrix: Matrix? = null
    private var state: State? = null
    private var minScale: Float = 0.toFloat()
    private var maxScale: Float = 0.toFloat()
    private var superMinScale: Float = 0.toFloat()
    private var superMaxScale: Float = 0.toFloat()
    private var m: FloatArray? = null
    private var contextInternal: Context? = null
    private var fling: Fling? = null
    private var mScaleType: ScaleType? = null
    private var imageRenderedAtLeastOnce: Boolean = false
    private var onDrawReady: Boolean = false
    private var delayedZoomVariables: ZoomVariables? = null
    private var viewWidth: Int = 0
    private var viewHeight: Int = 0
    private var prevViewWidth: Int = 0
    private var prevViewHeight: Int = 0
    private var matchViewWidth: Float = 0.toFloat()
    private var matchViewHeight: Float = 0.toFloat()
    private var prevMatchViewWidth: Float = 0.toFloat()
    private var prevMatchViewHeight: Float = 0.toFloat()
    private var mScaleDetector: ScaleGestureDetector? = null
    private var mGestureDetector: GestureDetector? = null
    private var doubleTapListener: GestureDetector.OnDoubleTapListener? = null
    private var userTouchListener: OnTouchListener? = null
    private var touchImageViewListener: OnTouchImageViewListener? = null

    private val isZoomed: Boolean
        get() = currentZoom != 1f

    val zoomedRect: RectF
        get() {
            if (mScaleType == ScaleType.FIT_XY) {
                throw UnsupportedOperationException("getZoomedRect() not supported with FIT_XY")
            }
            val topLeft = transformCoordTouchToBitmap(0f, 0f, true)
            val bottomRight = transformCoordTouchToBitmap(viewWidth.toFloat(), viewHeight.toFloat(), true)

            val w = drawable.intrinsicWidth.toFloat()
            val h = drawable.intrinsicHeight.toFloat()
            return RectF(topLeft.x / w, topLeft.y / h, bottomRight.x / w, bottomRight.y / h)
        }

    var maxZoom: Float
        get() = maxScale
        set(max) {
            maxScale = max
            superMaxScale = SUPER_MAX_MULTIPLIER * maxScale
        }

    var minZoom: Float
        get() = minScale
        set(min) {
            minScale = min
            superMinScale = SUPER_MIN_MULTIPLIER * minScale
        }

    val scrollPosition: PointF?
        get() {
            val drawable = drawable ?: return null
            val drawableWidth = drawable.intrinsicWidth
            val drawableHeight = drawable.intrinsicHeight

            val point = transformCoordTouchToBitmap((viewWidth / 2).toFloat(), (viewHeight / 2).toFloat(), true)
            point.x /= drawableWidth.toFloat()
            point.y /= drawableHeight.toFloat()
            return point
        }

    private val imageWidth: Float
        get() = matchViewWidth * currentZoom

    private val imageHeight: Float
        get() = matchViewHeight * currentZoom

    private enum class State {
        NONE, DRAG, ZOOM, FLING, ANIMATE_ZOOM
    }

    constructor(context: Context) : super(context) {
        sharedConstructing(context)
    }

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        sharedConstructing(context)
    }

    constructor(context: Context, attrs: AttributeSet, defStyle: Int) : super(context, attrs, defStyle) {
        sharedConstructing(context)
    }

    private fun sharedConstructing(context: Context) {
        super.setClickable(true)
        this.contextInternal = context
        mScaleDetector = ScaleGestureDetector(context, ScaleListener())
        mGestureDetector = GestureDetector(context, GestureListener())
        matrixInternal = Matrix()
        prevMatrix = Matrix()
        m = FloatArray(9)
        currentZoom = 1f
        if (mScaleType == null) {
            mScaleType = ScaleType.FIT_CENTER
        }
        minScale = 1f
        maxScale = 3f
        superMinScale = SUPER_MIN_MULTIPLIER * minScale
        superMaxScale = SUPER_MAX_MULTIPLIER * maxScale
        imageMatrix = matrixInternal
        scaleType = ScaleType.MATRIX
        setState(State.NONE)
        onDrawReady = false
        super.setOnTouchListener(PrivateOnTouchListener())
    }

    override fun setOnTouchListener(l: OnTouchListener) {
        userTouchListener = l
    }

    fun setOnTouchImageViewListener(l: OnTouchImageViewListener) {
        touchImageViewListener = l
    }

    fun setOnDoubleTapListener(l: GestureDetector.OnDoubleTapListener) {
        doubleTapListener = l
    }

    override fun setImageResource(resId: Int) {
        super.setImageResource(resId)
        savePreviousImageValues()
        fitImageToView()
    }

    override fun setImageBitmap(bm: Bitmap) {
        super.setImageBitmap(bm)
        savePreviousImageValues()
        fitImageToView()
    }

    override fun setImageDrawable(drawable: Drawable?) {
        super.setImageDrawable(drawable)
        savePreviousImageValues()
        fitImageToView()
    }

    override fun setImageURI(uri: Uri?) {
        super.setImageURI(uri)
        savePreviousImageValues()
        fitImageToView()
    }

    override fun setScaleType(type: ScaleType?) {
        if (type == ScaleType.FIT_START || type == ScaleType.FIT_END) {
            throw UnsupportedOperationException("TouchImageView does not support FIT_START or FIT_END")
        }
        if (type == ScaleType.MATRIX) {
            super.setScaleType(ScaleType.MATRIX)

        } else {
            mScaleType = type
            if (onDrawReady) {
                setZoom(this)
            }
        }
    }

    override fun getScaleType(): ScaleType? {
        return mScaleType
    }

    private fun savePreviousImageValues() {
        if (matrixInternal != null && viewHeight != 0 && viewWidth != 0) {
            matrixInternal!!.getValues(m)
            prevMatrix!!.setValues(m)
            prevMatchViewHeight = matchViewHeight
            prevMatchViewWidth = matchViewWidth
            prevViewHeight = viewHeight
            prevViewWidth = viewWidth
        }
    }

    public override fun onSaveInstanceState(): Parcelable? {
        val bundle = Bundle()
        bundle.putParcelable("instanceState", super.onSaveInstanceState())
        bundle.putFloat("saveScale", currentZoom)
        bundle.putFloat("matchViewHeight", matchViewHeight)
        bundle.putFloat("matchViewWidth", matchViewWidth)
        bundle.putInt("viewWidth", viewWidth)
        bundle.putInt("viewHeight", viewHeight)
        matrixInternal!!.getValues(m)
        bundle.putFloatArray("matrixInternal", m)
        bundle.putBoolean("imageRendered", imageRenderedAtLeastOnce)
        return bundle
    }

    public override fun onRestoreInstanceState(state: Parcelable) {
        if (state is Bundle) {
            val bundle = state
            currentZoom = bundle.getFloat("saveScale")
            m = bundle.getFloatArray("matrixInternal")
            prevMatrix!!.setValues(m)
            prevMatchViewHeight = bundle.getFloat("matchViewHeight")
            prevMatchViewWidth = bundle.getFloat("matchViewWidth")
            prevViewHeight = bundle.getInt("viewHeight")
            prevViewWidth = bundle.getInt("viewWidth")
            imageRenderedAtLeastOnce = bundle.getBoolean("imageRendered")
            super.onRestoreInstanceState(bundle.getParcelable("instanceState"))
            return
        }

        super.onRestoreInstanceState(state)
    }

    override fun onDraw(canvas: Canvas) {
        onDrawReady = true
        imageRenderedAtLeastOnce = true
        if (delayedZoomVariables != null) {
            setZoom(delayedZoomVariables!!.scale, delayedZoomVariables!!.focusX, delayedZoomVariables!!.focusY, delayedZoomVariables!!.scaleType)
            delayedZoomVariables = null
        }
        super.onDraw(canvas)
    }

    public override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        savePreviousImageValues()
    }

    fun resetZoom() {
        currentZoom = 1f
        fitImageToView()
    }

    @JvmOverloads
    fun setZoom(scale: Float, focusX: Float = 0.5f, focusY: Float = 0.5f, scaleType: ScaleType? = mScaleType) {
        if (!onDrawReady) {
            delayedZoomVariables = ZoomVariables(scale, focusX, focusY, scaleType!!)
            return
        }

        if (scaleType != mScaleType) {
            setScaleType(scaleType)
        }
        resetZoom()
        scaleImage(scale.toDouble(), (viewWidth / 2).toFloat(), (viewHeight / 2).toFloat(), true)
        matrixInternal!!.getValues(m)
        m!![Matrix.MTRANS_X] = -(focusX * imageWidth - viewWidth * 0.5f)
        m!![Matrix.MTRANS_Y] = -(focusY * imageHeight - viewHeight * 0.5f)
        matrixInternal!!.setValues(m)
        fixTrans()
        imageMatrix = matrixInternal
    }

    private fun setZoom(img: TouchImageView) {
        val center = img.scrollPosition
        setZoom(img.currentZoom, center!!.x, center.y, img.scaleType)
    }

    fun setScrollPosition(focusX: Float, focusY: Float) {
        setZoom(currentZoom, focusX, focusY)
    }

    private fun fixTrans() {
        matrixInternal!!.getValues(m)
        val transX = m!![Matrix.MTRANS_X]
        val transY = m!![Matrix.MTRANS_Y]

        val fixTransX = getFixTrans(transX, viewWidth.toFloat(), imageWidth)
        val fixTransY = getFixTrans(transY, viewHeight.toFloat(), imageHeight)

        if (fixTransX != 0f || fixTransY != 0f) {
            matrixInternal!!.postTranslate(fixTransX, fixTransY)
        }
    }

    private fun fixScaleTrans() {
        fixTrans()
        matrixInternal!!.getValues(m)
        if (imageWidth < viewWidth) {
            m!![Matrix.MTRANS_X] = (viewWidth - imageWidth) / 2
        }

        if (imageHeight < viewHeight) {
            m!![Matrix.MTRANS_Y] = (viewHeight - imageHeight) / 2
        }
        matrixInternal!!.setValues(m)
    }

    private fun getFixTrans(trans: Float, viewSize: Float, contentSize: Float): Float {
        val minTrans: Float
        val maxTrans: Float

        if (contentSize <= viewSize) {
            minTrans = 0f
            maxTrans = viewSize - contentSize

        } else {
            minTrans = viewSize - contentSize
            maxTrans = 0f
        }

        if (trans < minTrans)
            return -trans + minTrans
        return if (trans > maxTrans) -trans + maxTrans else 0f
    }

    private fun getFixDragTrans(delta: Float, viewSize: Float, contentSize: Float): Float {
        return if (contentSize <= viewSize) {
            0f
        } else delta
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        val drawable = drawable
        if (drawable == null || drawable.intrinsicWidth == 0 || drawable.intrinsicHeight == 0) {
            setMeasuredDimension(0, 0)
            return
        }

        val drawableWidth = drawable.intrinsicWidth
        val drawableHeight = drawable.intrinsicHeight
        val widthSize = MeasureSpec.getSize(widthMeasureSpec)
        val widthMode = MeasureSpec.getMode(widthMeasureSpec)
        val heightSize = MeasureSpec.getSize(heightMeasureSpec)
        val heightMode = MeasureSpec.getMode(heightMeasureSpec)
        viewWidth = setViewSize(widthMode, widthSize, drawableWidth)
        viewHeight = setViewSize(heightMode, heightSize, drawableHeight)
        setMeasuredDimension(viewWidth, viewHeight)
        fitImageToView()
    }

    private fun fitImageToView() {
        val drawable = drawable
        if (drawable == null || drawable.intrinsicWidth == 0 || drawable.intrinsicHeight == 0) {
            return
        }
        if (matrixInternal == null || prevMatrix == null) {
            return
        }

        val drawableWidth = drawable.intrinsicWidth
        val drawableHeight = drawable.intrinsicHeight
        var scaleX = viewWidth.toFloat() / drawableWidth
        var scaleY = viewHeight.toFloat() / drawableHeight

        when (mScaleType) {
            ScaleType.CENTER -> {
                scaleY = 1f
                scaleX = scaleY
            }
            ScaleType.CENTER_CROP -> {
                scaleY = Math.max(scaleX, scaleY)
                scaleX = scaleY
            }
            ScaleType.CENTER_INSIDE -> {
                scaleY = Math.min(1f, Math.min(scaleX, scaleY))
                scaleX = scaleY
                scaleY = Math.min(scaleX, scaleY)
                scaleX = scaleY
            }
            ScaleType.FIT_CENTER -> {
                scaleY = Math.min(scaleX, scaleY)
                scaleX = scaleY
            }
            ScaleType.FIT_XY -> {
            }
            else ->
                throw UnsupportedOperationException("TouchImageView does not support FIT_START or FIT_END")
        }

        val redundantXSpace = viewWidth - scaleX * drawableWidth
        val redundantYSpace = viewHeight - scaleY * drawableHeight
        matchViewWidth = viewWidth - redundantXSpace
        matchViewHeight = viewHeight - redundantYSpace
        if (!isZoomed && !imageRenderedAtLeastOnce) {
            matrixInternal!!.setScale(scaleX, scaleY)
            matrixInternal!!.postTranslate(redundantXSpace / 2, redundantYSpace / 2)
            currentZoom = 1f

        } else {
            if (prevMatchViewWidth == 0f || prevMatchViewHeight == 0f) {
                savePreviousImageValues()
            }

            prevMatrix!!.getValues(m)
            m!![Matrix.MSCALE_X] = matchViewWidth / drawableWidth * currentZoom
            m!![Matrix.MSCALE_Y] = matchViewHeight / drawableHeight * currentZoom

            val transX = m!![Matrix.MTRANS_X]
            val transY = m!![Matrix.MTRANS_Y]
            val prevActualWidth = prevMatchViewWidth * currentZoom
            val actualWidth = imageWidth
            translateMatrixAfterRotate(Matrix.MTRANS_X, transX, prevActualWidth, actualWidth, prevViewWidth, viewWidth, drawableWidth)
            val prevActualHeight = prevMatchViewHeight * currentZoom
            val actualHeight = imageHeight
            translateMatrixAfterRotate(Matrix.MTRANS_Y, transY, prevActualHeight, actualHeight, prevViewHeight, viewHeight, drawableHeight)
            matrixInternal!!.setValues(m)
        }
        fixTrans()
        imageMatrix = matrixInternal
    }

    private fun setViewSize(mode: Int, size: Int, drawableWidth: Int): Int {
        val viewSize: Int = when (mode) {
            MeasureSpec.EXACTLY -> size

            MeasureSpec.AT_MOST -> Math.min(drawableWidth, size)

            MeasureSpec.UNSPECIFIED -> drawableWidth

            else -> size
        }
        return viewSize
    }

    private fun translateMatrixAfterRotate(axis: Int, trans: Float, prevImageSize: Float, imageSize: Float, prevViewSize: Int, viewSize: Int, drawableSize: Int) {
        when {
            imageSize < viewSize -> {
                m!![axis] = (viewSize - drawableSize * m!![Matrix.MSCALE_X]) * 0.5f
            }
            trans > 0 -> {
                m!![axis] = -((imageSize - viewSize) * 0.5f)
            }
            else -> {
                val percentage = (Math.abs(trans) + 0.5f * prevViewSize) / prevImageSize
                m!![axis] = -(percentage * imageSize - viewSize * 0.5f)
            }
        }
    }

    private fun setState(state: State) {
        this.state = state
    }

    fun canScrollHorizontallyFroyo(direction: Int): Boolean {
        return canScrollHorizontally(direction)
    }

    override fun canScrollHorizontally(direction: Int): Boolean {
        matrixInternal!!.getValues(m)
        val x = m!![Matrix.MTRANS_X]

        if (imageWidth < viewWidth) {
            return false

        } else if (x >= -1 && direction < 0) {
            return false

        } else if (Math.abs(x) + viewWidth.toFloat() + 1f >= imageWidth && direction > 0) {
            return false
        }

        return true
    }

    private inner class GestureListener : GestureDetector.SimpleOnGestureListener() {

        override fun onSingleTapConfirmed(e: MotionEvent): Boolean {
            return if (doubleTapListener != null) {
                doubleTapListener!!.onSingleTapConfirmed(e)
            } else performClick()
        }

        override fun onLongPress(e: MotionEvent) {
            performLongClick()
        }

        override fun onFling(e1: MotionEvent, e2: MotionEvent, velocityX: Float, velocityY: Float): Boolean {
            if (fling != null) {
                fling!!.cancelFling()
            }
            fling = Fling(velocityX.toInt(), velocityY.toInt())
            compatPostOnAnimation(fling as Fling)
            return super.onFling(e1, e2, velocityX, velocityY)
        }

        override fun onDoubleTap(e: MotionEvent): Boolean {
            var consumed = false
            if (doubleTapListener != null) {
                consumed = doubleTapListener!!.onDoubleTap(e)
            }
            if (state == State.NONE) {
                val targetZoom = if (currentZoom == minScale) maxScale else minScale
                val doubleTap = DoubleTapZoom(targetZoom, e.x, e.y, false)
                compatPostOnAnimation(doubleTap)
                consumed = true
            }
            return consumed
        }

        override fun onDoubleTapEvent(e: MotionEvent): Boolean {
            return if (doubleTapListener != null) {
                doubleTapListener!!.onDoubleTapEvent(e)
            } else false
        }
    }

    interface OnTouchImageViewListener {
        fun onMove()
    }

    private inner class PrivateOnTouchListener : OnTouchListener {
        private val last = PointF()

        override fun onTouch(v: View, event: MotionEvent): Boolean {
            mScaleDetector!!.onTouchEvent(event)
            mGestureDetector!!.onTouchEvent(event)
            val curr = PointF(event.x, event.y)

            if (state == State.NONE || state == State.DRAG || state == State.FLING) {
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        last.set(curr)
                        if (fling != null)
                            fling!!.cancelFling()
                        setState(State.DRAG)
                    }

                    MotionEvent.ACTION_MOVE -> if (state == State.DRAG) {
                        val deltaX = curr.x - last.x
                        val deltaY = curr.y - last.y
                        val fixTransX = getFixDragTrans(deltaX, viewWidth.toFloat(), imageWidth)
                        val fixTransY = getFixDragTrans(deltaY, viewHeight.toFloat(), imageHeight)
                        matrixInternal!!.postTranslate(fixTransX, fixTransY)
                        fixTrans()
                        last.set(curr.x, curr.y)
                    }

                    MotionEvent.ACTION_UP, MotionEvent.ACTION_POINTER_UP -> setState(State.NONE)
                }
            }

            imageMatrix = matrixInternal

            if (userTouchListener != null) {
                userTouchListener!!.onTouch(v, event)
            }


            if (touchImageViewListener != null) {
                touchImageViewListener!!.onMove()
            }

            return true
        }
    }

    private inner class ScaleListener : ScaleGestureDetector.SimpleOnScaleGestureListener() {
        override fun onScaleBegin(detector: ScaleGestureDetector): Boolean {
            setState(State.ZOOM)
            return true
        }

        override fun onScale(detector: ScaleGestureDetector): Boolean {
            scaleImage(detector.scaleFactor.toDouble(), detector.focusX, detector.focusY, true)

            if (touchImageViewListener != null) {
                touchImageViewListener!!.onMove()
            }
            return true
        }

        override fun onScaleEnd(detector: ScaleGestureDetector) {
            super.onScaleEnd(detector)
            setState(State.NONE)
            var animateToZoomBoundary = false
            var targetZoom = currentZoom
            if (currentZoom > maxScale) {
                targetZoom = maxScale
                animateToZoomBoundary = true

            } else if (currentZoom < minScale) {
                targetZoom = minScale
                animateToZoomBoundary = true
            }

            if (animateToZoomBoundary) {
                val doubleTap = DoubleTapZoom(targetZoom, (viewWidth / 2).toFloat(), (viewHeight / 2).toFloat(), true)
                compatPostOnAnimation(doubleTap)
            }
        }
    }

    private fun scaleImage(deltaScale: Double, focusX: Float, focusY: Float, stretchImageToSuper: Boolean) {
        var deltaScale = deltaScale

        val lowerScale: Float
        val upperScale: Float
        if (stretchImageToSuper) {
            lowerScale = superMinScale
            upperScale = superMaxScale

        } else {
            lowerScale = minScale
            upperScale = maxScale
        }

        val origScale = currentZoom
        currentZoom *= deltaScale.toFloat()
        if (currentZoom > upperScale) {
            currentZoom = upperScale
            deltaScale = (upperScale / origScale).toDouble()
        } else if (currentZoom < lowerScale) {
            currentZoom = lowerScale
            deltaScale = (lowerScale / origScale).toDouble()
        }

        matrixInternal!!.postScale(deltaScale.toFloat(), deltaScale.toFloat(), focusX, focusY)
        fixScaleTrans()
    }

    private inner class DoubleTapZoom(private val targetZoom: Float, focusX: Float, focusY: Float, private val stretchImageToSuper: Boolean) : Runnable {

        private val startTime: Long
        private val startZoom: Float
        private val bitmapX: Float
        private val bitmapY: Float
        private val interpolator = AccelerateDecelerateInterpolator()
        private val startTouch: PointF
        private val endTouch: PointF

        init {
            setState(State.ANIMATE_ZOOM)
            startTime = System.currentTimeMillis()
            this.startZoom = currentZoom
            val bitmapPoint = transformCoordTouchToBitmap(focusX, focusY, false)
            this.bitmapX = bitmapPoint.x
            this.bitmapY = bitmapPoint.y

            startTouch = transformCoordBitmapToTouch(bitmapX, bitmapY)
            endTouch = PointF((viewWidth / 2).toFloat(), (viewHeight / 2).toFloat())
        }

        override fun run() {
            val t = interpolate()
            val deltaScale = calculateDeltaScale(t)
            scaleImage(deltaScale, bitmapX, bitmapY, stretchImageToSuper)
            translateImageToCenterTouchPosition(t)
            fixScaleTrans()
            imageMatrix = matrixInternal

            if (touchImageViewListener != null) {
                touchImageViewListener!!.onMove()
            }

            if (t < 1f) {
                compatPostOnAnimation(this)

            } else {
                setState(State.NONE)
            }
        }

        private fun translateImageToCenterTouchPosition(t: Float) {
            val targetX = startTouch.x + t * (endTouch.x - startTouch.x)
            val targetY = startTouch.y + t * (endTouch.y - startTouch.y)
            val curr = transformCoordBitmapToTouch(bitmapX, bitmapY)
            matrixInternal!!.postTranslate(targetX - curr.x, targetY - curr.y)
        }

        private fun interpolate(): Float {
            val currTime = System.currentTimeMillis()
            var elapsed = (currTime - startTime) / ZOOM_TIME
            elapsed = Math.min(1f, elapsed)
            return interpolator.getInterpolation(elapsed)
        }

        private fun calculateDeltaScale(t: Float): Double {
            val zoom = (startZoom + t * (targetZoom - startZoom)).toDouble()
            return zoom / currentZoom
        }

    }

    private fun transformCoordTouchToBitmap(x: Float, y: Float, clipToBitmap: Boolean): PointF {
        matrixInternal!!.getValues(m)
        val origW = drawable.intrinsicWidth.toFloat()
        val origH = drawable.intrinsicHeight.toFloat()
        val transX = m!![Matrix.MTRANS_X]
        val transY = m!![Matrix.MTRANS_Y]
        var finalX = (x - transX) * origW / imageWidth
        var finalY = (y - transY) * origH / imageHeight

        if (clipToBitmap) {
            finalX = Math.min(Math.max(finalX, 0f), origW)
            finalY = Math.min(Math.max(finalY, 0f), origH)
        }

        return PointF(finalX, finalY)
    }

    private fun transformCoordBitmapToTouch(bx: Float, by: Float): PointF {
        matrixInternal!!.getValues(m)
        val origW = drawable.intrinsicWidth.toFloat()
        val origH = drawable.intrinsicHeight.toFloat()
        val px = bx / origW
        val py = by / origH
        val finalX = m!![Matrix.MTRANS_X] + imageWidth * px
        val finalY = m!![Matrix.MTRANS_Y] + imageHeight * py
        return PointF(finalX, finalY)
    }

    private inner class Fling internal constructor(velocityX: Int, velocityY: Int) : Runnable {

        internal var scroller: CompatScroller? = null
        internal var currX: Int = 0
        internal var currY: Int = 0

        init {
            setState(State.FLING)
            scroller = CompatScroller(contextInternal!!)
            matrixInternal!!.getValues(m)

            val startX = m!![Matrix.MTRANS_X].toInt()
            val startY = m!![Matrix.MTRANS_Y].toInt()
            val minX: Int
            val maxX: Int
            val minY: Int
            val maxY: Int

            if (imageWidth > viewWidth) {
                minX = viewWidth - imageWidth.toInt()
                maxX = 0

            } else {
                maxX = startX
                minX = maxX
            }

            if (imageHeight > viewHeight) {
                minY = viewHeight - imageHeight.toInt()
                maxY = 0

            } else {
                maxY = startY
                minY = maxY
            }

            scroller!!.fling(startX, startY, velocityX, velocityY, minX,
                    maxX, minY, maxY)
            currX = startX
            currY = startY
        }

        fun cancelFling() {
            if (scroller != null) {
                setState(State.NONE)
                scroller!!.forceFinished(true)
            }
        }

        override fun run() {

            if (touchImageViewListener != null) {
                touchImageViewListener!!.onMove()
            }

            if (scroller!!.isFinished) {
                scroller = null
                return
            }

            if (scroller!!.computeScrollOffset()) {
                val newX = scroller!!.currX
                val newY = scroller!!.currY
                val transX = newX - currX
                val transY = newY - currY
                currX = newX
                currY = newY
                matrixInternal!!.postTranslate(transX.toFloat(), transY.toFloat())
                fixTrans()
                imageMatrix = matrixInternal
                compatPostOnAnimation(this)
            }
        }
    }

    @TargetApi(VERSION_CODES.GINGERBREAD)
    private inner class CompatScroller(context: Context) {
        internal var scroller: Scroller? = null
        internal var overScroller: OverScroller? = null
        internal var isPreGingerbread: Boolean = false

        val isFinished: Boolean
            get() = if (isPreGingerbread) {
                scroller?.isFinished!!
            } else {
                overScroller?.isFinished!!
            }

        val currX: Int
            get() = if (isPreGingerbread) {
                scroller?.currX!!
            } else {
                overScroller?.currX!!
            }

        val currY: Int
            get() = if (isPreGingerbread) {
                scroller?.currY!!
            } else {
                overScroller?.currY!!
            }

        init {
            if (VERSION.SDK_INT < VERSION_CODES.GINGERBREAD) {
                isPreGingerbread = true
                scroller = Scroller(context)

            } else {
                isPreGingerbread = false
                overScroller = OverScroller(context)
            }
        }

        fun fling(startX: Int, startY: Int, velocityX: Int, velocityY: Int, minX: Int, maxX: Int, minY: Int, maxY: Int) {
            if (isPreGingerbread) {
                scroller?.fling(startX, startY, velocityX, velocityY, minX, maxX, minY, maxY)
            } else {
                overScroller?.fling(startX, startY, velocityX, velocityY, minX, maxX, minY, maxY)
            }
        }

        fun forceFinished(finished: Boolean) {
            if (isPreGingerbread) {
                scroller?.forceFinished(finished)
            } else {
                overScroller?.forceFinished(finished)
            }
        }

        fun computeScrollOffset(): Boolean {
            if (isPreGingerbread) {
                return scroller?.computeScrollOffset()!!
            } else {
                overScroller?.computeScrollOffset()
                return overScroller?.computeScrollOffset()!!
            }
        }
    }

    @TargetApi(VERSION_CODES.JELLY_BEAN)
    private fun compatPostOnAnimation(runnable: Runnable) {
        if (VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN) {
            postOnAnimation(runnable)

        } else {
            postDelayed(runnable, (1000 / 60).toLong())
        }
    }

    private inner class ZoomVariables(var scale: Float, var focusX: Float, var focusY: Float, var scaleType: ScaleType)

    private fun printMatrixInfo() {
        val n = FloatArray(9)
        matrixInternal!!.getValues(n)
        Log.d(DEBUG, "Scale: " + n[Matrix.MSCALE_X] + " TransX: " + n[Matrix.MTRANS_X] + " TransY: " + n[Matrix.MTRANS_Y])
    }

    companion object {

        private val DEBUG = "DEBUG"

        private val SUPER_MIN_MULTIPLIER = .75f
        private val SUPER_MAX_MULTIPLIER = 1.25f
        private val ZOOM_TIME = 500f
    }
}