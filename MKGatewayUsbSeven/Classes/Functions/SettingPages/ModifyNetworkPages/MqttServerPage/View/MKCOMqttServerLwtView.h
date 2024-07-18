//
//  MKCOMqttServerLwtView.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOMqttServerLwtViewModel : NSObject

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

@property (nonatomic, assign)NSInteger lwtQos;

@property (nonatomic, copy)NSString *lwtTopic;

@property (nonatomic, copy)NSString *lwtPayload;

@end

@protocol MKCOMqttServerLwtViewDelegate <NSObject>

- (void)co_lwt_statusChanged:(BOOL)isOn;

- (void)co_lwt_retainChanged:(BOOL)isOn;

- (void)co_lwt_qosChanged:(NSInteger)qos;

- (void)co_lwt_topicChanged:(NSString *)text;

- (void)co_lwt_payloadChanged:(NSString *)text;

@end

@interface MKCOMqttServerLwtView : UIView

@property (nonatomic, strong)MKCOMqttServerLwtViewModel *dataModel;

@property (nonatomic, weak)id <MKCOMqttServerLwtViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
