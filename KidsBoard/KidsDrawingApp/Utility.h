
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"

#define CHECK_NULL_STRING(str) ([str isKindOfClass:[NSNull class]] || !str)?@"":str
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define ShowProgress(inView,strMessage) [Utility showProgressViewInView:inView withMessage:strMessage]
#define ShowProgressInWindow(inWindow,strMessage) [Utility showProgressViewInWindow:inWindow withMessage:strMessage]
#define HideProgress(inView) [Utility hideProgress:inView]
#define HideProgressInWindow(inWindow) [Utility hideProgressInWindow:inWindow]

#define isiPhone4  ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isiPhone6  ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define isiPhone6P  ([[UIScreen mainScreen] bounds].size.height == 736)?TRUE:FALSE

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SomethingWentWrong @"Something went wrong. please try again later."
#define ServerResponceError @"Server not responding."


@interface Utility : NSObject

#pragma mark - Custom items of navigation bar
@property BOOL isShowProgressView;
+(Utility *)initUtility;
+(void)showProgressViewInView:(UIView*)view withMessage:(NSString *)strMessage;
+(void)hideProgress:(UIView *)view;

@end

@interface UILabel (CustomFont)
-(void)setFontName:(NSString *)value;
@end
@interface UITextField (CustomFont)
-(void)setFontName:(NSString *)value;
@end
@interface UIButton (CustomFont)
-(void)setFontName:(NSString *)value;
@end
