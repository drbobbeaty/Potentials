//
//  BaseSimObj.h
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
#import "SimWorkspace.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class BaseSimObj
 This class is the base model object for all the things that can be
 placed in the workspace and simulated. This includes all dielectrics,
 conductors, charge sheets, etc. The class inheritance model is really
 pretty simple - the type of material is considered to be parameters
 and therefore not a subclass, whereas the shape of the object is
 considered specialization and therefore is subclassed. There's no reason
 to have a complex inheritance diagram for this and with the scheme we
 have in place it makes it very easy to alter the electrical properties
 of a device without having to create a new object, and that's nice.
 */
@interface BaseSimObj : NSObject {
	@private
	NSPoint			_center;
	BOOL			_isAConductor;
	double			_voltage;
	double			_relativeEpsilon;
	double			_fixedCharge;
	BOOL			_isSolid;
}

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the center of the object as it will appear on the
 workspace. Of course, this is not always going to be the centroid of
 each object, but it's usually a well-defined reference point that can
 be figured out pretty easily for each type. For example, for a line,
 this will be one endpoint.
 */
- (void) setCenter:(NSPoint)p;

/*!
 This method gets the 'center' of the object as it will appear on the
 workspace. This is not always the centroid, but it should always be a
 reasonably good reference point for the object.
 */
- (NSPoint) getCenter;

/*!
 This method sets the center of the object using the coordinates as
 opposed to the NSPoint that the other method uses. This is just a
 differrent way of doing the same thing so that it's easier for the
 user to do what they want simply.
 */
- (void) setCenterAtX:(float)x Y:(float)y;

/*!
 This method sets the real-space coordinate of the center of the object
 along the x-axis which is also the 'columns' in the simulation grid.
 */
- (void) setCenterX:(float)x;

/*!
 This method returns the real-space x-axis value of the center of the
 object.
 */
- (float) getCenterX;

/*!
 This method sets the real-space coordinate of the center of the object
 along the y-axis which is also the 'rows' in the simulation grid.
 */
- (void) setCenterY:(float)y;

/*!
 This method returns the real-space y-axis value of the center of the
 object.
 */
- (float) getCenterY;

/*!
 This method is called to set whether or not this item is a conductor.
 Basically, a conductor has a fixed voltage and no electric fields within
 it's boundaries. This is, of course, an ideal conductor. Call this method
 with YES and it'll set this item to be a conductor for the next simulation
 that is done with it.
 */
- (void) setIsAConductor:(BOOL)cond;

/*!
 This method returns the state of this object - with regards to it being
 a perfect conductor or not. It either is or isn't, and the parameters for
 it's physical being are taken from all those available for the object.
 */
- (BOOL) isAConductor;

/*!
 This method sets the potential of the object to the provided value and
 also assumes that this device is to be a conductor - why else would you
 be setting the voltage?
 */
- (void) setVoltage:(double)v;

/*!
 This method gets the voltage that's been assigned to the object or
 returns an undetermined value if it's not yet been set. In general, you
 need to make sure that you're asking this of conductors *only*.
 */
- (double) getVoltage;

/*!
 This method sets the relative dielectric constanct for this item. This
 doesn't make any sense for a conductor, but for anything else it makes
 a lot of sense. The default value is 1.0, and if nothing is set that's
 what's used.
 */
- (void) setRelativeEpsilon:(double)er;

/*!
 This method returns the relative dielectric constant for this item
 in the simulation. This makes no sense for a conductor, but for all
 other items it's got to be defined and good. The default for all objects
 is 1.0.
 */
- (double) getRelativeEpsilon;

/*!
 This method sets the fixed charge per unit area for the device in the
 next simulation. This is a bit arbitrary, and I'll agree that I need to
 do a little unit conversion here, but for the time being, this sets
 'rho' per unit of grid for this element.
 */
- (void) setFixedCharge:(double)rho;

/*!
 This method gets the fixed charge per unit of grid area for this device.
 I need to work on the units as we currently try to remain as unitless as
 possible, and I'll work on that as soon as I make the grid have actual
 physical units, but for now, this is as good as it gets.
 */
- (double) getFixedCharge;

/*!
 This method is used to make the object either hollow or solid. This can
 be useful in seeing the effects of a thin dielectric, or thin conductor
 versus a solid one. Very nice effect.
 */
- (void) setIsSolid:(BOOL)solid;

/*!
 This method is used to see if this object is solid throughout or simply
 a very thin structure. If it's thin, then it's *really* thin - one unit
 on the simulation workspace.
 */
- (BOOL) isSolid;

