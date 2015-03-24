//
//  SharedNetworking.m
//  GNews RSS
//
//  Created by Jon on 2/11/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import "SharedNetworking.h"

@interface SharedNetworking()
@property (strong, nonatomic) NSURLSession *urlSession;

@end

@implementation SharedNetworking

#pragma mark - Initialization

+ (id)sharedSharedNetworking
{
    static dispatch_once_t pred;
    static SharedNetworking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if ( self = [super init] ) {
    }
    return self;
}

#pragma mark - Requests

- (void)getFeedForURL:(NSString*)url
              success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
              failure:(void (^)(void))failureCompletion
{
    NSURL *gnewsURL = [[NSURL alloc] initWithString:url];
    // put NetworkActivityIndicatorVisible
    [[[NSURLSession sharedSession] dataTaskWithURL:gnewsURL completionHandler:
        ^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Failre Not 200:");
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Call the function (if exists)
                    if (failureCompletion) failureCompletion();
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *jsonError;
                    
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    NSLog(@"DownloadeData:%@",dictionary);
                    
                    // Call the block
                    successCompletion(dictionary,nil);
                });
            }
        }] resume];

    
}

@end
