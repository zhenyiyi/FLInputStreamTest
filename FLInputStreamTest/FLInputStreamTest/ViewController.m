//
//  ViewController.m
//  FLInputStreamTest
//
//  Created by fenglin on 7/6/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "ViewController.h"
#import "Reader.h"


@interface ViewController ()
@property (nonatomic, strong)Reader * reader;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *test = [@"12345" dataUsingEncoding:NSUTF8StringEncoding];
    

    NSURL *url =[[NSBundle mainBundle] URLForResource:@"Clarissa Harlowe" withExtension:@"txt"];
    
    self.reader = [[Reader alloc] initWithFileURL:url];
    
    [self.reader enumerateLinesWithBlock:^(NSInteger lineNumber, NSString *line) {
        NSLog(@"%ld-- %@",(long)lineNumber, line);
    } completion:^(NSInteger numbersOfLines) {
        
    }];
}

@end
