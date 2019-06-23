package com.lljjcoder.eeui.ui.module;


import com.lljjcoder.eeui.ui.entry.eeui_citypicker;

import app.eeui.framework.extend.view.ExtendWebView;
import app.eeui.framework.extend.view.webviewBridge.JsCallback;
import app.eeui.framework.ui.eeui;

public class WebModule {

    private static eeui_citypicker __obj;

    private static eeui_citypicker myApp() {
        if (__obj == null) {
            __obj = new eeui_citypicker();
        }
        return __obj;
    }

    /***************************************************************************************************/
    /***************************************************************************************************/
    /***************************************************************************************************/

    /**
     * 选择地址
     * @param object
     * @param callback
     */
    public static void select(ExtendWebView webView, String object, JsCallback callback) {
        myApp().select(webView.getContext(), object, eeui.MCallback(callback));
    }
}
