//
//  NTGrowingTextView.h
//  NTFacialInputDemo
//
//  Created by nonstriater on 14-4-14.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<Foundation/NSKeyValueObserving.h>

@class NTGrowingTextView;

@protocol NTGrowingTextViewDelegate<NSObject>

@optional
- (BOOL)growingTextViewShouldBeginEditing:(NTGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldEndEditing:(NTGrowingTextView *)growingTextView;

- (void)growingTextViewDidBeginEditing:(NTGrowingTextView *)growingTextView;
- (void)growingTextViewDidEndEditing:(NTGrowingTextView *)growingTextView;

- (BOOL)growingTextView:(NTGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)growingTextViewDidChange:(NTGrowingTextView *)growingTextView;

- (void)growingTextView:(NTGrowingTextView *)growingTextView willChangeHeight:(float)height;
- (void)growingTextView:(NTGrowingTextView *)growingTextView didChangeHeight:(float)height;

- (void)growingTextViewDidChangeSelection:(NTGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldReturn:(NTGrowingTextView *)growingTextView;
@end



@interface NTGrowingTextView : UIView<UITextViewDelegate>{

    UITextView *internalTextView;
    UIImageView *textViewBackgroundImageView;
    UILabel      *placeholderLabel;
    
    CGFloat maxHeight;
    CGFloat minHeight;
    
}

@property (nonatomic,weak) id<NTGrowingTextViewDelegate> delegate;
@property (nonatomic,assign) NSInteger maxNumberOfLines;
@property (nonatomic,assign) UIReturnKeyType returnKeyType;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIFont *font;

@property(nonatomic,strong) UIImage *textViewBackgroundImage;
@property(nonatomic,strong) UIColor *placeholderColor;
@property(nonatomic,strong) NSString *placeholderText;

@end
