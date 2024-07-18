//
//  MKCODeviceListCell.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCODeviceListCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)co_cellDeleteButtonPressed:(NSInteger)index;

@end

@class MKCODeviceListModel;
@interface MKCODeviceListCell : MKBaseCell

@property (nonatomic, weak)id <MKCODeviceListCellDelegate>delegate;

@property (nonatomic, strong)MKCODeviceListModel *dataModel;

+ (MKCODeviceListCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
