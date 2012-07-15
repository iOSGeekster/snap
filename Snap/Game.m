//
//  Game.m
//  Snap
//
//  Created by Jesper Nielsen on 15/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Game.h"
typedef enum{
    GameStateWaitingForSignIn,
    GameStateWaitingForReady,
    GameStateDealing,
    GameStatePlaying,
    GameStateGameOver,
    GameStateQuitting
}
GameState;

@implementation Game
{
    GameState _state;
    
    GKSession *_session;
    NSString *_serverPeerID;
    NSString *_localPlayerName;
}

@synthesize delegate = _delegate;
@synthesize isServer = _isServer;

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc %@", self);
#endif
}

#pragma mark - Game logic

- (void)startGameClientWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID{
    
}

- (void)quitGameWithReason:(QuitReason)reason{
    
}

#pragma mark - GKSession delegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
#ifdef DEBUG
	NSLog(@"Game: peer %@ changed state %d", peerID, state);
#endif
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"Game: connection request from peer %@", peerID);
#endif
    
	[session denyConnectionFromPeer:peerID];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: connection with peer %@ failed %@", peerID, error);
#endif
    
	// Not used.
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: session failed %@", error);
#endif
}

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
#ifdef DEBUG
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
}

@end
