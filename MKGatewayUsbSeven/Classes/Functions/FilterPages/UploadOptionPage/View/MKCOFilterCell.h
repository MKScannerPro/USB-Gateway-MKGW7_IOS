//
//  MKCOFilterCell.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOFilterCellModel : NSObject

/// cell标识符
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger dataListIndex;

@property (nonatomic, strong)NSArray <NSString *>*dataList;

@end

@protocol MKCOFilterCellDelegate <NSObject>

- (void)co_filterValueChanged:(NSInteger)dataListIndex index:(NSInteger)index;

@end

@interface MKCOFilterCell : MKBaseCell

@property (nonatomic, strong)MKCOFilterCellModel *dataModel;

@property (nonatomic, weak)id <MKCOFilterCellDelegate>delegate;

+ (MKCOFilterCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
