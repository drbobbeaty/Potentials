//
//  MaskedMatrix.h
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 28 2003.
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

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class MaskedMatrix
 This class is exceptionally handy for dealing with values in a matrix
 that may or may not have been set by the user of this class. The problem
 with floating point values is that there's no "not set yet" value. This
 is then solved by bonding together a matrix of doubles and a matrix of
 BOOLs and then using the BOOLs as a mask into the doubles so that we can
 be sure when each value is set, and unset.
 
 The workspace uses a few of these masked matrices to hold the properties
 of the simulation underway. It's a very convenient way to encapsulate
 the knowledge of "where" things are "supposed" to be, and where they are
 not.
 */
@interface MaskedMatrix : NSObject {
	@private
	int				_rowCnt;
	int				_colCnt;
	double**		_data;
	BOOL**			_mask;
}

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method gets the number of rows in the currently defined and
 allocated matrix. If there is no currently defined matrix, this method
 will return -1.
 */
- (int) getRowCount;

/*!
 This method gets the number of columns in the currently defined and
 allocated matrix. If there is no currently defined matrix, this method
 will return -1;
 */
- (int) getColCount;

/*!
 This method gets the value of the point referenced by 'p' or 0 if the
 point 'p' is not yet set in this matrix. Use the -haveValueAt: method
 to determine if there is supposed to be a vlid value in the matrix at
 this point. Because an NSPoint holds floating point values, they will
 simply be converted to ints before the row/column lookup is done.
 */
- (double) getValueAt:(NSPoint)p;

/*!
 This method gets the valus at the specified row and column of the matrix
 and returns it to the caller. If the specified point does not exist,
 we'll log the error, and return a 0 (which doesn't tell you much). It's
 best to call -haveValueAtRow:andCol: to ensure that the point exists and
 has a valid value before calling this method - just to be on the safe
 side.
 */
- (double) getValueAtRow:(int)r andCol:(int)c;

/*!
 This method will return the maximum value in the matrix as a single
 value so that users don't have to scan all the values themselves to
 get the limits on the data. If there are no values in the matrix, then
 NAN will be returned, and can be tested with isnan().
 */
- (double) getMaxValue;

/*!
 This method will return the minimum value in the matrix as a single
 value so that users don't have to scan all the values themselves to
 get the limits on the data. If there are no values in the matrix, then
 NAN will be returned, and can be tested with isnan().
 */
- (double) getMinValue;

/*!
 This method sets the value 'val' at the point in the matrix specified
 by the NSPoint, p. Of course, only the integer portion of the NSPoint's
 values are used, and at the same time the flag is set indicating that
 this value is valid.
 */
- (void) setValue:(double)val at:(NSPoint)p;

/*!
 This method sets the value 'val' and the row 'r', and column 'c' in the
 matrix, assuming that the matrix is large enough to hold this element.
 If not, then we'll log the error and move on from there. If it's valid,
 then we'll flag this location in the matrix as containing valid data.
 */
- (void) setValue:(double)val atRow:(int)r andCol:(int)c;

/*!
 This method returns YES if the current matrix contains a valid value
 at the location referenced by the NSPoint, p. Of course, only the integer
 portion of the NSPoint values will be used, but if this method returns
 YES, then there's something there that the user put there.
 */
- (BOOL) haveValueAt:(NSPoint)p;

/*!
 This method checks to see if the matrix has a vlid value referenced by
 the supplied row and column. This is important because a lot of the
 other routines use this guy to see if there's any reason to dig deeper
 to get a value.
 */
- (BOOL) haveValueAtRow:(int)r andCol:(int)c;

/*!
 This method makes the point in the matrix referenced by the NSPoint, p,
 no longer 'valid' for the sake of getting values from the matrix.
 */
- (void) discardValueAt:(NSPoint)p;

/*!
 This method makes the point in the matrix referenced by the row and
 column provided no longer 'valid' for the sake of getting values from
 the matrix.
 */
- (void) discardValueAtRow:(int)r andCol:(int)c;

/*!
 This method is a handy way to "clear out" this matrix of data without
 having to step through it one element at a time. It's easier and faster
 this way.
 */
- (void) discardAllValues;

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
 This method drops and allocated matrix for this instance, and is used
 to clean up the memory used and be a good non-leaking citizen.
 */
- (void) freeMatrixData;

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
