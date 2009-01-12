//
//  KDGradientButtonCell.h
//  KDSliderControl
//
//  Created by Keith Duncan on 06/07/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDGradientCell : NSButtonCell {
	CGFloat _cornerRadius;
}

@property(assign) CGFloat cornerRadius;

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)view;

@end
