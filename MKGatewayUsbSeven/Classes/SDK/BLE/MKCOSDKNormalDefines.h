
typedef NS_ENUM(NSInteger, mk_co_centralConnectStatus) {
    mk_co_centralConnectStatusUnknow,                                           //未知状态
    mk_co_centralConnectStatusConnecting,                                       //正在连接
    mk_co_centralConnectStatusConnected,                                        //连接成功
    mk_co_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_co_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_co_centralManagerStatus) {
    mk_co_centralManagerStatusUnable,                           //不可用
    mk_co_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_co_wifiSecurity) {
    mk_co_wifiSecurity_personal,
    mk_co_wifiSecurity_enterprise,
};

typedef NS_ENUM(NSInteger, mk_co_eapType) {
    mk_co_eapType_peap_mschapv2,
    mk_co_eapType_ttls_mschapv2,
    mk_co_eapType_tls,
};

typedef NS_ENUM(NSInteger, mk_co_connectMode) {
    mk_co_connectMode_TCP,                                          //TCP
    mk_co_connectMode_CASignedServerCertificate,                    //SSL.Do not verify the server certificate.
    mk_co_connectMode_CACertificate,                                //SSL.Verify the server's certificate
    mk_co_connectMode_SelfSignedCertificates,                       //SSL.Two-way authentication
};

//Quality of MQQT service
typedef NS_ENUM(NSInteger, mk_co_mqttServerQosMode) {
    mk_co_mqttQosLevelAtMostOnce,      //At most once. The message sender to find ways to send messages, but an accident and will not try again.
    mk_co_mqttQosLevelAtLeastOnce,     //At least once.If the message receiver does not know or the message itself is lost, the message sender sends it again to ensure that the message receiver will receive at least one, and of course, duplicate the message.
    mk_co_mqttQosLevelExactlyOnce,     //Exactly once.Ensuring this semantics will reduce concurrency or increase latency, but level 2 is most appropriate when losing or duplicating messages is unacceptable.
};

typedef NS_ENUM(NSInteger, mk_co_filterRelationship) {
    mk_co_filterRelationship_null,
    mk_co_filterRelationship_mac,
    mk_co_filterRelationship_advName,
    mk_co_filterRelationship_rawData,
    mk_co_filterRelationship_advNameAndRawData,
    mk_co_filterRelationship_macAndadvNameAndRawData,
    mk_co_filterRelationship_advNameOrRawData,
    mk_co_filterRelationship_advNameAndMacData,
};


@protocol mk_co_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
- (void)mk_co_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_co_startScan;

/// Stops scanning equipment.
- (void)mk_co_stopScan;

@end
