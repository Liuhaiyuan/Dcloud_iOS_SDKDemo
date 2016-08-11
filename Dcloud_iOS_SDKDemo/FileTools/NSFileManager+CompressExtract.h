//
//  NSFileManager+CompressExtract.h
//  Dcloud_iOS_SDKDemo
//
//  Created by liuhaiyuan on 16/8/9.
//  Copyright © 2016年 liuhaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (CompressExtract)

/**
 *  根据路径将文件压缩为zip到指定路径
 *  @param sourcePath 压缩文件夹路径
 *  @param destZipFile存放路径（保存重命名）
 */
- (BOOL) commpressFileAtPath:(NSString*)sourcePath to:(NSString*)destZipFile;

/**
 *  解压文件
 *
 *  @param zipPath  zip文件所在目录
 *  @param savePath 解压文件到哪里的目录
 *
 *  @return 解压文件结果
 */
- (BOOL)extractFileAtPath:(NSString *)zipPath toSavePath:(NSString *)savePath;

@end
