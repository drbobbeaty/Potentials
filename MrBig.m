//
//  MrBig.m
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 21 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// RCS Identification information
static char *rcsID = "$Id: MrBig.m,v 1.1 2008/08/07 20:32:58 drbob Exp $";
static void __AvoidCompilerWarning(void) { if(!rcsID)__AvoidCompilerWarning(); }

// Apple Headers

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "MrBig.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


@implementation MrBig
/*"
**	This class is the main controller for this application. It's where
**	we deal most directly with the starting, stopping, etc. of the app
**	as well as funneling information between the model objects and then
**	presenting the user with something to see. It's got a lot going on,
**	but then again, that's what happens in app controllers.
"*/

//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

+ (void) initialize
/*"
**	This method is called when the class is initialized and we're
**	going to take this opportunity to make sure that if no defaults
**	exist for this user, we're going to make them and save them so
**	that the later parts of the code that depend on them will not
**	run into the problem of them not being there.
"*/
{
	/*
	 * Because it's possible that subclasses will implement this
	 * method as well, we need to make sure that we're only doing
	 * the initialization for *this* class and not all other
	 * subclasses.
	 */
	if (self == [MrBig class]) {
        /* put initialization code here */
    }
}


//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

- (void) setWorkspace:(SimWorkspace*)ws
/*"
**	This method sets the workspace that will be used for subsequent sims
**	of the objects in the associated factory's inventory. The two pieces
**	need to work together through this controller to get the job done.
"*/
{
	if (_workspace != ws) {
		[_workspace release];
		_workspace = [ws retain];
	}
}


- (SimWorkspace*) getWorkspace
/*"
**	This method returns the workspace that is used for subsequent sims
**	of the objects in the associated factory's inventory. The two pieces
**	need to work together through this controller to get the job done.
"*/
{
	return _workspace;
}


- (void) setFactory:(SimObjFactory*)factory
/*"
**	This method sets the factory to the supplied value. The factory not
**	only converts the input source to simulation objects, it also
**	inventories them so that we can apply them to the workspace.
"*/
{
	if (_factory != factory) {
		[_factory release];
		_factory = [factory retain];
	}
}


- (SimObjFactory*) getFactory
/*"
**	This method sets the factory to the supplied value. The factory not
**	only converts the input source to simulation objects, it also
**	inventories them so that we can apply them to the workspace.
"*/
{
	return _factory;
}


- (void) setSrcFileName:(NSTextField*)field
/*"
**	This method sets the NSTextField that will be used in the application
**	to get the source file name from the user. This method will almost
**	certainly never get called as the connection is established in
**	InterfaceBuilder, but for the sake of completness, here it is.
"*/
{
	if (_srcFileName != field) {
		[_srcFileName release];
		_srcFileName = [field retain];
	}
}


- (NSTextField*) getSrcFileName
/*"
**	This method returns the NSTextField that will contain the file name
**	of the source data for this application. The user will enter this in
**	some manner and then we'll use it in the app to know what to read
**	from.
"*/
{
	return _srcFileName;
}


- (void) setProgressBar:(NSProgressIndicator*)bar
/*"
**	This method sets the NSProgressIndicator that will be used in the
**	application to let the user know that the simulation is running and
**	not to panic. This method will almost certainly never get called as
**	the connection is established in InterfaceBuilder, but for the sake
**	of completness, here it is.
"*/
{
	if (_progressBar != bar) {
		[_progressBar release];
		_progressBar = [bar retain];
	}
}


- (NSProgressIndicator*) getProgressBar
/*"
**	This method returns the NSProgressIndicator that will be used in the
**	application to let the user know that the simulation is running and
**	not to panic.
"*/
{
	return _progressBar;
}


- (void) setStatusLine:(NSTextField*)field
/*"
**	This method sets the NSTextField that will be used in the application
**	to let the user know what's basically going on in the app. The log
**	window will have the details, but this little status line is just for
**	the general state of things. This method will almost certainly never
**	get called as the connection is established in InterfaceBuilder, but
**	for the sake of completness, here it is.
"*/
{
	if (_statusLine != field) {
		[_statusLine release];
		_statusLine = [field retain];
	}
}


