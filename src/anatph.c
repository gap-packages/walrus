/*
 * anatph: A new approach to proving hyperbolicity
 */

#include "src/compiled.h"          /* GAP headers */
#include "src/integer.h"

Obj FuncSC_FLOYD_WARSHALL(Obj self, Obj mat)
{
    UInt i,j,k,n;
    Obj t;

    n = LEN_PLIST(mat);
    for(i=1;i<=n;i++)
        for(j=1;j<=n;j++)
            for(k=1;k<=n;k++) {
                t = SumInt(ELM2_LIST(mat, INTOBJ_INT(i), INTOBJ_INT(k)),
                           ELM2_LIST(mat, INTOBJ_INT(k), INTOBJ_INT(j)));
                if (LtInt(t, ELM2_LIST(mat, INTOBJ_INT(i), INTOBJ_INT(j)))) {
                    ASS2_LIST(mat, INTOBJ_INT(i), INTOBJ_INT(j), t);
                }
            }
    return mat;
}

// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
    GVAR_FUNC(SC_FLOYD_WARSHALL, 1, "mat"),

	{ 0 } /* Finish with an empty entry */

};

/******************************************************************************
*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions                                          */
    InitHdlrFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}

/******************************************************************************
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}

/******************************************************************************
*F  InitInfopl()  . . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
    .type = MODULE_DYNAMIC,
    .name = "anatph",
    .initKernel = InitKernel,
    .initLibrary = InitLibrary,
};

StructInitInfo * Init__Dynamic ( void )
{
  return &module;
}
