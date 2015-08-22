//
//  SAMRegisterViewController.m
//  ShooIM
//
//  Created by 杨森 on 15/8/21.
//  Copyright (c) 2015年 samyang. All rights reserved.
//

#import "SAMRegisterViewController.h"
#import "SAMKeyboardTool.h"
#import <AFNetworking.h>
#import "SAMMainViewController.h"

@interface SAMRegisterViewController ()<UITextFieldDelegate,SAMKeyboardToolDelegate>
{
    NSString *_state;
}
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerShowBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneShowBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordShowBtn;

@property (nonatomic, weak) UIDatePicker *datePicker;

/** 存放所有数组 */
@property (nonatomic, strong) NSArray *textFields;

/** keyboardTool */
@property (nonatomic, strong) SAMKeyboardTool *keyboardTool;


/** manager */
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation SAMRegisterViewController

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer.acceptableContentTypes=[_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"註冊";
    self.textFields = @[self.mailTextField,self.phoneNumTextField,self.userNameTextField,self.birthdayTextField,self.pwdTextField];
    
    [self setUpBirthdayKeyboard];
}

#pragma mark - 自定义生日键盘
- (void)setUpBirthdayKeyboard
{
    // 创建UIDatePicker
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    
    _datePicker = picker;
    
    // 设置地区 zh:中国
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    // 设置日期的模式
    picker.datePickerMode = UIDatePickerModeDate;
    
 
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    picker.date = [fmt dateFromString:@"1990-01-01"];
   
    // 监听UIDatePicker的滚动
    [picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    _birthdayTextField.inputView = picker;
}

/**
 *  当UIDatePicker滚动的时候调用给生日文本框赋值
 */
- (void)dateChange:(UIDatePicker *)datePicker
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:datePicker.date];
    
    _birthdayTextField.text = dateStr;
}


#pragma mark - 注册用户
- (IBAction)registerUser {
    if ([_mailTextField.text isEqualToString: @""] ||
        [_phoneNumTextField.text isEqualToString: @""] ||
        [_userNameTextField.text isEqualToString: @""] ||
        [_pwdTextField.text  isEqualToString: @""] ||
        [_birthdayTextField.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"請填寫完整信息再註冊！"];
    } else {
        [self registerNetworkRequest];
    }
}

#pragma mark - 註冊功能網絡請求
- (void)registerNetworkRequest
{
    [MBProgressHUD showMessage:nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"email"] = self.mailTextField.text;
    params[@"password"] = self.pwdTextField.text.md5String;
    params[@"mobile_phone"] = self.phoneNumTextField.text;
    params[@"name"] = self.userNameTextField.text;
    params[@"birthday"] = self.birthdayTextField.text;
    
    NSString *webAddress = [NSString stringWithFormat:@"%@%@",webServiceName,@"FmemberApply.asp"];
    
    
    [manager POST:webAddress parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUD];
        NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
        
        if ([state isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"註冊成功"];
            
            // 跳轉到主控制器
            [SAMCommon MoveToMainViewController];
            
        } else if ([state isEqualToString:@"1"]){
            [MBProgressHUD showError:@"Email或者手機號已經被註冊"];
    
        } else {
            [MBProgressHUD showError:@"註冊錯誤"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        
        if (![SAMCommon connectedToNetwork]) {
            [MBProgressHUD showError:@"網絡連接錯誤"];
        } else {
            [MBProgressHUD showError:@"註冊錯誤"];
        }
        
    }];

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
    }
}


#pragma mark - <UITextViewDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SAMKeyboardTool *tool = [SAMKeyboardTool tool];
    self.keyboardTool = tool;
    textField.inputAccessoryView = tool;
    tool.toolbarDelegate = self;
    
    if (textField == _mailTextField) {
        [_registerShowBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if (textField == _pwdTextField) {
        [_passwordShowBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if (textField == _phoneNumTextField) {
        [_phoneShowBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
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
    
    // 给生日文本框赋值
    [self dateChange:_datePicker];
}

// 是否允许用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.birthdayTextField) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (textField != self.mailTextField && textField != self.phoneNumTextField && textField != self.pwdTextField) {
            return ; // 不需要判断
        } else if (textField == self.mailTextField) {
            
            [self checkMail];

        } else if (textField == self.phoneNumTextField) {
            
            [self checkPhoneNumber];
            
        }  else if (textField == self.pwdTextField) {
            // 密碼不符合要求
            if (![SAMCommon isValidatePassword:_pwdTextField.text] )
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_passwordShowBtn setTitle:@"密碼不符合要求" forState:UIControlStateNormal];
                });
                return;
            }
            
        }
    });

}

#pragma mark - 檢測郵箱
- (void)checkMail
{
    // 检测邮箱是否有效
    if ([SAMCommon isValidateEmail:_mailTextField.text])
    {
        /**
         *  state = 0,可以使用
         *  state = 1 or 2, 已經被使用
         */
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"email"] = self.mailTextField.text;
        
        NSString *webAddress = [NSString stringWithFormat:@"%@%@",webServiceName,@"Fcheck_email.asp"];
        
        
        [self.manager POST:webAddress parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
            if ([_state isEqualToString:@"0"]) {
                [_registerShowBtn setTitle:@"可註冊" forState:UIControlStateNormal];
            } else if ([_state isEqualToString:@"1"] || [_state isEqualToString:@"2"]) {
                [_registerShowBtn setTitle:@"已被使用" forState:UIControlStateNormal];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_registerShowBtn setTitle:@"郵箱不符合要求" forState:UIControlStateNormal];
        });
        return;
    }

}

#pragma mark - 檢測電腦號碼
- (void)checkPhoneNumber
{
    // 檢測
    if ([SAMCommon isValidateMobile:self.phoneNumTextField.text] || [SAMCommon isValidateTWMobile:_phoneNumTextField.text])
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"phone"] = self.phoneNumTextField.text;
        
        NSString *webAddress = [NSString stringWithFormat:@"%@%@",webServiceName,@"Fcheck_mobile.asp"];
        
        
        [self.manager POST:webAddress parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _state = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
            if ([_state isEqualToString:@"0"]) {
                [_phoneShowBtn setTitle:@"可註冊" forState:UIControlStateNormal];
            } else if ([_state isEqualToString:@"1"] || [_state isEqualToString:@"2"]) {
                [_phoneShowBtn setTitle:@"已被使用" forState:UIControlStateNormal];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_phoneShowBtn setTitle:@"手機號碼不符合要求" forState:UIControlStateNormal];
        });
        return;
    }

}


#pragma mark - 结束第一响应者
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
