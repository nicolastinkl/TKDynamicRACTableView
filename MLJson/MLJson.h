//
//  MLJson.h
//  MolonFrame
//
//  Created by Molon on 13-9-29.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////
#pragma mark Deserializing methods
////////////

@interface NSString (JSONKitDeserializing)
- (id)objectFromJSONString;
- (id)mutableObjectFromJSONString;
@end

@interface NSData (JSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData;
- (id)mutableObjectFromJSONData;
@end

////////////
#pragma mark Serializing methods
////////////

@interface NSArray (JSONKitSerializing)
- (NSData *)JSONData;
- (NSString *)JSONString;
- (BOOL)isValidJSONObject;
@end

@interface NSDictionary (JSONKitSerializing)
- (NSData *)JSONData;
- (NSString *)JSONString;
- (BOOL)isValidJSONObject;
@end
