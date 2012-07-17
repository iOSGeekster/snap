//
//  Game.m
//  Snap
//
//  Created by Jesper Nielsen on 15/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Game.h"
#import "Packet.h"
#import "PacketSignInResponse.h"
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
    NSMutableDictionary *_players;
}

@synthesize delegate = _delegate;
@synthesize isServer = _isServer;

- (id)init{
    if ((self = [super init])) {
        _players = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    return self;
}

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc %@", self);
#endif
}

#pragma mark - Game logic

- (void)startGameClientWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID{
    self.isServer = NO;
    
    _session = session;
    _session.available = NO;
    _session.delegate = self;
    
    [_session setDataReceiveHandler:self withContext:nil];
    _serverPeerID = peerID;
    _localPlayerName = name;
    _state = GameStateWaitingForSignIn;
    
    [self.delegate gameWaitingForServerReady:self];
}

- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients{
    self.isServer = YES;
    _session = session;
    _session.available = NO;
    _session.delegate = self;
    [_session setDataReceiveHandler:self withContext:nil];
    _state = GameStateWaitingForSignIn;
    
    [self.delegate gameWaitingForClientsReady:self];
    
    Player *player = [[Player alloc] init];
    player.name = name;
    player.peerID = _session.peerID;
    player.position = PlayerPositionBottom;
    [_players setObject:player forKey:player.peerID];
    
    int index = 0;
    for (NSString *peerID in clients) {
        Player *player = [[Player alloc] init];
        player.peerID = peerID;
        [_players setObject:player forKey:player.peerID];
        
        if (index == 0) {
            player.position = ([clients count] == 1) ? PlayerPositionTop : PlayerPositionLeft;
        } else if (index == 1){
            player.position = PlayerPositionTop;
        } else {
            player.position = PlayerPositionRight;
        }
        index++;
    }
    
    Packet *packet = [Packet packetWithType:PacketTypeSignInRequest];
    [self sendPacketToAllClients:packet];
}

- (void)quitGameWithReason:(QuitReason)reason{
    _state = GameStateQuitting;
    [_session disconnectFromAllPeers];
    
    _session.delegate = nil;
    _session = nil;
    [self.delegate game:self didQuitWithReason:reason];
}

#pragma mark - Networking

- (void)sendPacketToAllClients:(Packet *)packet{
    GKSendDataMode dataMode = GKSendDataReliable;
    NSData *data = [packet data];
    
    NSError *error;
    if(![_session sendDataToAllPeers:data withDataMode:dataMode error:&error]){
        NSLog(@"Error sending data to clients: %@",error);
    }
}

- (void)sendPacketToServer:(Packet *)packet{
    GKSendDataMode dataMode = GKSendDataReliable;
    NSData *data = [packet data];
    NSError *error;
    if (![_session sendData:data toPeers:[NSArray arrayWithObject:_serverPeerID] withDataMode:dataMode error:&error]) {
        NSLog(@"Error sending data to server %@", error);
    }
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
    
    Packet *packet = [Packet packetWithData:data];
    if (packet == nil) {
        NSLog(@"Invalid packet: %@", data);
        return;
    }
    [self clientReceivedPacket:packet];
}

- (void)clientReceivedPacket:(Packet *)packet{
    switch (packet.packetType) {
        case PacketTypeSignInRequest:
            if (_state == GameStateWaitingForSignIn){
                _state = GameStateWaitingForReady;
                Packet *packet = [PacketSignInResponse packetWithPlayerName:_localPlayerName];
                [self sendPacketToServer:packet];
            }
            break;
            
        default:
            NSLog(@"Client received unexpected packet: %@", packet);
            break;
    }
}

@end
