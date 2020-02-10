#import <Foundation/Foundation.h>
#import "WeexSDK.h"

@interface eeuiCityPickerModule : NSObject <WXModuleProtocol>

- (void)select:(NSDictionary*)params callback:(WXModuleKeepAliveCallback)callback;

@end
