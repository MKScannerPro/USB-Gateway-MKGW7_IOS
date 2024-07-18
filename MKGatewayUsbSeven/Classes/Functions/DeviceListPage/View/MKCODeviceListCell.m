//
//  MKCODeviceListCell.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCODeviceListCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCODeviceListModel.h"

@interface MKCODeviceListCell ()

@property (nonatomic, strong)UIImageView *wifiIcon;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UILabel *stateLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation MKCODeviceListCell

+ (MKCODeviceListCell *)initCellWithTableView:(UITableView *)tableView {
    MKCODeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCODeviceListCellIdenty"];
    if (!cell) {
        cell = [[MKCODeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCODeviceListCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(242, 242, 242);
        [self.contentView addSubview:self.wifiIcon];
        [self.contentView addSubview:self.deviceNameLabel];
        [self.contentView addSubview:self.stateLabel];
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.rightIcon];
        [self addLongPressEventAction];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.wifiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(32.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(32.f);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wifiIcon.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.stateLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(8.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wifiIcon.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.stateLabel.mas_left).mas_offset(-5.f);
        make.bottom.mas_equalTo(-8.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)longPressEventAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(co_cellDeleteButtonPressed:)]) {
        [self.delegate co_cellDeleteButtonPressed:self.indexPath.row];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCODeviceListModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCODeviceModel.class]) {
        return;
    }
    self.deviceNameLabel.text = SafeStr(_dataModel.deviceName);
    self.stateLabel.text = (_dataModel.onLineState == MKCODeviceModelStateOnline ? @"Online" : @"Offline");
    self.stateLabel.textColor = (_dataModel.onLineState == MKCODeviceModelStateOnline ? NAVBAR_COLOR_MACROS : UIColorFromRGB(0xcccccc));
    self.macLabel.text = SafeStr(_dataModel.macAddress);
    if (dataModel.onLineState == MKCODeviceModelStateOffline) {
        //设备离线
        self.wifiIcon.image = LOADICON(@"MKGatewayUsbSeven", @"MKCODeviceListCell", @"co_offline_wifi.png");
        return;
    }
    //设备在线
    if (_dataModel.wifiLevel >= -50) {
        //Good
        self.wifiIcon.image = LOADICON(@"MKGatewayUsbSeven", @"MKCODeviceListCell", @"co_good_wifi.png");
        return;
    }
    if (_dataModel.wifiLevel >= -65 && _dataModel.wifiLevel < -50) {
        //Medium
        self.wifiIcon.image = LOADICON(@"MKGatewayUsbSeven", @"MKCODeviceListCell", @"co_medium_wifi.png");
        return;
    }
    if (_dataModel.wifiLevel < -65) {
        //Poor
        self.wifiIcon.image = LOADICON(@"MKGatewayUsbSeven", @"MKCODeviceListCell", @"co_poor_wifi.png");
        return;
    }
}

#pragma mark - private method
- (void)addLongPressEventAction {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    [longPress addTarget:self action:@selector(longPressEventAction:)];
    [self.contentView addGestureRecognizer:longPress];
}

#pragma mark - getter
- (UIImageView *)wifiIcon {
    if (!_wifiIcon) {
        _wifiIcon = [[UIImageView alloc] init];
        _wifiIcon.image = LOADICON(@"MKGatewayUsbSeven", @"MKCODeviceListCell", @"co_offline_wifi.png");
    }
    return _wifiIcon;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(15.f);
    }
    return _deviceNameLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = UIColorFromRGB(0xcccccc);
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.font = MKFont(12.f);
        _stateLabel.text = @"Offline";
    }
    return _stateLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textAlignment = NSTextAlignmentLeft;
        _macLabel.textColor = UIColorFromRGB(0xcccccc);
        _macLabel.font = MKFont(14.f);
    }
    return _macLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"MKGatewayUsbSeven", @"MKCODeviceListCell", @"co_goNextButton.png");
    }
    return _rightIcon;
}

@end
