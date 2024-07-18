//
//  MKCOResetByButtonCell.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOResetByButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCOResetByButtonCellDelegate <NSObject>

- (void)co_resetByButtonCellAction:(NSInteger)index;

@end

@interface MKCOResetByButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKCOResetByButtonCellDelegate>delegate;

@property (nonatomic, strong)MKCOResetByButtonCellModel *dataModel;

+ (MKCOResetByButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
