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
#import "BaseSimObj.h";
#import "SimWorkspace.h";
#import "SimObjFactory.h";

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


@interface MrBig : NSObject {
#if IB_WAS_SMARTER
	id				workspace;
	id				factory;
	id				srcFileName;
	id				progressBar;
	id				statusLine;
	id				logField;
#endif

	@private
	SimWorkspace*			_workspace;
	SimObjFactory*			_factory;
	NSTextField*			_srcFileName;
	NSProgressIndicator*	_progressBar;
	NSTextField*			_statusLine;
	NSTextView*				_logView;
}

/*"				Initialization Methods				"*/
+ (void) initialize;

/*"       Accessor Methods        "*/
- (void) setWorkspace:(SimWorkspace*)ws;
- (SimWorkspace*) getWorkspace;
- (void) setFactory:(SimObjFactory*)factory;
- (SimObjFactory*) getFactory;
- (void) setSrcFileName:(NSTextField*)field;
- (NSTextField*) getSrcFileName;
- (void) setProgressBar:(NSProgressIndicator*)bar;
- (NSProgressIndicator*) getProgressBar;
- (void) setStatusLine:(NSTextField*)field;
- (NSTextField*) getStatusLine;
- (void) setLogView:(NSTextView*)view;
- (NSTextView*) getLogView;

/*"				IB Actions							"*/
- (void) loadFromFile:(id)sender;
- (void) runSim:(id)sender;

/*"				General Housekeeping		"*/
- (void) awakeFromNib;

/*"				NSWindow Delegate Methods				"*/
- (void) windowWillClose:(NSNotification*)aNotification;

/*"				NSApplication Delegate Methods				"*/
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication;

/*"				Convenience UI Methods         	"*/
- (void) showStatus:(NSString*)status;
- (void) clearLog;
- (void) log:(NSString*)line;

/*"				Actions Helper Methods         	"*/
- (SimWorkspace*) createWorkspace:(NSString*)line;
- (void) writeOutResults:(NSString*)filename;

/*"              NSObject Overridden Methods      "*/
- (void) dealloc;

@end
