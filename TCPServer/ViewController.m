//
//  ViewController.m
//  TCPServer
//
//  Created by Lin Chuankai on 8/30/12.
//  Copyright (c) 2012 KILAB. All rights reserved.
//

#import "ViewController.h"
#import "TCPServer.h"

@interface ViewController ()

@end

@implementation ViewController
{
    TCPServer *server;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    server = [[TCPServer alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)start
{
    [server startWithPort:33352 UsingBlock:^(NSInputStream *stream){
        uint8_t buf[1];
        NSInteger len;
        len = [(NSInputStream *)stream read:buf maxLength:1];
        if (len) {
            NSLog(@"Input: %c", buf[0]);
        }
    }];
}

- (void)stop
{
    [server stop];
}

@end
