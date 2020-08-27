//
//  KKAlertController.m
//  AQGDemo
//
//  Created by BYMac on 2020/8/20.
//  Copyright © 2020 BYMac. All rights reserved.
//

#import "KKAlertController.h"
@interface KKAlertController ()

/// 保存 textField block
@property (nonatomic, strong) NSMutableDictionary * textFieldHandles;

/// 保存 action block
@property (nonatomic, strong) NSMutableDictionary * actionHandles;
@end

@implementation KKAlertController
+ (KKAlertController * _Nonnull (^)(NSString * _Nullable,
                                    NSString * _Nullable,
                                    UIAlertControllerStyle))init {
    return ^(NSString * title, NSString * message, UIAlertControllerStyle preferredStyle){
        return [super alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (KKAlertController * _Nonnull (^)(NSString * _Nullable,
                                    UIAlertActionStyle,
                                    ActionHandle))addAction {
    return ^(NSString * _Nullable title, UIAlertActionStyle actionStyle, ActionHandle handle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:actionStyle
                                                       handler:^(UIAlertAction * _Nonnull action) {
            ActionHandle handle  = [self.actionHandles valueForKey:[self fetchKeyFromHash:action.hash]];
            if (handle) handle(action);
        }];
        [self addAction:action];
        if (handle) {
            [self.actionHandles addEntriesFromDictionary:@{[self fetchKeyFromHash:action.hash] : handle}];
        }
        return self;
    };
}

- (KKAlertController * _Nonnull (^)(NSString * _Nullable, TextFieldHandle))addTextField {
    return ^(NSString * _Nullable placehoder, TextFieldHandle handle) {
        __weak typeof(self) weakSelf = self;
        [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            textField.placeholder   = placehoder;
            [textField addTarget:strongSelf action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            if (handle) {
                [strongSelf.textFieldHandles addEntriesFromDictionary:@{
                    [strongSelf fetchKeyFromHash:textField.hash] : handle
                }];
            }
        }];
        return self;
    };
}

#pragma mark - 监听文本框的输入进行回调
- (void)textFieldEditingChanged:(UITextField *)textField {
    TextFieldHandle handle  = [self.textFieldHandles valueForKey:[self fetchKeyFromHash:textField.hash]];
    if (handle) handle(textField);
}

#pragma mark - 哈希码转字符串
- (NSString *)fetchKeyFromHash:(NSUInteger)hash {
    return [NSString stringWithFormat:@"%lu",(unsigned long)hash];
}

- (NSMutableDictionary *)actionHandles {
    if (!_actionHandles) {
        _actionHandles = [NSMutableDictionary dictionary];
    }
    return _actionHandles;;
}

- (NSMutableDictionary *)textFieldHandles {
    if (!_textFieldHandles) {
        _textFieldHandles = [NSMutableDictionary dictionary];
    }
    return _textFieldHandles;;
}

@end
