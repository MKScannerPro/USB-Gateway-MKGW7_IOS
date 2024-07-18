//
//  MKCOMqttWifiSettingsModel.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCOMqttWifiSettingsModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCODeviceModeManager.h"

#import "MKCOMQTTInterface.h"

@interface MKCOMqttWifiSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCOMqttWifiSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readWifiInfos]) {
            [self operationFailedBlockWithMsg:@"Read Wifi Infos Error" block:failedBlock];
            return;
        }
        if (![self readNetworkInfos]) {
            [self operationFailedBlockWithMsg:@"Read Network Infos Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        NSInteger status = [self readOTAState];
        if (status == -1) {
            [self operationFailedBlockWithMsg:@"Read OTA Status Error" block:failedBlock];
            return;
        }
        if (status == 1) {
            [self operationFailedBlockWithMsg:@"Device is busy now!" block:failedBlock];
            return;
        }
        
        if (![self configWifiInfos]) {
            [self operationFailedBlockWithMsg:@"Config Wifi Infos Error" block:failedBlock];
            return;
        }
        if (![self configNetworkInfos]) {
            [self operationFailedBlockWithMsg:@"Config Wifi Network Infos Error" block:failedBlock];
            return;
        }
        if (self.security == 1 && !(!ValidStr(self.caFilePath) && !ValidStr(self.clientKeyPath) && !ValidStr(self.clientCertPath))) {
            //三个证书同时为空，则不需要发送
            if (((self.eapType == 0 || self.eapType == 1) && self.verifyServer) || self.eapType == 2) {
                //TLS需要设置这个，0:PEAP-MSCHAPV2  1:TTLS-MSCHAPV2这两种必须验证服务器打开的情况下才设置
                if (![self configEAPCerts]) {
                    [self operationFailedBlockWithMsg:@"Config EAP Certs Error" block:failedBlock];
                    return;
                }
            }
        }
        
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (NSInteger)readOTAState {
    __block NSInteger status = -1;
    [MKCOMQTTInterface co_readOtaStatusWithMacAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        status = [returnData[@"data"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return status;
}

- (BOOL)readWifiInfos {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_readWifiInfosWithMacAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.security = [returnData[@"data"][@"security_type"] integerValue];
        self.ssid = returnData[@"data"][@"ssid"];
        self.wifiPassword = returnData[@"data"][@"passwd"];
        self.eapType = [returnData[@"data"][@"eap_type"] integerValue];
        self.domainID = returnData[@"data"][@"eap_id"];
        self.eapUserName = returnData[@"data"][@"eap_username"];
        self.eapPassword = returnData[@"data"][@"eap_passwd"];
        self.verifyServer = ([returnData[@"data"][@"eap_verify_server"] integerValue] == 1);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiInfos {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_modifyWifiInfos:self macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNetworkInfos {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_readWifiNetworkInfosWithMacAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dhcp = ([returnData[@"data"][@"dhcp_en"] integerValue] == 1);
        self.ip = returnData[@"data"][@"ip"];
        self.mask = returnData[@"data"][@"netmask"];
        self.gateway = returnData[@"data"][@"gw"];
        self.dns = returnData[@"data"][@"dns"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkInfos {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_modifyWifiNetworkInfos:self macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPCerts {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_modifyWifiCerts:self macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (NSString *)checkMsg {
    if (!ValidStr(self.ssid) || self.ssid.length > 32) {
        return @"ssid error";
    }
    if (self.wifiPassword.length > 64) {
        return @"password error";
    }
    if (!self.dhcp) {
        if (![self.ip regularExpressions:isIPAddress]) {
            return @"IP Error";
        }
        if (![self.mask regularExpressions:isIPAddress]) {
            return @"Mask Error";
        }
        if (![self.gateway regularExpressions:isIPAddress]) {
            return @"Gateway Error";
        }
        if (![self.dns regularExpressions:isIPAddress]) {
            return @"DNS Error";
        }
    }
    return @"";
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"MqttWifiSettings"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("MqttWifiSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
