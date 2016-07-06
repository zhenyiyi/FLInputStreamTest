//
//  Reader.m
//  FLInputStreamTest
//
//  Created by fenglin on 7/6/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "Reader.h"
#import "NSData+EnumerateCompents.h"


static const NSInteger maxReadLength = 1024 * 4;

@interface Reader() <NSStreamDelegate>
{
   
}

@property (nonatomic, assign) NSInteger lineNumber;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) dispatch_queue_t ioQueue;

@property (nonatomic, strong) NSData *delimiter;

@property (nonatomic, strong) NSMutableData *remainder;

@property (nonatomic, copy) CallbackBlock callBackBlock;
@property (nonatomic, copy) CompeletionBlock compeletionBlock;
@end

@implementation Reader

- (id)initWithFileURL:(NSURL *)fileURL{
    self = [super init];
    if (self) {
        _fileURL = fileURL;
        self.delimiter = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
        self.lineNumber = 0;
    }
    return self;
}
- (void)enumerateLinesWithBlock:(CallbackBlock)block
                     completion:(CompeletionBlock)completion{
    
    self.callBackBlock = block;
    self.compeletionBlock = completion;
    
    if (!_ioQueue) {
        _ioQueue = dispatch_queue_create("com.fenglin.Reader.ioQueue", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(_ioQueue, ^{
        
        NSLog(@"currentThread : %@",[NSThread currentThread]);
        _inputStream = [NSInputStream inputStreamWithURL:self.fileURL];
        _inputStream.delegate = self;
        [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_inputStream open];
        
        [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        
    });
    
    
}


#pragma mark -- NSStreamDelegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    
    switch (eventCode) {
        case NSStreamEventNone:
            
            break;
        case NSStreamEventOpenCompleted:
            
            break;
        case NSStreamEventHasBytesAvailable:{
            
            NSMutableData * mData = [[NSMutableData alloc] initWithCapacity:maxReadLength];
            uint8_t buf[maxReadLength] ;
            NSInteger len = [(NSInputStream *)aStream read:buf maxLength:maxReadLength];
            /**
             *  A positive number indicates the number of bytes read;
                0 indicates that the end of the buffer was reached;
                A negative number means that the operation failed.
             */
            if (len > 0) {
                
                [mData appendBytes:buf length:len];
                [mData setLength:len];
                [self processDataChunk:mData];
            }
        }
            
            break;
        case NSStreamEventHasSpaceAvailable:
            
            break;
        case NSStreamEventErrorOccurred:
            
            break;
        case NSStreamEventEndEncountered:
            
            break;
        default:
            break;
    }
}

- (void)processDataChunk:(NSMutableData *)buffer{
    if (self.remainder) {
        [self.remainder appendData:buffer];
    }else{
        self.remainder = [NSMutableData dataWithData:buffer];
    }
    __weak typeof(self) _self = self;
    [self.remainder fl_enumerateCompomentsSepratedBy:self.delimiter block:^(NSData *data, BOOL isLast) {
        __strong typeof(_self) sself = _self;
        if (!isLast) {
            [sself transferData:data];
        } else if (data.length > 0){
            self.remainder = [data mutableCopy];
        }else{
            self.remainder = nil;
        }
    }];
}

- (void)transferData:(NSData *)data{
    self.lineNumber ++;
    if (data.length > 0) {
        NSString *line = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (self.callBackBlock) self.callBackBlock(self.lineNumber, line);
    }
}
@end
