//
//  ViewController.m
//  EricShell
//
//  Created by 川上 大樹 on 12/03/26.
//  Copyright (c) 2012 University of Tsukuba. All rights reserved.
//

#import "ViewController.h"
#import "Foundation/NSThread.h"
#import "Shell.h"

@implementation ViewController {
   IBOutlet UITextView *console;
   IBOutlet UITextField *input_textfield;
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
   [super viewDidLoad];
   console.text = @"";
   input_textfield.delegate = self;
   input_textfield.returnKeyType = UIReturnKeySend;
   shell = [[Shell alloc] initWithConsole:console];
   [NSThread detachNewThreadSelector:@selector(shellMain:) toTarget:shell withObject:nil];   
}

- (void)viewDidUnload
{
   [super viewDidUnload];
   // Release any retained subviews of the main view.
   // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
   [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [shell addInputBuffer:input_textfield.text];
   input_textfield.text = @"";
   return YES;   
}

@end
