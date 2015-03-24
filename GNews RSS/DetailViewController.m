//
//  DetailViewController.m
//  GNews RSS
//
//  Created by Jon on 2/11/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import "DetailViewController.h"
#import "BookmarkViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) NSMutableArray * favoriteList;
@property (strong, nonatomic) NSMutableDictionary * favoriteInfo;

@end

@implementation DetailViewController
UIView* loadingView;

#pragma mark - Managing the detail item

- (void)setLinkItem:(id)newLinkItem {
    if (_linkItem != newLinkItem) {
        _linkItem = newLinkItem;
            
        // Update the view.
        [self configureView];
        NSLog(@"setter override");
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.linkItem) {
        self.detailDescriptionLabel.text = self.linkItem[@"title"];
        NSURL *url = [NSURL URLWithString:self.linkItem[@"link"]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

        self.lastURL = [self.linkItem objectForKey:@"link"];
        [[NSUserDefaults standardUserDefaults] setObject:self.lastURL forKey:@"lastURL"]; // store link
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // Show star?
    [self.star setHidden:YES];
    if (self.starShow) {
        NSLog(@"Show star VDA");
        [self.star setHidden:NO];
    } else {
        NSLog(@"Don't show star VDA");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastURL"]; // get link
    if(![savedValue isEqual:nil]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:savedValue]]];
    }
    
    _webView.delegate = self;
    
    // begin spinning loading http://stackoverflow.com/questions/19475350/add-an-activity-indicator-on-a-uiwebview
    
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(100, 400, 80, 80)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35.0);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    [self.view addSubview:loadingView];
    // end spinning loading
   
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.favoriteList = [defaults objectForKey:@"favoriteList"];
    
}

- (bool)starShow {
    bool show = false;
    for (NSMutableDictionary *info in self.favoriteList) {
        if ([self.lastURL isEqualToString:info[@"link"]])
            show = true;
    }
    return show;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView setHidden:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [loadingView setHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// From http://rbnsn.me/posts/2014/09/08/ios-8-popover-presentations/
// and http://stackoverflow.com/questions/26723347/app-crashes-when-popover-appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"popoverSegue"]) {
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            NSLog(@"Prepare for iPad segue");
        } else {
            NSLog(@"Prepare for iPhone segue");
        }

        BookmarkViewController *bvc = (BookmarkViewController*)segue.destinationViewController;
        
        // This is the important part
        UIPopoverPresentationController *popPC = bvc.popoverPresentationController;
        popPC.delegate = self;
        bvc.delegate2 = self;
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//----
#pragma mark - BookmarkDelegateProtocol Methods
//----
- (void)bookmark:(id)sender sendsURL:(NSURL *)url {
    NSLog(@"Sending message from bookmarks");
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    // Show star?
    [self.star setHidden:NO];
    NSLog(@"Show star from bookmark");

}


// From http://www.raywenderlich.com/21558/beginning-twitter-tutorial-updated-for-ios-6
- (IBAction)TwitterButton:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ %@ via jdanzig",self.linkItem[@"title"],self.linkItem[@"link"]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)FavoriteButton:(id)sender {
    // reload if changed
    NSLog(@"Clicked Favorite");
    
    if(![self.favoriteList containsObject: self.linkItem] && self.linkItem != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (!self.favoriteList) {
            self.favoriteList = [[NSMutableArray alloc] init];
        }
        [self.favoriteList addObject:self.linkItem];
        
        [self.star setHidden:NO];
        NSLog(@"Show star from button");
    
        [defaults setObject:self.favoriteList forKey:@"favoriteList"];
    }

}
@end