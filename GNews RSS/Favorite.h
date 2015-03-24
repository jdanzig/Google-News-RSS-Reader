//
//  Favorite.h
//  GNews RSS
//
//  Created by jdanzig on 2/23/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Favorite : NSObject <NSCoding>

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSString *url;

@end
