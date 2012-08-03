//
//  Packet.h
//  Snap
//
//  Created by Jesper Nielsen on 17/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

const size_t PACKET_HEADER_SIZE = 10;
typedef enum{
    PacketTypeSignInRequest = 0x64,
    PacketTypeSignInResponse,
    
    PacketTypeServerReady,
    PacketTypeClientReady,
    
    PacketTypeDealCards,
    PacketTypeClientDealtCards,
    
    PacketTypeActivatePlayer,
    PacketTypeClientTurnedCard,
    
    PacketTypePlayerShouldSnap,
    PacketTypePlayerCalledSnap,
    
    PacketTypeOtherClientQuit,
    PacketTypeServerQuit,
    PacketTypeClientQuit,
}
PacketType;
@interface Packet : NSObject
@property (nonatomic, assign) PacketType packetType;

+ (id)packetWithType:(PacketType)packetType;
+ (id)packetWithData:(NSData *)data;
- (id)initWithType:(PacketType)packetType;

- (NSData *)data;
@end
