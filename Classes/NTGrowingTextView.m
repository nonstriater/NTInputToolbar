//
//  NTGrowingTextView.m
//  NTFacialInputDemo
//
//  Created by nonstriater on 14-4-14.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "NTGrowingTextView.h"

#define SYSTEM_VERSION_GRATER_THAN_OR_EQUAL(version) ([[[UIDevice currentDevice] systemVersion] compare:(version) options:NSNumericSearch]!=NSOrderedAscending)

const CGFloat kTextInsetX = 5.f;

@implementation NTGrowingTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.placeholderColor = [UIColor grayColor];
        self.placeholderText = @"点我！点我！";
        self.textViewBackgroundImage = [[UIImage imageNamed:@"default_input_bkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10,10,10, 10) resizingMode:UIImageResizingModeTile];
        
        [self initializeView];
        
    }
    return self;
}

- (void)initializeView{

    // Drawing code
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGRect backgroundFrame = self.frame;
    backgroundFrame.origin.y = 0;
    backgroundFrame.origin.x = 0;
    
    CGRect textViewFrame = CGRectInset(backgroundFrame, kTextInsetX, 0.f);
    
    /* Internal Text View component */
    internalTextView = [[UITextView alloc] initWithFrame:textViewFrame];
    internalTextView.delegate        = self;
    internalTextView.font            = [UIFont systemFontOfSize:18.0];
    internalTextView.contentInset    = UIEdgeInsetsMake(0,0,0,0);
    internalTextView.text            = @"";
    internalTextView.scrollEnabled   = NO;
    internalTextView.opaque          = NO;
    internalTextView.backgroundColor = [UIColor clearColor];
    internalTextView.showsHorizontalScrollIndicator = NO;
    internalTextView.layer.cornerRadius =5.0;
    internalTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    /* set placeholder */
    placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8,0,self.bounds.size.width - 16,self.bounds.size.height)];
    placeholderLabel.text = _placeholderText;
    placeholderLabel.font = internalTextView.font;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.textColor = self.placeholderColor;
    [internalTextView addSubview:placeholderLabel];
    
    /* Custom Background image */
    textViewBackgroundImageView = [[UIImageView alloc] initWithImage:self.textViewBackgroundImage];
    textViewBackgroundImageView.frame          = backgroundFrame;
    textViewBackgroundImageView.contentMode    = UIViewContentModeScaleToFill;
    
    [self addSubview:textViewBackgroundImageView];
    [self addSubview:internalTextView];
    
    minHeight = self.frame.size.height;
    [self setMaxNumberOfLines:5];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
}

- (void)setMaxNumberOfLines:(NSInteger)n{

    NSString *saveText = internalTextView.text, *newText = @"-";
    
    internalTextView.delegate = nil;
    internalTextView.hidden = YES;
    
    for (int i = 1; i < n; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    
    maxHeight = ((SYSTEM_VERSION_GRATER_THAN_OR_EQUAL(@"7"))?[[internalTextView layoutManager] usedRectForTextContainer:[internalTextView textContainer]].size.height:internalTextView.contentSize.height)+24.f;
    
    internalTextView.text = saveText;
    internalTextView.hidden = NO;
    internalTextView.delegate = self;
    
    
    _maxNumberOfLines = n;

}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setText:(NSString *)newText
{
    
    internalTextView.text = newText;
    
    // include this line to analyze the height of the textview.
    // fix from Ankit Thakur
    [self performSelector:@selector(textViewDidChange:) withObject:internalTextView];
}

-(NSString*) text
{
    return internalTextView.text;
}

// textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length]) {
        placeholderLabel.alpha = 0.f;
    }else{
        placeholderLabel.alpha = 1.f;
    }
    
    CGFloat newHeight = 0.f;
