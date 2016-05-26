

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface WXUtil :NSObject <NSXMLParserDelegate>
{
}
/**
 *2015.07.13
 *huan liu
 *加密实现MD5和SHA1
 */
+(NSString *) md5: (NSString *) inPutText ;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

/**
 实现http GET/POST 解析返回的json数据
 */
+(NSData *) httpSend:(NSString *)url method:(NSString *)method data:(NSString *)data;

@end