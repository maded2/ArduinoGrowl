//
//  GrowlSampleDisplay.h
//  Growl Display Plugins
//
//  Copyright 2006-2009 The Growl Project. All rights reserved.
//

#import "ArduinoGrowlDisplay.h"



#import "GrowlApplicationNotification.h"
#import "GrowlDefinesInternal.h"
#import "GrowlDefines.h"

#import "PrefsViewController.h"
#import "NotificationController.h"

@implementation ArduinoGrowlDisplay

- (id) init {
	if ((self = [super init])) {
		windowControllerClass = NSClassFromString(@"NotificationController");
	}
		
	return self;
}

- (void) dealloc {
	[preferencePane release];
	[super dealloc];
}

- (NSPreferencePane *) preferencePane {
	if (!preferencePane)
		preferencePane = [[PrefsViewController alloc] initWithBundle:[NSBundle bundleForClass:[PrefsViewController class]]];
	return preferencePane;
}

#pragma mark -
#pragma mark GrowlPositionController Methods
#pragma mark -

- (BOOL)requiresPositioning {
	return NO;
}

#pragma mark -
#pragma mark GAB
#pragma	mark -

- (void) configureBridge:(GrowlNotificationDisplayBridge *)theBridge {
	NotificationController *controller = [[theBridge windowControllers] objectAtIndex:0U];
	GrowlApplicationNotification *note = [theBridge notification];
	NSDictionary *noteDict = [note dictionaryRepresentation];
	
	[controller setNotifyingApplicationName:[note applicationName]];
	[controller setNotifyingApplicationProcessIdentifier:[noteDict objectForKey:GROWL_APP_PID]];
	[controller setClickContext:[noteDict objectForKey:GROWL_NOTIFICATION_CLICK_CONTEXT]];
	[controller setScreenshotModeEnabled:getBooleanForKey(noteDict, GROWL_SCREENSHOT_MODE)];
	[controller setClickHandlerEnabled:[noteDict objectForKey:@"ClickHandlerEnabled"]];
	
}



@end
