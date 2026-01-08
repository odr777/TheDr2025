#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ExistDocE ³ Autor ³ Edson M. / Nahim T   ³ Data ³ 22/07/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica si el documento de entrada ya fue incluido.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ExistDocE()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Financeiro 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


user function ExistDocE()
	Local lRet:= .T.
	Local aArea   := GetArea()
	Local cSql	
	Local NextArea := GetNextAlias()
	DbSelectArea("SF1")
	DbSetOrder(2)

//	Alert(xFilial("SF1") + M->F1_FORNECE+ M->F1_LOJA+ ALLTRIM(M->F1_DOC))

//	If SF1->(DbSeek( xFilial("SF1") + M->F1_FORNECE + M->F1_LOJA + M->F1_DOC))  //posicione

//		Aviso("Atención","El número de Doc. " + RTRIM(M->F1_DOC) + " ya existe, para este proveedor " ,{"OK"})
//		lRet:= .F.

//	EndIf

 //********* Edson 19.07.2019 **********//

	If  !empty(M->F1_FORNECE) .AND. !empty(M->F1_LOJA) .AND. !empty(M->F1_DOC) .AND. !empty(M->F1_DOC)
		
		cSql := "SELECT F1_DOC , F1_FORNECE , F1_LOJA , F1_ESPECIE, F1_NUMAUT "
		cSql := cSql+" FROM " + RetSqlName("SF1 ") "
		cSql := cSql+" WHERE F1_FORNECE = '" + M->F1_FORNECE + "' "
		cSql := cSql+" AND  F1_DOC = '" + AllTRIM(M->F1_DOC) + "' "
		cSql := cSql+" AND  F1_LOJA = '" + M->F1_LOJA + "' "
		cSql := cSql+" AND  F1_ESPECIE  = '" + M->F1_ESPECIE + "' "
		cSql := cSql+" AND  F1_NUMAUT  = '" + AllTRIM(M->F1_NUMAUT) + "' "
		cSql := cSql+" AND D_E_L_E_T_ <> '*'"

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
		dbSelectArea(NextArea)
		dbGoTop()

		if !Eof()
			if FUNNAME() == "MATA101N"
				Aviso("Atención","El número de Doc. " + ALLTRIM(M->F1_DOC) + " ya existe, para este proveedor " ,{"OK"})
			ENDIF
			
			M->F1_DOC = "0" + M->F1_DOC
			lRet:= .T.									
		endif				 		
		(NextArea)->(dbCloseArea()) 
											
	Endif

	RestArea( aArea )
Return lRet