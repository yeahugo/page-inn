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

@synthesize  resultText;

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

- (IBAction) borrowButtonTapped
{
	[self scanBarCode];
	theAction = Borrow;
}

- (IBAction) returnButtonTapped
{
	[self scanBarCode];
	theAction = Return;
}

- (IBAction) borrowMatrixCodeButton
{
	[self scanBarCode];
	theAction = BorrowMatrix;
}

- (IBAction) returnMatrixCodeButton
{
	[self scanBarCode];
	theAction = ReturnMatrix;	
}


-(void) scanBarCode
{
	ZBarReaderViewController *reader = [[ZBarReaderViewController alloc] init];
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

#pragma mark UIImagePickerControllerDelegate
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
	
    // EXAMPLE: do something useful with the barcode data
    resultText.text = symbol.data;
	
    [reader dismissModalViewControllerAnimated: YES];
	[reader release];
	[codeString release];
	codeString = symbol.data;
	[codeString retain];
	NSLog(@"codestring is %@",codeString);
	
	
	[self sendRequest];
}

-(void)sendRequest
{
	NSMutableString *urlString = [[NSMutableString alloc] init];
	switch (theAction) {
		case Add:
		{
			[urlString appendString:@"http://10.18.101.249:3000/books/"];

			[urlString appendString:@"isbn/"];
			[urlString appendString:codeString];
			break;
		}
		case Borrow:
		{
			[urlString appendString:@"http://10.18.101.249:3000/books/"];

			[urlString appendString:codeString];
			[urlString appendString:@"/users/"];
			NSString *udidString = [[UIDevice currentDevice] uniqueIdentifier];
			[urlString appendString:udidString];
			
			break;
		}
		case Return:
		{
			[urlString appendString:@"http://10.18.101.249:3000/books/"];

			NSString *udidString = [[UIDevice currentDevice] uniqueIdentifier];
			[urlString appendString:codeString];
			[urlString appendString:@"/users/"];
			[urlString appendString:udidString];
			[urlString appendString:@"/return"];
			break;
		}
		case BorrowMatrix:
		{
			[urlString appendString:@"http://10.18.101.249:3000/matrix/"];
			[urlString appendString:codeString];
			break;		
		}
		case ReturnMatrix:
		{
			[urlString appendString:@"http://10.18.101.249:3000/matrix/"];
			[urlString appendString:codeString];
			[urlString appendString:@"/return"];
			break;
		}
		case BorrowBookMatrix:
		{
			[urlString appendString:@"http://10.18.101.249:3000/booksmatrix/"];
			[urlString appendString:codeString];
			theAction = Borrow;
			break;		
		}
		case ReturnBookMatrix:
		{
			[urlString appendString:@"http://10.18.101.249:3000/booksmatrix/"];
			[urlString appendString:codeString];
			[urlString appendString:@"/return"];
			theAction = Return;
			break;		
		}
		default:
			break;
	}
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *requestc = [NSURLRequest requestWithURL:url];
	[[NSURLConnection alloc] initWithRequest:requestc delegate:self startImmediately:YES];				
}


#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString *refererString = [webView.request valueForHTTPHeaderField:@"Referer"];
	if ([refererString isEqualToString:@"http://10.18.101.249:3000/users/sign_in"]) {
		[loginWebView removeFromSuperview];
				
		UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"登陆成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[successAlertView show];
		[successAlertView release];
		
		[self sendRequest];
	}
	NSLog(@"finish header is %@",[[webView.request allHTTPHeaderFields] description]);
}

#pragma mark NSURLConnection
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
			if (statusCode == 412) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"没有获取到此书籍数据" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
		case Return:
		{
			if (statusCode == 413) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"没有绑定手机" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];		
			}
			if (statusCode == 412) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"没有录入此书籍" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];		
			}
			if (statusCode == 414) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"你没有借入此书籍" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];		
			}
			if (statusCode == 212) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"还书成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];		
			}
			break;		
		}
		case BorrowMatrix:
		{
			if (statusCode == 211) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"获取用户成功,请扫描要借书籍" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				successAlertView.tag = 11;
				[successAlertView show];
				[successAlertView release];	
				
				theAction = BorrowBookMatrix;
			}
			if (statusCode == 412) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"没有二维码相对应用户" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];	
			}
			break;		
		}
		case ReturnMatrix:
		{
			if (statusCode == 211) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"获取用户成功,请扫描要还书籍" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				successAlertView.tag = 11;
				[successAlertView show];
				[successAlertView release];	
				
				theAction = ReturnBookMatrix;
			}
			if (statusCode == 412) {
				UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"没有二维码相对应用户" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[successAlertView show];
				[successAlertView release];	
			}
			break;		
		}
	
		default:
			break;
	}	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag ==11) {
		[self scanBarCode];
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
	[resultText release];
	resultText = nil;
	[loginWebView release];
	loginWebView = nil;
	[codeString release];
	codeString = nil;
    [super dealloc];
}

@end
