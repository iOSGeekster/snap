//
//  PacketSignInResponse.h
//  Snap
//
//  Created by Jesper Nielsen on 17/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Packet.h"

@interface PacketSignInResponse : Packet

@property (nonatomic, copy) NSString *playerName;

+ (id)packetWithPlayerName:(NSString *)playerName;

@end
