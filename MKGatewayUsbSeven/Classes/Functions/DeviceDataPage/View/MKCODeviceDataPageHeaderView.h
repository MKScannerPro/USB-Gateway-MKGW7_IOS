//
//  MKCODeviceDataPageHeaderView.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCODeviceDataPageHeaderViewModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@end

@protocol MKCODeviceDataPageHeaderViewDelegate <NSObject>

- (void)co_updateLoadButtonAction;

- (void)co_powerButtonAction;

- (void)co_scannerStatusChanged:(BOOL)isOn;

- (void)co_manageBleDeviceAction;

@end

@interface MKCODeviceDataPageHeaderView : UIView

@property (nonatomic, strong)MKCODeviceDataPageHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKCODeviceDataPageHeaderViewDelegate>delegate;

- (void)updateTotalNumbers:(NSInteger)numbers;

@end

NS_ASSUME_NONNULL_END
