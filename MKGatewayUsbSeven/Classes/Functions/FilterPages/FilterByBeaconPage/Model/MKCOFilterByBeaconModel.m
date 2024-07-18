//
//  MKCOFilterByBeaconModel.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12..
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCOFilterByBeaconModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCODeviceModeManager.h"

#import "MKCOMQTTInterface.h"

@interface MKCOFilterByBeaconModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, assign)mk_co_filterByBeaconPageType pageType;

@end

@implementation MKCOFilterByBeaconModel

- (instancetype)initWithPageType:(mk_co_filterByBeaconPageType)pageType {
    if (self = [self init]) {
        self.pageType = pageType;
    }
    return self;
}

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (self.pageType == mk_co_filterByBeaconPageType_beacon) {
            if (![self readFilterByBeacon]) {
                [self operationFailedBlockWithMsg:@"Read Filter iBeacon Error" block:failedBlock];
                return;
            }
        }
        /*
        else if (self.pageType == mk_co_filterByBeaconPageType_MKBeacon) {
            if (![self readFilterByMKBeacon]) {
                [self operationFailedBlockWithMsg:@"Read Filter iBeacon Error" block:failedBlock];
                return;
            }
        }else if (self.pageType == mk_co_filterByBeaconPageType_MKBeaconAcc) {
            if (![self readFilterByMKBeaconACC]) {
                [self operationFailedBlockWithMsg:@"Read Filter iBeacon Error" block:failedBlock];
                return;
            }
        }*/
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        NSString *msg = [self checkParams];
        if (ValidStr(msg)) {
            [self operationFailedBlockWithMsg:msg block:failedBlock];
            return;
        }
        if (self.pageType == mk_co_filterByBeaconPageType_beacon) {
            if (![self configFilterByBeacon]) {
                [self operationFailedBlockWithMsg:@"Setup failed!" block:failedBlock];
                return;
            }
        }
        /*
        else if (self.pageType == mk_co_filterByBeaconPageType_MKBeacon) {
            if (![self configFilterByMKBeacon]) {
                [self operationFailedBlockWithMsg:@"Setup failed!" block:failedBlock];
                return;
            }
        }else if (self.pageType == mk_co_filterByBeaconPageType_MKBeaconAcc) {
            if (![self configFilterByMKBeaconACC]) {
                [self operationFailedBlockWithMsg:@"Setup failed!" block:failedBlock];
                return;
            }
        }*/
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readFilterByBeacon {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_readFilterByBeaconWithMacAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = ([returnData[@"data"][@"switch_value"] integerValue] == 1);
        NSInteger tempMinMinor = [returnData[@"data"][@"min_minor"] integerValue];
        NSInteger tempMaxMinor = [returnData[@"data"][@"max_minor"] integerValue];
        NSInteger tempMinMajor = [returnData[@"data"][@"min_major"] integerValue];
        NSInteger tempMaxMajor = [returnData[@"data"][@"max_major"] integerValue];
        self.minMinor = [NSString stringWithFormat:@"%ld",(long)tempMinMinor];
        self.maxMinor = [NSString stringWithFormat:@"%ld",(long)tempMaxMinor];
        self.minMajor = [NSString stringWithFormat:@"%ld",(long)tempMinMajor];
        self.maxMajor = [NSString stringWithFormat:@"%ld",(long)tempMaxMajor];
        if (tempMinMinor == 0 && tempMaxMinor == 65535) {
            self.minMinor = @"";
            self.maxMinor = @"";
        }
        if (tempMinMajor == 0 && tempMaxMajor == 65535) {
            self.minMajor = @"";
            self.maxMajor = @"";
        }
        dispatch_semaphore_signal(self.semaphore);
        self.uuid = [returnData[@"data"][@"uuid"] lowercaseString];
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterByBeacon {
    __block BOOL success = NO;
    
    NSInteger tempMinMinor = [self.minMinor integerValue];
    NSInteger tempMaxMinor = [self.maxMinor integerValue];
    NSInteger tempMinMajor = [self.minMajor integerValue];
    NSInteger tempMaxMajor = [self.maxMajor integerValue];
    
    if (!ValidStr(self.minMinor) && !ValidStr(self.maxMinor)) {
        tempMinMinor = 0;
        tempMaxMinor = 65535;
    }
    if (!ValidStr(self.minMajor) && !ValidStr(self.maxMajor)) {
        tempMinMajor = 0;
        tempMaxMajor = 65535;
    }
    
    [MKCOMQTTInterface co_configFilterByBeacon:self.isOn minMinor:tempMinMinor maxMinor:tempMaxMinor minMajor:tempMinMajor maxMajor:tempMaxMajor uuid:self.uuid macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}
/*
- (BOOL)readFilterByMKBeacon {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_readFilterByMKBeaconWithDeviceID:self.deviceID macAddress:self.macAddress topic:self.topic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = ([returnData[@"data"][@"switch"] integerValue] == 1);
        self.minMinor = [NSString stringWithFormat:@"%@",returnData[@"data"][@"min_minor"]];
        self.maxMinor = [NSString stringWithFormat:@"%@",returnData[@"data"][@"max_minor"]];
        self.minMajor = [NSString stringWithFormat:@"%@",returnData[@"data"][@"min_major"]];
        self.maxMajor = [NSString stringWithFormat:@"%@",returnData[@"data"][@"max_major"]];
        self.uuid = [returnData[@"data"][@"uuid"] lowercaseString];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterByMKBeacon {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_configFilterByMKBeacon:self.isOn minMinor:[self.minMinor integerValue] maxMinor:[self.maxMinor integerValue] minMajor:[self.minMajor integerValue] maxMajor:[self.maxMajor integerValue] uuid:self.uuid deviceID:self.deviceID macAddress:self.macAddress topic:self.topic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFilterByMKBeaconACC {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_readFilterByMKBeaconACCWithDeviceID:self.deviceID macAddress:self.macAddress topic:self.topic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = ([returnData[@"data"][@"switch"] integerValue] == 1);
        self.minMinor = [NSString stringWithFormat:@"%@",returnData[@"data"][@"min_minor"]];
        self.maxMinor = [NSString stringWithFormat:@"%@",returnData[@"data"][@"max_minor"]];
        self.minMajor = [NSString stringWithFormat:@"%@",returnData[@"data"][@"min_major"]];
        self.maxMajor = [NSString stringWithFormat:@"%@",returnData[@"data"][@"max_major"]];
        self.uuid = [returnData[@"data"][@"uuid"] lowercaseString];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterByMKBeaconACC {
    __block BOOL success = NO;
    [MKCOMQTTInterface co_configFilterByMKBeaconACC:self.isOn minMinor:[self.minMinor integerValue] maxMinor:[self.maxMinor integerValue] minMajor:[self.minMajor integerValue] maxMajor:[self.maxMajor integerValue] uuid:self.uuid deviceID:self.deviceID macAddress:self.macAddress topic:self.topic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}
*/
#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"filterBeaconParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (NSString *)checkParams {
    if (!ValidStr(self.minMajor) && ValidStr(self.maxMajor)) {
        return @"Major error";
    }
    if (ValidStr(self.minMajor) && !ValidStr(self.maxMajor)) {
        return @"Major error";
    }
    if (!ValidStr(self.minMinor) && ValidStr(self.maxMinor)) {
        return @"Minor error";
    }
    if (ValidStr(self.minMinor) && !ValidStr(self.maxMinor)) {
        return @"Minor error";
    }
    if ([self.minMinor integerValue] < 0 || [self.minMinor integerValue] > 65535 || [self.maxMinor integerValue] < [self.minMinor integerValue] || [self.maxMinor integerValue] > 65535) {
        return @"Minor error";
    }
    if ([self.minMajor integerValue] < 0 || [self.minMajor integerValue] > 65535 || [self.maxMajor integerValue] < [self.minMajor integerValue] || [self.maxMajor integerValue] > 65535) {
        return @"Major error";
    }
    if (!self.uuid || ![self.uuid isKindOfClass:NSString.class]) {
        return @"UUID error";
    }
    if (ValidStr(self.uuid)) {
        if (![self.uuid regularExpressions:isHexadecimal] || self.uuid.length > 32 || self.uuid.length % 2 != 0) {
            return @"UUID error";
        }
    }
    return @"";
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
        _readQueue = dispatch_queue_create("filterBeaconQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
