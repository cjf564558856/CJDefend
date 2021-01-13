//
//  JailbrokenCheck.m
//  LuYiFu
//
//  Created by 峰 on 2020/11/20.
//  Copyright © 2020 Oila. All rights reserved.
//

#import "JailbrokenCheck.h"

#import <sys/stat.h>
#import <dlfcn.h>

static char *JailbrokenPathArr[] = {"/Applications/Cydia.app","/usr/sbin/sshd","/bin/bash","/etc/apt","/Library/MobileSubstrate","/User/Applications/"};

@implementation JailbrokenCheck

bool isJailbroken1(){
    if(TARGET_IPHONE_SIMULATOR)return NO;
    for (int i = 0;i < sizeof(JailbrokenPathArr) / sizeof(char *);i++) {
        if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:JailbrokenPathArr[i]]]){
            return YES;
        }
    }
    return NO;
}

bool isJailbroken2(){
    if(TARGET_IPHONE_SIMULATOR)return NO;
    int ret ;
    Dl_info dylib_info;
    int (*func_stat)(const char *, struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        NSString *fName = [NSString stringWithUTF8String:dylib_info.dli_fname];
        if(![fName isEqualToString:@"/usr/lib/system/libsystem_kernel.dylib"]){
            return YES;
        }
    }
    
    for (int i = 0;i < sizeof(JailbrokenPathArr) / sizeof(char *);i++) {
        struct stat stat_info;
        if (0 == stat(JailbrokenPathArr[i], &stat_info)) {
            return YES;
        }
    }
    
    return NO;
}

bool isJailbroken3(){
    if(TARGET_IPHONE_SIMULATOR)return NO;
    return !(NULL == getenv("DYLD_INSERT_LIBRARIES"));
}

@end
