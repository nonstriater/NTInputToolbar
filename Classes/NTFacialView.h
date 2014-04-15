//
//  NTFacialView.h
//  FuShuo 管理所有表情
//
//  Created by nonstriater on 14-4-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoji.h"


@protocol NTFacialViewDelegate;
@interface NTFacialView : UIView{

    UIScrollView *facialScrollView;
    UIPageControl *pageControl;
}

@property(nonatomic,weak) id<NTFacialViewDelegate> delegate;
//@property(nonatomic,assign) CGRectInset contentEdge;//内边距
@property(nonatomic,assign) CGSize emotionSize;//每个标签的大小，默认 40x40px
@property(nonatomic,assign) BOOL pageControlHidden; //default is NO;
@property(nonatomic,strong) UIImage *deleteNormalIcon;//每一页标签右下角是一个删除按键
@property(nonatomic,strong) UIImage *deleteHightlightIcon;

@end


@protocol NTFacialViewDelegate <NSObject>
@optional

- (void)facialView:(NTFacialView *)facialView didSelectedWithText:(NSString *)text;
- (void)didSelectDeleteFacialView:(NTFacialView *)facialView;

@end

