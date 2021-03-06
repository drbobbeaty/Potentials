//
//  ResultsView.m
//  Potentials
//
//  Created by Bob Beaty on 5/1/19.
//  Copyright (c) 2019 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers
#import <Accelerate/Accelerate.h>

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "ResultsView_Protected.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class ResultsView
 This class is the output plotting view of the Voltage and Electric Field
 for the simulation. This has to be written because we really couldn't find
 a suitable graphing solution.
 */
@implementation ResultsView

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method gets the actual minimum value of the displayed graphical data.
 This is the un-scaled value, that internally will be used to scale all the
 plotting data from [0..1].
 */
- (double) getGraphedMin
{
	return _graphedMin;
}


/*!
 This method gets the actual maximum value of the displayed graphical data.
 This is the un-scaled value, that internally will be used to scale all the
 plotting data from [0..1].
 */
- (double) getGraphedMax
{
	return _graphedMax;
}


/*!
 This method returns YES if the computed data in this instance is complex
 in nature - that is magnitude and direction as opposed to just a scalar
 value.
 */
- (BOOL) isComplex
{
	return (_direction != nil);
}


/*!
 This method returns the shape of the simulated workspace that is being
 plotted on this view. This is the un-scaled shape, and is used in the
 mapping from that workspace to the view.
 */
- (NSRect) getGraphedRect
{
	return _workspaceRect;
}


/*!
 This method returns the number of rows in the simulated data that need to
 be properly graphed in this view.
 */
- (int) getRowCount
{
	return _rowCnt;
}

/*!
 This method returns the number of columns in the simulated data that need to
 be properly graphed in this view.
 */
- (int) getColCount
{
	return _colCnt;
}


/*!
 This method gets the currently defined inventory of drawable objects from
 the SimWorkspace that can be overlaid on the simulation's plotted results.
 */
- (NSArray*) getInventory
{
	return _inventory;
}


//----------------------------------------------------------------------------
//					Plotting Methods
//----------------------------------------------------------------------------

/*!
 This method takes the provided SimWorkspace and plots the Voltage as a
 function of x and y, based on the row, col organization of the Voltage
 data within the SimWorkspace.
 */
- (void) plotVoltage:(SimWorkspace*)workspace with:(NSArray*)inventory
{
	BOOL				error = NO;

	// first, make sure that there's something to work with
	if (!error) {
		if (workspace == nil) {
			error = YES;
			NSLog(@"[ResultsView -plotVoltage:] - no simulation workspace was passed in. You need to make sure to pass in a valid simulation workspace when calling this method.");
		}
	}
	// ...and that it's got results to output - and pick up the limits as well
	double  Vmax = NAN;
	double  Vmin = NAN;
	if (!error) {
		if ([workspace getResultantVoltage] == nil) {
			error = YES;
			NSLog(@"[ResultsView -plotVoltage:] - there are no resultant voltages for the simulation workspace defined at this time. You need to make sure to simulate the workspace by -runSim: and then call this method.");
		} else {
			// get the limits for the colorization of the data
			Vmax = [[workspace getResultantVoltage] getMaxValue];
			Vmin = [[workspace getResultantVoltage] getMinValue];
		}
	}

	// time to initialize the plotting data for the results
	if (!error) {
		if ([self initWithRows:[workspace getRowCount] andCols:[workspace getColCount]] == nil) {
			error = YES;
			NSLog(@"[ResultsView -plotVoltage:] - space for the plotting display data could not be allocated.");
		}
	}

	if (!error) {
		double	v = 0.0;
		// now let's loop over all the points and write out what we want...
		for (int r = 0; r < [self getRowCount]; r++) {
			for (int c = 0; c < [self getColCount]; c++) {
				// now get the results at this node
				v = [workspace getResultantVoltageAtNodeRow:r andCol:c];
				// save all this for drawing
				_values[r][c] = (v - Vmin)/(Vmax - Vmin);
			}
		}
		// ...and save the limits we discovered for the graphing
		[self _setGraphedMax:Vmax];
		[self _setGraphedMin:Vmin];
		// ...and save the shape and inventory from the workspace
		[self _setGraphedRect:[workspace getWorkspaceRect]];
		[self _setInventory:inventory];
	}

	[self setNeedsDisplay:YES];
	[self display];
}


