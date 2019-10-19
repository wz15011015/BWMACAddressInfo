//
//  NSString+Extension.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

@end



/**
 加密相关
 */
@interface NSString (Encryptor)

/**
 * SHA1 摘要算法
 * @return 16进制形式的摘要字符串, 大写
 */
- (NSString *)SHA1;

/**
 * SHA256摘要算法
 * @return 16进制形式的摘要字符串, 大写
 */
- (NSString *)SHA256;

/**
 * SHA512摘要算法
 * @return 16进制形式的摘要字符串, 大写
 */
- (NSString *)SHA512;

/**
 * MD5信息摘要算法
 * @return 16进制形式的摘要字符串, 大写
 */
- (NSString *)MD5;

@end


@interface NSString (Trimmer)

/**
 过滤首尾的空格
 
 @return 过滤后的字符串
 */
- (NSString *)trimWhitespace;

/**
 过滤首尾的空格和换行
 
 @return 过滤后的字符串
 */
- (NSString *)trimWhitespaceAndNewline;

/**
 过滤所有的空格
 
 @return 过滤后的字符串
 */
- (NSString *)trimAllWhitespace;

/**
 过滤所有的空格和换行
 
 @return 过滤后的字符串
 */
- (NSString *)trimAllWhitespaceAndNewline;


/**
 使用正则表达式替换字符串中的/和空格
 
 @return 替换后的字符串
 */
- (NSString *)replacingSlashAndWhitespace;

@end


/**
 OUI Code相关
 */
@interface NSString (OUICode)

/**
 转换为标准的OUI Code
 
 标准OUI: F0766F
 其他OUI: F0:76:6F / F0-76-6F
 */
- (NSString *)convertToStandardOUICode;

@end

NS_ASSUME_NONNULL_END