//    if(SYSTEM_VERSION_GRATER_THAN_OR_EQUAL(@"7")){
//        //internalTextView.textContainer.heightTracksTextView = YES;
//        internalTextView.layoutManager.allowsNonContiguousLayout = NO;
//    }
//    newHeight = internalTextView.contentSize.height;
    
    newHeight = [internalTextView sizeThatFits:CGSizeMake(internalTextView.frame.size.width, maxHeight)].height;
    
    NSLog(@"***newHeight=%f || maxheight=%f",newHeight,maxHeight);
    
    if (newHeight<minHeight) {
        newHeight = minHeight;
    }
    
    if (internalTextView.frame.size.height != newHeight) {
        
        if (newHeight > maxHeight && internalTextView.frame.size.height <= maxHeight)
        {
            newHeight = maxHeight;
        }
        
        if (newHeight >= maxHeight)
		{
            /* Enable vertical scrolling */
			if(!internalTextView.scrollEnabled)
            {
				internalTextView.scrollEnabled = YES;
				[internalTextView flashScrollIndicators];
			}
		}else{
            /* Disable vertical scrolling */
			internalTextView.scrollEnabled = NO;
		}
        
        
		if (newHeight <= maxHeight)
		{
            
            if ([_delegate respondsToSelector:@selector(growingTextView:willChangeHeight:)])
            {
				[_delegate growingTextView:self willChangeHeight:newHeight];
			}
            
            [self resizeTextViewWithNewHeight:newHeight animation:YES];
            
            if ([_delegate respondsToSelector:@selector(growingTextViewDidChange:)])
            {
                [_delegate growingTextViewDidChange:self];
            }

		}
		
		
	}
    
}

- (void)resizeTextViewWithNewHeight:(CGFloat)newHeight animation:(BOOL)animated{

    if(animated)
    {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(resizeTextViewFinish)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }

    /* Resize the frame */
    CGRect r = self.frame;
    r.size.height = newHeight;
    self.frame = r;
    r.origin.y = 0;
    r.origin.x = 0;
    internalTextView.frame = CGRectInset(r, kTextInsetX, 0);
    //            r.size.height -= 8;
    textViewBackgroundImageView.frame = r;
    
    if(animated)
    {
        [UIView commitAnimations];
    }
    
}


- (void)resizeTextViewFinish{

}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setFont:(UIFont *)afont
{
	internalTextView.font= afont;
	
	//[self setMaxNumberOfLines:maxNumberOfLines];
	//[self setMinNumberOfLines:minNumberOfLines];
}

-(UIFont *)font
{
	return internalTextView.font;
}

-(void)setTextColor:(UIColor *)color
{
	internalTextView.textColor = color;
}

-(UIColor*)textColor{
	return internalTextView.textColor;
}

-(void)setReturnKeyType:(UIReturnKeyType)keyType
{
	internalTextView.returnKeyType = keyType;
}

-(UIReturnKeyType)returnKeyType
{
	return internalTextView.returnKeyType;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [internalTextView becomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return [internalTextView becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
	[super resignFirstResponder];
	return [internalTextView resignFirstResponder];
}

#pragma mark - UITextView delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	if ([_delegate respondsToSelector:@selector(growingTextViewShouldBeginEditing:)]) {
		return [_delegate growingTextViewShouldBeginEditing:self];
		
	} else {
        placeholderLabel.alpha = 0.f;
		return YES;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	if ([_delegate respondsToSelector:@selector(growingTextViewShouldEndEditing:)]) {
		return [_delegate growingTextViewShouldEndEditing:self];
		
	} else {
        
		return YES;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidBeginEditing:(UITextView *)textView {
	if ([_delegate respondsToSelector:@selector(growingTextViewDidBeginEditing:)]) {
		[_delegate growingTextViewDidBeginEditing:self];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([_delegate respondsToSelector:@selector(growingTextViewDidEndEditing:)]) {
		[_delegate growingTextViewDidEndEditing:self];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)atext {
	
	//weird 1 pixel bug when clicking backspace when textView is empty
	if(![textView hasText] && [atext isEqualToString:@""]) return NO;
	
	if ([atext isEqualToString:@"\n"]) {
		if ([_delegate respondsToSelector:@selector(growingTextViewShouldReturn:)]) {
			if (![_delegate performSelector:@selector(growingTextViewShouldReturn:) withObject:self]) {
				return YES;
			} else {
				[textView resignFirstResponder];
				return NO;
			}
		}
	}
	
	return YES;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChangeSelection:(UITextView *)textView {
	if ([_delegate respondsToSelector:@selector(growingTextViewDidChangeSelection:)]) {
		[_delegate growingTextViewDidChangeSelection:self];
	}
}


@end
