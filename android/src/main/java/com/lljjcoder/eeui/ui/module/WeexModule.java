package com.lljjcoder.eeui.ui.module;

import com.lljjcoder.eeui.ui.entry.eeui_citypicker;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;


public class WeexModule extends WXModule {

    private static final String TAG = "eeuiCitypickerModule";

    private eeui_citypicker __obj;

    private eeui_citypicker myApp() {
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
    @JSMethod
    public void select(String object, JSCallback callback) {
        myApp().select(mWXSDKInstance.getContext(), object, callback);
    }
}
