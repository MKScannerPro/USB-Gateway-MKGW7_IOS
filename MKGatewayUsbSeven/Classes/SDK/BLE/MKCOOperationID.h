

typedef NS_ENUM(NSInteger, mk_co_taskOperationID) {
    mk_co_defaultTaskOperationID,
    
#pragma mark - Read
    mk_co_taskReadDeviceModelOperation,        //读取产品型号
    mk_co_taskReadFirmwareOperation,           //读取固件版本
    mk_co_taskReadHardwareOperation,           //读取硬件类型
    mk_co_taskReadSoftwareOperation,           //读取软件版本
    mk_co_taskReadManufacturerOperation,       //读取厂商信息
    
#pragma mark - 自定义协议读取
    mk_co_taskReadDeviceNameOperation,         //读取设备名称
    mk_co_taskReadDeviceMacAddressOperation,    //读取MAC地址
    mk_co_taskReadDeviceWifiSTAMacAddressOperation, //读取WIFI STA MAC地址
    mk_co_taskReadNTPServerHostOperation,       //读取NTP服务器域名
    mk_co_taskReadTimeZoneOperation,            //读取时区
    
#pragma mark - Wifi Params
    mk_co_taskReadWIFISecurityOperation,        //读取设备当前wifi的加密模式
    mk_co_taskReadWIFISSIDOperation,            //读取设备当前的wifi ssid
    mk_co_taskReadWIFIPasswordOperation,        //读取设备当前的wifi密码
    mk_co_taskReadWIFIEAPTypeOperation,         //读取设备当前的wifi EAP类型
    mk_co_taskReadWIFIEAPUsernameOperation,     //读取设备当前的wifi EAP用户名
    mk_co_taskReadWIFIEAPPasswordOperation,     //读取设备当前的wifi EAP密码
    mk_co_taskReadWIFIEAPDomainIDOperation,     //读取设备当前的wifi EAP域名ID
    mk_co_taskReadWIFIVerifyServerStatusOperation,  //读取是否校验服务器
    mk_co_taskReadWIFIDHCPStatusOperation,              //读取Wifi DHCP开关
    mk_co_taskReadWIFINetworkIpInfosOperation,          //读取Wifi IP信息
    mk_co_taskReadNetworkTypeOperation,                 //读取网络类型
    
#pragma mark - MQTT Params
    mk_co_taskReadServerHostOperation,          //读取MQTT服务器域名
    mk_co_taskReadServerPortOperation,          //读取MQTT服务器端口
    mk_co_taskReadClientIDOperation,            //读取Client ID
    mk_co_taskReadServerUserNameOperation,      //读取服务器登录用户名
    mk_co_taskReadServerPasswordOperation,      //读取服务器登录密码
    mk_co_taskReadServerCleanSessionOperation,  //读取MQTT Clean Session
    mk_co_taskReadServerKeepAliveOperation,     //读取MQTT KeepAlive
    mk_co_taskReadServerQosOperation,           //读取MQTT Qos
    mk_co_taskReadSubscibeTopicOperation,       //读取Subscribe topic
    mk_co_taskReadPublishTopicOperation,        //读取Publish topic
    mk_co_taskReadLWTStatusOperation,           //读取LWT开关状态
    mk_co_taskReadLWTQosOperation,              //读取LWT Qos
    mk_co_taskReadLWTRetainOperation,           //读取LWT Retain
    mk_co_taskReadLWTTopicOperation,            //读取LWT topic
    mk_co_taskReadLWTPayloadOperation,          //读取LWT Payload
    mk_co_taskReadConnectModeOperation,         //读取MTQQ服务器通信加密方式
    
#pragma mark - Filter Params
    mk_co_taskReadRssiFilterValueOperation,             //读取扫描RSSI过滤
    mk_co_taskReadFilterRelationshipOperation,          //读取扫描过滤逻辑
    mk_co_taskReadFilterMACAddressListOperation,        //读取MAC过滤列表
    mk_co_taskReadFilterAdvNameListOperation,           //读取ADV Name过滤列表
    
#pragma mark - iBeacon Params
    mk_co_taskReadAdvertiseBeaconStatusOperation,       //读取iBeacon开关
    mk_co_taskReadBeaconMajorOperation,                 //读取iBeacon major
    mk_co_taskReadBeaconMinorOperation,                 //读取iBeacon minor
    mk_co_taskReadBeaconUUIDOperation,                  //读取iBeacon UUID
    mk_co_taskReadBeaconAdvIntervalOperation,           //读取Adv interval
    mk_co_taskReadBeaconTxPowerOperation,               //读取Tx Power
    mk_co_taskReadRssiValueOperation,                   //读取RSSI@1m
    
#pragma mark - 计电量参数
    mk_co_taskReadMeteringSwitchOperation,              //读取计量数据上报开关
    mk_co_taskReadPowerReportIntervalOperation,         //读取电量数据上报间隔
    mk_co_taskReadEnergyReportIntervalOperation,        //读取电能数据上报间隔
    mk_co_taskReadLoadDetectionNotificationStatusOperation, //读取负载检测通知开关
    
    
#pragma mark - 密码特征
    mk_co_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 配置
    mk_co_taskEnterSTAModeOperation,                //设备重启进入STA模式
    mk_co_taskConfigNTPServerHostOperation,         //配置NTP服务器域名
    mk_co_taskConfigTimeZoneOperation,              //配置时区
    
#pragma mark - Wifi Params
    
    mk_co_taskConfigWIFISecurityOperation,      //配置wifi的加密模式
    mk_co_taskConfigWIFISSIDOperation,          //配置wifi的ssid
    mk_co_taskConfigWIFIPasswordOperation,      //配置wifi的密码
    mk_co_taskConfigWIFIEAPTypeOperation,       //配置wifi的EAP类型
    mk_co_taskConfigWIFIEAPUsernameOperation,   //配置wifi的EAP用户名
    mk_co_taskConfigWIFIEAPPasswordOperation,   //配置wifi的EAP密码
    mk_co_taskConfigWIFIEAPDomainIDOperation,   //配置wifi的EAP域名ID
    mk_co_taskConfigWIFIVerifyServerStatusOperation,    //配置wifi是否校验服务器
    mk_co_taskConfigWIFICAFileOperation,                //配置WIFI CA证书
    mk_co_taskConfigWIFIClientCertOperation,            //配置WIFI设备证书
    mk_co_taskConfigWIFIClientPrivateKeyOperation,      //配置WIFI私钥
    mk_co_taskConfigWIFIDHCPStatusOperation,                //配置Wifi DHCP开关
    mk_co_taskConfigWIFIIpInfoOperation,                    //配置Wifi IP地址相关信息
    
#pragma mark - MQTT Params
    mk_co_taskConfigServerHostOperation,        //配置MQTT服务器域名
    mk_co_taskConfigServerPortOperation,        //配置MQTT服务器端口
    mk_co_taskConfigClientIDOperation,              //配置ClientID
    mk_co_taskConfigServerUserNameOperation,        //配置服务器的登录用户名
    mk_co_taskConfigServerPasswordOperation,        //配置服务器的登录密码
    mk_co_taskConfigServerCleanSessionOperation,    //配置MQTT Clean Session
    mk_co_taskConfigServerKeepAliveOperation,       //配置MQTT KeepAlive
    mk_co_taskConfigServerQosOperation,             //配置MQTT Qos
    mk_co_taskConfigSubscibeTopicOperation,         //配置Subscribe topic
    mk_co_taskConfigPublishTopicOperation,          //配置Publish topic
    mk_co_taskConfigLWTStatusOperation,             //配置LWT开关
    mk_co_taskConfigLWTQosOperation,                //配置LWT Qos
    mk_co_taskConfigLWTRetainOperation,             //配置LWT Retain
    mk_co_taskConfigLWTTopicOperation,              //配置LWT topic
    mk_co_taskConfigLWTPayloadOperation,            //配置LWT payload
    mk_co_taskConfigConnectModeOperation,           //配置MTQQ服务器通信加密方式
    mk_co_taskConfigCAFileOperation,                //配置CA证书
    mk_co_taskConfigClientCertOperation,            //配置设备证书
    mk_co_taskConfigClientPrivateKeyOperation,      //配置私钥
        
#pragma mark - 过滤参数
    mk_co_taskConfigRssiFilterValueOperation,                   //配置扫描RSSI过滤
    mk_co_taskConfigFilterRelationshipOperation,                //配置扫描过滤逻辑
    mk_co_taskConfigFilterMACAddressListOperation,           //配置MAC过滤规则
    mk_co_taskConfigFilterAdvNameListOperation,             //配置Adv Name过滤规则
    
#pragma mark - 蓝牙广播参数
    mk_co_taskConfigAdvertiseBeaconStatusOperation,         //配置iBeacon开关
    mk_co_taskConfigBeaconMajorOperation,                   //配置iBeacon major
    mk_co_taskConfigBeaconMinorOperation,                   //配置iBeacon minor
    mk_co_taskConfigBeaconUUIDOperation,                    //配置iBeacon UUID
    mk_co_taskConfigAdvIntervalOperation,                   //配置广播频率
    mk_co_taskConfigTxPowerOperation,                       //配置Tx Power
    mk_co_taskConfigRssiValueOperation,                     //配置RSSI@1m
    
#pragma mark - 计电量参数
    mk_co_taskConfigMeteringSwitchOperation,                //配置计量数据上报开关
    mk_co_taskConfigPowerReportIntervalOperation,           //配置电量数据上报间隔
    mk_co_taskConfigEnergyReportIntervalOperation,          //配置电能数据上报间隔
    mk_co_taskConfigLoadDetectionNotificationStatusOperation,   //配置负载检测通知开关
};

