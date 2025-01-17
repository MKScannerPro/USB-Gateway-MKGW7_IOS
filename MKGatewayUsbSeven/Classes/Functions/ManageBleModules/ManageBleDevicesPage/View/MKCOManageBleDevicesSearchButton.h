//
//  MKCOManageBleDevicesSearchButton.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOManageBleDevicesSearchButtonModel : NSObject

/// 显示的标题
@property (nonatomic, copy)NSString *placeholder;

/// 显示的搜索名字
@property (nonatomic, copy)NSString *searchName;

/// 显示的搜索mac地址
@property (nonatomic, copy)NSString *searchMac;

/// 过滤的RSSI值
@property (nonatomic, assign)NSInteger searchRssi;

/// 过滤的最小RSSI值，当searchRssi == minSearchRssi时，不显示searchRssi搜索条件
@property (nonatomic, assign)NSInteger minSearchRssi;

@end

@protocol MKCOManageBleDevicesSearchButtonDelegate <NSObject>

/// 搜索按钮点击事件
- (void)co_scanSearchButtonMethod;

/// 搜索按钮右侧清除按钮点击事件
- (void)co_scanSearchButtonClearMethod;

@end

@interface MKCOManageBleDevicesSearchButton : UIControl

@property (nonatomic, strong)MKCOManageBleDevicesSearchButtonModel *dataModel;

@property (nonatomic, weak)id <MKCOManageBleDevicesSearchButtonDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
