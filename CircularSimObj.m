//
//  CircularSimObj.m
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 21 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers

// System Headers
#import <math.h>

// Third Party Headers

// Other Headers

// Class Headers
#import "CircularSimObj.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class CircularSimObj
 This class implements the basic circular simulation objects for the
 application. The idea being that all circular objects - both hollow
 and solid, are basically the same, and we can parameterize the differences
 into conductors, dielectrics and charge sheets.
 
 It's important to remember that a simulation object needs to be properly
 set up and *then* added to the workspace, as the adding process creates
 a 'snapshot' of the object in the workspace. This is useful in placing
 many of a single item in different locations, or with different values,
 but it does mean that care needs to be taken when placing objects on the
 workspace as they are "frozen in time" at that point.
 */
@implementation CircularSimObj

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the radius of the circular object to the "real world"
 measurement 'r'. This is important as the simulation workspace will have
 a "real world" coordinate system as well as the simulation grid that
 needs to be considered.
 */
- (void) setRadius:(float)r
{
	_radius = r;
}


/*!
 This method gets the "real world" radius of this circular object so
 that something can be done with it. Certainly, this will be used in the
 -addToWorkspace: method, but there are also other possible uses.
 */
- (float) getRadius
{
	return _radius;
}


//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes the circular object to be a solid, conductor
 with the voltage, v, and radius in real-world coordinates, r. It
 calls heavily on the superclass' init method and simply builds up
 that functionality that's specific to the circular object.
 */
- (id) initAsConductorWithVoltage:(double)v withRadius:(float)r
{
	if (self = [super initAsConductorWithVoltage:v]) {
		[self setRadius:r];
	}
	return self;
}


/*!
 This method initializes the circular object to be a solid, dielectric
 with the relative dielectric constant, er, and radius in real-world
 coordinates, r. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the circular
 object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er withRadius:(float)r
{
	if (self = [super initAsDielectricWithEpsilonR:er]) {
		[self setRadius:r];
	}
	return self;
}


/*!
 This method initializes the circular object to be a solid, fixed
 charge sheet with the charge density, rho, and radius in real-world
 coordinates, r. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the circular
 object.
 */
- (id) initAsChargeSheetWithRho:(double)rho withRadius:(float)r
{
	if (self = [super initAsChargeSheetWithRho:rho]) {
		[self setRadius:r];
	}
	return self;
}


/*!
 This method initializes the circular object to be a solid, conductor
 with the voltage, v, and radius in real-world coordinates, r, centered
 at the point, p. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the circular
 object.
 */
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withRadius:(float)r
{
	if (self = [super initAsConductorWithVoltage:v at:p]) {
		[self setRadius:r];
	}
	return self;
}


/*!
 This method initializes the circular object to be a solid, dielectric
 with the relative dielectric constant, er, and radius in real-world
 coordinates, r, centered at the point, p. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the circular object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withRadius:(float)r
{
	if (self = [super initAsDielectricWithEpsilonR:er at:p]) {
		[self setRadius:r];
	}
	return self;
}


/*!
 This method initializes the circular object to be a solid, fixed
 charge sheet with the charge density, rho, and radius in real-world
 coordinates, r, centered at the point, p. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the circular object.
 */
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withRadius:(float)r
{
	if (self = [super initAsChargeSheetWithRho:rho at:p]) {
		[self setRadius:r];
	}
	return self;
}


//----------------------------------------------------------------------------
//               Workspace Methods
//----------------------------------------------------------------------------

/*!
 This method takes the existing circular object as it exists and places
 a 'snapshot' of it on the supplied workspace based on it's coordinate
 system and the parameters of this object. This is done so that this
 object can then be "moved" and added again to the workspace in effect
 creating a duplicate.
 */
