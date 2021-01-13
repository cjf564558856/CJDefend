//
//  AntiDebug.m
//  LuYiFu
//
//  Created by 峰 on 2020/11/18.
//  Copyright © 2020 Oila. All rights reserved.
//

#import "AntiDebug.h"
#import <sys/sysctl.h>
#import "MyPtraceHeader.h"

@implementation AntiDebug

void openAntiDebugWithMonitorException(FindBlock findBlock){
//#ifdef DEBUG
//#else
    openAntiDebugWithOutMonitorException();
    debugCheck(findBlock);
//#endif
}

void openAntiDebugWithOutMonitorException(){
#ifdef DEBUG
#else
    ptrace(PT_DENY_ATTACH, 0, 0, 0);
    syscall(26,31,0,0,0);
#endif
}

BOOL isDebugger(){
    int name[4];
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    
    struct kinfo_proc info;
    size_t info_size = sizeof(info);

    int error = sysctl(name, sizeof(name)/sizeof(*name), &info, &info_size, 0, 0);
    
    assert(error == 0);
    
    return (info.kp_proc.p_flag & P_TRACED);
}

static  dispatch_source_t timer ;

void debugCheck(FindBlock findBlock){
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 60.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (isDebugger()) {
            //存在调试
            findBlock();
        }else{
           //没有调试"
        }
    });
    dispatch_resume(timer);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * 3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_source_cancel(timer);
    });
}



@end
