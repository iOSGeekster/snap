//
//  GameViewController.m
//  Snap
//
//  Created by Jesper Nielsen on 15/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "GameViewController.h"
#import "UIFont+SnapAdditions.h"
@interface GameViewController ()
@property (nonatomic, weak) IBOutlet UILabel *centerLabel;
@end

@implementation GameViewController
@synthesize delegate = _delegate;
@synthesize game = _game;
@synthesize centerLabel = _centerLabel;

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc %@", self);
#endif
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.centerLabel.font = [UIFont jn_snapFontWithSize:18.0f];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - Actions

- (IBAction)exitAction:(id)sender{
    [self.game quitGameWithReason:QuitReasonUserQuit];
}

#pragma mark - GameDelegate

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason{
    [self.delegate gameViewController:self didQuitWithReason:reason];
}

- (void)gameWaitingForServerReady:(Game *)game{
    self.centerLabel.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
}

- (void)gameWaitingForClientsReady:(Game *)game{
    self.centerLabel.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
}



@end
