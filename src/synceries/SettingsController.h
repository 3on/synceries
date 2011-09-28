//
//  SettingsController.h
//  synceries
//
//  Created by Jr on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthHandler.h"


@interface SettingsController : UIViewController {
    IBOutlet UIButton *buttonDeconnexion;
    
    UIViewController* rootController;
    SEL onRevoke;
}

@property(assign) SEL onRevoke;
@property(assign) UIViewController* rootController;
@property(retain, nonatomic) UIButton* buttonDeconnexion;


@end
