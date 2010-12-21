//
//  NotificationController.h
//  ArduinoGrowl
//
//  Created by Eddie Chan on 22/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GrowlDisplayWindowController.h"

#import "AMSerialPort.h"

@interface NotificationController : GrowlDisplayWindowController {
		
}

+ (void)newPortSelected: (NSString *)newPort;

- (void)initPort;

@end
