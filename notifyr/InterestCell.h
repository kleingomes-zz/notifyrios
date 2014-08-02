//
//  ReceivedNotificationCellTableViewCell.h
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockQuote;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;


@end
