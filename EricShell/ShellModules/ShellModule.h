//
//  ShellModule.h
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/26.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shell.h"

@interface ShellModule : NSObject {
@protected
   __weak Shell *shell;
   NSDictionary *vtable;
}
+(void)cmdNotFoundWithShell:(Shell *)shell_ command:(NSString *)command;
-(id)initWithShell:(Shell *)shell_;
-(BOOL)hasCommand:(NSString *)command;
-(NSInteger)trapCommand:(NSString *)command arguments:(NSArray *)args;
@end
