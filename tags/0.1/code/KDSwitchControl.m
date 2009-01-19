//
//  KDSliderControl.m
//  KDStatusSliderButton
//
//  Created by Keith Duncan on 26/01/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//
// Event loop in -mouseDown: contributed by Jonathan Dann
// It replaced my massive loop and is far more functional
//

#import "KDSwitchControl.h"

#import "KDGradientCell.h"

#import "Amber/Amber.h"
#import <QuartzCore/CoreAnimation.h>

@interface KDSwitchControl ()
@property(assign) float floatValue;
@property(assign) BOOL state;
@end

@interface KDSwitchControl (Private)
- (void)_drawKnobInSlotRect:(NSRect)bounds radius:(CGFloat)radius;
@end

@implementation KDSwitchControl

@synthesize floatValue=_floatValue;

+ (void)initialize {
	[self exposeBinding:NSValueBinding];
}

+ (id)defaultAnimationForKey:(NSString *)key {
	if ([key isEqualToString:@"floatValue"]) {
		id animation = [CABasicAnimation animation];
		[animation setDuration:0.15];
		return animation;
	} return [super defaultAnimationForKey:key];
}

+ (Class)cellClass {
	return [KDGradientCell class];
}

- (id)initWithFrame:(NSRect)frame {
	[super initWithFrame:frame];
	
	[self setWantsLayer:YES];
	
	_bindingInfo = [[NSMutableDictionary alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSApplicationDidBecomeActiveNotification object:NSApp];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSApplicationDidResignActiveNotification object:NSApp];
	
	return self;
}

- (void)dealloc {
	[_bindingInfo release];
	
	[super dealloc];
}

- (void)setFloatValue:(float)value {
	_floatValue = value;
	
	[self setNeedsDisplay:YES];
}

- (BOOL)state {
	return [[self valueForBinding:NSValueBinding] boolValue];
}

- (void)setState:(BOOL)value {
	[self setValue:[NSNumber numberWithBool:value] forBinding:NSValueBinding];
}

- (void)viewWillMoveToSuperview:(NSView *)view {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:[self window]];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:[self window]];
	
	[super viewWillMoveToSuperview:view];
	if (view == nil) return;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidResignKeyNotification object:[view window]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(display) name:NSWindowDidBecomeKeyNotification object:[view window]];
}

NS_INLINE NSRect InsetTextRect(NSRect textRect) {
	return NSInsetRect(textRect, 0, NSHeight(textRect)/7.0);
}

NS_INLINE void PartRects(NSRect bounds, NSRect *textRects, NSRect *backgroundRect) {
	NSDivideRect(bounds, textRects, backgroundRect, NSWidth(bounds)/5.0, NSMinXEdge);
	
	textRects[1] = InsetTextRect(NSOffsetRect(textRects[0], NSWidth(*backgroundRect), 0));
	textRects[0] = InsetTextRect(textRects[0]);
		
	(*backgroundRect).size.width -= NSWidth(*textRects);
	*backgroundRect = NSInsetRect(*backgroundRect, NSWidth(bounds)/20.0, 0);
}

NS_INLINE NSRect InsetBackgroundRect(NSRect backgroundRect) {
	return NSInsetRect(backgroundRect, 1.0, 1.0);
}

NS_INLINE CGFloat BackgroundRadiusForRect(NSRect rect) {
	return (4.0/27.0)*NSHeight(rect);
}

NS_INLINE NSRect KnobRectForInsetBackground(NSRect slotRect, float floatValue) {
	CGFloat knobWidth = NSWidth(slotRect)*(4.0/9.0);
	return RectFromCentrePoint(NSMakePoint(NSMinX(slotRect) + (knobWidth/2.0) + (floatValue*(NSWidth(slotRect)-knobWidth)), NSMidY(slotRect)), NSMakeSize(knobWidth, NSHeight(slotRect)));
}

