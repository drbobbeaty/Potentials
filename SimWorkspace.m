//
//  SimWorkspace.m
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 21 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers
#import <Accelerate/Accelerate.h>

// System Headers
#import <math.h>

// Third Party Headers

// Other Headers

// Class Headers
#import "SimWorkspace_Protected.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class SimWorkspace
 This class is the main simulation tool as it brings together the
 objects to place in the "workspace" as well as the numerical
 methods to solve the system of equations. A controller needs to
 take created BaseSimObj objects and then message them to add
 themselves to this workspace once this workspace has been defined
 with a coordinate system and a simulation grid.
 
 At this point, the simulation can be done and the results pulled
 out a node at a time. Finally, it's a good idea to release all
 the storage with freeAllStorage when you're done.
 */
@implementation SimWorkspace

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method gets the currently defined number of rows (y-dimension) in
 the simulation grid. This is useful if you want to scan over the data
 in the grid.
 */
- (int) getRowCount
{
	return _rowCnt;
}


/*!
 This method gets the currently defined number of columns (x-dimension) in
 the simulation grid. This is useful if you want to scan over the data
 in the grid.
 */
- (int) getColCount
{
	return _colCnt;
}


/*!
 This method is used to set the the workspace real-world coordinates
 so that electric field calculations are done as accurately as
 possible. This also is necessary as the simulation objects are all
 measured in this coordinate system and so we have to have a point
 of reference to map these objects into the simulation space.
 */
- (void) setWorkspaceRect:(NSRect)r
{
	_workspaceRect.origin.x = r.origin.x;
	_workspaceRect.origin.y = r.origin.y;
	_workspaceRect.size.width = r.size.width;
	_workspaceRect.size.height = r.size.height;
}


/*!
 This method returns the current workspace rectangle that defines the
 real-space coordinate system. This can be used to see if an object
 will fit on the workspace at all as all objects are in this
 coordinate system.
 */
- (NSRect) getWorkspaceRect
{
	return _workspaceRect;
}


/*!
 This method sets the size (width and height) of the simulation
 coordinate system. This might be useful if you don't care about the
 origin, or you wanted to stretch the simulation window a bit one way
 or the other.
 */
- (void) setWorkspaceSize:(NSSize)size
{
	_workspaceRect.size.width = size.width;
	_workspaceRect.size.height = size.height;
}


/*!
 This method gets just the size (width and height) of the simulation
 workspace as it's currently defined.
 */
- (NSSize) getWorkspaceSize
{
	return _workspaceRect.size;
}


/*!
 This method sets the origin (x, y) of the workspace in the simulation
 coordinate system. This might be useful if you wanted to move the
 simulation workarea one way or another.
 */
- (void) setWorkspaceOrigin:(NSPoint)p
{
	_workspaceRect.origin.x = p.x;
	_workspaceRect.origin.y = p.y;
}


/*!
 This method returns the origin (x, y) of the simulation workspace in
 the real-world coordinate system. Just a useful little trinket, nothing
 special.
 */
- (NSPoint) getWorkspaceOrigin
{
	return _workspaceRect.origin;
}


/*!
 This method sets the value of the fixed charge density to 'rho'
 at the coordinate point 'p' in the simulation grid. This is important
 set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setRho:(double)rho atNode:(NSPoint)p
{
	if ([self getRho] == nil) {
		NSLog(@"[SimWorkspace -setRho:atNode:] - the fixed charge density matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getRho] setValue:rho at:p];
	}
}


/*!
 This methodsets the value of the fixed charge density to 'rho'
 at the row 'r' and column 'c' in the simulation grid. This is important
 set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setRho:(double)rho atNodeRow:(int)r andCol:(int)c
{
	if ([self getRho] == nil) {
		NSLog(@"[SimWorkspace -setRho:atNodeRow:andCol:] - the fixed charge density matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getRho] setValue:rho atRow:r andCol:c];
	}
}


/*!
 This method allows the caller to accumulate fixed charge density
 as if you might have overlapping elements each with a different value
 and the total is a sum of the individual components. There are other
 ways to do this, of course, but this is nice and convenient.
 */
