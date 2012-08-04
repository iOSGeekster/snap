//
//  GameViewController.m
//  Snap
//
//  Created by Jesper Nielsen on 15/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "GameViewController.h"
#import "UIFont+SnapAdditions.h"
#import "Game.h"
#import "Card.h"
#import "CardView.h"
#import "Player.h"
#import "Stack.h"
@interface GameViewController ()
@property (nonatomic, weak) IBOutlet UILabel *centerLabel;
@end

@implementation GameViewController{
    UIAlertView *_alertView;
    AVAudioPlayer *_dealingCardsSound;
}

@synthesize delegate = _delegate;
@synthesize game = _game;
@synthesize centerLabel = _centerLabel;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize cardContainerView = _cardContainerView;
@synthesize turnOverButton = _turnOverButton;
@synthesize snapButton = _snapButton;
@synthesize nextRoundButton = _nextRoundButton;
@synthesize wrongSnapImageView = _wrongSnapImageView;
@synthesize correctSnapImageView = _correctSnapImageView;

@synthesize playerNameBottomLabel = _playerNameBottomLabel;
@synthesize playerNameLeftLabel = _playerNameLeftLabel;
@synthesize playerNameTopLabel = _playerNameTopLabel;
@synthesize playerNameRightLabel = _playerNameRightLabel;

@synthesize playerWinsBottomLabel = _playerWinsBottomLabel;
@synthesize playerWinsLeftLabel = _playerWinsLeftLabel;
@synthesize playerWinsTopLabel = _playerWinsTopLabel;
@synthesize playerWinsRightLabel = _playerWinsRightLabel;

@synthesize playerActiveBottomImageView = _playerActiveBottomImageView;
@synthesize playerActiveLeftImageView = _playerActiveLeftImageView;
@synthesize playerActiveTopImageView = _playerActiveTopImageView;
@synthesize playerActiveRightImageView = _playerActiveRightImageView;

@synthesize snapIndicatorBottomImageView = _snapIndicatorBottomImageView;
@synthesize snapIndicatorLeftImageView = _snapIndicatorLeftImageView;
@synthesize snapIndicatorTopImageView = _snapIndicatorTopImageView;
@synthesize snapIndicatorRightImageView = _snapIndicatorRightImageView;

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc %@", self);
#endif
    
    [_dealingCardsSound stop];
    [[AVAudioSession sharedInstance] setActive:NO error:NULL];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.centerLabel.font = [UIFont jn_snapFontWithSize:18.0f];
    
    self.snapButton.hidden = YES;
    self.nextRoundButton.hidden = YES;
    self.wrongSnapImageView.hidden = YES;
    self.correctSnapImageView.hidden = YES;
    
    [self hidePlayerLabels];
    [self hideActivePlayerIndicator];
    [self hideSnapIndicators];
    
    [self loadSounds];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_alertView dismissWithClickedButtonIndex:_alertView.cancelButtonIndex animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - Game UI

- (void)hidePlayerLabels
{
	self.playerNameBottomLabel.hidden = YES;
	self.playerWinsBottomLabel.hidden = YES;
    
	self.playerNameLeftLabel.hidden = YES;
	self.playerWinsLeftLabel.hidden = YES;
    
	self.playerNameTopLabel.hidden = YES;
	self.playerWinsTopLabel.hidden = YES;
    
	self.playerNameRightLabel.hidden = YES;
	self.playerWinsRightLabel.hidden = YES;
}

- (void)hideActivePlayerIndicator
{
	self.playerActiveBottomImageView.hidden = YES;
	self.playerActiveLeftImageView.hidden   = YES;
	self.playerActiveTopImageView.hidden    = YES;
	self.playerActiveRightImageView.hidden  = YES;
}

- (void)hideSnapIndicators
{
	self.snapIndicatorBottomImageView.hidden = YES;
	self.snapIndicatorLeftImageView.hidden   = YES;
	self.snapIndicatorTopImageView.hidden    = YES;
	self.snapIndicatorRightImageView.hidden  = YES;
}

