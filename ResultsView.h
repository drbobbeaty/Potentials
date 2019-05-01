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
@interface ResultsView : NSView

//----------------------------------------------------------------------------
//					Plotting Methods
//----------------------------------------------------------------------------

/*!
 This method colors the view in a distinctive way so I can see it on the
 screen and make sure it's OK.
 */
- (void) drawTestPattern;

//----------------------------------------------------------------------------
//               NSView Methods
//----------------------------------------------------------------------------

/*!
 This method is used to draw the region under the argument in the view.
 */
- (void) drawRect:(NSRect)dirtyRect;

@end

NS_ASSUME_NONNULL_END
