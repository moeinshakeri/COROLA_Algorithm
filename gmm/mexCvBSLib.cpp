//This mex file is written by Zoran Zivkovic 
// and
// Updated by Moein Shakeri to:
//
// set input from MATLAB for all mu, sigma and weights for all components
// set variable distance for each pixel independently
// set the function to report all mu, sigma, weights and distances for each pixel and all component to MATLAB via Mex file
//
//
//Example usage: See the matlab file mexCvBSLib.m 
//
//Author: Z.Zivkovic, www.zoranz.net, Updated by Moein Shakeri
//Date: 28-February-2007
//Using ObjectHandle.h from Tim Bailey
//Updated by Moein Shakeri, June 2016
///////////

#include "ObjectHandle.h"
#include "CvPixelBackgroundGMM.h"

class MyClass {
	CvPixelBackgroundGMM* pGMM;
public:
	MyClass(int width,int height) {pGMM=cvCreatePixelBackgroundGMM(width,height); mexPrintf("MyClass created.\n"); }
	~MyClass() {cvReleasePixelBackgroundGMM(&pGMM); mexPrintf("MyClass destroyed.\n"); }
	// updated by Moein Shakeri
	void process(unsigned char* imagein, unsigned char* imageout, unsigned char* image_R, unsigned char* image_G,unsigned char* image_B,unsigned char* image_S,unsigned char* image_W, unsigned char* distout) {cvUpdatePixelBackgroundGMMTiled(pGMM,imagein,imageout,image_R,image_G,image_B,image_S,image_W,distout);}
	void setParameters(double* pars);
	// Written by Moein Shakeri to set parameters
	void ReplaceBG(unsigned char* BG_input, unsigned char* image_R, unsigned char* image_G,unsigned char* image_B,unsigned char* image_S,unsigned char* image_W, unsigned char* distout) {cvSetPixelBackgroundGMM(pGMM,BG_input,image_R,image_G,image_B,image_S,image_W,distout);mexPrintf("Executed.\n");}
	// written by Moein Shakeri to set distance for each pixel independently.
	void import_dist(unsigned char* Dist_Matrix) {cvSetDistanceGMM(pGMM,Dist_Matrix);}
};


void MyClass::setParameters(double* pars)
{
//	mexPrintf("fAlphaT: %f\n", pars[0]);
	pGMM->fAlphaT=(float)pars[0];
//	mexPrintf("fTb: %f\n", pars[1]);
	pGMM->fTb=(float)pars[1];
//	mexPrintf("bShadowDetection: %f\n", pars[2]);
	pGMM->bShadowDetection=(int)pars[2];
//	mexPrintf("fTau: %f\n", pars[3]);
	pGMM->fTau=(float)pars[3];	
}


/* Input Arguments */

// updated by moein Shakeri
#define	I_IN	    prhs[0]
#define	PDATA_IN	prhs[1]
#define	PARS_IN     prhs[2]
#define DISTANCE_IN prhs[3]
#define BG_IN       prhs[4]

/* Output Arguments */

// Updated by Moein Shakeri
#define	I_OUT	   plhs[0]
#define R_OUT      plhs[1]
#define G_OUT      plhs[2]
#define B_OUT      plhs[3]
#define S_OUT      plhs[4]
#define W_OUT      plhs[5]
#define DIST_OUT   plhs[6]

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )     
{
	int nD;
    const int  *rND; 
	MyClass *mine=0;

	if (nrhs == 0)
	{
		mexErrMsgTxt("Need at least one input argument.");
		return;
	}

	if ( nlhs == 0 && nrhs == 1 ) 
	{
		//release memory 
		ObjectHandle<MyClass>* handle = ObjectHandle<MyClass>::from_mex_handle(prhs[0]);
	    delete handle;
		return;
	}

    // Get image size
	nD=mxGetNumberOfDimensions(I_IN);
    rND=mxGetDimensions(I_IN);
	if ((nD != 3) || (rND[2] != 3))
	{
			mexErrMsgTxt("Need RGB image");
			return;
	}
	
	if (nlhs == 1 && nrhs == 1) 
	{
		//create structure

		//RGB image is provoded
		mine = new MyClass(rND[0],rND[1]);	

		//mexPrintf("Pointer before: %#x, ", mine);
		ObjectHandle<MyClass> *handle = new ObjectHandle<MyClass>(mine);
		//mexPrintf("Pointer after: %#x\n", mine);
		plhs[0] = handle->to_mex_handle();
	}
	// Written by Moein Shakeri to set input parameters for all weights, distances, mu and sigma
	else if (nlhs == 7 && nrhs == 2 )
	{
		//update background
		MyClass& mine = get_object<MyClass>(PDATA_IN);

		// Create a matrix for the return argument
		I_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		R_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		G_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		B_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		S_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		W_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		DIST_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);

		/* Assign pointers to the various parameters */
		unsigned char* imageout = (unsigned char*) mxGetData(I_OUT);
		unsigned char* imagein = (unsigned char*) mxGetData(I_IN);
		unsigned char* image_R = (unsigned char*) mxGetData(R_OUT);
		unsigned char* image_G = (unsigned char*) mxGetData(G_OUT);
		unsigned char* image_B = (unsigned char*) mxGetData(B_OUT);
		unsigned char* image_S = (unsigned char*) mxGetData(S_OUT);
		unsigned char* image_W = (unsigned char*) mxGetData(W_OUT);
		unsigned char* distout = (unsigned char*) mxGetData(DIST_OUT);

		mine.process(imagein,imageout,image_R,image_G,image_B,image_S,image_W,distout);

	}
	// Written by Moein Shakeri to set inputs and get outputs parameters for all weights, distances, mu and sigma
	else if (nlhs == 7 && nrhs == 5 )
	{
		//update background
		MyClass& mine = get_object<MyClass>(PDATA_IN);

		// Create a matrix for the return argument
		I_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		R_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		G_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		B_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		S_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		W_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);
		DIST_OUT = mxCreateNumericArray(2,rND,mxUINT8_CLASS, mxREAL);


		/* Assign pointers to the various parameters */
		unsigned char* imageout = (unsigned char*) mxGetData(I_OUT);
		unsigned char* imagein = (unsigned char*) mxGetData(I_IN);
		unsigned char* image_R = (unsigned char*) mxGetData(R_OUT);
		unsigned char* image_G = (unsigned char*) mxGetData(G_OUT);
		unsigned char* image_B = (unsigned char*) mxGetData(B_OUT);
		unsigned char* image_S = (unsigned char*) mxGetData(S_OUT);
		unsigned char* image_W = (unsigned char*) mxGetData(W_OUT);
		unsigned char* distout = (unsigned char*) mxGetData(DIST_OUT);
		unsigned char* BG_input = (unsigned char*) mxGetData(BG_IN);
		unsigned char* Dist_Matrix = (unsigned char*) mxGetData(DISTANCE_IN);

		//Replace stored BG instead of current BG
		mine.ReplaceBG(BG_input,image_R,image_G,image_B,image_S,image_W,distout);
		mine.import_dist(Dist_Matrix);

	}
	//Written by Moein Shakeri to update the distances for each pixel 
	else if ( nlhs == 0 && nrhs == 4 )
	{
		//change settings -to do
		MyClass& mine = get_object<MyClass>(PDATA_IN);
		
		double* pars = (double*) mxGetData(PARS_IN);
		unsigned char* Dist_Matrix = (unsigned char*) mxGetData(DISTANCE_IN);
		mine.setParameters(pars);
		mine.import_dist(Dist_Matrix);

	}
	else mexErrMsgTxt("Bad input.");
}
