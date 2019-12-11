#include <Python2.7/Python.h>
#include <julia.h>

//Bridge from Python to Julia

static PyObject* py_adagramdisambig(PyObject* self, PyObject* args)
{
	const char *target_word;
	const char *context;
	int target_len = 0;
	int context_len = 0;

	if(!PyArg_ParseTuple(args, "s#s#", &target_word, &target_len, &context, &context_len)){
		return NULL;
	}

	jl_init();
    
	if(jl_eval_string("disambig") == NULL){
		jl_eval_string("include(\"disambig.jl\")");
	}

	//Create parameters for julia
	jl_value_t **fargs;
	JL_GC_PUSHARGS(fargs, 2);
	fargs[0] = jl_pchar_to_string(target_word, target_len);
	fargs[1] = jl_pchar_to_string(context, context_len);

	//Retrieve module and function	
	jl_module_t *jl_disambig_module =  (jl_module_t*)jl_eval_string("disambig");
	if(jl_disambig_module == NULL){
		return Py_BuildValue("i", -1);
	}
	
	jl_function_t *d_func  = jl_get_function(jl_disambig_module, "adagramDisambig");
	if(d_func == NULL){
		return Py_BuildValue("i", -1);	
	}

	//Invoke the julia function
	jl_value_t *retval = (jl_value_t*)jl_call(d_func, fargs, 2);
	JL_GC_POP();

	if(retval == NULL){
		return Py_BuildValue("i", -1);
	}
	
	return Py_BuildValue("i", jl_unbox_int32(retval));
}


static PyMethodDef disambigModule_methods[] = {
	{"disambig", py_adagramdisambig, METH_VARARGS},
	{NULL, NULL}
};

void initadagramDisambigModule(){
	libsupport_init();
	(void) Py_InitModule("adagramDisambigModule", disambigModule_methods);
}


