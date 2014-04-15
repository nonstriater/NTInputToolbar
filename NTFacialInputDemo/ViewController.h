//
//  ViewController.h
//  NTFacialInputDemo
//
//  Created by nonstriater on 14-4-12.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTInputControllerProtocol.h"

@interface ViewController : UIViewController<NTInputControllerDelegate>{

    IBOutlet UIView *contentView;
    IBOutlet UIView *inputBarView;
}

@end
