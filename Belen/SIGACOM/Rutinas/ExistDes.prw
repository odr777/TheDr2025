#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ExistDocE ³ Autor ³ Etcheverry / Nahim T ³ Data ³ 22/07/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica si el documento de entrada ya fue incluido.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ExistDes()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Financeiro 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function ExistDes(cCampo)
	Local lRet:= .T.
	Local aArea   := GetArea()
	Local cSql
	Local NextArea := GetNextAlias()
	DbSelectArea("SF1")
	DbSetOrder(2)
	nfornece := 	aScan(aHeader1,{|x| AllTrim(x[2]) == "DBB_FORNEC"})
	nLojaLu := aScan(aHeader1,{|x| AllTrim(x[2]) == "DBB_LOJA"})
	nDocumento := aScan(aHeader1,{|x| AllTrim(x[2]) == "DBB_DOC"})
	cProveedor := aCols[n][nfornece]
	cTienda := aCols[n][nLojaLu]
	cDocumento := aCols[n][nDocumento]
	cNumAuto := aCols[n][aScan(aHeader1,{|x| AllTrim(x[2]) == "DBB_NUMAUT"})]
	cSerie := aCols[n][aScan(aHeader1,{|x| AllTrim(x[2]) == "DBB_SERIE"})]
	cOK := aCols[n][aScan(aHeader1,{|x| AllTrim(x[2]) == "DBB_OK"})]

	Do Case
		Case cCampo == "DBB_FORNEC"
		cProveedor  := M->DBB_FORNEC
		cTienda := "01"
		Case cCampo == "DBB_DOC"
		cDocumento	:=  M->DBB_DOC
		Case cCampo == "DBB_SERIE"
		cSerie	:=  M->DBB_SERIE
		Case cCampo == "DBB_NUMAUT"
		cNumAuto	:=  M->DBB_NUMAUT
	EndCase

	If  !empty(cProveedor) .AND. !empty(cDocumento) .AND. empty(cOK) // .AND. !empty(cTienda)

		cSql := "SELECT F1_DOC , F1_FORNECE , F1_LOJA , F1_ESPECIE, F1_NUMAUT "
		cSql := cSql+" FROM " + RetSqlName("SF1") + " SF1 "
		cSql := cSql+" WHERE F1_FORNECE = '" + cProveedor + "' "
		cSql := cSql+" AND  F1_DOC = '" + AllTRIM(cDocumento) + "' "
		//cSql := cSql+" AND  F1_LOJA = '" + cTienda + "' "
		cSql := cSql+" AND  F1_ESPECIE  = 'NF'"
		cSql := cSql+" AND  F1_SERIE  =  '" + cSerie + "' "
		//		cSql := cSql+" AND  F1_NUMAUT  = '" + AllTRIM(cNumAuto) + "' " Nahim Valida si el nro de autorización existe
		cSql := cSql+" AND D_E_L_E_T_ <> '*'"

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
		dbSelectArea(NextArea)
		dbGoTop()

		if !Eof()
			if FUNNAME() == "MATA143"
				Aviso("Atención","El número de Doc. " + ALLTRIM(cDocumento) + " ya existe, para este proveedor " ,{"OK"})
			ENDIF
			aCols[n][nDocumento] = "0" + cDocumento
			lRet:= .T.
			/*lRet:= .T.
			if (NextArea)->(F1_NUMAUT) == cNumAuto
				Aviso("Atención","El número de Doc. " + ALLTRIM(cDocumento) + " ya existe, para este proveedor " ,{"OK"})
				return .F.
			else
				aCols[n][nDocumento] = "0" + aCols[n][nDocumento]
			endif
			*/
		endif
		(NextArea)->(dbCloseArea())

	Endif
	RestArea( aArea )
Return lRet
