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


@interface PointSimObj : BaseSimObj {
}

/*"              Accessor Methods                 "*/
- (void) setLocation:(NSPoint)p;
- (NSPoint) getLocation;
- (void) setX:(float)x;
- (float) getX;
- (void) setY:(float)y;
- (float) getY;

/*"              Initialization Methods           "*/

/*"              Workspace Methods                "*/

@end
