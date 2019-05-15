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

//----------------------------------------------------------------------------
//               Component Drawing Methods
//----------------------------------------------------------------------------

/*!
 This method takes the context on which to draw the colorized 2D heat map of
 data, and the array of colors to blend between for the different [0..1]
 values. This will simply draw all the rectangles of diffderent colors based
 on the values in this instance - nothing more.
 */
- (BOOL) _plotDataOn:(CGContextRef)ctext with:(NSArray*)colors;

/*!
 This method takes the context on which to draw the inventory of objects that
 were part of the simulation, as well as a color to render them in. This
 just makes it easy to optionally draw the inventory - at the user's request.
 */
- (BOOL) _drawInventoryOn:(CGContextRef)ctext with:(NSColor*)color;

/*!
 This method takes an object - defined as an NSDictionary, and the context
 on which to draw it, as well as a color to render in - and then draws it
 as needed. This just gets called for each item in the Inventory.
 */
- (BOOL) _draw:(NSDictionary*)item on:(CGContextRef)ctext with:(NSColor*)color;

/*!
 This method takes the array of values, and draws the contour lines for each
 in the provided context. These values will be in the interval [0..1] and in
 keeping with the scaled plotted values.
 */
- (BOOL) _drawContours:(NSArray*)values on:(CGContextRef)ctext with:(NSColor*)color;

/*!
 This method takes a single value, and draws the contour line(s) for this
 value in the provided context. The value will be in the interval [0..1] and
 in keeping with the scaled plotted values.
 */
- (BOOL) _drawContour:(double)value on:(CGContextRef)ctext with:(NSColor*)color;

@end
