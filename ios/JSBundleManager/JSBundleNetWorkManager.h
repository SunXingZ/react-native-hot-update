//
//  JSBundleNetWorkManager.h
//  fangxinjia
//
//  Created by 孙行者 on 2018/12/5.
//  Copyright © 2018 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
};

typedef void(^CompletionBlock)(BOOL result);
typedef void(^CompletionHandleBlock)(NSData *data, NSURLResponse *response, NSError *connectionError);
typedef void(^ReturnValueBlock)(NSDictionary *dic);
typedef void(^ErrorCodeBlock)(NSDictionary *dic);
typedef void(^FailureBlock)(NSError *error);

@interface JSBundleNetWorkManager : NSObject

+ (NSURLSessionDataTask *)sendWithRequestMethod:(RequestMethod)requestMethod URLString:(NSString *)urlString params:(NSDictionary *)params error:(NSError *__autoreleasing *)error completionHandler:(CompletionHandleBlock)completion;

@end
