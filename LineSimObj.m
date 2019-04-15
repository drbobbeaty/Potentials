//
//  LineSimObj.m
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
#import "LineSimObj.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class LinSimObj
 This class models a simple line in the workspace - one simulation grid
 'wide' from the starting point to the ending point. This happens to be
 implemented with the starting point being the BaseSimObj's "center" and
 the ending point being an instance variable of this method. This makes
 the movement of the line a little more difficult as we have to move both
 the starting point and the ending point. Anyway, this guy can be
 used for boundary conditions or as a line charge/voltage in the
 simulation.
 */
@implementation LineSimObj

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the starting point of the line which also turns out to
 be the "center" point of the BaseSimObj. This is just a simple convenience
 method that calls the -setCenter: method on the superclass.
 */
- (void) setStartPoint:(NSPoint)p
{
	[self setCenter:p];
}


/*!
 This method returns the 'starting' point of this line in the real-space
 coordinate system of the workspace. Of course, the notion of "starting"
 and ending points is arbitrary, but this will also be considered the
 'center' of the object and since we have to assign one of the two points
 as the starting point, we might as well make it this one.
 */
- (NSPoint) getStartPoint
{
	return [self getCenter];
}


/*!
 This method sets the real-space x-coordinate of the starting point to
 the provided value. This is useful when you simply need to relocate the
 x-value of the starting point to a fixed position.
 */
- (void) setStartPointX:(float)x
{
	[self setCenterX:x];
}


/*!
 This method gets the real-space x-coordinate of the starting point for
 the line. The convention for 'starting' vs. 'ending' is such that the
 "center" point for the BaseSimObj is the starting point, and the ending
 point is the other.
 */
- (float) getStartPointX
{
	return [self getCenterX];
}


/*!
 This method sets the real-space y-coordinate of the starting point to
 the provided value. This is useful when you simply need to relocate the
 y-value of the starting point to a fixed position.
 */
- (void) setStartPointY:(float)y
{
	[self setCenterY:y];
}


/*!
 This method gets the real-space y-coordinate of the starting point for
 the line. The convention for 'starting' vs. 'ending' is such that the
 "center" point for the BaseSimObj is the starting point, and the ending
 point is the other.
 */
- (float) getStartPointY
{
	return [self getCenterY];
}


/*!
 This method sets the ending point of the line to the real-space values
 provided by the argument.
 */
- (void) setEndPoint:(NSPoint)p
{
	_endPoint.x = p.x;
	_endPoint.y = p.y;
}


/*!
 This method returns the real-space ending point for the line as it's
 currently defined. In the beginning the ending point may not be
 defined by the user and so default to (0,0) or an indeterminate value.
 */
- (NSPoint) getEndPoint
{
	return _endPoint;
}


/*!
 This method sets the real-space x-coordinate of the ending point to
 the provided value. This is useful when you simply need to relocate the
 x-value of the ending point to a fixed position.
 */
- (void) setEndPointX:(float)x
{
	_endPoint.x = x;
}


/*!
 This method gets the real-space x-coordinate of the ending point for
 the line. The convention for 'starting' vs. 'ending' is such that the
 "center" point for the BaseSimObj is the starting point, and the ending
 point is the other.
 */
- (float) getEndPointX
{
	return _endPoint.x;
}


/*!
 This method sets the real-space y-coordinate of the ending point to
 the provided value. This is useful when you simply need to relocate the
 y-value of the ending point to a fixed position.
 */
- (void) setEndPointY:(float)y
{
	_endPoint.y = y;
}


/*!
 This method gets the real-space y-coordinate of the ending point for
 the line. The convention for 'starting' vs. 'ending' is such that the
 "center" point for the BaseSimObj is the starting point, and the ending
 point is the other.
 */
- (float) getEndPointY
{
	return _endPoint.y;
}


//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes the line object to be a solid, conductor
 with the voltage, v, starting at 'start' and continuing to 'end'
 in real-world coordinates. It calls heavily on the superclass' init
 method and simply builds up that functionality that's specific to the
 line object.
 */
- (id) initAsConductorWithVoltage:(double)v from:(NSPoint)start to:(NSPoint)end
{
	if (self = [super initAsConductorWithVoltage:v]) {
		[self setStartPoint:start];
		[self setEndPoint:end];
	}
	return self;
}


/*!
 This method initializes the line object to be a solid, dielectric
 with the relative dielectric constant, er, starting at 'start' and
 continuing to 'end' in real-world coordinates. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the line object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er from:(NSPoint)start to:(NSPoint)end
{
	if (self = [super initAsDielectricWithEpsilonR:er]) {
		[self setStartPoint:start];
		[self setEndPoint:end];
	}
	return self;
}


/*!
 This method initializes the line object to be a solid, fixed
 charge sheet with the charge density, rho, starting at 'start' and
 continuing to 'end' in real-world coordinates. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the line object.
 */
