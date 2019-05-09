//
//  SimObjFactory.m
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
#import "SimObjFactory.h"
#import "BaseSimObj.h"
#import "CircularSimObj.h"
#import "RectangularSimObj.h"
#import "PointSimObj.h"
#import "LineSimObj.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class SimObjFactory
 This class creates and inventories all the simulation objects that
 will be in-play at any time. This is basically the model generation
 and storage for the application. Nice and clean with the appropriate
 parsers in the right places to take text and convert it into usable
 simulation objects.
 */
@implementation SimObjFactory

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method assigns the passed-in array to be the main storage depot
 of the simulation objects that are currently in use. This inventory
 will be added to by the constructor methods on this class. Of course,
 the user is free to create new objects and add them to this inventory
 (or remove them, if needed) - it's just a convenient place to hold
 what's considered to be important at this time.
 */
- (void) setInventory:(NSMutableArray*)array
{
	if (_inventory != array) {
		[_inventory release];
		_inventory = [array retain];
	}
}


/*!
 This method returns the array of simulation objects that are currently
 considered 'important' to the simulation. This can be used to operate
 on them all - as in placing them on the workspace, or other housekeeping
 tasks.
 */
- (NSMutableArray*) getInventory
{
	return _inventory;
}


/*!
 This method adds the provided simulation object to the inventory of
 all simulation objects that will be active. This is important as it's
 most likely the case that these active objects will be the ones that
 are placed on the workspace for simulation.
 */
