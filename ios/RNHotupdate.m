
#import "RNHotupdate.h"
#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>
#import "JSBundleManager/JSBundleManager.h"

@implementation RNHotupdate

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_METHOD(downloadJSBundleFromServer:(NSString *)downloadUrl callback:(RCTResponseSenderBlock)callback) {
    JSBundleManager *JSBManager = [[JSBundleManager alloc] init];
    NSURL *targetPath = [NSURL fileURLWithPath:[JSBManager JSBundlePath]];
    [JSBManager downloadCodeFrom:downloadUrl toURL:targetPath completeHandler:^(BOOL result) {
        NSNumber *status;
        if (result) {
            status = [[NSNumber alloc] initWithInt:1];
        } else {
            status = [[NSNumber alloc] initWithInt:0];
        }
        callback(@[status]);
    }];
}

RCT_EXPORT_METHOD(reloadJSBundle) {
    if ([NSThread isMainThread]) {
        [_bridge reload];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_bridge reload];
        });
    }
    return;
}

@end

