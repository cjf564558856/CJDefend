//
//  WhiteListCheck.h
//  LuYiFu
//
//  Created by 峰 on 2020/11/19.
//  Copyright © 2020 Oila. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InjectionCheck : NSObject

typedef void(^CheckBlock)(const char * imageName);

/// 每次上架前需要调用getWhitelist()获取最新的动态库信息，然后替换libraries
void getWhitelist(void);

bool whitelistCheck(const char* currentLibraries,CheckBlock);

@end

NS_ASSUME_NONNULL_END
