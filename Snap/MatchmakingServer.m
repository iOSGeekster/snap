//
//  MatchmakingServer.m
//  Snap
//
//  Created by Jesper Nielsen on 01/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "MatchmakingServer.h"
typedef enum{
    ServerStateIdle,
    ServerStateAcceptingConnections,
    ServerStateIgnoringNewConnections,
}
ServerState;
@implementation MatchmakingServer{
    NSMutableArray *_connectedClients;
    ServerState _serverState;
}

@synthesize maxClients = _maxClients;
@synthesize session = _session;
@synthesize delegate = _delegate;

- (id)init{
    if((self = [super init])){
        _serverState = ServerStateIdle;
    }
    return self;
}

- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID{
    if (_serverState == ServerStateIdle) {
        _serverState = ServerStateAcceptingConnections;
        _connectedClients = [NSMutableArray arrayWithCapacity:self.maxClients];
        
        _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeServer];
        _session.delegate = self;
        _session.available = YES;
    }
}

- (NSArray *)connectedClients{
   return _connectedClients;
}

- (NSUInteger)connectedClientCount{
    return [_connectedClients count];
}

- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index{
    return [_connectedClients objectAtIndex:index];
}

- (NSString *)displayNameForPeerID:(NSString *)peerID{
    return [_session displayNameForPeer:peerID];
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
#ifdef DEBUG
    NSLog(@"MatchmakingServer: peer %@ changed state %d", peerID, state);
#endif
    
    switch (state) {
        case GKPeerStateAvailable:
            break;
        case GKPeerStateUnavailable:
            break;
        case GKPeerStateConnected:
            if(_serverState == ServerStateAcceptingConnections){
                if (![_connectedClients containsObject:peerID]) {
                    [_connectedClients addObject:peerID];
                    [self.delegate matchmakingServer:self clientDidConnect:peerID];
                }
            }
            break;
        case GKPeerStateDisconnected:
            if(_serverState != ServerStateIdle){
                if([_connectedClients containsObject:peerID]){
                    [_connectedClients removeObject:peerID];
                    [self.delegate matchmakingServer:self clientDidDisconnect:peerID];
                }
            }
            break;
        default:
            break;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
#ifdef DEBUG
    NSLog(@"MatchmakingServer: connection request from peer %@",peerID);
#endif
    
    if (_serverState == ServerStateAcceptingConnections && [self connectedClientCount] < self.maxClients) {
        NSError *error;
        if ([session acceptConnectionFromPeer:peerID error:&error]) {
            NSLog(@"MatchmakingServer: Connection accepted from peer %@", peerID);
        } else {
            NSLog(@"MatchmakingServer: Error accepting connection from peer %@, %@", peerID, error);
        }
    }else{
        [session denyConnectionFromPeer:peerID];
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
#ifdef DEBUG
    NSLog(@"MatchmakingServer: connection with peer %@ failed %@",peerID, error);
#endif
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
#ifdef DEBUG
    NSLog(@"MatchmakingServer: session failed %@", error);
#endif
    
    if([[error domain] isEqualToString:GKSessionErrorDomain]){
        if([error code] == GKSessionCannotEnableError){
            [self.delegate matchmakingServerNoNetwork:self];
            [self endSession];
        }
    }
}

- (void)endSession{
    NSAssert(_serverState != ServerStateIdle, @"Wrong state");
    
    _serverState = ServerStateIdle;
    [_session disconnectFromAllPeers];
    _session.available = NO;
    _session.delegate = nil;
    _session = nil;
    _connectedClients = nil;
    [self.delegate matchmakingServerSessionDidEnd:self];
}

- (void)stopAcceptingConnections{
    NSAssert(_serverState == ServerStateAcceptingConnections, @"Wrong state");
    _serverState = ServerStateIgnoringNewConnections;
    _session.available = NO;
}

@end
