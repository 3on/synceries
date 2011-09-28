//
//  Cell.h
//  synceries
//
//  Created by Jr on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Cell : UITableViewCell {
    IBOutlet UILabel *textLabel;
    IBOutlet UIImageView *checkImage;
}

@property (retain, nonatomic) UILabel *textLabel;
@property (retain, nonatomic) UIImageView *checkImage;

@end
