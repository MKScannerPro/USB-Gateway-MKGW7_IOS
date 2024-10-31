//
//  CBPeripheral+MKCOAdd.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKCOAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *co_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *co_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *co_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *co_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *co_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *co_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *co_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *co_product;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *co_custom;

- (void)co_updateCharacterWithService:(CBService *)service;

- (void)co_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)co_connectSuccess;

- (void)co_setNil;

@end

NS_ASSUME_NONNULL_END