//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This will initialize the item as a conductor with a voltage of 'v'. It
 will still be up to the user to set the location of this object on the
 workspace, but that might possibly be a veriable parameter that needs to
 be varied from run to run. The location will be reset to (0,0) and the
 relative dielectric constant (which is useless for a conductor) will be
 set to 1.0, and the fixed charge will be reset to 0.
 */
- (id) initAsConductorWithVoltage:(double)v;

/*!
 This will initialize the item as a dielectric with a relative dielectric
 constant of 'er'. It is still up the the caller to place this item's
 location as well as any possible fixed charge. The location will be reset
 to (0,0) and the fixed charge will be reset to 0.
 */
- (id) initAsDielectricWithEpsilonR:(double)er;

/*!
 This will initialize the object as a charge sheet with the charge density
 of 'rho'. The relative dielectric constant will be set to 1.0 and the
 center will be reset to (0,0).
 */
- (id) initAsChargeSheetWithRho:(double)rho;

/*!
 This will initialize the object as a conductor with the given voltage
 centered at the given point in the workspace frame. This will set the
 relative dielectric constant to 1.0 (which is unimportant for a
 conductor).
 */
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p;

/*!
 This will initialize the object as a dielectric slab with a relative
 dielectric constant 'er', and position the object at the provided point,
 'p'. The fixed charge will be reset to 0.
 */
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p;

/*!
 This will initialize the object as a charge sheet with the fixed charge
 of the supplied density and position the object at the provided point.
 The relative dielectric constant will be set to 1.0.
 */
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p;

//----------------------------------------------------------------------------
//					Simple Movement Methods
//----------------------------------------------------------------------------

/*!
 This method is a convenience method for moving the object to the provided
 point. If all shape objects are implemented correctly this should shift
 the defined 'center' point of the object to the new position and all other
 points should move relative to this.
 */
- (void) locateAt:(NSPoint)loc;

/*!
 This method is a convenience method that gets the center of ths object
 in a form that might make more sense to the user.
 */
- (NSPoint) getLocation;

/*!
 This method is a conveneince method for locating the center of the object
 at a given set of coordinates.
 */
- (void) locateAtX:(float)x Y:(float)y;

/*!
 This method moves the center of the object by the value of this point
 with respect to the current position. So, if the current position is
 (3,5) and 'delta' is (2,1) the final position will be (5,6).
 */
- (void) moveRelative:(NSPoint)delta;

/*!
 This method moves the center of the object by the value of each coordinate
 so that it might be a more convenient method than packaging up the values
 into an NSPoint.
 */
- (void) moveRelativeX:(float)deltaX Y:(float)deltaY;

//----------------------------------------------------------------------------
//					Manipulation Methods
//----------------------------------------------------------------------------

/*!
 This method will make the obect a thin shell as opposed to a solid. The
 thickness of the object is one unit in the workspace. This is a simple
 convenience method, but easy to understand and some may prefer this
 language as opposed to the setter.
 */
- (void) makeHollow;

/*!
 This method makes the object solid so that the dielectric, or charge, or
 conductor are solid within the boundary defined by the object. This is a
 simple convenience, but it's nice to have around.
 */
- (void) makeSolid;

//----------------------------------------------------------------------------
//					Workspace Methods
//----------------------------------------------------------------------------

/*!
 This method places the object within the provided workspace given it's
 current properties. The timing is important - when an object is placed
 in a workspace it's essentially like taking a 'snapshot' of the object
 as the location and physical parameters are forzen in the workspace.
 This is nice because a circular conductor can be added to a workspace,
 then moved, added again, and repeated several times to place a regular
 array of circular conductors.
 */
- (BOOL) addToWorkspace:(SimWorkspace*)ws;

/*!
 This method is used by the subclasses of this BaseSimObj class to
 place their physical properties - voltage, charge, dielectric constant
 on the workspace at the provided row and column location. This is very
 useful because it means that each subclass doesn't have to repeat this
 same functionality and every one of them needs it. The NSPoint
 represents the node in the simulation grid and *not* the real-world
 coordinates of the point.
 */
- (BOOL) addObjPropsToWorkspace:(SimWorkspace*)ws atNode:(NSPoint)p;

/*!
 This method is used by the subclasses of this BaseSimObj class to
 place their physical properties - voltage, charge, dielectric constant
 on the workspace at the provided row and column location. This is very
 useful because it means that each subclass doesn't have to repeat this
 same functionality and every one of them needs it.
 */
- (BOOL) addObjPropsToWorkspace:(SimWorkspace*)ws atNodeRow:(int)r andCol:(int)c;

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
