//
//  MrBig.m
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 21 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

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


/*!
 @class MrBig
 This class is my main app controller - every app has to have one, and this
 is mine. We're going to have all the IB Outlets/Actions so that we can play
 nice in the AppKit world, and then when we're asked to do something, we'll
 hop to it and get it all done.
 */
@implementation MrBig

//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method is called when the class is initialized and we're
 going to take this opportunity to make sure that if no defaults
 exist for this user, we're going to make them and save them so
 that the later parts of the code that depend on them will not
 run into the problem of them not being there.
 */
+ (void) initialize
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

/*!
 This method sets the factory to the supplied value. The factory not
 only converts the input source to simulation objects, it also
 inventories them so that we can apply them to the workspace.
 */
- (void) setFactory:(SimObjFactory*)factory
{
	if (_factory != factory) {
		[_factory release];
		_factory = [factory retain];
	}
}


/*!
 This method sets the factory to the supplied value. The factory not
 only converts the input source to simulation objects, it also
 inventories them so that we can apply them to the workspace.
 */
- (SimObjFactory*) getFactory
{
	return _factory;
}


/*!
 This method sets the NSProgressIndicator that will be used in the
 application to let the user know that the simulation is running and
 not to panic. This method will almost certainly never get called as
 the connection is established in InterfaceBuilder, but for the sake
 of completness, here it is.
 */
- (void) setProgressBar:(NSProgressIndicator*)bar
{
	if (_progressBar != bar) {
		[_progressBar release];
		_progressBar = [bar retain];
	}
}


/*!
 This method returns the NSProgressIndicator that will be used in the
 application to let the user know that the simulation is running and
 not to panic.
 */
- (NSProgressIndicator*) getProgressBar
{
	return _progressBar;
}


/*!
 This method sets the NSTextField that will be used in the application
 to let the user know what's basically going on in the app. The log
 window will have the details, but this little status line is just for
 the general state of things. This method will almost certainly never
 get called as the connection is established in InterfaceBuilder, but
 for the sake of completness, here it is.
 */
- (void) setStatusLine:(NSTextField*)field
{
	if (_statusLine != field) {
		[_statusLine release];
		_statusLine = [field retain];
	}
}


/*!
 This method returns the NSTextField that will be used in the application
 to let the user know what's basically going on in the app. The log
 window will have the details, but this little status line is just for
 the general state of things.
 */
- (NSTextField*) getStatusLine
{
	return _statusLine;
}


/*!
 This method sets the NSScrollView that will be used in the application
 to allow the user to modify the source for the simulation. This method
 will almost certainly never get called as the connection is established
 in InterfaceBuilder, but for the sake of completness, here it is.
 */
- (void) setContentView:(NSScrollView*)view
{
	if (_contentView != view) {
		[_contentView release];
		_contentView = [view retain];
	}
}


/*!
 This method returns the NSScrollView that will be used in the application
 to allow the user to modify the source for the simulation.
 */
- (NSScrollView*) getContentView
{
	return _contentView;
}


/*!
 This method returns the NSTextView that contains the content of the
 simulation source for viewing/creating/editing.
 */
- (NSTextView*) getContentText
{
	return [[self getContentView] documentView];
}


/*!
 This method sets the workspace that will be used for subsequent sims
 of the objects in the associated factory's inventory. The two pieces
 need to work together through this controller to get the job done.
 */
- (void) setWorkspace:(SimWorkspace*)ws
{
	if (_workspace != ws) {
		[_workspace release];
		_workspace = [ws retain];
	}
}


/*!
 This method returns the workspace that is used for subsequent sims
 of the objects in the associated factory's inventory. The two pieces
 need to work together through this controller to get the job done.
 */
- (SimWorkspace*) getWorkspace
{
	return _workspace;
}


/*!
 This method sets the name of the file that's currently being worked
 on in the 'contentView'. This is important because we need to know
 where it came from to save changes and to write the output.
 */
- (void) setSrcFileName:(NSString*)name
{
	if (_srcFileName != name) {
		[_srcFileName release];
		_srcFileName = [name retain];
	}
}


/*!
 This method returns the name of the file whose contents are in the
 'contentView' where it's available to be edited, and then run. When
 it's run we'll use this method to see where to put the output files.
 */
