//
//  PointSimObj.m
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 21 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// RCS Identification information
static char *rcsID = "$Id: PointSimObj.m,v 1.1 2008/08/07 20:32:58 drbob Exp $";
static void __AvoidCompilerWarning(void) { if(!rcsID)__AvoidCompilerWarning(); }

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


@implementation PointSimObj
/*"
**	This class is basically the BaseSimObj in that it's a simple point in
**	the simulation occupying only a single simulation node - a point source.
**	Most of the functionality for this class comes from the superclass,
**	but there are a few convenience methods that are in this class.
"*/

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

- (void) setLocation:(NSPoint)p
/*"
**	This method sets the location of the point in the real-space coordinate
**	system of the workspace. This is a convenience method to the BaseSimObj,
**	but is nice for those times where it's more appropriate.
"*/
{
	[self setCenter:p];
}


- (NSPoint) getLocation
/*"
**	This method returns the real-space cooordinates of the point.
"*/
{
	return [self getCenter];
}


- (void) setX:(float)x
/*"
**	This method sets the real-space coordinate along the x-axis which is also
**	the 'columns' in the simulation grid.
"*/
{
	[self setCenterX:x];
}


- (float) getX
/*"
**	This method returns the real-space x-axis value of the point.
"*/
{
	return [self getCenterX];
}


- (void) setY:(float)y
/*"
**	This method sets the real-space coordinate along the y-axis which is also
**	the 'rows' in the simulation grid.
"*/
{
	[self setCenterY:y];
}


- (float) getY
/*"
**	This method returns the real-space x-axis value of the point.
"*/
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
