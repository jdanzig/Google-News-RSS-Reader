//
//  MasterViewController.m
//  GNews RSS
//
//  Created by Jon on 2/11/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SharedNetworking.h"
#import "MasterTableViewCell.h"
#import "Reachability.h"

@interface MasterViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *links;
@property UIRefreshControl *refreshControl;

@end

@implementation MasterViewController

// Copied from http://pinkstone.co.uk/how-to-check-for-network-connectivity-in-ios/
- (BOOL)checkForNetwork
{
    // check if we've got network connectivity
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    
    switch (myStatus) {
        case NotReachable:
            NSLog(@"There's no internet connection at all. Display error message now.");
            return FALSE;
            break;
            
        case ReachableViaWWAN:
            NSLog(@"We have a 3G connection");
            return TRUE;
            break;
            
        case ReachableViaWiFi:
            NSLog(@"We have WiFi.");
            return TRUE;
            break;
            
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    /* Auto-resizing table view cells
    [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:@(NSNotification *note) {
                                                      NSLog(@"Size changed; need to reload table");
                                                      [self.tableView reloadData];
                                                  }];
     */
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    if (self.checkForNetwork) {
        [[SharedNetworking sharedSharedNetworking] getFeedForURL:@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss"
                                                     success:^(NSDictionary *dictionary, NSError *error) {
                                                         self.links = dictionary[@"responseData"][@"feed"][@"entries"];
                                                         
                                                         [self.tableView reloadData];
                                                     }
                                                     failure:^{
                                                         NSLog(@"Failure");
                                                     }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"No network connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        if(self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }

    }
    
    // Do any additional setup after loading the view, typically from a nib.
    // self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector
     (nightReadingChanged) name:@"reopened" object:nil];
    
}

// self-sizing from http://useyourloaf.com/blog/2014/08/07/self-sizing-table-view-cells.html
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void) nightReadingChanged {
    NSLog(@"Reload view");
    if(self.checkForNetwork) {
        [self refreshTable];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"No network connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        if(self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }
}

- (void) refreshTable {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (self.checkForNetwork) {
            [[SharedNetworking sharedSharedNetworking] getFeedForURL:@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss"
                                                     success:^(NSDictionary *dictionary, NSError *error) {
                                                         self.links = dictionary[@"responseData"][@"feed"][@"entries"];
                                                         
                                                         [self.tableView reloadData];
                                                         
                                                         if(self.refreshControl.refreshing) {
                                                             [self.refreshControl endRefreshing];
                                                         }
                                                     }
                                                     failure:^{
                                                         NSLog(@"Failure");
                                                     }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"No network connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        if(self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.links) {
        self.links = [[NSMutableArray alloc] init];
    }
    [self.links insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.checkForNetwork) {
        if ([[segue identifier] isEqualToString:@"showDetail"]) {
            NSLog(@"Prepare for segue");
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSDictionary *link = [self.links objectAtIndex:indexPath.row];
        
            DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
            [controller setLinkItem:link];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
    } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                            message:@"No network connection."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            if(self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.links.count;
}

- (MasterTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSNumber *nightMode = [defaults objectForKey:@"night_reading_preference"];
    if([nightMode  isEqual: @1]){
        NSLog(@"%@",nightMode);
        cell.backgroundColor = [UIColor blackColor];
        cell.Title.textColor = [UIColor whiteColor];
        cell.Date.textColor = [UIColor whiteColor];
        cell.Snippet.textColor = [UIColor whiteColor];
    }
    else{
        NSLog(@"Night Mode Off");
        cell.backgroundColor = [UIColor whiteColor];
        cell.Title.textColor = [UIColor blackColor];
        cell.Date.textColor = [UIColor blackColor];
        cell.Snippet.textColor = [UIColor blackColor];
    }
    
    cell.Title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.Date.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    cell.Snippet.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    cell.Title.text = [[self.links objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.Date.text = [[self.links objectAtIndex:indexPath.row] objectForKey:@"publishedDate"];
    cell.Snippet.text = [[self.links objectAtIndex:indexPath.row] objectForKey:@"contentSnippet"];
    
    [cell layoutIfNeeded]; // Force cell to redraw itself
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.links removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
