//
//  NSData+EnumerateCompents.h
//  FLInputStreamTest
//
//  Created by fenglin on 7/6/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (EnumerateCompents)
/**
 *  enumerate Data with the given delimiter
 *
 *  @param delimter the delimiter data
 *  @param block    callback when self is Separated by delimiter
 *  @note  data     already being separated data
 *  @note  isLast   whether it is separeed finished
 */
- (void)fl_enumerateCompomentsSepratedBy:(NSData *)delimiter block:(void(^)(NSData *data , BOOL isLast))block;
@end
