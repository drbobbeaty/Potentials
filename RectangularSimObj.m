//
//  RectangularSimObj.m
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 21 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// RCS Identification information
static char *rcsID = "$Id: RectangularSimObj.m,v 1.1 2008/08/07 20:32:58 drbob Exp $";
static void __AvoidCompilerWarning(void) { if(!rcsID)__AvoidCompilerWarning(); }

// Apple Headers

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "RectangularSimObj.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


@implementation RectangularSimObj
/*"
**	This class implements the basic rectangular simulation objects for the
**	application. The idea being that all rectangular objects - both hollow
**	and solid, are basically the same, and we can parameterize the differences
**	into conductors, dielectrics and charge sheets.
**
**	It's important to remember that a simulation object needs to be properly
**	set up and *then* added to the workspace, as the adding process creates
**	a 'snapshot' of the object in the workspace. This is useful in placing
**	many of a single item in different locations, or with different values,
**	but it does mean that care needs to be taken when placing objects on the
**	workspace as they are "frozen in time" at that point.
"*/

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

- (void) setSize:(NSSize)size
/*"
**	This method sets the size of the rectangular object. The components of
**	the passed-in NSSize are saved in the instance's local size object
**	so that this object isn't retained.
"*/
{
	_size.width = size.width;
	_size.height = size.height;
}


- (NSSize) getSize
/*"
**	This method returns the actual NSSize that represents the real-space
**	size of the rectangular object that is modeled by this instance. Since
**	this is not an object reference, but rather the actual values, there's
**	no reason to retain this guy.
"*/
{
	return _size;
}


- (void) setWidth:(float)w
/*"
**	This method sets the current width of the object to the provided value.
**	Because of the orientation of the rectangle, the width is always in
**	the x-axis direction.
"*/
{
	_size.width = w;
}


- (float) getWidth
/*"
**	This method gets the currently defined width of the object, as measured
**	along the x-axis.
"*/
{
	return _size.width;
}


- (void) setHeight:(float)h
/*"
**	This method sets the current height of the object to the provided value.
**	Because of the orientation of the rectangle, the height is always in
**	the y-axis direction.
"*/
{
	_size.height = h;
}


- (float) getHeight
/*"
**	This method gets the currently defined height of the object, as measured
**	along the y-axis.
"*/
{
	return _size.height;
}


//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

- (id) initAsConductorWithVoltage:(double)v withSize:(NSSize)size
/*"
**	This method initializes the rectangular object to be a solid, conductor
**	with the voltage, v, and size in real-world coordinates, size. It
**	calls heavily on the superclass' init method and simply builds up
**	that functionality that's specific to the rectangular object.
"*/
{
	if (self = [super initAsConductorWithVoltage:v]) {
		[self setSize:size];
	}
	return self;
}


