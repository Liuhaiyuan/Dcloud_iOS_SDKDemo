//
//  NSFileManager+CompressExtract.m
//  Dcloud_iOS_SDKDemo
//
//  Created by liuhaiyuan on 16/8/9.
//  Copyright © 2016年 liuhaiyuan. All rights reserved.
//

#import "NSFileManager+CompressExtract.h"
#import "ZipArchive.h"

@implementation NSFileManager (CompressExtract)

/**
 *  根据路径将文件压缩为zip到指定路径
 *  @param sourcePath 压缩文件夹路径
 *  @param destZipFile存放路径（保存重命名）
 */

- (BOOL) commpressFileAtPath:(NSString*)sourcePath to:(NSString*)destZipFile{
    
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:destZipFile];
    
    NSArray *subPaths = [self subpathsAtPath:sourcePath];// 关键是subpathsAtPath方法
    for(NSString *subPath in subPaths){
        NSString *fullPath = [sourcePath stringByAppendingPathComponent:subPath];
        BOOL isDir;
        if([self fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)// 只处理文件
        {
            [za addFileToZip:fullPath newname:subPath];
        }    
    }
    
    BOOL success = [za CloseZipFile2];
    NSLog(@"Zipped file with result %d",success);
    
    return success;
}

- (BOOL)extractFileAtPath:(NSString *)zipPath toSavePath:(NSString *)savePath{
    
    ZipArchive *za = [[ZipArchive alloc] init];
    
    [za UnzipOpenFile: zipPath];
        
    [za UnzipFileTo: savePath overWrite: YES];
    return [za UnzipCloseFile];
}

@end
