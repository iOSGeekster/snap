//
//  NSData+SnapAdditions.h
//  Snap
//
//  Created by Jesper Nielsen on 17/07/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SnapAdditions)
- (int)jn_int32AtOffset:(size_t)offset;
- (short)jn_int16AtOffset:(size_t)offset;
- (char)jn_int8AtOffset:(size_t)offset;
- (NSString *)jn_stringAtOffset:(size_t)offset bytesRead:(size_t *)amount;
@end

@interface NSMutableData (SnapAdditions)

- (void)jn_appendInt32:(int)value;
- (void)jn_appendInt16:(short)value;
- (void)jn_appendInt8:(char)value;
- (void)jn_appendString:(NSString *)string;

@end
