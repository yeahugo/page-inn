//
//  pagePhoneViewController.m
//  pagePhone
//
//  Created by iOS@Umeng on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "pagePhoneViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation pagePhoneViewController

@synthesize resultImage, resultText;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.userInteractionEnabled = YES;
	
//	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
//	button.backgroundColor = [UIColor blueColor];
//	[button setTitle:@"code" forState:UIControlStateNormal];
//	[button addTarget:self action:@selector(scanButtonTapped) forControlEvents:UIControlEventTouchUpOutside];
//	[self.view addSubview:button];	
}


- (IBAction) addNewbookButtonTapped
{
	
	NSLog(@"addNewbookButtonTapped.....");
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
	
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
	
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
	
    // present and release the controller
	//reader.showsCameraControls = YES; 
    [self presentModalViewController: reader
                            animated: YES];	
}

- (IBAction) scanButtonTapped
{

}

- (IBAction) borrowButtonTapped
{
	NSLog(@"设备ID:%@",[[UIDevice currentDevice] uniqueIdentifier]);
	
	NSString *udidString = [[UIDevice currentDevice] uniqueIdentifier];
	
	NSString *sourceString = [NSString stringWithFormat:@"http://10.18.101.249:3000/books/9787222064331/users/"];
	NSString *urlString = [sourceString stringByAppendingString:udidString];
	NSLog(@"usrl string is %@",urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *requestc = [NSURLRequest requestWithURL:url];
	[[NSURLConnection alloc] initWithRequest:requestc delegate:self startImmediately:YES];	
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
	
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
	
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =[info objectForKey: UIImagePickerControllerOriginalImage];
	
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
	NSString *codeString = symbol.data;
	NSLog(@"codestring is %@",codeString);
	
	NSString *sourceString = [NSString stringWithFormat:@"http://10.18.101.249:3000/books/isbn/"];
	NSString *urlString = [sourceString stringByAppendingString:codeString];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *requestc = [NSURLRequest requestWithURL:url];
	[[NSURLConnection alloc] initWithRequest:requestc delegate:self startImmediately:YES];
	
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSInteger statusCode = [response statusCode];
	if (statusCode == 200) {
		UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"录入图书成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[successAlertView show];
		[successAlertView release];
	}
	else if(statusCode == 500) {
		UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"录入图书失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[successAlertView show];
		[successAlertView release];
	}
	else if(statusCode == 600) {
		UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"此图书已存在" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[successAlertView show];
		[successAlertView release];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
