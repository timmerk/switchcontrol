//
//  KDSliderButton.h
//  KDStatusSliderButton
//
//  Created by Keith Duncan on 26/01/2008.
//  Copyright 2008 thirty-three. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AmberKit/AFKeyValueBinding.h"

@class AFGradientCell;

@interface AFSwitchControl : NSControl <AFKeyValueBinding> {
	NSMutableDictionary *_bindingInfo;
	
	CGFloat _floatValue;
}

@property (readwrite, retain) AFGradientCell *cell;

@end
