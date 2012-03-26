//
//  ShellFlashDeck.m
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/26.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import "ShellFlashDeck.h"
#import "FlashDeck.h"

@implementation ShellFlashDeck {
   FlashDeck *deck;
}
static const uint NUM_COMMANDS = 2;

-(id)initWithShell:(Shell *)shell_ console:(UITextView *)console_
{
   if(!(self = [super initWithShell:shell_ console:console_])) return nil;
   NSString *commandNames[NUM_COMMANDS] = {
      @"create_deck",
      @"print_deck",
   };
   NSString *methodNames[NUM_COMMANDS] = {
      @"cmdCreateDeck:",
      @"cmdPrintDeck:",
   };
   deck = nil;
   vtable = [NSDictionary dictionaryWithObjects:(id *)methodNames
                                        forKeys:(id *)commandNames count:NUM_COMMANDS];
   return self;
}

-(NSInteger)cmdCreateDeck:(NSArray *)args
{
   [shell print:@"name:"];
   deck = [[FlashDeck alloc]initWithName: [shell getLine]];
   while (1) {
      NSString *q, *a;
      [shell print:@"question:"];
      q = [shell getLine];
      [shell print:@"answer:", q];
      a = [shell getLine];
      FlashCard *card = [[FlashCard alloc]initWithQuestion:q answer:a];
      [deck addCard:card];
      [shell print:@"continue?(y/n):"];
      if([[shell getLine] compare:@"n"] == NSOrderedSame) break; 
   }
   return 1;
}

-(NSInteger)cmdPrintDeck:(NSArray *)args
{
   if(!deck) return 0;
   [shell print:@"%@\n", deck];
   return 1;
}

@end
