//
//  FlashDeck.h
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/25.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashCard.h"

// FlashCardを束ねてDeck(デッキ)とする
@interface FlashDeck : NSObject <NSFastEnumeration> {
@private
   NSString *name;
}
@property (readonly) NSString *name;
@property (readonly) NSUInteger count; // number of cards
@property (readonly) NSUInteger num_wrong; // sum num_wrong in cards

// Lifecycle
-(id)initWithName:(NSString *)name_;

// Interface
-(void)addCard:(FlashCard *)card;
-(FlashCard *)cardAt:(NSUInteger)index;

// Enumeration
-(NSEnumerator *)cardEnumerator;
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                 objects:(__unsafe_unretained id [])buffer
                                   count:(NSUInteger)len;
@end

// FlashDeckのEnumerator
@interface FlashDeckEnumerator : NSEnumerator {
@private
   FlashDeck *deck;
   NSEnumerator *enumerator;
}
-(id)initWithFlashDeck:(FlashDeck *)deck_;
-(id)nextObject;
@end
