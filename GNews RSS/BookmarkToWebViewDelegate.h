//
//  BookmarkToWebViewDelegate.h
//  GNews RSS
//
//  Created by jdanzig on 2/16/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BookmarkToWebViewDelegate <NSObject>
- (void)bookmark:(id)sender sendsURL:(NSURL*)url;
@end
