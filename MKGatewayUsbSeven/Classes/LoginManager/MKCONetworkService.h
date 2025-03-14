//
//  MKCONetworkService.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2025/3/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKIotCloudManager/MKBaseService.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOCreatScannerProDeviceModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

/// 设备在本地存储的名字
@property (nonatomic, copy)NSString *macName;

/// 设备的遗言主题
@property (nonatomic, copy)NSString *lastWillTopic;

/// 设备的发布主题
@property (nonatomic, copy)NSString *publishTopic;

/// 设备的订阅主题
@property (nonatomic, copy)NSString *subscribeTopic;

- (NSDictionary *)params;

@end

@interface MKCONetworkService : MKBaseService

/// 创建Scanner Pro设备
/// - Parameters:
///   - deviceList: deviceList
///   - isHome: 是否是正式环境
///   - token:  登录的token
///   - sucBlock: 成功回调
///   - failBlock: 失败回调
- (void)addScannerProDevicesToCloud:(NSArray <MKCOCreatScannerProDeviceModel *>*)deviceList
                             isHome:(BOOL)isHome
                              token:(NSString *)token
                           sucBlock:(MKNetworkRequestSuccessBlock)sucBlock
                          failBlock:(MKNetworkRequestFailureBlock)failBlock;

/// 取消创建Scanner Pro设备接口
- (void)cancelAddScannerProDevice;

@end

NS_ASSUME_NONNULL_END
