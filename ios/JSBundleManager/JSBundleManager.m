//
//  JSBundleManager.m
//  fangxinjia
//
//  Created by 孙行者 on 2018/12/5.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import "JSBundleManager.h"
#import "JSBundleFileManager.h"
#import "JSBundleNetWorkManager.h"
#import "SSZipArchive.h"

@implementation JSBundleManager

- (BOOL)copyJSBundleFileToURL:(NSURL *)url {
    NSURL *bundleFileURL = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    return [JSBundleFileManager copyFileToPath: bundleFileURL targetPath: url];
}

- (BOOL)copyAssetsFileToURL:(NSURL *)url {
    NSURL *assetsFileURL = [[NSBundle mainBundle] URLForResource:@"assets" withExtension:nil];
    return [JSBundleFileManager copyFileToURL:assetsFileURL targetURL:url];
}

- (BOOL)hasJSBundleInDocumentsDirectory {
    return [JSBundleFileManager isFileExistInPath:[self pathForJSBundleInDocumentsDirectory]];
}

- (BOOL)hasAssetsInDocumentsDirectory {
    return [JSBundleFileManager isFileExistInPath:[self pathForAssetsInDocumentsDirectory]];
}

- (BOOL)hasAssetsInProjectDirectory {
    return [JSBundleFileManager isFileExistInPath:[self pathForAssetsInProject]];
}

- (NSString *)pathForJSBundleInProject {
    NSURL *bundleFileURL = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    return bundleFileURL.path;
}

- (NSString *)pathForAssetsInProject {
    NSURL *assetsFileURL = [[NSBundle mainBundle] URLForResource:@"assets" withExtension:nil];
    return assetsFileURL.path;
}

- (NSString *)pathForJSBundleInDocumentsDirectory {
    NSString *fileName = [[@"main_" stringByAppendingString:APP_VERSION] stringByAppendingPathExtension:@"jsbundle"];
    NSString *filePath = [[self JSBundlePath] stringByAppendingPathComponent: fileName];
    return filePath;
}

- (NSString *)pathForAssetsInDocumentsDirectory {
    NSString *folderName = @"assets";
    NSString *folderPath = [[self JSBundlePath] stringByAppendingPathComponent:folderName];
    return folderPath;
}

- (NSString *)JSBundlePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *bundlePath = [documentsPath stringByAppendingPathComponent:@"JSBundle"];
    if(![JSBundleFileManager isFileExistInPath: bundlePath]) {
        NSError *error = nil;
        [JSBundleFileManager createDirectory:@"JSBundle" targetPath: documentsPath error: &error];
    }
    return bundlePath;
}

- (BOOL)resetJSBundlePath {
    [JSBundleFileManager deleteFileWithPath:[self JSBundlePath] error:nil];
    BOOL(^createBundle)(BOOL) = ^(BOOL retry) {
        NSError *error;
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        [JSBundleFileManager createDirectory:@"JSBundle" targetPath:documentsPath error:&error];
        if (error) {
            if (retry) {
                createBundle(NO);
            } else {
                return NO;
            }
        }
        return YES;
    };
    return createBundle(YES);
}

- (NSURL *)URLForJSBundleInProject {
    return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
}

- (NSURL *)URLForAssetsInProject {
    NSURL *assetsFileURL = [[NSBundle mainBundle] URLForResource:@"assets" withExtension:nil];
    return assetsFileURL;
}

- (NSURL *)URLForJSBundleInDocumentsDirectory {
    return [NSURL fileURLWithPath:[self pathForJSBundleInDocumentsDirectory]];
}

- (NSURL *)URLForAssetsInDocumentsDirectory {
    return [NSURL fileURLWithPath:[self pathForAssetsInDocumentsDirectory]];
}

- (RCTRootView *)createRootViewWithModuleName:(NSString *)moduleName
                                       bridge:(RCTBridge *)bridge {
    return [[RCTRootView alloc] initWithBridge:bridge moduleName:moduleName initialProperties:nil];
}

