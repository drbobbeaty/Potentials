//
//  SimWorkspace_Protected.m
//  Potentials
//
//  Created by Bob Beaty on Thu May 08 2003.
//  Copyright (c) 2003 The Man from S.P.U.D.. All rights reserved.
//

// RCS Identification information
static char *rcsID = "$Id: SimWorkspace_Protected.m,v 1.1 2008/08/07 20:32:58 drbob Exp $";
static void __AvoidCompilerWarning(void) { if(!rcsID)__AvoidCompilerWarning(); }

// Apple Headers

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "SimWorkspace_Protected.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


@implementation SimWorkspace (Protected)
/*"
**	These are the 'protected' methods on the SimWorkspace object. They are
**	protected as a category because they can do a lot more damage than good
**	in the wrong hands, but we want to keep everything well encapsulated so
**	we need these methods, we just don't want them in the public API that
**	everyone gets to see. So they are here.
"*/

//----------------------------------------------------------------------------
//               Accessor Methods
//----------------------------------------------------------------------------

- (void) _setRowCount:(int)r
/*"
**	This method sets the number of rows in the simulation grid that we'll be
**	using. This doesn't effect any of the allocated storage, and so changing
**	this without carefully changing the storage is going to mess things up
**	something fierce. Please use this carefully. Typically, it's only called
**	within the init methods.
"*/
{
	_rowCnt = r;
}


- (void) _setColCount:(int)c
/*"
**	This method sets the number of columns in the simulation grid that we'll be
**	using. This doesn't effect any of the allocated storage, and so changing
**	this without carefully changing the storage is going to mess things up
**	something fierce. Please use this carefully. Typically, it's only called
**	within the init methods.
"*/
{
	_colCnt = c;
}


- (void) _setRho:(MaskedMatrix*)rho
/*"
**	This method sets the matrix being used to hold the fixed values of the
**	fixed sheet charge density for the simulation and is usually only
**	done within the init method. The size of this matrix has to match the
**	rows and columns set for this simulation workspace or we're going to
**	have a very messy time sorting things out.
"*/
{
	if (_rho != rho) {
		[_rho release];
		_rho = [rho retain];
	}
}


- (void) _setEpsilonR:(MaskedMatrix*)er
/*"
**	This method sets the matrix being used to hold the fixed values of the
**	relative dielectric constant for the simulation and is usually only
**	done within the init method. The size of this matrix has to match the
**	rows and columns set for this simulation workspace or we're going to
**	have a very messy time sorting things out.
"*/
{
	if (_er != er) {
		[_er release];
		_er = [er retain];
	}
}


- (void) _setVoltage:(MaskedMatrix*)v
/*"
**	This method sets the matrix being used to hold the fixed values of the
**	electrostatic potential for the simulation and is usually only
**	done within the init method. The size of this matrix has to match the
**	rows and columns set for this simulation workspace or we're going to
**	have a very messy time sorting things out.
"*/
{
	if (_voltage != v) {
		[_voltage release];
		_voltage = [v retain];
	}
}


- (void) _setResultantVoltage:(MaskedMatrix*)results
/*"
**	This method sets the matrix being used to hold the results of the
**	simulated voltage values and is usually only done within the simulation
**	methods. The size of this matrix has to match the rows and columns set
**	for this simulation workspace or we're going to have a very messy time
**	sorting things out.
"*/
{
	if (_resultantVoltage != results) {
		[_resultantVoltage release];
		_resultantVoltage = [results retain];
	}
}

@end
