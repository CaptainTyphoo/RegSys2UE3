#define S_FUNCTION_NAME Riementrieb_S_c
#define S_FUNCTION_LEVEL 2
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "simstruc.h"
#include "math.h"
#include "tmwtypes.h"
#include "matrix.h"

/* continuous state symbols */
#define omegam	x_[0]
#define iq	x_[1]
#define id	x_[2]
#define epsilon	x_[3]
#define omegal	x_[4]
/* time derivate of continuous state symbols */
#define dt_omegam	dx_[0]
#define dt_iq	dx_[1]
#define dt_id	dx_[2]
#define dt_epsilon	dx_[3]
#define dt_omegal	dx_[4]

/* input symbols */
#define uq	u_0[0]
#define ud	u_0[1]
#define Ml	u_1[0]

/* output symbols */
#define y_x1	y_0[0]
#define y_x2	y_1[0]
#define y_x3	y_1[1]
#define y_x4	y_2[0]
#define y_x5	y_2[1]

/* parameter symbols */
/* initial condition of continuous state */
#define omegam_0    mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"omegam_0"))
#define iq_0        mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"iq_0"))
#define id_0        mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"id_0"))
#define epsilon_0   mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"epsilon_0"))
#define omegal_0    mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"omegal_0"))
/* parameter 1 */
#define Il	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"Il"))
#define cr1	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"cr1"))
#define cr3	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"cr3"))
#define dl	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"dl"))
#define rl	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"rl"))
#define Im	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"Im"))
#define dm	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"dm"))
#define rm	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"rm"))
#define Rm	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"Rm"))
#define Lm	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"Lm"))
#define p	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"p"))
#define Phi	mxGetScalar(mxGetField(ssGetSFcnParam(S,0),0,"Phi"))


/* global defines */
#define NUMSTATES_C 5
#define NUMSTATES_D 0
#define NUMPARAM 1
#define IS_PARAM_DOUBLE(pVal) (mxIsNumeric(pVal) && !mxIsLogical(pVal) && !mxIsEmpty(pVal) && !mxIsSparse(pVal) && !mxIsComplex(pVal) && mxIsDouble(pVal))

/* function declarations */
static void mdlCheckParameters(SimStruct *);

static void mdlInitializeSizes(SimStruct *S)
{
    int_T ii;
    
	ssSetNumSFcnParams(S, NUMPARAM);
	#ifdef MATLAB_MEX_FILE
        if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
            mdlCheckParameters(S);
            if (ssGetErrorStatus(S) != NULL) {
                return;
            }
            for (ii=0; ii<ssGetSFcnParamsCount(S); ii++)
                ssSetSFcnParamTunable(S, ii, 0);
        }else{
            ssSetErrorStatus(S, "wrong number of arguments");
            return;
        }
	#endif

	/* continuous states */
	ssSetNumContStates(S, 5);

	/* discrete states */
	ssSetNumDiscStates(S, 0);

	/* input ports */
	if (!ssSetNumInputPorts(S, 2)) return;
	/* input port 0 */
	ssSetInputPortWidth(S, 0, 2);
	ssSetInputPortRequiredContiguous(S, 0, true);
	ssSetInputPortDirectFeedThrough(S, 0, 0);
	/* input port 1 */
	ssSetInputPortWidth(S, 1, 1);
	ssSetInputPortRequiredContiguous(S, 1, true);
	ssSetInputPortDirectFeedThrough(S, 1, 0);

	/* output ports */
	if (!ssSetNumOutputPorts(S, 3)) return;
	/* output port 0 */
	ssSetOutputPortWidth(S, 0, 1);
	/* output port 1 */
	ssSetOutputPortWidth(S, 1, 2);
	/* output port 2 */
	ssSetOutputPortWidth(S, 2, 2);
	/* PWork width */
	ssSetNumPWork(S,0);

	/* number of sample times */
	ssSetNumSampleTimes(S, 1);

	/* zero crossing */
	ssSetNumNonsampledZCs( S, 0);

	/* additional options */
	ssSetOptions(S,
		SS_OPTION_EXCEPTION_FREE_CODE);
} /* mdlInitializeSizes */



#define MDL_START
#if defined(MDL_START)
static void mdlStart(SimStruct *S)
{
 /* PWork ... */
}
#endif /* MDL_START */



