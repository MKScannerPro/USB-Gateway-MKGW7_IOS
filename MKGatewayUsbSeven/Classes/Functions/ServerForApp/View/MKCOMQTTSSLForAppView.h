//
//  MKCOMQTTSSLForAppView.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOMQTTSSLForAppViewModel : NSObject

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA certificate     1:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFileName;

/// P12证书
@property (nonatomic, copy)NSString *clientFileName;

@end

@protocol MKCOMQTTSSLForAppViewDelegate <NSObject>

- (void)co_mqtt_sslParams_app_sslStatusChanged:(BOOL)isOn;

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)co_mqtt_sslParams_app_certificateChanged:(NSInteger)certificate;

/// 用户点击选择了caFaile按钮
- (void)co_mqtt_sslParams_app_caFilePressed;

/// 用户点击选择了P12证书按钮
- (void)co_mqtt_sslParams_app_clientFilePressed;

@end

@interface MKCOMQTTSSLForAppView : UIView

@property (nonatomic, strong)MKCOMQTTSSLForAppViewModel *dataModel;

@property (nonatomic, weak)id <MKCOMQTTSSLForAppViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