/*!
 This method takes the provided SimWorkspace and plots the Electric Field
 as a function of x and y, based on the row, col organization of the Voltage
 data within the SimWorkspace.
 */
- (void) plotElectricField:(SimWorkspace*)workspace with:(NSArray*)inventory
{
	BOOL				error = NO;

	// first, make sure that there's something to work with
	if (!error) {
		if (workspace == nil) {
			error = YES;
			NSLog(@"[ResultsView -plotElectricField:] - no simulation workspace was passed in. You need to make sure to pass in a valid simulation workspace when calling this method.");
		}
	}
	// ...and that it's got results to output - and pick up the limits as well
	double  Emax = NAN;
	double  Emin = NAN;
	if (!error) {
		if ([workspace getResultantElectricFieldMagnitude] == nil) {
			error = YES;
			NSLog(@"[ResultsView -plotElectricField:] - there are no resultant electric field data for the simulation workspace defined at this time. You need to make sure to simulate the workspace by -runSim: and then call this method.");
		} else {
			// get the limits for the colorization of the data
			Emax = [[workspace getResultantElectricFieldMagnitude] getMaxValue];
			Emin = [[workspace getResultantElectricFieldMagnitude] getMinValue];
		}
	}

	// time to initialize the plotting data for the results
	if (!error) {
		if ([self initComplexWithRows:[workspace getRowCount] andCols:[workspace getColCount]] == nil) {
			error = YES;
			NSLog(@"[ResultsView -plotElectricField:] - space for the plotting display data could not be allocated.");
		}
	}

	if (!error) {
		double	em = 0.0;
		double	ed = 0.0;
		// now let's loop over all the points and write out what we want...
		for (int r = 0; r < [self getRowCount]; r++) {
			for (int c = 0; c < [self getColCount]; c++) {
				// now get the results at this node
				em = [workspace getResultantElectricFieldMagnitudeAtNodeRow:r andCol:c];
				ed = [workspace getResultantElectricFieldDirectionAtNodeRow:r andCol:c];
				// save all this for drawing
				_values[r][c] = (em - Emin)/(Emax - Emin);
				_direction[r][c] = ed;
			}
		}
		// ...and save the limits we discovered for the graphing
		[self _setGraphedMax:Emax];
		[self _setGraphedMin:Emin];
		// ...and save the shape and inventory from the workspace
		[self _setGraphedRect:[workspace getWorkspaceRect]];
		[self _setInventory:inventory];
	}

	[self setNeedsDisplay:YES];
	[self display];
}


//----------------------------------------------------------------------------
//               Linear Interpolation of Color Methods
//----------------------------------------------------------------------------

/*!
 This function converts the NSColor from perceptual to linear light. It's
 part of the color interpolation algorithm.
 */
+ (NSColor*) sRGBCompanding:(NSColor*)per
{
	// get the components of the incoming NSColor
	CGFloat		rgb[4];
	if (per) {
		[per getRed:(&rgb[0]) green:(&rgb[1]) blue:(&rgb[2]) alpha:(&rgb[3])];
		// apply companding to Red, Green, and Blue components
		for (int i = 0; i < 3; ++i) {
			if (rgb[i] > 0.0031308) {
				rgb[i] = 1.055 * pow(rgb[i], 1.0/2.4) - 0.055;
			} else {
				rgb[i] *= 12.92;
			}
		}
	}
	// return the new NSColor
	return (per ? [NSColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:rgb[3]] : nil);
}


/*!
 This function converts the NSColor from linear to perceptual light. It's
 part of the color interpolation algorithm.
 */
