//
//  KKHud.h
//  AQGDemo
//
//  Created by BYMac on 2020/8/25.
//  Copyright © 2020 BYMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN

@interface KKHud : NSObject
+ (instancetype)share;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 在Appdelegate初始化指示器
/// @param init 初始化block
- (void)hudInit:(void(^)(MBProgressHUD * hud))init;

/// 指示器添加到父视图
- (KKHud *(^)(UIView * parentView))addHudIn;

/// 指示是否动画显示
- (KKHud *(^)(BOOL isAnimated))animated;

/// 指示器标题
- (KKHud *(^)(NSString * title))title;

/// 指示器详情
- (KKHud *(^)(NSString * detail))detail;

/// 指示器类型,该属性单次有效，在指示器消息后会变成默认类型
- (KKHud *(^)(MBProgressHUDMode mode))mode;

/// 显示指示器，最后调用
- (void (^)(void))showHUd;

/// 隐藏指示器，最后调用, 返回一个MBProgressHUD的block是为了可以进行指示器隐藏的回调
- (MBProgressHUD * (^)(void))hideHud;

/// 延迟显示指示器，最后调用，传入时间，,返回一个MBProgressHUD的block是为了可以进行指示器隐藏的回调
- (MBProgressHUD * (^)(NSTimeInterval delay))hideWithDelay;
@end

NS_ASSUME_NONNULL_END
