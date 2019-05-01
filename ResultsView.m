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
 This method is used to draw the region under the argument in the view.
 */
- (void) drawRect:(NSRect)dirtyRect {
	// always do the super's call first, to make sure it's done right
    [super drawRect:dirtyRect];
    
    // Drawing code here.
	
	// set any NSColor for filling, say white:
	[[NSColor redColor] setFill];
	NSRectFill(dirtyRect);
}

@end
