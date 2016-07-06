//
//  NSData+EnumerateCompents.m
//  FLInputStreamTest
//
//  Created by fenglin on 7/6/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "NSData+EnumerateCompents.h"
#import <UIKit/UIKit.h>
/*
 
0123456789\n
9876543210\n
0123456789\n
9876543210

 data length  = 43;
 delimiter  = '\n';
 
 loc                : 0
 range              : (10, 1);
 rangeWithDelimiter : (0 , 10 - 0 + 1);
 delimitedData      : 0123456789\n
 loc                : 10+1 = 11

*/
@implementation NSData (EnumerateCompents)

- (void)fl_enumerateCompomentsSepratedBy:(NSData *)delimiter block:(void(^)(NSData *data , BOOL isLast))block{
    
    NSUInteger loc = 0;
    
    while (YES) {
        
        NSRange range = [self rangeOfData:delimiter options:0 range:NSMakeRange(loc, self.length - loc)];
        
        if (range.location == NSNotFound) {
            break;
        }
        NSRange rangeWithDelimiter = NSMakeRange(loc, range.location - loc + delimiter.length);
        
        NSData *delimitedData = [self subdataWithRange:rangeWithDelimiter];
        
        block(delimitedData, NO);
        
        loc = NSMaxRange(rangeWithDelimiter) ;
    }
    NSData *restOfData = [self subdataWithRange:NSMakeRange(loc, self.length - loc)];
    block(restOfData, YES);
}

@end
