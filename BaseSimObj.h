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


@interface BaseSimObj : NSObject {
	@private
	NSPoint			_center;
	BOOL				_isAConductor;
	double			_voltage;
	double			_relativeEpsilon;
	double			_fixedCharge;
	BOOL				_isSolid;
}

/*"              Accessor Methods                 "*/
- (void) setCenter:(NSPoint)p;
- (NSPoint) getCenter;
- (void) setCenterAtX:(float)x Y:(float)y;
- (void) setCenterX:(float)x;
- (float) getCenterX;
- (void) setCenterY:(float)y;
- (float) getCenterY;
- (void) setIsAConductor:(BOOL)cond;
- (BOOL) isAConductor;
- (void) setVoltage:(double)v;
- (double) getVoltage;
- (void) setRelativeEpsilon:(double)er;
- (double) getRelativeEpsilon;
- (void) setFixedCharge:(double)rho;
- (double) getFixedCharge;
- (void) setIsSolid:(BOOL)solid;
- (BOOL) isSolid;

/*"              Initialization Methods           "*/
- (id) initAsConductorWithVoltage:(double)v;
- (id) initAsDielectricWithEpsilonR:(double)er;
- (id) initAsChargeSheetWithRho:(double)rho;
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p;
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p;
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p;

/*"              Simple Movement Methods          "*/
- (void) locateAt:(NSPoint)loc;
- (NSPoint) getLocation;
- (void) locateAtX:(float)x Y:(float)y;
- (void) moveRelative:(NSPoint)delta;
- (void) moveRelativeX:(float)deltaX Y:(float)deltaY;

/*"              Manipulation Methods             "*/
- (void) makeHollow;
- (void) makeSolid;

/*"              Workspace Methods                "*/
- (BOOL) addToWorkspace:(SimWorkspace*)ws;
- (BOOL) addObjPropsToWorkspace:(SimWorkspace*)ws atNode:(NSPoint)p;
- (BOOL) addObjPropsToWorkspace:(SimWorkspace*)ws atNodeRow:(int)r andCol:(int)c;

@end
