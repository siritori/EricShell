//
//  Shell.m
//  FlashCard
//
//  Created by 川上 大樹 on 12/03/25.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import "Shell.h"
#import "ShellModule.h"
#import "ShellStandard.h"
#import "ShellFlashDeck.h"

enum {
   STATE_NO_INPUT,
   STATE_ANY_INPUT
};

@implementation Shell {
   __weak UITextView *console;
   NSArray *modules;
   NSConditionLock *stdin_lock;
   NSString  *stdin_buf;
   NSString *stdout_buf;
}

#pragma mark Utilities

// 一行の入力をトークン列に分解してNSArrayで返す。
static NSArray* split2token(NSString *input)
{
   NSMutableArray *arg = [NSMutableArray new];
   // 空白文字でトークン分割する
   NSArray *tokens = [input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   NSEnumerator *enumerator = [tokens objectEnumerator];
   NSString *element;
   while (element = [enumerator nextObject]) {
      // ゴミが入っていたらskipする
      if (element.length == 0) continue;
      [arg addObject:element];
   }
   return (NSArray *)arg;
}

// 入力をUITextFieldから受け付ける。入力されるまでブロッキングするため、shellMainスレッドからのみ呼べる。
-(NSString *)getLine
{
   NSString *line;
   /* !!! CRITICAL SECTION BEGIN !!!*/
   [stdin_lock lockWhenCondition:STATE_ANY_INPUT];
   line = stdin_buf; // copy to escape
   stdin_buf = @"";  // clear buffer
   [stdin_lock unlockWithCondition:STATE_NO_INPUT];
   /* !!! CRITICAL SECTION END !!!*/
   [self print:@"%@\n", line];
   return line;
}

#pragma mark I/O buffer management

// 指定された文字列を標準入力バッファに追加する。
-(void)addInputBuffer:(NSString *)text
{
   if(text.length == 0) return;
   /* !!! CRITICAL SECTION BEGIN !!!*/
   [stdin_lock lockWhenCondition:STATE_NO_INPUT];
   stdin_buf = [stdin_buf stringByAppendingString:text];
   [stdin_lock unlockWithCondition:STATE_ANY_INPUT];
   /* !!! CRITICAL SECTION END !!!*/
}

// 指定された文字列を標準出力バッファに追加する。
-(void)addOutputBuffer:(NSString *)text
{
   @synchronized(stdout_buf) {
      stdout_buf = [stdout_buf stringByAppendingString:text];
   }
}

-(void)flushConsole_ // called from flushConsole
{
   @synchronized(stdout_buf) {
      @synchronized(console) {
         console.text = [console.text stringByAppendingString:stdout_buf];
         NSRange bottom = NSMakeRange(console.text.length-1, 1);
         [console scrollRangeToVisible:bottom];
         stdout_buf = @"";
      }
   }
}
-(void)clearConsole_ // called from clearConsole
{
   @synchronized(stdout_buf) {
      stdout_buf = @"";
   }
   @synchronized(console) {
      console.text = @"";
   }
}

#pragma mark Interface

// 指定された文字列を入力として実行する。
-(NSInteger)execText:(NSString *)input
{
   NSArray *args = split2token(input);
   // 入力がなかった場合そのまま帰る
   if (args.count == 0) return 0;
   // args[0]はコマンド名
   NSString *command = [args objectAtIndex:0];
   // commandを解釈できるモジュールを探す
   for (ShellModule *mod in modules) {
      if([mod hasCommand:command]) {
         return [mod trapCommand:command arguments:args];
      }
   }
   [ShellModule cmdNotFoundWithShell:self command:command];
   return 0;
}

// 指定されたフォーマットに従って文字列を整形し、stdout_bufに溜める。画面表示はflushするまでされない。
-(void)printWithBuffering:(NSString *)fmt, ...
{
   va_list list;
   va_start(list, fmt);
   NSString *str = [[NSString alloc] initWithFormat:fmt arguments:list];
   va_end(list);
   [self addOutputBuffer:str];   
}

// 指定されたフォーマットに従って文字列を整形して画面表示する。バッファリングしない。
-(void)print:(NSString *)fmt, ...
{
   va_list list;
   va_start(list, fmt);
   NSString *str = [[NSString alloc] initWithFormat:fmt arguments:list];
   va_end(list);
   [self addOutputBuffer:str];
   [self flushConsole];
}

// stdout_bufに溜まった文字列を実際にUITextViewに反映してスクロールする。
-(void)flushConsole
{
   @synchronized(stdout_buf) {
      if(stdout_buf.length == 0) return;
      [self performSelectorOnMainThread:@selector(flushConsole_) withObject:nil waitUntilDone:NO];
   }
}

// 画面表示をクリアする
-(void)clearConsole
{
   [self performSelectorOnMainThread:@selector(clearConsole_) withObject:nil waitUntilDone:YES];
}

#pragma mark Lifecycle

// UITextViewをコンソールの出力として用いる。
-(id)initWithConsole:(UITextView *)console_
{
   if(!(self = [super init])) return nil;
   console = console_;
   stdin_buf   = @"";
   stdout_buf  = @"";
   // UITextFieldに入力が入ったときにlockできる
   stdin_lock = [[NSConditionLock alloc] initWithCondition:STATE_NO_INPUT];
   // ShellModuleをロードする
   modules = [NSArray arrayWithObjects:
              [[ShellStandard alloc] initWithShell:self],
              [[ShellFlashDeck alloc] initWithShell:self],
              nil];
   return self;
}

// シェルのメインループ
-(void)shellMain:(NSObject *)arg
{
   NSLog(@"ShellMain Thread Started");
   [self print:PROMPT];
   [self flushConsole];
   while (1) {
      NSString *line = [self getLine];
      // 文字列を実行
      NSInteger result = [self execText:line];
      NSLog(@"result:%d", result);
      // 次のプロンプトを表示する
      [self print:PROMPT];
      [self flushConsole];
   }
}



@end
