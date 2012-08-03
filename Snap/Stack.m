//
//  Stack.m
//  Snap
//
//  Created by Jesper Nielsen on 02/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Stack.h"
#import "Card.h"
@implementation Stack{
    NSMutableArray *_cards;
}

- (id)init{
    if ((self = [super init])) {
        _cards = [NSMutableArray arrayWithCapacity:26];
    }
    return self;
}

- (void)addCardToTop:(Card *)card{
    NSAssert(card != nil, @"Card cannot be nil");
    NSAssert([_cards indexOfObject:card] == NSNotFound, @"Already have this card");
    [_cards addObject:card];
}

- (NSUInteger)cardCount{
    return [_cards count];
}

- (NSArray *)array{
    return [_cards copy];
}

- (Card *)cardAtIndex:(NSUInteger)index{
    return [_cards objectAtIndex:index];
}

@end
