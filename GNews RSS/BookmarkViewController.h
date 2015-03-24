//
//  BookmarkViewController.h
//  GNews RSS
//
//  Created by jdanzig on 2/16/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Custom Protocol
 */

@protocol BookmarkToWebViewDelegate <NSObject>
- (void)bookmark:(id)sender sendsURL:(NSURL*)url;
@end

@interface BookmarkViewController : UIViewController

@property (weak, nonatomic) id<BookmarkToWebViewDelegate> delegate;
@property (weak, nonatomic) id<BookmarkToWebViewDelegate> delegate2;
@property (weak, nonatomic) IBOutlet UITableView *bookmarkTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)editButtonTapped:(id)sender;

@end