- (RCTBridge *)createBridgeWithBundleURL:(NSURL *)bundleURL {
    return [[RCTBridge alloc] initWithBundleURL:bundleURL moduleProvider:nil launchOptions:nil];
}

- (RCTRootView *)createRootViewWithURL:(NSURL *)url
                            moduleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions {
    return [[RCTRootView alloc] initWithBundleURL:url
                                       moduleName:moduleName
                                initialProperties:nil
                                    launchOptions:launchOptions];
}

- (RCTRootView *)getRootViewModuleName:(NSString *)moduleName
                         launchOptions:(NSDictionary *)launchOptions {
    NSURL *jsCodeLocation = nil;
    RCTRootView *rootView = nil;
#if DEBUG
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
    rootView = [self createRootViewWithURL:jsCodeLocation moduleName:moduleName launchOptions:launchOptions];
#else
    jsCodeLocation = [self URLForJSBundleInDocumentsDirectory];
    if (![self hasJSBundleInDocumentsDirectory]) {
        [self resetJSBundlePath];
        BOOL copyJSBundleResult = [self copyJSBundleFileToURL:[self URLForJSBundleInDocumentsDirectory]];
        if (!copyJSBundleResult) {
            [self resetJSBundlePath];
            jsCodeLocation = [self URLForJSBundleInProject];
        }
    }
    if ([self hasAssetsInProjectDirectory]) {
        if (![self hasAssetsInDocumentsDirectory]) {
            BOOL copyAssetsResult = [self copyAssetsFileToURL:[self URLForAssetsInDocumentsDirectory]];
            if(!copyAssetsResult) {
                [self resetJSBundlePath];
                jsCodeLocation = [self URLForJSBundleInProject];
            }
        } else {
            NSString *mainAssets = [self pathForAssetsInProject];
            NSString *documentsAssets = [self pathForAssetsInDocumentsDirectory];
            BOOL isSameAssets = [JSBundleFileManager contentsEqualAtPath:mainAssets andPath:documentsAssets];
            if (!isSameAssets) {
                [self resetJSBundlePath];
                jsCodeLocation = [self URLForJSBundleInProject];
            }
        }
    }
    RCTBridge *bridge = [self createBridgeWithBundleURL:jsCodeLocation];
    rootView = [self createRootViewWithModuleName:moduleName bridge:bridge];
#endif
    return rootView;
}

- (void)downloadCodeFrom:(NSString *)srcURLString
                   toURL:(NSURL *)targetURLString
         completeHandler:(CompletionBlock)complete {
    [JSBundleNetWorkManager sendWithRequestMethod:(RequestMethodGET) URLString:srcURLString params:nil error:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        if (connectionError) {
            !complete ?: complete(NO);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = httpResponse.statusCode;
        if (statusCode != 200) {
            !complete ?: complete(NO);
            return;
        }
        NSString *fileName = [[@"main_" stringByAppendingString:APP_VERSION] stringByAppendingPathExtension:@"jsbundle"];
        NSString *filePath = [[self JSBundlePath] stringByAppendingPathComponent: fileName];
        NSString *zipFileName = [fileName stringByAppendingPathExtension:@"zip"];
        NSString *zipFilePath = [[self JSBundlePath] stringByAppendingPathComponent: zipFileName];
        [JSBundleFileManager createFile:zipFileName toPath:zipFilePath];
        NSError *error = nil;
        [data writeToFile:zipFilePath options:(NSDataWritingAtomic) error:&error];
        if (error) {
            [JSBundleFileManager deleteFileWithPath:zipFilePath error:nil];
            !complete ?: complete(NO);
        } else {
            [JSBundleFileManager deleteFileWithPath:filePath error:nil];
            BOOL success = [SSZipArchive unzipFileAtPath:zipFilePath toDestination:[self JSBundlePath]];
            [JSBundleFileManager deleteFileWithPath:zipFilePath error:nil];
            if (!success) {
                if ([self hasJSBundleInDocumentsDirectory]) {
                    [JSBundleFileManager deleteFileWithPath:filePath error:nil];
                }
            }
            !complete ?: complete(success);
        }
    }];
}

@end
