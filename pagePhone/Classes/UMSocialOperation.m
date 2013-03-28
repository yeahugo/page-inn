//
//  UMSocialOperation.m
//  UMAdManager
//
//  Created by luyiyuan on 9/5/11.
//  Copyright (c) 2011 umeng.com. All rights reserved.
//

#import "UMSocialOperation.h"

@implementation UMSocialOperation
@synthesize delegate = _delegate;
@synthesize requestString = _requestString;
@synthesize tag = _tag;
@synthesize receivedData = _receivedData;
@synthesize postData = _postData;
@synthesize statusCode = _statusCode;

-(UMSocialOperation *)initWithUrl:(NSString*)aUrlString postBody:(NSData*)postBody  delegate:(id<UMSocialOperDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.requestString = aUrlString;
        _receivedData = [[NSMutableData alloc] init];
        self.postData = postBody;
        self.delegate = delegate;
    }
    return self;
}


-(void)startDoSomething
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestString]];

    if(self.postData&&self.postData.length>0)
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:self.postData];
        
    }
    else {
        [request setHTTPMethod:@"GET"];         
    }
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:10];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    
    _connect = [NSURLConnection connectionWithRequest:request delegate:self]; 
    success = NO;
    
    if (_connect != nil) {
        do{
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];    
        } while (!success) ;
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    self.statusCode = [(NSHTTPURLResponse *)response statusCode];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    
    if(self.delegate&&[self.delegate respondsToSelector:@selector(UMOperate_Finsh:data:error:)])
    {
        [self.delegate UMOperate_Finsh:self data:nil error:error];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _connect = nil;
    success = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{

    if(self.delegate&&[self.delegate respondsToSelector:@selector(UMOperate_Finsh:data:error:)])
    {
        [self.delegate UMOperate_Finsh:self data:self.receivedData error:nil];
    }
    
    _connect = nil;
    success = YES;
    
    _state = UMSocialOperationFinishedState;
}
#pragma mark -

- (void)main 
{
    @autoreleasepool {
        [self startDoSomething];
    }
}
@end
