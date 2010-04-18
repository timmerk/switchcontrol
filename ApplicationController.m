//
//  ApplicationController.m
//  Switch Control
//
//  Created by Keith Duncan on 27/02/2009.
//  Copyright 2009 thirty-three. All rights reserved.
//

#import "ApplicationController.h"

#import "AmberFoundation/AmberFoundation.h"

@implementation ApplicationController

@synthesize control;

- (void)awakeFromNib {
	[[self control] bind:NSValueBinding toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:[NSString stringWithKeyPathComponents:@"values", @"importantOption", nil] options:nil];
}

@end
