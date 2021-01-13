//
//  AntiDebug.h
//  LuYiFu
//
//  Created by 峰 on 2020/11/18.
//  Copyright © 2020 Oila. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FindBlock)(void);

@interface AntiDebug : NSObject

void openAntiDebugWithMonitorException(FindBlock findBlock);

void openAntiDebugWithOutMonitorException(void);

@end

NS_ASSUME_NONNULL_END
