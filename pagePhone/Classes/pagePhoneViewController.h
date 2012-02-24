//
//  pagePhoneViewController.h
//  pagePhone
//
//  Created by iOS@Umeng on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

typedef enum{
	Scan = 0,
	Add,
	Borrow,
	Return,
}Action;

@interface pagePhoneViewController : UIViewController< ZBarReaderDelegate,UIWebViewDelegate> {
    UITextView *resultText;
	Action theAction;
	UIWebView *loginWebView;
	NSString *codeString;
}

@property (nonatomic, retain) IBOutlet UITextView *resultText;

- (IBAction) addNewbookButtonTapped;
- (IBAction) scanButtonTapped;
- (IBAction) borrowButtonTapped;
- (IBAction) returnButtonTapped;

-(void) sendRequest;
-(void) scanBarCode;
@end