+ (NSColor*) sRGBInverseCompanding:(NSColor*)lin
{
	// get the components of the incoming NSColor
	CGFloat		rgb[4];
	if (lin) {
		[lin getRed:(&rgb[0]) green:(&rgb[1]) blue:(&rgb[2]) alpha:(&rgb[3])];
		// apply inverse companding to Red, Green, and Blue components
		for (int i = 0; i < 3; ++i) {
			if (rgb[i] > 0.04045) {
				rgb[i] = pow((rgb[i] + 0.055)/1.055, 2.4);
			} else {
				rgb[i] /= 12.92;
			}
		}
	}
	// return the new NSColor
	return (lin ? [NSColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:rgb[3]] : nil);
}


/*!
 This method is used to determine the NSColor of the realtive value x [0..1],
 and it maps between the NSColors. This is the way to interpolate for the
 color based on the given value in a range.
 */
+ (NSColor*) interpolate:(double)x withColorsBetween:(NSColor*)clow and:(NSColor*)chigh
{
	BOOL				error = NO;
	BOOL				found = NO;

	// Pulled from: https://stackoverflow.com/questions/22607043/color-gradient-algorithm

	// don't bother processing impossible values
	CGFloat		rgb[4];
	if (!error && !found) {
		if (isnan(x) || isinf(x)) {
			found = YES;
			for (int i = 0; i < 4; i++) {
				rgb[i] = 1.0;
			}
		}
	}

	// apply inverse compounding to the low-end color endpoint
	CGFloat		lrgb[4];
	if (!error && !found && clow) {
		NSColor*	inv = [ResultsView sRGBInverseCompanding:clow];
		if (inv == nil) {
			error = YES;
			NSLog(@"[ResultsView +interpolate:between:and:withColorsBetween:and:] - the low-end color could not be inverse companded.");
		} else {
			[inv getRed:(&lrgb[0]) green:(&lrgb[1]) blue:(&lrgb[2]) alpha:(&lrgb[3])];
		}
	}

	// apply inverse compounding to the high-end color endpoint
	CGFloat		hrgb[4];
	if (!error && !found && chigh) {
		NSColor*	inv = [ResultsView sRGBInverseCompanding:chigh];
		if (inv == nil) {
			error = YES;
			NSLog(@"[ResultsView +interpolate:between:and:withColorsBetween:and:] - the high-end color could not be inverse companded.");
		} else {
			[inv getRed:(&hrgb[0]) green:(&hrgb[1]) blue:(&hrgb[2]) alpha:(&hrgb[3])];
		}
	}

	// interpolate the RGB values based on the value of x in the interval
	if (!error && !found) {
		// interpolate each of the RGB+alpha values...
		for (int i = 0; i < 4; ++i) {
			rgb[i] = (hrgb[i] - lrgb[i])*x + lrgb[i];
		}
		// ...and then factor in the interpolated intensity on RGB
		double	lbright = pow(lrgb[0]+lrgb[1]+lrgb[2], 0.43);
		double	hbright = pow(hrgb[0]+hrgb[1]+hrgb[2], 0.43);
		double	bright = (hbright - lbright)*x + lbright;
		double	intens = pow(bright, 1.0/0.43);
		double	fact = intens / (rgb[0] + rgb[1] + rgb[2]);
		for (int i = 0; i < 3; ++i) {
			rgb[i] *= fact;
		}
	}

	return (error ? nil : [ResultsView sRGBCompanding:[NSColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:rgb[3]]]);
}


/*!
 This method is used to determine the NSColor of the value x, where the
 limits on x are provided, and they map to the NSColors. This is the way to
 interpolate for the color based on the value in the range.
 */
