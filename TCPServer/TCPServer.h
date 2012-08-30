//
//  TCPServer.h
//  TCPServer
//
//  Created by Lin Chuankai on 8/30/12.
//  Copyright (c) 2012 KILAB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCPServer : NSObject <NSStreamDelegate>

- (void)startWithPort:(NSUInteger) port UsingBlock:(void (^)(NSInputStream *stream))block;
- (void)stop;

@end
