//
//  DSUtility.h
//  DreamStreet
//
//  Created by Wenzhao Tan on 3/14/12.
//  Copyright 2012 Hana Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSUtility : NSObject {
    
}

/** Takes a string that is a filename (with or without path component) and returns the correct filename depending on the current device.
 On iPhone/iPod Touch it will simply return fileName. On iPad it will append "-ipad" to the filename and before the suffix and return that.
 By naming all corresponding iPad assets with the "_ipad" suffix and using this function you can avoid a lot of #ifdef and load different
 resource files with the same code. */
+(NSString*)nameAdapter:(NSString*)fileName;
+(NSDate *)getTodayBeginTime;

+(NSString *)sha1:(NSString *)input;
+(NSString *)md5:(NSString *)input;

+(NSHTTPCookie *)getCookie:(NSString *)name;
+(void)dumpCookies;
+(void)removeEpicCookie;

@end
