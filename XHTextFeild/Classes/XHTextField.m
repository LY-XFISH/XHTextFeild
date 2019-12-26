//
//  XHTextField.m
//  Travel
//
//  Created by LiuYu on 2018/7/17.
//  Copyright © 2018年 Nil. All rights reserved.
//

#import "XHTextField.h"

@interface XHTextField ()<UITextFieldDelegate>

@property (strong, nonatomic) NSArray *SYS_keyboardSTR;
@property (assign, nonatomic) BOOL isAddedObserver;

@end

// 匹配出数字
#define MATCH_NUMBER_RE      @"[0-9]"
// 匹配出中文
#define MATCH_CN_RE          @"[\u4E00-\u9FA5]"
// 匹配出英文
#define MATCH_EN_RE          @"[a-zA-Z]"
// 匹配出中文和英文
#define MATCH_ENCH_RE        @"[a-zA-Z\u4E00-\u9FA5]"
// 匹配出数字和字母
#define MATCH_NUMBER_EN_RE   @"[a-zA-Z0-9]"
// 匹配出数字和中文
#define MATCH_NUMBER_CN_RE   @"[0-9\u4E00-\u9FA5]"

@implementation XHTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseConfig];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseConfig];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseConfig];
    }
    return self;
}

/**
 基本配置
 */
- (void)baseConfig {
    [self addObserver];
    self.delegate = self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 删除键
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    // 键盘类型
    NSString *primaryLanguage = [[textField textInputMode] primaryLanguage];
    
    // emoji键盘不能输入
    if ([primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    
    // 系统键盘-九宫格输入
    if ([self.SYS_keyboardSTR containsObject:string]) {
        return YES;
    }
    
    NSString *matchStr = @"";
    
    switch (self.limit) {
        case XHTextFieldLimitNone:
            // do nothing....
            break;
        case XHTextFieldLimitNumber:
            matchStr = MATCH_NUMBER_ONLY;
            break;
        case XHTextFieldLimitEN:
            matchStr = MATCH_EN_ONLY;
            break;
        case XHTextFieldLimitCN:
            matchStr = MATCH_CN_ONLY;
            break;
        case (XHTextFieldLimitNumber | XHTextFieldLimitEN) :
            matchStr = MATCH_NUMBER_EN;
            break;
        case (XHTextFieldLimitNumber | XHTextFieldLimitCN) :
            matchStr = MATCH_NUMBER_CN;
            break;
        case (XHTextFieldLimitEN | XHTextFieldLimitCN) :
            matchStr = MATCH_ENCN;
            break;
        default:
            break;
    }
    
    if (!matchStr.length) {
        // 无限制
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textField:shouldChangeCharactersInRange:replacementString:)]) {
            return [_textFieldDelegate xh_textField:self shouldChangeCharactersInRange:range replacementString:string];
        }
        return YES;
    }
    
    // 过滤字符
    if (![XHTextField predicateText:string MatchStr:matchStr]) {
        return NO;
    }
    
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [_textFieldDelegate xh_textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (!textField.text.length) {
        return YES;
    }
    
    if (self.limit == XHTextFieldLimitNone) {
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldReturn:)]) {
            return [_textFieldDelegate xh_textFieldShouldReturn:self];
        }
        
        return YES;
    }
    
    if (self.limit == XHTextFieldLimitNumber) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_NUMBER_ONLY]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldReturn:)]) {
            return [_textFieldDelegate xh_textFieldShouldReturn:self];
        }
        
        return YES;
    }
    
    if (self.limit == XHTextFieldLimitEN) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_EN_ONLY]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldReturn:)]) {
            return [_textFieldDelegate xh_textFieldShouldReturn:self];
        }
        
        return YES;
    }
    
    if (self.limit == XHTextFieldLimitCN) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_CN_ONLY]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldReturn:)]) {
            return [_textFieldDelegate xh_textFieldShouldReturn:self];
        }
        
        return YES;
    }
    
    if (self.limit == (XHTextFieldLimitNumber | XHTextFieldLimitEN)) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_NUMBER_EN]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldReturn:)]) {
            return [_textFieldDelegate xh_textFieldShouldReturn:self];
        }
        
        return YES;
    }
    
    if (self.limit == (XHTextFieldLimitNumber | XHTextFieldLimitCN)) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_NUMBER_CN]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldReturn:)]) {
            return [_textFieldDelegate xh_textFieldShouldReturn:self];
        }
        
        return YES;
    }
    
    if (self.limit == (XHTextFieldLimitEN | XHTextFieldLimitCN)) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_ENCN]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldReturn:)]) {
            return [_textFieldDelegate xh_textFieldShouldReturn:self];
        }
        
        return YES;
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (!textField.text.length) {
        return YES;
    }
    
    if (self.limit == XHTextFieldLimitNone) {
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldEndEditing:)]) {
            return [_textFieldDelegate xh_textFieldShouldEndEditing:self];
        }
        
        return YES;
    }
    
    if (self.limit == XHTextFieldLimitNumber) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_NUMBER_ONLY]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldEndEditing:)]) {
            return [_textFieldDelegate xh_textFieldShouldEndEditing:self];
        }

        return YES;
    }
    
    if (self.limit == XHTextFieldLimitEN) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_EN_ONLY]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldEndEditing:)]) {
            return [_textFieldDelegate xh_textFieldShouldEndEditing:self];
        }
        
        return YES;
    }
    
    if (self.limit == XHTextFieldLimitCN) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_CN_ONLY]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldEndEditing:)]) {
            return [_textFieldDelegate xh_textFieldShouldEndEditing:self];
        }
        
        return YES;
    }
    
    if (self.limit == (XHTextFieldLimitNumber | XHTextFieldLimitEN)) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_NUMBER_EN]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldEndEditing:)]) {
            return [_textFieldDelegate xh_textFieldShouldEndEditing:self];
        }

        return YES;
    }
    
    if (self.limit == (XHTextFieldLimitNumber | XHTextFieldLimitCN)) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_NUMBER_CN]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldEndEditing:)]) {
            return [_textFieldDelegate xh_textFieldShouldEndEditing:self];
        }
        
        return YES;
    }
    
    if (self.limit == (XHTextFieldLimitEN | XHTextFieldLimitCN)) {
        
        if (![XHTextField predicateText:textField.text MatchStr:MATCH_ENCN]) {
            return NO;
        }
        
        [textField resignFirstResponder];
        
        if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldEndEditing:)]) {
            return [_textFieldDelegate xh_textFieldShouldEndEditing:self];
        }
        
        return YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldDidBeginEditing:)]) {
        return [_textFieldDelegate xh_textFieldShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldDidBeginEditing:)]) {
        [_textFieldDelegate xh_textFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldDidEndEditing:)]) {
        [_textFieldDelegate xh_textFieldDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldShouldClear:)]) {
        return [_textFieldDelegate xh_textFieldShouldClear:self];
    }
    return YES;
}

