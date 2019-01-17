//
//  JSBundleNetWorkManager.m
//  fangxinjia
//
//  Created by 孙行者 on 2018/12/5.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSBundleNetWorkManager.h"

@implementation JSBundleNetWorkManager

+ (NSURLSessionDataTask *)sendWithRequestMethod:(RequestMethod)requestMethod URLString:(NSString *)urlString params:(NSDictionary *)params error:(NSError *__autoreleasing *)error completionHandler:(CompletionHandleBlock)completion {
  NSString *method = @"GET";
  if (requestMethod == RequestMethodPOST) {
    method = @"POST";
  }
  urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlString]];
  request.HTTPMethod = method;
  request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
  if (RequestMethodPOST) {
    if (params) {
      request.HTTPBody = [QueryStringFromParametersWithEncoding(params, NSUTF8StringEncoding) dataUsingEncoding: NSUTF8StringEncoding];
    }
  }
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest: request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (completion) {
      completion(data, response, error);
    }
  }];
  [task resume];
  return task;
}

static NSString * QueryStringFromParametersWithEncoding(NSDictionary *params, NSStringEncoding stringEncoding) {
  NSMutableArray *mutablePairs = [NSMutableArray array];
  [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    NSString *ercentEscapedKey = key;
    NSString *ercentEscapedValue = obj;
    if ([key isKindOfClass:[NSString class]]) {
      ercentEscapedKey = [key stringByAddingPercentEscapesUsingEncoding:stringEncoding];
    }
    if ([ercentEscapedValue isKindOfClass:[NSString class]]) {
      ercentEscapedValue = [key stringByAddingPercentEscapesUsingEncoding:stringEncoding];
    }
    NSString *pair = [NSString stringWithFormat:@"%@=%@", ercentEscapedKey, ercentEscapedValue];
    [mutablePairs addObject:pair];
  }];
  return [mutablePairs componentsJoinedByString:@"&"];
}

@end
