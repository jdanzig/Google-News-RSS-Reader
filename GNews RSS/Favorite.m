//
//  Favorite.m
//  GNews RSS
//
//  Created by jdanzig on 2/23/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import "Favorite.h"

@implementation Favorite
- (void)encodeWithCoder:(NSCoder *)encoder {
    //[super encodeWithCoder: encoder]; // if super conforms to NSCoding
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.url forKey:@"url"];
}
- (id) initWithCoder:(NSCoder *)decoder {
    //self = [super initWithCoder: decoder]; // if super conforms to NSCoding
    self = [super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.date = [decoder decodeObjectForKey:@"date"];
    self.url = [decoder decodeObjectForKey:@"url"];
    return self;
    
}

@end

/******** DATA PERSISTANCE READ/WRITE FILES
 // File path
 NSError* err = nil;
 NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
 ￼￼inDomain:NSUserDomainMask appropriateForURL:nil
 create:YES error:&err];
 
 ￼// Write
 NSData* sessionData = [NSKeyedArchiver archivedDataWithRootObject:session]; NSURL* file = [docs URLByAppendingPathComponent:@"sessions.plist"];
 [sessionData writeToURL:file atomically:NO];
 DLog(@"DOCS:%@",file);
 
 // Read
 NSData* data = [[NSData alloc] initWithContentsOfURL:file];
 STSession *sessionRetrieved =  (STSession*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
 DLog(@"Retrieved:%@ %@",sessionRetrieved.startTime,sessionRetrieved.uuid);
*********/