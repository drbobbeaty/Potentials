//
//  LineSimObj.h
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
/*
 * In implementing the Cohen-Sutherland line clipping code, we need to
 * have a definition of the code assigned to each of the endpoints of
 * the line.
 */
typedef unsigned int CODE;
enum {
	TOP = 0x1, BOTTOM = 0x2, RIGHT = 0x4, LEFT = 0x8
};

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
@interface LineSimObj : BaseSimObj {
	@private
	NSPoint			_endPoint;
}

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the starting point of the line which also turns out to
 be the "center" point of the BaseSimObj. This is just a simple convenience
 method that calls the -setCenter: method on the superclass.
 */
- (void) setStartPoint:(NSPoint)p;

/*!
 This method returns the 'starting' point of this line in the real-space
 coordinate system of the workspace. Of course, the notion of "starting"
 and ending points is arbitrary, but this will also be considered the
 'center' of the object and since we have to assign one of the two points
 as the starting point, we might as well make it this one.
 */
- (NSPoint) getStartPoint;

/*!
 This method sets the real-space x-coordinate of the starting point to
 the provided value. This is useful when you simply need to relocate the
 x-value of the starting point to a fixed position.
 */
- (void) setStartPointX:(float)x;

/*!
 This method gets the real-space x-coordinate of the starting point for
 the line. The convention for 'starting' vs. 'ending' is such that the
 "center" point for the BaseSimObj is the starting point, and the ending
 point is the other.
 */
- (float) getStartPointX;

/*!
 This method sets the real-space y-coordinate of the starting point to
 the provided value. This is useful when you simply need to relocate the
 y-value of the starting point to a fixed position.
 */
- (void) setStartPointY:(float)y;

/*!
 This method gets the real-space y-coordinate of the starting point for
 the line. The convention for 'starting' vs. 'ending' is such that the
 "center" point for the BaseSimObj is the starting point, and the ending
 point is the other.
 */
- (float) getStartPointY;

/*!
 This method sets the ending point of the line to the real-space values
 provided by the argument.
 */
- (void) setEndPoint:(NSPoint)p;

/*!
 This method returns the real-space ending point for the line as it's
 currently defined. In the beginning the ending point may not be
 defined by the user and so default to (0,0) or an indeterminate value.
 */
- (NSPoint) getEndPoint;

/*!
 This method sets the real-space x-coordinate of the ending point to
 the provided value. This is useful when you simply need to relocate the
 x-value of the ending point to a fixed position.
 */
- (void) setEndPointX:(float)x;

/*!
 This method gets the real-space x-coordinate of the ending point for
 the line. The convention for 'starting' vs. 'ending' is such that the
 "center" point for the BaseSimObj is the starting point, and the ending
 point is the other.
 */
- (float) getEndPointX;

/*!
 This method sets the real-space y-coordinate of the ending point to
 the provided value. This is useful when you simply need to relocate the
 y-value of the ending point to a fixed position.
 */
- (void) setEndPointY:(float)y;

/*!
 This method gets the real-space y-coordinate of the ending point for
 the line. The convention for 'starting' vs. 'ending' is such that the
 "center" point for the BaseSimObj is the starting point, and the ending
 point is the other.
 */
- (float) getEndPointY;

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
- (id) initAsConductorWithVoltage:(double)v from:(NSPoint)start to:(NSPoint)end;

/*!
 This method initializes the line object to be a solid, dielectric
 with the relative dielectric constant, er, starting at 'start' and
 continuing to 'end' in real-world coordinates. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the line object.
 */
- (id) initAsDielectricWithEpsilonR:(double)er from:(NSPoint)start to:(NSPoint)end;

/*!
 This method initializes the line object to be a solid, fixed
 charge sheet with the charge density, rho, starting at 'start' and
 continuing to 'end' in real-world coordinates. It calls heavily on the
 superclass' init method and simply builds up that functionality that's
 specific to the line object.
 */
- (id) initAsChargeSheetWithRho:(double)rho from:(NSPoint)start to:(NSPoint)end;

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
- (void) moveRelative:(NSPoint)delta;

/*!
 Because this object is a little different that the others, we need to be
 careful about how this guy is moved around on the workspace. We need to
 move both the starting point and the ending point. We do this by moving
 the "center" of the object (the starting point) and then move the ending
 point. Not hard, but it's important to remember the relationships between
 the points and the "center".
 */
- (void) moveRelativeX:(float)deltaX Y:(float)deltaY;

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
- (BOOL) addToWorkspace:(SimWorkspace*)ws;

/*!
 This method is a part of the Cohen-Sutherland line clipping code which
 is very efficient at clipping the provided line in the viewing window.
 for our use, this viewing window is always a SimWorkspace, and the line
 being clipped is this object's instance itself. It's clipped in the
 real-world coordinates, and then those are converted into simulation
 grid nodes for further use.
 */
- (CODE) computeCSCodeFor:(NSPoint)p in:(SimWorkspace*)ws;

@end
