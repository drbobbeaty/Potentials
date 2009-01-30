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


@interface MaskedMatrix : NSObject {
	@private
	int				_rowCnt;
	int				_colCnt;
	double**		_data;
	BOOL**			_mask;
}

/*"              Accessor Methods             "*/
- (int) getRowCount;
- (int) getColCount;
- (double) getValueAt:(NSPoint)p;
- (double) getValueAtRow:(int)r andCol:(int)c;
- (void) setValue:(double)val at:(NSPoint)p;
- (void) setValue:(double)val atRow:(int)r andCol:(int)c;
- (BOOL) haveValueAt:(NSPoint)p;
- (BOOL) haveValueAtRow:(int)r andCol:(int)c;
- (void) discardValueAt:(NSPoint)p;
- (void) discardValueAtRow:(int)r andCol:(int)c;
- (void) discardAllValues;

/*"              Initialization Methods       "*/
- (id) initWithRows:(int)rowCnt andCols:(int)colCnt;
- (void) freeMatrixData;

/*"              NSObject Overridden Methods  "*/
- (void) dealloc;

@end
