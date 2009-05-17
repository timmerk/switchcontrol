//
//  ApplicationController.h
//  Switch Control
//
//  Created by Keith Duncan on 27/02/2009.
//  Copyright 2009 thirty-three. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFSwitchControl;

@interface ApplicationController : NSObject {
	AFSwitchControl *control;
}

@property (assign) IBOutlet AFSwitchControl *control;

@end
