//
//  MatchMakingClient.m
//  Snap
//
//  Created by Jesper Nielsen on 01/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "MatchMakingClient.h"
typedef enum{
    ClientStateIdle,
    ClientStateSearchingForServers,
    ClientStateConnecting,
    ClientStateConnected,
}
ClientState;
@implementation MatchMakingClient{
    NSMutableArray *_availableServers;
    ClientState _clientState;
    NSString *_serverPeerID;
}
@synthesize session = _session;
@synthesize delegate = _delegate;

- (id)init{
    if(self = [super init]){
        _clientState = ClientStateIdle;
    }
    return self;
}

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID{
    if(_clientState == ClientStateIdle){
        _clientState = ClientStateSearchingForServers;
        _availableServers = [[NSMutableArray alloc] initWithCapacity:10];
        
        _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
        _session.delegate = self;
        _session.available = YES;

    }
}

- (void)connectToServerWithPeerID:(NSString *)peerID{
    NSAssert(_clientState == ClientStateSearchingForServers, @"Wrong state");
    
    _clientState = ClientStateConnecting;
    _serverPeerID = peerID;
    [_session connectToPeer:peerID withTimeout:_session.disconnectTimeout];
}

- (NSArray *)availableServers{
    return _availableServers;
}

- (NSUInteger)availableServerCount{
    return [_availableServers count];
}

- (NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index{
    return [_availableServers objectAtIndex:index];
}

- (NSString *)displayNameForPeerID:(NSString *)peerID{
    return [_session displayNameForPeer:peerID];
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: peer %@ changed state %d", peerID, state);
#endif
    switch (state) {
        case GKPeerStateAvailable:
            if(_clientState == ClientStateSearchingForServers){
                if(![_availableServers containsObject:peerID]){
                    [_availableServers addObject:peerID];
                    [self.delegate matchmakingClient:self serverBecameAvailable:peerID];
                }
            }
            break;
        case GKPeerStateUnavailable:
            if(_clientState == ClientStateSearchingForServers){
                if([_availableServers containsObject:peerID]){
                    [_availableServers removeObject:peerID];
                    [self.delegate matchmakingClient:self serverBecameUnavailable:peerID];
                }
            }
            break;
            
        case GKPeerStateConnected:
            break;
        case GKPeerStateConnecting:
            break;
        case GKPeerStateDisconnected:
            break;
        default:
            break;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: connection request from peer %@", peerID);
#endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: connection with peer %@ failed %@", peerID, error);
#endif
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: session failed %@", error);
#endif
}
@end
