//
//  CircularSimObj.h
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
@interface CircularSimObj : BaseSimObj {
	@private
	float			_radius;
}

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the radius of the circular object to the "real world"
 measurement 'r'. This is important as the simulation workspace will have
 a "real world" coordinate system as well as the simulation grid that
 needs to be considered.
 */
- (void) setRadius:(float)r;

/*!
 This method gets the "real world" radius of this circular object so
 that something can be done with it. Certainly, this will be used in the
 -addToWorkspace: method, but there are also other possible uses.
 */
- (float) getRadius;

//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes the circular object to be a solid, conductor
 with the voltage, v, and radius in real-world coordinates, r. It
 calls heavily on the superclass' init method and simply builds up
 that functionality that's specific to the circular object.
 */
- (id) initAsConductorWithVoltage:(double)v withRadius:(float)r;

/*!
 This method initializes the circular object to be a solid, dielectric
 with the relative dielectric constant, er, and radius in real-world
 coordinates, r. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the circular
 object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er withRadius:(float)r;

/*!
 This method initializes the circular object to be a solid, fixed
 charge sheet with the charge density, rho, and radius in real-world
 coordinates, r. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the circular
 object.
 */
- (id) initAsChargeSheetWithRho:(double)rho withRadius:(float)r;

/*!
 This method initializes the circular object to be a solid, conductor
 with the voltage, v, and radius in real-world coordinates, r, centered
 at the point, p. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the circular
 object.
 */
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withRadius:(float)r;

/*!
 This method initializes the circular object to be a solid, dielectric
 with the relative dielectric constant, er, and radius in real-world
 coordinates, r, centered at the point, p. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the circular object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withRadius:(float)r;

/*!
 This method initializes the circular object to be a solid, fixed
 charge sheet with the charge density, rho, and radius in real-world
 coordinates, r, centered at the point, p. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the circular object.
 */
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withRadius:(float)r;

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
- (BOOL) addToWorkspace:(SimWorkspace*)ws;

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