- (void)showPlayerLabels{
    Player *player = [self.game playerAtPosition:PlayerPositionBottom];
    if (player != nil) {
        self.playerNameBottomLabel.hidden = NO;
        self.playerWinsBottomLabel.hidden = NO;
    }
    
    player = [self.game playerAtPosition:PlayerPositionLeft];
	if (player != nil)
	{
		self.playerNameLeftLabel.hidden = NO;
		self.playerWinsLeftLabel.hidden = NO;
	}
    
	player = [self.game playerAtPosition:PlayerPositionTop];
	if (player != nil)
	{
		self.playerNameTopLabel.hidden = NO;
		self.playerWinsTopLabel.hidden = NO;
	}
    
	player = [self.game playerAtPosition:PlayerPositionRight];
	if (player != nil)
	{
		self.playerNameRightLabel.hidden = NO;
		self.playerWinsRightLabel.hidden = NO;
	}
}

- (void)updateWinsLabels{
    NSString *format = NSLocalizedString(@"%d Won", @"Number of games won");
    
    Player *player = [self.game playerAtPosition:PlayerPositionBottom];
    if (player != nil) {
        self.playerWinsBottomLabel.text = [NSString stringWithFormat:format, player.gamesWon];
    }
    
    player = [self.game playerAtPosition:PlayerPositionLeft];
    if (player != nil) {
        self.playerWinsLeftLabel.text = [NSString stringWithFormat:format, player.gamesWon];
    }
    
    player = [self.game playerAtPosition:PlayerPositionTop];
    if (player != nil) {
        self.playerWinsTopLabel.text = [NSString stringWithFormat:format, player.gamesWon];
    }
    
    player = [self.game playerAtPosition:PlayerPositionRight];
    if (player != nil) {
        self.playerWinsRightLabel.text = [NSString stringWithFormat:format, player.gamesWon];
    }
}

- (void)resizeLabelToFit:(UILabel *)label{
    [label sizeToFit];
    
    CGRect rect = label.frame;
    rect.size.width = ceilf(rect.size.width/2.0f) * 2.0f; // make even
    rect.size.height = ceilf(rect.size.height/2.0f) * 2.0f; //make even
    label.frame = rect;
}

