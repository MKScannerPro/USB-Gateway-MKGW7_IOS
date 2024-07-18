//
//  MKCOBXPButtonController.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/1/12.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKCOBXPButtonController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKButtonMsgCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKAlertView.h"

#import "MKBLEBaseSDKAdopter.h"

#import "MKCOMQTTDataManager.h"
#import "MKCOMQTTInterface.h"

#import "MKCODeviceModeManager.h"
#import "MKCODeviceModel.h"

#import "MKCOReminderAlertView.h"
#import "MKCOButtonFirmwareCell.h"

#import "MKCOButtonDFUController.h"

@interface MKCOBXPButtonController ()<UITableViewDelegate,
UITableViewDataSource,
MKButtonMsgCellDelegate,
MKCOButtonFirmwareCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *section6List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)NSDictionary *bxpStatusDic;

@end

@implementation MKCOBXPButtonController

- (void)dealloc {
    NSLog(@"MKCOBXPButtonController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [self addNotes];
    [self readDatasFromDevice];
}

#pragma mark - super method

- (void)rightButtonMethod {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self disconnect];
    }];
    NSString *msg = @"Please confirm agian whether to disconnect the gateway from BLE devices?";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_co_needDismissAlert"];
}

- (void)leftButtonMethod {
    //用户点击左上角，则需要返回MKCODeviceDataController
    [self popToViewControllerWithClassName:@"MKCODeviceDataController"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 10.f;
    }
    if (section == 5) {
        return 55.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6 && indexPath.row == 0) {
        //LED control
        [self showLedReminderAlert];
        return;
    }
    if (indexPath.section == 6 && indexPath.row == 1) {
        //Buzzer control
        [self showBuzzerReminderAlert];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return self.section5List.count;
    }
    if (section == 6) {
        return self.section6List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKCOButtonFirmwareCell *cell = [MKCOButtonFirmwareCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section2List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 3) {
        MKButtonMsgCell *cell = [MKButtonMsgCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel =  self.section4List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 5) {
        MKButtonMsgCell *cell = [MKButtonMsgCell initCellWithTableView:tableView];
        cell.dataModel =  self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section6List[indexPath.row];
    return cell;
}

#pragma mark - MKButtonMsgCellDelegate
/// 右侧按钮点击事件
/// @param index 当前cell所在index
- (void)mk_buttonMsgCellButtonPressed:(NSInteger)index {
    if (index == 0) {
        //Read battery and alarm info
        [self readDatasFromDevice];
        return;
    }
    if (index == 1) {
        //Dismiss alarm status
        [self dismissAlarmStatus];
        return;
    }
}

#pragma mark - MKCOButtonFirmwareCellDelegate
- (void)co_buttonFirmwareCell_buttonAction:(NSInteger)index {
    if (index == 0) {
        //DFU
        MKCOButtonDFUController *vc = [[MKCOButtonDFUController alloc] init];
        vc.bleMacAddress = self.deviceBleInfo[@"data"][@"mac"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - notes
- (void)receiveDisconnect:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCODeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    NSDictionary *dataDic = user[@"data"];
    if (![dataDic[@"mac"] isEqualToString:self.deviceBleInfo[@"data"][@"mac"]]) {
        return;
    }
    if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_co_needDismissAlert" object:nil];
    //返回上一级页面
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCOMQTTInterface co_readBXPButtonConnectedStatusWithBleMacAddress:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        self.bxpStatusDic = returnData;
        [self updateStatusDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)dismissAlarmStatus {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKCOMQTTInterface co_dismissBXPButtonAlarmStatusWithBleMacAddress:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        [self readDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)disconnect {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKCOMQTTInterface co_disconnectNormalBleDeviceWithBleMac:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.navigationController popViewControllerAnimated:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)sendLedReminder:(NSString *)interval duration:(NSString *)duration color:(NSInteger)color {
    if (!ValidStr(interval) || !ValidStr(duration)) {
        [self.view showCentralToast:@"Params Cannot Be Empty!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCOMQTTInterface co_configDeviceLedReminderWithBleMac:self.deviceBleInfo[@"data"][@"mac"] interval:[interval integerValue] duration:[duration integerValue] macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)sendBuzzerReminder:(NSString *)interval duration:(NSString *)duration {
    if (!ValidStr(interval) || !ValidStr(duration)) {
        [self.view showCentralToast:@"Params Cannot Be Empty!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCOMQTTInterface co_configDeviceBuzzerReminderWithBleMac:self.deviceBleInfo[@"data"][@"mac"] interval:[interval integerValue] duration:[duration integerValue] macAddress:[MKCODeviceModeManager shared].macAddress topic:[MKCODeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)updateStatusDatas {
    MKNormalTextCellModel *cellModel1 = self.section4List[0];
    cellModel1.rightMsg = [NSString stringWithFormat:@"%@%@",self.bxpStatusDic[@"data"][@"battery_v"],@"mV"];
    
    MKNormalTextCellModel *cellModel2 = self.section4List[1];
    cellModel2.rightMsg = [NSString stringWithFormat:@"%@",self.bxpStatusDic[@"data"][@"single_alarm_num"]];
    
    MKNormalTextCellModel *cellModel3 = self.section4List[2];
    cellModel3.rightMsg = [NSString stringWithFormat:@"%@",self.bxpStatusDic[@"data"][@"double_alarm_num"]];
    
    MKNormalTextCellModel *cellModel4 = self.section4List[3];
    cellModel4.rightMsg = [NSString stringWithFormat:@"%@",self.bxpStatusDic[@"data"][@"long_alarm_num"]];
    
    MKNormalTextCellModel *cellModel5 = self.section4List[4];
    NSString *statusValue = [MKBLEBaseSDKAdopter fetchHexValue:[self.bxpStatusDic[@"data"][@"alarm_status"] integerValue] byteLen:1];
    NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:statusValue];
    BOOL singleStatus = [[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
    BOOL doubleStatus = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
    BOOL longStatus = [[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
    BOOL abnormalStatus = [[binary substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
    if ([self.bxpStatusDic[@"data"][@"alarm_status"] integerValue] == 0) {
        //无触发
        cellModel5.rightMsg = @"Not triggered";
    }else {
        //有触发
        NSString *indexString = @"";
        if (singleStatus) {
            indexString = [indexString stringByAppendingString:@"&1"];
        }
        if (doubleStatus) {
            indexString = [indexString stringByAppendingString:@"&2"];
        }
        if (longStatus) {
            indexString = [indexString stringByAppendingString:@"&3"];
        }
        if (abnormalStatus) {
            indexString = [indexString stringByAppendingString:@"&4"];
        }
        if (indexString.length > 0 && [[indexString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"&"]) {
            //截取有效字符串
            indexString = [indexString substringFromIndex:1];
        }
        cellModel5.rightMsg = [NSString stringWithFormat:@"Mode %@ triggered",SafeStr(indexString)];
    }
    
    [self.tableView reloadData];
}

#pragma mark - private method
- (void)addNotes {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDisconnect:)
                                                 name:MKCOReceiveGatewayDisconnectBXPButtonNotification
                                               object:nil];
}

- (void)showLedReminderAlert {
    MKCOReminderAlertViewModel *dataModel = [[MKCOReminderAlertViewModel alloc] init];
    dataModel.title = @"LED Reminder";
    dataModel.intervalMsg = @"Blinking interval";
    dataModel.durationMsg = @"Blinking duration";
    MKCOReminderAlertView *alertView = [[MKCOReminderAlertView alloc] init];
    [alertView showAlertWithModel:dataModel confirmAction:^(NSString * _Nonnull interval, NSString * _Nonnull duration, NSInteger color) {
        [self sendLedReminder:interval duration:duration color:color];
    }];
}

- (void)showBuzzerReminderAlert {
    MKCOReminderAlertViewModel *dataModel = [[MKCOReminderAlertViewModel alloc] init];
    dataModel.title = @"Buzzer Reminder";
    dataModel.intervalMsg = @"Ring interval";
    dataModel.durationMsg = @"Ring duration";
    MKCOReminderAlertView *alertView = [[MKCOReminderAlertView alloc] init];
    [alertView showAlertWithModel:dataModel confirmAction:^(NSString * _Nonnull interval, NSString * _Nonnull duration, NSInteger color) {
        [self sendBuzzerReminder:interval duration:duration];
    }];
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
    
    for (NSInteger i = 0; i < 5; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    MKTableSectionLineHeaderModel *lastHeaderModel = [[MKTableSectionLineHeaderModel alloc] init];
    lastHeaderModel.text = @"Mode description in alrm status: mode 1: Single press, mode 2: Double press,mode 3: Long press, mode 4: Abnormal inactivity";
    lastHeaderModel.msgTextFont = MKFont(12.f);
    lastHeaderModel.msgTextColor = UIColorFromRGB(0xcccccc);
    [self.headerList addObject:lastHeaderModel];
    
    MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
    [self.headerList addObject:headerModel];
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Product model";
    cellModel1.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"product_model"]);
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Manufacture";
    cellModel2.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"company_name"]);
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKCOButtonFirmwareCellModel *cellModel = [[MKCOButtonFirmwareCellModel alloc] init];
    cellModel.index = 0;
    cellModel.leftMsg = @"Firmware version";
    cellModel.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"firmware_version"]);
    cellModel.rightButtonTitle = @"DFU";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Hardware version";
    cellModel1.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"hardware_version"]);
    [self.section2List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Software version";
    cellModel2.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"software_version"]);
    [self.section2List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"MAC address";
    cellModel3.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"mac"]);
    [self.section2List addObject:cellModel3];
}

- (void)loadSection3Datas {
    MKButtonMsgCellModel *cellModel = [[MKButtonMsgCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Read battery and alarm info";
    cellModel.buttonTitle = @"Read";
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Battery voltage";
    [self.section4List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Single press event count";
    [self.section4List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Double press event count";
    [self.section4List addObject:cellModel3];
    
    MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
    cellModel4.leftMsg = @"Long press event count";
    [self.section4List addObject:cellModel4];
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.leftMsg = @"Alarm status";
    
    [self.section4List addObject:cellModel5];
}

- (void)loadSection5Datas {
    MKButtonMsgCellModel *cellModel = [[MKButtonMsgCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Dismiss alarm status";
    cellModel.buttonTitle = @"Dismiss";
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"LED control";
    cellModel1.showRightIcon = YES;
    [self.section6List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Buzzer control";
    cellModel2.showRightIcon = YES;
    [self.section6List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [MKCODeviceModeManager shared].deviceName;
    [self.rightButton setTitle:@"Disconnect" forState:UIControlStateNormal];
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
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
