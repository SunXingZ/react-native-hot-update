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

+ (NSURLSessionDataTask *)sendWithRequestMethod:(RequestMethod)requestMethod URLString:(NSString *)urlString params:(NSDictionary *)params error:(NSError *__autoreleasing *)error completionHandler:(CompletionHandleBlock)completion;

@end

NS_ASSUME_NONNULL_END
