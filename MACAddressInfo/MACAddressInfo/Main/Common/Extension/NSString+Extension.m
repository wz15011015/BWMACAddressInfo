//
//  NSString+Extension.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

@end



@implementation NSString (Encryptor)

+ (instancetype)stringFromBytes:(unsigned char *)bytes size:(int)size {
    NSMutableString *result = @"".mutableCopy;
    for (int i = 0; i < size; ++i) {
        [result appendFormat:@"%02X", bytes[i]];
    }
    return [NSString stringWithString:result];
}

/**
 * SHA1 摘要算法
 * @return 16进制形式的摘要字符串, 大写
 */
- (NSString *)SHA1 {
    const char *cString = self.UTF8String;
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cString, (unsigned int)strlen(cString), bytes);
    return [NSString stringFromBytes:bytes size:CC_SHA1_DIGEST_LENGTH];
}

/**
 * SHA256摘要算法
 * @return 16进制形式的摘要字符串, 大写
 */
- (NSString *)SHA256 {
    const char *cString = self.UTF8String;
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cString, (unsigned int)strlen(cString), bytes);
    return [NSString stringFromBytes:bytes size:CC_SHA256_DIGEST_LENGTH];
}

/**
 * SHA512摘要算法
 * @return 16进制形式的摘要字符串, 大写
 */
- (NSString *)SHA512 {
    const char *cString = self.UTF8String;
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(cString, (unsigned int)strlen(cString), bytes);
    return [NSString stringFromBytes:bytes size:CC_SHA512_DIGEST_LENGTH];
}

/**
 * MD5信息摘要算法
 * @return 16进制形式的摘要字符串, 大写
 */
- (NSString *)MD5 {
    const char *cString = self.UTF8String;
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (unsigned int)strlen(cString), bytes);
    return [NSString stringFromBytes:bytes size:CC_MD5_DIGEST_LENGTH];
}


@end



@implementation NSString (Trimmer)

/**
 过滤首尾的空格

 @return 过滤后的字符串
 */
- (NSString *)trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 过滤首尾的空格和换行

 @return 过滤后的字符串
 */
- (NSString *)trimWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 过滤所有的空格

 @return 过滤后的字符串
 */
- (NSString *)trimAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 过滤所有的空格和换行

 @return 过滤后的字符串
 */
- (NSString *)trimAllWhitespaceAndNewline {
    NSString *result = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return result;
}

/**
 使用正则表达式替换字符串中的/和空格

 @return 替换后的字符串
 */
- (NSString *)replacingSlashAndWhitespace {
    NSString *newString = self;
    
    // 正则表达式的模式字符串
    NSString *regString = @"[/ ]";
    NSError *error = nil;
    // 创建正则表达式对象
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:regString options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        newString = [reg stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
    }
    return newString;
}

@end



/**
 OUI Code相关
 */
@implementation NSString (OUICode)

/**
 转换为标准的OUI Code
 
 标准OUI: F0766F
 其他OUI: F0:76:6F / F0-76-6F
 */
- (NSString *)convertToStandardOUICode {
    NSString *newString = self;
    
    /** 使用正则表达式剔除字符串中的冒号/空格/减号/ */
    // 正则表达式的模式字符串
    NSString *regString = @"[: ]|[-]";
    NSError *error = nil;
    // 创建正则表达式对象
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regString options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        newString = [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
    }
    // 转为大写
    newString = [newString uppercaseString];
    return newString;
}

@end
