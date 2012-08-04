//
//  PacketDealCards.h
//  Snap
//
//  Created by Jesper Nielsen on 04/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Packet.h"

@interface PacketDealCards : Packet
@property (nonatomic, strong) NSDictionary *cards;
@property (nonatomic, copy) NSString *startingPeerID;

+ (id)packetWithCards:(NSDictionary *)cards startingWithPlayerPeerID:(NSString *)startingPeerID;

@end