- (NSString*) getSrcFileName
{
	return _srcFileName;
}


//----------------------------------------------------------------------------
//               IB Actions
//----------------------------------------------------------------------------

/*!
 This method is called most often by the user initiating a load from the
 filesystem for a simulation definition. We need to load it up and place
 it in the 'contentView' so that it can be edited, or simulated. As the
 user sees fit.
 */
- (void) loadFromFile:(id)sender
{
	BOOL		error = NO;
	
	// Create the File Open Dialog class.
	NSOpenPanel*	openDlg = nil;
	if (!error) {
		openDlg = [NSOpenPanel openPanel];
		if (openDlg == nil) {
			error = YES;
			NSLog(@"[MrBig -loadFromFile:] - I could not create an NSOpenPanel for asking the user what file to load. Please check on this as soon as possible.");
		} else {
			/*
			 * Set up the default config for the dialog:
			 * - choose files, and directories to get to the file
			 * - select only one file.
			 */
			[openDlg setCanChooseFiles:YES];
			[openDlg setCanChooseDirectories:YES];
			[openDlg setAllowsMultipleSelection:NO];
		}
	}
	
	/*
	 * Display the dialog.  If the OK button was pressed,
	 * process the files.
	 */
	if (!error) {
		if ([openDlg runModal] == NSOKButton) {
			/*
			 * Get an array containing the full filenames of all
			 * files and directories selected.
			 */
			NSArray*	urls = [openDlg URLs];
			if ((urls != nil) && ([urls count] > 0)) {
				[self setSrcFileName:[urls objectAtIndex:0]];
			} else {
				// no file names to use, can't do a thing
				error = true;
				NSLog(@"[MrBig -loadFromFile:] - the Open Dialog indicated that there was something to do, but there was no filename available. This is something to look into.");
			}
		} else {
			// we have no filename selected, so do nothing else
			error = true;
		}
	}

	// turn on the "spinning wheel and update the status if we have a file
	if (!error) {
		// first, turn on the "busy bar" though we don't know how long it'll be
		[[self getProgressBar] startAnimation:self];
		// ...and change the status line to something useful
		[self showStatus:@"Loading the file"];
	}

	/*
	 * Next, get the file that we're going to use and load it up
	 */
	if (!error) {
		if ([self getSrcFileName] == nil) {
			error = YES;
			NSLog(@"[MrBig -loadFromFile:] - there is no file specified in the proper location of the UI. Please make sure that there is a file and it's available for reading before trying to load it.");
		} else {
			NSString*	contents = [NSString stringWithContentsOfFile:[self getSrcFileName] encoding:NSUTF8StringEncoding error:NULL];
			if (contents == nil) {
				error = YES;
				NSLog(@"[MrBig -loadFromFile:] - the file specified in the UI: '%@' could not be read into an NSString. Please make sure that there is a file and it's available for reading before trying to load it.", [self getSrcFileName]);
			} else {
				// save it to the content view
				[[self getContentText] setString:contents];
			}
		}
	}

	// turn off the "busy bar"
	[[self getProgressBar] stopAnimation:self];
	if (!error) {
		// ...and change the status line to something useful
		[self showStatus:@"Loaded"];
	}
}


/*!
 This method is called when the user wants to save the existing file in
 the 'contentView' to the file already loaded - basically, saving it on
 top of itself. Standard stuff.
 */
- (IBAction) saveToFile:(id)sender
{
	BOOL		error = NO;
	
	// first, turn on the "busy bar" though we don't know how long it'll be
	[[self getProgressBar] startAnimation:self];
	// ...and change the status line to something useful
	[self showStatus:@"Saving the file"];
	
	/*
	 * Next, get the file that we're going to use for saving all this
	 */
	if (!error) {
		if ([self getSrcFileName] == nil) {
			// nothing? then make the user pick the name
			[self saveAsToFile:sender];
		} else {
			if (![[[self getContentText] string] writeToFile:[self getSrcFileName] atomically:YES encoding:NSUTF8StringEncoding error:NULL]) {
				error = YES;
				NSLog(@"[MrBig -saveToFile:] - the file '%@'could not be written to. Please check on permissions.", [self getSrcFileName]);
				// show a decent status to let the user know the issue
				[self showStatus:@"Could not save file - check space/perms"];
			} else {
				// show a decent status to let the user know it's OK
				[self showStatus:@"Saved"];
			}
		}
	}
	
	// turn off the "busy bar"
	[[self getProgressBar] stopAnimation:self];
}


