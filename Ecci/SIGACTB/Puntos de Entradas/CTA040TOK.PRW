
/*/{Protheus.doc} User Function CTA040TOK
    Validación para que no se pueda grabar 
    @type  Function
    @author user
    @since 05/06/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CTA040TOK()
    local lRetorno := .F. // FALTO ES TODO OK
    local nOpcion := PARAMIXB ///nOpction
    if M->CTD_CLASSE == "2" // si es clase 2
        lRetorno :=  empty(M->CTD_XTAREF) //
        // lRetorno := !ExistCPO("AF9",M->CTD_XTAREF) // no puede ser vacios 
        if lRetorno
            MsgAlert("No es posible dejar vacio el campo Tarea del proyecto cuando es item Analítico.","CTA040TOK")
        endif
    ENDIF
Return lRetorno
