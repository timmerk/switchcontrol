//
//  ApplicationController.m
//  Switch Control
//
//  Created by Keith Duncan on 27/02/2009.
//  Copyright 2009 thirty-three. All rights reserved.
//

#import "ApplicationController.h"

@implementation ApplicationController

@dynamic control;

- (void)awakeFromNib {
	[control bind:NSValueBinding toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.importantOption" options:nil];
}

@end