- (NSTextField*) getStatusLine
/*"
**	This method returns the NSTextField that will be used in the application
**	to let the user know what's basically going on in the app. The log
**	window will have the details, but this little status line is just for
**	the general state of things.
"*/
{
	return _statusLine;
}


- (void) setLogView:(NSTextView*)view
/*"
**	This method sets the NSTextView that will be used in the application
**	to send detailedd log messages to the user during the run. This method
**	will almost certainly never get called as the connection is established
**	in InterfaceBuilder, but for the sake of completness, here it is.
"*/
{
	if (_logView != view) {
		[_logView release];
		_logView = [view retain];
	}
}


- (NSTextView*) getLogView
/*"
**	This method returns the NSTextView that will be used in the application
**	to send detailedd log messages to the user during the run.
"*/
{
	return _logView;
}


//----------------------------------------------------------------------------
//               IB Actions
//----------------------------------------------------------------------------

- (void) loadFromFile:(id)sender
/*"
**	This method is called most often by the user clicking on a button on
**	the UI to indicate that he's put in the filename to load and use. So
**	what we want to do is to load this file up... set up the workspace
**	and all the simulation objects based on this file and then fire off
**	the simulation with a call to -runSim:. It's very much the all-in-one
**	method but that's OK - if I need to later I can split it up.
"*/
{
	BOOL		error = NO;
	NSString*	filename = nil;
	NSArray*	lines = nil;
	
	// first, turn on the "busy bar" though we don't know how long it'll be
	[[self getProgressBar] startAnimation:self];
	// ...and change the status line to something useful
	[self showStatus:@"Loading the file"];

	/*
	 * Next, get the file that we're going to use as an NSArray of NSStrings
	 */
	if (!error) {
		filename = [[self getSrcFileName] stringValue];
		if (filename == nil) {
			error = YES;
			NSLog(@"[MrBig -loadFromFile:] - there is no file specified in the proper location of the UI. Please make sure that there is a file and it's available for reading before trying to load it.");
		} else {
			NSString*	contents = [NSString stringWithContentsOfFile:filename];
			if (contents == nil) {
				error = YES;
				NSLog(@"[MrBig -loadFromFile:] - the file specified in the UI: '%@' could not be read into an NSString. Please make sure that there is a file and it's available for reading before trying to load it.", filename);
			} else {
				lines = [contents componentsSeparatedByString:@"\n"];
				if (lines == nil) {
					error = YES;
					NSLog(@"[MrBig -loadFromFile:] - the file specified in the UI: '%@' could not be parsed into a series of lines. Please make sure that there is a file and it's available for reading before trying to load it.", filename);
				}
			}
		}
	}

	/*
	 * For each line in the array, see if it's a comment, if so skip it.
	 * If it starts with "WS" then it's the SimWorkspace definition line
	 * and we need to build a new workspace based on what it says. If it's
	 * anything else, pass it to the Factory for it to process.
	 */
	if (!error) {
		NSString*		line = nil;
		NSEnumerator*	enumerator = [lines objectEnumerator];
		if (enumerator != nil) {
			while (line = [enumerator nextObject]) {
				// see if it starts with a '#' - a comment
				if ([line hasPrefix:@"#"] || ([line length] == 0)) {
					// go back and get another line
					continue;
				}

				// see if it starts with 'WS' - a workspace command
				if ([line hasPrefix:@"WS"]) {
					SimWorkspace*		ws = [self createWorkspace:line];
					if (ws == nil) {
						error = YES;
						NSLog(@"[MrBig -loadFromFile:] - the line in the file : '%@' was supposed to construct a workspace, but it failed. Please check the logs for the possible cause: '%@'", filename, line);
					} else {
						// save this guy for our use later
						[self setWorkspace:ws];
					}

					// go back and get another line
					continue;
				}

				// everything else goes to the Factory
				if ([[self getFactory] createSimObjWithString:line] == nil) {
					error = YES;
					NSLog(@"[MrBig -loadFromFile:] - the line in the file : '%@' could not be parsed into simulation object. Please make sure that the format is correct: '%@'", filename, line);
				}
			}
		}
	}

	// for simplicity sake, run this simulation now
	if (!error) {
		[self runSim:sender];
	}

	// turn off the "busy bar"
	[[self getProgressBar] stopAnimation:self];
	// ...and change the status line to something useful
	[self showStatus:@"Done"];
}


