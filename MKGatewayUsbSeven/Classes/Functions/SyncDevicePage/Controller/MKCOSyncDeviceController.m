//
//  MKCOSyncDeviceController.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2025/3/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKCOSyncDeviceController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKNormalService.h"

#import "MKIoTCloudExitAccountAlert.h"

#import "MKCOUserLoginManager.h"

#import "MKCOSyncDeviceCell.h"

@interface MKCOSyncDeviceController ()<UITableViewDelegate,
UITableViewDataSource,
MKCOSyncDeviceCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKCOSyncDeviceController

- (void)dealloc {
    NSLog(@"MKCOSyncDeviceController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadDataSections];
}

#pragma mark - super method
- (void)rightButtonMethod {
    MKIoTCloudExitAccountAlert *alert = [[MKIoTCloudExitAccountAlert alloc] init];
    [alert showWithAccount:[MKCOUserLoginManager shared].username completeBlock:^{
        [[MKCOUserLoginManager shared] syncLoginDataWithHome:[MKCOUserLoginManager shared].isHome username:[MKCOUserLoginManager shared].username password:@""];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCOSyncDeviceCell *cell = [MKCOSyncDeviceCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCOSyncDeviceCellDelegate
- (void)co_syncDeviceCell_selected:(BOOL)selected index:(NSInteger)index {
    MKCOSyncDeviceCellModel *cellModel = self.dataList[index];
    cellModel.selected = selected;
}

#pragma mark - event method
- (void)syncButtonPressed {
    NSMutableArray *uploadList = [NSMutableArray array];
    for (MKCOSyncDeviceCellModel *cellModel in self.dataList) {
        if (cellModel.selected) {
            MKUserCreatScannerProDeviceModel *uploadModel = [[MKUserCreatScannerProDeviceModel alloc] init];
            uploadModel.deviceType = 8;
            uploadModel.macAddress = cellModel.macAddress;
            uploadModel.macName = cellModel.deviceName;
            uploadModel.lastWillTopic = cellModel.lwtTopic;
            uploadModel.publishTopic = cellModel.publishedTopic;
            uploadModel.subscribeTopic = cellModel.subscribedTopic;
            [uploadList addObject:uploadModel];
        }
    }
    if (uploadList.count == 0) {
        [self.view showCentralToast:@"Add devices first"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [[MKNormalService share] addScannerProDevicesToCloud:uploadList isHome:[MKCOUserLoginManager shared].isHome token:self.token sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Sync success"];
    } failBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSections
- (void)loadDataSections {
    for (NSInteger i = 0; i < self.deviceList.count; i ++) {
        MKCODeviceModel *device = self.deviceList[i];
        MKCOSyncDeviceCellModel *cellModel = [[MKCOSyncDeviceCellModel alloc] init];
        cellModel.index = i;
        cellModel.deviceName = device.deviceName;
        cellModel.macAddress = device.macAddress;
        cellModel.lwtTopic = device.lwtTopic;
        cellModel.subscribedTopic = device.subscribedTopic;
        cellModel.publishedTopic = device.publishedTopic;
        [self.dataList addObject:cellModel];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"MKScannerPro";
    [self.rightButton setImage:LOADICON(@"MKGatewayUsbSeven", @"MKCOSyncDeviceController", @"co_authorIcon.png") forState:UIControlStateNormal];
    UIView *footView = [self footerView];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(100.f);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(footView.mas_top);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = COLOR_WHITE_MACROS;
    
    UIButton *syncButton = [MKCustomUIAdopter customButtonWithTitle:@"Sync Devices"
                                                             target:self
                                                             action:@selector(syncButtonPressed)];
    [footerView addSubview:syncButton];
    [syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.centerY.mas_equalTo(footerView.mas_centerY);
        make.height.mas_equalTo(40.f);
    }];
    
    return footerView;
}

@end
