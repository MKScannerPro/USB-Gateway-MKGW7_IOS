//
//  CBPeripheral+MKCOAdd.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKCOAdd.h"

#import <objc/runtime.h>

static const char *co_manufacturerKey = "co_manufacturerKey";
static const char *co_deviceModelKey = "co_deviceModelKey";
static const char *co_hardwareKey = "co_hardwareKey";
static const char *co_softwareKey = "co_softwareKey";
static const char *co_firmwareKey = "co_firmwareKey";

static const char *co_passwordKey = "co_passwordKey";
static const char *co_disconnectTypeKey = "co_disconnectTypeKey";
static const char *co_customKey = "co_customKey";

static const char *co_passwordNotifySuccessKey = "co_passwordNotifySuccessKey";
static const char *co_disconnectTypeNotifySuccessKey = "co_disconnectTypeNotifySuccessKey";
static const char *co_customNotifySuccessKey = "co_customNotifySuccessKey";

@implementation CBPeripheral (MKCOAdd)

- (void)co_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &co_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &co_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &co_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &co_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &co_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &co_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &co_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &co_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)co_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &co_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &co_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &co_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)co_connectSuccess {
    if (![objc_getAssociatedObject(self, &co_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &co_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &co_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.co_hardware || !self.co_firmware) {
        return NO;
    }
    if (!self.co_password || !self.co_disconnectType || !self.co_custom) {
        return NO;
    }
    return YES;
}

- (void)co_setNil {
    objc_setAssociatedObject(self, &co_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &co_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &co_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &co_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &co_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &co_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &co_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &co_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &co_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &co_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &co_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)co_manufacturer {
    return objc_getAssociatedObject(self, &co_manufacturerKey);
}

- (CBCharacteristic *)co_deviceModel {
    return objc_getAssociatedObject(self, &co_deviceModelKey);
}

- (CBCharacteristic *)co_hardware {
    return objc_getAssociatedObject(self, &co_hardwareKey);
}

- (CBCharacteristic *)co_software {
    return objc_getAssociatedObject(self, &co_softwareKey);
}

- (CBCharacteristic *)co_firmware {
    return objc_getAssociatedObject(self, &co_firmwareKey);
}

- (CBCharacteristic *)co_password {
    return objc_getAssociatedObject(self, &co_passwordKey);
}

- (CBCharacteristic *)co_disconnectType {
    return objc_getAssociatedObject(self, &co_disconnectTypeKey);
}

- (CBCharacteristic *)co_custom {
    return objc_getAssociatedObject(self, &co_customKey);
}

@end
