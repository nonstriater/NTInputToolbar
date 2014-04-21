//
//  ViewController.m
//  NTFacialInputDemo
//
//  Created by nonstriater on 14-4-12.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "ViewController.h"
#import "NTInputToolBar.h"

@interface ViewController (){

   // UIExpandingTextView *_textView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NTInputToolBar *input = [[NTInputToolBar alloc] initWithViewController:self];
    //input.textView.placeholder = @"输入文字";
    
    UIImageView *textViewBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_inputBack"]];
    textViewBackgroundImageView.frame          = CGRectMake(0, 100, 320, 100);
    [self.view addSubview:textViewBackgroundImageView];
    
    //_textView.backgroundColor
    //[contentView addSubview:_textView];
    
}



- (UIView *)contentView{

    return contentView;
}

- (UIView *)inputBarView{
    return inputBarView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
