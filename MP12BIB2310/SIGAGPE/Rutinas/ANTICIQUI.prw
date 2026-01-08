#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ANTIQUI  ºAuthor Omar Delgadillo 28/08/2024  			  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±       ¹±±
±±ºUse       ³        Generico Bolivia                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//User Function ANTIQUI(cFilial, cMatricula, cTiIPOQUI, nANOQUI)

User Function ANTICIQUI(cFil, cMat, cTipoQUI, nAnoQui, nAntiQUI)
    Local nHORAS 	:= 0
	Local cQuery 	:= ""
	Local nAux 		:= 0
	Local cAlias  	:= "SRD"
	Local cQrySRD 	:= "QSRD"
	Local aStruct
	Local cPDAntQui	:= "767"
	Local cPDQui	:= "769"

	cQuery := " SELECT SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_PD, SRD.RD_SEMANA, SRD.RD_PROCES, SUM(SRD.RD_HORAS) RD_HORAS, SUM(SRD.RD_VALOR) RD_VALOR "
	cQuery += " from " + RetSqlName("SRD") + " SRD"
	cQuery += " WHERE SRD.D_E_L_E_T_ = '' and SRD.RD_PD = '" + cPDAntQui + "' AND SRD.RD_FILIAL = '" + cFil + "' AND SRD.RD_MAT = '" + cMat + "' AND SRD.RD_ROTEIR = 'QUI' "
	cQuery += " GROUP BY SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_PD, SRD.RD_SEMANA, SRD.RD_PROCES "
	cQuery += " HAVING MAX(SRD.RD_PERIODO) > COALESCE ((SELECT TOP 1 SRD2.RD_PERIODO FROM " + RetSqlName("SRD") + " SRD2 "
	cQuery += " 				WHERE SRD2.D_E_L_E_T_ = '' and SRD2.RD_PD = '" + cPDQui + "' AND SRD2.RD_FILIAL = '" + cFil + "' AND SRD2.RD_MAT = '" + cMat + "' AND SRD2.RD_ROTEIR = 'QUI' "
	cQuery += " 	ORDER BY SRD2.RD_PERIODO DESC),0) "

    //Aviso("",cQuery,{"Ok"},,,,,.T.)
	cQuery := ChangeQuery(cQuery)
	aStruct := (cAlias)->(dbStruct())

	If  MsOpenDbf(.T.,"TOPCONN",TcGenQry(, ,cQuery),cQrySRD,.T.,.T.)
		For nAux := 1 To Len(aStruct)
			If ( aStruct[nAux][2] <> "C" )
				TcSetField(cQrySRD,aStruct[nAux][1],aStruct[nAux][2],aStruct[nAux][3],aStruct[nAux][4])
			EndIf
		Next nAux
	Endif

	dbSelectArea(cQrySRD)
	(cQrySRD)->(dbGoTop())

	// RD_VALOR si es mayor que cero, existe un anticipo
    //nVALOR := 0, nHORAS := 0		// CUANDO NO HABIA ANTICIPOS
	//nVALOR > 0, nHORAS > 0			// CUANDO EXISTE UN ANTICIPO, PUEDE HABER VARIOS
	IF (cQrySRD)->( !eof() )
		nAntiQUI 	:= (cQrySRD)->RD_VALOR
		nHORAS		:= (cQrySRD)->RD_HORAS
		(cQrySRD)->( DBSKIP() )
	endIf

    // TIPOQUI A anticipo /Q quinquenio /C Completar quinquenio
    if nHORAS = 0 .AND. nAnoQui >= 5
        cTipoQUI 	:= "Q" 
		nAnoQui 	:= 5
    ELSE
        if (nHORAS + nAnoQui) >= 5
            cTipoQUI := "C"
            nAnoQui := 5 //nHORAS + nAnoQui // o 5
        else 
            cTipoQUI := "A" // TIPOQUI A anticipo /Q quinquenio        
        endif
    ENDIF
Return
