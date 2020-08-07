//
//  DataTool.h
//  TubeLamp
//
//  Created by Ben on 2020/7/9.
//  Copyright © 2020 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataTool : NSObject
+(NSString*)getCrcString:(NSString *)string;
+(NSData *)convertHexStrToData:(NSString *)str;
+(NSString *)convertDataToHexStr:(NSData *)data;
+(NSString *)convert2StringWithAsciiHexString:(NSString *)string;
+(NSString *)convert2AsciiHexStringWithString:(NSString *)string;
+(NSString *)getmd5:(NSString *)inputString;
+(NSArray *)getDivisionFromLongSendData:(NSString *)sendData;
@end

NS_ASSUME_NONNULL_END
