//
//  MKCOImportServerController.h
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCOImportServerControllerDelegate <NSObject>

- (void)co_selectedServerParams:(NSString *)fileName;

@end

@interface MKCOImportServerController : MKBaseViewController

@property (nonatomic, weak)id <MKCOImportServerControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
