//
//  TCPServer.m
//  TCPServer
//
//  Created by Lin Chuankai on 8/30/12.
//  Copyright (c) 2012 KILAB. All rights reserved.
//

#import "TCPServer.h"
#import <CoreFoundation/CoreFoundation.h>
#import <sys/socket.h>
#import <netinet/in.h>

@implementation TCPServer
{
    CFSocketRef sock;
    NSInputStream *inputStream;
    void (^eventBlock)(NSInputStream *);
}

- (void)startWithPort:(NSUInteger)port UsingBlock:(void (^)(NSInputStream *))block
{
    NSLog(@"startWithPort:%u", port);
    CFSocketContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    sock = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, onConnect, &context);
    if (!sock) {
        NSLog(@"Socket creating failed");
        return;
    }
    
    struct sockaddr_in sin = {0};
    sin.sin_len = sizeof(sin);
    sin.sin_family = AF_INET; /* Address family */
    sin.sin_port = htons(port); /* Or a specific port */
    sin.sin_addr.s_addr= INADDR_ANY;
    
    CFDataRef sinData = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&sin, sizeof(sin));
    if (CFSocketSetAddress(sock, sinData)) {
        NSLog(@"CFSocketSetAddress failed");
        return;
    }
    CFRunLoopSourceRef socketsource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, sock, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), socketsource, kCFRunLoopDefaultMode);
    eventBlock = block;
}
- (void)stop
{
    CFSocketInvalidate(sock);
    NSLog(@"socket invalidated");
}

void onConnect(CFSocketRef s, CFSocketCallBackType callbackType, CFDataRef address, const void *data, void *info)
{
    if (callbackType == kCFSocketAcceptCallBack) {
        NSLog(@"Server socket connected");
        
        CFReadStreamRef readStreamRef;
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, *(CFSocketNativeHandle *)data, &readStreamRef, NULL);
        TCPServer *server = (__bridge TCPServer *)(info);
        server->inputStream = (__bridge NSInputStream *)readStreamRef;
        server->inputStream.delegate = server;
        [server->inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [server->inputStream open];
    } else {
        NSLog(@"Unknown callback type");
    }
}
    
#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    NSLog(@"Stream event");
    switch (streamEvent) {
        case NSStreamEventHasBytesAvailable:
        {
            self->eventBlock((NSInputStream *)theStream);
            break;
        }
            
        default:
            break;
    }
}

@end
