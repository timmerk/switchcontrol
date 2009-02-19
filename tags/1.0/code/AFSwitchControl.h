//
//  KDSliderButton.h
//  KDStatusSliderButton
//
//  Created by Keith Duncan on 26/01/2008.
//  Copyright 2008 thirty-three. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AFSwitchControl : NSControl {
	NSMutableDictionary *_bindingInfo;
	
	float _floatValue;
	CGFloat _cumulativeDelta;
}

@end

@interface AFSwitchControl (KDKeyValueBinding) <AFKeyValueBinding>

@end
