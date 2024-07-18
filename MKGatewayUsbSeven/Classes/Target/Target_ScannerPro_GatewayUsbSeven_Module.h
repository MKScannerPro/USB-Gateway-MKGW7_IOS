//
//  Target_ScannerPro_GatewayUsbSeven_Module.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_ScannerPro_GatewayUsbSeven_Module : NSObject

/// 设备列表页面
/// @param params @{}
- (UIViewController *)Action_MKScannerPro_GatewayUsbSeven_DeviceListPage:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
