//
//  FlashDeck.m
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/25.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import "FlashDeck.h"

@implementation FlashDeck

#pragma mark Propaties

-(NSUInteger)count {
   return [cards count];
}

-(NSUInteger)num_wrong {
   NSUInteger sum = 0;
   for (FlashCard *card in cards) {
      sum += card.num_wrong;
   }
   return sum;
}

#pragma mark Lifecycle

-(id)initWithName:(NSString *)name_ {
   if(!(self = [super init])) return nil;
   name = name_;
   cards = [NSMutableArray new];
   return self;
}

#pragma mark Interface
// Cardを末尾に追加する
-(void)addCard:(FlashCard *)card
{
   [cards addObject:card];
}

// index番目のカードを取得する
-(FlashCard *)cardAt:(NSUInteger)index {
   return [cards objectAtIndex:index];
}

#pragma mark Enumeration

// cardsを数え上げるenumeratorを返す(for FlashDeckEnumerator only)
-(NSEnumerator*)cardEnumerator {
   return [cards objectEnumerator];
}

// foreach(NSFastEnumeration)用
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                 objects:(__unsafe_unretained id [])buffer
                                   count:(NSUInteger)len
{
   return [cards countByEnumeratingWithState:state
                                     objects:buffer
                                       count:len];
}
@end

// FlashDeckのEnumerator
@implementation FlashDeckEnumerator
-(id)initWithFlashDeck:(FlashDeck *)deck_ {
   if(!(self = [super init])) return nil;
   deck = deck_;
   enumerator = [deck cardEnumerator];
   return self;
}
-(id)nextObject {
   return [enumerator nextObject];
}
@end