- (void) runSim:(id)sender
/*"
**	This method runs the simulation for the workspace and factory provided.
**	It is assumed that the factory has all the simulation objects that it
**	needs to do the job and so I won't have to do much before getting right
**	to it.
"*/
{
	BOOL				error = NO;
	SimWorkspace*		ws = nil;
	SimObjFactory*		factory = nil;

	// first, make sure we have a workspace and a factory to use
	if (!error) {
		ws = [self getWorkspace]; 
		if (ws == nil) {
			error = YES;
			NSLog(@"[MrBig -runSim:] - there is no defined workspace with which to run this simulation. Please make sure there is before calling this method.");
		}
	}
	if (!error) {
		factory = [self getFactory];
		if (factory == nil) {
			error = YES;
			NSLog(@"[MrBig -runSim:] - there is no defined factory with which to run this simulation. Please make sure there is before calling this method.");
		}
	}

	// change the status line to something useful
	[self showStatus:@"Adding objects to workspace"];

	// now add all the factory's objects to the workspace
	if (!error) {
		BaseSimObj*		obj = nil;
		NSEnumerator*	enumerator = [[factory getInventory] objectEnumerator];
		if (enumerator != nil) {
			while (obj = [enumerator nextObject]) {
				// everything goes to the Workspace
				if (![obj addToWorkspace:ws]) {
					NSLog(@"[MrBig -runSim:] - the simulation object could not be added to the workspace. This is a serious problem and look to the logs for a possible cause.");
				}
			}
		}
	}

	// change the status line to something useful
	[self showStatus:@"Simulating workspace"];

	// now run the simulation on the workspace
	if (!error) {
		if (![ws simulateWorkspace]) {
			error = YES;
			NSLog(@"[MrBig -runSim:] - the workspace could not properly be simulated. Please check the logs for a possible cause.");
		}
	}

	// to make things simple, output the results of the simulation
	if (!error) {
		[self writeOutResults:(NSString*)[[[self getSrcFileName] stringValue] stringByAppendingString:@".ans"]];
	}

	// change the status line to something useful
	[self showStatus:@"Done with simulation"];
}


//----------------------------------------------------------------------------
//               General Housekeeping
//----------------------------------------------------------------------------

- (void) awakeFromNib
/*"
**	There are a lot of housekeeping things that I need to do when I
**	first start up. The first thing I need to do is to load up the
**	user preferences and then use them to modify the settings from the
**	defaults.
"*/
{
	// set the progress indicator to the 'circular' style
	[[self getProgressBar] setStyle:NSProgressIndicatorSpinningStyle];
	[[self getProgressBar] setDisplayedWhenStopped:NO];

	// Set the status to a simple 'Ready'
	[self showStatus:@"Ready"];

	// Clear out the log message area
	[self clearLog];
}


//----------------------------------------------------------------------------
//               NSWindow Delegate Methods
//----------------------------------------------------------------------------

- (void) windowWillClose:(NSNotification*)aNotification
/*"
**	This method is called by the main window when it's about to get
**	closed. This means it's time for us to save out the existing
**	structure of the window to the defaults so that it can be read
**	in again when next the user needs a window.
"*/
{

}


//----------------------------------------------------------------------------
//               NSApplication Delegate Methods
//----------------------------------------------------------------------------

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication
/*"
**	When the last window closes on this app, we need to quit as it's just
**	plain time to go. This is done here as we are the application's
**	delegate and this is expected of us. Nice NSApplication class...
"*/
{
	return YES;
}


//----------------------------------------------------------------------------
//               Convenience UI Methods
//----------------------------------------------------------------------------

- (void) showStatus:(NSString*)status
/*"
**	This method is a simple conveneient way to set the text on the status
**	line to a nice value.
"*/
{
	[[self getStatusLine] setStringValue:status];
	NSLog(status);
}


- (void) clearLog
/*"
**	This method clears out the NSTextView that holds all the log messages.
**	This is nice for the user when they've been doing a lot and they want
**	to clear it out before they do something else.
"*/
{
	[[self getLogView] setString:@""];
}


