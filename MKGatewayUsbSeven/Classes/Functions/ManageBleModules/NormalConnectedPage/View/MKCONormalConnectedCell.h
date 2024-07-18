//
//  MKCONormalConnectedCell.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCONormalConnectedCellModel : NSObject

@property (nonatomic, assign)NSInteger section;

@property (nonatomic, assign)NSInteger row;

@property (nonatomic, copy)NSString *server;

@property (nonatomic, copy)NSString *characteristic;

/*
 Bit0:BOARFCAST
 Bit1:READ
 Bit2:WRITE_NR
 Bit3:WRITE
 Bit4:NOTIFY
 Bit5:INDICATE
 Bit6:AUTH
 Bit7:EXT_PROP
 */
@property (nonatomic, copy)NSString *properties;

/*
 -1表示特征不支持通知
 0表示特征通知关闭
 1表示特征通知打开
 */
@property (nonatomic, assign)NSInteger notifyStatus;

@property (nonatomic, copy)NSString *value;

- (CGFloat)cellHeightWithWidth:(CGFloat)viewWidth;

@end

@protocol MKCONormalConnectedCellDelegate <NSObject>

- (void)co_normalConnectedCell_writeButtonPressed:(NSInteger)section
                                              row:(NSInteger)row
                                       serverUUID:(NSString *)serverUUID
                                   characteristic:(NSString *)characteristic;

- (void)co_normalConnectedCell_readButtonPressed:(NSInteger)section
                                             row:(NSInteger)row
                                      serverUUID:(NSString *)serverUUID
                                  characteristic:(NSString *)characteristic;

- (void)co_normalConnectedCell_notifyButtonPressed:(BOOL)notify
                                           section:(NSInteger)section
                                               row:(NSInteger)row
                                        serverUUID:(NSString *)serverUUID
                                    characteristic:(NSString *)characteristic;

@end

@interface MKCONormalConnectedCell : MKBaseCell

@property (nonatomic, weak)id <MKCONormalConnectedCellDelegate>delegate;

@property (nonatomic, strong)MKCONormalConnectedCellModel *dataModel;

+ (MKCONormalConnectedCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
