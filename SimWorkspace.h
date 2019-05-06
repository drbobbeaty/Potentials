//
//  SimWorkspace.h
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
#import "MaskedMatrix.h"

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
@interface SimWorkspace : NSObject {
	@private
	int					_rowCnt;
	int					_colCnt;
	NSRect				_workspaceRect;
	MaskedMatrix*		_rho;
	MaskedMatrix*		_er;
	MaskedMatrix*		_voltage;
	MaskedMatrix*		_resultantVoltage;
	MaskedMatrix*		_resultantElectricFieldMagnitude;
	MaskedMatrix*		_resultantElectricFieldDirection;
}

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method gets the currently defined number of rows (y-dimension) in
 the simulation grid. This is useful if you want to scan over the data
 in the grid.
 */
- (int) getRowCount;

/*!
 This method gets the currently defined number of columns (x-dimension) in
 the simulation grid. This is useful if you want to scan over the data
 in the grid.
 */
- (int) getColCount;

/*!
 This method is used to set the the workspace real-world coordinates
 so that electric field calculations are done as accurately as
 possible. This also is necessary as the simulation objects are all
 measured in this coordinate system and so we have to have a point
 of reference to map these objects into the simulation space.
 */
- (void) setWorkspaceRect:(NSRect)r;

/*!
 This method returns the current workspace rectangle that defines the
 real-space coordinate system. This can be used to see if an object
 will fit on the workspace at all as all objects are in this
 coordinate system.
 */
- (NSRect) getWorkspaceRect;

/*!
 This method sets the size (width and height) of the simulation
 coordinate system. This might be useful if you don't care about the
 origin, or you wanted to stretch the simulation window a bit one way
 or the other.
 */
- (void) setWorkspaceSize:(NSSize)size;

/*!
 This method gets just the size (width and height) of the simulation
 workspace as it's currently defined.
 */
- (NSSize) getWorkspaceSize;

/*!
 This method sets the origin (x, y) of the workspace in the simulation
 coordinate system. This might be useful if you wanted to move the
 simulation workarea one way or another.
 */
- (void) setWorkspaceOrigin:(NSPoint)p;

/*!
 This method returns the origin (x, y) of the simulation workspace in
 the real-world coordinate system. Just a useful little trinket, nothing
 special.
 */
- (NSPoint) getWorkspaceOrigin;

/*!
 This method sets the value of the fixed charge density to 'rho'
 at the coordinate point 'p' in the simulation grid. This is important
 set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setRho:(double)rho atNode:(NSPoint)p;

/*!
 This methodsets the value of the fixed charge density to 'rho'
 at the row 'r' and column 'c' in the simulation grid. This is important
 set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setRho:(double)rho atNodeRow:(int)r andCol:(int)c;

/*!
 This method allows the caller to accumulate fixed charge density
 as if you might have overlapping elements each with a different value
 and the total is a sum of the individual components. There are other
 ways to do this, of course, but this is nice and convenient.
 */
- (void) addRho:(double)rho atNode:(NSPoint)p;

/*!
 This method allows the caller to accumulate fixed charge density
 at the given row and column as if you might have overlapping elements
 each with a different value and the total is a sum of the individual
 components. There are other ways to do this, of course, but this is
 nice and convenient.
 */
- (void) addRho:(double)rho atNodeRow:(int)r andCol:(int)c;

/*!
 This method gets the MaskedMatrix that holds the fixed charge density sheet
 values for this simultation workspace. This is here primarily because of
 the possibility of future expansion and the fact that you can never really
 anticipate all the possibilities.
 */
- (MaskedMatrix*) getRho;

/*!
 This method gets the currently defined value of rho (fixed charge density).
 This will be used in the simulation, so it's nice to be able to keep track
 of it both before and after the simulation.
 */
- (double) getRhoAtNode:(NSPoint)p;

