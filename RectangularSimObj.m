//
//  RectangularSimObj.m
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
#import "RectangularSimObj.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class RectangularSimObj
 This class implements the basic rectangular simulation objects for the
 application. The idea being that all rectangular objects - both hollow
 and solid, are basically the same, and we can parameterize the differences
 into conductors, dielectrics and charge sheets.
 
 It's important to remember that a simulation object needs to be properly
 set up and *then* added to the workspace, as the adding process creates
 a 'snapshot' of the object in the workspace. This is useful in placing
 many of a single item in different locations, or with different values,
 but it does mean that care needs to be taken when placing objects on the
 workspace as they are "frozen in time" at that point.
 */
@implementation RectangularSimObj

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the size of the rectangular object. The components of
 the passed-in NSSize are saved in the instance's local size object
 so that this object isn't retained.
 */
- (void) setSize:(NSSize)size
{
	_size.width = size.width;
	_size.height = size.height;
}


/*!
 This method returns the actual NSSize that represents the real-space
 size of the rectangular object that is modeled by this instance. Since
 this is not an object reference, but rather the actual values, there's
 no reason to retain this guy.
 */
- (NSSize) getSize
{
	return _size;
}


/*!
 This method sets the current width of the object to the provided value.
 Because of the orientation of the rectangle, the width is always in
 the x-axis direction.
 */
- (void) setWidth:(float)w
{
	_size.width = w;
}


/*!
 This method gets the currently defined width of the object, as measured
 along the x-axis.
 */
- (float) getWidth
{
	return _size.width;
}


/*!
 This method sets the current height of the object to the provided value.
 Because of the orientation of the rectangle, the height is always in
 the y-axis direction.
 */
- (void) setHeight:(float)h
{
	_size.height = h;
}


/*!
 This method gets the currently defined height of the object, as measured
 along the y-axis.
 */
- (float) getHeight
{
	return _size.height;
}


//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes the rectangular object to be a solid, conductor
 with the voltage, v, and size in real-world coordinates, size. It
 calls heavily on the superclass' init method and simply builds up
 that functionality that's specific to the rectangular object.
 */
- (id) initAsConductorWithVoltage:(double)v withSize:(NSSize)size
{
	if (self = [super initAsConductorWithVoltage:v]) {
		[self setSize:size];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, conductor
 with the voltage, v, and width and height in real-world coordinates, w and
 h. It calls heavily on the superclass' init method and simply builds up
 that functionality that's specific to the rectangular object.
 */
- (id) initAsConductorWithVoltage:(double)v withWidth:(float)w andHeight:(float)h
{
	if (self = [super initAsConductorWithVoltage:v]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, dielectric
 with the relative dielectric constant, er, and size in real-world
 coordinates, size. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the rectangular
 object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er withSize:(NSSize)size
{
	if (self = [super initAsDielectricWithEpsilonR:er]) {
		[self setSize:size];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, dielectric
 with the relative dielectric constant, er, and width and height in
 real-world coordinates, w and h. It calls heavily on the superclass' init
 method and simply builds up that functionality that's specific to the
 rectangular object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er withWidth:(float)w andHeight:(float)h
{
	if (self = [super initAsDielectricWithEpsilonR:er]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, fixed
 charge sheet with the charge density, rho, and size in real-world
 coordinates, size. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the rectangular
 object.
 */
- (id) initAsChargeSheetWithRho:(double)rho withSize:(NSSize)size
{
	if (self = [super initAsChargeSheetWithRho:rho]) {
		[self setSize:size];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, fixed
 charge sheet with the charge density, rho, and width and height in
 real-world coordinates, w and h. It calls heavily on the superclass'
 init method and simply builds up that functionality that's specific to
 the rectangular object.
 */
- (id) initAsChargeSheetWithRho:(double)rho withWidth:(float)w andHeight:(float)h
{
	if (self = [super initAsChargeSheetWithRho:rho]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, conductor
 with the voltage, v, and size in real-world coordinates, size, centered
 at the point, p. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the rectangular
 object.
 */
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withSize:(NSSize)size
{
	if (self = [super initAsConductorWithVoltage:v at:p]) {
		[self setSize:size];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, conductor
 with the voltage, v, and width and height in real-world coordinates, w and
 h, centered at the point, p. It calls heavily on the superclass' init
 method and simply builds up that functionality that's specific to the
 rectangular object.
 */
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withWidth:(float)w andHeight:(float)h
{
	if (self = [super initAsConductorWithVoltage:v at:p]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, dielectric
 with the relative dielectric constant, er, and size in real-world
 coordinates, size, centered at point, p. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the rectangular object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withSize:(NSSize)size
{
	if (self = [super initAsDielectricWithEpsilonR:er at:p]) {
		[self setSize:size];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, dielectric
 with the relative dielectric constant, er, and width and height in
 real-world coordinates, w and h, centered at point, p. It calls heavily
 on the superclass' init method and simply builds up that functionality
 that's specific to the rectangular object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withWidth:(float)w andHeight:(float)h
{
	if (self = [super initAsDielectricWithEpsilonR:er at:p]) {
		[self setWidth:w];
		[self setHeight:h];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, fixed
 charge sheet with the charge density, rho, and size in real-world
 coordinates, size, centered at point, p. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the rectangular object.
 */
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withSize:(NSSize)size
{
	if (self = [super initAsChargeSheetWithRho:rho at:p]) {
		[self setSize:size];
	}
	return self;
}


/*!
 This method initializes the rectangular object to be a solid, fixed
 charge sheet with the charge density, rho, and width and height in
 real-world coordinates, w and h, centered at the point, p. It calls
 heavily on the superclass' init method and simply builds up that
 functionality that's specific to the rectangular object.
 */
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withWidth:(float)w andHeight:(float)h
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

/*!
 This method takes the existing rectangular object as it exists and places
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
	if (!error && !allDone) {
		// correct the x-axis first
		xlo = (xlo < 0 ? 0 : xlo);
		xhi = (xhi < 0 ? ([ws getColCount] - 1) : xhi);
		// now correct the y-axis
		ylo = (ylo < 0 ? 0 : ylo);
		yhi = (yhi < 0 ? ([ws getRowCount] - 1) : yhi);

		// now we can "paint" each node in the workspace grid
		for (int r = ylo; !error && (r <= yhi); r++) {
			for (int c = xlo; !error && (c <= xhi); c++) {
				if ((r == ylo) || (r == yhi-1) || (c == xlo) || (c == xhi-1) || [self isSolid]) {
					if (![self addObjPropsToWorkspace:ws atNodeRow:r andCol:c]) {
						error = YES;
						NSLog(@"[RectangularSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this object, yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", r, c);
					}
				}
			}
		}

		// now flag this as done
		allDone = YES;
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
		rect.size = [self getSize];
		// move the center of the rect to the origin for the NSRect
		rect.origin = [self getLocation];
		rect.origin.x -= rect.size.width/2.0;
		rect.origin.y -= rect.size.height/2.0;
		// map the point to [0..1] on each axis for plotting
		rect.origin.x = (rect.origin.x - wsr.origin.x)/wsr.size.width;
		rect.origin.y = (rect.origin.y - wsr.origin.y)/wsr.size.height;
		rect.size.width /= wsr.size.width;
		rect.size.height /= wsr.size.height;
		return @{@"draw" : @"rect",
				 @"data" : [NSValue valueWithRect:rect]};
	}
	// there's nothing we can possibly do without a workspace
	return nil;
}

@end
