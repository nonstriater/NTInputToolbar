//
//  ViewControllerB.h
//  NTFacialInputDemo
//
//  Created by nonstriater on 14-4-21.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerB : UIViewController{


    IBOutlet UIButton *showKeyboard;
    
    IBOutlet UIView *contentView;
    IBOutlet UIView *inputBar;
    
}

- (IBAction)showKeyboard:(id)sender;

@end
