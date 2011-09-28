//
//  OAuthHandler.m
//  synceries
//
//  Created by Anita on 05/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OAuthHandler.h"


@implementation OAuthHandler

static NSString* keyChainItemName = @"Synceries:GoogleSpreadsheets";
static NSString* clientId = @"795504765909.apps.googleusercontent.com";
static NSString* clientSecret = @"__c1h8duMqkiBnHX9srjENn1";
static NSString* scope = @"https://spreadsheets.google.com/feeds/ https://docs.google.com/feeds/";

-(void) pushAuthControllerIn:(UINavigationController*) controller withDelegate:(id)delegate {
    GTMOAuth2ViewControllerTouch* viewController;
    GTMOAuth2Authentication* potentialAuth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:keyChainItemName clientID:clientId clientSecret:clientSecret];
    
    if (potentialAuth && [potentialAuth canAuthorize]) {
        [delegate viewController:nil finishedWithAuth:potentialAuth error:nil];
    } else {
        viewController = [[[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope clientID:clientId clientSecret:clientSecret keychainItemName:keyChainItemName delegate:delegate finishedSelector:@selector(viewController:finishedWithAuth:error:)] autorelease];
        [controller pushViewController:viewController animated:true];
    }
}

-(void) revokeAuth {
    id auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:keyChainItemName clientID:clientId clientSecret:clientSecret];
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:keyChainItemName];
    [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:auth];
}

@end
