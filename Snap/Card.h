//
//  Card.h
//  Snap
//
//  Created by Jesper Nielsen on 02/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    SuitClubs,
    SuitHearts,
    SuitDiamonds,
    SuitSpades
}
Suit;

#define CardAce 1
#define CardJack 11
#define CardQueen 12
#define CardKing 13

@interface Card : NSObject
@property (nonatomic, assign, readonly) Suit suit;
@property (nonatomic, assign, readonly) int value;

- (id)initWithSuit:(Suit)suit value:(int)value;

@end
