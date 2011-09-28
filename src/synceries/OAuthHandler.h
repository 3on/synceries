//
//  OAuthHandler.h
//  synceries
//
//  Created by Anita on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2Authentication.h"


@interface OAuthHandler : NSObject {
    GTMOAuth2Authentication* authToken;
}

-(void) pushAuthControllerIn:(UINavigationController*) controller withDelegate:(id) delegate;
-(void) revokeAuth;
@end
