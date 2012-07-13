//
//  MatchMakingClient.h
//  Snap
//
//  Created by Jesper Nielsen on 01/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MatchMakingClient;

@protocol MatchmakingClientDelegate <NSObject>

- (void)matchmakingClient:(MatchMakingClient *)client serverBecameAvailable:(NSString *)peerID;
- (void)matchmakingClient:(MatchMakingClient *)client serverBecameUnavailable:(NSString *)peerID;
- (void)matchmakingClient:(MatchMakingClient *)client didDisconnectFromServer:(NSString *)peerID;

@end

@interface MatchMakingClient : NSObject <GKSessionDelegate>

@property (nonatomic, strong, readonly) NSArray *availableServers;
@property (nonatomic, strong, readonly) GKSession *session;
@property (nonatomic, weak) id <MatchmakingClientDelegate> delegate;

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID;
- (NSUInteger)availableServerCount;
- (NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index;
- (NSString *)displayNameForPeerID:(NSString *)peerID;
- (void)connectToServerWithPeerID:(NSString *)peerID;

@end
