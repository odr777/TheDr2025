

/*/{Protheus.doc} User Function getSerCCH
    @type  Function
    @author Nahim Terrazas
    @since 13/07/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function getSerCCH()
	cCaixa 	:= POSICIONE("SEU",7,xFilial("SF1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,"EU_CAIXA")
    // cCaixa 	:= POSICIONE("SEU",7,xFilial("SF1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,"EU_CAIXA")
	If !Empty(cCaixa)
        cCaixa := " - " + cCaixa
    endif
Return cCaixa
