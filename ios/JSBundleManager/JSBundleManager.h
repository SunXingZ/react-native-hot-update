//
//  JSBundleManager.h
//  fangxinjia
//
//  Created by 孙行者 on 2018/12/5.
//  Copyright © 2018 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>

//#define APP_VERSION ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])

typedef void(^CompletionBlock)(BOOL result);

@interface JSBundleManager : NSObject

- (NSString *)JSBundlePath;

- (BOOL)copyJSBundleFileToURL:(NSURL *)url;

- (BOOL)copyAssetsFileToURL:(NSURL *)url;

- (BOOL)hasJSBundleInDocumentsDirectory;

- (BOOL)hasAssetsInDocumentsDirectory;

- (BOOL)hasAssetsInProjectDirectory;

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
