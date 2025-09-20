//
//  MKCONetworkService.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2025/3/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKCONetworkService.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKUrlDefinition.h"


@implementation MKCOCreatScannerProDeviceModel

- (NSString *)valid {
    self.macAddress = [self.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    if (![self.macAddress regularExpressions:isHexadecimal] || self.macAddress.length != 12) {
        return @"Mac error";
    }
    self.macAddress = [self.macAddress lowercaseString];
    
    if (!ValidStr(self.macName)) {
        return @"Mac name cannot be empty";
    }
    
    if (!ValidStr(self.publishTopic)) {
        return @"PublishTopic cannot be empty";
    }
    
    if (!ValidStr(self.subscribeTopic)) {
        return @"SubscribeTopic cannot be empty";
    }
    
    if (!ValidStr(self.lastWillTopic)) {
        return @"LastWillTopic cannot be empty";
    }
    
    return @"";
}

- (NSDictionary *)params {
    NSString *valid = [self valid];
    if (ValidStr(valid)) {
        return @{
            @"error":valid
        };
    }
    
    return @{
        @"lastWill":self.lastWillTopic,
        @"mac":self.macAddress,
        @"macName":self.macName,
        @"model":@"85",
        @"publishTopic":self.publishTopic,
        @"subscribeTopic":self.subscribeTopic
    };
}

@end

@interface MKCONetworkService ()

@property (nonatomic, strong)NSURLSessionDataTask *addScannerProDeviceTask;

@end

@implementation MKCONetworkService

+ (instancetype)share {
    static dispatch_once_t t;
    static MKCONetworkService *service = nil;
    dispatch_once(&t, ^{
        service = [[MKCONetworkService alloc] init];
    });
    return service;
}

- (void)addScannerProDevicesToCloud:(NSArray <MKCOCreatScannerProDeviceModel *>*)deviceList
                             isHome:(BOOL)isHome
                              token:(NSString *)token
                           sucBlock:(MKNetworkRequestSuccessBlock)sucBlock
                          failBlock:(MKNetworkRequestFailureBlock)failBlock {
    if (!ValidStr(token)) {
        NSError *error = [self errorWithErrorInfo:@"You should login first"
                                           domain:@"addDeviceToCloud"
                                             code:RESULT_API_PARAMS_EMPTY];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    
    NSMutableArray *paramList = [NSMutableArray array];
    
    for (MKCOCreatScannerProDeviceModel *deviceModel in deviceList) {
        NSDictionary *params = [deviceModel params];
        if (ValidStr(params[@"error"])) {
            NSError *error = [self errorWithErrorInfo:params[@"error"]
                                               domain:@"addDeviceToCloud"
                                                 code:RESULT_API_PARAMS_EMPTY];
            if (failBlock) {
                failBlock(error);
            }
            return;
        }
        [paramList addObject:params];
    }
    
    // 创建 NSURLSession
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // 创建请求 URL
    NSString *urlString = (isHome ? MKRequstUrl(@"stage-api/mqtt/mqttGateway/batchAdd") : MKTestRequstUrl(@"prod-api/mqtt/mqttGateway/batchAdd"));
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    // 将参数转换为 JSON 数据
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramList options:0 error:&jsonError];
    if (jsonError) {
        if (failBlock) {
            failBlock(jsonError);
        }
        return;
    }
    request.HTTPBody = jsonData;
    
    // 创建 NSURLSessionDataTask
    @weakify(self);
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            [self handleRequestFailed:error failBlock:failBlock];
            return;
        }
        
        // 解析响应数据
        NSError *jsonParsingError;
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if (jsonParsingError) {
            [self handleRequestFailed:jsonParsingError failBlock:failBlock];
            return;
        }
        
        [self handleRequestSuccess:responseObject sucBlock:sucBlock failBlock:failBlock];
    }];
    
    // 开始任务
    [task resume];
    
    // 保存任务
    self.addScannerProDeviceTask = task;
}

- (void)cancelAddScannerProDevice {
    if (self.addScannerProDeviceTask.state == NSURLSessionTaskStateRunning) { //如果要取消的请求正在运行中，才取消
        [self.addScannerProDeviceTask cancel];
    }
}

@end
