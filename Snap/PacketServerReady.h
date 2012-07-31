//
//  PacketServerReady.h
//  Snap
//
//  Created by Jesper Nielsen on 31/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Packet.h"

@interface PacketServerReady : Packet
@property (nonatomic, strong) NSMutableDictionary *players;

+ (id)packetWithPlayers:(NSMutableDictionary *)players;

@end
