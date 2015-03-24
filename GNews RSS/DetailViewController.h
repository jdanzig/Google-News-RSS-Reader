//
//  DetailViewController.h
//  GNews RSS
//
//  Created by Jon on 2/11/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "BookmarkViewController.h"


@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate, UIPopoverPresentationControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) NSDictionary *linkItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *lastURL;

- (IBAction)TwitterButton:(id)sender;
- (IBAction)FavoriteButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *star;

/*
- (void)viewWillAppear:(BOOL)animated
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor greenColor];
    [self presentViewController:vc animated:NO completion:^{
        NSLog(@"Splash screen is showing");
    }];
}
 */

@end

