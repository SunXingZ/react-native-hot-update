//
//  HRequestManager.h
//  RNHotupdate
//
//  Created by 放心家 on 2019/1/4.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
};

typedef void(^CompletionBlock)(BOOL result);
typedef void(^CompletionHandleBlock)(NSData *data, NSURLResponse *response, NSError *connectionError);
typedef void(^ReturnValueBlock)(NSDictionary *dic);
typedef void(^ErrorCodeBlock)(NSDictionary *dic);
typedef void(^FailureBlock)(NSError *error);

@interface HRequestManager : NSObject

@end

NS_ASSUME_NONNULL_END
