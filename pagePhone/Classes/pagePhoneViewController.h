//
//  pagePhoneViewController.h
//  pagePhone
//
//  Created by iOS@Umeng on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface pagePhoneViewController : UIViewController< ZBarReaderDelegate > {
	UIImageView *resultImage;
    UITextView *resultText;
}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextView *resultText;

- (IBAction) addNewbookButtonTapped;
- (IBAction) scanButtonTapped;
- (IBAction) borrowButtonTapped;
@end

