//
//  MKCOMqttWifiSettingsBandCell.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/2/2.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOMqttWifiSettingsBandCellModel : NSObject

@property (nonatomic, assign)NSInteger country;

@end

@protocol MKCOMqttWifiSettingsBandCellDelegate <NSObject>

- (void)co_mqttWifiSettingsBandCell_countryChanged:(NSInteger)country;

@end

@interface MKCOMqttWifiSettingsBandCell : MKBaseCell

@property (nonatomic, strong)MKCOMqttWifiSettingsBandCellModel *dataModel;

@property (nonatomic, weak)id <MKCOMqttWifiSettingsBandCellDelegate>delegate;

+ (MKCOMqttWifiSettingsBandCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
