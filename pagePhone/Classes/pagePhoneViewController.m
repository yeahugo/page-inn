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
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(170, 120, 120, 30)];
	label.textColor = [UIColor blackColor];
	label.text = @"isbn:";
	label.backgroundColor = [UIColor clearColor];
	
	resultText = [[UITextView alloc] initWithFrame:CGRectMake(170, 150, 120, 50)];
	resultText.textAlignment = UITextAlignmentRight;
	
	resultText.backgroundColor = [UIColor clearColor];
	[self.view addSubview:label];
	[self.view addSubview:resultText];

}


- (IBAction) addNewbookButtonTapped
{
	[self scanBarCode];
	theAction = Add;
}

- (IBAction) scanButtonTapped
{
	[self scanBarCode];
	theAction = Scan;
}

-(void) scanBarCode
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
	
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
	
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
	
    [self presentModalViewController: reader
                            animated: YES];	
}


- (IBAction) borrowButtonTapped
{
	[self scanBarCode];
	theAction = Borrow;
}

-(void)sendBorrowRequest
{
	
	NSString *udidString = [[UIDevice currentDevice] uniqueIdentifier];
	
	NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://10.18.101.249:3000/books/"];
	NSLog(@"resultText is %@",resultText.text);
	[urlString appendString:codeString];
	[urlString appendString:@"/users/"];
	[urlString appendString:udidString];
	
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
    resultText.text = symbol.data;
	
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =[info objectForKey: UIImagePickerControllerOriginalImage];
	
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
	[codeString release];
	codeString = symbol.data;
	[codeString retain];
	NSLog(@"codestring is %@",codeString);
	
	
	switch (theAction) {
		case Add:
		{
			NSString *sourceString = [NSString stringWithFormat:@"http://10.18.101.249:3000/books/isbn/"];
			NSString *urlString = [sourceString stringByAppendingString:codeString];
			NSURL *url = [NSURL URLWithString:urlString];
			NSURLRequest *requestc = [NSURLRequest requestWithURL:url];
			[[NSURLConnection alloc] initWithRequest:requestc delegate:self startImmediately:YES];			
			break;
		}
		case Borrow:
		{
			NSLog(@"设备ID:%@",[[UIDevice currentDevice] uniqueIdentifier]);
			
			[self sendBorrowRequest];
			break;
		}
		case Scan:
		{
			
			break;		
		}	

		default:
			break;
	}
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"start loading....");
	//NSString *url = [[webView.request URL]  path];
	
	NSLog(@"header is %@",[[webView.request allHTTPHeaderFields] description]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString *refererString = [webView.request valueForHTTPHeaderField:@"Referer"];
	if ([refererString isEqualToString:@"http://10.18.101.249:3000/users/sign_in"]) {
		[loginWebView removeFromSuperview];
				
		UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"登陆成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[successAlertView show];
		[successAlertView release];
		
		[self sendBorrowRequest];
	}
	NSLog(@"finish header is %@",[[webView.request allHTTPHeaderFields] description]);
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
	NSLog(@"status code is %d",statusCode);
	switch (theAction) {
		case Add:
		{
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
			
			break;	
		}
		case Borrow:
		{
			if (statusCode == 410) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"没有对应的udid号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];
				
				NSString *loginString = @"http://10.18.101.249:3000/users/sign_in";
				NSURL *url = [NSURL URLWithString:loginString];
				NSURLRequest *request = [NSURLRequest requestWithURL:url];
				loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
				loginWebView.delegate = self;
				[loginWebView loadRequest:request];
				[self.view addSubview:loginWebView];
			}
			if (statusCode == 412) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"图书馆还没有此书籍" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];				
			}
			
			if (statusCode == 411) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"此书尚未归还" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];				
			}
			if (statusCode == 211) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"借书成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];				
			}
			
			break;		
		}
		default:
			break;
	}
	
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
