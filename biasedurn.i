/* File: biasedurn.i */
%module biasedurn

%{
#define SWIG_FILE_WITH_INIT
#include "stocc.h"
#include "urn.h"
%}

%include "numpy.i"
%include "typemaps.i" 
%include "std_vector.i"

%include typemaps.i

%init %{
import_array();
%}


%typemap(in) (int* px, int nres) {
    /* Check that the input is a Python list data structure */
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_ValueError,"Expected a Python list of values\n");
        return NULL;
    }

    /* Set the second parameter to the length of the Python list input */
    $2 = PySequence_Length($input);

    /* Allocate memory to convert the list into a C/C++ array */
    $1 = (int*) malloc($2 * sizeof(int));

    /* Loop over the values in the list */
    for (int i = 0; i < $2; i++) {

        /* Extract the value from the list at this location */
        PyObject *o = PySequence_GetItem($input,i);

        /* If the value is a number, cast it as an int and set the
         * input array value */
        if (PyNumber_Check(o)) {
            $1[i] = (int) PyLong_AsLong(o);
        }
        else {
            free($1);
            PyErr_SetString(PyExc_ValueError,"Expected a list of numbers\n");
            return NULL;
        }
    }
}

/* CFishersNCHypergeometric::moments(double * mean, double * var) */
%typemap(in, numinputs=0) (double* mean, double* var) (double temp_mean, double temp_var) {
    $1 = &temp_mean;
    $2 = &temp_var;
}
%typemap(argout) (double* mean, double* var) {
    // double -> PyFloat
    PyObject *mean = PyFloat_FromDouble(*$1);
    PyObject *var = PyFloat_FromDouble(*$2);

    // Return tuple of (mean, variance)
    PyObject *tuple = PyTuple_New(2);
    PyTuple_SetItem(tuple, 0, mean);
    PyTuple_SetItem(tuple, 1, var);

    $result = tuple;
}

/* CMultiWalleniusNCHypergeometric(int colors, int64_t * m, int colors_dummy, double * odds, int32_t n, double accuracy=1.E-8) */
%apply (int64_t* IN_ARRAY1, int DIM1) {(int64_t* m, int colors)}
%apply (double* IN_ARRAY1, int DIM1) {(double* odds, int colors_dummy)}

/* CMultiWalleniusNCHypergeometric::probability(int32_t n, int64_t * x) */
%apply (int64_t* IN_ARRAY1, int DIM1) {(int64_t* x, int32_t n)}

/* CMultiWalleniusNCHypergeometric::mean() */
%typemap(out) vector<double> {
    $result = PyList_New($1.size());
    for (unsigned i=0; i<$1.size(); i++) {
        PyObject *o = PyFloat_FromDouble((double)$1[i]);
        PyList_SetItem($result, i, o);
    }
}

%include "urn.h"
%include "stocc.h"