+ (NSColor*) interpolate:(double)x between:(double)xlow and:(double)xhigh withColorsBetween:(NSColor*)clow and:(NSColor*)chigh
{
	// if it's not a normal number, then let the more complete version do it
	if (isnan(x) || isinf(x)) {
		return [ResultsView interpolate:x withColorsBetween:clow and:chigh];
	}
	// convert the value in the range to a [0..1] value, and call that
	double		tgt = (x - xlow)/(xhigh - xlow);
	return [ResultsView interpolate:tgt withColorsBetween:clow and:chigh];
}


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
- (id) initWithRows:(int)rowCnt andCols:(int)colCnt
{
	BOOL			error = NO;

	// first, let's make sure the super can be initialized
	if (!error && (_values == nil)) {
		if (!(self = [super init])) {
			error = YES;
			NSLog(@"[ResultsView -initWithRows:andCols:] - the superclass could not complete it's -init method. Please check the logs for a possible cause.");
		}
	}

	// next, release all that we might have right now
	if (!error) {
		[self freePlottingData];
	}

	// now, first try to allocate the vector of pointers for the doubles
	if (!error) {
		_values = (double **) malloc( rowCnt * sizeof(double *) );
		if (_values == nil) {
			error = YES;
			NSLog(@"[ResultsView -initWithRows:andCols:] - while trying to create the vector of pointers for the doubles (%d rows), I ran into a memory allocation problem and couldn't continue. Please check into this as soon as possible.", rowCnt);
		}
	}

	// next, try to allocate each row of doubles
	if (!error) {
		for (int i = 0; i < rowCnt; i++) {
			_values[i] = (double *) malloc( colCnt * sizeof(double) );
			if (_values[i] == nil) {
				error = YES;
				NSLog(@"[ResultsView -initWithRows:andCols:] - while trying to create a row of doubles (%d out of %d rows), I ran into a memory allocation problem and couldn't continue. Please check into this as soon as possible.", (i+1), rowCnt);
			} else {
				// clear out the array with zeros
				vDSP_vclrD(_values[i], 1, colCnt);
			}
		}
	}

	// if we have had any error we need to clean up what we've done
	if (error) {
		if (_values != nil) {
			// free up each of the rows themselves
			for (int i = 0; i < rowCnt; i++) {
				if (_values[i] != nil) {
					free(_values[i]);
					_values[i] = nil;
				}
			}
			// ...and then free up the vector of pointers
			free(_values);
			_values = nil;
		}
	} else {
		// save these as they have been successfully allocated and are valid
		_rowCnt = rowCnt;
		_colCnt = colCnt;
	}

	return (error ? nil : self);
}


/*!
 This method drops any matrix that might already be allocated in this
 instance and attempts to allocate a new matrix of the given size capable
 of holding both magnitude and direction. If this is successful, then self
 is returned. If not, then nil is returned. This method can be called many
 times in the life of this object, each time resizing to the desired
 dimensions.
 */
- (id) initComplexWithRows:(int)rowCnt andCols:(int)colCnt
{
	BOOL			error = NO;

	// first, let's make sure the super can be initialized
	if (!error && (_values == nil)) {
		if (![self initWithRows:rowCnt andCols:colCnt]) {
			error = YES;
			NSLog(@"[ResultsView -initComplexWithRows:andCols:] - the base initialization could not be completed. Please check the logs for a possible cause.");
		}
	}

	// now, first try to allocate the vector of pointers for the doubles
	if (!error) {
		_direction = (double **) malloc( rowCnt * sizeof(double *) );
		if (_direction == nil) {
			error = YES;
			NSLog(@"[ResultsView -initComplexWithRows:andCols:] - while trying to create the vector of pointers for the doubles (%d rows), I ran into a memory allocation problem and couldn't continue. Please check into this as soon as possible.", rowCnt);
		}
	}

	// next, try to allocate each row of doubles
	if (!error) {
		for (int i = 0; i < rowCnt; i++) {
			_direction[i] = (double *) malloc( colCnt * sizeof(double) );
			if (_direction[i] == nil) {
				error = YES;
				NSLog(@"[ResultsView -initComplexWithRows:andCols:] - while trying to create a row of doubles (%d out of %d rows), I ran into a memory allocation problem and couldn't continue. Please check into this as soon as possible.", (i+1), rowCnt);
			} else {
				// clear out the array with zeros
				vDSP_vclrD(_direction[i], 1, colCnt);
			}
		}
	}

	// if we have had any error we need to clean up what we've done
	if (error) {
		if (_direction != nil) {
			// free up each of the rows themselves
			for (int i = 0; i < rowCnt; i++) {
				if (_direction[i] != nil) {
					free(_direction[i]);
					_direction[i] = nil;
				}
			}
			// ...and then free up the vector of pointers
			free(_direction);
			_direction = nil;
		}
	}

	return (error ? nil : self);
}


