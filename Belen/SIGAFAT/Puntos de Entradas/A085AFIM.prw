


/*/{Protheus.doc} User Function A085AFIM
    Realiza el cambio de estado para que no genere el itf con valor erroneo.
    Momeentaneo cambiar 
    llamado 11508387 

    @type  Function
    @author user
    @since 26/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function A085AFIM()
	If type("cEstadoAnt") <> "U"
        // alert("volviendo al anterior")
        Reclock("SA2",.F.)
            A2_EST := cEstadoAnt // cambio temporalmente a otro valor
        MsUnlock()
		cEstadoAnt := NIL
		FreeObj(cEstadoAnt)
	Endif
Return 
