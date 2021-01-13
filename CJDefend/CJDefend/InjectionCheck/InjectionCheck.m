

//
//  WhiteListCheck.m
//  LuYiFu
//
//  Created by 峰 on 2020/11/19.
//  Copyright © 2020 Oila. All rights reserved.
//

#import "InjectionCheck.h"

#import <mach-o/dyld.h>
#import <mach-o/loader.h>

@implementation InjectionCheck

void getWhitelist(){
    int count = _dyld_image_count();

    for (int i = 0; i < count; i++) {
        const char * imageName = _dyld_get_image_name(i);
        printf("%s",imageName);
    }
    printf("\n\n\n--------------------------🎉🍺🎆🔓动态库输出结束🔓🎆🍺🎉---------------------------\n\n\n");
}

bool whitelistCheck(const char* currentLibraries,CheckBlock checkBlock){
    int count = _dyld_image_count();
    
    for (int i = 0; i < count; i++) {
        const char * imageName = _dyld_get_image_name(i);
        if (!strstr(currentLibraries,imageName)&&!strstr(imageName, "/var/containers/Bundle/Application")) {
            //该库有危险
            checkBlock(imageName);
            return NO;
        }
    }
    return YES;
}

@end
