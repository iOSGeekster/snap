//
//  NSData+SnapAdditions.m
//  Snap
//
//  Created by Jesper Nielsen on 17/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "NSData+SnapAdditions.h"

@implementation NSData (SnapAdditions)
- (int)jn_int32AtOffset:(size_t)offset{
    const int *intBytes = (const int *)[self bytes];
    return  ntohl(intBytes[offset / 4]);
}

- (short)jn_int16AtOffset:(size_t)offset{
    const short *shortBytes = (const short *)[self bytes];
    return ntohs(shortBytes[offset / 2]);
}

- (char)jn_int8AtOffset:(size_t)offset{
    const char *charBytes = (const char *)[self bytes];
    return charBytes[offset];
}

- (NSString *)jn_stringAtOffset:(size_t)offset bytesRead:(size_t *)amount{
    const char *charBytes = (const char *)[self bytes];
    NSString *string = [NSString stringWithUTF8String:charBytes + offset];
    *amount = strlen(charBytes + offset) + 1;
    return string;
}
@end

@implementation NSMutableData (SnapAdditions)

- (void)jn_appendInt32:(int)value{
    value = htonl(value);
    //& returns the memory address of the operand
    [self appendBytes:&value length:4];
}

- (void)jn_appendInt16:(short)value{
    value = htons(value);
    [self appendBytes:&value length:2];
}

- (void)jn_appendInt8:(char)value{
    [self appendBytes:&value length:1];
}

- (void)jn_appendString:(NSString *)string{
    const char *cString = [string UTF8String];
    [self appendBytes:cString length:strlen(cString) + 1];
}

@end
