//
//  ShellFlashDeck.m
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/26.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import "ShellFlashDeck.h"
#import "FlashCard.h"

@implementation ShellFlashDeck {
   FlashCard *card;
}
static const uint NUM_COMMANDS = 2;

-(id)initWithShell:(Shell *)shell_
{
   if(!(self = [super initWithShell:shell_])) return nil;
   NSString *commandNames[NUM_COMMANDS] = {
      @"create_card",
      @"print_card",
   };
   NSString *methodNames[NUM_COMMANDS] = {
      @"cmdCreateCard:",
      @"cmdPrintCard:",
   };
   card = nil;
   vtable = [NSDictionary dictionaryWithObjects:(id *)methodNames
                                        forKeys:(id *)commandNames count:NUM_COMMANDS];
   return self;
}

-(NSInteger)cmdCreateCard:(NSArray *)args
{
   [shell print:@"question:"];
   [shell flushConsole];
   NSString *question = [shell getLine];
   [shell print:@"%@\nanswer:", question];
   [shell flushConsole];
   NSString *answer = [shell getLine];
   [shell print:@"%@\n", answer];   
   card = [[FlashCard alloc]initWithQuestion:question answer:answer];
   NSLog(@"%@", card);
   return 1;
}

-(NSInteger)cmdPrintCard:(NSArray *)args
{
   if(!card) return 0;
   [shell print:@"question:%@\n", card.question];
   for (NSString *ans in card.answers) {
      [shell print:@"answer:%@\n", ans];
   }
   return 1;
}

@end
