//
//  Reader.h
//  FLInputStreamTest
//
//  Created by fenglin on 7/6/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CallbackBlock)(NSInteger lineNumber, NSString *line);
typedef void (^CompeletionBlock)(NSInteger numbersOfLines);


@interface Reader : NSObject

- (id)initWithFileURL:(NSURL *)fileURL;
- (void)enumerateLinesWithBlock:(CallbackBlock)block
                     completion:(CompeletionBlock)completion;
@end