/*!
 This method is called when there's no existing filename for the simulation
 we have loaded into the active workspace. In this case, we need to have the
 user give us a filename to use and then create the file.
 */
- (IBAction) saveAsToFile:(id)sender
{
	BOOL		error = NO;
	
	// Create the File Save Dialog class.
	NSSavePanel*	saveDlg = nil;
	if (!error) {
		saveDlg = [NSSavePanel savePanel];
		if (saveDlg == nil) {
			error = YES;
			NSLog(@"[MrBig -saveAsToFile:] - I could not create an NSSavePanel for asking the user what file to save this as. Please check on this as soon as possible.");
		} else {
			// set the save dialog to use '.pot' files
			[saveDlg setAllowedFileTypes:[NSArray arrayWithObject:@"pot"]];
		}
	}
	
	/*
	 * Display the dialog.  If the OK button was pressed,
	 * read the file name and use it.
	 */
	if (!error) {
		if ([saveDlg runModal] == NSOKButton) {
			[self setSrcFileName:[[saveDlg URL] absoluteString]];
		} else {
			// we have no filename selected, so do nothing else
			error = true;
		}
	}

	// let the simpler 'save' do the work
	if (!error) {
		[self saveToFile:sender];
	}
}


/*!
 This method clears out all the "stuff" of the current simulation so
 that the user can start a fresh with a new source and then run it
 or not, as they see fit.
 */
- (IBAction) clearSimulation:(id)sender
{
	// clear out the factory of all instruments
	[[self getFactory] removeAllInventory];
	[self setWorkspace:nil];
	// clear out the content and it's filename
	[[self getContentText] setString:@""];
	[self setSrcFileName:nil];
	// show a decent status to let the user know it's OK
	[self showStatus:@"Ready"];
}


/*!
 This method runs the simulation for the workspace and factory provided.
 It is assumed that the factory has all the simulation objects that it
 needs to do the job and so I won't have to do much before getting right
 to it.
 */
