//
//  DataTool.m
//  TubeLamp
//
//  Created by Ben on 2020/7/9.
//  Copyright © 2020 Ben. All rights reserved.
//

#import "DataTool.h"
#define POLYNOMIAL 0x1021
#define INITIAL_REMAINDER 0xACE1
#define WIDTH (8 * sizeof(unsigned short))
#define TOPBIT (1 << (WIDTH - 1))
#import <CommonCrypto/CommonDigest.h>
@implementation DataTool

+(NSString*)getCrcString:(NSString *)string
{
    //该函数为包含从帧头标志到命令数据的所有命令字段的CRC16校验值。校验公式为0x1021，初始值为0xACE1。
    //根据给定的数据计算CRC值方法如下：
    //参数：str要进行CRC计算的缓冲区数据
    //      len要进行CRC计算的缓冲区数据的数据长度
    //返回值：返回CRC计算的结果数据字符串
    //CRC校验
    unsigned short remainder = INITIAL_REMAINDER;
    int ibyte;
    unsigned char i;
    unsigned char arr[string.length/2];
    
    for (int i=0; i<string.length; i+=2) {
        arr[i/2]=(int)strtoul([[string substringWithRange:NSMakeRange(i, 2)] UTF8String],0,16);
    }
    
    for (ibyte = 0; ibyte < string.length/2; ++ibyte)
    {
        remainder ^= ((arr[ibyte]) << (WIDTH - 8));
        for (i = 8; i > 0; --i)
        {
            if (remainder & TOPBIT)
                remainder = (remainder << 1) ^ POLYNOMIAL;
            else
                remainder = (remainder << 1);
        }
    }
    return [NSString stringWithFormat:@"%.4x",remainder];
}

+(NSData *)convertHexStrToData:(NSString *)str {
    
    
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


+(NSString *)convertDataToHexStr:(NSData *)data {
    
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

+(NSString *)convert2StringWithAsciiHexString:(NSString *)string{
    //会省掉00,因为00没有ascii码
    if(string.length!=2){
        return [[NSString stringWithFormat:@"%c",(int)strtoul([[string substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)]stringByAppendingString:[self convert2StringWithAsciiHexString:[string substringWithRange:NSMakeRange(2, string.length-2)]]];
    }else {
        return [NSString stringWithFormat:@"%c",(int)strtoul([string UTF8String], 0, 16)];
    }
}

+(NSString *)convert2AsciiHexStringWithString:(NSString *)string{
    NSString *asciiString=@"";
    for (int i=0;i<string.length;i++){
        int asciiCode=[string characterAtIndex:i];
        asciiString=[asciiString stringByAppendingFormat:@"%.2x",asciiCode];
        NSLog(@"asciiString:%@",asciiString);
    }
    return asciiString;
}


+(NSString *)getmd5:(NSString *)inputString{
    
    char arr[inputString.length/2];
    for (int i=0; i<inputString.length/2; i++) {
        arr[i]=strtoul([[inputString substringWithRange:NSMakeRange(i*2, 2)] UTF8String],0,16);
    }
    const char *cStr=arr;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (int)inputString.length/2, result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+(NSArray *)getDivisionFromLongSendData:(NSString *)sendData{
    //把不带crc校验的长发送指令传入,输出分包数组
    NSString *crc=[DataTool getCrcString:sendData];
    sendData = [sendData stringByAppendingString:crc];
    unsigned long sendDataLength = sendData.length/2;//单位:字节
    unsigned long offset = 0;//单位:字节
    unsigned long DivisionSize=19;//单位:字节
    unsigned long sendTimes=1;
    unsigned long totalsendTimes = sendDataLength%DivisionSize == 0 ? sendDataLength/DivisionSize :sendDataLength/DivisionSize+1;
    //第一次发送的数据分包
    NSMutableArray *divisionArray=[NSMutableArray array];
    do{
        NSString * division;
        NSUInteger currDivisionSize  = sendDataLength -offset > DivisionSize ? DivisionSize :sendDataLength-offset;
        //当前包的大小 = 总长度 -偏移-> 如果大于设定的分包大小, 则当前分包大小=分包大小,否则等于长度-偏移
        if(sendTimes==1){
            division=[@"40" stringByAppendingString:[sendData substringWithRange:NSMakeRange(offset*2, currDivisionSize*2)]];
        }else if(1<sendTimes && sendTimes<totalsendTimes){
            division=[@"80" stringByAppendingString:[sendData substringWithRange:NSMakeRange(offset*2, currDivisionSize*2)]];
        }else if(sendTimes == totalsendTimes){
            division=[@"c0" stringByAppendingString:[sendData substringWithRange:NSMakeRange(offset*2, currDivisionSize*2)]];
        }
        [divisionArray addObject:division];
        sendTimes++;
        offset += currDivisionSize;
    }while(offset < sendDataLength);
    return divisionArray;
}

@end
