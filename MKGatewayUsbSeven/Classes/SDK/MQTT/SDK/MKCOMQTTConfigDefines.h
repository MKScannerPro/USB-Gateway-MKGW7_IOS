
typedef NS_ENUM(NSInteger, mk_co_keyResetType) {
    mk_co_keyResetType_powerOnOneMin,     //Press in 1 min after powered
    mk_co_keyResetType_pressAnyTime,      //Press any time
};

typedef NS_ENUM(NSInteger, mk_co_filterRelationship) {
    mk_co_filterRelationship_null,
    mk_co_filterRelationship_mac,
    mk_co_filterRelationship_advName,
    mk_co_filterRelationship_rawData,
    mk_co_filterRelationship_advNameAndRawData,
    mk_co_filterRelationship_advNameAndRawDataAndMac,
    mk_co_filterRelationship_advNameOrRawData,
    mk_co_filterRelationship_advNameAndRawMac,
};

typedef NS_ENUM(NSInteger, mk_co_filterByTLM) {
    mk_co_filterByTLM_nonEncrypted,        //Non-encrypted type TLM
    mk_co_filterByTLM_encrypted,           //Encryption type TLM
    mk_co_filterByTLM_all,                //Filter all Eddystone_TLM data
};

typedef NS_ENUM(NSInteger, mk_co_filterByOther) {
    mk_co_filterByOther_A,                 //Filter by A condition.
    mk_co_filterByOther_AB,                //Filter by A & B condition.
    mk_co_filterByOther_AOrB,              //Filter by A | B condition.
    mk_co_filterByOther_ABC,               //Filter by A & B & C condition.
    mk_co_filterByOther_ABOrC,             //Filter by (A & B) | C condition.
    mk_co_filterByOther_AOrBOrC,           //Filter by A | B | C condition.
};

typedef NS_ENUM(NSInteger, mk_co_duplicateDataFilter) {
    mk_co_duplicateDataFilter_none,
    mk_co_duplicateDataFilter_mac,
    mk_co_duplicateDataFilter_macAndDataType,
    mk_co_duplicateDataFilter_macAndRawData
};

typedef NS_ENUM(NSInteger, mk_co_PHYMode) {
    mk_bv_PHYMode_BLE4,                     //1M PHY (BLE 4.x)
    mk_bv_PHYMode_BLE5,                     //1M PHY (BLE 5)
    mk_bv_PHYMode_BLE4AndBLE5,              //1M PHY (BLE 4.x + BLE 5)
    mk_bv_PHYMode_CodedBLE5,                //Coded PHY(BLE 5)
};


@protocol co_indicatorLightStatusProtocol <NSObject>

@property (nonatomic, assign)BOOL server_connecting;

@property (nonatomic, assign)BOOL server_connected;

@end



@protocol mk_co_BLEFilterRawDataProtocol <NSObject>

/// The currently filtered data type, refer to the definition of different Bluetooth data types by the International Bluetooth Organization, 1 byte of hexadecimal data
@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.if minIndex's value is 0,maxIndex must be 0;
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.if maxIndex's value is 0,minIndex must be 0;
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:29 Bytes
@property (nonatomic, copy)NSString *rawData;

@end


@protocol mk_co_BLEFilterBXPButtonProtocol <NSObject>

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL singlePressIsOn;

@property (nonatomic, assign)BOOL doublePressIsOn;

@property (nonatomic, assign)BOOL longPressIsOn;

@property (nonatomic, assign)BOOL abnormalInactivityIsOn;

@end


@protocol mk_co_BLEFilterPirProtocol <NSObject>

@property (nonatomic, assign)BOOL isOn;

/// 0：low delay 1：medium delay 2：high delay 3：all type
@property (nonatomic, assign)NSInteger delayRespneseStatus;

/// 0：close 1：open 2：all type
@property (nonatomic, assign)NSInteger doorStatus;

/// 0：low sensitivity 1：medium sensitivity 2：high sensitivity 3：all type
@property (nonatomic, assign)NSInteger sensorSensitivity;

/// 0：no effective motion detected 1：effective motion detected 2：all type
@property (nonatomic, assign)NSInteger sensorDetectionStatus;

@end


#pragma mark - 通过MQTT重新设置设备的wifi

@protocol mk_co_mqttModifyWifiProtocol <NSObject>

/// 0:personal  1:enterprise
@property (nonatomic, assign)NSInteger security;

