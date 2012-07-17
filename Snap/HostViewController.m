//
//  HostViewController.m
//  Snap
//
//  Created by Jesper Nielsen on 01/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "HostViewController.h"
#import "UIFont+SnapAdditions.h"
#import "UIButton+SnapAdditions.h"
#import "PeerCell.h"

@interface HostViewController (){
    MatchmakingServer *_matchMakingServer;
    QuitReason _quitReason;
}
@property (nonatomic, weak) IBOutlet UILabel *headingLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;

@end

@implementation HostViewController
@synthesize headingLabel = _headingLabel;
@synthesize nameLabel = _nameLabel;
@synthesize nameTextField = _nameTextField;
@synthesize statusLabel = _statusLabel;
@synthesize tableView = _tableView;
@synthesize startButton = _startButton;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headingLabel.font = [UIFont jn_snapFontWithSize:24.0f];
    self.nameLabel.font = [UIFont jn_snapFontWithSize:16.0f];
    self.statusLabel.font = [UIFont jn_snapFontWithSize:16.0f];
    self.nameTextField.font = [UIFont jn_snapFontWithSize:20.0f];
    
    [self.startButton jn_applySnapStyle];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(_matchMakingServer == nil){
        _matchMakingServer = [[MatchmakingServer alloc] init];
        _matchMakingServer.delegate = self;
        _matchMakingServer.maxClients = 3;
        [_matchMakingServer startAcceptingConnectionsForSessionID:SESSION_ID];
        
        self.nameTextField.placeholder = _matchMakingServer.session.displayName;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)startAction:(id)sender{
    if (_matchMakingServer != nil && [_matchMakingServer connectedClientCount] > 0) {
        NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([name length] == 0) {
            name = _matchMakingServer.session.displayName;
        }
        [_matchMakingServer stopAcceptingConnections];
        [self.delegate hostViewController:self startGameWithSession:_matchMakingServer.session playerName:name clients:_matchMakingServer.connectedClients];
    }
    
}

- (IBAction)exitAction:(id)sender{
    _quitReason = QuitReasonUserQuit;
    [_matchMakingServer endSession];
    [self.delegate hostViewControllerDidCancel:self];
}

#pragma mark - MatchmakingServerDelegate

- (void)matchmakingServer:(MatchmakingServer *)delegate clientDidConnect:(NSString *)peerID{
    [self.tableView reloadData];
}

- (void)matchmakingServer:(MatchmakingServer *)delegate clientDidDisconnect:(NSString *)peerID{
    [self.tableView reloadData];
}

- (void)matchmakingServerNoNetwork:(MatchmakingServer *)server{
    _quitReason = QuitReasonNoNetwork;
}

- (void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server{
    _matchMakingServer.delegate = nil;
    _matchMakingServer = nil;
    [self.tableView reloadData];
    [self.delegate hostViewController:self didEndSessionWithReason:_quitReason];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_matchMakingServer != nil) {
        return [_matchMakingServer connectedClientCount];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PeerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *peerID = [_matchMakingServer peerIDForConnectedClientAtIndex:indexPath.row];
    cell.textLabel.text = [_matchMakingServer displayNameForPeerID:peerID];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
