//
//  HBundleManager.h
//  RNHotupdate
//
//  Created by 放心家 on 2019/1/4.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionBlock)(BOOL result);

@interface HBundleManager : NSObject

- (NSString *)JSBundlePath;

- (BOOL)copyJSBundleFileToURL:(NSURL *)url;

- (BOOL)copyAssetsFileToURL:(NSURL *)url;

- (BOOL)hasJSBundleInDocumentsDirectory;

- (BOOL)hasAssetsInDocumentsDirectory;

- (NSString *)pathForJSBundleInProject;

- (NSString *)pathForAssetsInProject;

- (NSString *)pathForJSBundleInDocumentsDirectory;

- (NSString *)pathForAssetsInDocumentsDirectory;

- (NSURL *)URLForJSBundleInProject;

- (NSURL *)URLForAssetsInProject;

- (NSURL *)URLForJSBundleInDocumentsDirectory;

- (NSURL *)URLForAssetsInDocumentsDirectory;

- (BOOL)resetJSBundlePath;

- (RCTRootView *)createRootViewWithModuleName:(NSString *)moduleName
                                       bridge:(RCTBridge *)bridge;

- (RCTRootView *)createRootViewWithURL:(NSURL *)url
                            moduleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions;

- (RCTRootView *)getRootViewModuleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions;

- (RCTBridge *)createBridgeWithBundleURL:(NSURL *)bundleURL;

- (void)downloadCodeFrom:(NSString *)srcURLString
                   toURL:(NSURL *)targetURLString
         completeHandler:(CompletionBlock)complete;

@end

NS_ASSUME_NONNULL_END
