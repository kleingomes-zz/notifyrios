//
//  ItemCell.h
//  notifyr
//
//  Created by Nelson Narciso on 2015-01-31.
//  Copyright (c) 2015 Nelson Narciso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end
