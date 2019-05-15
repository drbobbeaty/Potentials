//
//  ResultsView_Protected.m
//  Potentials
//
//  Created by Bob Beaty on 5/8/19.
//

// Apple Headers

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
 These are the 'protected' methods on the ResultsView object. They are
 protected as a category because they can do a lot more damage than good
 in the wrong hands, but we want to keep everything well encapsulated so
 we need these methods, we just don't want them in the public API that
 everyone gets to see. So they are here.
 */
@implementation ResultsView (Protected)

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method gets the actual minimum value of the displayed graphical data.
 This is the un-scaled value, that internally will be used to scale all the
 plotting data from [0..1].
 */
- (void) _setGraphedMin:(double)value
{
	_graphedMin = value;
}


/*!
 This method gets the actual maximum value of the displayed graphical data.
 This is the un-scaled value, that internally will be used to scale all the
 plotting data from [0..1].
 */
- (void) _setGraphedMax:(double)value
{
	_graphedMax = value;
}


/*!
 This method returns the shape of the simulated workspace that is being
 plotted on this view. This is the un-scaled shape, and is used in the
 mapping from that workspace to the view.
 */
- (void) _setGraphedRect:(NSRect)shape
{
	_workspaceRect = shape;
}


/*!
 This method sets the inventory of drawable objects from the SimWorkspace
 so that we can draw them on the simulation plot. They are all scaled to
 have linear dimensions [0..1] so it's easy to place them on the NSView.
 */
- (void) _setInventory:(NSArray*)inventory
{
	if (_inventory != inventory) {
		[_inventory release];
		_inventory = [inventory retain];
	}
}


//----------------------------------------------------------------------------
//               Component Drawing Methods
//----------------------------------------------------------------------------

/*!
 This method takes the context on which to draw the colorized 2D heat map of
 data, and the array of colors to blend between for the different [0..1]
 values. This will simply draw all the rectangles of diffderent colors based
 on the values in this instance - nothing more.
 */
- (BOOL) _plotDataOn:(CGContextRef)ctext with:(NSArray*)colors
{
	BOOL			error = NO;

	NSUInteger 		stages = [colors count];
	double			dc = 1.0/(stages - 1);
	if (_values != nil) {
		CGFloat		dx = [self frame].size.width / [self getColCount];
		CGFloat		dy = [self frame].size.height / [self getRowCount];
		NSColor*	gc = nil;
		double		x = 0.0;
		NSUInteger	ilow = 0;
		for (int r = 0; r < [self getRowCount]; r++) {
			for (int c = 0; c < [self getColCount]; c++) {
				x = _values[r][c];
				ilow = MIN((int)(x/dc), (stages-2));
				x -= ilow * dc;
				if ((gc = [ResultsView interpolate:(x/dc) withColorsBetween:colors[ilow] and:colors[ilow+1]])) {
					[gc setFill];
					CGContextFillRect(ctext, CGRectMake(c*dx, r*dy, dx, dy));
				}
			}
		}
	}

	return !error;
}


/*!
 This method takes the context on which to draw the inventory of objects that
 were part of the simulation, as well as a color to render them in. This
 just makes it easy to optionally draw the inventory - at the user's request.
 */
- (BOOL) _drawInventoryOn:(CGContextRef)ctext with:(NSColor*)color
{
	BOOL			error = NO;

	if ([self getInventory] != nil) {
		for (NSDictionary* item in [self getInventory]) {
			if (item != nil) {
				[self _draw:item on:ctext with:color];
			}
		}
	}

	return !error;
}


/*!
 This method takes an object - defined as an NSDictionary, and the context
 on which to draw it, as well as a color to render in - and then draws it
 as needed. This just gets called for each item in the Inventory.
 */
