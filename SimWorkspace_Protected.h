//
//  SimWorkspace_Protected.h
//  Potentials
//
//  Created by Bob Beaty on Thu May 08 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
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


@interface SimWorkspace (Protected)

/*"              Accessor Methods                 "*/
- (void) _setRowCount:(int)r;
- (void) _setColCount:(int)c;
- (void) _setRho:(MaskedMatrix*)rho;
- (void) _setEpsilonR:(MaskedMatrix*)er;
- (void) _setVoltage:(MaskedMatrix*)v;
- (void) _setResultantVoltage:(MaskedMatrix*)results;

@end
