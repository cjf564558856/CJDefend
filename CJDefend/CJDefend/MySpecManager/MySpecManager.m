
//
//  MySpecManager.m
//  LuYiFu
//
//  Created by 峰 on 2020/11/20.
//  Copyright © 2020 Oila. All rights reserved.
//

#import "MySpecManager.h"

#import "AntiDebug.h"
#import "InjectionCheck.h"
#import "JailbrokenCheck.h"
#import "CompleteCheck.h"

static MySpec_t * instance = NULL;

@implementation MySpecManager

+ (MySpec_t *)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = malloc(sizeof(MySpec_t));
        instance->openAntiDebugWithOutMonitorException = _openAntiDebugWithOutMonitorException;
        instance->openAntiDebugWithMonitorException = _openAntiDebugWithMonitorException;
        instance->getWhitelist = _getWhitelist;
        instance->whitelistCheck = _whitelistCheck;
        instance->jailbrokenCheck = _jailbrokenCheck;
        instance->completeCheck = _completeCheck;
        instance->cryptidEncrypted = _cryptidEncrypted;
        instance->openAllMonitor = _openAllMonitor;
    });
    return instance;
}

+ (void)destroy{
    instance ? free(instance): 0;
    instance = NULL;
}

#pragma mark -- Private
static void _openAntiDebugWithMonitorException(FindBlock findBlock){
    openAntiDebugWithMonitorException(^{
        findBlock();
    });
}

static void _openAntiDebugWithOutMonitorException(void){
    openAntiDebugWithOutMonitorException();
}

static void _getWhitelist(void){
    getWhitelist();
}

static void _whitelistCheck(const char* currentLibraries, CheckBlock checkBlock){
    whitelistCheck(currentLibraries,^(const char * _Nonnull imageName) {
        checkBlock(imageName);
    });
};

static void _jailbrokenCheck(FindBlock findBlock){
    if (isJailbroken1() || isJailbroken2() || isJailbroken3()) {
        findBlock();
    }
}

static void _completeCheck(FindBlock findBlock){
    if (!completeCheck()) {
        findBlock();
    }
}

static void _cryptidEncrypted(FindBlock findBlock){
//#ifdef DEBUG
//#else
    if (!isCryptidEncrypted()) {
        findBlock();
    }
//#endif
}

static void _openAllMonitor(const char* currentLibraries,CheckBlock checkBlock,FindBlock antiDebugBlock,FindBlock completeBlock,FindBlock encryptedBlock,FindBlock jailbrokenBlock){
    whitelistCheck(currentLibraries,^(const char * _Nonnull imageName) {
        checkBlock(imageName);
    });
    openAntiDebugWithMonitorException(^{
        antiDebugBlock();
    });
//    if (!completeCheck()) {
//        completeBlock();
//    }
    _completeCheck(completeBlock);
//    if (!isCryptidEncrypted()) {
//        encryptedBlock();
//    }
    _cryptidEncrypted(encryptedBlock);
//    if (isJailbroken1() || isJailbroken2() || isJailbroken3()) {
//        jailbrokenBlock();
//    }
    _jailbrokenCheck(jailbrokenBlock);
}

@end