- (BOOL) addToInventory:(BaseSimObj*)simObj
{
	BOOL			error = NO;

	// see if there's anything to do
	if (!error) {
		if (simObj == nil) {
			error = YES;
			NSLog(@"[SimObjFactory -addToInventory:] - the passed-in simulation object is nil and that really means that there's nothing for me to do. Please make sure the argument to this method is not nil before calling.");
		}
	}

	// see if there's any place to put this guy
	if (!error) {
		if ([self getInventory] == nil) {
			error = YES;
			NSLog(@"[SimObjFactory -addToInventory:] - the master storage of all simulation objects has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
		} else {
			// add him if things are OK to this point
			[[self getInventory] addObject:simObj];
		}
	}

	return !error;
}


/*!
 This method removes the provided simulation object to the inventory of
 all simulation objects that will be active. This is important as it's
 most likely the case that these active objects will be the ones that
 are placed on the workspace for simulation.
 */
- (BOOL) removeFromInventory:(BaseSimObj*)simObj
{
	BOOL			error = NO;

	// see if there's anything to do
	if (!error) {
		if (simObj == nil) {
			error = YES;
			NSLog(@"[SimObjFactory -removeFromInventory:] - the passed-in simulation object is nil and that really means that there's nothing for me to do. Please make sure the argument to this method is not nil before calling.");
		}
	}

	// see if there's any place to yank this guy from
	if (!error) {
		if ([self getInventory] == nil) {
			error = YES;
			NSLog(@"[SimObjFactory -removeFromInventory:] - the master storage of all simulation objects has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
		} else {
			// remove him if things are OK to this point
			[[self getInventory] removeObject:simObj];
		}
	}

	return !error;
}


/*!
 This method removes all the simulation objects from the inventory of
 simulation objects that will be active. This is important as it's
 most likely the case that these active objects will be the ones that
 are placed on the workspace for simulation, and by doing this we're
 essentially clearing out all the current objects and starting fresh.
 */
- (void) removeAllInventory
{
	if ([self getInventory] == nil) {
		NSLog(@"[SimObjFactory -removeAllInventory] - the master storage of all simulation objects has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
	} else {
		// remove everything in the array now
		[[self getInventory] removeAllObjects];
	}
}


//----------------------------------------------------------------------------
//               NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method does the super's -init as well as making sure we have
 a place tp put all the simulation objects that we're going to be
 creating and manipulating.
 */
- (id) init
{
	if (self = [super init]) {
		NSMutableArray*		a = [[[NSMutableArray alloc] init] autorelease];
		if (a == nil) {
			NSLog(@"[SimObjFactory -init] - the storage for all the simulation objects that will be created could not be created. This is a serious allocation error and needs to be looked into as soon as possible.");
		} else {
			[self setInventory:a];
		}
	}
	return self;
}


/*!
 This method is called by the runtime when the released object is about
 to get cleaned up. This gives us an opportunity to clean up all the
 memory we're using at the time and be a good citizen.
 */
- (void) dealloc
{
	// drop all the memory we're using
	[self removeAllInventory];
	// ...and the array that held it
	[self setInventory:nil];
	// ...and don't forget to call the super's dealloc too...
	[super dealloc];
}


//----------------------------------------------------------------------------
//               Sim Object Creators
//----------------------------------------------------------------------------

/*!
 This method is interesting in that the description of a simulation object
 can be contained in a single NSString, and given this data the purpose of
 this guy is to create a functional simulation object and place it in the
 inventory of objects that this factory has created. It's a simple way to
 build up these objects from, say, a text file.
 */
- (BaseSimObj*) createSimObjWithString:(NSString*)line
{
	BOOL			error = NO;
	BaseSimObj*		retval = nil;
	float			x = 0.0;
	float			y = 0.0;
	float			radius = 0.0;
	float			width = 0.0;
	float			height = 0.0;
	float			endX = 0.0;
	float			endY = 0.0;
	double			value = 0.0;

	// first, make sure we have something to do here
	if (!error) {
		if (line == nil) {
			error = YES;
			NSLog(@"[SimObjFactory -createSimObjWithString:] - the passed-in description of a simulation object is null and that means that there's nothing I can do. Please make sure that the argument is not nil before calling.");
		} else if ([line length] == 0) {
			error = YES;
			NSLog(@"[SimObjFactory -createSimObjWithString:] - the passed-in description of a simulation object is empty and that means that there's nothing I can do. Please make sure that the argument is not nil before calling.");
		}
	}

	// make a scanner for the args that we'll be picking off
	NSScanner*	scanner = nil;
	if (!error) {
		NSString*		args = [line substringFromIndex:2];
		if (args == nil) {
			error = YES;
			NSLog(@"[SimObjFactory -createSimObjWithString:] - the substring for the line: '%@' consisting of just the arguments to the type directive could not be made. This is a serious problem.", line);
		} else {
			scanner = [NSScanner scannerWithString:args];
			if (scanner == nil) {
				error = YES;
				NSLog(@"[SimObjFactory -createSimObjWithString:] - the scanner for the arguments: '%@' could not be made. This is a serious problem.", args);
			}
		}
	}

	// now pick off the center of the object as it's the same for all types
	if (!error && ![scanner scanFloat:&x]) {
		error = YES;
		NSLog(@"[SimObjFactory -createSimObjWithString:] - the value of 'x' could not be read from the scanner for the line: '%@'. This is a serious formatting problem and it needs to be addressed.", line);
	}
	if (!error && ![scanner scanFloat:&y]) {
		error = YES;
		NSLog(@"[SimObjFactory -createSimObjWithString:] - the value of 'y' could not be read from the scanner for the line: '%@'. This is a serious formatting problem and it needs to be addressed.", line);
	}

	/*
	 * Now let's see the shape and from that determine what basically to
	 * do. From there, we'll break it down by type and be able to create all
	 * the different kinds of objects.
	 */
	if (!error) {
		if ([line hasPrefix:@"C"]) {
			/*
			 * CIRCLE
			 */
			if (!error && ![scanner scanFloat:&radius]) {
				error = YES;
				NSLog(@"[SimObjFactory -createSimObjWithString:] - the value of 'radius' could not be read from the scanner for the line: '%@'. This is a serious formatting problem and it needs to be addressed.", line);
			}
		} else if ([line hasPrefix:@"R"]) {
			/*
			 * RECTANGLE
			 */
			if (!error && ![scanner scanFloat:&width]) {
				error = YES;
				NSLog(@"[SimObjFactory -createSimObjWithString:] - the value of 'width' could not be read from the scanner for the line: '%@'. This is a serious formatting problem and it needs to be addressed.", line);
			}

			if (!error && ![scanner scanFloat:&height]) {
				error = YES;
				NSLog(@"[SimObjFactory -createSimObjWithString:] - the value of 'height' could not be read from the scanner for the line: '%@'. This is a serious formatting problem and it needs to be addressed.", line);
			}
		} else if ([line hasPrefix:@"L"]) {
			/*
			 * LINE
			 */
			if (!error && ![scanner scanFloat:&endX]) {
				error = YES;
				NSLog(@"[SimObjFactory -createSimObjWithString:] - the value of 'endX' could not be read from the scanner for the line: '%@'. This is a serious formatting problem and it needs to be addressed.", line);
			}

			if (!error && ![scanner scanFloat:&endY]) {
				error = YES;
				NSLog(@"[SimObjFactory -createSimObjWithString:] - the value of 'endY' could not be read from the scanner for the line: '%@'. This is a serious formatting problem and it needs to be addressed.", line);
			}
		} else if ([line hasPrefix:@"P"]) {
			/*
			 * POINT
			 */
			// nothing... it's already all there
		} else {
			// unknown type of simulation object
			error = YES;
			NSLog(@"[SimObjFactory -createSimObjWithString:] - the passed-in description of a simulation object: '%@' is not one that's understood. Please use one of the known simulation objects.", line);
		}
	}

	// now pick off the "value" of the object as it's always there too
	if (!error && ![scanner scanDouble:&value]) {
		error = YES;
		NSLog(@"[SimObjFactory -createSimObjWithString:] - the value of the object's main property (voltage, er, rho) could not be read from the scanner for the line: '%@'. This is a serious formatting problem and it needs to be addressed.", line);
	}

	/*
	 * Now that we have everything parsed from the line we need to build up
	 * the simulation object based on the type and these parsed values
	 */
	if (!error) {
		if ([line hasPrefix:@"CM"]) {
			retval = [[[CircularSimObj alloc] initAsConductorWithVoltage:value at:NSMakePoint(x,y) withRadius:radius] autorelease];
		} else if ([line hasPrefix:@"CD"]) {
			retval = [[[CircularSimObj alloc] initAsDielectricWithEpsilonR:value at:NSMakePoint(x,y) withRadius:radius] autorelease];
		} else if ([line hasPrefix:@"CC"]) {
			retval = [[[CircularSimObj alloc] initAsChargeSheetWithRho:value at:NSMakePoint(x,y) withRadius:radius] autorelease];
		} else if ([line hasPrefix:@"RM"]) {
			retval = [[[RectangularSimObj alloc] initAsConductorWithVoltage:value at:NSMakePoint(x,y) withWidth:width andHeight:height] autorelease];
		} else if ([line hasPrefix:@"RD"]) {
			retval = [[[RectangularSimObj alloc] initAsDielectricWithEpsilonR:value at:NSMakePoint(x,y) withWidth:width andHeight:height] autorelease];
		} else if ([line hasPrefix:@"RC"]) {
			retval = [[[RectangularSimObj alloc] initAsChargeSheetWithRho:value at:NSMakePoint(x,y) withWidth:width andHeight:height] autorelease];
		} else if ([line hasPrefix:@"LM"]) {
			retval = [[[LineSimObj alloc] initAsConductorWithVoltage:value from:NSMakePoint(x,y) to:NSMakePoint(endX,endY)] autorelease];
		} else if ([line hasPrefix:@"LD"]) {
			retval = [[[LineSimObj alloc] initAsDielectricWithEpsilonR:value from:NSMakePoint(x,y) to:NSMakePoint(endX,endY)] autorelease];
		} else if ([line hasPrefix:@"LC"]) {
			retval = [[[LineSimObj alloc] initAsChargeSheetWithRho:value from:NSMakePoint(x,y) to:NSMakePoint(endX,endY)] autorelease];
		} else if ([line hasPrefix:@"PM"]) {
			retval = [[[PointSimObj alloc] initAsConductorWithVoltage:value at:NSMakePoint(x,y)] autorelease];
		} else if ([line hasPrefix:@"PD"]) {
			retval = [[[PointSimObj alloc] initAsDielectricWithEpsilonR:value at:NSMakePoint(x,y)] autorelease];
		} else if ([line hasPrefix:@"PC"]) {
			retval = [[[PointSimObj alloc] initAsChargeSheetWithRho:value at:NSMakePoint(x,y)] autorelease];
		}
		if (retval == nil) {
			error = YES;
			NSLog(@"[SimObjFactory -createSimObjWithString:] - the simulation object described by the line: '%@' could not be created. Please check the logs for a possible cause", line);
		} else {
			// add it to the inventory now that it's been built
			if (![self addToInventory:retval]) {
				error = YES;
				NSLog(@"[SimObjFactory -createSimObjWithString:] - the simulation object described by the line: '%@' was created successfully but could not be added to the inventory of this factory. This is a serious problem that needs looking into. Please check the logs for a possible cause", line);
			}
		}
	}
	
	return error ? nil : retval;
}

@end
