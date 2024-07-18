//
//  MKCOBleWifiSettingsCertCell.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/7/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOBleWifiSettingsCertCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *fileName;

@end

@protocol MKCOBleWifiSettingsCertCellDelegate <NSObject>

- (void)co_bleWifiSettingsCertPressed:(NSInteger)index;

@end

@interface MKCOBleWifiSettingsCertCell : MKBaseCell

@property (nonatomic, strong)MKCOBleWifiSettingsCertCellModel *dataModel;

@property (nonatomic, weak)id <MKCOBleWifiSettingsCertCellDelegate>delegate;

+ (MKCOBleWifiSettingsCertCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
