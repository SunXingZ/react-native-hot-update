
#import "RNHotupdate.h"
#import "Utils/HBundleManager.h"

@implementation RNHotupdate

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(downloadJSBundleFromServer:(NSString *)downloadUrl callback:(RCTResponseSenderBlock)callback) {
    HBundleManager *BundleManager = [[HBundleManager alloc] init];
    NSURL *targetPath = [NSURL fileURLWithPath:[BundleManager JSBundlePath]];
    [BundleManager downloadCodeFrom:downloadUrl toURL:targetPath completeHandler:^(BOOL result) {
        NSNumber *status;
        if (result) {
            status = [[NSNumber alloc] initWithInt:1];
        } else {
            status = [[NSNumber alloc] initWithInt:0];
        }
        callback(@[status]);
    }];
}

@end
  
