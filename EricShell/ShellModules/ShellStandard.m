//
//  ShellStandard.m
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/26.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import "ShellStandard.h"

@implementation ShellStandard {
   NSMutableDictionary *env;
}
static const uint NUM_COMMANDS = 6;

-(id)initWithShell:(Shell *)shell_ console:(UITextView *)console_
{
   if(!(self = [super initWithShell:shell_ console:console_])) return nil;
   NSString *commandNames[NUM_COMMANDS] = {
      @"hello",
      @"print_args",
      @"date",
      @"clear",
      @"set",
      @"get",
   };
   NSString *methodNames[NUM_COMMANDS] = {
      @"cmdHello:",
      @"cmdPrintArgs:",
      @"cmdDate:",
      @"cmdClear:",
      @"cmdEnvSet:",
      @"cmdEnvGet:",
   };
   vtable = [NSDictionary dictionaryWithObjects:(id *)methodNames
                                        forKeys:(id *)commandNames count:NUM_COMMANDS];
   env = [NSMutableDictionary new];
   return self;
}

// 渡された引数を表示する
-(NSInteger)cmdPrintArgs:(NSArray *)args
{
   for (NSString *s in args) {
      [shell print:@"arg:%@\n", s];
   }
   return 1;
}

// あいさつする
-(NSInteger)cmdHello:(NSArray *)args
{
   NSString *name;
   if([args count] < 2) {
      [shell print:@"Whats' your name?:"];
      name = [shell getLine];
   } else {
      name = [args objectAtIndex:1];
   }
   [shell print:@"Hello, %@\n", name];
   return 1;
}

// 日付を表示する
-(NSInteger)cmdDate:(NSArray *)args
{
   [shell print:@"today is %@\n", [NSDate date]];
   return 1;
}

// 画面クリア
-(NSInteger)cmdClear:(NSArray *)args
{
   [shell clearConsole];
   return 1;
}

// 環境変数としてセット
-(NSInteger)cmdEnvSet:(NSArray *)args
{
   if([args count] < 3) return 0;
   NSString *key = [args objectAtIndex:1];
   NSString *val = [args objectAtIndex:2];
   [env setObject:val forKey:key];
   return 1;
}

// 環境変数の取得
-(NSInteger)cmdEnvGet:(NSArray *)args
{
   if([args count] < 2) return 0;
   NSString *val = [env objectForKey:[args objectAtIndex:1]];
   [shell print:@"%@\n", val];
   return 1;
}

@end