- (void)drawRect:(NSRect)frame {
	NSRect textRects[2], backgroundRect;
	PartRects([self bounds], textRects, &backgroundRect);
	
	if ([self needsToDrawRect:textRects[0]] || [self needsToDrawRect:textRects[1]]) {		
		NSShadow *textShadow = [[NSShadow alloc] init];
		[textShadow setShadowColor:[NSColor whiteColor]];
		[textShadow setShadowOffset:NSMakeSize(0, -1.5)];
		[textShadow setShadowBlurRadius:0.0];
		
		[NSGraphicsContext saveGraphicsState];
		[textShadow set];
		
		[[NSColor colorWithCalibratedWhite:(74.0/255.0) alpha:1.0] set];
		AKDrawStringAlignedInFrame(@"OFF", [NSFont boldSystemFontOfSize:0], NSCenterTextAlignment, NSIntegralRect(textRects[0]));
		
		[NSGraphicsContext restoreGraphicsState];
		
		[NSGraphicsContext saveGraphicsState];
		[textShadow set];
		
		NSUInteger state = [[self valueForBinding:NSValueBinding] unsignedIntegerValue];
	
#if 1
		if (state == NSOnState && [[NSApplication sharedApplication] isActive]) {
			[[NSColor colorWithCalibratedRed:(25.0/255.0) green:(86.0/255.0) blue:(173.0/255.0) alpha:1.0] set];
		} else {
			[[NSColor colorWithCalibratedWhite:(74.0/255.0) alpha:1.0] set];
		}
		
		AKDrawStringAlignedInFrame(@"ON", [NSFont boldSystemFontOfSize:0], NSCenterTextAlignment, NSIntegralRect(textRects[1]));
#else
		[[NSGradient sourceListSelectionGradientIsKey:([self state] == NSOnState && [[self window] isKeyWindow])] drawInBezierPath:textPath angle:-90.0];
#endif
		
		[NSGraphicsContext restoreGraphicsState];
		[textShadow release];
	}
	
	CGFloat radius = 0;
	NSBezierPath *backgroundPath = nil;
	NSGradient *backgroundGradient = nil;
	
	radius = BackgroundRadiusForRect(backgroundRect);
	backgroundPath = [NSBezierPath bezierPathWithRoundedRect:NSIntegralRect(backgroundRect) xRadius:radius yRadius:radius];
	backgroundGradient = [[NSGradient alloc] initWithColors:[NSArray arrayWithObjects:[NSColor colorWithCalibratedWhite:(80.0/255.0) alpha:0.9], [NSColor colorWithCalibratedWhite:(129.0/255.0) alpha:0.9], nil]];
	
	[backgroundGradient drawInBezierPath:backgroundPath angle:-90];
	[backgroundGradient release];
	
	NSRect insetBackgroundRect = InsetBackgroundRect(backgroundRect);
	
	radius = BackgroundRadiusForRect(insetBackgroundRect);
	backgroundPath = [NSBezierPath bezierPathWithRoundedRect:NSIntegralRect(insetBackgroundRect) xRadius:radius yRadius:radius];
	backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:(99.0/255.0) alpha:1.0], 0.0, [NSColor colorWithCalibratedWhite:(142.0/255.0) alpha:1.0], 0.3, [NSColor colorWithCalibratedWhite:(171.0/255.0) alpha:1.0], 1.0, nil];
	
	[backgroundGradient drawInBezierPath:backgroundPath angle:-90];
	[backgroundGradient release];
	
	[NSGraphicsContext saveGraphicsState];
	[backgroundPath setClip];
	
	// Draw the knob
	[self _drawKnobInSlotRect:insetBackgroundRect radius:radius];
	
	[NSGraphicsContext restoreGraphicsState];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
	return YES;
}

