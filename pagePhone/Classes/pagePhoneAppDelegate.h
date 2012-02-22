//
//  pagePhoneAppDelegate.h
//  pagePhone
//
//  Created by iOS@Umeng on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pagePhoneViewController;

@interface pagePhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    pagePhoneViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet pagePhoneViewController *viewController;

@end

