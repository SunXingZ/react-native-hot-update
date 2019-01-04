//
//  HFileManager.m
//  RNHotupdate
//
//  Created by 放心家 on 2019/1/4.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "HFileManager.h"

#define FileManager [NSFileManager defaultManager]

@implementation HFileManager

+ (NSString *)createDirectory:(NSString *)fileName targetPath:(NSString *)targetPath error:(NSError **)error {
    NSString *path = [targetPath stringByAppendingPathComponent: fileName];
    if(![FileManager fileExistsAtPath: path]) {
        [FileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    }
    return path;
}

+ (NSString *)createFile:(NSString *)fileName toPath:(NSString *)toPath {
    NSString * path = [toPath stringByAppendingPathComponent: fileName];
    if (![FileManager fileExistsAtPath: path])
    {
        [FileManager createFileAtPath: path contents: nil attributes: nil];
    }
    return path;
}

+ (BOOL) deleteFileWithPath:(NSString *)targetPath error:(NSError **)error {
    return [FileManager removeItemAtPath: targetPath error:error];
}

+ (BOOL) deleteFileWithURL:(NSURL *)targetURL error:(NSError **)error {
    return [FileManager removeItemAtURL: targetURL error:error];
}

+ (BOOL)isFileExistInPath:(NSString *)path {
    return [FileManager fileExistsAtPath: path];
}

+ (BOOL) copyFileToPath:(NSString *)originPath targetPath:(NSString *)targetPath {
    NSError *error = nil;
    [FileManager copyItemAtPath: originPath toPath:targetPath error: &error];
    if (error) {
        return NO;
    }
    return YES;
}

+ (BOOL)copyFileToURL:(NSURL *)originURL targetURL:(NSURL *)targetURL {
    NSError *error = nil;
    [FileManager copyItemAtURL: originURL toURL: targetURL error: &error];
    if (error) {
        return NO;
    }
    return YES;
}

+ (long long) fileSizeInPath:(NSString*) filePath {
    if ([FileManager fileExistsAtPath: filePath]){
        return [[FileManager attributesOfItemAtPath: filePath error: nil] fileSize];
    }
    return 0;
}

+ (float)folderSizeInPath:(NSString*) folderPath {
    if (![FileManager fileExistsAtPath: folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[FileManager subpathsAtPath: folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    //遍历所有文件计算文件大小
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent: fileName];
        folderSize += [self fileSizeInPath: fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

+ (NSArray *)childFilesNameInPath:(NSString *)path {
    return [FileManager subpathsAtPath: path];
}

+ (NSDictionary *)fileAttributeInPath:(NSString *)path {
    return [FileManager attributesOfItemAtPath: path error: nil];
}

+ (BOOL)contentsEqualAtPath:(NSString *)path1 andPath:(NSString *)path2 {
    return [FileManager contentsEqualAtPath:path1 andPath: path2];
}

@end
