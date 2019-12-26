//
//  XHTextField.h
//  Lius.Yu
//
//  Created by LiuYu on 2018/7/17.
//  Copyright © 2018年 Nil. All rights reserved.
//  自带限制的输入框

#import <UIKit/UIKit.h>

@class XHTextField;
@protocol XHTextFieldDelegate <NSObject>

@optional;

- (BOOL)xh_textFieldShouldBeginEditing:(XHTextField *)textField;
- (void)xh_textFieldDidBeginEditing:(XHTextField *)textField;
- (BOOL)xh_textFieldShouldEndEditing:(XHTextField *)textField;
- (void)xh_textFieldDidEndEditing:(XHTextField *)textField;

- (BOOL)xh_textField:(XHTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL)xh_textFieldShouldClear:(XHTextField *)textField;
- (BOOL)xh_textFieldShouldReturn:(XHTextField *)textField;

- (void)xh_textFieldTextDidChanged:(XHTextField *)textField;

@end

// ----- Limit

// 是否是英文
#define MATCH_EN_ONLY        @"(^[a-zA-Z]+$)"
// 是否是中文
#define MATCH_CN_ONLY        @"(^[\u4E00-\u9FA5]+$)"
// 是否是数字
#define MATCH_NUMBER_ONLY    @"(^[0-9]+$)"
// 是否是中文或英文
#define MATCH_ENCN           @"(^[a-zA-Z\u4E00-\u9FA5]+$)"
// 是否是数字或英文
#define MATCH_NUMBER_EN      @"(^[a-zA-Z0-9]+$)"
// 是否是数字或中文
#define MATCH_NUMBER_CN      @"(^[0-9\u4E00-\u9FA5]+$)"

IB_DESIGNABLE

/**
 输入限制
 */
typedef NS_ENUM(NSUInteger, XHTextFieldLimit) {
    
    XHTextFieldLimitNone    = 0,        /**< 无限制 */
    XHTextFieldLimitNumber  = 1 << 0,   /**< 许可数字输入 */
    XHTextFieldLimitEN      = 1 << 1,   /**< 许可英文输入 */
    XHTextFieldLimitCN      = 1 << 2,   /**< 许可中文输入 */
    
};

@interface XHTextField : UITextField

#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger maxLength;
#endif

@property (assign, nonatomic) NSUInteger maxLength;     /**< 最大输入长度 */

@property (assign, nonatomic) XHTextFieldLimit limit;   /**< 输入限制类型 */

@property (weak,   nonatomic) id<XHTextFieldDelegate> textFieldDelegate;

/**
 正则验证
 
 @param matchStr 正则表达式
 @return BOOL
 */
+ (BOOL)predicateText:(NSString *)text MatchStr:(NSString *)matchStr;

@end

