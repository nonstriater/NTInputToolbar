//
//  NTInputToolBar.m
//  FuShuo
//
//  Created by nonstriater on 14-4-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "NTInputToolBar.h"

const CGFloat inputToolBarHeight = 44.f;
const CGFloat animationDuration = 0.25f;
const NSInteger curveOption     = 7<<16;
const CGFloat defaultKeyboardHeight = 216.f;
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define KeyWindow [UIApplication sharedApplication].keyWindow

@implementation NTInputToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.facialNormalImage = [UIImage imageNamed:@"default_facial_n"];
        self.facialHightlightImage = [UIImage imageNamed:@"default_facial_h"];
        self.keyboardNormalImage = [UIImage imageNamed:@"default_keyboard_n"];
        self.keyboardHightlightImage = [UIImage imageNamed:@"default_keyboard_h"];
        //TODO:
        self.voiceImage = [UIImage imageNamed:@"default_delete_icon"];
        
        //self.toolbarBackgroundImage = [UIImage imageNamed:@"default_toobar_bkg"];
        self.backgroundColor = [UIColor colorWithRed:213/255.f green:213/255.f blue:213/255.f alpha:1.f];
        
        self.voiceButtonHidden = YES;
        self.facialButtonHidden = NO;
        
        keyboardHeight    = defaultKeyboardHeight;
        keyboardHasShow = NO;//代表整个键盘
        
        text = [NSMutableString string];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
        
    }
    return self;
}

- (id)initWithViewController:(id<NTInputControllerDelegate>)controller{

    if ([controller isKindOfClass:[UIViewController class]]) {
        viewController = (UIViewController *)controller;
    }
    contentView = [controller contentView];
    inputBarView = [controller inputBarView];
    
    self = [self initWithFrame:CGRectMake(0, inputBarView.frame.origin.y , inputBarView.frame.size.width, inputBarView.frame.size.height+defaultKeyboardHeight)];
    if (self) {
        
        [viewController.view addSubview:self];
        [self initializeView];
    }
    return self;
}

- (void)initializeView{

    // Drawing code
    CGFloat leftMargin= 4.f;
    CGFloat topMargin = 2.f;
    CGFloat screenWidth = viewController.view.frame.size.width;
    
    toolbarBackground = [[UIImageView alloc] initWithFrame:self.bounds];
    toolbarBackground.image = self.toolbarBackgroundImage;
    toolbarBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:toolbarBackground];
    
    //voice button
    if (!self.voiceButtonHidden) {
        voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceButton.backgroundColor = [UIColor clearColor];
        voiceButton.frame = CGRectMake(leftMargin, topMargin, 40.f, 40.f);
        leftMargin+=45.f;
        
        [voiceButton setImage:self.voiceImage forState:UIControlStateNormal];
        [voiceButton addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voiceButton];
    }
    
    
    CGFloat textViewWidth = (self.voiceButtonHidden)?screenWidth-50:screenWidth-2*50;
    textViewWidth = (self.facialButtonHidden)?textViewWidth+50.f:textViewWidth;
    _textView = [[NTGrowingTextView alloc] initWithFrame:CGRectMake(leftMargin, topMargin,textViewWidth,inputToolBarHeight-2*topMargin)];
    [_textView setReturnKeyType:UIReturnKeySend];
    _textView.maxNumberOfLines = 5;
    _textView.delegate = self;
    [self addSubview:_textView];
    
    //键盘/表情切换按钮
    if (!self.facialButtonHidden) {
        
        keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyboardButton.backgroundColor = [UIColor clearColor];
        keyboardButton.frame = CGRectMake(_textView.frame.origin.x+_textView.frame.size.width+5, topMargin, 40.f, 40.f);
        [keyboardButton setImage:self.keyboardNormalImage forState:UIControlStateNormal];
        [keyboardButton setImage:self.keyboardHightlightImage forState:UIControlStateHighlighted];
        [keyboardButton addTarget:self action:@selector(keyboardButtonClicked:)  forControlEvents:UIControlEventTouchUpInside];
        keyboardButton.hidden = YES;
        [self addSubview:keyboardButton];
        
        facialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        facialButton.backgroundColor = [UIColor clearColor];
        facialButton.frame = CGRectMake(_textView.frame.origin.x+_textView.frame.size.width+5, topMargin, 40.f, 40.f);
        [facialButton setImage:self.facialNormalImage forState:UIControlStateNormal];
        [facialButton setImage:self.facialHightlightImage forState:UIControlStateHighlighted];
        [facialButton addTarget:self action:@selector(facialButtonClicked:)  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:facialButton];
        
        facialView = [[NTFacialView alloc] initWithFrame:CGRectMake(0.f, inputBarView.frame.size.height, inputBarView.frame.size.width, defaultKeyboardHeight)];
        //facialView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        facialView.delegate = self;
        [self addSubview:facialView];
        
        facialBackgroundView = [[UIView alloc] initWithFrame:facialView.frame];
        facialBackgroundView.backgroundColor = [UIColor whiteColor];
        //facialView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self insertSubview:facialBackgroundView belowSubview:facialView];
    }


}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}

