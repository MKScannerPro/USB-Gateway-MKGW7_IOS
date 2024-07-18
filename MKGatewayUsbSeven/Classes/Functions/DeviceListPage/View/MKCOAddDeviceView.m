//
//  MKCOAddDeviceView.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCOAddDeviceView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@interface MKCOAddDeviceView ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *centerIcon;

@end

@implementation MKCOAddDeviceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.msgLabel];
        [self addSubview:self.centerIcon];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(52.f);
        make.height.mas_equalTo(MKFont(18.f).lineHeight);
    }];
    [self.centerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(110.f);
    }];
}

#pragma mark - setter & getter
- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.textColor = UIColorFromRGB(0x0188cc);
        _msgLabel.font = MKFont(18.f);
        _msgLabel.text = @"Please add new device!";
    }
    return _msgLabel;
}

- (UIImageView *)centerIcon{
    if (!_centerIcon) {
        _centerIcon = [[UIImageView alloc] init];
        _centerIcon.image = LOADICON(@"MKGatewayUsbSeven", @"MKCOAddDeviceView", @"co_deviceList_centerIcon.png");
    }
    return _centerIcon;
}

@end
