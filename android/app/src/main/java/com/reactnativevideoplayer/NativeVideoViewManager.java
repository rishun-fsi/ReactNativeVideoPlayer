package com.reactnativevideoplayer;

import static com.facebook.react.bridge.UiThreadUtil.runOnUiThread;

import android.app.ProgressDialog;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.annotation.UiThread;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.Map;

public class NativeVideoViewManager extends SimpleViewManager<FrameLayout> {


    private static final String REACT_CLASS = "NativeVideoView";

    private static final String NATIVE_EVENT_CHANGE = "onEventChange";
    private static final String NATIVE_EVENT_ERROR = "onEventError";

    private VideoView videoView;

    private FrameLayout frameLayout;

    private ProgressBar progressBar;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected FrameLayout createViewInstance(ThemedReactContext context) {
        videoView = new VideoView(context);
        frameLayout = new FrameLayout(context);
        progressBar = new ProgressBar(context);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(120,120);
        params.gravity = Gravity.CENTER;
        progressBar.setLayoutParams(params);
        return frameLayout;
    }

    @ReactProp(name = "value")
    public void setValue(FrameLayout frameLayout, String value) {
        final MediaPlayerAdapter mediaPlayerAdapter = new MediaPlayerAdapter();
        videoView.setOnPreparedListener(mediaPlayerAdapter);
        videoView.setOnErrorListener(mediaPlayerAdapter);
        videoView.setOnCompletionListener(mediaPlayerAdapter);

        if (value != null) {
            videoView.setVideoURI(value);
        }


        frameLayout.addView(videoView);
        frameLayout.addView(progressBar);
    }

    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put(
                        NATIVE_EVENT_CHANGE,
                        MapBuilder.of(
                                "phasedRegistrationNames",
                                MapBuilder.of("bubbled", "onChange")))
                .put(
                        NATIVE_EVENT_ERROR,
                        MapBuilder.of(
                                "phasedRegistrationNames",
                                MapBuilder.of("bubbled", "onError")))
                .build();
    }

    @Override
    public void onDropViewInstance(@NonNull FrameLayout view) {
        view.removeAllViews();
        if (videoView != null) {
            videoView.release();
            videoView = null;
        }
        super.onDropViewInstance(view);
    }

    /**
     * Playerイベント通知アダプタ
     */
    private class MediaPlayerAdapter implements VideoView.OnPreparedListener,
            VideoView.OnErrorListener, VideoView.OnCompletionListener {

        @Override
        public void onCompletion(final VideoView videoView) {
//            if (videoView != null) {
//                videoView.reset();
//            }
        }

        @Override
        public boolean onError(final int what, final int extra, final Throwable throwable) {
            WritableMap event = Arguments.createMap();
            event.putString("error", throwable.getMessage());
            ReactContext reactContext = (ReactContext)frameLayout.getContext();
            reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                    frameLayout.getId(),
                    NATIVE_EVENT_ERROR,
                    event);
            return false;
        }

        @Override
        public void onPrepared(final VideoView videoView) {
            if (videoView != null) {
                videoView.start();

                progressBar.setVisibility(View.GONE);

                WritableMap event = Arguments.createMap();
                //event.putString("message", "android MyMessage");
                event.putInt("duration", (int)(videoView.getDuration() / 1000));
                ReactContext reactContext = (ReactContext)frameLayout.getContext();
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                        frameLayout.getId(),
                        NATIVE_EVENT_CHANGE,
                        event);
            }
        }
    }

    public void getPosition(String value, Callback callback) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (videoView != null) {
                    Integer eventId = (int)(videoView.getCurrentPosition() / 1000);
                    callback.invoke(eventId);
                    //Log.d("111111", "player current pos = " + videoView.getCurrentPosition());
                }
            }
        });
    }

    public void sendMessage(String message) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (videoView != null && message != null && !message.isEmpty()) {
                    if (message.contentEquals("play")) {
                        videoView.play();
                    } else if (message.contentEquals("pause")) {
                        videoView.pause();
                    } else if (message.contentEquals("fast_backward")) {
                        long position = videoView.getCurrentPosition();
                        long seekPos = position - 10000 < 0 ? 0 : position - 10000;
                        videoView.seekTo(seekPos);
                    } else if (message.contentEquals("fast_forward")) {
                        long position = videoView.getCurrentPosition();
                        long duration = videoView.getDuration();
                        long seekPos = Math.min(position + 10000, duration);
                        videoView.seekTo(seekPos);
                    }
                }
            }
        });
    }
}
