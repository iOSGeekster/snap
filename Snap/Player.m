//
//  Player.m
//  Snap
//
//  Created by Jesper Nielsen on 17/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Player.h"
#import "Card.h"
#import "Stack.h"
@implementation Player
@synthesize position = _position;
@synthesize name = _name;
@synthesize peerID = _peerID;
@synthesize receivedResponse = _receivedResponse;
@synthesize gamesWon = _gamesWon;
@synthesize closedCards = _closedCards;
@synthesize openCards = _openCards;
- (void)dealloc{
#ifdef DEBUG
    NSLog(@"deallog %@",self);
#endif
}

- (id)init{
    if ((self = [super init])) {
        _closedCards = [[Stack alloc] init];
        _openCards = [[Stack alloc] init];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ peerID = %@, name = %@, position = %d", [super description], self.peerID, self.name, self.position];
}

- (Card *)turnOverTopCard{
    NSAssert([self.closedCards cardCount] > 0, @"No more cards");
    
    Card *card = [self.closedCards topmostCard];
    card.isTurnedOver = YES;
    [self.openCards addCardToTop:card];
    [self.closedCards removeTopmostCard];
    
    return card;
}
@end
