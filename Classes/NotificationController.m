//
//  NotificationController.m
//  ArduinoGrowl
//
//  Created by Eddie Chan on 22/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NotificationController.h"

#import "GrowlDefines.h"
#import "GrowlApplicationNotification.h"

#import "AMSerialPort.h"
#import "AMSerialPortAdditions.h"
#import "AMSerialPortList.h"

#define ArduinoPrefDomain			@"com.Growl.Arduino"
#define PrefKey						@"arduinoSerialPort"

static AMSerialPort *port= nil;
static NSString *portString= nil;

@implementation NotificationController

- (id) init 
{
	NSLog(@"init notification controller");

	if (!portString)
	{
		SYNCHRONIZE_GROWL_PREFS();
		
		NSData *data = nil;
		READ_GROWL_PREF_VALUE(PrefKey, ArduinoPrefDomain, NSData*, &data);
		if (data && [data isKindOfClass:[NSData class]]) {
			portString = [NSUnarchiver unarchiveObjectWithData:data];
		} else {
			portString = nil;
		}
		[data release];

		if (portString)
		{
			NSLog(@"serial port = %s", [portString UTF8String]);
		}
	}
	return self;
}

- (void) setNotification: (GrowlApplicationNotification *) theNotification {
	[super setNotification:theNotification];
	if (!theNotification)
		return;
	

	//NSDictionary *noteDict = [notification dictionaryRepresentation];
	NSString *title = [notification title];
	NSString *text  = [notification notificationDescription];

	
	NSLog(@"send notification : %s", [title UTF8String]);
	
	if (!port || ![port isOpen])
		[self initPort];
	
	if(port && [port isOpen]) {
		NSMutableData *data= [NSMutableData dataWithData: [title dataUsingEncoding: NSUTF8StringEncoding]];
		[data increaseLengthBy: 1];
		[port writeData: data error:NULL];
		[port writeString:text usingEncoding:NSUTF8StringEncoding error:NULL];
	}
	else
		NSLog(@"failed to send notification");

	
}

+ (void)newPortSelected: (NSString *)newPort
{
	// close current port
	if (!port)
	{
		NSLog(@"closing old port");
		[port close];
		[port release];
	}
	NSLog(@"new port selected");

	port= nil;
	portString= newPort;
}

- (void)initPort
{
	// Try connection
	
	AMSerialPort *newPort= [[AMSerialPort alloc] init: portString withName: portString type:(NSString*)CFSTR(kIOSerialBSDModemType)];
	if ([newPort open]) {
		
		//Then I suppose we connected!
		NSLog(@"successfully connected");
				
		//The standard speeds defined in termios.h are listed near
		//the top of AMSerialPort.h. Those can be preceeded with a 'B' as below. However, I've had success
		//with non standard rates (such as the one for the MIDI protocol). Just omit the 'B' for those.
		
		[newPort setSpeed:B38400]; 
		
		
		// listen for data in a separate thread
		[newPort readDataInBackground];
		port= newPort;
		
	} else { // an error occured while creating port
		
		NSLog(@"error connecting");
		
	}
	
}

@end
