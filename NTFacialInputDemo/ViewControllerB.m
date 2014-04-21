//
//  ViewControllerB.m
//  NTFacialInputDemo
//
//  Created by nonstriater on 14-4-21.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "NTInputToolBar.h"
#import "ViewControllerB.h"

@interface ViewControllerB ()<NTInputControllerDelegate>{

    NTInputToolBar *input;
}

@end

@implementation ViewControllerB

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    input = [[NTInputToolBar alloc] initWithViewController:self];
    input.hiddenAfterUserd = YES;
}


- (IBAction)showKeyboard:(id)sender{

    [input becomeFirstResponder];

}

- (UIView *)contentView{
    return contentView;
}
- (UIView *)inputBarView{
    return inputBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
