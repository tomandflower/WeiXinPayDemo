//
//  WXUtil.h
//  WeiXinPayDemo
//
//  Created by tomandhua on 16/5/18.
//  Copyright © 2016年 tomandhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXUtil : NSObject <NSXMLParserDelegate>
//加密实现和SHA1
+ (NSString *)md5:(NSString *)str;
+ (NSString *)sha1:(NSString *)str;

//实现http GET/POST 解析返回的json数据
+ (NSData *)httSend:(NSString *)url method:(NSString *)method data:(NSString *)data;
@end
