//
//  ResultsView.m
//  Potentials
//
//  Created by Bob Beaty on 5/1/19.
//  Copyright (c) 2019 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers

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
 This class is the output plotting view of the Voltage and Electric Field
 for the simulation. This has to be written because we really couldn't find
 a suitable graphing solution.
 */
@implementation ResultsView

//----------------------------------------------------------------------------
//					Plotting Methods
//----------------------------------------------------------------------------

/*!
 This method colors the view in a distinctive awy so I can see it on the
 screen and make sure it's OK.
 */
- (void) drawTestPattern
{
	NSLog(@"[ResultsView -drawTestPattern:] - ready to draw the test pattern in the view.");
}


/*!
 This method takes the provided SimWorkspace and plots the Voltage as a
 function of x and y, based on the row, col organization of the Voltage
 data within the SimWorkspace.
 */
- (void) plotVoltage:(SimWorkspace*) workspace
{
	BOOL				error = NO;

	// first, make sure that there's a workspace to plot
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
		for (int r = 0; r < _rowCnt; r++) {
			for (int c = 0; c < _colCnt; c++) {
				// now get the results at this node
				v = [workspace getResultantVoltageAtNodeRow:r andCol:c];
				// save all this for drawing
				_values[r][c] = (v - Vmin)/(Vmax - Vmin);
			}
		}
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

	// make sure to clear out the size of the array now
	_rowCnt = 0;
	_colCnt = 0;
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
    
	// start with a white background for the drawing area...
	[[NSColor whiteColor] setFill];
	NSRectFill(dirtyRect);

	// plot all the data on a uniform grid
	CGContextRef	myContext = nil;
	NSColor*		spectrum[] = {[NSColor redColor],
								  [NSColor orangeColor],
								  [NSColor yellowColor],
								  [NSColor cyanColor]};
	int 			stages = 4;
	double			dc = 1.0/(stages - 1);
	if (_values != nil) {
		NSLog(@"[ResultsView -drawRect:] - starting to draw the data...");
		myContext = [[NSGraphicsContext currentContext] CGContext];
		CGFloat		dx = [self frame].size.width / _colCnt;
		CGFloat		dy = [self frame].size.height / _rowCnt;
		CGFloat		gs = MIN(dx, dy);
		NSColor*	gc = nil;
		CGFloat		red, grn, blu, alph;
		double		x = 0.0;
		int 		ilow = 0;
		for (int r = 0; r < _rowCnt; r++) {
			for (int c = 0; c < _colCnt; c++) {
				x = _values[r][c];
				ilow = MIN((int)(x/dc), (stages-2));
				x -= ilow * dc;
				gc = [ResultsView interpolate:(x/dc) withColorsBetween:spectrum[ilow] and:spectrum[ilow+1]];
				if (gc) {
					[gc getRed:(&red) green:(&grn) blue:(&blu) alpha:(&alph)];
					CGContextSetRGBFillColor(myContext, red, grn, blu, alph);
					CGContextFillRect(myContext, CGRectMake(c*gs, r*gs, gs, gs));
				}
			}
		}
	}
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
