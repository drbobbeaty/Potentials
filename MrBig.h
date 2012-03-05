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


/*!
 @class MrBig
 This class is my main app controller - every app has to have one, and this
 is mine. We're going to have all the IB Outlets/Actions so that we can play
 nice in the AppKit world, and then when we're asked to do something, we'll
 hop to it and get it all done.
 */
@interface MrBig : NSObject {
	@private
	IBOutlet SimObjFactory*			_factory;
	IBOutlet NSProgressIndicator*	_progressBar;
	IBOutlet NSTextField*			_statusLine;
	IBOutlet NSScrollView*			_contentView;
	SimWorkspace*					_workspace;
	NSURL*							_srcFileName;
}

//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method is called when the class is initialized and we're
 going to take this opportunity to make sure that if no defaults
 exist for this user, we're going to make them and save them so
 that the later parts of the code that depend on them will not
 run into the problem of them not being there.
 */
+ (void) initialize;

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the factory to the supplied value. The factory not
 only converts the input source to simulation objects, it also
 inventories them so that we can apply them to the workspace.
 */
- (void) setFactory:(SimObjFactory*)factory;

/*!
 This method sets the factory to the supplied value. The factory not
 only converts the input source to simulation objects, it also
 inventories them so that we can apply them to the workspace.
 */
- (SimObjFactory*) getFactory;

/*!
 This method sets the NSProgressIndicator that will be used in the
 application to let the user know that the simulation is running and
 not to panic. This method will almost certainly never get called as
 the connection is established in InterfaceBuilder, but for the sake
 of completness, here it is.
 */
- (void) setProgressBar:(NSProgressIndicator*)bar;

/*!
 This method returns the NSProgressIndicator that will be used in the
 application to let the user know that the simulation is running and
 not to panic.
 */
- (NSProgressIndicator*) getProgressBar;

/*!
 This method sets the NSTextField that will be used in the application
 to let the user know what's basically going on in the app. The log
 window will have the details, but this little status line is just for
 the general state of things. This method will almost certainly never
 get called as the connection is established in InterfaceBuilder, but
 for the sake of completness, here it is.
 */
- (void) setStatusLine:(NSTextField*)field;

/*!
 This method returns the NSTextField that will be used in the application
 to let the user know what's basically going on in the app. The log
 window will have the details, but this little status line is just for
 the general state of things.
 */
- (NSTextField*) getStatusLine;

/*!
 This method sets the NSScrollView that will be used in the application
 to allow the user to modify the source for the simulation. This method
 will almost certainly never get called as the connection is established
 in InterfaceBuilder, but for the sake of completness, here it is.
 */
- (void) setContentView:(NSScrollView*)view;

/*!
 This method returns the NSScrollView that will be used in the application
 to allow the user to modify the source for the simulation.
 */
- (NSScrollView*) getContentView;

/*!
 This method returns the NSTextView that contains the content of the
 simulation source for viewing/creating/editing.
 */
- (NSTextView*) getContentText;

/*!
 This method sets the workspace that will be used for subsequent sims
 of the objects in the associated factory's inventory. The two pieces
 need to work together through this controller to get the job done.
 */
- (void) setWorkspace:(SimWorkspace*)ws;

/*!
 This method returns the workspace that is used for subsequent sims
 of the objects in the associated factory's inventory. The two pieces
 need to work together through this controller to get the job done.
 */
- (SimWorkspace*) getWorkspace;

/*!
 This method sets the name of the file that's currently being worked
 on in the 'contentView'. This is important because we need to know
 where it came from to save changes and to write the output.
 */
- (void) setSrcFileName:(NSURL*)name;

/*!
 This method returns the name of the file whose contents are in the
 'contentView' where it's available to be edited, and then run. When
 it's run we'll use this method to see where to put the output files.
 */
- (NSURL*) getSrcFileName;

//----------------------------------------------------------------------------
//					IB Actions
//----------------------------------------------------------------------------

/*!
 This method is called most often by the user initiating a load from the
 filesystem for a simulation definition. We need to load it up and place
 it in the 'contentView' so that it can be edited, or simulated. As the
 user sees fit.
 */
- (IBAction) loadFromFile:(id)sender;

/*!
 This method is called when the user wants to save the existing file in
 the 'contentView' to the file already loaded - basically, saving it on
 top of itself. Standard stuff.
 */
- (IBAction) saveToFile:(id)sender;

/*!
 This method is called when there's no existing filename for the simulation
 we have loaded into the active workspace. In this case, we need to have the
 user give us a filename to use and then create the file.
 */
- (IBAction) saveAsToFile:(id)sender;

/*!
 This method clears out all the "stuff" of the current simulation so
 that the user can start a fresh with a new source and then run it
 or not, as they see fit.
 */
- (IBAction) clearSimulation:(id)sender;

/*!
 This method runs the simulation for the workspace and factory provided.
 It is assumed that the factory has all the simulation objects that it
 needs to do the job and so I won't have to do much before getting right
 to it.
 */
- (IBAction) runSim:(id)sender;

//----------------------------------------------------------------------------
//					General Housekeeping
//----------------------------------------------------------------------------

/*!
 There are a lot of housekeeping things that I need to do when I
 first start up. The first thing I need to do is to load up the
 user preferences and then use them to modify the settings from the
 defaults.
 */
- (void) awakeFromNib;

//----------------------------------------------------------------------------
//					NSWindow Delegate Methods
//----------------------------------------------------------------------------

/*!
 This method is called by the main window when it's about to get
 closed. This means it's time for us to save out the existing
 structure of the window to the defaults so that it can be read
 in again when next the user needs a window.
 */
- (void) windowWillClose:(NSNotification*)aNotification;

//----------------------------------------------------------------------------
//					NSApplication Delegate Methods
//----------------------------------------------------------------------------

/*!
 When the last window closes on this app, we need to quit as it's just
 plain time to go. This is done here as we are the application's
 delegate and this is expected of us. Nice NSApplication class...
 */
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication;

//----------------------------------------------------------------------------
//					Convenience UI Methods
//----------------------------------------------------------------------------

/*!
 This method is a simple conveneient way to set the text on the status
 line to a nice value.
 */
- (void) showStatus:(NSString*)status;

//----------------------------------------------------------------------------
//					Actions Helper Methods
//----------------------------------------------------------------------------

/*!
 This method is going to load up the simulation engine with the data
 represented by the string passed in from, say, a file or the content
 that the user is working on. It builds up everything and then returns
 YES if it's all OK.
 */
- (BOOL) loadEngine:(NSString*)source;

/*!
 This method takes the line from the input source that has the form:
 
     WS <x> <y> <width> <height> <rows> <cols>
 
 and returns a fully functional workspace based on these parameters. If
 the data is not there or in error, this method will return nil. If
 it is successful, then the SimWorkspace returned will be autoreleased
 so if you want to keep it you had better -retain it.
 */
- (SimWorkspace*) createWorkspace:(NSString*)line;

/*!
 This method writes out the results of the simulation so that the user
 can plot them, etc. There's nothing special about the format - tab
 delimited data with column headings in the first row.
 */
- (void) writeOutResults:(NSURL*)filename;

//----------------------------------------------------------------------------
//					NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method is called then the class is deallocated (freed) and
 we need to clean things up. For the most part, this is really
 pretty simple, but it can get nasty at times, so we need to be
 careful.
 */
- (void) dealloc;

@end
