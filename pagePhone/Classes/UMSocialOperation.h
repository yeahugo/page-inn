//
//  UMSocialOperation.h
//  UMAdManager
//
//  Created by luyiyuan on 9/5/11.
//  Copyright (c) 2011 umeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    UMSocialOperationPausedState      = -1,
    UMSocialOperationReadyState       = 1,
    UMSocialOperationExecutingState   = 2,
    UMSocialOperationFinishedState    = 3,
} UMSocialOperationState;

@class UMSocialOperation;

@protocol UMSocialOperDelegate <NSObject>
-(void)UMOperate_Finsh:(UMSocialOperation *)op data:(NSData*)data error:(NSError *)err;
@end

@interface UMSocialOperation : NSOperation
{
@private
    BOOL                success;
    id<UMSocialOperDelegate>  __unsafe_unretained _delegate;
    NSInteger           _tag;
    NSInteger           _statusCode;
    NSString            *_requestString;
    NSMutableData       *_receivedData;
    NSData              *_postData;
    NSURLConnection     *_connect;
    UMSocialOperationState _state;
}
@property (nonatomic)           NSInteger tag;
@property (nonatomic)           NSInteger statusCode;
@property (nonatomic,unsafe_unretained)    id<UMSocialOperDelegate> delegate;
@property (nonatomic,copy)      NSString *requestString;
@property (nonatomic,strong)    NSMutableData *receivedData;
@property (nonatomic,strong)    NSData *postData;

- (UMSocialOperation *)initWithUrl:(NSString*)aUrlString postBody:(NSData*)postBody delegate:(id<UMSocialOperDelegate>)delegate;
@end
