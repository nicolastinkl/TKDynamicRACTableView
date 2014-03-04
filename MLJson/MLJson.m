//
//  MLJson.m
//  MolonFrame
//
//  Created by Molon on 13-9-29.
//  Copyright (c) 2013年 Molon. All rights reserved.
//
// The NSData MUST be UTF8 encoded JSON.

#import "MLJson.h"

////////////
#pragma mark Deserializing methods
////////////

@implementation NSString (JSONKitDeserializing)

- (id)objectFromJSONString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data objectFromJSONData];
}

- (id)mutableObjectFromJSONString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data mutableObjectFromJSONData];
}

@end

@implementation NSData (JSONKitDeserializing)

- (id)objectFromJSONData
{
    return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:NULL];
}

- (id)mutableObjectFromJSONData
{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:NULL];
}

@end

////////////
#pragma mark Serializing methods
////////////
@implementation NSDictionary (JSONKitSerializing)

// Object转换为NSData
- (NSData *)JSONData
{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
}

// Object转换为NSString
- (NSString *)JSONString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (BOOL)isValidJSONObject
{
    return [NSJSONSerialization isValidJSONObject:self];
}

@end


@implementation NSArray (JSONKitSerializing)

// Object转换为NSData
- (NSData *)JSONData
{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
}

// Object转换为NSString
- (NSString *)JSONString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (BOOL)isValidJSONObject
{
    return [NSJSONSerialization isValidJSONObject:self];
}

@end
