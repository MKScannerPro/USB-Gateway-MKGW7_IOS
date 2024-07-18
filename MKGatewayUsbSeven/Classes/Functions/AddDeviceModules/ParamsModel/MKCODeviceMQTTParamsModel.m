//
//  MKCODeviceMQTTParamsModel.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCODeviceMQTTParamsModel.h"

#import "MKCODeviceModel.h"

static MKCODeviceMQTTParamsModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCODeviceMQTTParamsModel

+ (MKCODeviceMQTTParamsModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCODeviceMQTTParamsModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

#pragma mark - getter
- (MKCODeviceModel *)deviceModel {
    if (!_deviceModel) {
        _deviceModel = [[MKCODeviceModel alloc] init];
    }
    return _deviceModel;
}

@end
