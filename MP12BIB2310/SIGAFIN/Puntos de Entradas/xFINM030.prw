



/*/{Protheus.doc} User Function FINM030
    Punto de entrada MVC para grabación de la SE5 

    En este caso se está adicionando un correlativo
    
    @type  Function
    @author Nahim Terrazas
    @since 17/05/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FINM030()
Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.

Local nLinha     := 0
Local nQtdLinhas := 0
Local cMsg       := ''

If aParam <> NIL
    oObj       := aParam[1]
    cIdPonto   := aParam[2]
    cIdModel   := aParam[3]
    If cIdPonto == 'FORMCOMMITTTSPRE' 
        IF isInCallStack("FINA100")  // SÓLAMENTE EN TRANSFERENCIA
            IF empty(SE5->E5_XCORREL) // correlativo está vacio
                // __cNumTrf := nrCorrSe5// GetSxeNum("SE5","E5_XCORREL","E5_XCORREL"+cEmpAnt)
                // ROLLBACKSXE()//Descarta el n?mero obtenido por la funci?n GETSXENUM(), dej?ndolo disponible nuevamente.
	            if type("nrCorrSe5") <> "U"
                    SE5->E5_XCORREL :=nrCorrSe5
                endif
            ENDIF
        ENDIF
        // alert("mostra mensagem")
    endif
endif
Return .t.