/// security为enterprise的时候才有效。0:PEAP-MSCHAPV2  1:TTLS-MSCHAPV2  2:TLS
@property (nonatomic, assign)NSInteger eapType;

/// 1-32 Characters.
@property (nonatomic, copy)NSString *ssid;

/// 0-64 Characters.security为personal的时候才有效
@property (nonatomic, copy)NSString *wifiPassword;

/// 0-32 Characters.  eapType为PEAP-MSCHAPV2/TTLS-MSCHAPV2才有效
@property (nonatomic, copy)NSString *eapUserName;

/// 0-64 Characters.eapType为TLS的时候无此参数
@property (nonatomic, copy)NSString *eapPassword;

/// 0-64 Characters.eapType为TLS的时候有效
@property (nonatomic, copy)NSString *domainID;

/// eapType为PEAP-MSCHAPV2/TTLS-MSCHAPV2才有效
@property (nonatomic, assign)BOOL verifyServer;

@end

@protocol mk_co_mqttModifyWifiEapCertProtocol <NSObject>

/// security为personal无此参数
@property (nonatomic, copy)NSString *caFilePath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientKeyPath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientCertPath;

@end

@protocol mk_co_mqttModifyNetworkProtocol <NSObject>

@property (nonatomic, assign)BOOL dhcp;

/// 47.104.81.55
@property (nonatomic, copy)NSString *ip;

/// 47.104.81.55
@property (nonatomic, copy)NSString *mask;

/// 47.104.81.55
@property (nonatomic, copy)NSString *gateway;

/// 47.104.81.55
@property (nonatomic, copy)NSString *dns;

@end


@protocol mk_co_modifyMqttServerProtocol <NSObject>

/// 1-64 characters
@property (nonatomic, copy)NSString *host;

/// 1-65535
@property (nonatomic, copy)NSString *port;

/// 1-64 Characters
@property (nonatomic, copy)NSString *clientID;

/// 1-128 Characters
@property (nonatomic, copy)NSString *subscribeTopic;

/// 1-128 Characters
@property (nonatomic, copy)NSString *publishTopic;

@property (nonatomic, assign)BOOL cleanSession;

/// 0/1/2
@property (nonatomic, assign)NSInteger qos;

/// 10s~120s.
@property (nonatomic, copy)NSString *keepAlive;

/// 0-256 Characters
@property (nonatomic, copy)NSString *userName;

/// 0-256 Characters
@property (nonatomic, copy)NSString *password;

/// 0:TCP    1:CA signed server certificate     2:CA certificate     3:Self signed certificates
@property (nonatomic, assign)NSInteger connectMode;

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

/// 0/1/2
@property (nonatomic, assign)NSInteger lwtQos;

/// 1-128 Characters
@property (nonatomic, copy)NSString *lwtTopic;

/// 1-128 Characters
@property (nonatomic, copy)NSString *lwtPayload;

@end


@protocol mk_co_modifyMqttServerCertsProtocol <NSObject>

/// 0-256 Characters
@property (nonatomic, copy)NSString *caFilePath;

/// 0-256 Characters
@property (nonatomic, copy)NSString *clientKeyPath;

/// 0-256 Characters
@property (nonatomic, copy)NSString *clientCertPath;

@end


#pragma mark - 扫描数据上报内容选项protocol

@protocol co_uploadDataOptionProtocol <NSObject>

@property (nonatomic, assign)BOOL timestamp;

@property (nonatomic, assign)BOOL rawData_advertising;

@property (nonatomic, assign)BOOL rawData_response;

@end


#pragma mark - Advertise iBeacon

@protocol co_advertiseBeaconProtocol <NSObject>

@property (nonatomic, assign)BOOL advertise;

@property (nonatomic, assign)NSInteger major;

@property (nonatomic, assign)NSInteger minor;

@property (nonatomic, copy)NSString *uuid;

@property (nonatomic, assign)NSInteger advInterval;

/// RSSI@1M -100dBm ~ 0dBm
@property (nonatomic, assign)NSInteger rssi;

/*
 0：-24dbm
 1：-21dbm
 2：-18dbm
 3：-15dbm
 4：-12dbm
 5：-9dbm
 6：-6dbm
 7：-3dbm
 8：0dbm
 9：3dbm
 10：6dbm
 11：9dbm
 12：12dbm
 13：15dbm
 14：18dbm
 15：21dbm
 */
@property (nonatomic, assign)NSInteger txPower;

@end
