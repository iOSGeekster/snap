//
//  Packet.m
//  Snap
//
//  Created by Jesper Nielsen on 17/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Packet.h"
#import "NSData+SnapAdditions.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"
#import "PacketOtherClientQuit.h"
#import "Card.h"
#import "PacketDealCards.h"
@implementation Packet

@synthesize packetType = _packetType;

+ (id)packetWithType:(PacketType)packetType{
    return [[[self class] alloc] initWithType:packetType];
}

+ (id)packetWithData:(NSData *)data{
    if ([data length] < /*PACKET_HEADER_SIZE*/10) {
        NSLog(@"Error: Packet too small");
        return nil;
    }
    
    if ([data jn_int32AtOffset:0] != 'SNAP') {
        NSLog(@"Error. Packet has invalid header");
        return nil;
    }
    
// Not used yet?   int packetNumber = [data jn_int32AtOffset:4];
    PacketType packetType = [data jn_int16AtOffset:8];
    
    Packet *packet;
    switch (packetType) {
        case PacketTypeSignInRequest:
        case PacketTypeClientReady:
        case PacketTypeClientDealtCards:
        case PacketTypeServerQuit:
        case PacketTypeClientQuit:
            packet = [Packet packetWithType:packetType];
            break;
        case PacketTypeSignInResponse:
            packet = [PacketSignInResponse packetWithData:data];
            break;
        case PacketTypeServerReady:
            packet = [PacketServerReady packetWithData:data];
            break;
        case PacketTypeOtherClientQuit:
            packet = [PacketOtherClientQuit packetWithData:data];
            break;
        case PacketTypeDealCards:
            packet = [PacketDealCards packetWithData:data];
            break;
        default:
            NSLog(@"Error: packet has invalid packetType");
            return nil;
    }
    
    return packet;
}

- (id)initWithType:(PacketType)packetType{
    if ((self = [super init])) {
        self.packetType = packetType;
    }
    return self;
}

- (NSData *)data{
    
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
    [data jn_appendInt32:'SNAP'];
    [data jn_appendInt32:0];
    [data jn_appendInt16:self.packetType];
    [self addPayloadToData:data];
    return data;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

- (void)addPayloadToData:(NSMutableData *)data{
    
}

+ (NSMutableDictionary *)cardsFromData:(NSData *)data atOffset:(size_t)offset{
    size_t count;
    
    NSMutableDictionary *cards = [NSMutableDictionary dictionaryWithCapacity:4];
    
    while (offset < [data length]) {
        NSString *peerID = [data jn_stringAtOffset:offset bytesRead:&count];
        offset += count;
        
        int numberOfCards = [data jn_int8AtOffset:offset];
        offset += 1;
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:numberOfCards];
        
        for (int t = 0; t < numberOfCards; ++t) {
            int suit = [data jn_int8AtOffset:offset];
            offset += 1;
            
            int value = [data jn_int8AtOffset:offset];
            offset += 1;
            
            Card *card = [[Card alloc] initWithSuit:suit value:value];
            [array addObject:card];
        }
        [cards setObject:array forKey:peerID];
    }
    return cards;
}

- (void)addCards:(NSDictionary *)cards toPayload:(NSMutableData *)data{
    [cards enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *array, BOOL *stop){
        [data jn_appendString:key];
        [data jn_appendInt8:[array count]];
        
        for (int t = 0; t < [array count]; ++t) {
            Card *card = [array objectAtIndex:t];
            [data jn_appendInt8:card.suit];
            [data jn_appendInt8:card.value];
        }
    }];
}

@end