/*!
 This method drops the allocated plotting data for this instance, and
 is used to clean up the memory used and be a good non-leaking citizen.
 */
- (void) freePlottingData
{
	if (_values != nil) {
		// free up each of the rows themselves
		for (int i = 0; i < _rowCnt; i++) {
			if (_values[i] != nil) {
				free(_values[i]);
				_values[i] = nil;
			}
		}
		// ...and then free up the vector of pointers
		free(_values);
		_values = nil;
	}

	if (_direction != nil) {
		// free up each of the rows themselves
		for (int i = 0; i < _rowCnt; i++) {
			if (_direction[i] != nil) {
				free(_direction[i]);
				_direction[i] = nil;
			}
		}
		// ...and then free up the vector of pointers
		free(_direction);
		_direction = nil;
	}

	// make sure to clear out the size of the array, and the drawable inventory
	_rowCnt = 0;
	_colCnt = 0;
	[self _setInventory:nil];
}


//----------------------------------------------------------------------------
//               NSView Methods
//----------------------------------------------------------------------------

/*!
 This method is used to draw the region under the argument in the view.
 */
- (void) drawRect:(NSRect)dirtyRect {
	// always do the super's call first, to make sure it's done right
    [super drawRect:dirtyRect];

	// start the timer on the drawing work...
	NSTimeInterval begin = [NSDate timeIntervalSinceReferenceDate];

	// start with a white background for the drawing area...
	[[NSColor whiteColor] setFill];
	NSRectFill(dirtyRect);

	// compute the proper scale factor for drawing...
	_pelsPerUnit = MIN(([self frame].size.width/[self getGraphedRect].size.width),([self frame].size.height/[self getGraphedRect].size.height));
	// ...and the origin of the drawing area. We will need these
	_drawOrigin.x = ([self frame].size.width - _pelsPerUnit*[self getGraphedRect].size.width)/2;
	_drawOrigin.y = ([self frame].size.height - _pelsPerUnit*[self getGraphedRect].size.height)/2;

	// plot all the simulation data on the viewport
	CGContextRef	myContext = [[NSGraphicsContext currentContext] CGContext];
	NSArray*		spectrum = @[[NSColor blueColor],
								 [NSColor redColor],
								 [NSColor orangeColor],
								 [NSColor yellowColor],
								 [NSColor cyanColor]];
	[self _plotDataOn:myContext with:spectrum];

	// now draw the arrows for direction, or the contours for the scalar
	if ([self isComplex]) {
		// draw the arrows for the direction of the field at each point
		[self _drawArrowsOn:myContext with:[NSColor darkGrayColor]];
	} else {
		// draw the default contour lines for the scalar data
		NSArray*	units = @[@0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9];
		[self _drawContours:units on:myContext with:[NSColor darkGrayColor]];
	}

	// now draw all the objects in the workspace on top of this...
	[self _drawInventoryOn:myContext with:[NSColor blackColor]];

	NSLog(@"[ResultsView -drawRect:] - plot drawn in %.3f msec", ([NSDate timeIntervalSinceReferenceDate] - begin) * 1000);
}


//----------------------------------------------------------------------------
//               NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method is called by the runtime when the released object is about
 to get cleaned up. This gives us an opportunity to clean up all the
 memory we're using at the time and be a good citizen.
 */
- (void) dealloc
{
	// drop all the memory we're using
	[self freePlottingData];
	// ...and don't forget to call the super's dealloc too...
	[super dealloc];
}

@end
