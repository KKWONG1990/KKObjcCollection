//
//  KKAlertController.h
//  AQGDemo
//
//  Created by BYMac on 2020/8/20.
//  Copyright © 2020 BYMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKAlertController;
NS_ASSUME_NONNULL_BEGIN

/* UITextField 交互回调*/
typedef void(^_Nullable TextFieldHandle)(UITextField * textField);
/* UIAlertAction 交互回调*/
typedef void(^_Nullable ActionHandle)(UIAlertAction * action);

@interface KKAlertController : UIAlertController

/// 初始化AlertControlle，在block内部传入标题、信息、类型
+ (KKAlertController *(^)(NSString * _Nullable title,
                          NSString * _Nullable message,
                          UIAlertControllerStyle preferredStyle))init;

/// 添加action - block传入标题、样式、自定义颜色、ActionHandle类型block
- (KKAlertController *(^)(NSString * _Nullable title,
                          UIAlertActionStyle actionStyle,
                          UIColor * _Nullable titleColor,
                          ActionHandle handle))addAction;

/// 添加TextField - block传入占位符、自定义颜色、 TextFieldHandle 类型block
- (KKAlertController *(^)(NSString * _Nullable placehoder,
                          UIColor * _Nullable textColor,
                          TextFieldHandle handle))addTextField;

/// 自定义Title样式
- (KKAlertController *(^)(UIColor * _Nullable titleColor,
                          UIFont * _Nullable titleFont))titleStyle;

/// 自定义message样式
- (KKAlertController *(^)(UIColor * _Nullable messageColor,
                          UIFont * _Nullable messageFont))messageStyle;
@end

NS_ASSUME_NONNULL_END
