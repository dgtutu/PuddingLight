//
//  DataTool.h
//  TubeLamp
//
//  Created by Ben on 2020/7/9.
//  Copyright © 2020 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataTool : NSObject
+(NSString*)getCrcString:(NSString *)string;
+(NSData *)convertHexStrToData:(NSString *)str;
+(NSString *)convertDataToHexStr:(NSData *)data;
+(NSString *)convert2StringWithAsciiHexString:(NSString *)string;
+(NSString *)convert2AsciiHexStringWithString:(NSString *)string;
+(NSString *)getmd5:(NSString *)inputString;
+(NSArray *)getDivisionFromLongSendData:(NSString *)sendData;
+ (unsigned long)getSubStringNumFromHexString:(NSString *)string FromLoc:(NSUInteger)loc WithLen:(NSUInteger)len;

//image -> hsv
+(NSArray *)colorAtPixel:(CGPoint)point andUIImage:(UIImage *)image;
+(NSArray *)Rgb2HsvWithR:(float)R G:(float)G B:(float) B;

+(NSString *)getQRDataString:(int)showPage ColorTemperature:(int)colorTemperature ColorCompensate:(int)colorCompensate Brightness:(int)brightness ;

+(NSString *)getQRDataString:(int)showPage ColorHue:(int)colorHue ColorSaturation:(int)colorSaturation Brightness:(int)brightness ;

/**
 获取二维码

 @param string 二维码中的信息
 @param size 二维码Size
 @param waterImg 水印图片
 @return 一个二维码图片，水印在二维码中央
 */
+ (UIImage *)qrImgForString:(NSString *)string size:(CGSize)size waterImg:(UIImage *)waterImg;

/**
 镶嵌图片

 @param img1 图片1
 @param img2 图片2
 @param location 图片2的起点
 @return 镶嵌后的图片
 */
+ (UIImage *)spliceImg1:(UIImage *)img1 img2:(UIImage *)img2 img2Location:(CGPoint)location;

/**
 修改二维码颜色
 
 @param image 二维码图片
 @param red red
 @param green green
 @param blue blue
 @return 修改颜色后的二维码图片
 */
+ (UIImage *)changeColorWithQRCodeImg:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;
@end

NS_ASSUME_NONNULL_END
