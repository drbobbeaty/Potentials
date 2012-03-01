//
//  PointSimObj.m
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
#import "PointSimObj.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class PointSimObj
 This class is basically the BaseSimObj in that it's a simple point in
 the simulation occupying only a single simulation node - a point source.
 Most of the functionality for this class comes from the superclass,
 but there are a few convenience methods that are in this class.
 */
@implementation PointSimObj

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the location of the point in the real-space coordinate
 system of the workspace. This is a convenience method to the BaseSimObj,
 but is nice for those times where it's more appropriate.
 */
- (void) setLocation:(NSPoint)p
{
	[self setCenter:p];
}


/*!
 This method returns the real-space cooordinates of the point.
 */
- (NSPoint) getLocation
{
	return [self getCenter];
}


/*!
 This method sets the real-space coordinate along the x-axis which is also
 the 'columns' in the simulation grid.
 */
- (void) setX:(float)x
{
	[self setCenterX:x];
}


/*!
 This method returns the real-space x-axis value of the point.
 */
- (float) getX
{
	return [self getCenterX];
}


/*!
 This method sets the real-space coordinate along the y-axis which is also
 the 'rows' in the simulation grid.
 */
- (void) setY:(float)y
{
	[self setCenterY:y];
}


/*!
 This method returns the real-space x-axis value of the point.
 */
- (float) getY
{
	return [self getCenterY];
}


//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------


//----------------------------------------------------------------------------
//               Workspace Methods
//----------------------------------------------------------------------------

@end
