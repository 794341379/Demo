//
//  DWKKitDeafault.h
//  DWKKit
//
//  Created by pisen on 16/10/14.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

#ifndef DWKKitDeafault_h
#define DWKKitDeafault_h

#define kPathDomain                 [DWKConfigDataInstance stringFromConfigByName:@"kPathDomain"]
#define kPathVersion                [DWKConfigDataInstance stringFromConfigByName:@"kPathVersion"]
#define kPathCommon                 [DWKConfigDataInstance stringFromConfigByName:@"kPathCommon"]
#define kCheckNewVersionType        [DWKConfigDataInstance intFromConfigByName:@"kCheckNewVersionType"]
#define kIsRequestEncrypted         [DWKConfigDataInstance boolFromConfigByName:@"kIsRequestEncrypted"]

/**
 * 基本接口地址
 */
#ifndef kPathAppBaseUrl             //普通接口地址前缀，后跟版本号
#define kPathAppBaseUrl         [kPathDomain stringByAppendingFormat:@"/%@",kPathVersion]
#endif
#ifndef kPathAppResUrl              //资源文件前缀
#define kPathAppResUrl          kPathDomain
#endif
#ifndef kPathAppCommonUrl           //公共接口地址前缀，与APP无关，与版本号无关
#define kPathAppCommonUrl       [kPathDomain stringByAppendingFormat:@"/%@",kPathCommon]
#endif

/**
 * 接口名称
 */
#ifndef kPathCheckNewVersion
#define kPathCheckNewVersion    @"CheckNewVersion"
#endif
#ifndef kPathGetServerTime
#define kPathGetServerTime      @"GetServerTime"
#endif


/**
 *  判断设备的相关参数
 */
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width) //屏幕的宽度(point)
#endif
#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height)//屏幕的高度(point)
#endif
#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER           __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#endif
#ifndef IOS8_OR_LATER
#define IOS8_OR_LATER           __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#endif
#ifndef IOS9_OR_LATER
#define IOS9_OR_LATER           __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#endif


#ifndef CURRENT_DATE
#define CURRENT_DATE            [YSCDataInstance currentDate]
#endif
#ifndef USER_ID
#define USER_ID                 @""//TODO:
#endif




#endif /* DWKKitDeafault_h */