- (void) log:(NSString*)line;
/*"
**	This method adds the provided line to the end of the NSTextView that
**	displays all the log messages for this application. There's nothing
**	special about what this does other than to make it look no different
**	from general log messages.
"*/
{
	[[self getLogView] setString:[[[self getLogView] string] stringByAppendingString:line]];
}


//----------------------------------------------------------------------------
//               Actions Helper Methods
//----------------------------------------------------------------------------

- (SimWorkspace*) createWorkspace:(NSString*)line
/*"
**	This method takes the line from the input source that has the form:
**
**		WS <x> <y> <width> <height> <rows> <cols>
**
**	and returns a fully functional workspace based on these parameters. If
**	the data is not there or in error, this method will return nil. If
**	it is successful, then the SimWorkspace returned will be autoreleased
**	so if you want to keep it you had better -retain it.
"*/
{
	BOOL				error = NO;
	SimWorkspace*		retval = nil;
	float				x = -1.0;
	float				y = -1.0;
	float				width = -1.0;
	float				height = -1.0;
	int					rows = -1;
	int					cols = -1;

	// first, see if we have anything to do
	if (!error) {
		if (line == nil) {
			error = YES;
			NSLog(@"[MrBig -createWorkspace:] - the passed-in line is nil and that means that I can't possibly create a workspace object from this. Please make sure that the arguments to this method are not nil before calling.");
		}
	}

	// next, make sure it starts with "WS"
	if (!error) {
		if (![line hasPrefix:@"WS"]) {
			error = YES;
			NSLog(@"[MrBig -createWorkspace:] - the line: '%@' was supposed to construct a SimWorkspace object but the line didn't start with 'WS' as it was supposed to. Please correct this formatting error, or pass in only lines that define workspace objects.", line);
		}
	}

	// now create a scanner and get all the values we're looking for
	if (!error) {
		NSString*		args = [line substringFromIndex:2];
		if (args == nil) {
			error = YES;
			NSLog(@"[MrBig -createWorkspace:] - the substring for the line: '%@' consisting of just the arguments to the 'WS' directive could not be made. This is a serious problem.", line);
		} else {
			NSScanner*	scanner = [NSScanner scannerWithString:args];
			if (scanner == nil) {
				error = YES;
				NSLog(@"[MrBig -createWorkspace:] - the scanner for the arguments: '%@' could not be made. This is a serious problem.", args);
			} else {
				// pick them off one by one
				if (!error && ![scanner scanFloat:&x]) {
					error = YES;
					NSLog(@"[MrBig -createWorkspace:] - the value of 'x' could not be read from the scanner for the arguments: '%@'. This is a serious formatting problem and it needs to be addressed.", args);
				}

				if (!error && ![scanner scanFloat:&y]) {
					error = YES;
					NSLog(@"[MrBig -createWorkspace:] - the value of 'y' could not be read from the scanner for the arguments: '%@'. This is a serious formatting problem and it needs to be addressed.", args);
				}

				if (!error && ![scanner scanFloat:&width]) {
					error = YES;
					NSLog(@"[MrBig -createWorkspace:] - the value of 'width' could not be read from the scanner for the arguments: '%@'. This is a serious formatting problem and it needs to be addressed.", args);
				}

				if (!error && ![scanner scanFloat:&height]) {
					error = YES;
					NSLog(@"[MrBig -createWorkspace:] - the value of 'height' could not be read from the scanner for the arguments: '%@'. This is a serious formatting problem and it needs to be addressed.", args);
				}

				if (!error && ![scanner scanInt:&rows]) {
					error = YES;
					NSLog(@"[MrBig -createWorkspace:] - the value of 'rows' could not be read from the scanner for the arguments: '%@'. This is a serious formatting problem and it needs to be addressed.", args);
				}

				if (!error && ![scanner scanInt:&cols]) {
					error = YES;
					NSLog(@"[MrBig -createWorkspace:] - the value of 'cols' could not be read from the scanner for the arguments: '%@'. This is a serious formatting problem and it needs to be addressed.", args);
				}
			}
		}
	}

	// at this point, if we're OK, try to create the workspace
	if (!error) {
		retval = [[[SimWorkspace alloc] initWithSize:NSMakeSize(width, height) andOrigin:NSMakePoint(x, y) usingRows:rows andCols:cols] autorelease];
	}

	return error ? nil : retval;
}


