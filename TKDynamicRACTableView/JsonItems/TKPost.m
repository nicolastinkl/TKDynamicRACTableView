//
//  TKPost.m
//  TKDynamicRACTableView
//
//  Created by tinkl on 10/5/14.
//  Copyright (c) 2014 ___TINKL___. All rights reserved.
//

#import "TKPost.h"
#import "TKUtilsMacro.h"

@implementation TKPost



/*
 + (JSONKeyMapper *)keyMapper
 {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        //.......
    }];
 }

 */

/*!
 *  url
 *
 *
    @return http://petta-moment.qiniudn.com/1399690172226_moment_3457.jpg-moment.petta
 */
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

/*!
 *   @return http://petta-moment.qiniudn.com/1399690172226_moment_3457.jpg-moment.petta
 *
 *  @param momenttoken <#momenttoken description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)imageURLWithmoment:(NSString *) momenttoken
{
    return F(@"%@-%@",self.momenturl, testIMAGEURLToken);
}

/*!
 *  http://petta-photo.qiniudn.com/user_photo_24653.jpg
 *
 */
- (NSString *)imageURLWithUser
{
    return F(@"http://petta-photo.qiniudn.com/user_photo_%ld.jpg",self.userid);
}

@end