- (void)voiceButtonClicked:(UIButton *)button{

    
}

//出来文字键盘
- (void)keyboardButtonClicked:(UIButton *)button{
    
    facialButton.hidden = NO;
    keyboardButton.hidden = YES;
    
    [_textView becomeFirstResponder];//弹出键盘
    
    //等键盘弹出来以后
//    if (facialView) {
//        facialView.center = CGPointMake(facialView.center.x, facialView.center.y+keyboardHeight);
//    }
    
}

- (void)facialBoardHiddenWithAnimation:(BOOL)animated{

    
    
}

// 1）在底部点表情按钮； 2) 先输入框弹出文字键盘，在点表情按钮  3）文字键盘-->标签
- (void)facialButtonClicked:(UIButton *)button{

    facialButton.hidden = YES;
    keyboardButton.hidden = NO;
    
    if (keyboardHasShow) {// 3
            
        [_textView resignFirstResponder];
        
        CGFloat offset = defaultKeyboardHeight-keyboardHeight;
        [self showKeyboardWithDuration:animationDuration option:curveOption offset:offset];
        
        facialView.center = CGPointMake(facialView.center.x, facialView.center.y+defaultKeyboardHeight);
        [UIView animateWithDuration:animationDuration animations:^{
            
            facialView.center = CGPointMake(facialView.center.x,facialView.center.y-defaultKeyboardHeight);
                
                
        } completion:^(BOOL finish){
                keyboardHasShow = finish;
        }];
        
        keyboardHeight = defaultKeyboardHeight;
        
    }else{//1 or 2
        keyboardHeight = defaultKeyboardHeight;
        [self showKeyboard];
    }
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tapG{

    [self hiddenKeyboard];
    
}

- (void)hiddenKeyboard{
    
    if (tapGesture) {
        [contentView removeGestureRecognizer:tapGesture];
        tapGesture=nil;
    }
    
    facialButton.hidden = NO;
    keyboardButton.hidden = YES;
    [_textView resignFirstResponder];// 有willchangeframe完成后续工作
  
    [UIView animateWithDuration:animationDuration delay:0.f options:    curveOption animations:^{
            //viewController.view.center = CGPointMake(viewController.view.center.x, viewController.view.center.y+keyboardHeight);
        contentView.center = CGPointMake(contentView.center.x, contentView.center.y+keyboardHeight);
        self.center = CGPointMake(self.center.x, self.center.y+keyboardHeight);
        
        
    } completion:^(BOOL finish){
        keyboardHasShow = NO;
    }];
    

}

- (void)showKeyboard{

    if (!tapGesture) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [contentView addGestureRecognizer:tapGesture];
    }

    
    [UIView animateWithDuration:animationDuration delay:0.f options:curveOption animations:^{
        
//        viewController.view.center = CGPointMake(viewController.view.center.x, viewController.view.center.y-keyboardHeight);

        contentView.center = CGPointMake(contentView.center.x, contentView.center.y-keyboardHeight);
        self.center = CGPointMake(self.center.x, self.center.y-keyboardHeight);
        
    } completion:^(BOOL finish){
        keyboardHasShow = finish;
    }];
    
    
}


- (void)showKeyboardWithDuration:(float)animationDuration option:(UIViewAnimationOptions)option offset:(CGFloat)keyboardHeightOffset{

    if (!tapGesture) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [contentView addGestureRecognizer:tapGesture];
    }
    

    [UIView animateWithDuration:animationDuration delay:0.f options:option animations:^{
        //viewController.view.center = CGPointMake(viewController.view.center.x, viewController.view.center.y-keyboardHeightOffset);
        contentView.center = CGPointMake(contentView.center.x, contentView.center.y-keyboardHeightOffset);
        self.center = CGPointMake(self.center.x, self.center.y-keyboardHeightOffset);
        
    } completion:^(BOOL finish){
        keyboardHasShow = finish;
    }];
    
}

#pragma mark- keyboard notification

