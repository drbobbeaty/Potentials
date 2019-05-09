//
//  PointSimObj.h
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

// Superclass Headers
#import "BaseSimObj.h"

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
@interface PointSimObj : BaseSimObj {
}

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the location of the point in the real-space coordinate
 system of the workspace. This is a convenience method to the BaseSimObj,
 but is nice for those times where it's more appropriate.
 */
- (void) setLocation:(NSPoint)p;

/*!
 This method returns the real-space cooordinates of the point.
 */
- (NSPoint) getLocation;

/*!
 This method sets the real-space coordinate along the x-axis which is also
 the 'columns' in the simulation grid.
 */
- (void) setX:(float)x;

/*!
 This method returns the real-space x-axis value of the point.
 */
- (float) getX;

/*!
 This method sets the real-space coordinate along the y-axis which is also
 the 'rows' in the simulation grid.
 */
- (void) setY:(float)y;

/*!
 This method returns the real-space x-axis value of the point.
 */
- (float) getY;

//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//               Workspace Methods
//----------------------------------------------------------------------------

/*!
 This method returns an NSDictionary with the Quartz 2D drawing data
 and keys to indicate *how* to draw that object. The axis measurements
 are normalized to [0..1] so that scaling this is very easy, and it's
 placed in the workspace so that as that region is drawn, this object
 is in the correct location. This is essential so that this guy can
 be drawn on the simulation results.
 */
- (NSDictionary*) drawingInfo:(SimWorkspace*)ws;

@end
