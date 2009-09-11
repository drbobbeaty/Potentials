//
//  MrBig.h
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 21 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers
#import <Foundation/Foundation.h>

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "BaseSimObj.h"
#import "SimWorkspace.h"
#import "SimObjFactory.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


@interface MrBig : NSObject {
	@private
	IBOutlet SimObjFactory*			_factory;
	IBOutlet NSProgressIndicator*	_progressBar;
	IBOutlet NSTextField*			_statusLine;
	IBOutlet NSScrollView*			_contentView;
	SimWorkspace*					_workspace;
	NSString*						_srcFileName;
}

/*"				Initialization Methods				"*/
+ (void) initialize;

/*"       Accessor Methods        "*/
- (void) setFactory:(SimObjFactory*)factory;
- (SimObjFactory*) getFactory;
- (void) setProgressBar:(NSProgressIndicator*)bar;
- (NSProgressIndicator*) getProgressBar;
- (void) setStatusLine:(NSTextField*)field;
- (NSTextField*) getStatusLine;
- (void) setContentView:(NSScrollView*)view;
- (NSScrollView*) getContentView;
- (NSTextView*) getContentText;
- (void) setWorkspace:(SimWorkspace*)ws;
- (SimWorkspace*) getWorkspace;
- (void) setSrcFileName:(NSString*)name;
- (NSString*) getSrcFileName;

/*"				IB Actions							"*/
- (IBAction) loadFromFile:(id)sender;
- (IBAction) saveToFile:(id)sender;
- (IBAction) saveAsToFile:(id)sender;
- (IBAction) clearSimulation:(id)sender;
- (IBAction) runSim:(id)sender;

/*"				General Housekeeping		"*/
- (void) awakeFromNib;

/*"				NSWindow Delegate Methods				"*/
- (void) windowWillClose:(NSNotification*)aNotification;

/*"				NSApplication Delegate Methods				"*/
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication;

/*"				Convenience UI Methods         	"*/
- (void) showStatus:(NSString*)status;

/*"				Actions Helper Methods         	"*/
- (BOOL) loadEngine:(NSString*)source;
- (SimWorkspace*) createWorkspace:(NSString*)line;
- (void) writeOutResults:(NSString*)filename;

/*"              NSObject Overridden Methods      "*/
- (void) dealloc;

@end
