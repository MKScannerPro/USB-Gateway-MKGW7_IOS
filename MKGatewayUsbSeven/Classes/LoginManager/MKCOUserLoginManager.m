//
//  MKCOUserLoginManager.m
//  MKGatewayUsbSeven_Example
//
//  Created by aa on 2025/3/5.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKCOUserLoginManager.h"

#import "MKMacroDefines.h"

static MKCOUserLoginManager *loginManager = nil;
static dispatch_once_t onceToken;

@interface MKCOUserLoginManager ()

@property (nonatomic, copy)NSString *filePath;

@property (nonatomic, strong)NSMutableDictionary *configures;

/// 是否已经登陆
@property (nonatomic, assign)BOOL isLogin;

/// 使用的是否是正式环境
@property (nonatomic, assign)BOOL isHome;

/// 登录的用户名
@property (nonatomic, copy)NSString *username;

/// 登录的密码
@property (nonatomic, copy)NSString *password;

@end

@implementation MKCOUserLoginManager
- (instancetype)init {
    if (self = [super init]) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.filePath = [documentPath stringByAppendingPathComponent:@"co_app.cfg"];
        self.configures = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];
        if (ValidDict(self.configures)) {
            self.isHome = [self.configures[@"isHome"] boolValue];
            self.username = self.configures[@"username"];
            self.password = self.configures[@"password"];
        }else {
            self.configures = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

+ (MKCOUserLoginManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!loginManager) {
            loginManager = [MKCOUserLoginManager new];
        }
    });
    return loginManager;
}

- (void)syncLoginDataWithHome:(BOOL)isHome username:(NSString *)username password:(NSString *)password {
    self.isHome = isHome;
    self.username = username;
    self.password = password;
    [self.configures setObject:@(isHome) forKey:@"isHome"];
    [self.configures setObject:SafeStr(username) forKey:@"username"];
    [self.configures setObject:SafeStr(password) forKey:@"password"];
    
    BOOL result = [self.configures writeToFile:self.filePath atomically:YES];
}

@end