#define MDL_CHECK_PARAMETERS
#if defined(MDL_CHECK_PARAMETERS) && defined(MATLAB_MEX_FILE)
static void mdlCheckParameters(SimStruct *S)
{
    
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"omegam_0") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'omegam_0'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"iq_0") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'iq_0'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"id_0") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'id_0'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"epsilon_0") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'epsilon_0'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"omegal_0") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'omegal_0'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"Il") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'Il'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"cr1") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'cr1'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"cr3") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'cr3'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"dl") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'dl'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"rl") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'rl'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"Im") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'Im'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"dm") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'dm'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"rm") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'rm'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"Rm") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'Rm'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"Lm") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'Lm'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"p") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'p'.");
    }
    if (mxGetFieldNumber(ssGetSFcnParam(S,0),"Phi") < 0) {
        ssSetErrorStatus(S,"Parameter has no field named 'Phi'.");
    }
}
#endif /* MDL_CHECK_PARAMETERS */



#define MDL_INITIALIZE_SAMPLE_TIMES
static void mdlInitializeSampleTimes(SimStruct *S)
{
	ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
	ssSetOffsetTime(S, 0, 0.0);
	ssSetModelReferenceSampleTimeDefaultInheritance(S);
}


#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
	/* continuous states */
	real_T *x_ = ssGetContStates(S);
	/* parameter */
	/* const real_T *p_0 = (const real_T*) mxGetPr(ssGetSFcnParam(S,0));*/

	omegam = omegam_0;
	iq = iq_0;
	id = id_0;
	epsilon = epsilon_0;
	omegal = omegal_0;
}


#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S)
{
    /* system states */
    real_T *x_ = ssGetContStates(S);
    /* derivates of system states */
    real_T *dx_ = ssGetdX(S);
	/* input ports */
	const real_T *u_0 = (const real_T*) ssGetInputPortSignal(S, 0);
	const real_T *u_1 = (const real_T*) ssGetInputPortSignal(S, 1);
    /* parameter */
	/* const real_T *p_1 = (const real_T*) mxGetPr(ssGetSFcnParam(S,1));*/

    double t10,t14,t16,t3,t6;

    t3 = epsilon * epsilon;
    t6 = cr1 * epsilon + cr3 * t3 * epsilon;
    t10 = p * Phi;
    dt_omegam = 0.1e1 / Im * (0.2e1 * t6 * rm - dm * omegam + 0.3e1 / 0.2e1 * t10 * iq);
    t14 = 0.1e1 / Lm;
    t16 = Lm * p;
    dt_iq = 0.2e1 / 0.3e1 * t14 * (-Rm * iq + 0.3e1 / 0.2e1 * t16 * omegam * id - t10 * omegam + uq);
    dt_id = 0.2e1 / 0.3e1 * t14 * (-Rm * id - 0.3e1 / 0.2e1 * t16 * omegam * iq + ud);
    dt_epsilon = rl * omegal - rm * omegam;
    dt_omegal = 0.1e1 / Il * (-0.2e1 * t6 * rl - dl * omegal + Ml);
}


static void mdlOutputs(SimStruct *S, int_T tid)
{
    /* system states */
    real_T *x_ = ssGetContStates(S);
	/* input ports */
	const real_T *u_0 = (const real_T*) ssGetInputPortSignal(S, 0);
	const real_T *u_1 = (const real_T*) ssGetInputPortSignal(S, 1);
	/* output ports */
	real_T *y_0 = (real_T*) ssGetOutputPortSignal(S, 0);
	real_T *y_1 = (real_T*) ssGetOutputPortSignal(S, 1);
	real_T *y_2 = (real_T*) ssGetOutputPortSignal(S, 2);
    /* parameter */
	/* const real_T *p_1 = (const real_T*) mxGetPr(ssGetSFcnParam(S,1));*/


    y_x1 = omegam;
    y_x2 = iq;
    y_x3 = id;
    y_x4 = epsilon;
    y_x5 = omegal;
}




static void mdlTerminate(SimStruct *S)
{
}


#ifdef  MATLAB_MEX_FILE
	#include "simulink.c" /* MEX-file interface mechanism */
#else
	#include "cg_sfun.h" /* Code generation registration function */
#endif



