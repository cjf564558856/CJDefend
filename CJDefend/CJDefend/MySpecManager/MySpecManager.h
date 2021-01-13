//
//  MySpecManager.h
//  LuYiFu
//
//  Created by 峰 on 2020/11/20.
//  Copyright © 2020 Oila. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MySpec ([MySpecManager share])

NS_ASSUME_NONNULL_BEGIN

typedef void(^FindBlock)(void);
typedef void(^CheckBlock)(const char * imageName);

typedef struct _spec_t {
    void (*openAntiDebugWithMonitorException)(FindBlock findBlock);
    void (*openAntiDebugWithOutMonitorException)(void);
    
    void (*getWhitelist)(void);
    void (*whitelistCheck)(const char* currentLibraries, CheckBlock checkBlock);
    
    void (*jailbrokenCheck)(FindBlock findBlock);
    
    void (*completeCheck)(FindBlock findBlock);
    void (*cryptidEncrypted)(FindBlock findBlock);
    
    void (*openAllMonitor)(const char* currentLibraries,CheckBlock checkBlock,FindBlock antiDebugBlock,FindBlock completeBlock,FindBlock encryptedBlock,FindBlock jailbrokenBlock);
}MySpec_t ;

@interface MySpecManager : NSObject

+ (MySpec_t *)share;

@end

NS_ASSUME_NONNULL_END