- (void) runSim:(id)sender
{
	BOOL				error = NO;
	SimWorkspace*		ws = nil;

	// first, load up the simulation engine (factory & workspace)
	if (!error) {
		// first, clear out the factory's contents as it sits now
		[[self getFactory] removeAllInventory];
		// ...and now load it up with the current 'content' from the user
		if (![self loadEngine:[[self getContentText] string]]) {
			error = YES;
			NSLog(@"[MrBig -runSim:] - while trying to load up the simulator with the contents of the current document an error occured. This is bad news.");
			// put some reasonable error in the status line
			[self showStatus:@"Parsing error in source"];
		}
	}

	// next, make sure we have a workspace to use
	if (!error) {
		ws = [self getWorkspace]; 
		if (ws == nil) {
			error = YES;
			NSLog(@"[MrBig -runSim:] - there is no defined workspace with which to run this simulation. Please make sure there is before calling this method.");
		}
	}

	// change the status line to something useful
	if (!error) {
		[self showStatus:@"Adding objects to workspace"];
	}

	// now add all the factory's objects to the workspace
	if (!error) {
		BaseSimObj*		obj = nil;
		NSEnumerator*	enumerator = [[[self getFactory] getInventory] objectEnumerator];
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
	if (!error) {
		[self showStatus:@"Simulating workspace"];
	}

	// now run the simulation on the workspace
	if (!error) {
		if (![ws simulateWorkspace]) {
			error = YES;
			NSLog(@"[MrBig -runSim:] - the workspace could not properly be simulated. Please check the logs for a possible cause.");
		}
	}

	// to make things simple, output the results of the simulation
	if (!error) {
		[self writeOutResults:(NSString*)[[[self getSrcFileName] stringByDeletingPathExtension] stringByAppendingString:@".ans"]];
	}

	// change the status line to something useful
	if (!error) {
		[self showStatus:@"Done with simulation"];
	}
}


//----------------------------------------------------------------------------
//               General Housekeeping
//----------------------------------------------------------------------------

/*!
 There are a lot of housekeeping things that I need to do when I
 first start up. The first thing I need to do is to load up the
 user preferences and then use them to modify the settings from the
 defaults.
 */
- (void) awakeFromNib
{
	// this is the font that I want to use with the content pane
	[[self getContentText] setFont:[NSFont fontWithName:@"Consolas" size:10.0]];
	// clear out the content area as we wish it to appear clean
	[[self getContentText] setString:@""];
	
	// Set the status to a simple 'Ready'
	[self showStatus:@"Ready"];
}


//----------------------------------------------------------------------------
//               NSWindow Delegate Methods
//----------------------------------------------------------------------------

/*!
 This method is called by the main window when it's about to get
 closed. This means it's time for us to save out the existing
 structure of the window to the defaults so that it can be read
 in again when next the user needs a window.
 */
- (void) windowWillClose:(NSNotification*)aNotification
{

}


//----------------------------------------------------------------------------
//               NSApplication Delegate Methods
//----------------------------------------------------------------------------

/*!
 When the last window closes on this app, we need to quit as it's just
 plain time to go. This is done here as we are the application's
 delegate and this is expected of us. Nice NSApplication class...
 */
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication
{
	return YES;
}


//----------------------------------------------------------------------------
//               Convenience UI Methods
//----------------------------------------------------------------------------

/*!
 This method is a simple conveneient way to set the text on the status
 line to a nice value.
 */
- (void) showStatus:(NSString*)status
{
	[[self getStatusLine] setStringValue:status];
	NSLog(@"%@", status);
}


//----------------------------------------------------------------------------
//               Actions Helper Methods
//----------------------------------------------------------------------------

/*!
 This method is going to load up the simulation engine with the data
 represented by the string passed in from, say, a file or the content
 that the user is working on. It builds up everything and then returns
 YES if it's all OK.
 */
- (BOOL) loadEngine:(NSString*)source
{
	BOOL		error = NO;

	// break the source string into lines for parsing by the factory
	NSArray*	lines = nil;
	if (!error) {
		if (source == nil) {
			error = YES;
			NSLog(@"[MrBig -loadEngine:] - the specified string is nil and that means that there's nothing I can process. Please make sure there's something to do before calling this method.");
		} else {
			// ...and then break it up into lines for the factory
			lines = [source componentsSeparatedByString:@"\n"];
			if (lines == nil) {
				error = YES;
				NSLog(@"[MrBig -loadEngine:] - the specified string could not be parsed into a series of lines. Please make sure that there is a something there to do before trying to load it.");
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
						NSLog(@"[MrBig -loadEngine:] - the line in the source was supposed to construct a workspace, but it failed. Please check the logs for the possible cause: '%@'", line);
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
					NSLog(@"[MrBig -loadEngine:] - the line in the source could not be parsed into simulation object. Please make sure that the format is correct: '%@'", line);
				}
			}
		}
	}

	return !error;
}


/*!
 This method takes the line from the input source that has the form:
 
 WS <x> <y> <width> <height> <rows> <cols>
 
 and returns a fully functional workspace based on these parameters. If
 the data is not there or in error, this method will return nil. If
 it is successful, then the SimWorkspace returned will be autoreleased
 so if you want to keep it you had better -retain it.
 */
- (SimWorkspace*) createWorkspace:(NSString*)line
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


/*!
 This method writes out the results of the simulation so that the user
 can plot them, etc. There's nothing special about the format - tab
 delimited data with column headings in the first row.
 */
- (void) writeOutResults:(NSString*)filename
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
		FILE	*all = fopen([filename UTF8String], "w");
		FILE	*volt = fopen([[filename stringByAppendingString:@"_v.txt"] UTF8String], "w");
		FILE	*mage = fopen([[filename stringByAppendingString:@"_e.txt"] UTF8String], "w");
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

/*!
 This method is called then the class is deallocated (freed) and
 we need to clean things up. For the most part, this is really
 pretty simple, but it can get nasty at times, so we need to be
 careful.
 */
- (void) dealloc
{
	// drop all the memory we're using
	[self setWorkspace:nil];
	// ...and don't forget to call the super's dealloc too...
	[super dealloc];
}


@end