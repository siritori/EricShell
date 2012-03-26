//
//  Shell.h
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/25.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Foundation/NSThread.h"
#define PROMPT @"[eric@iPad] "

enum {
   STATE_NO_INPUT,
   STATE_ANY_INPUT
};

@interface Shell : NSObject

// I/O buffer management
-(void)addInputBuffer:(NSString *)text;

// Interface
-(NSString *)getLine;
-(NSInteger)execText:(NSString *)input;
-(void)print:(NSString *)fmt, ...;
-(void)flushConsole;
-(void)clearConsole;

// Lifecycle
-(id)initWithConsole:(UITextView *)console;
-(void)shellMain:(NSObject *)arg;

@end