/*!
 This method gets the currently defined value of rho (fixed charge density)
 at the row and column in the matrix specified. This will be used in the
 simulation, so it's nice to be able to keep track of it both before and
 after the simulation.
 */
- (double) getRhoAtNodeRow:(int)r andCol:(int)c;

/*!
 This method sets the value of the relative dielectric constant to 'er'
 at the coordinate point 'p' in the simulation grid. This is important
 set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setEpsilonR:(double)er atNode:(NSPoint)p;

/*!
 This method sets the value of the relative dielectric constant to 'er'
 at the coordinate row 'r' and column 'c' in the simulation grid. This is
 important set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setEpsilonR:(double)er atNodeRow:(int)r andCol:(int)c;

/*!
 This method allows the caller to accumulate relative dielectric constant
 as if you might have overlapping elements each with a different value
 and the total is a sum of the individual components. There are other
 ways to do this, of course, but this is nice and convenient.
 */
- (void) addEpsilonR:(double)er atNode:(NSPoint)p;

/*!
 This method allows the caller to accumulate relative dielectric constant
 as if you might have overlapping elements each with a different value
 and the total is a sum of the individual components. There are other
 ways to do this, of course, but this is nice and convenient.
 */
- (void) addEpsilonR:(double)er atNodeRow:(int)r andCol:(int)c;

/*!
 This method gets the MaskedMatrix that holds the fixed relative dielectric
 constants for this simultation workspace. This is here primarily because of
 the possibility of future expansion and the fact that you can never really
 anticipate all the possibilities.
 */
- (MaskedMatrix*) getEpsilonR;

/*!
 This method gets the currently defined value of er (relative dielectric
 constant). This will be used in the simulation, so it's nice to be able to
 keep track of it both before and after the simulation.
 */
- (double) getEpsilonRAtNode:(NSPoint)p;

/*!
 This method gets the currently defined value of er (relative dielectric
 constant) for the specified row and column. This will be used in the
 simulation, so it's nice to be able to keep track of it both before and
 after the simulation.
 */
- (double) getEpsilonRAtNodeRow:(int)r andCol:(int)c;

/*!
 This method sets the value of the fixed electrostatic potential to 'v'
 at the coordinate point 'p' in the simulation grid. This is important
 set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setVoltage:(double)v atNode:(NSPoint)p;

/*!
 This method sets the value of the fixed electrostatic potential to 'v'
 at the coordinate row 'r' and column 'c' in the simulation grid. This is
 important set-up prior to a simulation run and needs to be done by each
 simulation object for each point of their 'existance'.
 */
- (void) setVoltage:(double)v atNodeRow:(int)r andCol:(int)c;

/*!
 This method gets the MaskedMatrix that holds the fixed electrostatic potential
 values for this simultation workspace. This is here primarily because of
 the possibility of future expansion and the fact that you can never really
 anticipate all the possibilities.
 */
- (MaskedMatrix*) getVoltage;

/*!
 This method gets the currently defined value of v (fixed electrostatic
 potential). This will be used in the simulation, so it's nice to be able to
 keep track of it both before and after the simulation.
 */
- (double) getVoltageAtNode:(NSPoint)p;

/*!
 This method gets the currently defined value of v (fixed electrostatic
 potential) at the specified row and column. This will be used in the
 simulation, so it's nice to be able to keep track of it both before and
 after the simulation.
 */
- (double) getVoltageAtNodeRow:(int)r andCol:(int)c;

/*!
 This method gets the matrix of results from the simulation and will return
 nil until there are simulation results to present. Not that this is a great
 way to check if the simulation has been run, but it's certainly a possible
 use for this method.
 */
- (MaskedMatrix*) getResultantVoltage;

/*!
 This method gets the simulated value of the potential. This is the main
 results of this class and be used for a great many things.
 */
- (double) getResultantVoltageAtNode:(NSPoint)p;

/*!
 This method gets the simulated value of the potential. This is the main
 results of this class and be used for a great many things.
 */
