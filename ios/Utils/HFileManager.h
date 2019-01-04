//
//  HFileManager.h
//  RNHotupdate
//
//  Created by 放心家 on 2019/1/4.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFileManager : NSObject

+ (BOOL)isFileExistInPath:(NSString *)path;

+ (NSString *)createDirectory:(NSString *)fileName targetPath:(NSString *)targetPath error:(NSError **)error;

+ (BOOL) deleteFileWithPath:(NSString *)targetPath error:(NSError **)error;

+ (BOOL) deleteFileWithURL:(NSURL *)targetURL error:(NSError **)error;

+ (NSString *)createFile:(NSString *)fileName toPath:(NSString *)toPath;

+ (BOOL) copyFileToPath:(NSString *)originPath targetPath:(NSString *)targetPath;

+ (BOOL)copyFileToURL:(NSURL *)originURL targetURL:(NSURL *)targetURL;

+ (long long) fileSizeInPath:(NSString*) filePath;

+ (float)folderSizeInPath:(NSString*) folderPath;

+ (NSArray *)childFilesNameInPath:(NSString *)path;

+ (NSDictionary *)fileAttributeInPath:(NSString *)path;

+ (BOOL)contentsEqualAtPath:(NSString *)path1 andPath:(NSString *)path2;

@end

NS_ASSUME_NONNULL_END
