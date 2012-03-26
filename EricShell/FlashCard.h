//
//  FlashCard.h
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/24.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlashCard : NSObject<NSCoding> {
@private
   NSUInteger num_wrong;
   NSString *question;
   NSMutableArray *answers;
}
@property (readonly) NSUInteger num_wrong;
@property (readonly) NSString *question;
@property (readonly) NSArray *answers;

// Lifecycle
-(id)initWithQuestion:(NSString *)question_
               answer:(NSString *)answer_;
-(id)initWithQuestion:(NSString *)question_
              answers:(NSArray *)answers_;

// NSCoding
-(id)initWithCoder:(NSCoder *)decoder_;
-(void)encodeWithCoder:(NSCoder *)coder_;

// Interface
-(NSString *)description;
-(BOOL)check:(NSString *)user_answer;

@end
