//
//  NTInputControllerProtocol.h
//  NTFacialInputDemo
//
//  Created by nonstriater on 14-4-14.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#ifndef NTFacialInputDemo_NTInputControllerProtocol_h
#define NTFacialInputDemo_NTInputControllerProtocol_h

@protocol NTInputControllerDelegate <NSObject>
@required
- (UIView *)contentView;
- (UIView *)inputBarView;

@end

#endif
