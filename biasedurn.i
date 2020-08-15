/* File: biasedurn.i */
%module biasedurn

%{
#define SWIG_FILE_WITH_INIT
#include "stocc.h"
#include "urn.h"
%}

%include "stdint.i"
%include "typemaps.i" 
%include "std_vector.i"

%include typemaps.i


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

%typemap(in) (int32_t *) {
    /* Check that the input is a Python list data structure */
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_ValueError,"Expected a Python list of values\n");
        return NULL;
    }

    /* Create array */
    int len = PySequence_Length($input);
    $1 = (int32_t*) malloc(len * sizeof(int32_t));

    /* Loop over the values in the list */
    for (int i=0; i<len; i++) {
        /* Extract the value from the list at this location */
        PyObject *o = PySequence_GetItem($input, i);

        if (PyNumber_Check(o)) {
            $1[i] = (int) PyFloat_AsDouble(o);
        }
        else {
            free($1);
            PyErr_SetString(PyExc_ValueError,"Expected a list of numbers\n");
            return NULL;
        }
    }
}
%typemap(typecheck) (int32_t *) {
    $1 = PyList_Check($input);
}

%typemap(in) (double *) {
    /* Check that the input is a Python list data structure */
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_ValueError,"Expected a Python list of values\n");
        return NULL;
    }

    /* Create array */
    int len = PySequence_Length($input);
    $1 = (double*) malloc(len * sizeof(double));

    /* Loop over the values in the list */
    for (int i=0; i<len; i++) {
        /* Extract the value from the list at this location */
        PyObject *o = PySequence_GetItem($input, i);

        if (PyNumber_Check(o)) {
            $1[i] = (double) PyFloat_AsDouble(o);
        }
        else {
            free($1);
            PyErr_SetString(PyExc_ValueError,"Expected a list of numbers\n");
            return NULL;
        }
    }
}
%typemap(typecheck) (double *) {
    $1 = PyList_Check($input);
}

%typemap(out) (vector<double>) {
    $result = PyList_New($1.size());
    for (unsigned i=0; i<$1.size(); i++) {
        PyObject *o = PyFloat_FromDouble((double) $1[i]);
        PyList_SetItem($result, i, o);
    }
}

%include "urn.h"
%include "stocc.h"
