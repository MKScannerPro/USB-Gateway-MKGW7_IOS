//
//  MKCOBleWifiSettingsController.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCOBleWifiSettingsController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTableSectionLineHeader.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"
#import "MKTextFieldCell.h"
#import "MKTextSwitchCell.h"
#import "MKCAFileSelectController.h"

#import "MKCODeviceModel.h"

#import "MKCODeviceMQTTParamsModel.h"

#import "MKCOBleWifiSettingsModel.h"

#include "MKCOBleWifiSettingsCertCell.h"

static NSString *const noteMsg = @"Please note the CA certificate is required, the client certificate and client key are optional.";

@interface MKCOBleWifiSettingsController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate,
MKCOBleWifiSettingsCertCellDelegate,
MKCAFileSelectControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *section6List;

@property (nonatomic, strong)NSMutableArray *section7List;

@property (nonatomic, strong)NSMutableArray *section8List;

@property (nonatomic, strong)NSMutableArray *section9List;

@property (nonatomic, strong)NSMutableArray *section10List;

@property (nonatomic, strong)NSMutableArray *section11List;

@property (nonatomic, strong)NSMutableArray *section12List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)MKCOBleWifiSettingsModel *dataModel;

@end

@implementation MKCOBleWifiSettingsController

- (void)dealloc {
    NSLog(@"MKCOBleWifiSettingsController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 11) {
        return 10.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForRowAtIndexPath:indexPath];
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Security
        self.dataModel.security = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = dataListIndex;
        [self.tableView reloadData];
        return;
    }
    if (index == 1) {
        //EAP type
        self.dataModel.eapType = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section1List[0];
        cellModel.dataListIndex = dataListIndex;
        self.noteLabel.hidden = (self.dataModel.eapType != 2);
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //SSID
        self.dataModel.ssid = value;
        MKTextFieldCellModel *cellModel = self.section2List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //WIFI Password
        self.dataModel.wifiPassword = value;
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //EAP Username
        self.dataModel.eapUserName = value;
        MKTextFieldCellModel *cellModel = self.section4List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Password
        self.dataModel.eapPassword = value;
        MKTextFieldCellModel *cellModel = self.section5List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 4) {
        //Domain ID
        self.dataModel.domainID = value;
        MKTextFieldCellModel *cellModel = self.section6List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 5) {
        //IP
        self.dataModel.wifi_ip = value;
        MKTextFieldCellModel *cellModel = self.section12List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 6) {
        //Mask
        self.dataModel.wifi_mask = value;
        MKTextFieldCellModel *cellModel = self.section12List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 7) {
        //Gateway
        self.dataModel.wifi_gateway = value;
        MKTextFieldCellModel *cellModel = self.section12List[2];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 8) {
        //DNS
        self.dataModel.wifi_dns = value;
        MKTextFieldCellModel *cellModel = self.section12List[3];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Verify server
        self.dataModel.verifyServer = isOn;
        MKTextSwitchCellModel *cellModel = self.section7List[0];
        cellModel.isOn = isOn;
        
        [self.tableView mk_reloadSection:8 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 1) {
        //Wifi DHCP
        self.dataModel.wifi_dhcp = isOn;
        MKTextSwitchCellModel *cellModel = self.section11List[0];
        cellModel.isOn = isOn;
        [self.tableView mk_reloadSection:12 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKCOBleWifiSettingsCertCellDelegate
- (void)co_bleWifiSettingsCertPressed:(NSInteger)index {
    if (index == 0) {
        //CA certificate
        MKCAFileSelectController *vc = [[MKCAFileSelectController alloc] init];
        vc.pageType = mk_caCertSelPage;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (index == 1) {
        //Client certificate
        MKCAFileSelectController *vc = [[MKCAFileSelectController alloc] init];
        vc.pageType = mk_clientCertSelPage;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (index == 2) {
        //Client key
        MKCAFileSelectController *vc = [[MKCAFileSelectController alloc] init];
        vc.pageType = mk_clientKeySelPage;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - MKCAFileSelectControllerDelegate
- (void)mk_certSelectedMethod:(mk_certListPageType)certType certName:(NSString *)certName {
    if (certType == mk_caCertSelPage) {
        //CA certificate
        self.dataModel.caFileName = certName;
        MKCOBleWifiSettingsCertCellModel *cellModel = self.section8List[0];
        cellModel.fileName = certName;
        [self.tableView mk_reloadSection:8 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (certType == mk_clientCertSelPage) {
        //Client certificate
        self.dataModel.clientCertName = certName;
        MKCOBleWifiSettingsCertCellModel *cellModel = self.section9List[0];
        cellModel.fileName = certName;
        [self.tableView mk_reloadSection:9 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (certType == mk_clientKeySelPage) {
        //Client key
        self.dataModel.clientKeyName = certName;
        MKCOBleWifiSettingsCertCellModel *cellModel = self.section10List[0];
        cellModel.fileName = certName;
        [self.tableView mk_reloadSection:10 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        [MKCODeviceMQTTParamsModel shared].wifiConfig = YES;
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [MKCODeviceMQTTParamsModel shared].wifiConfig = NO;
    }];
}

#pragma mark - table数据处理方法
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //Security
        return self.section0List.count;
    }
    if (section == 1) {
        //EAP type
        return (self.dataModel.security == 1 ? self.section1List.count : 0);
    }
    if (section == 2) {
        //SSID
        return self.section2List.count;
    }
    if (section == 3) {
        //WIFI Password.Security为Personal有效
        return (self.dataModel.security == 0 ? self.section3List.count : 0);
    }
    if (section == 4) {
        //EAP Username   Security为Enterprise && EAP type为PEAP-MSCHAPV2或者TTLS -MSCHAPV2
        if (self.dataModel.security == 1 && (self.dataModel.eapType == 0 || self.dataModel.eapType == 1)) {
            return self.section4List.count;
        }
        return 0;
    }
    if (section == 5) {
        //EAP Password
        if ((self.dataModel.security == 0) || (self.dataModel.security == 1 && self.dataModel.eapType == 2)) {
            //Security为Personal和TLS没有此选项
            return 0;
        }
        return self.section5List.count;
    }
    if (section == 6) {
        //Domain ID. TLS特有
        return ((self.dataModel.security == 1 && self.dataModel.eapType == 2) ? self.section6List.count : 0);
    }
    if (section == 7) {
        //Verify server. Security为Enterprise && EAP type为PEAP-MSCHAPV2或者TTLS -MSCHAPV2
        if (self.dataModel.security == 1 && (self.dataModel.eapType == 0 || self.dataModel.eapType == 1)) {
            return self.section7List.count;
        }
    }
    if (section == 8) {
        //CA certificate.Security为Enterprise有效
        if (self.dataModel.security == 1) {
            if (!self.dataModel.verifyServer && (self.dataModel.eapType == 0 || self.dataModel.eapType == 1)) {
                return 0;
            }
            return self.section8List.count;
        }
        
    }
    if (section == 9) {
        //Client certificate.TLS特有
        return ((self.dataModel.security == 1 && self.dataModel.eapType == 2) ? self.section9List.count : 0);
    }
    if (section == 10) {
        //Client key.TLS特有
        return ((self.dataModel.security == 1 && self.dataModel.eapType == 2) ? self.section10List.count : 0);
    }
    if (section == 11) {
        //Ethernet DHCP
        return self.section11List.count;
    }
    if (section == 12) {
        //Ethernet IP
        return (self.dataModel.wifi_dhcp ? 0 : self.section12List.count);
    }
    
    return 0;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //Security
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        //EAP type
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        //SSID
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        //WIFI Password
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        //EAP Username
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        //EAP Password
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        //Domain ID.
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        //Verify server.
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 8) {
        //CA certificate.
        MKCOBleWifiSettingsCertCell *cell = [MKCOBleWifiSettingsCertCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section8List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 9) {
        //Client certificate.TLS特有
        MKCOBleWifiSettingsCertCell *cell = [MKCOBleWifiSettingsCertCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section9List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 10) {
        //CA certificate
        MKCOBleWifiSettingsCertCell *cell = [MKCOBleWifiSettingsCertCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section10List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 11) {
        //Wifi DHCP
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section11List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    //Wifi IP
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section12List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    [self loadSection7Datas];
    [self loadSection8Datas];
    [self loadSection9Datas];
    [self loadSection10Datas];
    [self loadSection11Datas];
    [self loadSection12Datas];
    
    for (NSInteger i = 0; i < 13; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    self.noteLabel.hidden = (self.dataModel.eapType != 2);
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Security";
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataList = @[@"Personal",@"Enterprise"];
    cellModel.dataListIndex = self.dataModel.security;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"EAP type";
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataList = @[@"PEAP-MSCHAPV2",@"TTLS-MSCHAPV2",@"TLS"];
    cellModel.dataListIndex = self.dataModel.eapType;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"SSID";
    cellModel.maxLength = 32;
    cellModel.textPlaceholder = @"1-32 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.ssid;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Password";
    cellModel.maxLength = 64;
    cellModel.textPlaceholder = @"0-64 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.wifiPassword;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"EAP username";
    cellModel.maxLength = 32;
    cellModel.textPlaceholder = @"0-32 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.eapUserName;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 3;
    cellModel.msg = @"EAP password";
    cellModel.maxLength = 64;
    cellModel.textPlaceholder = @"0-64 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.eapPassword;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 4;
    cellModel.msg = @"Domain ID";
    cellModel.maxLength = 64;
    cellModel.textPlaceholder = @"0-64 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.domainID;
    [self.section6List addObject:cellModel];
}

- (void)loadSection7Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Verify server";
    cellModel.isOn = self.dataModel.verifyServer;
    [self.section7List addObject:cellModel];
}

- (void)loadSection8Datas {
    MKCOBleWifiSettingsCertCellModel *cellModel = [[MKCOBleWifiSettingsCertCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"CA certificate";
    cellModel.fileName = self.dataModel.caFileName;
    [self.section8List addObject:cellModel];
}

- (void)loadSection9Datas {
    MKCOBleWifiSettingsCertCellModel *cellModel = [[MKCOBleWifiSettingsCertCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Client certificate";
    cellModel.fileName = self.dataModel.clientCertName;
    [self.section9List addObject:cellModel];
}

- (void)loadSection10Datas {
    MKCOBleWifiSettingsCertCellModel *cellModel = [[MKCOBleWifiSettingsCertCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Client key";
    cellModel.fileName = self.dataModel.clientKeyName;
    [self.section10List addObject:cellModel];
}

- (void)loadSection11Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"DHCP";
    cellModel.isOn = self.dataModel.wifi_dhcp;
    [self.section11List addObject:cellModel];
}

- (void)loadSection12Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 5;
    cellModel1.msg = @"IP";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.wifi_ip;
    [self.section12List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 6;
    cellModel2.msg = @"Mask";
    cellModel2.textFieldType = mk_normal;
    cellModel2.textFieldValue = self.dataModel.wifi_mask;
    [self.section12List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 7;
    cellModel3.msg = @"Gateway";
    cellModel3.textFieldType = mk_normal;
    cellModel3.textFieldValue = self.dataModel.wifi_gateway;
    [self.section12List addObject:cellModel3];
    
    MKTextFieldCellModel *cellModel4 = [[MKTextFieldCellModel alloc] init];
    cellModel4.index = 8;
    cellModel4.msg = @"DNS";
    cellModel4.textFieldType = mk_normal;
    cellModel4.textFieldValue = self.dataModel.wifi_dns;
    [self.section12List addObject:cellModel4];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Network Settings";
    [self.rightButton setImage:LOADICON(@"MKGatewayUsbSeven", @"MKCOBleWifiSettingsController", @"co_saveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
//        _tableView.tableFooterView = [self tableFooterView];
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)section6List {
    if (!_section6List) {
        _section6List = [NSMutableArray array];
    }
    return _section6List;
}

- (NSMutableArray *)section7List {
    if (!_section7List) {
        _section7List = [NSMutableArray array];
    }
    return _section7List;
}

- (NSMutableArray *)section8List {
    if (!_section8List) {
        _section8List = [NSMutableArray array];
    }
    return _section8List;
}

- (NSMutableArray *)section9List {
    if (!_section9List) {
        _section9List = [NSMutableArray array];
    }
    return _section9List;
}

- (NSMutableArray *)section10List {
    if (!_section10List) {
        _section10List = [NSMutableArray array];
    }
    return _section10List;
}

- (NSMutableArray *)section11List {
    if (!_section11List) {
        _section11List = [NSMutableArray array];
    }
    return _section11List;
}

- (NSMutableArray *)section12List {
    if (!_section12List) {
        _section12List = [NSMutableArray array];
    }
    return _section12List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKCOBleWifiSettingsModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCOBleWifiSettingsModel alloc] init];
    }
    return _dataModel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = noteMsg;
    }
    return _noteLabel;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 60.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    [footerView addSubview:self.noteLabel];
    [self.noteLabel setHidden:YES];
    CGSize msgSize = [NSString sizeWithText:noteMsg
                                    andFont:MKFont(12.f)
                                 andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel setFrame:CGRectMake(15.f, 15.f, kViewWidth - 2 * 15.f, msgSize.height)];
    
    return footerView;
}

@end