- (BOOL) _draw:(NSDictionary*)item on:(CGContextRef)ctext with:(NSColor*)color
{
	BOOL			error = NO;

	// grab the scale factors for the [0..1] ranges
	CGFloat		sx = [self frame].size.width;
	CGFloat		sy = [self frame].size.height;
	// make sure we default to black for the drawing
	if (color == nil) {
		color = [NSColor blackColor];
	}

	// if we have an item to draw - do it!
	if (item != nil) {
		// get the type of item that needs to be drawn
		NSString*	draw = item[@"draw"];
		if ([draw isEqualToString:@"line"]) {
			// get the specifics for the line from the data
			NSPoint		beg = [item[@"from"] pointValue];
			NSPoint		end = [item[@"to"] pointValue];
			// map it to the viewport for drawing
			beg.x *= sx;
			beg.y *= sy;
			end.x *= sx;
			end.y *= sy;
			CGPoint		line[] = {beg, end};
			NSLog(@"[ResultsView -draw:on:with:] - drawing line inventory: (%.2f, %.2f) -> (%.2f, %.2f)", beg.x, beg.y, end.x, end.y);
			// draw the line in the viewport
			CGContextBeginPath(ctext);
			CGContextSetLineWidth(ctext, 1.0);
			[color setStroke];
			CGContextAddLines(ctext, line, 2);
			CGContextStrokePath(ctext);
		} else if ([draw isEqualToString:@"rect"]) {
			// get the specifics for the rectangle from the data
			NSRect		rect = [item[@"data"] rectValue];
			// map it to the viewport for drawing
			rect.origin.x *= sx;
			rect.origin.y *= sy;
			rect.size.width *= sx;
			rect.size.height *= sy;
			NSLog(@"[ResultsView -draw:on:with:] - drawing rect inventory: (%.2f, %.2f) %.2fx%.2f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
			// draw the rectangle in the viewport
			CGContextBeginPath(ctext);
			CGContextSetLineWidth(ctext, 1.0);
			[color setStroke];
			CGContextAddRect(ctext, rect);
			CGContextStrokePath(ctext);
		} else if ([draw isEqualToString:@"point"]) {
			// get the specifics for the point from the data
			NSPoint		pt = [item[@"data"] pointValue];
			// map it to the viewport for drawing
			pt.x *= sx;
			pt.y *= sy;
			NSLog(@"[ResultsView -draw:on:with:] - drawing point inventory: (%.2f, %.2f)", pt.x, pt.y);
			// draw the point in the viewport
			[color setStroke];
			CGContextFillRect(ctext, CGRectMake(pt.x, pt.y, 3, 3));
		} else if ([draw isEqualToString:@"circle"]) {
			// get the specifics for the circle from the data
			NSRect		rect = [item[@"data"] rectValue];
			// map it to the viewport for drawing
			rect.origin.x *= sx;
			rect.origin.y *= sy;
			rect.size.width *= sx;
			rect.size.height *= sy;
			NSLog(@"[ResultsView -draw:on:with:] - drawing circle inventory: (%.2f, %.2f) %.2fx%.2f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
			// draw the circle in the viewport
			CGContextBeginPath(ctext);
			CGContextSetLineWidth(ctext, 1.0);
			[color setStroke];
			CGContextAddEllipseInRect(ctext, rect);
			CGContextStrokePath(ctext);
		} else {
			NSLog(@"[ResultsView -draw:on:with:] - unable to draw the figure: %@", item);
		}
	}

	return !error;
}


/*!
 This method takes the array of values, and draws the contour lines for each
 in the provided context. These values will be in the interval [0..1] and in
 keeping with the scaled plotted values.
 */
- (BOOL) _drawContours:(NSArray*)values on:(CGContextRef)ctext with:(NSColor*)color
{
	BOOL			error = NO;

	if (values != nil) {
		for (NSNumber* num in values) {
			if (num != nil) {
				[self _drawContour:[num doubleValue] on:ctext with:color];
			}
		}
	}

	return !error;
}


/*!
 This method takes a single value, and draws the contour line(s) for this
 value in the provided context. The value will be in the interval [0..1] and
 in keeping with the scaled plotted values.
 */
- (BOOL) _drawContour:(double)value on:(CGContextRef)ctext with:(NSColor*)color
{
	BOOL			error = NO;

	if (_values != nil) {
		CGFloat		dx = [self frame].size.width / [self getColCount];
		CGFloat		dy = [self frame].size.height / [self getRowCount];
		BOOL		ul, ur, ll, lr;
		NSPoint		pbeg, pend, qbeg, qend;
		NSPoint		oob = NSMakePoint(-1, -1);		// out-of-bounds point
		CGFloat		x = 0.0, y = 0.0;
		for (int r = 0; r < ([self getRowCount]-1); r++) {
			for (int c = 0; c < ([self getColCount]-1); c++) {
				// reset the origin of this square
				x = c*dx;
				y = r*dy;
				// reset the endpoints of the line(s)
				pbeg = oob;		// line 'p'
				pend = oob;
				qbeg = oob;		// line 'q'
				qend = oob;
				// now compute the in/out state of the four corners
				ul = (_values[r+1][c] < value);
				ur = (_values[r+1][c+1] < value);
				ll = (_values[r][c] < value);
				lr = (_values[r][c+1] < value);
				// look at all 16 possibilities, and see what line(s) are needed
				if ((ul && ur && ll && lr) || (!ul && !ur && !ll && !lr)) {
					// do nothing - uniform across the square
					continue;
				} else if ((ul && !ur && !ll && !lr) || (!ul && ur && ll && lr)) {
					// line from left to top
					pbeg = NSMakePoint(x, y+dy/2);
					pend = NSMakePoint(x+dx/2, y+dy);
				} else if ((!ul && ur && !ll && !lr) || (ul && !ur && ll && lr)) {
					// line from right to top
					pbeg = NSMakePoint(x+dx, y+dy/2);
					pend = NSMakePoint(x+dx/2, y+dy);
				} else if ((!ul && !ur && ll && !lr) || (ul && ur && !ll && lr)) {
					// line from left to bottom
					pbeg = NSMakePoint(x, y+dy/2);
					pend = NSMakePoint(x+dx/2, y);
				} else if ((!ul && !ur && !ll && lr) || (ul && ur && ll && !lr)) {
					// line from right to bottom
					pbeg = NSMakePoint(x+dx, y+dy/2);
					pend = NSMakePoint(x+dx/2, y);
				} else if ((ul && ur && !ll && !lr) || (!ul && !ur && ll && lr)) {
					// line from left to right
					pbeg = NSMakePoint(x, y+dy/2);
					pend = NSMakePoint(x+dx, y+dy/2);
				} else if ((ul && !ur && ll && !lr) || (!ul && ur && !ll && lr)) {
					// line from bottom to top
					pbeg = NSMakePoint(x+dx/2, y);
					pend = NSMakePoint(x+dx/2, y+dy);
				} else if (ul && !ur && !ll && lr) {
					// two lines: left to top, and bottom to right
					pbeg = NSMakePoint(x, y+dy/2);
					pend = NSMakePoint(x+dx/2, y+dy);
					qbeg = NSMakePoint(x+dx, y+dy/2);
					qend = NSMakePoint(x+dx/2, y);
				} else if (!ul && ur && ll && !lr) {
					// two lines: left to bottom, and top to right
					pbeg = NSMakePoint(x, y+dy/2);
					pend = NSMakePoint(x+dx/2, y);
					qbeg = NSMakePoint(x+dx, y+dy/2);
					qend = NSMakePoint(x+dx/2, y+dy);
				}
				// now see what we need to draw... we have line 'p'...
				CGPoint		line[] = {pbeg, pend};
				// draw the line in the viewport
				CGContextBeginPath(ctext);
				CGContextSetLineWidth(ctext, 1.0);
				[color setStroke];
				CGContextAddLines(ctext, line, 2);
				CGContextStrokePath(ctext);
				// see if we have line 'q'...
				if (!NSEqualPoints(qbeg, oob)) {
					CGPoint		line[] = {qbeg, qend};
					// draw the line in the viewport
					CGContextBeginPath(ctext);
					CGContextSetLineWidth(ctext, 1.0);
					[color setStroke];
					CGContextAddLines(ctext, line, 2);
					CGContextStrokePath(ctext);
				}
			}
		}
	}

	return !error;
}

@end
