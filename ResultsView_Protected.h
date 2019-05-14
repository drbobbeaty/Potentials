//
//  ResultsView_Protected.h
//  Potentials
//
//  Created by Bob Beaty on 5/8/19.
//  Copyright (c) 2019 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers
#import <Cocoa/Cocoa.h>

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "ResultsView.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class ResultsView
 These are the 'protected' methods on the ResultsView object. They are
 protected as a category because they can do a lot more damage than good
 in the wrong hands, but we want to keep everything well encapsulated so
 we need these methods, we just don't want them in the public API that
 everyone gets to see. So they are here.
 */
@interface ResultsView (Protected)

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method gets the actual minimum value of the displayed graphical data.
 This is the un-scaled value, that internally will be used to scale all the
 plotting data from [0..1].
 */
- (void) _setGraphedMin:(double)value;

/*!
 This method gets the actual maximum value of the displayed graphical data.
 This is the un-scaled value, that internally will be used to scale all the
 plotting data from [0..1].
 */
- (void) _setGraphedMax:(double)value;

/*!
 This method returns the shape of the simulated workspace that is being
 plotted on this view. This is the un-scaled shape, and is used in the
 mapping from that workspace to the view.
 */
- (void) _setGraphedRect:(NSRect)shape;

/*!
 This method sets the inventory of drawable objects from the SimWorkspace
 so that we can draw them on the simulation plot. They are all scaled to
 have linear dimensions [0..1] so it's easy to place them on the NSView.
 */
- (void) _setInventory:(NSArray*)inventory;

@end
