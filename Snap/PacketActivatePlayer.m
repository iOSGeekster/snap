//
//  PacketActivatePlayer.m
//  Snap
//
//  Created by Jesper Nielsen on 04/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "PacketActivatePlayer.h"
#import "NSData+SnapAdditions.h"
@implementation PacketActivatePlayer

@synthesize peerID = _peerID;

+ (id)packetWithPeerID:(NSString *)peerID{
    return [[[self class] alloc] initWithPeerID:peerID];
}

- (id)initWithPeerID:(NSString *)peerID{
    if ((self = [super initWithType:PacketTypeActivatePlayer])) {
        self.peerID = peerID;
    }
    return self;
}

+ (id)packetWithData:(NSData *)data{
    size_t count;
    NSString *peerID = [data jn_stringAtOffset:10 /*PACKET_HEADER_SIZE*/ bytesRead:&count];
    return [[self class] packetWithPeerID:peerID];
}

- (void)addPayloadToData:(NSMutableData *)data{
    [data jn_appendString:self.peerID];
}

@end