- (void)mouseDown:(NSEvent *)event {
	NSRect textRect, backgroundRect;
	PartRects([self bounds], &textRect, &backgroundRect);
	
	NSRect slotRect = InsetBackgroundRect(backgroundRect);
	NSRect knobRect = KnobRectForInsetBackground(slotRect, _floatValue);
	
	NSPoint hitPoint = [self convertPoint:[event locationInWindow] fromView:nil];
	BOOL state = self.state;
	
	if (![self mouse:hitPoint inRect:knobRect]) {
		if ((state == NSOffState && NSMaxX(knobRect) < hitPoint.x) || (state == NSOnState && NSMinX(knobRect) > hitPoint.x)) [self setValue:[NSNumber numberWithUnsignedInteger:!state] forBinding:NSValueBinding];
		return;
	}
	
	[[self cell] setHighlighted:YES];
	
	BOOL loop = YES, dragging = NO;
	
	NSPoint mouseLocation;
	
	while (loop) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseUpMask|NSLeftMouseDraggedMask)];
		mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];
		
		CGFloat newFloat, newPosition;
		CGFloat minPosition = NSMinX(slotRect) + NSWidth(knobRect)/2.0;
		CGFloat maxPosition = NSMaxX(slotRect) - NSWidth(knobRect)/2.0;
		
		switch ([event type]) {
			case NSLeftMouseDragged:
				dragging = YES;
				newPosition = mouseLocation.x - (hitPoint.x-NSMidX(knobRect));
				
				if (newPosition <= minPosition)
					newFloat = 0.0;
				else if (newPosition >= maxPosition)
					newFloat = 1.0;
				else
					newFloat = (newPosition-minPosition)/(maxPosition - minPosition);
				
				self.floatValue = newFloat;
				break;
			case NSLeftMouseUp:
				[[self cell] setHighlighted:NO];
				
				if (dragging) {
					if (_floatValue >= 0.15 && state == NO) self.state = YES;
					else if (_floatValue <= 0.85 && state == YES) self.state = NO;
					else self.state = state;
				} else self.state = !state;
				
				loop = NO;
				break;
		}
	}
}

@end

@implementation KDSwitchControl (KDKeyValueBinding)

- (id)infoForBinding:(NSString *)binding {
	id info = [_bindingInfo objectForKey:binding];
	return (info != nil) ? info : [super infoForBinding:binding];
}

- (void)setInfo:(id)info forBinding:(NSString *)binding {
	[_bindingInfo setObject:info forKey:binding];
}

void *SelectedIndexObservationContext = (void *)1000;

- (void *)contextForBinding:(NSString *)binding {
	if ([binding isEqualToString:NSValueBinding]) return SelectedIndexObservationContext;
	else return nil;
}

- (void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options {
	if ([self infoForBinding:binding] != nil) [self unbind:binding];
	
	void *context = [self contextForBinding:binding];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
						  observable, NSObservedObjectKey,
						  [[keyPath copy] autorelease], NSObservedKeyPathKey,
						  [[options copy] autorelease], NSOptionsKey, nil];
	
	if ([binding isEqualToString:NSValueBinding]) {
		[self setInfo:info forBinding:binding];
		[observable addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:context];
		
		[self setFloatValue:([self state] ? 1.0 : 0.0)];
		
		_floatValue = [[self valueForBinding:NSValueBinding] unsignedIntegerValue];
	} else [super bind:binding toObject:observable withKeyPath:keyPath options:options];
	
	[self setNeedsDisplay:YES];
}

- (void)unbind:(NSString *)binding {
	if ([binding isEqualToString:NSValueBinding]) {
		[[self controllerForBinding:binding] removeObserver:self forKeyPath:[self keyPathForBinding:binding]];
		[_bindingInfo removeObjectForKey:binding];
	} else [super unbind:binding];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == SelectedIndexObservationContext) {
		[[self animator] setFloatValue:[[self valueForBinding:NSValueBinding] unsignedIntegerValue]];
	} else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	[self setNeedsDisplay:YES];
}

@end

@implementation KDSwitchControl (Private)

- (void)_drawKnobInSlotRect:(NSRect)slotRect radius:(CGFloat)radius {
	NSRect handleBounds = KnobRectForInsetBackground(slotRect, _floatValue);
	
	KDGradientCell *cell = (KDGradientCell *)[self cell];
	
	cell.cornerRadius = radius;
	[cell drawBezelWithFrame:NSIntegralRect(handleBounds) inView:self];
}

@end
