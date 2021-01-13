//
//  CompleteCheck.m
//  LuYiFu
//
//  Created by 峰 on 2020/11/24.
//  Copyright © 2020 Oila. All rights reserved.
//

#import "CompleteCheck.h"

#import <mach-o/loader.h>
#import <mach-o/dyld.h>

#define CPU_SUBTYPES_SUPPORTED  ((__arm__ || __arm64__ || __x86_64__) && !TARGET_IPHONE_SIMULATOR)

#if __LP64__
#define macho_header                mach_header_64
#define LC_SEGMENT_COMMAND        LC_SEGMENT_64
#define LC_SEGMENT_COMMAND_WRONG LC_SEGMENT
#define LC_ENCRYPT_COMMAND        LC_ENCRYPTION_INFO
#define macho_segment_command    segment_command_64
#define macho_section            section_64
#else
#define macho_header                mach_header
#define LC_SEGMENT_COMMAND        LC_SEGMENT
#define LC_SEGMENT_COMMAND_WRONG LC_SEGMENT_64
#define LC_ENCRYPT_COMMAND        LC_ENCRYPTION_INFO_64
#define macho_segment_command    segment_command
#define macho_section            section
#endif

@implementation CompleteCheck


bool completeCheck(){
    char *env2 = getenv("XPC_SERVICE_NAME");
    NSString *res2 = [NSString stringWithFormat:@"%s",env2];
    return [res2 containsString:@"com.luyifu.gtxy"];
}

bool isCryptidEncrypted()
{
    const struct macho_header * mh = _dyld_get_image_header(0);

    const uint32_t cmd_count = mh->ncmds;
    const struct load_command* const cmds = (struct load_command*)(((char*)mh)+sizeof(struct macho_header));
    const struct load_command* cmd = cmds;
    for (uint32_t i = 0; i < cmd_count; ++i) {
        if (cmd->cmd == LC_ENCRYPTION_INFO_64 || cmd->cmd == LC_ENCRYPT_COMMAND) {
            const struct encryption_info_command* enc = (struct encryption_info_command*)cmd;
            return (enc->cryptid == 1);
        }
        cmd = (const struct load_command*)(((char*)cmd)+cmd->cmdsize);
    }

    return false;
}


@end
