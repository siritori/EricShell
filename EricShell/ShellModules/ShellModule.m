//
//  ShellModule.m
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/26.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import "ShellModule.h"
#import "objc/message.h"

@implementation ShellModule

+(void)cmdNotFoundWithShell:(Shell *)shell_ command:(NSString *)command
{
   [shell_ print:@"ERROR: command '%@' not found\n", command];
}

-(id)initWithShell:(Shell *)shell_
{
   if(!(self = [super init])) return nil;
   shell = shell_;
   return self;
}

-(BOOL)hasCommand:(NSString *)command
{
   return [vtable objectForKey:command]? TRUE : FALSE;
}

-(NSInteger)trapCommand:(NSString *)command arguments:(NSArray *)args
{
   NSString *methodName = [vtable objectForKey:command];
   SEL selector = NSSelectorFromString(methodName);
   return (NSInteger)objc_msgSend(self, selector, args);
}

@end
