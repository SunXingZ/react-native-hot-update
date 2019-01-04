//
//  HBundleManager.m
//  RNHotupdate
//
//  Created by 放心家 on 2019/1/4.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "HBundleManager.h"
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import "HFileManager.h"
#import "HRequestManager.h"

@implementation HBundleManager

- (BOOL)copyJSBundleFileToURL:(NSURL *)url {
    NSURL *bundleFileURL = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    return [HFileManager copyFileToPath: bundleFileURL targetPath: url];
}

- (BOOL)copyAssetsFileToURL:(NSURL *)url {
    NSURL *assetsFileURL = [[NSBundle mainBundle] URLForResource:@"assets" withExtension:nil];
    return [HFileManager copyFileToURL:assetsFileURL targetURL:url];
}

- (BOOL)hasJSBundleInDocumentsDirectory {
    return [HFileManager isFileExistInPath:[self pathForJSBundleInDocumentsDirectory]];
}

- (BOOL)hasAssetsInDocumentsDirectory {
    return [HFileManager isFileExistInPath:[self pathForAssetsInDocumentsDirectory]];
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
    NSString *fileName = [@"main" stringByAppendingPathExtension:@"jsbundle"];
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
    if(![HFileManager isFileExistInPath: bundlePath]) {
        NSError *error = nil;
        [HFileManager createDirectory:@"JSBundle" targetPath: documentsPath error: &error];
    }
    return bundlePath;
}

- (BOOL)resetJSBundlePath {
    [HFileManager deleteFileWithPath:[self JSBundlePath] error:nil];
    BOOL(^createBundle)(BOOL) = ^(BOOL retry) {
        NSError *error;
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        [HFileManager createDirectory:@"JSBundle" targetPath:documentsPath error:&error];
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
    // 上述问题解决方案
    if (![self hasAssetsInDocumentsDirectory]) {
        [self resetJSBundlePath];
        BOOL copyAssetsResult = [self copyAssetsFileToURL:[self URLForAssetsInDocumentsDirectory]];
        if(copyAssetsResult) {
            jsCodeLocation = [self URLForJSBundleInDocumentsDirectory];
        } else {
            jsCodeLocation = [self URLForJSBundleInProject];
        }
        if (![self hasJSBundleInDocumentsDirectory]) {
            BOOL copyJSBundleResult = [self copyJSBundleFileToURL:[self URLForJSBundleInDocumentsDirectory]];
            if (!copyJSBundleResult) {
                jsCodeLocation = [self URLForJSBundleInProject];
            }
        }
    } else {
        NSString *mainAssets = [self pathForAssetsInProject];
        NSString *documentsAssets = [self pathForAssetsInDocumentsDirectory];
        BOOL isSameAssets = [HFileManager contentsEqualAtPath:mainAssets andPath:documentsAssets];
        if (isSameAssets) {
            if (![self hasJSBundleInDocumentsDirectory]) {
                BOOL copyJSBundleResult = [self copyJSBundleFileToURL:[self URLForJSBundleInDocumentsDirectory]];
                if (copyJSBundleResult) {
                    jsCodeLocation = [self URLForJSBundleInDocumentsDirectory];
                } else {
                    jsCodeLocation = [self URLForJSBundleInProject];
                }
            } else {
                jsCodeLocation = [self URLForJSBundleInDocumentsDirectory];
            }
        } else {
            [self resetJSBundlePath];
            jsCodeLocation = [self URLForJSBundleInProject];
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
    [HRequestManager sendWithRequestMethod:(RequestMethodGET) URLString:srcURLString params:nil error:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        NSString *writePath = [self pathForJSBundleInDocumentsDirectory];
        if (connectionError) {
            !complete ?: complete(NO);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = httpResponse.statusCode;
        if (statusCode == 200) {
            if ([HFileManager isFileExistInPath:writePath]) {
                NSError *error = nil;
                [HFileManager deleteFileWithPath:writePath error:&error];
                NSString *fileName = [@"main" stringByAppendingPathExtension:@"jsbundle"];
                NSString *filePath = [[self JSBundlePath] stringByAppendingPathComponent: fileName];
                [HFileManager createFile:fileName toPath:filePath];
            }
            NSError *error = nil;
            [data writeToFile:writePath options:(NSDataWritingAtomic) error:&error];
            if (error) {
                !complete ?: complete(NO);
                [HFileManager deleteFileWithPath:writePath error:nil];
            } else {
                !complete ?: complete(YES);
            }
        } else {
            !complete ?: complete(NO);
        }
    }];
}

@end