// keyboard 中文汉字选择界面，手写输入界面等（键盘高度会有变化） 也会触发 UIKeyboardWillShowNotification(不过先触发willchangeframe)
- (void)keyboardWillShow:(NSNotification *)notification{
    
    facialButton.hidden = NO;
    keyboardButton.hidden = YES;
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect startBound,endBound;
    [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&startBound];
    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endBound];
    float offset = startBound.origin.y - endBound.origin.y;
   
    /*
     *
     *  1 底部弹起
     *  2 表情--》文字键盘(键盘高度和表情键盘高度有差别，要调整输入框的高度) ,文字键盘从底部弹起
     *  3 文字键盘已经弹出，键盘高度调整（输入中文，切换手写键盘）
     */
    
    if (ScreenHeight == startBound.origin.y) {//1 or2
       
        keyboardHeight = offset;
        
        if (!keyboardHasShow) {//1. 底部弹起
            [self showKeyboardWithDuration:[duration floatValue] option:[curve intValue]<<16 offset:offset];
            
            
        }else{//2 . 表情--》文字键盘(键盘高度和表情键盘高度有差别，要调整输入框的高度)
            
            [self showKeyboardWithDuration:[duration floatValue] option:[curve intValue]<<16 offset:(offset-defaultKeyboardHeight)];
        }
        
    }else{// 3. 键盘已经弹出，键盘高度调整

        keyboardHeight+=offset;
        //viewController.view.center = CGPointMake(viewController.view.center.x, viewController.view.center.y-offset);
        
        contentView.center = CGPointMake(contentView.center.x, contentView.center.y-offset);
        self.center = CGPointMake(self.center.x, self.center.y-offset);
        
    }
    
}

- (void)keyboardWillHidden:(NSNotification *)notification{

    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
//    if (keyboardHasShow && !keyboardWillHidden && !keyboardWillShow)  {//只处理frame change(willshow willhidden or framechange)
//        
//        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//        
//        CGRect startBound,endBound;
//        [[notification.userInfo objectForKey:UIKeyboardCenterBeginUserInfoKey] getValue:&startBound];
//        [[notification.userInfo objectForKey:UIKeyboardCenterEndUserInfoKey] getValue:&endBound];
//        float offset = startBound.origin.y - endBound.origin.y;
//        keyboardHeight+=offset;
//        
//        if ( offset) {
//            [self showKeyboardWithDuration:[duration floatValue] option:[curve intValue]<<16 offset:offset];
//        }
//        
//    }
    
}

#pragma mark - NTFacialView delegate
- (void)facialView:(NTFacialView *)facialView didSelectedWithText:(NSString *)_text{

    NSLog(@"表情：%@",_text);
    
}

- (void)didSelectDeleteFacialView:(NTFacialView *)facialView{

}


#pragma mark - UIExpandingTextView delegate

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    return YES;
}

- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView{
    return YES;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{

}
- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{

}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return YES;
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{

}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    
    float diff = growingTextView.frame.size.height - height;
    NSLog(@"height = %f,diff=%f",height,diff);
    
    
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
    
    CGRect gr = growingTextView.frame;
    growingTextView.frame = CGRectMake(gr.origin.x, gr.origin.y, gr.size.width, gr.size.height-=diff);
    
    facialView.center = CGPointMake(facialView.center.x,facialView.center.y-diff );
    facialBackgroundView.center = CGPointMake(facialBackgroundView.center.x, facialBackgroundView.center.y-diff);
    
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{

}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView{

}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{

    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(inputToolBar:sendMessageWithText:)]) {
            [_inputDelegate inputToolBar:self sendMessageWithText:growingTextView.text];
            growingTextView.text = nil;
            [growingTextView resignFirstResponder];
        }
    return YES;
    
}



//- (BOOL)expandingTextViewShouldBeginEditing:(UIExpandingTextView *)expandingTextView{
//    
//    return YES;
//}
//- (BOOL)expandingTextViewShouldEndEditing:(UIExpandingTextView *)expandingTextView{
//    return YES;
//}
//- (BOOL)expandingTextView:(UIExpandingTextView *)expandingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    return YES;
//}
//- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
//    
//    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(inputToolBar:sendMessageWithText:)]) {
//        [_inputDelegate inputToolBar:self sendMessageWithText:expandingTextView.text];
//        expandingTextView.text = nil;
//        [expandingTextView resignFirstResponder];
//    }
//    return YES;
//}
//
//- (void)expandingTextViewDidBeginEditing:(UIExpandingTextView *)expandingTextView{}
//- (void)expandingTextViewDidEndEditing:(UIExpandingTextView *)expandingTextView{}
//
//- (void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView{}
//
//- (void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height{
//    
//    float diff = expandingTextView.frame.size.height - height;
//    NSLog(@"height=%f,diff=%f",height,diff);
//    CGRect r = self.frame;
//    r.origin.y += diff;
//    r.size.height -= diff;
//    self.frame = r;
//    
//}
//- (void)expandingTextView:(UIExpandingTextView *)expandingTextView didChangeHeight:(float)height{
//
//}
//
//- (void)expandingTextViewDidChangeSelection:(UIExpandingTextView *)expandingTextView{}
//
//



@end
