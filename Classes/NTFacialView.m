//
//  NTFacialView.m
//  FuShuo
//
//  Created by nonstriater on 14-4-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "NTFacialView.h"

@implementation NTFacialView{

    NSArray *emotions;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pageControlHidden = YES;
        self.emotionSize = CGSizeMake(40.f, 40.f);
        self.backgroundColor = [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.f];
        
        emotions = [Emoji emojiEmotions];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    facialScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    facialScrollView.pagingEnabled = YES;
    facialScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:facialScrollView];
    
    CGFloat topPadding = 12;
    CGFloat leftPadding = 8;
    
    CGFloat contentHeight = CGRectGetHeight(rect)-2*topPadding;
    CGFloat contentWidth = CGRectGetWidth(rect)- 2*leftPadding;
    
    if (contentHeight<_emotionSize.height ||
        contentWidth<_emotionSize.width) {
        NSLog(@"the facial view rect too small!!");
        return;
    }
    
    int numOfRows = fabsf(contentHeight/_emotionSize.height);
    int numOfColoums = fabsf(contentWidth/_emotionSize.width);

    
    CGFloat rowsMargin = (contentHeight-numOfRows*_emotionSize.height)/(numOfRows-1);
    CGFloat coloumsMargin = (contentWidth-numOfColoums*_emotionSize.width)/(numOfColoums-1);
    
    int t = [emotions count];
    int numOfPages = 0;
    while(t>0){
        
        //最后一页不足一整页
        int numOfEmotionOnePage = (t>numOfRows*numOfColoums-1)?numOfRows*numOfColoums:t+1;
        
        for (int i=0; i<numOfEmotionOnePage; i++) {
            
            int currentRow = i/numOfColoums;
            int currentColomu = i%numOfColoums;
            
            
            UIButton *emotionItem = [UIButton buttonWithType:UIButtonTypeCustom];
            emotionItem.backgroundColor = [UIColor clearColor];
            emotionItem.frame = CGRectMake(numOfPages*CGRectGetWidth(rect)+leftPadding+currentColomu*(_emotionSize.width+coloumsMargin), topPadding+currentRow*(_emotionSize.height+rowsMargin), _emotionSize.width, _emotionSize.height);
            if (i<numOfEmotionOnePage-1) {
                
                [emotionItem.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:30.f]];
                [emotionItem setTitle:emotions[(numOfPages)*(numOfColoums*numOfRows-1)+i] forState:UIControlStateNormal];
                [emotionItem addTarget:self action:@selector(emotionItemClicked:) forControlEvents:UIControlEventTouchUpInside];
     
            }else{// 最后一个位置
            
                if (!self.deleteNormalIcon) {
                    self.deleteNormalIcon = [UIImage imageNamed:@"default_delete_icon_n"];
                    self.deleteHightlightIcon = [UIImage imageNamed:@"default_delete_icon_h"];
                }
                [emotionItem setImage:self.deleteNormalIcon forState:UIControlStateNormal];
                [emotionItem addTarget:self action:@selector(deleteItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                [emotionItem setImage:self.deleteHightlightIcon forState:UIControlStateHighlighted];
                
            }
            
            [facialScrollView addSubview:emotionItem];
        }
        
        t-=(numOfColoums*numOfRows-1);
        numOfPages++;
        
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];//TODO:
    pageControl.numberOfPages = numOfPages;
    pageControl.currentPage = 0;
    pageControl.hidesForSinglePage = YES;
    pageControl.hidden = self.pageControlHidden;
    [self addSubview:pageControl];
    
    facialScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*numOfPages, CGRectGetHeight(self.frame));
    
    
}


- (void)emotionItemClicked:(UIButton *)button{
    
    if (_delegate && [_delegate respondsToSelector:@selector(facialView:didSelectedWithText:)]) {
        [_delegate facialView:self didSelectedWithText:button.titleLabel.text];
    }
    
}

- (void)deleteItemClicked:(UIButton *)button{

    if (_delegate && [_delegate respondsToSelector:@selector(didSelectDeleteFacialView:)]) {
        [_delegate didSelectDeleteFacialView:self];
    }
}



@end
