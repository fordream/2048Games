//
//  DSUtility.m
//  DreamStreet
//
//  Created by Wenzhao Tan on 3/14/12.
//  Copyright 2012 Hana Mobile LLC. All rights reserved.
//

#import "DSUtility.h"
#import "HanaConfig.h"
#include <CommonCrypto/CommonDigest.h>


@implementation DSUtility

+(NSString*)nameAdapter:(NSString*)fileName{
	if (fileName == nil)
		return nil;
    
    HanaConfig *config = [HanaConfig sharedInstance];
    if (config.useIPadAsset){
        NSString* justFileName = [fileName stringByDeletingPathExtension];
        justFileName = [justFileName stringByAppendingString:@"_ipad"];
	
        NSString* extension = [fileName pathExtension];
        if ([extension length] > 0)
        {
            return [justFileName stringByAppendingPathExtension:extension];
        }
	
        return justFileName;
    }else {
        return fileName;
    }
}

+(NSDate *)getTodayBeginTime{
    NSDate *origToday = [NSDate date];
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *origComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                                    fromDate:origToday];
    [origComponents setHour:0];
    [origComponents setMinute:0];
    [origComponents setSecond:0];
    NSDate *today = [gregorian dateFromComponents:origComponents];
    return today;
}

+(NSString *)sha1:(NSString *)input{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%X", digest[i]];
    }
    
    return output;
}

+(NSString *)md5:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"x", digest[i]];
    }
    return  output;
}

+(NSHTTPCookie *)getCookie:(NSString *)name{
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]){
        if (name != nil && [name compare:[cookie name]] == NSOrderedSame){
            return cookie;
        }
    }
    return nil;
}

+(void)dumpCookies{
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]){
        NSLog(@"name: '%@'\n",   [cookie name]);
        NSLog(@"value: '%@'\n",  [cookie value]);
        NSLog(@"domain: '%@'\n", [cookie domain]);
        NSLog(@"path: '%@'\n",   [cookie path]);
    }
}

+(void)removeEpicCookie{
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        break;
    }
}

@end