- (double) getResultantVoltageAtNodeRow:(int)r andCol:(int)c;

/*!
 This method gets the matrix of results from the simulation and will return
 nil until there are simulation results to present. Not that this is a great
 way to check if the simulation has been run, but it's certainly a possible
 use for this method. This is just the magnitude of the field, and there is
 another call for the direction.
 */
- (MaskedMatrix*) getResultantElectricFieldMagnitude;

/*!
 This method gets the magnitude of the simulated electric field at the
 point in the simulation grid indicated by the integer values of the
 passed-in point.
 */
- (double) getResultantElectricFieldMagnitudeAtNode:(NSPoint)p;

/*!
 This method gets the magnitude of the simulated electric field at the
 row and column in the simulation grid indicated by the integer values
 passed-in.
 */
- (double) getResultantElectricFieldMagnitudeAtNodeRow:(int)r andCol:(int)c;

/*!
 This method gets the matrix of results from the simulation and will return
 nil until there are simulation results to present. Not that this is a great
 way to check if the simulation has been run, but it's certainly a possible
 use for this method. This is just the direction of the field, and there is
 another call for the magnitude.
 */
- (MaskedMatrix*) getResultantElectricFieldDirection;

/*!
 This method gets the direction in degrees of the unit circle of the
 simulated electric field at the point in the simulation grid indicated
 by the integer values of the passed-in point.
 */
- (double) getResultantElectricFieldDirectionAtNode:(NSPoint)p;

/*!
 This method gets the direction in radians of the unit circle of the
 simulated electric field at the row and column in the simulation grid
 indicated by the integer values passed-in.
 */
- (double) getResultantElectricFieldDirectionAtNodeRow:(int)r andCol:(int)c;

//----------------------------------------------------------------------------
//               Coordinate Mapping Methods
//----------------------------------------------------------------------------

/*!
 This method returns the simulation grid coordinate for the real-space
 x-axis coordinate passed in. If this value does not fit within the
 simulation grid this method will return a -1 to alert the caller that
 this won't come into play in the simulation.
 */
- (int) getColForXValue:(float)x;

/*!
 This method returns the real-space x-axis coordinate for the
 simulation grid coordinate passed in. If this value does not fit within
 the simulation grid this method will return NAN to alert the caller that
 this won't come into play in the simulation. You can test this with
 isnan() to see if an error occurred.
 */
- (float) getXValueForCol:(int)c;

/*!
 This method returns the distance in real-space of each simulation
 node along the x-axis. This is useful in a lot of different ways
 and it's a major convenience method as well. If not enough data
 has been provided to this point to compute this value, NAN will be
 returned to the caller.
 */
- (float) getDeltaX;

/*!
 This method returns the simulation grid coordinate for the real-space
 y-axis coordinate passed in. If this value does not fit within the
 simulation grid this method will return a -1 to alert the caller that
 this won't come into play in the simulation.
 */
- (int) getRowForYValue:(float)y;

/*!
 This method returns the real-space y-axis coordinate for the
 simulation grid coordinate passed in. If this value does not fit within
 the simulation grid this method will return NAN to alert the caller that
 this won't come into play in the simulation. You can test this with
 isnan() to see if an error occurred.
 */
- (float) getYValueForRow:(int)r;

/*!
 This method returns the distance in real-space of each simulation
 node along the y-axis. This is useful in a lot of different ways
 and it's a major convenience method as well. If not enough data
 has been provided to this point to compute this value, NAN will be
 returned to the caller.
 */
- (float) getDeltaY;

/*!
 This method takes a point in real-space and mapps it to the simulation
 grid node that's currently defined for this guy. If a point lies outside
 of the simulation grid it will have a value of -1. While the NSPoint can
 hold float values, the returned values will be ints as they are grid
 locations and therefore need to be integers.
 */
- (NSPoint) getNodeInWorkspace:(NSPoint)p;

