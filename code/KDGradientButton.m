//
//  KDGradientButton.m
//  KDSliderControl
//
//  Created by Keith Duncan on 06/07/2008.
//  Copyright 2008 thirty-three software. All rights reserved.
//

#import "KDGradientButton.h"

#import "KDGradientCell.h"

@implementation KDGradientButton

+ (Class)cellClass {
	return [KDGradientCell class];
}

- (BOOL)isFlipped {
	return NO;
}

- (void)drawRect:(NSRect)frame {	
	((KDGradientCell *)_cell).cornerRadius = NSHeight(frame)/6.0;
	
	[super drawRect:frame];
}

@end
