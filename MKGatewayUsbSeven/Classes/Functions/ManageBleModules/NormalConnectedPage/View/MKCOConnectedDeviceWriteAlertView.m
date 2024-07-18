//
//  MKCOConnectedDeviceWriteAlertView.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCOConnectedDeviceWriteAlertView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKTextField.h"

static CGFloat const buttonHeight = 45.f;
static CGFloat const textFieldHeight = 30.f;

@interface MKCOConnectedDeviceWriteAlertView ()

@property (nonatomic, strong)UIView *centerView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)UIView *verticalLine;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, copy)void (^confirmBlock) (NSString *textValue);

@property (nonatomic, copy)void (^cancelBlock) (void);

@end

@implementation MKCOConnectedDeviceWriteAlertView

- (void)dealloc {
    NSLog(@"MKCOConnectedDeviceWriteAlertView销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        [self addSubview:self.centerView];
    }
    return self;
}

#pragma mark - event method

- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)confirmButtonPressed {
    if (self.confirmBlock) {
        self.confirmBlock(SafeStr(self.textField.text));
    }
    [self dismiss];
}

#pragma mark - public method
- (void)showAlertWithValue:(NSString *)value
               dismissNote:(NSString *)dismissNote
              cancelAction:(void (^)(void))cancelAction
             confirmAction:(void (^)(NSString *textValue))confirmAction {
    [kAppWindow addSubview:self];
    if (ValidStr(dismissNote)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss)
                                                     name:dismissNote
                                                   object:nil];
    }
    
    self.cancelBlock = cancelAction;
    self.confirmBlock = confirmAction;
    
    [self.centerView addSubview:self.titleLabel];
    [self.centerView addSubview:self.messageLabel];
    [self.centerView addSubview:self.textField];
    [self.centerView addSubview:self.horizontalLine];
    [self.centerView addSubview:self.verticalLine];
    [self.centerView addSubview:self.cancelButton];
    [self.centerView addSubview:self.confirmButton];
    
    [self setupSubViews];
}

#pragma mark - private method

- (void)setupSubViews {
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-90.f);
        make.height.mas_equalTo(150.f);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(18.f).lineHeight);
    }];
    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.width.mas_equalTo(25.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.messageLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
    
    //两个按钮
    [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(30.f);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.verticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerView.mas_centerX);
        make.width.mas_equalTo(CUTTING_LINE_HEIGHT);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.verticalLine.mas_left);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.verticalLine.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - getter
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = RGBCOLOR(234, 234, 234);
        
        _centerView.layer.masksToBounds = YES;
        _centerView.layer.cornerRadius = 8.f;
    }
    return _centerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleLabel.font = MKFont(18.f);
        _titleLabel.text = @"Write value";
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = DEFAULT_TEXT_COLOR;
        _messageLabel.font = MKFont(14.f);
        _messageLabel.text = @"0x";
    }
    return _messageLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_hexCharOnly];
        _textField.backgroundColor = COLOR_WHITE_MACROS;
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.font = MKFont(14.f);
        _textField.textAlignment = NSTextAlignmentLeft;
    }
    return _textField;
}

- (UIView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = RGBCOLOR(53, 53, 53);
    }
    return _horizontalLine;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = RGBCOLOR(53, 53, 53);
    }
    return _verticalLine;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [self loadButtonWithTitle:@"Cancel" selector:@selector(dismiss)];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [self loadButtonWithTitle:@"Confirm" selector:@selector(confirmButtonPressed)];
    }
    return _confirmButton;
}

- (UIButton *)loadButtonWithTitle:(NSString *)title selector:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:COLOR_BLUE_MARCROS forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
