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


/*!
 @class SimObjFactory
 This class creates and inventories all the simulation objects that
 will be in-play at any time. This is basically the model generation
 and storage for the application. Nice and clean with the appropriate
 parsers in the right places to take text and convert it into usable
 simulation objects.
 */
@interface SimObjFactory : NSObject {
	@private
	NSMutableArray*		_inventory;
}

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method assigns the passed-in array to be the main storage depot
 of the simulation objects that are currently in use. This inventory
 will be added to by the constructor methods on this class. Of course,
 the user is free to create new objects and add them to this inventory
 (or remove them, if needed) - it's just a convenient place to hold
 what's considered to be important at this time.
 */
- (void) setInventory:(NSMutableArray*)array;

/*!
 This method returns the array of simulation objects that are currently
 considered 'important' to the simulation. This can be used to operate
 on them all - as in placing them on the workspace, or other housekeeping
 tasks.
 */
- (NSMutableArray*) getInventory;

/*!
 This method adds the provided simulation object to the inventory of
 all simulation objects that will be active. This is important as it's
 most likely the case that these active objects will be the ones that
 are placed on the workspace for simulation.
 */
- (BOOL) addToInventory:(BaseSimObj*)simObj;

/*!
 This method removes the provided simulation object to the inventory of
 all simulation objects that will be active. This is important as it's
 most likely the case that these active objects will be the ones that
 are placed on the workspace for simulation.
 */
- (BOOL) removeFromInventory:(BaseSimObj*)simObj;

/*!
 This method removes all the simulation objects from the inventory of
 simulation objects that will be active. This is important as it's
 most likely the case that these active objects will be the ones that
 are placed on the workspace for simulation, and by doing this we're
 essentially clearing out all the current objects and starting fresh.
 */
- (void) removeAllInventory;

//----------------------------------------------------------------------------
//					NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method does the super's -init as well as making sure we have
 a place tp put all the simulation objects that we're going to be
 creating and manipulating.
 */
- (id) init;

/*!
 This method is called by the runtime when the released object is about
 to get cleaned up. This gives us an opportunity to clean up all the
 memory we're using at the time and be a good citizen.
 */
- (void) dealloc;

//----------------------------------------------------------------------------
//					Sim Object Creators
//----------------------------------------------------------------------------

/*!
 This method is interesting in that the description of a simulation object
 can be contained in a single NSString, and given this data the purpose of
 this guy is to create a functional simulation object and place it in the
 inventory of objects that this factory has created. It's a simple way to
 build up these objects from, say, a text file.
 */
- (BaseSimObj*) createSimObjWithString:(NSString*)line;

@end
