//
//  KKHud.m
//  AQGDemo
//
//  Created by BYMac on 2020/8/25.
//  Copyright © 2020 BYMac. All rights reserved.
//

#import "KKHud.h"

@implementation KKHud
{
    UIView *    _parentView;  /*指示器父视图*/
    BOOL        _animated;    /*指示器是否动画*/
    NSString *  _title;       /*指示器标题*/
    NSString *  _detail;      /*指示器详情*/
    MBProgressHUD * _hud;     /*指示器*/
    MBProgressHUDMode _mode;  /*指示器类型*/
}

+ (instancetype)share {
    static KKHud * _hudShare = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hudShare = [[self alloc] init];
    });
    return _hudShare;
}

- (void)hudInit:(void (^)(MBProgressHUD * _Nonnull))init {
    _hud = [[MBProgressHUD alloc] init];
    init(_hud);
}

- (KKHud * _Nonnull (^)(UIView * _Nonnull))addHudIn {
   return ^(UIView * parentView){
       [parentView addSubview:self->_hud];
        return self;
   };
}

- (KKHud * _Nonnull (^)(BOOL))animated {
    return ^(BOOL isAnimated){
        self->_animated = isAnimated;
         return self;
    };
}

- (KKHud * _Nonnull (^)(NSString * _Nonnull))title {
    return ^(NSString * title) {
        self->_title = title;
        return self;
    };
}

- (KKHud * _Nonnull (^)(NSString * _Nonnull))detail {
    return ^(NSString * detail) {
        self->_detail = detail;
        return self;
    };
}

- (KKHud * _Nonnull (^)(MBProgressHUDMode))mode {
    return ^(MBProgressHUDMode mode) {
        self->_mode = mode;
        return self;
    };
}

- (void (^)(void))showHUd {
    return ^{
        [self->_hud showAnimated:self->_animated];
        self->_hud.mode = self->_mode;
        self->_hud.label.text = self->_title;
        self->_hud.detailsLabel.text = self->_detail;
    };
}

- (MBProgressHUD * (^)(void))hideHud {
    return ^{
        [self->_hud hideAnimated:self->_animated];
        [self resetValue];
        return self->_hud;
    };
}

- (MBProgressHUD * (^)(NSTimeInterval))hideWithDelay {
    return ^(NSTimeInterval delay){
        [self->_hud hideAnimated:self->_animated afterDelay:delay];
        [self resetValue];
        return self->_hud;
    };
}

- (void)resetValue {
    _title      = nil;
    _detail     = nil;
    _animated   = YES;
    _mode       = MBProgressHUDModeIndeterminate;
}
@end
