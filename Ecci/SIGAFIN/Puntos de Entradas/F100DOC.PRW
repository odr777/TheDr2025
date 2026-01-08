

/*/{Protheus.doc} User Function F100DOC
    (long_description)
    @type  Function
    @author user
    @since 14/05/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function F100DOC()
    Local aArea		:= GetArea()
    Local cDocTran	:= ParamIxb[8] // obtiene el mismo nro
    // __cNumTrf := GetSxeNum("SE5","E5_PROCTRA","E5_PROCTRA"+cEmpAnt)
    // ROLLBACKSXE()//Descarta el n?mero obtenido por la funci?n GETSXENUM(), dej?ndolo disponible nuevamente.
    PUBLIC nrCorrSe5 :=  u_Maxse5co()// GetSxeNum("SE5","E5_XCORREL","E5_XCORREL"+cEmpAnt)
    // __cNumTrf := GetSxeNum("SE5","E5_PROCTRA","E5_PROCTRA"+cEmpAnt)
    // ROLLBACKSXE()//Descarta el n?mero obtenido por la funci?n GETSXENUM(), dej?ndolo disponible nuevamente.


Return cDocTran
