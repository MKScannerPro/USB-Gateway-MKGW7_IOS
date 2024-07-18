//
//  MKCOUserCredentialsView.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOUserCredentialsViewModel : NSObject

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@end

@protocol MKCOUserCredentialsViewDelegate <NSObject>

- (void)co_mqtt_userCredentials_userNameChanged:(NSString *)userName;

- (void)co_mqtt_userCredentials_passwordChanged:(NSString *)password;

@end

@interface MKCOUserCredentialsView : UIView

@property (nonatomic, strong)MKCOUserCredentialsViewModel *dataModel;

@property (nonatomic, weak)id <MKCOUserCredentialsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
