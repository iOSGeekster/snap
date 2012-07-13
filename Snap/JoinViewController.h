//
//  JoinViewController.h
//  Snap
//
//  Created by Jesper Nielsen on 01/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchMakingClient.h"
@class JoinViewController;
@protocol JoinViewControllerDelegate <NSObject>

- (void)joinViewControllerDidCancel:(JoinViewController *)controller;
- (void)joinViewController:(JoinViewController *)controller didDisconnectWithReason:(QuitReason)reason;

@end
@interface JoinViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MatchmakingClientDelegate>
@property (nonatomic, weak) id <JoinViewControllerDelegate> delegate;
@end
