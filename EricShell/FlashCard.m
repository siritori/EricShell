//
//  FlashCard.m
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/24.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import "FlashCard.h"

@implementation FlashCard
@synthesize num_wrong;
@synthesize question;
@synthesize answers;

#pragma mark Utilities

static NSString* trimSideWhitespace(NSString *str)
{
   return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark NSCoding

-(id)initWithCoder:(NSCoder *)decoder
{
   if(!(self = [super init])) return nil;
   num_wrong = [[decoder decodeObjectForKey:@"num_wrong"] unsignedIntValue];
   question  = [decoder decodeObjectForKey:@"question"];
   answers   = [decoder decodeObjectForKey:@"answers"];
   return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
   [coder encodeObject:[NSNumber numberWithUnsignedInt: num_wrong] forKey:@"num_wrong"];
   [coder encodeObject:question forKey:@"question"];
   [coder encodeObject:answers forKey:@"answers"];
}

#pragma mark Lifecycle
-(id)initWithQuestion:(NSString *)question_
               answer:(NSString *)answer_
{
   if(!(self = [super init])) return nil;
   // register after ignore side whitespaces
   num_wrong = 0;
   question = trimSideWhitespace(question_);
   answers = [NSMutableArray new];
   [answers addObject:trimSideWhitespace(answer_)];
   return self;
}

-(id)initWithQuestion:(NSString *)question_
              answers:(NSArray *)answers_
{
   if(!(self = [super init])) return nil;
   // 作成当時は一度も間違えていない
   num_wrong = 0;
   // 両端の空白を除去してから格納する
   question = [question_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   answers = [NSMutableArray new];
   for (NSString *s in answers_) {
      [answers addObject:trimSideWhitespace(s)];
   }
   return self;
}

#pragma mark Interface

-(NSString*)description
{
   NSString *desc = [[NSString alloc]initWithFormat:@"\nquestion:%@\nanswer:\n", question];
   for (NSString *s in answers) {
      desc = [desc stringByAppendingFormat:@"  %@\n", s];
   }
   return desc;
}

-(BOOL)check:(NSString *)user_answer
{
   NSString *trimmed = trimSideWhitespace(user_answer);
   // compare with all answers
   for (NSString *s in answers) {
      if([trimmed caseInsensitiveCompare:s] == NSOrderedSame) return TRUE;
   }
   return FALSE;
}

@end
