//
//  SimObjFactory.h
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

// Forward Class Declarations
@class BaseSimObj;

// Public Data Types

// Public Constants

// Public Macros


@interface SimObjFactory : NSObject {
	@private
	NSMutableArray*		_inventory;
}

/*"       Accessor Methods                 "*/
- (void) setInventory:(NSMutableArray*)array;
- (NSMutableArray*) getInventory;
- (BOOL) addToInventory:(BaseSimObj*)simObj;
- (BOOL) removeFromInventory:(BaseSimObj*)simObj;
- (void) removeAllInventory;

/*"       NSObject Overridden Methods      "*/
- (id) init;
- (void) dealloc;

/*"       Sim Object Creators              "*/
- (BaseSimObj*) createSimObjWithString:(NSString*)line;

@end
