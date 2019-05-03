//
//  MaskedMatrix.m
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 28 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers

// System Headers
#include <math.h>

// Third Party Headers

// Other Headers

// Class Headers
#import "MaskedMatrix.h"

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
@implementation MaskedMatrix

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method gets the number of rows in the currently defined and
 allocated matrix. If there is no currently defined matrix, this method
 will return -1.
 */
- (int) getRowCount
{
	int			retval = -1;
	if (_data != nil) {
		retval = _rowCnt;
	}
	return retval;
}


/*!
 This method gets the number of columns in the currently defined and
 allocated matrix. If there is no currently defined matrix, this method
 will return -1;
 */
- (int) getColCount
{
	int			retval = -1;
	if (_data != nil) {
		retval = _colCnt;
	}
	return retval;
}


/*!
 This method gets the value of the point referenced by 'p' or 0 if the
 point 'p' is not yet set in this matrix. Use the -haveValueAt: method
 to determine if there is supposed to be a vlid value in the matrix at
 this point. Because an NSPoint holds floating point values, they will
 simply be converted to ints before the row/column lookup is done.
 */
- (double) getValueAt:(NSPoint)p
{
	return [self getValueAtRow:(int) p.x andCol:(int) p.y];
}


/*!
 This method gets the valus at the specified row and column of the matrix
 and returns it to the caller. If the specified point does not exist,
 we'll log the error, and return a 0 (which doesn't tell you much). It's
 best to call -haveValueAtRow:andCol: to ensure that the point exists and
 has a valid value before calling this method - just to be on the safe
 side.
 */
- (double) getValueAtRow:(int)r andCol:(int)c
{
	double		retval = 0.0;
	if ([self haveValueAtRow:r andCol:c]) {
		retval = _data[r][c];
	}
	return retval;
}


/*!
 This method will return the maximum value in the matrix as a single
 value so that users don't have to scan all the values themselves to
 get the limits on the data. If there are no values in the matrix, then
 NAN will be returned, and can be tested with isnan().
 */
- (double) getMaxValue
{
	double	retval = NAN;
	int		rows = [self getRowCount];
	int		cols = [self getColCount];

	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			if (_mask[i][j] && (!isnan(_data[i][j]) && !isinf(_data[i][j])) && (isnan(retval) || (retval < _data[i][j]))) {
				retval = _data[i][j];
			}
		}
	}
	return retval;
}


/*!
 This method will return the minimum value in the matrix as a single
 value so that users don't have to scan all the values themselves to
 get the limits on the data. If there are no values in the matrix, then
 NAN will be returned, and can be tested with isnan().
 */
- (double) getMinValue
{
	double	retval = NAN;
	int		rows = [self getRowCount];
	int		cols = [self getColCount];

	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			if (_mask[i][j] && (!isnan(_data[i][j]) && !isinf(_data[i][j])) && (isnan(retval) || (_data[i][j] < retval))) {
				retval = _data[i][j];
			}
		}
	}
	return retval;
}


/*!
 This method sets the value 'val' at the point in the matrix specified
 by the NSPoint, p. Of course, only the integer portion of the NSPoint's
 values are used, and at the same time the flag is set indicating that
 this value is valid.
 */
- (void) setValue:(double)val at:(NSPoint)p
{
	[self setValue:val atRow:(int) p.x andCol:(int) p.y];
}


/*!
 This method sets the value 'val' and the row 'r', and column 'c' in the
 matrix, assuming that the matrix is large enough to hold this element.
 If not, then we'll log the error and move on from there. If it's valid,
 then we'll flag this location in the matrix as containing valid data.
 */