- (void) addRho:(double)rho atNode:(NSPoint)p
{
	if ([self getRho] == nil) {
		NSLog(@"[SimWorkspace -addRho:atNode:] - the fixed charge density matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getRho] setValue:([[self getRho] getValueAt:p] + rho) at:p];
	}
}


/*!
 This method allows the caller to accumulate fixed charge density
 at the given row and column as if you might have overlapping elements
 each with a different value and the total is a sum of the individual
 components. There are other ways to do this, of course, but this is
 nice and convenient.
 */
- (void) addRho:(double)rho atNodeRow:(int)r andCol:(int)c
{
	if ([self getRho] == nil) {
		NSLog(@"[SimWorkspace -addRho:atNodeRow:andCol:] - the fixed charge density matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getRho] setValue:([[self getRho] getValueAtRow:r andCol:c] + rho) atRow:r andCol:c];
	}
}


/*!
 This method gets the MaskedMatrix that holds the fixed charge density sheet
 values for this simultation workspace. This is here primarily because of
 the possibility of future expansion and the fact that you can never really
 anticipate all the possibilities.
 */
- (MaskedMatrix*) getRho
{
	return _rho;
}


/*!
 This method gets the currently defined value of rho (fixed charge density).
 This will be used in the simulation, so it's nice to be able to keep track
 of it both before and after the simulation.
 */
- (double) getRhoAtNode:(NSPoint)p
{
	double			retval = 0.0;
	if ([self getRho] == nil) {
		NSLog(@"[SimWorkspace -getRhoAtNode:] - the fixed charge density matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start getting values for the simulation.");
	} else {
		retval = [[self getRho] getValueAt:p];
	}
	return retval;
}


/*!
 This method gets the currently defined value of rho (fixed charge density)
 at the row and column in the matrix specified. This will be used in the
 simulation, so it's nice to be able to keep track of it both before and
 after the simulation.
 */
- (double) getRhoAtNodeRow:(int)r andCol:(int)c
{
	double			retval = 0.0;
	if ([self getRho] == nil) {
		NSLog(@"[SimWorkspace -getRhoAtNodeRow:andCol:] - the fixed charge density matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start getting values for the simulation.");
	} else {
		retval = [[self getRho] getValueAtRow:r andCol:c];
	}
	return retval;
}


/*!
 This method sets the value of the relative dielectric constant to 'er'
 at the coordinate point 'p' in the simulation grid. This is important
 set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setEpsilonR:(double)er atNode:(NSPoint)p
{
	if ([self getEpsilonR] == nil) {
		NSLog(@"[SimWorkspace -setEpsilonR:atNode:] - the relative dielectric constant matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getEpsilonR] setValue:er at:p];
	}
}


/*!
 This method sets the value of the relative dielectric constant to 'er'
 at the coordinate row 'r' and column 'c' in the simulation grid. This is
 important set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setEpsilonR:(double)er atNodeRow:(int)r andCol:(int)c
{
	if ([self getEpsilonR] == nil) {
		NSLog(@"[SimWorkspace -setEpsilonR:atNodeRow:andCol:] - the relative dielectric constant matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getEpsilonR] setValue:er atRow:r andCol:c];
	}
}


/*!
 This method allows the caller to accumulate relative dielectric constant
 as if you might have overlapping elements each with a different value
 and the total is a sum of the individual components. There are other
 ways to do this, of course, but this is nice and convenient.
 */
- (void) addEpsilonR:(double)er atNode:(NSPoint)p
{
	if ([self getEpsilonR] == nil) {
		NSLog(@"[SimWorkspace -addEpsilonR:atNode:] - the relative dielectric constant matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getEpsilonR] setValue:([[self getEpsilonR] getValueAt:p] + er) at:p];
	}
}


/*!
 This method allows the caller to accumulate relative dielectric constant
 as if you might have overlapping elements each with a different value
 and the total is a sum of the individual components. There are other
 ways to do this, of course, but this is nice and convenient.
 */
- (void) addEpsilonR:(double)er atNodeRow:(int)r andCol:(int)c
{
	if ([self getEpsilonR] == nil) {
		NSLog(@"[SimWorkspace -addEpsilonR:atNodeRow:andCol:] - the relative dielectric constant matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getEpsilonR] setValue:([[self getEpsilonR] getValueAtRow:r andCol:c] + er) atRow:r andCol:c];
	}
}


/*!
 This method gets the MaskedMatrix that holds the fixed relative dielectric
 constants for this simultation workspace. This is here primarily because of
 the possibility of future expansion and the fact that you can never really
 anticipate all the possibilities.
 */
- (MaskedMatrix*) getEpsilonR
{
	return _er;
}


/*!
 This method gets the currently defined value of er (relative dielectric
 constant). This will be used in the simulation, so it's nice to be able to
 keep track of it both before and after the simulation.
 */
- (double) getEpsilonRAtNode:(NSPoint)p
{
	double			retval = 0.0;
	if ([self getEpsilonR] == nil) {
		NSLog(@"[SimWorkspace -getEpsilonRAtNode:] - the relative dielectric constant matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start getting values for the simulation.");
	} else {
		retval = [[self getEpsilonR] getValueAt:p];
	}
	return retval;
}


/*!
 This method gets the currently defined value of er (relative dielectric
 constant) for the specified row and column. This will be used in the
 simulation, so it's nice to be able to keep track of it both before and
 after the simulation.
 */
- (double) getEpsilonRAtNodeRow:(int)r andCol:(int)c
{
	double			retval = 0.0;
	if ([self getEpsilonR] == nil) {
		NSLog(@"[SimWorkspace -getEpsilonRAtNodeRow:andCol:] - the relative dielectric constant matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start getting values for the simulation.");
	} else {
		retval = [[self getEpsilonR] getValueAtRow:r andCol:c];
	}
	return retval;
}


/*!
 This method sets the value of the fixed electrostatic potential to 'v'
 at the coordinate point 'p' in the simulation grid. This is important
 set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setVoltage:(double)v atNode:(NSPoint)p
{
	if ([self getVoltage] == nil) {
		NSLog(@"[SimWorkspace -setVoltage:atNode:] - the fixed electristatic potential matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getVoltage] setValue:v at:p];
	}
}


/*!
 This method sets the value of the fixed electrostatic potential to 'v'
 at the coordinate row 'r' and column 'c' in the simulation grid. This is
 important set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setVoltage:(double)v atNodeRow:(int)r andCol:(int)c
{
	if ([self getVoltage] == nil) {
		NSLog(@"[SimWorkspace -setVoltage:atNodeRow:andCol:] - the fixed electristatic potential matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start establishing values for the simulation.");
	} else {
		[[self getVoltage] setValue:v atRow:r andCol:c];
	}
}


/*!
 This method gets the MaskedMatrix that holds the fixed electrostatic potential
 values for this simultation workspace. This is here primarily because of
 the possibility of future expansion and the fact that you can never really
 anticipate all the possibilities.
 */
- (MaskedMatrix*) getVoltage
{
	return _voltage;
}


/*!
 This method gets the currently defined value of v (fixed electrostatic
 potential). This will be used in the simulation, so it's nice to be able to
 keep track of it both before and after the simulation.
 */
- (double) getVoltageAtNode:(NSPoint)p
{
	double			retval = 0.0;
	if ([self getVoltage] == nil) {
		NSLog(@"[SimWorkspace -getVoltageAtNode:] - the fixed electrostatic potential matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start getting values for the simulation.");
	} else {
		retval = [[self getVoltage] getValueAt:p];
	}
	return retval;
}


/*!
 This method gets the currently defined value of v (fixed electrostatic
 potential) at the specified row and column. This will be used in the
 simulation, so it's nice to be able to keep track of it both before and
 after the simulation.
 */
- (double) getVoltageAtNodeRow:(int)r andCol:(int)c
{
	double			retval = 0.0;
	if ([self getVoltage] == nil) {
		NSLog(@"[SimWorkspace -getVoltageAtNodeRow:andCol:] - the fixed electrostatic potential matrix is not currently allocated. This means you need to call -initWithRect:usingRows:andCols: to set up these matricies properly before you can start getting values for the simulation.");
	} else {
		retval = [[self getVoltage] getValueAtRow:r andCol:c];
	}
	return retval;
}


/*!
 This method gets the matrix of results from the simulation and will return
 nil until there are simulation results to present. Not that this is a great
 way to check if the simulation has been run, but it's certainly a possible
 use for this method.
 */
- (MaskedMatrix*) getResultantVoltage
{
	return _resultantVoltage;
}


/*!
 This method gets the simulated value of the potential. This is the main
 results of this class and be used for a great many things.
 */
- (double) getResultantVoltageAtNode:(NSPoint)p
{
	double			retval = 0.0;
	if ([self getResultantVoltage] == nil) {
		NSLog(@"[SimWorkspace -getResultantVoltage:atNode:] - the simulated results for the potential matrix is not currently allocated. This means you need to call -simulateWorkspace to calculate the values and set up these matricies properly before you can start getting values from the simulation.");
	} else {
		retval = [[self getResultantVoltage] getValueAt:p];
	}
	return retval;
}


/*!
 This method gets the simulated value of the potential. This is the main
 results of this class and be used for a great many things.
 */
- (double) getResultantVoltageAtNodeRow:(int)r andCol:(int)c
{
	double			retval = 0.0;
	if ([self getResultantVoltage] == nil) {
		NSLog(@"[SimWorkspace -getResultantVoltage:atNodeRow:andCol:] - the simulated results for the potential matrix is not currently allocated. This means you need to call -simulateWorkspace to calculate the values and set up these matricies properly before you can start getting values from the simulation.");
	} else {
		retval = [[self getResultantVoltage] getValueAtRow:r andCol:c];
	}
	return retval;
}


//----------------------------------------------------------------------------
//               Coordinate Mapping Methods
//----------------------------------------------------------------------------

/*!
 This method returns the simulation grid coordinate for the real-space
 x-axis coordinate passed in. If this value does not fit within the
 simulation grid this method will return a -1 to alert the caller that
 this won't come into play in the simulation.
 */
- (int) getColForXValue:(float)x
{
	int				retval = -1;

	// first, get the limits of this simulation space
	float			lo = [self getWorkspaceOrigin].x;
	float			hi = lo + [self getWorkspaceSize].width;

	// now let's see if the point lies in this space
	if ((lo <= x) && (x <= hi) && (lo < hi) && ([self getColCount] > 0)) {
		// do the simple tests first to avoid rounding
		if (x == lo) {
			retval = 0;
		} else if (x == hi) {
			retval = [self getColCount] - 1;
		} else {
			retval = (x - lo) * [self getColCount] / (hi - lo);
		}
	}
	return retval;
}


/*!
 This method returns the real-space x-axis coordinate for the
 simulation grid coordinate passed in. If this value does not fit within
 the simulation grid this method will return NAN to alert the caller that
 this won't come into play in the simulation. You can test this with
 isnan() to see if an error occurred.
 */
- (float) getXValueForCol:(int)c
{
	float			retval = NAN;

	if ((c >= 0) && (c < [self getColCount])) {
		retval = [self getWorkspaceOrigin].x + (c / ([self getColCount] - 1.0)) * [self getWorkspaceSize].width;
	}
	return retval;
}


/*!
 This method returns the distance in real-space of each simulation
 node along the x-axis. This is useful in a lot of different ways
 and it's a major convenience method as well. If not enough data
 has been provided to this point to compute this value, NAN will be
 returned to the caller.
 */
- (float) getDeltaX
{
	float		retval = NAN;

	if ([self getColCount] != 0) {
		retval = [self getWorkspaceSize].width/([self getColCount] - 1.0);
	}
	return retval;
}


/*!
 This method returns the simulation grid coordinate for the real-space
 y-axis coordinate passed in. If this value does not fit within the
 simulation grid this method will return a -1 to alert the caller that
 this won't come into play in the simulation.
 */
- (int) getRowForYValue:(float)y
{
	int				retval = -1;

	// first, get the limits of this simulation space
	float			lo = [self getWorkspaceOrigin].y;
	float			hi = lo + [self getWorkspaceSize].height;

	// now let's see if the point lies in this space
	if ((lo <= y) && (y <= hi) && (lo < hi) && ([self getRowCount] > 0)) {
		// do the simple tests first to avoid rounding
		if (y == lo) {
			retval = 0;
		} else if (y == hi) {
			retval = [self getRowCount] - 1;
		} else {
			retval = (y - lo) * [self getRowCount] / (hi - lo);
		}
	}
	return retval;
}


/*!
 This method returns the real-space y-axis coordinate for the
 simulation grid coordinate passed in. If this value does not fit within
 the simulation grid this method will return NAN to alert the caller that
 this won't come into play in the simulation. You can test this with
 isnan() to see if an error occurred.
 */
- (float) getYValueForRow:(int)r
{
	float			retval = NAN;

	if ((r >= 0) && (r < [self getRowCount])) {
		retval = [self getWorkspaceOrigin].y + (r / ([self getRowCount] - 1.0)) * [self getWorkspaceSize].height;
	}
	return retval;
}


/*!
 This method returns the distance in real-space of each simulation
 node along the y-axis. This is useful in a lot of different ways
 and it's a major convenience method as well. If not enough data
 has been provided to this point to compute this value, NAN will be
 returned to the caller.
 */
- (float) getDeltaY
{
	float		retval = NAN;

	if ([self getRowCount] != 0) {
		retval = [self getWorkspaceSize].height/([self getRowCount] - 1.0);
	}
	return retval;
}


/*!
 This method takes a point in real-space and mapps it to the simulation
 grid node that's currently defined for this guy. If a point lies outside
 of the simulation grid it will have a value of -1. While the NSPoint can
 hold float values, the returned values will be ints as they are grid
 locations and therefore need to be integers.
 */
- (NSPoint) getNodeInWorkspace:(NSPoint)p
{
	return [self getNodeInWorkspaceAtX:p.x Y:p.y];
}


/*!
 This method takes the real-space point specified by the ordinal (x,y)
 and maps it to the currently defined simulation grid for this guy. If
 the point lies outside of the simulation grid then the coordinate
 (-1,-1) will be returned. Make sure to check this before you use it
 as it'll cause nasty array indexing problems if you hand it a -1.
 */
- (NSPoint) getNodeInWorkspaceAtX:(float)x Y:(float)y
{
	NSPoint			retval;
	// first, get the individual compponents
	retval.x = [self getColForXValue:x];
	retval.y = [self getRowForYValue:y];
	// next, make sure neither was out of bounds
	if ((retval.x < 0) || (retval.y < 0)) {
		retval.x = -1;
		retval.y = -1;
	}
	return retval;
}


/*!
 This method takes the simulation coordinates in the supplied NSPoint
 as grid node rows and columns and converts these to real-world values
 as defined in this workspace instance. It's the inverse of the
 -getNodeInWorkspace: method, and is very useful when doing the reverse
 mapping of the coordinates.
 */
- (NSPoint) getPointInWorkspaceAtNode:(NSPoint)p
{
	return [self getPointInWorkspaceAtNodeRow:(int)p.x andCol:(int)p.y];
}


/*!
 This method takes supplied the simulation row and column coordinates
 as grid node values and converts these to real-world values
 as defined in this workspace instance. It's the inverse of the
 -getNodeInWorkspaceAtX:Y: method, and is very useful when doing the
 reverse mapping of the coordinates.
 */
- (NSPoint) getPointInWorkspaceAtNodeRow:(int)r andCol:(int)c
{
	NSPoint			retval;
	// first, get the individual compponents
	retval.x = [self getXValueForCol:c];
	retval.y = [self getYValueForRow:r];
	return retval;
}


//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

/*!
 This initialization method takes the real-space simulation rectangle as well
 as the number of rows and columns that will be used in the simulation grid.
 We'll initialize everything, allocate all the storage for the different
 constants and in general make sure that things are ready for the addition
 of simulation objects on the workspace. After that, it's a simulation call
 and you get the answers.
 */
- (id) initWithRect:(NSRect)r usingRows:(int)rowCnt andCols:(int)colCnt
{
	return [self initWithSize:r.size andOrigin:r.origin usingRows:rowCnt andCols:colCnt];
}


/*!
 This initialization method takes the real-space simulation origin and size
 as well as the number of rows and columns that will be used in the
 simulation grid. We'll initialize everything, allocate all the storage for
 the different constants and in general make sure that things are ready for
 the addition of simulation objects on the workspace. After that, it's a
 simulation call and you get the answers.
 */
- (id) initWithSize:(NSSize)size andOrigin:(NSPoint)p usingRows:(int)rowCnt andCols:(int)colCnt
{
	BOOL			error = NO;

	// first, let's check the arguments for reasonable values
	if (!error) {
		if ((size.width <= 0) || (size.height <= 0)) {
			error = YES;
			NSLog(@"[SimWorkspace -initWithSize:andOrigin:usingRows:andCols:] - the size of the real-space simulation area is nonsense: width=%f and height=%f. Please make sure that you have reasonable values here.", size.width, size.height);
		}
	}
	if (!error) {
		if ((rowCnt <= 0) || (colCnt <= 0)) {
			error = YES;
			NSLog(@"[SimWorkspace -initWithSize:andOrigin:usingRows:andCols:] - the size of the simulation grid is nonsense: rows=%d and cols=%d. Please make sure that you have reasonable values here.", rowCnt, colCnt);
		}
	}

	// next, let's make sure the super can be initialized
	if (!error) {
		if (!(self = [super init])) {
			error = YES;
			NSLog(@"[SimWorkspace -initWithSize:andOrigin:usingRows:andCols:] - the superclass could not complete it's -init method. Please check the logs for a possible cause.");
		}
	}

	// we need to create the MaskedMatrix for epsilon
	MaskedMatrix*		er = nil;
	if (!error) {
		er = [[[MaskedMatrix alloc] initWithRows:rowCnt andCols:colCnt] autorelease];
		if (er == nil) {
			error = YES;
			NSLog(@"[SimWorkspace -initWithSize:andOrigin:usingRows:andCols:] - the constant matrix for the relative dielectric constant could not be created and this is a serious storage problem. The request was made for a %dx%d sized matrix, and that seems to be too much. Check into this.", rowCnt, colCnt);
		}
	}

	// we need to create the MaskedMatrix for rho
	MaskedMatrix*		rho = nil;
	if (!error) {
		rho = [[[MaskedMatrix alloc] initWithRows:rowCnt andCols:colCnt] autorelease];
		if (rho == nil) {
			error = YES;
			NSLog(@"[SimWorkspace -initWithSize:andOrigin:usingRows:andCols:] - the constant matrix for the fixed charge density could not be created and this is a serious storage problem. The request was made for a %dx%d sized matrix, and that seems to be too much. Check into this.", rowCnt, colCnt);
		}
	}

	// we need to create the MaskedMatrix for V
	MaskedMatrix*		v = nil;
	if (!error) {
		v = [[[MaskedMatrix alloc] initWithRows:rowCnt andCols:colCnt] autorelease];
		if (v == nil) {
			error = YES;
			NSLog(@"[SimWorkspace -initWithSize:andOrigin:usingRows:andCols:] - the constant matrix for the fixed electrostatic potential could not be created and this is a serious storage problem. The request was made for a %dx%d sized matrix, and that seems to be too much. Check into this.", rowCnt, colCnt);
		}
	}

	// regardless of what's happened up to now, we need to free the old storage
	[self freeAllStorage];
	// ...and if we had an error reset the rest of the parameters to 'scratch'
	if (error) {
		// ...and we need to reset the values for this guy
		[self _setRowCount:0];
		[self _setColCount:0];
		[self setWorkspaceRect:NSMakeRect(0, 0, 0, 0)];
	} else {
		// things are looking good! save everything
		[self _setRowCount:rowCnt];
		[self _setColCount:colCnt];
		// set the real-space size and origin
		[self setWorkspaceSize:size];
		[self setWorkspaceOrigin:p];
		// save the masked matricies that I've created
		[self _setRho:rho];
		[self _setEpsilonR:er];
		[self _setVoltage:v];
		// don't forget to clear everything out now that it's there
		[self clearWorkspace];
	}

	return error ? nil : self;
}


/*!
 This method clears out all the local storage that this instance has in
 it's use. This is nice because it allows us to clean things up nicely
 for a new init call or in the case of dealloc when we're getting cleaned
 up.
 */
- (void) freeAllStorage
{
	// drop everything we've used
	[self _setRho:nil];
	[self _setEpsilonR:nil];
	[self _setVoltage:nil];
	[self _setResultantVoltage:nil];
}


//----------------------------------------------------------------------------
//               Simulation Methods
//----------------------------------------------------------------------------

/*!
 This method can be called to clear out all the data for a simulation
 workspace. This will remove all the objects in the workspace and act as
 if you did the Big Shake on the Etch-A-Sketch.
 */
- (void) clearWorkspace
{
	[[self getEpsilonR] discardAllValues];
	[[self getRho] discardAllValues];
	[[self getVoltage] discardAllValues];
	// the results are a little different - we can't have *any*
	[self _setResultantVoltage:nil];
}


/*!
 This method will take the existing workspace with all the objects placed
 on it and simulate it for the potential at each simulation grid point.
 This needs to be done before you can get any values out of the workspace,
 but that's pretty obvious if you think about it.
 */
- (BOOL) simulateWorkspace
{
	BOOL			error = NO;

	// first, make sure we're set up for this
	if (!error) {
		if (([self getRowCount] <= 1) || ([self getColCount] <= 1) ||
			([self getEpsilonR] == nil) || ([self getRho] == nil) ||
			([self getVoltage] == nil)) {
			error = YES;
			NSLog(@"[SimWorkspace -simulateWorkspace] - this workspace is not yet set up properly for a simulation. You need to set reasonable simulation node counts as well as initializing this class for the simulation. Please make sure you cann one of the -init methods before calling this method.");
		}
	}

	/*
	 * Next, determine storage format and allocate space for solution set.
	 * For a more complete description of the arguments and what they are,
	 * how big they need to be, etc. please see the docs on DGBSV in LAPACK.
	 */
	__CLPK_integer		n = [self getRowCount] * [self getColCount];
	__CLPK_integer		kl = MIN([self getRowCount], [self getColCount]);
	__CLPK_integer		ku = kl;
	__CLPK_integer		klpku = kl + ku;
	BOOL				rowMajor = (kl == [self getColCount]);
	__CLPK_integer		nrhs = 1;
	__CLPK_integer		ldab = 2*kl + ku + 1;
	__CLPK_doublereal	*ab = NULL;
	if (!error) {
		ab = (__CLPK_doublereal	*) malloc( ldab*n*sizeof(__CLPK_doublereal) );
		if (ab == NULL) {
			error = YES;
			NSLog(@"[SimWorkspace -simulateWorkspace] - while trying to allocate the banded A matrix storage (%dx%d) for the solution, we ran into an allocation problem and couldn't get it. Please check into this as soon as possilbe.", ldab, n);
		}
	}
	__CLPK_integer		ldb = n;
	__CLPK_doublereal	*b = NULL;
	if (!error) {
		b = (__CLPK_doublereal *) malloc( ldb*nrhs*sizeof(__CLPK_doublereal) );
		if (b == NULL) {
			// free up what we've already obtained
			free(ab);
			// ...and log the error
			error = YES;
			NSLog(@"[SimWorkspace -simulateWorkspace] - while trying to allocate the RHS b matrix storage (%dx%d) for the solution, we ran into an allocation problem and couldn't get it. Please check into this as soon as possilbe.", ldb, nrhs);
		}
	}
	__CLPK_integer		*ipiv = NULL;
	if (!error) {
		ipiv = (__CLPK_integer *) malloc( n*sizeof(__CLPK_integer) );
		if (ipiv == NULL) {
			// free up what we've already obtained
			free(b);
			free(ab);
			// ...and log the error
			error = YES;
			NSLog(@"[SimWorkspace -simulateWorkspace] - while trying to allocate the ipivot storage (%dx1) for the solution, we ran into an allocation problem and couldn't get it. Please check into this as soon as possilbe.", n);
		}
	}
	
	/*
	 * Now we can populate the matricies with the equations to solve. We
	 * do this by going through all the nodes and placing the equation for
	 * that node into the cLAPACK matricies ab[] and b[] based on the
	 * location of each node, and the physical parameters for that node.
	 *
	 * Because cLAPACK uses banded storage and a vector as opposed to a
	 * two-dimensional array of numbers, we need to be able to convert
	 * the matrix notation into the actual values placed in the banded
	 * storage. Here's how it goes:
	 *
	 * The banded storage format is given as:
	 *     ab(kl+ku+1+i-j, j) = a(i, j)
	 * where i, j are constrained to be in the banded storage "coverage"
	 * and are both in the range (1,n), i.e. FORTRAN-style. To convert
	 * this to C-style arrays:
	 *     ab[kl+ku+i-j][j] = a[i][j]
	 * where now i and j run from 0..(n-1). The important difference is
	 * in the loss of the "+1" for the limiting case of kl=ku=0 needs to
	 * map to row=0 not row=1. The conversion to the row-major storage is,
	 * in general, accomplished with:
	 *     ab[col*ldab + row] = ab[row][col]
	 * for a given row and column, where again, row and col are in the range
	 * (0,n-1). Therefore, to map a general FORTRAN-style i,j from
	 * A into the banded storage is:
	 *     ab[j*ldab + kl+ku+i-j] = a(i, j)
	 * with the addition of a simple variable for speed:
	 *     ab[j*ldab + klpku + i-j] = a(i, j)
	 * and that's what we're implementing. B is implemented in a similar
	 * manner where:
	 *     b[rhs*ldb + i] = b(i, rhs)
	 * or:
	 *     b[i] = b(i)
	 * assuming that nrhs = 1, which it does for all our work.
	 */
	if (!error) {
		int		row = 0;
		int		col = 0;
		int		rows = [self getRowCount];
		int		cols = [self getColCount];
		// these will be the node numbers in the simulation
		int		ijn = 0;
		int		ln = 0;
		int		rn = 0;
		int		tn = 0;
		int		bn = 0;
		// these are the components of the coefficients
		__CLPK_doublereal	invHx2 = 1.0/([self getDeltaX] * [self getDeltaX]);
		__CLPK_doublereal	invHy2 = 1.0/([self getDeltaY] * [self getDeltaY]);
		// these are the values of rho and er at the node in the simulation
		__CLPK_doublereal	rho = 0;
		__CLPK_doublereal	er = 0;
		// now loop through all the node in the workspace
		for (row = 0; row < rows; row++) {
			for (col = 0; col < cols; col++) {
				/*
				 * We need to convert the row and col into a node number based
				 * on the most efficient banding possible.
				 */
				ijn = (rowMajor ? (row * cols + col) : (col * rows + row));
				
				// see if there's a fixed potential at this node
				if ([[self getVoltage] haveValueAtRow:row andCol:col]) {
					/*
					 * In this case the equation is simple: v(i,j) = v_fixed
					 */
					ab[ijn*ldab + klpku] = 1.0;
					b[ijn] = [self getVoltageAtNodeRow:row andCol:col];
				} else {
					/*
					 * In this case, we need to build up the entire Poission's Eq.
					 * for this node.
					 */
					// first, do the 'ij' node
					ab[ijn*ldab + klpku] = -2.0*(invHx2 + invHy2);
					// next, do the 'top' node
					if (row == 0) {
						// due to symmetry, add to the 'bottom' node
						bn = (rowMajor ? (ijn + cols) : (ijn + 1));
						ab[bn*ldab + klpku + ijn-bn] += invHy2;
					} else {
						tn = (rowMajor ? (ijn - cols) : (ijn - 1));
						ab[tn*ldab + klpku + ijn-tn] += invHy2;
					}
					// next, do the 'bottom' node
					if (row == (rows - 1)) {
						// due to symmetry, add to the 'top' node
						tn = (rowMajor ? (ijn - cols) : (ijn - 1));
						ab[tn*ldab + klpku + ijn-tn] += invHy2;
					} else {
						bn = (rowMajor ? (ijn + cols) : (ijn + 1));
						ab[bn*ldab + klpku + ijn-bn] += invHy2;
					}
					// next, do the 'left' node
					if (col == 0) {
						// due to symmetry, add to the 'right' node
						rn = (rowMajor ? (ijn + 1) : (ijn + rows));
						ab[rn*ldab + klpku + ijn-rn] += invHx2;
					} else {
						ln = (rowMajor ? (ijn - 1) : (ijn - rows));
						ab[ln*ldab + klpku + ijn-ln] += invHx2;
					}
					// finally, do the 'right' node
					if (col == (cols - 1)) {
						// due to symmetry, add to the 'left' node
						ln = (rowMajor ? (ijn - 1) : (ijn - rows));
						ab[ln*ldab + klpku + ijn-ln] += invHx2;
					} else {
						rn = (rowMajor ? (ijn + 1) : (ijn + rows));
						ab[rn*ldab + klpku + ijn-rn] += invHx2;
					}
					
					/*
					 * Now let's calculate the RHS of Ax=b...
					 */
					rho = [self getRhoAtNodeRow:row andCol:col];
					er = [self getEpsilonRAtNodeRow:row andCol:col];
					b[ijn] = -1.0 * rho/(er == 0 ? 1.0 : er);
				}
			}
		}
	}

	// finally, we can solve the system for the user using dgbsv_ in cLAPACK
	if (!error) {
		__CLPK_integer	info = 0;
		dgbsv_(&n, &kl, &ku, &nrhs, ab, &ldab, ipiv, b, &ldb, &info);
		if (info < 0) {
			error = YES;
			NSLog(@"[SimWorkspace -simulateWorkspace] - argument #%d had an illegal value to DGBSV in LAPACK. Please check into this.", -1*info);
		} else if (info > 0) {
			error = YES;
			NSLog(@"[SimWorkspace -simulateWorkspace] - diagonal #%d is zero indicating singularity which shouldn't happen.", info);
		}
	}

	// we need to create the resultant voltage matrix and populate it
	MaskedMatrix*		rv = nil;
	if (!error) {
		rv = [[[MaskedMatrix alloc] initWithRows:[self getRowCount] andCols:[self getColCount]] autorelease];
		if (rv == nil) {
			error = YES;
			NSLog(@"[SimWorkspace -simulateWorkspace] - the resultant voltage matrix for the simulation could not be created and this is a serious storage problem. The request was made for a %dx%d sized matrix, and that seems to be too much. Check into this.", [self getRowCount], [self getColCount]);
		} else {
			// now fill in all the values from the solution set
			int		row = 0;
			int		col = 0;
			int		ij = 0;
			for (row = 0; row < [self getRowCount]; row++) {
				for (col = 0; col < [self getColCount]; col++) {
					/*
					 * We need to convert the row and col into a node number based
					 * on the most efficient banding possible.
					 */
					ij = (rowMajor ? (row * [self getColCount] + col) : (col * [self getRowCount] + row));
					// now save it
					[rv setValue:b[ij] atRow:row andCol:col];
				}
			}
					
			// ...and don't forget to save it for the user
			[self _setResultantVoltage:rv];
		}
	}
	
	// in the end, we can release what it is that we don't need
	if (ipiv != NULL) {
		free(ipiv);
	}
	if (b != NULL) {
		free(b);
	}
	if (ab != NULL) {
		free(ab);
	}

	return !error;
}


/*!
 This method gets the magnitude of the simulated electric field at the
 point in the simulation grid indicated by the integer values of the
 passed-in point. This is nice if you're only really interested in the
 magnitude at the point and don't want to convert the entire space or
 don't care about the direction of the field vector.
 */
- (double) getResultantElectricFieldMagnitudeAtNode:(NSPoint)p
{
	return [self getResultantElectricFieldMagnitudeAtNodeRow:(int)p.x andCol:(int)p.y];
}


/*!
 This method gets the magnitude of the simulated electric field at the
 row and column in the simulation grid indicated by the integer values
 passed-in. This is nice if you're only really interested in the
 magnitude at the point and don't want to convert the entire space or
 don't care about the direction of the field vector.
 
 Given that we can model the voltage solution as a function of (x,y)
 like:
     V(x,y) = a * x*x + b * x + c + d * y*y + e * y
 then the coefficients break down to:
     a = (1/(2*hx*hx))*(vl - 2.0*vij + vr)
     b = (1.(2*hx))*(vr - vl)
 on a uniform mesh in the x-direction.
 
 This then means that:
     ex = b at v=vij
 and similarly easily done for the y-direction.
 */
- (double) getResultantElectricFieldMagnitudeAtNodeRow:(int)r andCol:(int)c
{
	BOOL			error = NO;
	double		retval = 0.0;

	// make sure we have a properly sized simulation grid
	if (!error) {
		if (([self getRowCount] < 2) || ([self getColCount] < 2)) {
			error = YES;
			NSLog(@"[SimWorkspace -getResultantElectricFieldMagnitudeAtNodeRow:andCol:] - the simulation grid needs to be at least two rows and two columns, the current simulation grid is %dx%d which is too small. Please establish a proper sized grid.", [self getRowCount], [self getColCount]);
		}
	}
	
	// make sure we have something to calculate on
	if (!error) {
		if ([self getResultantVoltage] == nil) {
			error = YES;
			NSLog(@"[SimWorkspace -getResultantElectricFieldMagnitudeAtNodeRow:andCol:] - the simulation needs to have been completed to determine any results and this simulation hasn't. Please call -simulateWorkspace after things are set-up and then call this method.");
		}
	}

	// now do the calculations
	if (!error) {
		// get the grid spacings in the x and y directions
		double	hx = [self getWorkspaceSize].width/[self getColCount];
		double	hy = [self getWorkspaceSize].height/[self getRowCount];

		// get the column and row limits
		int			cr = c + 1;
		int			cl = c - 1;
		int			rb = r + 1;
		int			rt = r - 1;
		// assume LOS at each border
		if (cr >= [self getColCount]) cr = [self getColCount] - 2;
		if (cl <= 0) cl = 1;
		if (rb >= [self getRowCount]) rb = [self getRowCount] - 2;
		if (rt <= 0) rt = 1;
		
		// now get the voltages at the surrounding nodes
		double	vr = [[self getResultantVoltage] getValueAtRow:r andCol:cr];
		double	vl = [[self getResultantVoltage] getValueAtRow:r andCol:cl];
		double	vb = [[self getResultantVoltage] getValueAtRow:rb andCol:c];
		double	vt = [[self getResultantVoltage] getValueAtRow:rt andCol:c];

		// now get the components of the electric field
		double	ex = (vr - vl)/(2.0*hx);
		double	ey = (vb - vt)/(2.0*hy);

		// now get the answer we're looking for
		retval = sqrt(ex*ex + ey*ey);
	}

	return error ? 0.0 : retval;
}


/*!
 This method gets the direction in degrees of the unit circle of the
 simulated electric field at the point in the simulation grid indicated
 by the integer values of the passed-in point. This is nice if you're
 only really interested in the direction at the point and don't want to
 convert the entire space or don't care about the magnitude of the field
 vector.
 */
- (double) getResultantElectricFieldDirectionAtNode:(NSPoint)p
{
	return [self getResultantElectricFieldDirectionAtNodeRow:(int)p.x andCol:(int)p.y];
}


/*!
 This method gets the direction in radians of the unit circle of the
 simulated electric field at the row and column in the simulation grid
 indicated by the integer values passed-in. This is nice if you're
 only really interested in the direction at the point and don't want to
 convert the entire space or don't care about the magnitude of the field
 vector.
 */
- (double) getResultantElectricFieldDirectionAtNodeRow:(int)r andCol:(int)c
{
	BOOL			error = NO;
	double		retval = 0.0;

	// make sure we have a properly sized simulation grid
	if (!error) {
		if (([self getRowCount] < 2) || ([self getColCount] < 2)) {
			error = YES;
			NSLog(@"[SimWorkspace -getResultantElectricFieldMagnitudeAtNodeRow:andCol:] - the simulation grid needs to be at least two rows and two columns, the current simulation grid is %dx%d which is too small. Please establish a proper sized grid.", [self getRowCount], [self getColCount]);
		}
	}

	// make sure we have something to calculate on
	if (!error) {
		if ([self getResultantVoltage] == nil) {
			error = YES;
			NSLog(@"[SimWorkspace -getResultantElectricFieldMagnitudeAtNodeRow:andCol:] - the simulation needs to have been completed to determine any results and this simulation hasn't. Please call -simulateWorkspace after things are set-up and then call this method.");
		}
	}

	// now do the calculations
	if (!error) {
		// get the grid spacings in the x and y directions
		double	hx = [self getWorkspaceSize].width/[self getColCount];
		double	hy = [self getWorkspaceSize].height/[self getRowCount];

		// get the column and row limits
		int		cr = c + 1;
		int		cl = c - 1;
		int		rb = r + 1;
		int		rt = r - 1;
		// assume LOS at each border
		if (cr >= [self getColCount]) cr = [self getColCount] - 2;
		if (cl <= 0) cl = 1;
		if (rb >= [self getRowCount]) rb = [self getRowCount] - 2;
		if (rt <= 0) rt = 1;

		// now get the voltages at the surrounding nodes
		double	vr = [[self getResultantVoltage] getValueAtRow:r andCol:cr];
		double	vl = [[self getResultantVoltage] getValueAtRow:r andCol:cl];
		double	vb = [[self getResultantVoltage] getValueAtRow:rb andCol:c];
		double	vt = [[self getResultantVoltage] getValueAtRow:rt andCol:c];

		// now get the components of the electric field
		double	ex = (vr - vl)/(2.0*hx);
		double	ey = (vb - vt)/(2.0*hy);

		// now get the answer we're looking for
		if ((ex == 0) && (ey == 0)) {
			retval = 0;
		} else {
			retval = atan2(ey, ex);
		}
	}

	return error ? 0.0 : retval;
}


//----------------------------------------------------------------------------
//               NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method is called by the runtime when the released object is about
 to get cleaned up. This gives us an opportunity to clean up all the
 memory we're using at the time and be a good citizen.
 */
- (void) dealloc
{
	// drop all the memory we're using
	[self freeAllStorage];
	// ...and don't forget to call the super's dealloc too...
	[super dealloc];
}

@end
