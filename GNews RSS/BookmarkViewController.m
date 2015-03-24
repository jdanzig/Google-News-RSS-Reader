//
//  BookmarkViewController.m
//  GNews RSS
//
//  Created by jdanzig on 2/16/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import "BookmarkViewController.h"
#import "Reachability.h"

@interface BookmarkViewController ()

@property NSMutableArray * favoriteDisplay;

@end

@implementation BookmarkViewController

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.favoriteDisplay = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteList"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteDisplay.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.checkForNetwork) {
        [self.delegate2 bookmark:self sendsURL: [NSURL URLWithString:[[self.favoriteDisplay objectAtIndex:indexPath.row] objectForKey:@"link"]]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"No network connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    //cell.favoriteTitle.text = [[self.favoriteDisplay objectAtIndex:indexPath.row] objectForKey:@"title"];
//    cell.favoriteTitle.text = [[self.favoriteDisplay objectAtIndex:indexPath.row] objectForKey:@"title"];
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:110];
    titleLabel.text = [[self.favoriteDisplay objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if(self.bookmarkTableView.editing) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.favoriteDisplay removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:self.favoriteDisplay forKey:@"favoriteList"];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (IBAction)editButtonTapped:(id)sender {
    
    if(!self.bookmarkTableView.editing) {
        [self.bookmarkTableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done"];
    } else {
        [self.bookmarkTableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit"];
    }
}

@end
