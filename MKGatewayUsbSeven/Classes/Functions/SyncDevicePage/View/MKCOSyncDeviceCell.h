//
//  MKCOSyncDeviceCell.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2025/3/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKCODeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCOSyncDeviceCellModel : MKCODeviceModel

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCOSyncDeviceCellDelegate <NSObject>

- (void)co_syncDeviceCell_selected:(BOOL)selected index:(NSInteger)index;

@end

@interface MKCOSyncDeviceCell : MKBaseCell

@property (nonatomic, strong)MKCOSyncDeviceCellModel *dataModel;

@property (nonatomic, weak)id <MKCOSyncDeviceCellDelegate>delegate;

+ (MKCOSyncDeviceCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
