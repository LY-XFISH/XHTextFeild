//
//  XHViewController.m
//  XHTextFeild
//
//  Created by 18382434902 on 12/26/2019.
//  Copyright (c) 2019 18382434902. All rights reserved.
//

#import "XHViewController.h"
#import "XHTextFeild/XHTextField.h"

@interface XHViewController ()<XHTextFieldDelegate>

@property (weak, nonatomic) IBOutlet XHTextField *textFeild;

@end

@implementation XHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textFeild.textFieldDelegate = self;
    self.textFeild.limit = XHTextFieldLimitCN;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - XHTextFieldDelegate

- (void)xh_textFieldTextDidChanged:(XHTextField *)textField {
    NSLog(@"%@",textField.text);
}

- (BOOL)xh_textField:(XHTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}



@end
