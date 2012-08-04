//
//  Stack.h
//  Snap
//
//  Created by Jesper Nielsen on 02/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;
@interface Stack : NSObject
- (void)addCardToTop:(Card *)card;
- (NSUInteger)cardCount;
- (NSArray *)array;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)addCardsFromArray:(NSArray *)array;
@end
