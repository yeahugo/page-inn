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
	BorrowMatrix,
	ReturnMatrix,
	BorrowBookMatrix,
	ReturnBookMatrix,
}Action;

@interface pagePhoneViewController : UIViewController< ZBarReaderDelegate,UIWebViewDelegate,UIAlertViewDelegate> {
    UITextView *resultText;
	Action theAction;
	UIWebView *loginWebView;
	NSString *codeString;
    NSString *_hostString;
    UIActivityIndicatorView *_activityIndicatorView;
    NSOperationQueue *_operationQueue;
}

@property (nonatomic, retain) IBOutlet UITextView *resultText;

- (IBAction) addNewbookButtonTapped;
- (IBAction) scanButtonTapped;
- (IBAction) borrowButtonTapped;
- (IBAction) returnButtonTapped;

- (IBAction) borrowMatrixCodeButton;
- (IBAction) returnMatrixCodeButton;

- (void) sendRequest;
- (void) scanBarCode;
@end