/*!
 This method takes the real-space point specified by the ordinal (x,y)
 and maps it to the currently defined simulation grid for this guy. If
 the point lies outside of the simulation grid then the coordinate
 (-1,-1) will be returned. Make sure to check this before you use it
 as it'll cause nasty array indexing problems if you hand it a -1.
 */
- (NSPoint) getNodeInWorkspaceAtX:(float)x Y:(float)y;

/*!
 This method takes the simulation coordinates in the supplied NSPoint
 as grid node rows and columns and converts these to real-world values
 as defined in this workspace instance. It's the inverse of the
 -getNodeInWorkspace: method, and is very useful when doing the reverse
 mapping of the coordinates.
 */
- (NSPoint) getPointInWorkspaceAtNode:(NSPoint)p;

/*!
 This method takes supplied the simulation row and column coordinates
 as grid node values and converts these to real-world values
 as defined in this workspace instance. It's the inverse of the
 -getNodeInWorkspaceAtX:Y: method, and is very useful when doing the
 reverse mapping of the coordinates.
 */
- (NSPoint) getPointInWorkspaceAtNodeRow:(int)r andCol:(int)c;

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
- (id) initWithRect:(NSRect)r usingRows:(int)rowCnt andCols:(int)colCnt;

/*!
 This initialization method takes the real-space simulation origin and size
 as well as the number of rows and columns that will be used in the
 simulation grid. We'll initialize everything, allocate all the storage for
 the different constants and in general make sure that things are ready for
 the addition of simulation objects on the workspace. After that, it's a
 simulation call and you get the answers.
 */
- (id) initWithSize:(NSSize)size andOrigin:(NSPoint)p usingRows:(int)rowCnt andCols:(int)colCnt;

/*!
 This method clears out all the local storage that this instance has in
 it's use. This is nice because it allows us to clean things up nicely
 for a new init call or in the case of dealloc when we're getting cleaned
 up.
 */
- (void) freeAllStorage;

//----------------------------------------------------------------------------
//               Simulation Methods
//----------------------------------------------------------------------------

/*!
 This method can be called to clear out all the data for a simulation
 workspace. This will remove all the objects in the workspace and act as
 if you did the Big Shake on the Etch-A-Sketch.
 */
- (void) clearWorkspace;

/*!
 This method will take the existing workspace with all the objects placed
 on it and simulate it for the potential at each simulation grid point.
 This needs to be done before you can get any values out of the workspace,
 but that's pretty obvious if you think about it.
 */
- (BOOL) simulateWorkspace;

/*!
 This method gets the magnitude of the simulated electric field at the
 point in the simulation grid indicated by the integer values of the
 passed-in point. This is nice if you're only really interested in the
 magnitude at the point and don't want to convert the entire space or
 don't care about the direction of the field vector.
 */
- (double) getResultantElectricFieldMagnitudeAtNode:(NSPoint)p;

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
- (double) getResultantElectricFieldMagnitudeAtNodeRow:(int)r andCol:(int)c;

/*!
 This method gets the direction in degrees of the unit circle of the
 simulated electric field at the point in the simulation grid indicated
 by the integer values of the passed-in point. This is nice if you're
 only really interested in the direction at the point and don't want to
 convert the entire space or don't care about the magnitude of the field
 vector.
 */
- (double) getResultantElectricFieldDirectionAtNode:(NSPoint)p;

/*!
 This method gets the direction in radians of the unit circle of the
 simulated electric field at the row and column in the simulation grid
 indicated by the integer values passed-in. This is nice if you're
 only really interested in the direction at the point and don't want to
 convert the entire space or don't care about the magnitude of the field
 vector.
 */
- (double) getResultantElectricFieldDirectionAtNodeRow:(int)r andCol:(int)c;

//----------------------------------------------------------------------------
//               NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method is called by the runtime when the released object is about
 to get cleaned up. This gives us an opportunity to clean up all the
 memory we're using at the time and be a good citizen.
 */
- (void) dealloc;

@end