- (id) initAsChargeSheetWithRho:(double)rho from:(NSPoint)start to:(NSPoint)end
{
	if (self = [super initAsChargeSheetWithRho:rho]) {
		[self setStartPoint:start];
		[self setEndPoint:end];
	}
	return self;
}


//----------------------------------------------------------------------------
//               Simple Movement Methods
//----------------------------------------------------------------------------

/*!
 Because this object is a little different that the others, we need to be
 careful about how this guy is moved around on the workspace. We need to
 move both the starting point and the ending point. We do this by moving
 the "center" of the object (the starting point) and then move the ending
 point. Not hard, but it's important to remember the relationships between
 the points and the "center".
 */
- (void) moveRelative:(NSPoint)delta
{
	[super moveRelative:delta];
	_endPoint.x += delta.x;
	_endPoint.y += delta.y;
}


/*!
 Because this object is a little different that the others, we need to be
 careful about how this guy is moved around on the workspace. We need to
 move both the starting point and the ending point. We do this by moving
 the "center" of the object (the starting point) and then move the ending
 point. Not hard, but it's important to remember the relationships between
 the points and the "center".
 */
- (void) moveRelativeX:(float)deltaX Y:(float)deltaY
{
	[super moveRelativeX:deltaX Y:deltaY];
	_endPoint.x += deltaX;
	_endPoint.y += deltaY;
}


//----------------------------------------------------------------------------
//               Workspace Methods
//----------------------------------------------------------------------------

/*!
 This method takes the existing line object as it exists and places
 a 'snapshot' of it on the supplied workspace based on it's coordinate
 system and the parameters of this object. This is done so that this
 object can then be "moved" and added again to the workspace in effect
 creating a duplicate.
 */
