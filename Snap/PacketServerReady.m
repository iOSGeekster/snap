//
//  PacketServerReady.m
//  Snap
//
//  Created by Jesper Nielsen on 31/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "PacketServerReady.h"
#import "NSData+SnapAdditions.h"
#import "Player.h"

@implementation PacketServerReady
@synthesize players = _players;

+ (id)packetWithPlayers:(NSMutableDictionary *)players{
    return [[[self class] alloc] initWithPlayers:players];
}

+ (id)packetWithData:(NSData *)data{
    NSMutableDictionary *players = [NSMutableDictionary dictionaryWithCapacity:4];
    
    size_t offset = 10;//PACKET_HEADER_SIZE;
    size_t count;
    
    int numberOfPlayers = [data jn_int8AtOffset:offset];
    offset += 1;
    
    for (int t = 0; t < numberOfPlayers; t++) {
        NSString *peerID = [data jn_stringAtOffset:offset bytesRead:&count];
        offset += count;
        
        NSString *name = [data jn_stringAtOffset:offset bytesRead:&count];
        offset += count;
        
        PlayerPosition position = [data jn_int8AtOffset:offset];
        offset += 1;
        
        Player *player = [[Player alloc] init];
        player.peerID = peerID;
        player.name = name;
        player.position = position;
        [players setObject:player forKey:player.peerID];
    }
    return [[self class] packetWithPlayers:players];
}

- (id)initWithPlayers:(NSMutableDictionary *)players{
    if ((self = [super initWithType:PacketTypeServerReady])) {
        self.players = players;
    }
    return self;
}

- (void)addPayloadToData:(NSMutableData *)data{
    [data jn_appendInt8:[self.players count]];
    
    [self.players enumerateKeysAndObjectsUsingBlock:^(id key, Player *player, BOOL *stop){
        [data jn_appendString:player.peerID];
        [data jn_appendString:player.name];
        [data jn_appendInt8:player.position];
    }];
}

@end
