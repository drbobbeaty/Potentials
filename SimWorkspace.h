//
//  SimWorkspace.h
//  Potentials
//
//  Created by Bob Beaty on Mon Apr 21 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// Apple Headers
#import <Foundation/Foundation.h>

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "MaskedMatrix.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


@interface SimWorkspace : NSObject {
	@private
	int					_rowCnt;
	int					_colCnt;
	NSRect				_workspaceRect;
	MaskedMatrix*		_rho;
	MaskedMatrix*		_er;
	MaskedMatrix*		_voltage;
	MaskedMatrix*		_resultantVoltage;
}

/*"              Accessor Methods                 "*/
- (int) getRowCount;
- (int) getColCount;
- (void) setWorkspaceRect:(NSRect)r;
- (NSRect) getWorkspaceRect;
- (void) setWorkspaceSize:(NSSize)size;
- (NSSize) getWorkspaceSize;
- (void) setWorkspaceOrigin:(NSPoint)p;
- (NSPoint) getWorkspaceOrigin;
- (void) setRho:(double)rho atNode:(NSPoint)p;
- (void) setRho:(double)rho atNodeRow:(int)r andCol:(int)c;
- (void) addRho:(double)rho atNode:(NSPoint)p;
- (void) addRho:(double)rho atNodeRow:(int)r andCol:(int)c;
- (MaskedMatrix*) getRho;
- (double) getRhoAtNode:(NSPoint)p;
- (double) getRhoAtNodeRow:(int)r andCol:(int)c;
- (void) setEpsilonR:(double)er atNode:(NSPoint)p;
- (void) setEpsilonR:(double)er atNodeRow:(int)r andCol:(int)c;
- (void) addEpsilonR:(double)er atNode:(NSPoint)p;
- (void) addEpsilonR:(double)er atNodeRow:(int)r andCol:(int)c;
- (MaskedMatrix*) getEpsilonR;
- (double) getEpsilonRAtNode:(NSPoint)p;
- (double) getEpsilonRAtNodeRow:(int)r andCol:(int)c;
- (void) setVoltage:(double)v atNode:(NSPoint)p;
- (void) setVoltage:(double)v atNodeRow:(int)r andCol:(int)c;
- (MaskedMatrix*) getVoltage;
- (double) getVoltageAtNode:(NSPoint)p;
- (double) getVoltageAtNodeRow:(int)r andCol:(int)c;
- (MaskedMatrix*) getResultantVoltage;
- (double) getResultantVoltageAtNode:(NSPoint)p;
- (double) getResultantVoltageAtNodeRow:(int)r andCol:(int)c;

/*"              Coordinate Mapping Methods       "*/
- (int) getColForXValue:(float)x;
- (float) getXValueForCol:(int)c;
- (float) getDeltaX;
- (int) getRowForYValue:(float)y;
- (float) getYValueForRow:(int)r;
- (float) getDeltaY;
- (NSPoint) getNodeInWorkspace:(NSPoint)p;
- (NSPoint) getNodeInWorkspaceAtX:(float)x Y:(float)y;
- (NSPoint) getPointInWorkspaceAtNode:(NSPoint)p;
- (NSPoint) getPointInWorkspaceAtNodeRow:(int)r andCol:(int)c;

/*"              Initialization Methods           "*/
- (id) initWithRect:(NSRect)r usingRows:(int)rowCnt andCols:(int)colCnt;
- (id) initWithSize:(NSSize)size andOrigin:(NSPoint)p usingRows:(int)rowCnt andCols:(int)colCnt;
- (void) freeAllStorage;

/*"              Simulation Methods               "*/
- (void) clearWorkspace;
- (BOOL) simulateWorkspace;
- (double) getResultantElectricFieldMagnitudeAtNode:(NSPoint)p;
- (double) getResultantElectricFieldMagnitudeAtNodeRow:(int)r andCol:(int)c;
- (double) getResultantElectricFieldDirectionAtNode:(NSPoint)p;
- (double) getResultantElectricFieldDirectionAtNodeRow:(int)r andCol:(int)c;

/*"              NSObject Overridden Methods      "*/
- (void) dealloc;

@end
