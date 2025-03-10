//
//  MKCOSyncDeviceCell.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2025/3/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKCOSyncDeviceCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

@implementation MKCOSyncDeviceCellModel
@end

@interface MKCOSyncDeviceCell ()

@property (nonatomic, strong)UIControl *backBtn;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UIImageView *icon;

@end

@implementation MKCOSyncDeviceCell

+ (MKCOSyncDeviceCell *)initCellWithTableView:(UITableView *)tableView {
    MKCOSyncDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCOSyncDeviceCellIdenty"];
    if (!cell) {
        cell = [[MKCOSyncDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCOSyncDeviceCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backBtn];
        [self.backBtn addSubview:self.deviceNameLabel];
        [self.backBtn addSubview:self.macLabel];
        [self.backBtn addSubview:self.icon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.icon.mas_left).mas_offset(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.icon.mas_left).mas_offset(-15.f);
        make.bottom.mas_equalTo(-10.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
}

#pragma mark - event method
- (void)backBtnPressed {
    self.backBtn.selected = !self.backBtn.selected;
    [self updateIcon];
    if ([self.delegate respondsToSelector:@selector(co_syncDeviceCell_selected:index:)]) {
        [self.delegate co_syncDeviceCell_selected:self.backBtn.selected index:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCOSyncDeviceCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCOSyncDeviceCellModel.class]) {
        return;
    }
    self.deviceNameLabel.text = SafeStr(_dataModel.deviceName);
    self.macLabel.text = SafeStr(_dataModel.macAddress);
    self.backBtn.selected = _dataModel.selected;
    [self updateIcon];
}

#pragma mark - Private method
- (void)updateIcon {
    UIImage *btnIcon = (self.backBtn.selected ? LOADICON(@"MKGatewayUsbSeven", @"MKCOSyncDeviceCell", @"co_listButtonSelectedIcon.png") : LOADICON(@"MKGatewayUsbSeven", @"MKCOSyncDeviceCell", @"co_listButtonUnselectedIcon.png"));
    [self.icon setImage:btnIcon];
}

#pragma mark - getter
- (UIControl *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIControl alloc] init];
        [_backBtn addTarget:self
                     action:@selector(backBtnPressed)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
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

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textColor = DEFAULT_TEXT_COLOR;
        _macLabel.textAlignment = NSTextAlignmentLeft;
        _macLabel.font = MKFont(12.f);
    }
    return _macLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

@end