- (void)calculateLabelFrames{
    UIFont *font = [UIFont jn_snapFontWithSize:14.0f];
	self.playerNameBottomLabel.font = font;
	self.playerNameLeftLabel.font = font;
	self.playerNameTopLabel.font = font;
	self.playerNameRightLabel.font = font;
    
	font = [UIFont jn_snapFontWithSize:11.0f];
	self.playerWinsBottomLabel.font = font;
	self.playerWinsLeftLabel.font = font;
	self.playerWinsTopLabel.font = font;
	self.playerWinsRightLabel.font = font;
    
	self.playerWinsBottomLabel.layer.cornerRadius = 4.0f;
	self.playerWinsLeftLabel.layer.cornerRadius = 4.0f;
	self.playerWinsTopLabel.layer.cornerRadius = 4.0f;
	self.playerWinsRightLabel.layer.cornerRadius = 4.0f;
    
	UIImage *image = [[UIImage imageNamed:@"ActivePlayer"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
	self.playerActiveBottomImageView.image = image;
	self.playerActiveLeftImageView.image = image;
	self.playerActiveTopImageView.image = image;
	self.playerActiveRightImageView.image = image;
    
	CGFloat viewWidth = self.view.bounds.size.width;
	CGFloat centerX = viewWidth / 2.0f;
    
	Player *player = [self.game playerAtPosition:PlayerPositionBottom];
	if (player != nil)
	{
		self.playerNameBottomLabel.text = player.name;
        
		[self resizeLabelToFit:self.playerNameBottomLabel];
		CGFloat labelWidth = self.playerNameBottomLabel.bounds.size.width;
        
		CGPoint point = CGPointMake(centerX - 19.0f - 3.0f, 306.0f);
		self.playerNameBottomLabel.center = point;
        
		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsBottomLabel.center = winsPoint;
        
		self.playerActiveBottomImageView.frame = CGRectMake(0, 0, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
        
		point.x = centerX - 9.0f;
		self.playerActiveBottomImageView.center = point;
	}
    
	player = [self.game playerAtPosition:PlayerPositionLeft];
	if (player != nil)
	{
		self.playerNameLeftLabel.text = player.name;
        
		[self resizeLabelToFit:self.playerNameLeftLabel];
		CGFloat labelWidth = self.playerNameLeftLabel.bounds.size.width;
        
		CGPoint point = CGPointMake(2.0 + 20.0f + labelWidth/2.0f, 48.0f);
		self.playerNameLeftLabel.center = point;
        
		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsLeftLabel.center = winsPoint;
        
		self.playerActiveLeftImageView.frame = CGRectMake(2.0f, 38.0f, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
	}
    
	player = [self.game playerAtPosition:PlayerPositionTop];
	if (player != nil)
	{
		self.playerNameTopLabel.text = player.name;
        
		[self resizeLabelToFit:self.playerNameTopLabel];
		CGFloat labelWidth = self.playerNameTopLabel.bounds.size.width;
        
		CGPoint point = CGPointMake(centerX - 19.0f - 3.0f, 15.0f);
		self.playerNameTopLabel.center = point;
        
		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsTopLabel.center = winsPoint;
        
		self.playerActiveTopImageView.frame = CGRectMake(0, 0, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
        
		point.x = centerX - 9.0f;
		self.playerActiveTopImageView.center = point;
	}
    
	player = [self.game playerAtPosition:PlayerPositionRight];
	if (player != nil)
	{
		self.playerNameRightLabel.text = player.name;
        
		[self resizeLabelToFit:self.playerNameRightLabel];
		CGFloat labelWidth = self.playerNameRightLabel.bounds.size.width;
        
		CGPoint point = CGPointMake(viewWidth - labelWidth/2.0f - 2.0f - 6.0f - 38.0f - 12.0f, 48.0f);
		self.playerNameRightLabel.center = point;
        
		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsRightLabel.center = winsPoint;
        
		self.playerActiveRightImageView.frame = CGRectMake(self.playerNameRightLabel.frame.origin.x - 20.0f, 38.0f, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
	}
}

- (void)hidePlayerLabelsForPlayer:(Player *)player{
    switch (player.position) {
        case PlayerPositionBottom:
            self.playerNameBottomLabel.hidden = YES;
            self.playerWinsBottomLabel.hidden = YES;
            break;
        case PlayerPositionLeft:
            self.playerNameLeftLabel.hidden = YES;
            self.playerWinsLeftLabel.hidden = YES;
            break;
        case PlayerPositionTop:
            self.playerNameTopLabel.hidden = YES;
            self.playerWinsTopLabel.hidden = YES;
            break;
        case PlayerPositionRight:
            self.playerNameRightLabel.hidden = YES;
            self.playerWinsRightLabel.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)hideActiveIndicatorForPlayer:(Player *)player{
    switch (player.position) {
        case PlayerPositionBottom:
            self.playerActiveBottomImageView.hidden = YES;
            break;
        case PlayerPositionLeft:
            self.playerActiveLeftImageView.hidden = YES;
            break;
        case PlayerPositionTop:
            self.playerActiveTopImageView.hidden = YES;
            break;
        case PlayerPositionRight:
            self.playerActiveRightImageView.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)hideSnapIndicatorForPlayer:(Player *)player{
    switch (player.position) {
        case PlayerPositionBottom:
            self.snapIndicatorBottomImageView.hidden = YES;
            break;
        case PlayerPositionLeft:
            self.snapIndicatorLeftImageView.hidden = YES;
            break;
        case PlayerPositionTop:
            self.snapIndicatorTopImageView.hidden = YES;
            break;
        case PlayerPositionRight:
            self.snapIndicatorRightImageView.hidden = YES;
            break;
        default:
            break;
    }
}

#pragma mark - Actions

- (IBAction)exitAction:(id)sender{
    if (self.game.isServer) {
        _alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"End game?", @"Alert title (user is host)") message:NSLocalizedString(@"This will terminate the game for all other players.", @"Alert message (user is host)") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"Button: No") otherButtonTitles:NSLocalizedString(@"Yes", @"Button: Yes"), nil];
    }else {
        _alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Leave the game?", @"Alert title (user is not the host") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"Button: No") otherButtonTitles:NSLocalizedString(@"Yes", @"Button: Yes"), nil];
    }
    
    [_alertView show];
}

- (IBAction)turnOverPressed:(id)sender
{
}

- (IBAction)turnOverEnter:(id)sender
{
}

- (IBAction)turnOverExit:(id)sender
{
}

- (IBAction)turnOverAction:(id)sender
{
}

- (IBAction)snapAction:(id)sender
{
}

- (IBAction)nextRoundAction:(id)sender
{
}

#pragma mark - UIViewAlert delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        [self.game quitGameWithReason:QuitReasonUserQuit];
    }
}

#pragma mark - GameDelegate

- (void)gameDidBegin:(Game *)game{
    [self showPlayerLabels];
    [self calculateLabelFrames];
    [self updateWinsLabels];
}

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason{
    [self.delegate gameViewController:self didQuitWithReason:reason];
}

- (void)gameWaitingForServerReady:(Game *)game{
    self.centerLabel.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
}

- (void)gameWaitingForClientsReady:(Game *)game{
    self.centerLabel.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
}

- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer{
    [self hidePlayerLabelsForPlayer:disconnectedPlayer];
    [self hideActiveIndicatorForPlayer:disconnectedPlayer];
    [self hideSnapIndicatorForPlayer:disconnectedPlayer];
}

- (void)gameShouldDealCards:(Game *)game startingWithPlayer:(Player *)startingPlayer{
    self.centerLabel.text = NSLocalizedString(@"Dealing...", @"Status text: dealing");
    
    self.snapButton.hidden = YES;
    self.nextRoundButton.hidden = YES;
    
    NSTimeInterval delay = 1.0f;
    
    //Sound code
    _dealingCardsSound.currentTime = 0.0f;
    [_dealingCardsSound prepareToPlay];
    [_dealingCardsSound performSelector:@selector(play) withObject:nil afterDelay:delay];
    
    for (int t = 0; t < 26; ++t) {
        for (PlayerPosition p = startingPlayer.position; p < startingPlayer.position +4; ++p) {
            Player *player = [self.game playerAtPosition:p % 4];
            if (player != nil && t < [player.closedCards cardCount]) {
                CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 0, CardWidth, CardHeight)];
                cardView.card = [player.closedCards cardAtIndex:t];
                [self.cardContainerView addSubview:cardView];
                [cardView animateDealingToPlayer:player withDelay:delay];
                delay += 0.1f;
            }
        }
    }
    
    [self performSelector:@selector(afterDealing) withObject:nil afterDelay:delay];
    
}

- (void)afterDealing{
    [_dealingCardsSound stop];
    self.snapButton.hidden = NO;
    [self.game beginRound];
}

- (void)game:(Game *)game didActivatePlayer:(Player *)player{
    [self showIndicatorForActivePlayer];
    self.snapButton.enabled = YES;
}

- (void)showIndicatorForActivePlayer{
    [self hideActivePlayerIndicator];
    PlayerPosition position = [self.game activePlayer].position;
    
    switch (position) {
        case PlayerPositionBottom:
            self.playerActiveBottomImageView.hidden = NO;
            break;
        case PlayerPositionLeft:
            self.playerActiveLeftImageView.hidden = NO;
            break;
        case PlayerPositionTop:
            self.playerActiveTopImageView.hidden = NO;
            break;
        case PlayerPositionRight:
            self.playerActiveRightImageView.hidden = NO;
            break;
        default:
            break;
    }
    
    if (position == PlayerPositionBottom) {
        self.centerLabel.text = NSLocalizedString(@"Your turn. Tap the stack.", @"Status text: your turn");
    } else {
        self.centerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@'s turn", @"Status text: other players turn"), [self.game activePlayer].name];
    }
    
}

#pragma mark - Sound methods

- (void)loadSounds{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    audioSession.delegate = nil;
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    [audioSession setActive:YES error:nil];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Dealing" withExtension:@"caf"];
    _dealingCardsSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _dealingCardsSound.numberOfLoops = -1;
    [_dealingCardsSound prepareToPlay];
}

@end
