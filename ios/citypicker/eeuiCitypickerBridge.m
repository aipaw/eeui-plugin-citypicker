//
//  eeuiCitypickerBridge.m
//  eeuiApp
//
//  Created by 高一 on 2019/1/6.
//

#import "eeuiCitypickerBridge.h"
#import "eeuiCityPickerModule.h"

@interface eeuiCitypickerBridge ()

@property (nonatomic, strong) eeuiCityPickerModule *city;

@end

@implementation eeuiCitypickerBridge

- (void)initialize
{
    if (self.city == nil) {
        self.city = [[eeuiCityPickerModule alloc] init];
    }
}

- (void)select:(NSDictionary*)params callback:(WXModuleKeepAliveCallback)callback
{
    [self.city select:params callback:callback];
}

@end
