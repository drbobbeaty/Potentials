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


@interface LineSimObj : BaseSimObj {
	@private
	NSPoint			_endPoint;
}

/*"              Accessor Methods                 "*/
- (void) setStartPoint:(NSPoint)p;
- (NSPoint) getStartPoint;
- (void) setStartPointX:(float)x;
- (float) getStartPointX;
- (void) setStartPointY:(float)y;
- (float) getStartPointY;
- (void) setEndPoint:(NSPoint)p;
- (NSPoint) getEndPoint;
- (void) setEndPointX:(float)x;
- (float) getEndPointX;
- (void) setEndPointY:(float)y;
- (float) getEndPointY;

/*"              Initialization Methods           "*/
- (id) initAsConductorWithVoltage:(double)v from:(NSPoint)start to:(NSPoint)end;
- (id) initAsDielectricWithEpsilonR:(double)er from:(NSPoint)start to:(NSPoint)end;
- (id) initAsChargeSheetWithRho:(double)rho from:(NSPoint)start to:(NSPoint)end;

/*"              Simple Movement Methods          "*/
- (void) moveRelative:(NSPoint)delta;
- (void) moveRelativeX:(float)deltaX Y:(float)deltaY;

/*"              Workspace Methods                "*/
- (BOOL) addToWorkspace:(SimWorkspace*)ws;
- (CODE) computeCSCodeFor:(NSPoint)p in:(SimWorkspace*)ws;

@end