- (BOOL) addToWorkspace:(SimWorkspace*)ws
{
	BOOL			error = NO;
	BOOL			allDone = NO;
	int				xlo = -1;
	int				xhi = -1;
	int				ylo = -1;
	int				yhi = -1;

	// first, make sure we have something to do
	if (!error && !allDone) {
		if (ws == nil) {
			error = YES;
			NSLog(@"[CircularSimObj -addToWorkspace:] - the passed-in workspace is nil and that means that there's nothing I can do. Please make sure the arguments to this method are not nil.");
		}
	}

	// next, get the bounding rectangle in the simulation grid coords
	if (!error && !allDone) {
		xlo = [ws getColForXValue:([self getCenterX] - [self getRadius])];
		xhi = [ws getColForXValue:([self getCenterX] + [self getRadius])];
		ylo = [ws getRowForYValue:([self getCenterY] - [self getRadius])];
		yhi = [ws getRowForYValue:([self getCenterY] + [self getRadius])];
		if (((xlo == -1) && (xhi == -1)) || ((ylo == -1) && (yhi == -1))) {
			// the circle doesn't sit on the simulation grid at all!
			allDone = YES;
		}
	}

	// next, correct for the actual simulation grid values
	if (!error && !allDone) {
		// correct the x-axis first
		if ((xlo == -1) && (xhi >= 0)) {
			xlo = 0;
		} else if ((xlo >= 0) && (xhi == -1)) {
			xhi = [ws getColCount] - 1;
		}
		// now correct the y-axis
		if ((ylo == -1) && (yhi >= 0)) {
			ylo = 0;
		} else if ((ylo >= 0) && (yhi == -1)) {
			yhi = [ws getRowCount] - 1;
		}
	}

	/*
	 * OK... now we need to test each of these points in the bounding
	 * rectangle to see if it should be 'painted' as part of the circle.
	 * If it's hollow, be sure to just paint the perimeter.
	 */
	if (!error && !allDone) {
		int			r = 0;
		int			c = 0;
		float		x = 0.0;
		float		y = 0.0;
		// get the center's location for speedy access
		float		xc = [self getCenterX];
		float		yc = [self getCenterY];
		// precompute the squared radii that define the 'painting'
		float		r2hi = [self getRadius] * [self getRadius];
		float		r2lo = ([self isSolid] ? -1.0 : ([self getRadius] - 2.0*MAX([ws getDeltaX], [ws getDeltaY]))*([self getRadius] - 2.0*MAX([ws getDeltaX], [ws getDeltaY])));
		// now go through all the points checking each one
		for (r = ylo; !error && (r <= yhi); r++) {
			for (c = xlo; !error && (c <= xhi); c++) {
				// convert these values into real-world coordinates
				x = [ws getXValueForCol:c] - xc;
				y = [ws getYValueForRow:r] - yc;

				// skip this point if it's illegal (shouldn't be, though)
				if (isnan(x) || isnan(y)) {
					continue;
				}

				// see if we should be painting this point
				if (((x*x + y*y) <= r2hi) && ((x*x + y*y) >= r2lo)) {
					if (![self addObjPropsToWorkspace:ws atNodeRow:r andCol:c]) {
						error = YES;
						NSLog(@"[CircularSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this object, yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", r, c);
					}
				}
			}
		}
	}

	return !error;
}


/*!
 This method returns an NSDictionary with the Quartz 2D drawing data
 and keys to indicate *how* to draw that object. The axis measurements
 are normalized to [0..1] so that scaling this is very easy, and it's
 placed in the workspace so that as that region is drawn, this object
 is in the correct location. This is essential so that this guy can
 be drawn on the simulation results.
 */
- (NSDictionary*) drawingInfo:(SimWorkspace*)ws
{
	if (ws != nil) {
		NSRect		wsr = [ws getWorkspaceRect];
		NSRect		rect;
		rect.origin = [self getLocation];
		CGFloat 	r = [self getRadius];
		rect.origin.x -= r;
		rect.origin.y -= r;
		rect.size.width = 2.0 * r;
		rect.size.height = 2.0 * r;
		// map the point to [0..1] on each axis for plotting
		rect.origin.x = (rect.origin.x - wsr.origin.x)/wsr.size.width;
		rect.origin.y = (rect.origin.y - wsr.origin.y)/wsr.size.height;
		rect.size.width /= wsr.size.width;
		rect.size.height /= wsr.size.height;
		return @{@"draw" : @"circle",
				 @"data" : [NSValue valueWithRect:rect]};
	}
	// there's nothing we can possibly do without a workspace
	return nil;
}

@end
