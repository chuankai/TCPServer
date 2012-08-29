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
{
    TCPServer *server;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    server = [[TCPServer alloc] init];
    [server startWithPort:33339 UsingBlock:nil];
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

@end
