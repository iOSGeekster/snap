//
//  PacketSignInResponse.m
//  Snap
//
//  Created by Jesper Nielsen on 17/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "PacketSignInResponse.h"
#import "NSData+SnapAdditions.h"

@implementation PacketSignInResponse
@synthesize playerName = _playerName;

+ (id)packetWithPlayerName:(NSString *)playerName{
    return [[[self class] alloc] initWithPlayerName:playerName];
}

- (id)initWithPlayerName:(NSString *)playerName{
    if ((self = [super initWithType:PacketTypeSignInResponse])) {
        self.playerName = playerName;
    }
    return self;
}

- (void)addPayloadToData:(NSMutableData *)data{
    [data jn_appendString:self.playerName];
}
@end