- (void) setValue:(double)val atRow:(int)r andCol:(int)c
{
	BOOL			error = NO;

	// first, make sure we have something allocated at all
	int			rowCnt = [self getRowCount];
	int			colCnt = [self getColCount];
	if (!error) {
		if (rowCnt == -1) {
			error = YES;
			NSLog(@"[MaskedMatrix -setValue:atRow:andCol:] - there's no currently defined matrix at this time. Please do an -initWithRows:andCols: to establish an upper limit on the matrix you're interested in using and then call this method.");
		}
	}

	// next, make sure the row and column are within acceptable limits
	if (!error) {
		if ((r < 0) || (r >= rowCnt)) {
			error = YES;
			NSLog(@"[MaskedMatrix -setValue:atRow:andCol:] - the currently defined matrix has rows from 0 to %d, and the passed in value of %d is outside that range. Please make sure that the value falls within that range, or create a bigger matrix.", rowCnt, r);
		}
	}
	if (!error) {
		if ((c < 0) || (c >= colCnt)) {
			error = YES;
			NSLog(@"[MaskedMatrix -setValue:atRow:andCol:] - the currently defined matrix has columns from 0 to %d, and the passed in value of %d is outside that range. Please make sure that the value falls within that range, or create a bigger matrix.", (colCnt-1), c);
		}
	}

	// if all is OK, then save the value and flag it correctly
	if (!error) {
		_data[r][c] = val;
		_mask[r][c] = YES;
	}
}


/*!
 This method returns YES if the current matrix contains a valid value
 at the location referenced by the NSPoint, p. Of course, only the integer
 portion of the NSPoint values will be used, but if this method returns
 YES, then there's something there that the user put there.
 */
- (BOOL) haveValueAt:(NSPoint)p
{
	return [self haveValueAtRow:(int) p.x andCol:(int) p.y];
}


/*!
 This method checks to see if the matrix has a vlid value referenced by
 the supplied row and column. This is important because a lot of the
 other routines use this guy to see if there's any reason to dig deeper
 to get a value.
 */
- (BOOL) haveValueAtRow:(int)r andCol:(int)c
{
	BOOL			error = NO;

	// first, make sure we have something allocated at all
	int			rowCnt = [self getRowCount];
	int			colCnt = [self getColCount];
	if (!error) {
		if (rowCnt == -1) {
			error = YES;
			NSLog(@"[MaskedMatrix -haveValueAtRow:andCol:] - there's no currently defined matrix at this time. Please do an -initWithRows:andCols: to establish an upper limit on the matrix you're interested in using and then call this method.");
		}
	}

	// next, make sure the row and column are within acceptable limits
	if (!error) {
		if ((r < 0) || (r >= rowCnt)) {
			error = YES;
		}
	}
	if (!error) {
		if ((c < 0) || (c >= colCnt)) {
			error = YES;
		}
	}

	// if all is OK, then save the value and flag it correctly
	if (!error) {
		if (!_mask[r][c]) {
			error = YES;
		}
	}

	return !error;
}


/*!
 This method makes the point in the matrix referenced by the NSPoint, p,
 no longer 'valid' for the sake of getting values from the matrix.
 */
- (void) discardValueAt:(NSPoint)p
{
	[self discardValueAtRow:(int) p.x andCol:(int) p.y];
}


/*!
 This method makes the point in the matrix referenced by the row and
 column provided no longer 'valid' for the sake of getting values from
 the matrix.
 */
- (void) discardValueAtRow:(int)r andCol:(int)c
{
	if ([self haveValueAtRow:r andCol:c]) {
		_mask[r][c] = NO;
	}
}


/*!
 This method is a handy way to "clear out" this matrix of data without
 having to step through it one element at a time. It's easier and faster
 this way.
 */