- (id) initAsConductorWithVoltage:(double)v withWidth:(float)w andHeight:(float)h
/*"
**	This method initializes the rectangular object to be a solid, conductor
**	with the voltage, v, and width and height in real-world coordinates, w and
**	h. It calls heavily on the superclass' init method and simply builds up
**	that functionality that's specific to the rectangular object.
"*/
{
	if (self = [super initAsConductorWithVoltage:v]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


- (id) initAsDielectricWithEpsilonR:(double)er withSize:(NSSize)size
/*"
**	This method initializes the rectangular object to be a solid, dielectric
**	with the relative dielectric constant, er, and size in real-world
**	coordinates, size. It calls heavily on the superclass' init method and
**	simply builds up that functionality that's specific to the rectangular
**	object.
"*/
{
	if (self = [super initAsDielectricWithEpsilonR:er]) {
		[self setSize:size];
	}
	return self;
}


- (id) initAsDielectricWithEpsilonR:(double)er withWidth:(float)w andHeight:(float)h
/*"
**	This method initializes the rectangular object to be a solid, dielectric
**	with the relative dielectric constant, er, and width and height in
**	real-world coordinates, w and h. It calls heavily on the superclass' init
**	method and simply builds up that functionality that's specific to the
**	rectangular object.
"*/
{
	if (self = [super initAsDielectricWithEpsilonR:er]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


- (id) initAsChargeSheetWithRho:(double)rho withSize:(NSSize)size
/*"
**	This method initializes the rectangular object to be a solid, fixed
**	charge sheet with the charge density, rho, and size in real-world
**	coordinates, size. It calls heavily on the superclass' init method and
**	simply builds up that functionality that's specific to the rectangular
**	object.
"*/
{
	if (self = [super initAsChargeSheetWithRho:rho]) {
		[self setSize:size];
	}
	return self;
}


- (id) initAsChargeSheetWithRho:(double)rho withWidth:(float)w andHeight:(float)h
/*"
**	This method initializes the rectangular object to be a solid, fixed
**	charge sheet with the charge density, rho, and width and height in
**	real-world coordinates, w and h. It calls heavily on the superclass'
**	init method and simply builds up that functionality that's specific to
**	the rectangular object.
"*/
{
	if (self = [super initAsChargeSheetWithRho:rho]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withSize:(NSSize)size
/*"
**	This method initializes the rectangular object to be a solid, conductor
**	with the voltage, v, and size in real-world coordinates, size, centered
**	at the point, p. It calls heavily on the superclass' init method and
**	simply builds up that functionality that's specific to the rectangular
**	object.
"*/
{
	if (self = [super initAsConductorWithVoltage:v at:p]) {
		[self setSize:size];
	}
	return self;
}


- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withWidth:(float)w andHeight:(float)h
/*"
**	This method initializes the rectangular object to be a solid, conductor
**	with the voltage, v, and width and height in real-world coordinates, w and
**	h, centered at the point, p. It calls heavily on the superclass' init
**	method and simply builds up that functionality that's specific to the
**	rectangular object.
"*/
{
	if (self = [super initAsConductorWithVoltage:v at:p]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withSize:(NSSize)size
/*"
**	This method initializes the rectangular object to be a solid, dielectric
**	with the relative dielectric constant, er, and size in real-world
**	coordinates, size, centered at point, p. It calls heavily on the
**	superclass' init method and simply builds up that functionality that's
**	specific to the rectangular object.
"*/
{
	if (self = [super initAsDielectricWithEpsilonR:er at:p]) {
		[self setSize:size];
	}
	return self;
}


- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withWidth:(float)w andHeight:(float)h
/*"
**	This method initializes the rectangular object to be a solid, dielectric
**	with the relative dielectric constant, er, and width and height in
**	real-world coordinates, w and h, centered at point, p. It calls heavily
**	on the superclass' init method and simply builds up that functionality
**	that's specific to the rectangular object.
"*/
{
	if (self = [super initAsDielectricWithEpsilonR:er at:p]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withSize:(NSSize)size
/*"
**	This method initializes the rectangular object to be a solid, fixed
**	charge sheet with the charge density, rho, and size in real-world
**	coordinates, size, centered at point, p. It calls heavily on the
**	superclass' init method and simply builds up that functionality that's
**	specific to the rectangular object.
"*/
{
	if (self = [super initAsChargeSheetWithRho:rho at:p]) {
		[self setSize:size];
	}
	return self;
}


- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withWidth:(float)w andHeight:(float)h
/*"
**	This method initializes the rectangular object to be a solid, fixed
**	charge sheet with the charge density, rho, and width and height in
**	real-world coordinates, w and h, centered at the point, p. It calls
**	heavily on the superclass' init method and simply builds up that
**	functionality that's specific to the rectangular object.
"*/
{
	if (self = [super initAsChargeSheetWithRho:rho at:p]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


//----------------------------------------------------------------------------
//               Workspace Methods
//----------------------------------------------------------------------------

- (BOOL) addToWorkspace:(SimWorkspace*)ws
/*"
**	This method takes the existing rectangular object as it exists and places
**	a 'snapshot' of it on the supplied workspace based on it's coordinate
**	system and the parameters of this object. This is done so that this
**	object can then be "moved" and added again to the workspace in effect
**	creating a duplicate.
"*/
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
			NSLog(@"[RectangularSimObj -addToWorkspace:] - the passed-in workspace is nil and that means that there's nothing I can do. Please make sure the arguments to this method are not nil.");
		}
	}

	// next, get the bounding rectangle in the simulation grid coords
	if (!error && !allDone) {
		xlo = [ws getColForXValue:([self getCenterX] - [self getWidth]/2.0)];
		xhi = [ws getColForXValue:([self getCenterX] + [self getWidth]/2.0)];
		ylo = [ws getRowForYValue:([self getCenterY] - [self getHeight]/2.0)];
		yhi = [ws getRowForYValue:([self getCenterY] + [self getHeight]/2.0)];
		if (((xlo == -1) && (xhi == -1)) || ((ylo == -1) && (yhi == -1))) {
			// the object doesn't sit on the simulation grid at all!
			allDone = YES;
		}
	}

	/*
	 * OK... we need to know if this guy is solid. If it's not, then we
	 * simply draw the bordering lines as they appear in the workspace.
	 * If this guy is solid, then we need to do a little more work to
	 * get the actual size of the rectangle to "paint" on the workspace.
	 */
	if (!error && !allDone && [self isSolid]) {
		int			r = 0;
		int			c = 0;

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

		// now we can "paint" each node in the workspace grid
		for (r = ylo; !error && (r <= yhi); r++) {
			for (c = xlo; !error && (c <= xhi); c++) {
				if (![self addObjPropsToWorkspace:ws atNodeRow:r andCol:c]) {
					error = YES;
					NSLog(@"[RectangularSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this solid object, yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", r, c);
				}
			}
		}

		// now flag this as done
		allDone = YES;
	}

	/*
	 * If we are here, then it means that it's a hollow object and we need
	 * to treat it a little differently so that we don't have extra lines
	 * in the simulation that might mess things up.
	 */
	if (!error && !allDone) {
		int			i = 0;
		int			istart = 0;
		int			istop = 0;
		
		/*
		 * See if the left or right sides exists in the workspace
		 */
		if ((xlo >= 0) || (xhi >= 0)) {
			// assume a reasonable endpoints for the line
			istart = ylo;
			istop = yhi;
			// now correct the y-axis limits for the workspace
			if ((ylo == -1) && (yhi >= 0)) {
				istart = 0;
			} else if ((ylo >= 0) && (yhi == -1)) {
				istop = [ws getRowCount] - 1;
			}
			// now "paint" the line in the workspace
			for (i = istart; !error && (i <= istop); i++) {
				// see if the left side is "in play" on the workspace
				if ((xlo >= 0) && ![self addObjPropsToWorkspace:ws atNodeRow:i andCol:xlo]) {
					error = YES;
					NSLog(@"[RectangularSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this hollow object (left side), yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", i, xlo);
				}
				// see if the right side is "in play" on the workspace
				if ((xhi >= 0) && ![self addObjPropsToWorkspace:ws atNodeRow:i andCol:xhi]) {
					error = YES;
					NSLog(@"[RectangularSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this hollow object (right side), yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", i, xhi);
				}
			}
		}

		/*
		 * See if the top or bottom sides exists in the workspace
		 */
		if ((ylo >= 0) || (yhi >= 0)) {
			// assume a reasonable endpoints for the line
			istart = xlo;
			istop = xhi;
			// now correct the x-axis limits for the workspace
			if ((xlo == -1) && (xhi >= 0)) {
				istart = 0;
			} else if ((xlo >= 0) && (xhi == -1)) {
				istop = [ws getColCount] - 1;
			}
			// now "paint" the line in the workspace
			for (i = istart; !error && (i <= istop); i++) {
				// see if the top side is "in play" on the workspace
				if ((ylo >= 0) && ![self addObjPropsToWorkspace:ws atNodeRow:ylo andCol:i]) {
					error = YES;
					NSLog(@"[RectangularSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this hollow object (top side), yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", ylo, i);
				}
				// see if the bottom side is "in play" on the workspace
				if ((yhi >= 0) && ![self addObjPropsToWorkspace:ws atNodeRow:yhi andCol:i]) {
					error = YES;
					NSLog(@"[RectangularSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this hollow object (bottom side), yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", yhi, i);
				}
			}
		}

		// now flag this as done
		allDone = YES;
	}

	return !error;
}

@end
