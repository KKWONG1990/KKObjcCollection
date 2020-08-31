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

@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * messageColor;
@property (nonatomic, strong) UIFont * titleFont;
@property (nonatomic, strong) UIFont * messageFont;
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
    [self customTitleStyle];
    [self customMessageStyle];
}

- (void)customTitleStyle {
    if (self.title == nil || [self.title isEqualToString:@""]) return;
    NSMutableAttributedString * titleAttributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
    if (self.titleColor) [titleAttributedString addAttributes:@{NSForegroundColorAttributeName : self.titleColor}
                                                        range:NSMakeRange(0, self.title.length)];
    if (self.titleFont) [titleAttributedString addAttributes:@{NSFontAttributeName : self.titleFont}
                                                       range:NSMakeRange(0, self.title.length)];
    [self setValue:titleAttributedString forKey:@"attributedTitle"];
}

- (void)customMessageStyle {
    if (self.message == nil || [self.message isEqualToString:@""]) return;
       NSMutableAttributedString * messageAttributedString = [[NSMutableAttributedString alloc] initWithString:self.message];
       if (self.messageColor) [messageAttributedString addAttributes:@{NSForegroundColorAttributeName : self.messageColor}
                                                           range:NSMakeRange(0, self.message.length)];
       if (self.messageFont) [messageAttributedString addAttributes:@{NSFontAttributeName : self.messageFont}
                                          range:NSMakeRange(0, self.message.length)];
       [self setValue:messageAttributedString forKey:@"attributedMessage"];
}

- (KKAlertController * _Nonnull (^)(NSString * _Nullable,
                                    UIAlertActionStyle,
                                    UIColor * _Nullable,
                                    ActionHandle))addAction {
    return ^(NSString * _Nullable title, UIAlertActionStyle actionStyle, UIColor * _Nullable titleColor, ActionHandle handle) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:actionStyle
                                                       handler:^(UIAlertAction * _Nonnull action) {
            ActionHandle handle  = [self.actionHandles valueForKey:[self fetchKeyFromHash:action.hash]];
            if (handle) handle(action);
        }];
        if (titleColor) [action setValue:titleColor forKey:@"_titleTextColor"];
        if (handle) [self.actionHandles addEntriesFromDictionary:@{[self fetchKeyFromHash:action.hash] : handle}];
        [self addAction:action];
        return self;
    };
}

- (KKAlertController * _Nonnull (^)(NSString * _Nullable, UIColor * _Nullable ,TextFieldHandle))addTextField {
    return ^(NSString * _Nullable placehoder, UIColor * _Nullable textColor, TextFieldHandle handle) {
        __weak typeof(self) weakSelf = self;
        [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            textField.placeholder   = placehoder;
            if (textColor) textField.textColor = textColor;
            [textField addTarget:strongSelf action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            if (handle) [strongSelf.textFieldHandles addEntriesFromDictionary:@{[strongSelf fetchKeyFromHash:textField.hash] : handle}];
        }];
        return self;
    };
}

- (KKAlertController * _Nonnull (^)(UIColor * _Nullable, UIFont * _Nullable))titleStyle {
    return ^(UIColor * _Nullable titleColor,
             UIFont * _Nullable titleFont) {
       self.titleColor     = titleColor;
       self.titleFont      = titleFont;
       return self;
   };
}

- (KKAlertController * _Nonnull (^)(UIColor * _Nullable, UIFont * _Nullable))messageStyle {
    return ^(UIColor * _Nullable messageColor,
             UIFont * _Nullable messageFont) {
        self.messageFont    = messageFont;
        self.messageColor   = messageColor;
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
