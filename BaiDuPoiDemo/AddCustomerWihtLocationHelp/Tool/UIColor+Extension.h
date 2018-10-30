//
//  UIColor+Extension.h
//  Identify
//
//  Created by wupeng on 16/1/26.
//  Copyright © 2016年 StarShine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+(UIColor *)randomColor;
+(UIColor *)getAppThemesColor;
+(UIColor *)getAPPTabarColor;
+(UIImage *)colorToImage:(UIColor *)color;
+(UIColor *)getAPPTabarTextColor;
+(UIColor *)getChangeViewBGColor;
+(UIColor *)getGradeoneBGColor;
+(UIColor *)getGradetwoBGColor;
+(UIColor *)getGradethreeBGColor;
+(UIColor *)getLineViewColor;
+(UIColor *)getPlaceholderColor;
+(UIColor *)getValetOrderBGColor;
+(UIColor *)getHEXRGB:(NSString *)HEXString;

//渐变颜色
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
@end
