
#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} User Function FINPROCITF
    Realiza el cambio de estado para que no genere el itf con valor erroneo.
    Momeentaneo cambiar 
    llamado 11508387 
    @type  Function
    @author user
    @since 04/05/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FINPROCITF(param_name)
    Local aArea		:= GetArea()

    nRecno :=   ParamIxb[1] //nRecnoSE5 , nOpc
    nOpcint :=  ParamIxb[2] // opcion
    if nOpcint == 1
        if Funname() $ "FINA085A|FINA090" .and. POSICIONE("SA2",1,xFilial("SA2")+SE5->E5_CLIFOR + SE5->E5_LOJA ,"A2_EST") == 'EX' .and. !SA6->A6_COD $ GetMv("MV_CARTEIR") .AND. SA6->A6_MOEDA == 2 // SI ES DEL EXTERIOR Y ESTÁ PAGANDO EN DÓLARES
            public cEstadoAnt := SA2->A2_EST
            Reclock("SA2",.F.)
                A2_EST := "SC" // cambio temporalmente a otro valor
            MsUnlock()
        ENDIF
		// if cPaisLoc $ "BOL".And. cCalcITF == "1" .and. (Funname() $ "FINA085A|FINA090" .AND. POSICIONE("SA2",1,xFilial("SA2")+SE5->E5_CLIFOR + SE5->E5_LOJA ,"A2_EST") == 'EX') .or.  ( SA6->A6_MOEDA <> 1 ) .and. SA6->A6_EST <> "EX" .and. ((!(GetMv("MV_CXFIN") $ SA6->A6_COD) .And. !(SA6->A6_COD $ GetMv("MV_CARTEIR"))    ) .Or. IsCaixaLoja(cBanco)) // Nahim Terrazas Cambio 31/05/2019
		// 	lRet:= .T.
        // endif
    endif
    RestArea(aArea)
Return 
