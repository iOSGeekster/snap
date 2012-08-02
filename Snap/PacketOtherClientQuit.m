//
//  PacketOtherClientQuit.m
//  Snap
//
//  Created by Jesper Nielsen on 02/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "PacketOtherClientQuit.h"
#import "NSData+SnapAdditions.h"
@implementation PacketOtherClientQuit
@synthesize peerID = _peerID;

+ (id)packetWithPeerID:(NSString *)peerID{
    return [[[self class] alloc] initWithPeerID:peerID];
}

- (id)initWithPeerID:(NSString *)peerID{
    if ((self = [super initWithType:PacketTypeOtherClientQuit])) {
        self.peerID = peerID;
    }
    return self;
}

+ (id)packetWithData:(NSData *)data{
    size_t offset = PACKET_HEADER_SIZE;
    size_t count;
    
    NSString *peerID = [data jn_stringAtOffset:offset bytesRead:&count];
    
    return [[self class] packetWithPeerID:peerID];
}

- (void)addPayloadToData:(NSMutableData *)data{
    [data jn_appendString:self.peerID];
}

@end
