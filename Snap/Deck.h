//
//  Deck.h
//  Snap
//
//  Created by Jesper Nielsen on 02/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;
@interface Deck : NSObject
- (void)shuffle;
- (Card *)draw;
- (int)cardsRemaining;
@end
