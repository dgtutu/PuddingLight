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
#import <CoreImage/CoreImage.h>
#import <CommonCrypto/CommonDigest.h>
@implementation DataTool


+ (unsigned long)getSubStringNumFromHexString:(NSString *)string FromLoc:(NSUInteger)loc WithLen:(NSUInteger)len{
   return strtoul([[string substringWithRange:NSMakeRange(loc, len)] UTF8String],0,16);
}

+ (UIImage *)qrImgForString:(NSString *)string size:(CGSize)size waterImg:(UIImage *)waterImg {
    
    //创建名为"CIQRCodeGenerator"的CIFilter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //将filter所有属性设置为默认值
    [filter setDefaults];
    
    //将所需尽心转为UTF8的数据，并设置给filter
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    /*
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    //拿到二维码图片，此时的图片不是很清晰，需要二次加工
    CIImage *outPutImage = [filter outputImage];
    
    //如果有水印图片，那么添加水印后在调整清晰度，
    //如果没有直接，直接调节清晰度
    if (!waterImg) {
        return [[[self alloc] init] getHDImgWithCIImage:outPutImage size:size];
    } else {
        return [[[self alloc] init] getHDImgWithCIImage:outPutImage size:size waterImg:waterImg];;
    }
}

/**
 调整二维码清晰度
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */
- (UIImage *)getHDImgWithCIImage:(CIImage *)img size:(CGSize)size {
    
    CGRect extent = CGRectIntegral(img.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:img fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    return outputImage;
}

/**
 调整二维码清晰度
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */
- (UIImage *)sencond_getHDImgWithCIImage:(CIImage *)img size:(CGSize)size {
    
    //二维码的颜色
    UIColor *pointColor = [UIColor blackColor];
    //背景颜色
    UIColor *backgroundColor = [UIColor whiteColor];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage", img,
                             @"inputColor0", [CIColor colorWithCGColor:pointColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}


/**
 调整二维码清晰度，添加水印图片
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @param waterImg 水印图片
 @return 添加水印图片后，清晰的二维码图片
 */
- (UIImage *)getHDImgWithCIImage:(CIImage *)img size:(CGSize)size waterImg:(UIImage *)waterImg {
    
    CGRect extent = CGRectIntegral(img.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:img fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //logo图
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [waterImg drawInRect:CGRectMake((size.width-waterImg.size.width)/2.0, (size.height-waterImg.size.height)/2.0, waterImg.size.width, waterImg.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

/**
 拼接图片
 
 @param img1 图片1
 @param img2 图片2
 @return 拼接后的图片
 */
+ (UIImage *)spliceImg1:(UIImage *)img1 img2:(UIImage *)img2 img2Location:(CGPoint)location {
    
    //    CGSize size1 = img1.size;
    CGSize size2 = img2.size;
    
    UIGraphicsBeginImageContextWithOptions(img1.size, NO, [[UIScreen mainScreen] scale]);
    [img1 drawInRect:CGRectMake(0, 0, img1.size.width, img1.size.height)];
    
    //    [img2 drawInRect:CGRectMake((size1.width-size2.width)/2.0, (size1.height-size2.height)/2.0, size2.width, size2.height)];
    //    [img2 drawInRect:CGRectMake(size1.width/4.0, size1.height/2.5, size1.width/2, size1.width/2)];
    [img2 drawInRect:CGRectMake(location.x, location.y, size2.width, size2.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

/**
 修改二维码颜色
 
 @param image 二维码图片
 @param red red
 @param green green
 @param blue blue
 @return 修改颜色后的二维码图片
 */
+ (UIImage *)changeColorWithQRCodeImg:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue {
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, (CGRect){(CGPointZero), (image.size)}, image.CGImage);
    //遍历像素
    int pixelNumber = imageHeight * imageWidth;
    [self changeColorOnPixel:rgbImageBuf pixelNum:pixelNumber red:red green:green blue:blue];
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage * resultImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return resultImage;
}

/**
 遍历像素点，修改颜色
 
 @param rgbImageBuf rgbImageBuf
 @param pixelNum pixelNum
 @param red red
 @param green green
 @param blue blue
 */
+ (void)changeColorOnPixel: (uint32_t *)rgbImageBuf pixelNum: (int)pixelNum red: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue {
    
    uint32_t * pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        
        if ((*pCurPtr & 0xffffff00) < 0xd0d0d000) {
            
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        } else {
            //将白色变成透明色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
}

void ProviderReleaseData(void * info, const void * data, size_t size) {
    
    free((void *)data);
}


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

+(NSArray *)colorAtPixel:(CGPoint)point andUIImage:(UIImage *)image {
    // 如果点超出图像范围，则退出
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // 把[0,255]的颜色值映射至[0,1]区间
    
    NSLog(@"%02x%02x%02x", pixelData[0], pixelData[1], pixelData[2]);
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
//    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [DataTool Rgb2HsvWithR:red G:green B:blue];
    //    return @[[NSNumber numberWithFloat: alpha], [NSNumber numberWithFloat: red], [NSNumber numberWithFloat: green], [NSNumber numberWithFloat: blue]];
    //    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+(NSArray *) Rgb2HsvWithR:(float)R G:(float)G B:(float) B{
    // r,g,b values are from 0 to 1
    // h = [0,360], s = [0,1], v = [0,1]
    // if s == 0, then h = -1 (undefined)
    
    float min, max, delta,tmp, V, S, H;
    tmp = MIN(R, G);
    min = MIN( tmp, B );
    tmp = MAX( R, G);
    max = MAX(tmp, B );
    V = max; // v
    
    delta = max - min;
    
    if( max != 0 ){
        S = delta / max; // s
    }else{
        // r = g = b = 0 // s = 0, v is undefined
        S = 0;
        H = 0;
        
        NSLog(@"hsv = %f-%f-%f", H, S, S);
        return @[[NSNumber numberWithFloat: H], [NSNumber numberWithFloat: S], [NSNumber numberWithFloat: V]];
    }
    if( R == max ){
        H = ( G - B ) / delta; // between yellow & magenta
    }else if( G == max ){
        H = 2 + ( B - R ) / delta; // between cyan & yellow
    }else{
        H = 4 + ( R - G ) / delta; // between magenta & cyan
    }
    
    H *= 60; // degrees
    if( H < 0 )
        H += 360;
    NSLog(@"hsv = %f-%f-%f", H, S, V);
    return @[[NSNumber numberWithFloat: H], [NSNumber numberWithFloat: S], [NSNumber numberWithFloat: V]];
}

+(NSString *)getQRDataString:(int)showPage ColorTemperature:(int)colorTemperature ColorCompensate:(int)colorCompensate Brightness:(int)brightness {
    NSString *resultString;
    
    unsigned char payload[4];
    payload[0] = showPage; //1
    payload[1] = colorTemperature;
    payload[2] = colorCompensate;
    payload[3] = brightness;
    NSData *data = [NSData dataWithBytes:payload length:4];
    resultString = [self convertDataToHexStr:data];
    return resultString;
}

+(NSString *)getQRDataString:(int)showPage ColorHue:(int)colorHue ColorSaturation:(int)colorSaturation Brightness:(int)brightness {
    NSString *resultString;
    unsigned char payload[5];
    payload[0] = showPage; //3
    payload[1] = (colorHue >> 8) & 0xff;
    payload[2] = colorHue  & 0xff;
    payload[3] = colorSaturation ;
    payload[4] = brightness;
    NSData *data = [NSData dataWithBytes:payload length:5];
    resultString = [self convertDataToHexStr:data];
    
    return resultString;
    
    
    
}



@end
