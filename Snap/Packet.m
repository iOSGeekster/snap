//
//  Packet.m
//  Snap
//
//  Created by Jesper Nielsen on 17/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Packet.h"
#import "NSData+SnapAdditions.h"
const size_t PACKET_HEADER_SIZE = 10;
@implementation Packet

@synthesize packetType = _packetType;

+ (id)packetWithType:(PacketType)packetType{
    return [[[self class] alloc] initWithType:packetType];
}

+ (id)packetWithData:(NSData *)data{
    if ([data length] < PACKET_HEADER_SIZE) {
        NSLog(@"Error: Packet too small");
        return nil;
    }
    
    if ([data jn_int32AtOffset:0] != 'SNAP') {
        NSLog(@"Error. Packet has invalid header");
        return nil;
    }
    
// Not used yet?   int packetNumber = [data jn_int32AtOffset:4];
    PacketType packetType = [data jn_int16AtOffset:8];
    return [Packet packetWithType:packetType];
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

@end
