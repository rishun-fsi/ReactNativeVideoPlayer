package com.reactnativevideoplayer;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class PlayControllerModule extends ReactContextBaseJavaModule {
    private NativeVideoViewManager nativeVideoViewManager;
    PlayControllerModule(ReactApplicationContext context, NativeVideoViewManager nativeVideoViewManager) {
        super(context);
        this.nativeVideoViewManager = nativeVideoViewManager;
    }

    @Override
    public String getName() {
        return "PlayControllerModule";
    }

    @ReactMethod
    public void createPlayControllerEvent(String key, String value, Callback callback) {
        nativeVideoViewManager.getPosition(value, callback);

    }

    @ReactMethod
    public void sendPlayControllerEvent(String message) {
        nativeVideoViewManager.sendMessage(message);
    }
}