- (void) writeOutResults:(NSString*)filename
/*"
**	This method writes out the results of the simulation so that the user
**	can plot them, etc. There's nothing special about the format - tab
**	delimited data with column headings in the first row.
"*/
{
	BOOL				error = NO;
	SimWorkspace*		ws = nil;

	// first, make sure we have a filename to use
	if (!error) {
		if (filename == nil) {
			error = YES;
			NSLog(@"[MrBig -writeOutResults:] - the passed-in filename is nil and that means that there's nothing that can be done. Please make sure that the argument to this method is not nil before calling.");
		}
	}

	// now make sure that there's a workspace to output
	if (!error) {
		ws = [self getWorkspace];
		if (ws == nil) {
			error = YES;
			NSLog(@"[MrBig -writeOutResults:] - there is no simulation workspace defined at this time. You need to make sure to load up a simulation workspace by any means and then call this method.");
		}
	}
	// ...and that it's got results to output
	if (!error) {
		if ([ws getResultantVoltage] == nil) {
			error = YES;
			NSLog(@"[MrBig -writeOutResults:] - there are no resultant voltages for the simulation workspace defined at this time. You need to make sure to simulate the workspace by -runSim: and then call this method.");
		}
	}

	// change the status line to something useful
	[self showStatus:@"Writing out results"];

	// let's open up a standard C FILE for this as we don't need anything fancy
	if (!error) {
		FILE	*all = fopen([filename cString], "w");
		FILE	*volt = fopen([[filename stringByAppendingString:@"_v.txt"] cString], "w");
		FILE	*mage = fopen([[filename stringByAppendingString:@"_e.txt"] cString], "w");
		if ((all == NULL) || (volt == NULL) || (mage == NULL)) {
			error = YES;
			NSLog(@"[MrBig -writeOutResults:] - the file: '%@' could not be opened for writing out the results. This is a serious problem that needs to be looked into.", filename);
		} else {
			int		r = 0;
			int		c = 0;
			int		rows = [ws getRowCount];
			int		cols = [ws getColCount];
			float	x = 0.0;
			float	y = 0.0;
			double	v = 0.0;
			double	magE = 0.0;
			double	dirE = 0.0;

			// write out the header for this file
			fprintf(all, "x\ty\tv\tmagE\tdirE\n");
			// ...and this header for the voltage and electric field magnitude
			for (c = 0; c < cols; c++) {
				x = [ws getXValueForCol:c];
				fprintf(volt, "\t%g", x);
				fprintf(mage, "\t%g", x);
			}
			// end the title row with a CRLF and we're ready for data
			fprintf(volt, "\n");
			fprintf(mage, "\n");
			// now let's loop over all the points and write out what we want...
			for (r = (rows-1); r >= 0; r--) {
				for (c = 0; c < cols; c++) {
					// get the location of this node in real-space
					x = [ws getXValueForCol:c];
					y = [ws getYValueForRow:r];

					// now get the results at this node
					v = [ws getResultantVoltageAtNodeRow:r andCol:c];
					magE = [ws getResultantElectricFieldMagnitudeAtNodeRow:r andCol:c];
					dirE = [ws getResultantElectricFieldDirectionAtNodeRow:r andCol:c];

					// write it out
					fprintf(all, "%f\t%f\t%g\t%g\t%g\n", x, y, v, magE, dirE);
					if (c == 0) {
						fprintf(volt, "%g", y);
						fprintf(mage, "%g", y);
					}
					fprintf(volt, "\t%g", v);
					fprintf(mage, "\t%g", magE);
				}
				// for these two, end the line of data now and be ready for the next
				fprintf(volt, "\n");
				fprintf(mage, "\n");
			}

			// close out the file as we're done.
			fclose(all);
			fclose(volt);
			fclose(mage);
		}
	}
}


//----------------------------------------------------------------------------
//               NSObject Overridden Methods
//----------------------------------------------------------------------------

- (void) dealloc
/*"
 **	This method is called then the class is deallocated (freed) and
 **	we need to clean things up. For the most part, this is really
 **	pretty simple, but it can get nasty at times, so we need to be
 **	careful.
 "*/
{
	// drop all the memory we're using
	[self setWorkspace:nil];
	// ...and don't forget to call the super's dealloc too...
	[super dealloc];
}


@end