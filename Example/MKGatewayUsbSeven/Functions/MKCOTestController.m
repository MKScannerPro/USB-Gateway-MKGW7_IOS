//
//  MKCOTestController.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/7/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKCOTestController.h"

#import "Masonry.h"

#import "MKCustomUIAdopter.h"

#import "MKCODeviceListController.h"

@interface MKCOTestController ()

@end

@implementation MKCOTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultTitle = @"Remote gateway";
    self.leftButton.hidden = YES;
    UIButton *button = [MKCustomUIAdopter customButtonWithTitle:@"USB gateway"
                                                         target:self
                                                         action:@selector(pushRemoteGatewayPage)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(180.f);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(40.f);
    }];
}

- (void)pushRemoteGatewayPage {
    MKCODeviceListController *vc = [[MKCODeviceListController alloc] init];
    vc.connectServer = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
