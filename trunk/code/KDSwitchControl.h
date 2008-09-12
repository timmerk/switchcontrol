//
//  KDSliderButton.h
//  KDStatusSliderButton
//
//  Created by Keith Duncan on 26/01/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDSwitchControl : NSControl {
	NSMutableDictionary *_bindingInfo;
	
	float _floatValue;
	CGFloat _cumulativeDelta;
}

@end

@interface KDSwitchControl (KDKeyValueBinding) <AFKeyValueBinding>

@end
