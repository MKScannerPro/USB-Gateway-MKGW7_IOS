//
//  MKCOConnectedDeviceWriteAlertView.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCOConnectedDeviceWriteAlertView : UIView

- (void)showAlertWithValue:(NSString *)value
               dismissNote:(NSString *)dismissNote
              cancelAction:(void (^)(void))cancelAction
             confirmAction:(void (^)(NSString *textValue))confirmAction;

@end

NS_ASSUME_NONNULL_END
