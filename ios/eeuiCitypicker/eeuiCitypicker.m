//
//  eeuiCitypicker.m
//  Pods
//
//  Created by 高一 on 2019/3/4.
//

#import "eeuiCitypicker.h"
#import "eeuiCitypickerBridge.h"
#import "WeexInitManager.h"
#import <WebKit/WKWebView.h>

WEEX_PLUGIN_INIT(eeuiCitypicker)
@implementation eeuiCitypicker

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static eeuiCitypicker *instance;
    dispatch_once(&onceToken, ^{
        instance = [[eeuiCitypicker alloc] init];
    });
    return instance;
}

- (void) setJSCallModule:(JSCallCommon *)callCommon webView:(WKWebView*)webView
{
    [callCommon setJSCallAssign:webView name:@"eeuiCitypicker" bridge:[[eeuiCitypickerBridge alloc] init]];
}

@end