// MARK: - Public Methods

/**
 正则验证
 
 @param matchStr 正则表达式
 @return BOOL
 */
+ (BOOL)predicateText:(NSString *)text MatchStr:(NSString *)matchStr {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", matchStr];
    return [predicate evaluateWithObject:text];
}

// MARK: - Private Methods

/**
 过滤非法字符

 @param string 待过滤的字符串
 @param regexStr 过滤规则（正则）
 @return 过滤后的字符串
 */
- (NSString *)filterCharactor:(NSString *)string withReges:(NSString *)regexStr {
    
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error) {
        NSLog(@"Error : %@",error.localizedDescription);
        return string;
    }
    
    NSArray *resultArray = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];

    NSString *result = @"";
    
    for (NSTextCheckingResult *checkResult in resultArray) {
        
        NSLog(@"++++++++++++++++++++++>>>>>>>>>");
        
        for (int i = 0; i < checkResult.numberOfRanges; i ++) {
            
            NSRange range = [checkResult rangeAtIndex:i];
            
            NSString *checkStr = [string substringWithRange:range];
            
            NSLog(@"*********************************");
            NSLog(@"checkStr ===========> %@",checkStr);
            
            result = [result stringByAppendingString:checkStr];
        }
    }
    
    return result;
}


/**
 添加监听方法
 */
- (void)addObserver {
    
    if (self.isAddedObserver) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFeildTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.isAddedObserver = YES;
}

// MARK: Observer Methods

- (void)textFeildTextDidChanged:(NSNotification *)notice {
    
    UITextField *theTextFeild = (UITextField *)notice.object;
    
    if (![theTextFeild isEqual:self]) {
        return;
    }
    
    NSString *toBestring = theTextFeild.text;

    UITextRange *selectedRange = [theTextFeild markedTextRange];
    UITextPosition *position   = [theTextFeild positionFromPosition:selectedRange.start offset:0];

    // 非高亮输入 需要过滤字符
    if (!position) {
        
        if (self.limit == XHTextFieldLimitNone) {
            
        } else if (self.limit == XHTextFieldLimitEN) {
            theTextFeild.text = [self filterCharactor:toBestring withReges:MATCH_EN_RE];
        } else if (self.limit == XHTextFieldLimitCN) {
            theTextFeild.text = [self filterCharactor:toBestring withReges:MATCH_CN_RE];
        } else if (self.limit == XHTextFieldLimitNumber) {
            theTextFeild.text = [self filterCharactor:toBestring withReges:MATCH_NUMBER_RE];
        } else if (self.limit == (XHTextFieldLimitNumber | XHTextFieldLimitEN)) {
            theTextFeild.text = [self filterCharactor:toBestring withReges:MATCH_NUMBER_EN_RE];
        } else if (self.limit == (XHTextFieldLimitNumber | XHTextFieldLimitCN)) {
            theTextFeild.text = [self filterCharactor:toBestring withReges:MATCH_NUMBER_CN_RE];
        } else if (self.limit == (XHTextFieldLimitEN | XHTextFieldLimitCN)) {
            theTextFeild.text = [self filterCharactor:toBestring withReges:MATCH_ENCH_RE];
        }
        
        // 限制长度
        if ((theTextFeild.text.length > self.maxLength) && (self.maxLength > 0)) {
            theTextFeild.text = [theTextFeild.text substringToIndex:self.maxLength];
        }
    }
    
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(xh_textFieldTextDidChanged:)]) {
        [_textFieldDelegate xh_textFieldTextDidChanged:self];
    }
    
    // do  nothing ...
}

// MARK: - Lazy Load

/**
 搜狗输入法-中文输入占位符
 */
- (NSArray *)SYS_keyboardSTR {
    if (!_SYS_keyboardSTR) {
        _SYS_keyboardSTR = @[@"➋",@"➌",@"➍",@"➎",@"➏",@"➐",@"➑",@"➒"];
    }
    return _SYS_keyboardSTR;
}

@end



