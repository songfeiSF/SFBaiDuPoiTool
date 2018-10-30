//
//  UIColor+Extension.m
//  Identify
//
//  Created by wupeng on 16/1/26.
//  Copyright © 2016年 StarShine. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+(UIColor *)randomColor {
    UIColor *randomColor = [UIColor colorWithRed:((arc4random() % 254 ) + 1)/255.0 green:((arc4random() % 254 ) + 1)/255.0 blue:((arc4random() % 254 ) + 1)/255.0 alpha:1.f];
    return randomColor;
}
+(UIColor *)getAppThemesColor {
    return [UIColor getHEXRGB:@"FF5722"];
}
+(UIColor *)getAPPTabarColor {
    return [UIColor getHEXRGB:@"F0F0F0"];
}
+(UIColor *)getAPPTabarTextColor {
   return [UIColor getHEXRGB:@"3888f9"];
}
+(UIColor *)getChangeViewBGColor {
    return [UIColor getHEXRGB:@"EFEFF4"];
}
+(UIColor *)getGradeoneBGColor {
    return [UIColor getHEXRGB:@"ff6d56"];
}
+(UIColor *)getGradetwoBGColor {
    return [UIColor getHEXRGB:@"ffb312"];
}
+(UIColor *)getGradethreeBGColor {
    return [UIColor getHEXRGB:@"41ca96"];
}
+(UIColor *)getLineViewColor {
    return [UIColor getHEXRGB:@"E8E8E8"];
}
+(UIColor *)getPlaceholderColor {
    return [UIColor getHEXRGB:@"D2D2D6"];
}
+(UIColor *)getValetOrderBGColor {
    return [UIColor getHEXRGB:@"FF5C1C"];
}
+(UIColor *)getHEXRGB:(NSString *)HEXString {
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [HEXString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [HEXString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [HEXString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:CGFLOAT_MAX];
}
#pragma mark - colorToImage
+ (UIImage *)colorToImage:(UIColor *)color {
    CGSize szie = CGSizeMake(1, 1);
    // 打开上下文
    UIGraphicsBeginImageContextWithOptions(szie, NO, [UIScreen mainScreen].scale);
    // 填充color
    [color setFill];
    // 画图
    UIRectFill(CGRectMake(0, 0, szie.width, szie.height));
    // 获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // return
    return image;
    
}

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:fromHexColorStr].CGColor,(__bridge id)[UIColor colorWithHex:toHexColorStr].CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}




//获取16进制颜色的方法
+ (UIColor *)colorWithHex:(NSString *)hexColor {
    hexColor = [hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([hexColor length] < 6) {
        return nil;
    }
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *rs = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gs = [hexColor substringWithRange:range];
    range.location = 4;
    NSString *bs = [hexColor substringWithRange:range];
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rs] scanHexInt:&r];
    [[NSScanner scannerWithString:gs] scanHexInt:&g];
    [[NSScanner scannerWithString:bs] scanHexInt:&b];
    if ([hexColor length] == 8) {
        range.location = 4;
        NSString *as = [hexColor substringWithRange:range];
        [[NSScanner scannerWithString:as] scanHexInt:&a];
    } else {
        a = 255;
    }
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
}
@end
