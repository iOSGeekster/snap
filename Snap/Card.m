//
//  Card.m
//  Snap
//
//  Created by Jesper Nielsen on 02/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Card.h"

@implementation Card
@synthesize suit = _suit;
@synthesize value = _value;
@synthesize isTurnedOver = _isTurnedOver;

- (id)initWithSuit:(Suit)suit value:(int)value{
    NSAssert(value >= CardAce && value <= CardKing, @"Invalid card value");
    
    if ((self = [super init])) {
        _suit = suit;
        _value = value;
    }
    
    return self;
}

@end
