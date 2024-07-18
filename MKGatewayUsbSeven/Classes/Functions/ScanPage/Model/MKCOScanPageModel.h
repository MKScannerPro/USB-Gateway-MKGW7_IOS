//
//  MKCOScanPageModel.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKCOScanPageModel : NSObject

@property (nonatomic, copy)NSString *deviceType;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, assign)NSInteger rssi;

@property (nonatomic, assign)BOOL connectable;

@end

NS_ASSUME_NONNULL_END
