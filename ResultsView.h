//
//  ResultsView.h
//  Potentials
//
//  Created by Bob Beaty on 5/1/19.
//  Copyright (c) 2019 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers
#import <Cocoa/Cocoa.h>

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


NS_ASSUME_NONNULL_BEGIN

/*!
 @class ResultsView
 This class is the output plotting view of the Voltage and Electric Field
 for the simulation. This has to be written because we really couldn't find
 a suitable graphing solution.
 */
@interface ResultsView : NSView {
	@private
	double			_graphedMax;
	double			_graphedMin;
	NSRect			_workspaceRect;
	int 			_rowCnt;
	int				_colCnt;
	double**		_values;
	NSArray*		_inventory;
}

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method gets the currently defined inventory of drawable objects from
 the SimWorkspace that can be overlaid on the simulation's plotted results.
 */
- (NSArray*) getInventory;

//----------------------------------------------------------------------------
//					Plotting Methods
//----------------------------------------------------------------------------

/*!
 This method takes the provided SimWorkspace and plots the Voltage as a
 function of x and y, based on the row, col organization of the Voltage
 data within the SimWorkspace.
 */
- (void) plotVoltage:(SimWorkspace*)workspace with:(NSArray*)inventory;

/*!
 This method takes the provided SimWorkspace and plots the Electric Field
 as a function of x and y, based on the row, col organization of the Voltage
 data within the SimWorkspace.
 */
- (void) plotElectricField:(SimWorkspace*)workspace with:(NSArray*)inventory;

//----------------------------------------------------------------------------
//               Linear Interpolation of Color Methods
//----------------------------------------------------------------------------

/*!
 This function converts the NSColor from perceptual to linear light. It's
 part of the color interpolation algorithm.
 */
+ (NSColor*) sRGBCompanding:(NSColor*)per;

/*!
 This function converts the NSColor from linear to perceptual light. It's
 part of the color interpolation algorithm.
 */
+ (NSColor*) sRGBInverseCompanding:(NSColor*)lin;

/*!
 This method is used to determine the NSColor of the realtive value x [0..1],
 and it maps between the NSColors. This is the way to interpolate for the
 color based on the given value in a range.
 */
+ (NSColor*) interpolate:(double)x withColorsBetween:(NSColor*)clow and:(NSColor*)chigh;

/*!
 This method is used to determine the NSColor of the value x, where the
 limits on x are provided, and they map to the NSColors. This is the way to
 interpolate for the color based on the value in the range.
 */
+ (NSColor*) interpolate:(double)x between:(double)xlow and:(double)xhigh withColorsBetween:(NSColor*)clow and:(NSColor*)chigh;

//----------------------------------------------------------------------------
//               Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method drops any matrix that might already be allocated in this
 instance and attempts to allocate a new matrix of the given size. If
 this is successful, then self is returned. If not, then nil is returned.
 This method can be called many times in the life of this object, each
 time resizing to the desired dimensions.
 */
- (id) initWithRows:(int)rowCnt andCols:(int)colCnt;

/*!
 This method drops the allocated plotting data for this instance, and
 is used to clean up the memory used and be a good non-leaking citizen.
 */
- (void) freePlottingData;

//----------------------------------------------------------------------------
//               NSView Methods
//----------------------------------------------------------------------------

/*!
 This method is used to draw the region under the argument in the view.
 */
- (void) drawRect:(NSRect)dirtyRect;

//----------------------------------------------------------------------------
//               NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method is called by the runtime when the released object is about
 to get cleaned up. This gives us an opportunity to clean up all the
 memory we're using at the time and be a good citizen.
 */
- (void) dealloc;

@end

NS_ASSUME_NONNULL_END
