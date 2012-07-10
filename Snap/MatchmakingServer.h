//
//  MatchmakingServer.h
//  Snap
//
//  Created by Jesper Nielsen on 01/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MatchmakingServer;
@protocol MatchmakingServerDelegate <NSObject>
- (void)matchmakingServer:(MatchmakingServer *)delegate clientDidConnect:(NSString *)peerID;
- (void)matchmakingServer:(MatchmakingServer *)delegate clientDidDisconnect:(NSString *)peerID;
@end
@interface MatchmakingServer : NSObject <GKSessionDelegate>
@property (nonatomic, assign) int maxClients;
@property (nonatomic, strong, readonly) NSArray *connectedClients;
@property (nonatomic, strong, readonly) GKSession *session;
@property (nonatomic, weak) id <MatchmakingServerDelegate> delegate;

- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID;
- (NSUInteger)connectedClientCount;
- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index;
- (NSString *)displayNameForPeerID:(NSString *)peerID;

@end
