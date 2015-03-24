//
//  SharedNetworking.h
//  GNews RSS
//
//  Created by Jon on 2/11/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedNetworking : NSObject
+ (id)sharedSharedNetworking;
- (void)getFeedForURL:(NSString*)url
              success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
              failure:(void (^)(void))failureCompletion;

@end
