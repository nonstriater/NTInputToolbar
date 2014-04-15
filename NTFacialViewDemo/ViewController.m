//
//  ViewController.m
//  NTFacialViewDemo
//
//  Created by nonstriater on 14-4-12.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "ViewController.h"
#import "NTFacialView.h"

@interface ViewController ()<NTFacialViewDelegate>{

    UILabel *textLabel;
    NSMutableString *strings;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NTFacialView *facialView = [[NTFacialView alloc] initWithFrame:CGRectMake(0, 468, 320, 260.f)];
    facialView.delegate = self;
    [self.view addSubview:facialView];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 320, 200)];
    textLabel.numberOfLines = 10;
    [self.view addSubview:textLabel];
    
    strings = [NSMutableString string];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y-300.f);

}

- (void)facialView:(NTFacialView *)facialView didSelectedWithText:(NSString *)text{
    
    [strings appendString:text];
    textLabel.text = strings;
    
    
}

- (void)didSelectDeleteFacialView:(NTFacialView *)facialView{
    
    if (![strings length]) {
        return;
    }
    
    [strings replaceCharactersInRange:NSMakeRange([strings length]-2, 2) withString:@""];
    textLabel.text = strings;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
