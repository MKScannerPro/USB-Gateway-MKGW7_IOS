//
//  MKCOSystemTimeCell.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOSystemTimeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKCOSystemTimeCellDelegate <NSObject>

- (void)co_systemTimeButtonPressed:(NSInteger)index;

@end

@interface MKCOSystemTimeCell : MKBaseCell

@property (nonatomic, strong)MKCOSystemTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKCOSystemTimeCellDelegate>delegate;

+ (MKCOSystemTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