- (BOOL) addToWorkspace:(SimWorkspace*)ws
{
	BOOL		error = NO;
	BOOL		allDone = NO;
	// these are for the Cohen-Sutherland algorithm
	NSPoint		zero = { .x = 0, .y = 0 };
	CODE		zeroCode = 0;
	NSPoint		one = { .x = 0, .y = 0 };
	CODE		oneCode = 0;
	CODE		c = 0;
	float		x = 0.0;
	float		y = 0.0;
	float		xmin = -1.0;
	float		xmax = -1.0;
	float		ymin = -1.0;
	float		ymax = -1.0;
	
	// first, make sure we have something to do
	if (!error && !allDone) {
		if (ws == nil) {
			error = YES;
			NSLog(@"[LineSimObj -addToWorkspace:] - the passed-in workspace is nil and that means that there's nothing I can do. Please make sure the arguments to this method are not nil.");
		} else {
			// get the limits of the clipping rectangle from the workspace
			xmin = [ws getWorkspaceOrigin].x;
			xmax = xmin + [ws getWorkspaceSize].width;
			ymin = [ws getWorkspaceOrigin].y;
			ymax = ymin + [ws getWorkspaceSize].height;
		}
	}

	/*
	 * Next, we need to copy the endpoints of this line to temp variables
	 * as we'll possibly be moving them to lie totally within the clipping
	 * region. While we're at it, let's get the initial codes for each
	 * point as well.
	 */
	if (!error && !allDone) {
		// get the starting and ending points in real-space coordinates
		zero = [self getStartPoint];
		one = [self getEndPoint];
		// now get their code w.r.t. the workspace
		zeroCode = [self computeCSCodeFor:zero in:ws];
		oneCode = [self computeCSCodeFor:one in:ws];
	}

	/*
	 * This is the main processing of the Cohen-Sutherland algorithm.
	 * The line endpoints are checked for complete inclusion, or exclusion
	 * and if neither is the case, then the lines are pushed towards the
	 * clipping boundary and rechecked. It's really pretty neat.
	 */
	while (!error && !allDone) {
		// check for the inclusion of both ends in the clipping rectangle
		if ((zeroCode | oneCode) == 0) {
			break;
		}

		// check for the exclusion of both ends from the rectangle
		if ((zeroCode & oneCode) != 0) {
			allDone = YES;
			break;
		}

		// typical case - clip end outside rectangle
		c = zeroCode ? zeroCode : oneCode;
		if (c & TOP) {
			x = zero.x + (one.x - zero.x) * (ymax - zero.y) / (one.y - zero.y);
			y = ymax;
		} else if (c & BOTTOM) {
			x = zero.x + (one.x - zero.x) * (ymin - zero.y) / (one.y - zero.y);
			y = ymin;
		} else if (c & RIGHT) {
			x = xmax;
			y = zero.y + (one.y - zero.y) * (xmax - zero.x) / (one.x - zero.x);
		} else {
			x = xmin;
			y = zero.y + (one.y - zero.y) * (xmin - zero.x) / (one.x - zero.x);
		}

		// set the new end point and iterate again
		if (c == zeroCode) {
			zero.x = x;
			zero.y = y;
			zeroCode = [self computeCSCodeFor:zero in:ws];
		} else {
			one.x = x;
			one.y = y;
			oneCode = [self computeCSCodeFor:one in:ws];
		}
	}

	/*
	 * Next, convert the endpoints in the simulation grid coords and
	 * then determine which axis needs to be stepped through. The problem
	 * is that for slopes < 1, we need to increment x, and for slopes > 1
	 * we need to increment y. This is because we don't want any gaps in
	 * the line from incrementing the slower moving values.
	 */
	if (!error && !allDone) {
		float		slope = 0;

		// convert the real-space values to simulation grid coordinates
		zero.x = [ws getColForXValue:zero.x];
		zero.y = [ws getRowForYValue:zero.y];
		one.x = [ws getColForXValue:one.x];
		one.y = [ws getRowForYValue:one.y];
		// now see which axis has the greater movement
		if (fabs(zero.x - one.x) > fabs(zero.y - one.y)) {
			int			r = 0;
			int			c = 0;
			/*
			 * OK... we need to step x from low to high and calculate the
			 * corresponding values of y from the equation for a line.
			 */
			// first make sure that the zero point is less than the one point
			if (zero.x > one.x) {
				float tx = zero.x;
				float ty = zero.y;
				zero.x = one.x;
				zero.y = one.y;
				one.x = tx;
				one.y = ty;
			}
			// calculate the linear slope of the line
			slope = (one.y - zero.y)/(one.x - zero.x);
			// now scan from zero to one on the x-axis
			for (c = zero.x; !error && !allDone && (c <= one.x); c++) {
				// compute the row that this point should appear on
				r = slope * (c - zero.x) + zero.y;
				// ...and then paint it there
				if (![self addObjPropsToWorkspace:ws atNodeRow:r andCol:c]) {
					error = YES;
					NSLog(@"[LineSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this x-axis incrementing line object, yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", r, c);
				}
			}
		} else {
			int			r = 0;
			int			c = 0;
			/*
			 * OK... we need to step y from low to high and calculate the
			 * corresponding values of x from the equation for a line.
			 */
			// first make sure that the zero point is less than the one point
			if (zero.y > one.y) {
				float tx = zero.x;
				float ty = zero.y;
				zero.x = one.x;
				zero.y = one.y;
				one.x = tx;
				one.y = ty;
			}
			// calculate the inverse linear slope of the line
			slope = (one.x - zero.x)/(one.y - zero.y);
			// now scan from zero to one on the y-axis
			for (r = zero.y; !error && !allDone && (r <= one.y); r++) {
				// compute the column that this point should appear on
				c = slope * (r - zero.y) + zero.x;
				// ...and then paint it there
				if (![self addObjPropsToWorkspace:ws atNodeRow:r andCol:c]) {
					error = YES;
					NSLog(@"[LineSimObj -addToWorkspace:] - the point at (row,col): (%d,%d) was supposed to be part of this y-axis incrementing line object, yet when I tried to set it's values on the workspace an error occurred. Please check the logs for a possible cause.", r, c);
				}
			}
		}
	}

	return !error;	
}


/*!
 This method is a part of the Cohen-Sutherland line clipping code which
 is very efficient at clipping the provided line in the viewing window.
 for our use, this viewing window is always a SimWorkspace, and the line
 being clipped is this object's instance itself. It's clipped in the
 real-world coordinates, and then those are converted into simulation
 grid nodes for further use.
 */
- (CODE) computeCSCodeFor:(NSPoint)p in:(SimWorkspace*)ws
{
	BOOL			error = NO;
	CODE			retval = 0;

	// make sure we have something to do
	if (!error) {
		if (ws == nil) {
			error = YES;
			NSLog(@"[LineSimObj -computeCSCodeFor:in:] - the passed-in workspace is nil and that means that there's nothing I can do. Please make sure the arguments to this method are not nil.");
		}
	}

	/*
	 * The method says to codify the point based on the relative placement
	 * of the point w.r.t. the rectangle. These codes are bit-wise and
	 * additive with an 'or' function.
	 */
	if (!error) {
		if (p.y > ([ws getWorkspaceOrigin].y + [ws getWorkspaceSize].height)) {
			retval |= TOP;
		} else if (p.y < [ws getWorkspaceOrigin].y) {
			retval |= BOTTOM;
		}
		if (p.x > ([ws getWorkspaceOrigin].x + [ws getWorkspaceSize].width)) {
			retval |= RIGHT;
		} else if (p.x < [ws getWorkspaceOrigin].x) {
			retval |= LEFT;
		}
	}
	
	return retval;
}

@end
