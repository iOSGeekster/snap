//
//  Game.h
//  Snap
//
//  Created by Jesper Nielsen on 15/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Game;
@protocol GameDelegate <NSObject>

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason;
    
@end
@interface Game : NSObject <GKSessionDelegate>

@property (nonatomic, weak) id <GameDelegate> delegate;
@property (nonatomic, assign) BOOL isServer;

- (void)startGameClientWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;
- (void)quitGameWithReason:(QuitReason)reason;

@end
