//
//  PrefsViewController.m
//
//  Created by Eddie Chan on 22/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrefsViewController.h"

#import "GrowlDefinesInternal.h"

#import "AMSerialPortList.h"
#import "AMSerialPortAdditions.h"
#import "AMSerialPort.h"

#import "NotificationController.h"

@implementation PrefsViewController

- (NSString *)mainNibName
{
	return @"PrefsViewController";
}

- (void)mainViewDidLoad
{
	// load available serial ports into combobox

	
	/// initialize port list to arm notifications
	[AMSerialPortList sharedPortList];
	
	
	// get an port enumerator
	NSEnumerator *enumerator = [AMSerialPortList portEnumerator];
	AMSerialPort *aPort;
	[serialPortSelection removeAllItems];
	
	while (aPort = [enumerator nextObject]) {
		[serialPortSelection addItemWithObjectValue:[aPort bsdPath]];
	}

	SYNCHRONIZE_GROWL_PREFS();
	
	NSData *data = nil;
	READ_GROWL_PREF_VALUE(PrefKey, ArduinoPrefDomain, NSData*, &data);
	if (data && [data isKindOfClass:[NSData class]]) {
		selectedPort = [NSUnarchiver unarchiveObjectWithData:data];
	} else {
		selectedPort = nil;
	}
	[data release];
	
	if (selectedPort)
	{
		NSLog(@"serial port = %s", [selectedPort UTF8String]);
		[serialPortSelection selectItemWithObjectValue: selectedPort];
	}
}

- (IBAction)serialPortSelectionDidChanged:(id)sender
{
	if (selectedPort && [selectedPort isEqualToString: [serialPortSelection objectValueOfSelectedItem]])
		return;
						  

	selectedPort= [serialPortSelection objectValueOfSelectedItem];

	NSLog(@"serial port changed to %s", [selectedPort UTF8String]);

	NSData *theData = [NSArchiver archivedDataWithRootObject:selectedPort];
    WRITE_GROWL_PREF_VALUE(PrefKey, theData, ArduinoPrefDomain);
    UPDATE_GROWL_PREFS();

	[NotificationController newPortSelected: selectedPort];

}

@end
