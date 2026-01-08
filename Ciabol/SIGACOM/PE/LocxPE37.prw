#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LocxPE37.PRW.ºAutor  ³Nain Terrazas-TdeP    ºFecha ³15/11/19º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE Luego de generar los documentos de entrada para modificar±±
±± Los títulos (SE1)	   												   ±±
±±º          ³  Utilizado para pasar la glosa de docuemntos de entrada	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLIVIA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LocxPE37()

    Local aAreaSE2  := SE2->(GetArea())

    // verifica que     
	IF FUNNAME() == "MATA101N" .and. SE2->E2_NUM == SF1->F1_DOC .and. SE2->E2_PREFIXO == SF1->F1_SERIE
         SE2->(dbgotop())
         SE2->(DbSetOrder(1))
        //  E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
         SE2->(DbSeek(xFilial('SE2')+SF1->F1_SERIE+SF1->F1_DOC))

        do while SE2->E2_NUM == SF1->F1_DOC .and. SE2->E2_PREFIXO == SF1->F1_SERIE
        Reclock( "SE2" , .F. )
		    Replace E2_HIST with SF1->F1_UGLOSA      // Adicionando Glosa.
        MsUnlock()
        SE2->(DBSKIP())
        enddo
	endif
    Restarea(aAreaSE2)

	//	alert(SE2->E2_HIST)
Return
