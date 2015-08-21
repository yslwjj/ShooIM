//
//  SAMRegisterViewController.m
//  ShooIM
//
//  Created by 杨森 on 15/8/21.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import "SAMRegisterViewController.h"
#import "SAMKeyboardTool.h"

@interface SAMRegisterViewController ()<UITextFieldDelegate,SAMKeyboardToolDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

/** 存放所有数组 */
@property (nonatomic, strong) NSArray *textFields;

/** keyboardTool */
@property (nonatomic, strong) SAMKeyboardTool *keyboardTool;

@end

@implementation SAMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"註冊";
    self.textFields = @[self.mailTextField,self.phoneNumTextField,self.userNameTextField,self.birthdayTextField,self.pwdTextField];
}

#pragma mark - 注册用户
- (IBAction)registerUser {
    
}

#pragma mark - 键盘工具栏的代理方法
- (void)keyboardTool:(SAMKeyboardTool *)tool didClickItem:(SAMKeyboardToolItem)item
{
    int index = 0;
    if (item == SAMKeyboardToolItemPrevious) {
        for (int i = 0; i < self.textFields.count; i++) {
            UIView *view = self.textFields[i];
            if ([view isFirstResponder]) {
                index = i;
                [self.textFields[index-1] becomeFirstResponder];
                return;
            }
        }
        
    } else if (item == SAMKeyboardToolItemNext) {
        for (int i = 0; i < self.textFields.count; i++) {
            UIView *view = self.textFields[i];
            if ([view isFirstResponder]) {
                index = i;
                [self.textFields[index+1] becomeFirstResponder];
                return;
            }
        }
    } else if (item == SAMKeyboardToolItemDone) {
        [self.view endEditing:YES];
        [self registerUser];
    }
}


#pragma mark - <UITextViewDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SAMKeyboardTool *tool = [SAMKeyboardTool tool];
    self.keyboardTool = tool;
    textField.inputAccessoryView = tool;
    tool.toolbarDelegate = self;
    
    return YES;
    
}

/**
 * 当点击键盘右下角的return key时,就会调用这个方法
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.mailTextField) {
        [self.phoneNumTextField becomeFirstResponder];
    } else if (textField == self.phoneNumTextField) {
        [self.userNameTextField becomeFirstResponder];
    } else if (textField == self.userNameTextField) {
        [self.birthdayTextField becomeFirstResponder];
    } else if (textField == self.birthdayTextField) {
        [self.pwdTextField becomeFirstResponder];
    } else if (textField == self.pwdTextField) {
        [self.view endEditing:YES];
        [self registerUser];
    }
    
    return YES;
}

/**
 * 键盘弹出就会调用这个方法
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger currentIndex = [self.textFields indexOfObject:textField];
    
    self.keyboardTool.previousItem.enabled = (currentIndex != 0);
    self.keyboardTool.nextItem.enabled = (currentIndex != self.textFields.count - 1);
}

#pragma mark - 结束第一响应者
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
