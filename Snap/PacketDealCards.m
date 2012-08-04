//
//  PacketDealCards.m
//  Snap
//
//  Created by Jesper Nielsen on 04/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "PacketDealCards.h"
#import "NSData+SnapAdditions.h"
@implementation PacketDealCards
@synthesize cards = _cards;
@synthesize startingPeerID = _startingPeerID;

+ (id)packetWithCards:(NSDictionary *)cards startingWithPlayerPeerID:(NSString *)startingPeerID{
    return [[[self class] alloc] initWithCards:cards startingWithPlayerPeerID:startingPeerID];
}

- (id)initWithCards:(NSDictionary *)cards startingWithPlayerPeerID:(NSString *)startingPeerID{
    if ((self = [super initWithType:PacketTypeDealCards])) {
        self.cards = cards;
        self.startingPeerID = startingPeerID;
    }
    return self;
}

+ (id)packetWithData:(NSData *)data{
    size_t offset = 10; //PACKET_HEADER_SIZE;
    size_t count;
    
    NSString *startingPeerID = [data jn_stringAtOffset:offset bytesRead:&count];
    offset += count;
    
    NSDictionary *cards = [[self class] cardsFromData:data atOffset:offset];
    
    return [[self class] packetWithCards:cards startingWithPlayerPeerID:startingPeerID];
}

- (void)addPayloadToData:(NSMutableData *)data{
    [data jn_appendString:self.startingPeerID];
    [self addCards:self.cards toPayload:data];
}



@end
