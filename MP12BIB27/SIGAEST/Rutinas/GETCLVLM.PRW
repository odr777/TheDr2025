

/*/{Protheus.doc} User Function GETCLVLM
    Obtiene la clase de valor 
    @type  Function
    @author Nahim
    @since 11/12/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function GETCLVLM(cBemTv1)
    aArea := GetArea()
    dbSelectArea("ST9")
    dbSetOrder(1)
    cClVlbl := ""
    // T9_FILIAL+T9_CODBEM
    IF dbSeek(xFilial("ST9")+cBemTv1)
        dbSelectArea("SN3") //Posicione SN3
        dbSetOrder(1)
        // N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ
        IF dbSeek(xFilial("SN3")+ST9->T9_CODIMOB + '10') // Encuentra SN3
            if !empty(SN3->N3_CLVL)  // no tiene que estár vacio
                cClVlbl := SN3->N3_CLVL
            else
                alert("campo N3_CLVLCON vacio en el bien: "  + SN3->N3_CBASE)
            ENDIF
        else
            alert("NO RELACION EN LA SN3 (ACTIVOS) :" +ST9->T9_CODIMOB)
        ENDIF
    else
        alert("NO RELACION EN LA ST9 (Bienes) - Mant. " +cBemTv1)
    ENDIF
    IF ALLTRIM(FUNNAME())  $ "MATA241"  
        CCC := STJ->TJ_CCUSTO
    endif
    RestArea(aArea)
Return cClVlbl
