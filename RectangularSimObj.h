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


@interface RectangularSimObj : BaseSimObj {
	@private
	NSSize				_size;
}

/*"              Accessor Methods                 "*/
- (void) setSize:(NSSize)size;
- (NSSize) getSize;
- (void) setWidth:(float)w;
- (float) getWidth;
- (void) setHeight:(float)h;
- (float) getHeight;

/*"              Initialization Methods           "*/
- (id) initAsConductorWithVoltage:(double)v withSize:(NSSize)size;
- (id) initAsConductorWithVoltage:(double)v withWidth:(float)w andHeight:(float)h;
- (id) initAsDielectricWithEpsilonR:(double)er withSize:(NSSize)size;
- (id) initAsDielectricWithEpsilonR:(double)er withWidth:(float)w andHeight:(float)h;
- (id) initAsChargeSheetWithRho:(double)rho withSize:(NSSize)size;
- (id) initAsChargeSheetWithRho:(double)rho withWidth:(float)w andHeight:(float)h;
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withSize:(NSSize)size;
- (id) initAsConductorWithVoltage:(double)v at:(NSPoint)p withWidth:(float)w andHeight:(float)h;
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withSize:(NSSize)size;
- (id) initAsDielectricWithEpsilonR:(double)er at:(NSPoint)p withWidth:(float)w andHeight:(float)h;
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withSize:(NSSize)size;
- (id) initAsChargeSheetWithRho:(double)rho at:(NSPoint)p withWidth:(float)w andHeight:(float)h;

/*"              Workspace Methods                "*/
- (BOOL) addToWorkspace:(SimWorkspace*)ws;

@end
