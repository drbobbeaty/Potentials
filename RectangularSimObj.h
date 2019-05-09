//
//  RectangularSimObj.h
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
@interface RectangularSimObj : BaseSimObj {
	@private
	NSSize				_size;
}

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the size of the rectangular object. The components of
 the passed-in NSSize are saved in the instance's local size object
 so that this object isn't retained.
 */
- (void) setSize:(NSSize)size;

/*!
 This method returns the actual NSSize that represents the real-space
 size of the rectangular object that is modeled by this instance. Since
 this is not an object reference, but rather the actual values, there's
 no reason to retain this guy.
 */
- (NSSize) getSize;

/*!
 This method sets the current width of the object to the provided value.
 Because of the orientation of the rectangle, the width is always in
 the x-axis direction.
 */
- (void) setWidth:(float)w;

/*!
 This method gets the currently defined width of the object, as measured
 along the x-axis.
 */
- (float) getWidth;

/*!
 This method sets the current height of the object to the provided value.
 Because of the orientation of the rectangle, the height is always in
 the y-axis direction.
 */
- (void) setHeight:(float)h;

/*!
 This method gets the currently defined height of the object, as measured
 along the y-axis.
 */
- (float) getHeight;

//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes the rectangular object to be a solid, conductor
 with the voltage, v, and size in real-world coordinates, size. It
 calls heavily on the superclass' init method and simply builds up
 that functionality that's specific to the rectangular object.
 */
- (id) initAsConductorWithVoltage:(double)v withSize:(NSSize)size;

/*!
 This method initializes the rectangular object to be a solid, conductor
 with the voltage, v, and width and height in real-world coordinates, w and
 h. It calls heavily on the superclass' init method and simply builds up
 that functionality that's specific to the rectangular object.
 */
- (id) initAsConductorWithVoltage:(double)v withWidth:(float)w andHeight:(float)h;

/*!
 This method initializes the rectangular object to be a solid, dielectric
 with the relative dielectric constant, er, and size in real-world
 coordinates, size. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the rectangular
 object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er withSize:(NSSize)size;

/*!
 This method initializes the rectangular object to be a solid, dielectric
 with the relative dielectric constant, er, and width and height in
 real-world coordinates, w and h. It calls heavily on the superclass' init
 method and simply builds up that functionality that's specific to the
 rectangular object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er withWidth:(float)w andHeight:(float)h;

/*!
 This method initializes the rectangular object to be a solid, fixed
 charge sheet with the charge density, rho, and size in real-world
 coordinates, size. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the rectangular
 object.
 */
- (id) initAsChargeSheetWithRho:(double)rho withSize:(NSSize)size;

/*!
 This method initializes the rectangular object to be a solid, fixed
 charge sheet with the charge density, rho, and width and height in
 real-world coordinates, w and h. It calls heavily on the superclass'
 init method and simply builds up that functionality that's specific to
 the rectangular object.
 */
- (id) initAsChargeSheetWithRho:(double)rho withWidth:(float)w andHeight:(float)h;

/*!
 This method initializes the rectangular object to be a solid, conductor
 with the voltage, v, and size in real-world coordinates, size, centered
 at the point, p. It calls heavily on the superclass' init method and
 simply builds up that functionality that's specific to the rectangular
 object.
 */
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withSize:(NSSize)size;

/*!
 This method initializes the rectangular object to be a solid, conductor
 with the voltage, v, and width and height in real-world coordinates, w and
 h, centered at the point, p. It calls heavily on the superclass' init
 method and simply builds up that functionality that's specific to the
 rectangular object.
 */
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withWidth:(float)w andHeight:(float)h;

/*!
 This method initializes the rectangular object to be a solid, dielectric
 with the relative dielectric constant, er, and size in real-world
 coordinates, size, centered at point, p. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the rectangular object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withSize:(NSSize)size;

/*!
 This method initializes the rectangular object to be a solid, dielectric
 with the relative dielectric constant, er, and width and height in
 real-world coordinates, w and h, centered at point, p. It calls heavily
 on the superclass' init method and simply builds up that functionality
 that's specific to the rectangular object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withWidth:(float)w andHeight:(float)h;

/*!
 This method initializes the rectangular object to be a solid, fixed
 charge sheet with the charge density, rho, and size in real-world
 coordinates, size, centered at point, p. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the rectangular object.
 */
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withSize:(NSSize)size;

/*!
 This method initializes the rectangular object to be a solid, fixed
 charge sheet with the charge density, rho, and width and height in
 real-world coordinates, w and h, centered at the point, p. It calls
 heavily on the superclass' init method and simply builds up that
 functionality that's specific to the rectangular object.
 */
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withWidth:(float)w andHeight:(float)h;

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
