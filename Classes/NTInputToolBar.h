//
//  NTInputToolBar.h
//  FuShuo  管理键盘
//
//  Created by nonstriater on 14-4-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTGrowingTextView.h"
#import "NTFacialView.h"
#import "NTInputControllerProtocol.h"

@protocol NTInputToolBarDelegate;
@interface NTInputToolBar : UIToolbar<NTGrowingTextViewDelegate,NTFacialViewDelegate>{

    UIViewController    *viewController;
    UIView              *contentView;
    UIView              *inputBarView;
    //BOOL                attachToScrollView;
    
    UIImageView         *toolbarBackground;
    NTFacialView        *facialView;
    UIView              *facialBackgroundView;//防止facialView和keyboard动画交替的黑色背景
    UITapGestureRecognizer *tapGesture;
    UIButton            *keyboardButton;
    UIButton            *facialButton;
    UIButton            *voiceButton;

    CGFloat keyboardHeight  ;
    BOOL keyboardHasShow;
 
    NSMutableString *text;
}

@property(nonatomic,weak) id<NTInputToolBarDelegate> inputDelegate;
@property(nonatomic,strong) UIImage *toolbarBackgroundImage;
@property(nonatomic,strong) NTGrowingTextView *textView;
@property(nonatomic,strong) UIImage *keyboardNormalImage;
@property(nonatomic,strong) UIImage *keyboardHightlightImage;
@property(nonatomic,strong) UIImage *facialNormalImage;
@property(nonatomic,strong) UIImage *facialHightlightImage;
@property(nonatomic,strong) UIImage *voiceImage;
@property(nonatomic,assign) BOOL voiceButtonHidden;// default is YES(Hidden)
@property(nonatomic,assign) BOOL facialButtonHidden;
@property(nonatomic,assign) BOOL hiddenAfterUserd; //defautl is NO 

- (id)initWithViewController:(id<NTInputControllerDelegate>)controller;
//- (id)initWithScrollViewController:(UIViewController *)controller;
- (void)hiddenKeyboard;
- (void)showKeyboard;
- (void)becomeFirstResponder;

@end


@protocol NTInputToolBarDelegate <NSObject>

- (void)inputToolBar:(NTInputToolBar *)inputBar sendMessageWithText:(NSString *)text;

@end
