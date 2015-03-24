//
//  MasterTableViewCell.h
//  GNews RSS
//
//  Created by Jonathan Danzig on 2/13/15.
//  Copyright (c) 2015 Jonathan Danzig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UILabel *Snippet;

@end
