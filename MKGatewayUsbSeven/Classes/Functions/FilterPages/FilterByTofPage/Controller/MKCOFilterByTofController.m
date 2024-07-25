//
//  MKCOFilterByTofController.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2024/2/18.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKCOFilterByTofController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextFieldCell.h"
#import "MKCustomUIAdopter.h"
#import "MKTableSectionLineHeader.h"

#import "MKFilterEditSectionHeaderView.h"

#import "MKCOFilterByTofModel.h"

@interface MKCOFilterByTofController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate,
MKFilterEditSectionHeaderViewDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)MKCOFilterByTofModel *dataModel;

@end

@implementation MKCOFilterByTofController

- (void)dealloc {
    NSLog(@"MKCOFilterByTofController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 35.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        MKFilterEditSectionHeaderViewModel *headerModel = [[MKFilterEditSectionHeaderViewModel alloc] init];
        headerModel.index = 0;
        headerModel.msg = @"MFG Code";
        MKFilterEditSectionHeaderView *headerView = [MKFilterEditSectionHeaderView initHeaderViewWithTableView:tableView];
        headerView.dataModel = headerModel;
        headerView.delegate = self;
        return headerView;
    }
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = [[MKTableSectionLineHeaderModel alloc] init];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //MK TOF
        self.dataModel.isOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index >= self.section1List.count) {
        return;
    }
    MKTextFieldCellModel *cellModel = self.section1List[index];
    cellModel.textFieldValue = value;
}

#pragma  mark - MKFilterEditSectionHeaderViewDelegate

/// 加号点击事件
/// @param index 所在index
- (void)mk_filterEditSectionHeaderView_addButtonPressed:(NSInteger)index {
    if (self.section1List.count >= 10) {
        [self.view showCentralToast:@"You can set up to 10 filters!"];
        return;
    }
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = self.section1List.count;
    cellModel.msg = [NSString stringWithFormat:@"Code %ld",(long)(self.section1List.count + 1)];
    cellModel.textPlaceholder = @"2 Bytes";
    cellModel.textFieldType = mk_hexCharOnly;
    cellModel.textFieldValue = @"";
    cellModel.maxLength = 4;
    [self.section1List addObject:cellModel];
    [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
}

/// 减号点击事件
/// @param index 所在index
- (void)mk_filterEditSectionHeaderView_subButtonPressed:(NSInteger)index {
    if (self.section1List.count == 0) {
        return;
    }
    [self.section1List removeLastObject];
    [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
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
    NSMutableArray *codeList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.section1List.count; i ++) {
        MKTextFieldCellModel *cellModel = self.section1List[i];
        if (cellModel.textFieldValue.length != 4 || ![cellModel.textFieldValue regularExpressions:isHexadecimal]) {
            [self.view showCentralToast:@"Para Error"];
            return;
        }
        [codeList addObject:cellModel.textFieldValue];
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithCodeList:codeList sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"MK TOF";
    cellModel.isOn = self.dataModel.isOn;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    for (NSInteger i = 0; i < self.dataModel.codeList.count; i ++) {
        MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
        cellModel.index = i;
        cellModel.msg = [NSString stringWithFormat:@"Code %ld",(long)(i + 1)];
        cellModel.textPlaceholder = @"2 Bytes";
        cellModel.textFieldType = mk_hexCharOnly;
        cellModel.textFieldValue = self.dataModel.codeList[i];
        cellModel.maxLength = 4;
        [self.section1List addObject:cellModel];
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"MK TOF";
    [self.rightButton setImage:LOADICON(@"MKGatewayUsbSeven", @"MKCOFilterByTofController", @"co_saveIcon.png") forState:UIControlStateNormal];
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

- (MKCOFilterByTofModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCOFilterByTofModel alloc] init];
    }
    return _dataModel;
}

@end
