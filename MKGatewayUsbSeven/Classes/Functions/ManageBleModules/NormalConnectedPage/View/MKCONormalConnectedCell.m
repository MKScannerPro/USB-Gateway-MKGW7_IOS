//
//  MKCONormalConnectedCell.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCONormalConnectedCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKCONormalConnectedCellModel

- (CGFloat)cellHeightWithWidth:(CGFloat)viewWidth {
    NSString *charMsg = [NSString stringWithFormat:@"%@%@",@"Characteristics UUID: 0x",[SafeStr(self.characteristic) uppercaseString]];
    CGSize characteristicSize = [NSString sizeWithText:charMsg
                                               andFont:MKFont(15.f)
                                            andMaxSize:CGSizeMake(viewWidth - 2 * 15.f, MAXFLOAT)];
    NSString *binary = [self.properties binaryByhex];
    NSMutableArray *propertiesMsgList = [NSMutableArray array];
    BOOL read = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
    if (read) {
        [propertiesMsgList addObject:@"READ"];
    }
    BOOL writeNoRespond = [[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
    if (writeNoRespond) {
        [propertiesMsgList addObject:@"WRITE NO RESPONSE"];
    }
    BOOL write = [[binary substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
    if (write) {
        [propertiesMsgList addObject:@"WRITE"];
    }
    BOOL notify = [[binary substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
    if (notify) {
        if (propertiesMsgList.count > 0) {
            [propertiesMsgList insertObject:@"NOTIFY" atIndex:0];
        }else {
            [propertiesMsgList addObject:@"NOTIFY"];
        }
    }
    NSString *propertiesMsg = @"Properties:";
    for (NSInteger i = 0; i < propertiesMsgList.count; i ++) {
        if (i == 0) {
            //第一个
            propertiesMsg = [propertiesMsg stringByAppendingString:propertiesMsgList[i]];
        }else {
            //第二个，需要添加','
            propertiesMsg = [NSString stringWithFormat:@"%@,%@",propertiesMsg,propertiesMsgList[i]];
        }
    }
    CGSize propertyLabelSize = [NSString sizeWithText:propertiesMsg
                                              andFont:MKFont(13.f)
                                           andMaxSize:CGSizeMake(viewWidth - 2 * 15.f - 120.f, MAXFLOAT)];
    NSString *valueMsg = [NSString stringWithFormat:@"%@%@",@"Value: 0x",[SafeStr(self.value) uppercaseString]];
    CGSize valueSize = [NSString sizeWithText:valueMsg
                                      andFont:MKFont(13.f)
                                   andMaxSize:CGSizeMake(viewWidth - 2 * 15.f, MAXFLOAT)];
    //top = 10.f  bottom = 10.f 每个label上下间隔10.f
    return (5 * 10.f + characteristicSize.height + propertyLabelSize.height + valueSize.height);
}

@end

@interface MKCONormalConnectedCell ()

@property (nonatomic, strong)UILabel *characteristicLabel;

@property (nonatomic, strong)UILabel *propertyLabel;

@property (nonatomic, strong)UIButton *writeButton;

@property (nonatomic, strong)UIButton *readButton;

@property (nonatomic, strong)UIButton *notifyButton;

@property (nonatomic, strong)UILabel *valueLabel;

@end

@implementation MKCONormalConnectedCell

+ (MKCONormalConnectedCell *)initCellWithTableView:(UITableView *)tableView {
    MKCONormalConnectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCONormalConnectedCellIdenty"];
    if (!cell) {
        cell = [[MKCONormalConnectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCONormalConnectedCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.characteristicLabel];
        [self.contentView addSubview:self.propertyLabel];
        [self.contentView addSubview:self.writeButton];
        [self.contentView addSubview:self.readButton];
        [self.contentView addSubview:self.notifyButton];
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
}

#pragma mark - event method
- (void)writeButtonPressed {
    if ([self.delegate respondsToSelector:@selector(co_normalConnectedCell_writeButtonPressed:row:serverUUID:characteristic:)]) {
        [self.delegate co_normalConnectedCell_writeButtonPressed:self.dataModel.section
                                                             row:self.dataModel.row
                                                      serverUUID:self.dataModel.server
                                                  characteristic:self.dataModel.characteristic];
    }
}

- (void)readButtonPressed {
    if ([self.delegate respondsToSelector:@selector(co_normalConnectedCell_readButtonPressed:row:serverUUID:characteristic:)]) {
        [self.delegate co_normalConnectedCell_readButtonPressed:self.dataModel.section
                                                            row:self.dataModel.row
                                                     serverUUID:self.dataModel.server
                                                 characteristic:self.dataModel.characteristic];
    }
}

- (void)notifyButtonPressed {
    if ([self.delegate respondsToSelector:@selector(co_normalConnectedCell_notifyButtonPressed:section:row:serverUUID:characteristic:)]) {
        [self.delegate co_normalConnectedCell_notifyButtonPressed:!self.notifyButton.selected
                                                          section:self.dataModel.section
                                                              row:self.dataModel.row
                                                       serverUUID:self.dataModel.server
                                                   characteristic:self.dataModel.characteristic];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCONormalConnectedCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCONormalConnectedCellModel.class]) {
        return;
    }
    self.characteristicLabel.text = [NSString stringWithFormat:@"%@%@",@"Characteristics UUID: 0x",[SafeStr(_dataModel.characteristic) uppercaseString]];
    if (ValidStr(_dataModel.value)) {
        self.valueLabel.text = [NSString stringWithFormat:@"%@%@",@"Value: 0x",[SafeStr(_dataModel.value) uppercaseString]];
    }else {
        self.valueLabel.text = @"Value:";
    }
    
    [self.notifyButton setImage:LOADICON(@"MKGatewayUsbSeven", @"MKCONormalConnectedCell", @"co_characteristic_notifyIcon.png") forState:UIControlStateNormal];
    self.notifyButton.selected = NO;
    if (_dataModel.notifyStatus == 1) {
        //打开了监听
        [self.notifyButton setImage:LOADICON(@"MKGatewayUsbSeven", @"MKCONormalConnectedCell", @"co_characteristic_receiveIcon.png") forState:UIControlStateNormal];
        self.notifyButton.selected = YES;
    }
    [self loadSubViews];
}

#pragma mark - UI
- (void)loadSubViews {
    if (self.characteristicLabel.superview) {
        [self.characteristicLabel removeFromSuperview];
    }
    [self.contentView addSubview:self.characteristicLabel];
    CGSize characteristicSize = [NSString sizeWithText:self.characteristicLabel.text
                                               andFont:self.characteristicLabel.font
                                            andMaxSize:CGSizeMake(self.contentView.frame.size.width - 2 * 15.f, MAXFLOAT)];
    [self.characteristicLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(characteristicSize.height);
    }];
    [self setupPropertiesViews];
    if (self.valueLabel.superview) {
        [self.valueLabel removeFromSuperview];
    }
    [self.contentView addSubview:self.valueLabel];
    CGSize valueSize = [NSString sizeWithText:self.valueLabel.text
                                      andFont:self.valueLabel.font
                                   andMaxSize:CGSizeMake(self.contentView.frame.size.width - 2 * 15.f, MAXFLOAT)];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-10.f);
        make.height.mas_equalTo(valueSize.height);
    }];
}

- (void)setupPropertiesViews {
    if (self.writeButton.superview) {
        [self.writeButton removeFromSuperview];
    }
    if (self.readButton.superview) {
        [self.readButton removeFromSuperview];
    }
    if (self.notifyButton.superview) {
        [self.notifyButton removeFromSuperview];
    }
    NSString *binary = [self.dataModel.properties binaryByhex];
    NSMutableArray *buttonList = [NSMutableArray array];
    NSMutableArray *propertiesMsgList = [NSMutableArray array];
    BOOL read = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
    if (read) {
        [buttonList addObject:self.readButton];
        [propertiesMsgList addObject:@"READ"];
    }
    BOOL writeNoRespond = [[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
    if (writeNoRespond) {
        [propertiesMsgList addObject:@"WRITE NO RESPONSE"];
    }
    BOOL write = [[binary substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
    if (write) {
        [propertiesMsgList addObject:@"WRITE"];
    }
    if (write || writeNoRespond) {
        [buttonList addObject:self.writeButton];
    }
    BOOL notify = [[binary substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
    if (notify) {
        [buttonList addObject:self.notifyButton];
        if (propertiesMsgList.count > 0) {
            [propertiesMsgList insertObject:@"NOTIFY" atIndex:0];
        }else {
            [propertiesMsgList addObject:@"NOTIFY"];
        }
    }
    if (self.propertyLabel.superview) {
        [self.propertyLabel removeFromSuperview];
    }
    [self.contentView addSubview:self.propertyLabel];
    NSString *msg = @"Properties:";
    for (NSInteger i = 0; i < propertiesMsgList.count; i ++) {
        if (i == 0) {
            //第一个
            msg = [msg stringByAppendingString:propertiesMsgList[i]];
        }else {
            //第二个，需要添加','
            msg = [NSString stringWithFormat:@"%@,%@",msg,propertiesMsgList[i]];
        }
    }
    self.propertyLabel.text = msg;
    CGSize propertyLabelSize = [NSString sizeWithText:self.propertyLabel.text
                                              andFont:self.propertyLabel.font
                                           andMaxSize:CGSizeMake(self.contentView.frame.size.width - 2 * 15.f - 120.f, MAXFLOAT)];
    [self.propertyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-120.f);
        make.top.mas_equalTo(self.characteristicLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(propertyLabelSize.height);
    }];
    if (buttonList.count == 0) {
        //没有属性按钮
        return;
    }
    //存在按钮
    //先取最后一个按钮，放在最右侧的位置
    UIButton *lastButton = [buttonList lastObject];
    [self.contentView addSubview:lastButton];
    [lastButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(self.characteristicLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [buttonList removeLastObject];
    if (buttonList.count == 0) {
        //一个按钮
        return;
    }
    UIButton *centerButton = [buttonList lastObject];
    [self.contentView addSubview:centerButton];
    [centerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lastButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(lastButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [buttonList removeLastObject];
    if (buttonList.count == 0) {
        //两个按钮
        return;
    }
    //三个按钮
    UIButton *leftButton = [buttonList lastObject];
    [self.contentView addSubview:leftButton];
    [leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(centerButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(lastButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [buttonList removeLastObject];
}

#pragma mark - getter
- (UILabel *)characteristicLabel {
    if (!_characteristicLabel) {
        _characteristicLabel = [[UILabel alloc] init];
        _characteristicLabel.textColor = DEFAULT_TEXT_COLOR;
        _characteristicLabel.font = MKFont(15.f);
        _characteristicLabel.textAlignment = NSTextAlignmentLeft;
        _characteristicLabel.numberOfLines = 0;
    }
    return _characteristicLabel;
}

- (UILabel *)propertyLabel {
    if (!_propertyLabel) {
        _propertyLabel = [[UILabel alloc] init];
        _propertyLabel.textColor = DEFAULT_TEXT_COLOR;
        _propertyLabel.font = MKFont(13.f);
        _propertyLabel.textAlignment = NSTextAlignmentLeft;
        _propertyLabel.numberOfLines = 0;
    }
    return _propertyLabel;
}

- (UIButton *)writeButton {
    if (!_writeButton) {
        _writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeButton setImage:LOADICON(@"MKGatewayUsbSeven", @"MKCONormalConnectedCell", @"co_characteristic_writeIcon.png") forState:UIControlStateNormal];
        [_writeButton addTarget:self
                         action:@selector(writeButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeButton;
}

- (UIButton *)readButton {
    if (!_readButton) {
        _readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readButton setImage:LOADICON(@"MKGatewayUsbSeven", @"MKCONormalConnectedCell", @"co_characteristic_readIcon.png") forState:UIControlStateNormal];
        [_readButton addTarget:self
                        action:@selector(readButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _readButton;
}

- (UIButton *)notifyButton {
    if (!_notifyButton) {
        _notifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_notifyButton setImage:LOADICON(@"MKGatewayUsbSeven", @"MKCONormalConnectedCell", @"co_characteristic_notifyIcon.png") forState:UIControlStateNormal];
        [_notifyButton addTarget:self
                          action:@selector(notifyButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _notifyButton;
}

-(UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.font = MKFont(13.f);
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.numberOfLines = 0;
    }
    return _valueLabel;
}

@end
