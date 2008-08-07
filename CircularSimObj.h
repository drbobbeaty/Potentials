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


@interface CircularSimObj : BaseSimObj {
	@private
	float			_radius;
}

/*"              Accessor Methods                 "*/
- (void) setRadius:(float)r;
- (float) getRadius;

/*"              Initialization Methods           "*/
- (id) initAsConductorWithVoltage:(double)v withRadius:(float)r;
- (id) initAsDielectricWithEpsilonR:(double)er withRadius:(float)r;
- (id) initAsChargeSheetWithRho:(double)rho withRadius:(float)r;
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withRadius:(float)r;
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withRadius:(float)r;
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withRadius:(float)r;

/*"              Workspace Methods                "*/
- (BOOL) addToWorkspace:(SimWorkspace*)ws;

@end
