//
//  PrefsViewController.h
//
//  Created by Eddie Chan on 22/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

#define ArduinoPrefDomain			@"com.Growl.Arduino"
#define PrefKey						@"arduinoSerialPort"

@interface PrefsViewController : NSPreferencePane {

	IBOutlet NSComboBox		*serialPortSelection;
	IBOutlet NSTextField	*connectionStatus;
	IBOutlet NSProgressIndicator		*connectionProgress;
	
	NSString				*selectedPort;
	
}

- (IBAction)serialPortSelectionDidChanged:(id)sender;

@end
