//
//  Utility.m
//  QCOM
//
//  Created by mac1 on 11/23/15.
//  Copyright © 2015 Infrawebsoft. All rights reserved.
//

#import "Utility.h"

@implementation Utility

#pragma mark - Custom items of navigation bar

#pragma mark - Get color

+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+(void)showProgressViewInView:(UIView*)view withMessage:(NSString *)strMessage{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.label.text = @"Loading...";
    HUD.label.textColor=[self getColor:@"333333"];
    [Utility initUtility].isShowProgressView=YES;
    
    [HUD showAnimated:true];
}

+(void)hideProgress:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
    [Utility initUtility].isShowProgressView=false;
    
}

+ (void)showAlertWithTitle:(NSString *)strTitile andMessage:(NSString *)strMessage
{
    
    [[[UIAlertView alloc]initWithTitle:strTitile message:strMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
}

+(Utility *)initUtility
{
    static dispatch_once_t once;
    static Utility *sharedMyClass;
    dispatch_once(&once, ^ {
        sharedMyClass = [[self alloc] init];
    });
    return sharedMyClass;
}
@end
@implementation UILabel (CustomFont)
-(void)setFontName:(NSString *)value{
    CGFloat newsize = (self.font.pointSize * [UIScreen mainScreen].bounds.size.width)/320;
    [self setFont:[UIFont fontWithName:self.font.fontName size:newsize]];
}
@end
@implementation UITextField (CustomFont)
-(void)setFontName:(NSString *)value{
    CGFloat newsize = (self.font.pointSize * [UIScreen mainScreen].bounds.size.width)/320;
    [self setFont:[UIFont fontWithName:self.font.fontName size:newsize]];
}
@end
@implementation UIButton (CustomFont)
-(void)setFontName:(NSString *)value{
    CGFloat newsize = (self.titleLabel.font.pointSize * [UIScreen mainScreen].bounds.size.width)/320;
    [self.titleLabel setFont:[UIFont fontWithName:self.titleLabel.font.fontName size:newsize]];
}
@end
