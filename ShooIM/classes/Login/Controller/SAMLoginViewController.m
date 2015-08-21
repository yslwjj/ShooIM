//
//  SAMLoginViewController.m
//  ShooIM
//
//  Created by 杨森 on 15/8/20.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import "SAMLoginViewController.h"
#import "SAMRegisterViewController.h"
#import "SAMKeyboardTool.h"
#import "SAMMainViewController.h"

@interface SAMLoginViewController ()<UITextFieldDelegate,SAMKeyboardToolDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

/** 保存所有的textField */
@property (nonatomic, strong) NSArray *textFields;

/** keyboardTool */
@property (nonatomic, strong) SAMKeyboardTool *keyboardTool;

@end

@implementation SAMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登錄";
    self.textFields = @[self.mailTextField,self.pwdTextField];

}

#pragma mark - 註冊用戶
- (IBAction)registerUser {
    
    // 進入註冊界面
    SAMRegisterViewController *registerVC = [[SAMRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];

}

#pragma mark - 忘記密碼

- (IBAction)forgetPassword {
    
}

#pragma mark - 登錄

- (IBAction)login {
    SAMMainViewController * main = [[SAMMainViewController alloc] init];
    [self.navigationController pushViewController:main animated:YES];
    main.navigationItem.leftBarButtonItem.customView = [[UIView alloc] init];
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
        [self login];
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
        [self.pwdTextField becomeFirstResponder];
    } else if (textField == self.pwdTextField) {
        [self.view endEditing:YES];
        [self login];
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