- (void) discardAllValues
{
	int		rows = [self getRowCount];
	int		cols = [self getColCount];
	int		i = 0;
	int		j = 0;

	for (i = 0; i < rows; i++) {
		for (j = 0; j < cols; j++) {
			_mask[i][j] = NO;
		}
	}
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
	int				i = 0;

	// first, let's make sure the super can be initialized
	if (!error && (_data == nil) && (_mask == nil)) {
		if (!(self = [super init])) {
			error = YES;
			NSLog(@"[MaskedMatrix -initWithRows:andCols:] - the superclass could not complete it's -init method. Please check the logs for a possible cause.");
		}
	}

	// next, release all that we might have right now
	if (!error) {
		[self freeMatrixData];
	}

	// now, first try to allocate the vector of pointers for the doubles
	if (!error) {
		_data = (double **) malloc( rowCnt * sizeof(double *) );
		if (_data == nil) {
			error = YES;
			NSLog(@"[MaskedMatrix -initWithRows:andCols:] - while trying to create the vector of pointers for the doubles (%d rows), I ran into a memory allocation problem and couldn't continue. Please check into this as soon as possible.", rowCnt);
		}
	}

	// next, try to allocate each row of doubles
	if (!error) {
		for (i = 0; i < rowCnt; i++) {
			_data[i] = (double *) malloc( colCnt * sizeof(double) );
			if (_data[i] == nil) {
				error = YES;
				NSLog(@"[MaskedMatrix -initWithRows:andCols:] - while trying to create a row of doubles (%d out of %d rows), I ran into a memory allocation problem and couldn't continue. Please check into this as soon as possible.", (i+1), rowCnt);
			}
		}
	}

	// next, try to allocate the vector of pointers for the BOOLs
	if (!error) {
		_mask = (BOOL **) malloc( rowCnt * sizeof(BOOL *) );
		if (_mask == nil) {
			error = YES;
			NSLog(@"[MaskedMatrix -initWithRows:andCols:] - while trying to create the vector of pointers for the BOOLs (%d rows), I ran into a memory allocation problem and couldn't continue. Please check into this as soon as possible.", rowCnt);
		}
	}

	// next, try to allocate each row of BOOLs
	if (!error) {
		for (i = 0; i < rowCnt; i++) {
			_mask[i] = (BOOL *) malloc( colCnt * sizeof(BOOL) );
			if (_mask[i] == nil) {
				error = YES;
				NSLog(@"[MaskedMatrix -initWithRows:andCols:] - while trying to create a row of BOOLs (%d out of %d rows), I ran into a memory allocation problem and couldn't continue. Please check into this as soon as possible.", (i+1), rowCnt);
			}
		}
	}

	// if we have had any error we need to clean up what we've done
	if (error) {
		// first, try to clean out any BOOL rows
		if (_mask != nil) {
			// free up each of the rows themselves
			for (i = 0; i < rowCnt; i++) {
				if (_mask[i] != nil) {
					free(_mask[i]);
					_mask[i] = nil;
				}
			}
			// ...and then free up the vector of pointers
			free(_mask);
			_mask = nil;
		}
		// ...now try to clean out any double rows
		if (_data != nil) {
			// free up each of the rows themselves
			for (i = 0; i < rowCnt; i++) {
				if (_data[i] != nil) {
					free(_data[i]);
					_data[i] = nil;
				}
			}
			// ...and then free up the vector of pointers
			free(_data);
			_data = nil;
		}
	} else {
		// save these as they have been successfully allocated and are valid
		_rowCnt = rowCnt;
		_colCnt = colCnt;
	}

	return (error ? nil : self);
}


/*!
 This method drops and allocated matrix for this instance, and is used
 to clean up the memory used and be a good non-leaking citizen.
 */
- (void) freeMatrixData
{
	int		i = 0;

	// we're going to free it in the opposite order it was malloced
	if (_mask != nil) {
		// free up each of the rows themselves
		for (i = 0; i < _rowCnt; i++) {
			if (_mask[i] != nil) {
				free(_mask[i]);
				_mask[i] = nil;
			}
		}
		// ...and then free up the vector of pointers
		free(_mask);
		_mask = nil;
	}

	if (_data != nil) {
		// free up each of the rows themselves
		for (i = 0; i < _rowCnt; i++) {
			if (_data[i] != nil) {
				free(_data[i]);
				_data[i] = nil;
			}
		}
		// ...and then free up the vector of pointers
		free(_data);
		_data = nil;
	}

	// make sure to clear out the size of the array now
	_rowCnt = 0;
	_colCnt = 0;
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
	[self freeMatrixData];
	// ...and don't forget to call the super's dealloc too...
	[super dealloc];
}

@end
