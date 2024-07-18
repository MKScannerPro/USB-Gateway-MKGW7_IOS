//
//  Target_ScannerPro_GatewayUsbSeven_Module.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "Target_ScannerPro_GatewayUsbSeven_Module.h"

#import "MKCODeviceListController.h"

@implementation Target_ScannerPro_GatewayUsbSeven_Module

- (UIViewController *)Action_MKScannerPro_GatewayUsbSeven_DeviceListPage:(NSDictionary *)params {
    MKCODeviceListController *vc = [[MKCODeviceListController alloc] init];
    vc.connectServer = YES;
    return vc;
}

@end
