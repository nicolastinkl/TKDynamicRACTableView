//
//  TKUtilsMacro.h
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.

/*!
 *  public macro
 */
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewWidth                       self.view.bounds.size.width
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define RectSetOriginWH(x, w, h)            CGRectMake(x, 10, w, h)

#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c)                         [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
#define F(string, args...)                  [NSString stringWithFormat:string, args]
#define USER_DEFAULT                        [NSUserDefaults standardUserDefaults]
#define FILE_MANAGER                        [NSFileManager defaultManager]
#define APP_CACHES_PATH                     [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define ios7BlueColor                        [UIColor colorWithRed:0.188 green:0.655 blue:1.000 alpha:1.000]
#define ALERT(title, msg)                   [[[UIAlertView alloc] initWithTitle:title\
                                            message:msg\
                                            delegate:nil\
                                            cancelButtonTitle:@"ok"\
                                            otherButtonTitles:nil] show]

/*!
 *  Diy block
 */
typedef void(^TKBlock)(void);
typedef void(^TKBlockBlock)(TKBlock block);
typedef void(^TKObjectBlock)(id obj);
typedef void(^TKArrayBlock)(NSArray *array);
typedef void(^TKMutableArrayBlock)(NSMutableArray *array);
typedef void(^TKDictionaryBlock)(NSDictionary *dic);
typedef void(^TKErrorBlock)(NSError *error);
typedef void(^TKIndexBlock)(NSInteger index);
typedef void(^TKFloatBlock)(CGFloat afloat);



/*!
 * @function Singleton GCD Macro
 */
#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                        \
\
+ (classname *)shared##classname {                      \
\
static dispatch_once_t pred;                        \
__strong static classname * shared##classname = nil;\
dispatch_once( &pred, ^{                            \
shared##classname = [[self alloc] init]; });    \
return shared##classname;                           \
}
#endif

/*!
 *  SLog
 */

#if NEED_OUTPUT_LOG

#define SLog(xx, ...)   NSLog(xx, ##__VA_ARGS__)
#define SLLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define SLLogRect(rect) \
SLLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y, \
rect.size.width, rect.size.height)

#define SLLogPoint(pt) \
SLLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)

#define SLLogSize(size) \
SLLog(@"%s w=%f, h=%f", #size, size.width, size.height)

#define SLLogColor(_COLOR) \
SLLog(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)

#define SLLogSuperViews(_VIEW) \
{ for (UIView* view = _VIEW; view; view = view.superview) { SLLog(@"%@", view); } }

#define SLLogSubViews(_VIEW) \
{ for (UIView* view in [_VIEW subviews]) { SLLog(@"%@", view); } }

#else

#define SLog(xx, ...)  ((void)0)
#define SLLog(xx, ...)  ((void)0)

#endif



