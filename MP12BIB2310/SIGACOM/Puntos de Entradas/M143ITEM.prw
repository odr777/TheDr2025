#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF Chr(13)+Chr(10)
#DEFINE C_SEPARADOR ";"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M143ITEM   º Autor ³ Erick Etcheverr  º Fecha ³  13/01/24   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescripcion ³ Punto de Entrada ajuste de lineas para recalcular costeo º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BASE BOLIVIA                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M143ITEM()

	Local cMsg := "" //EET: Cuidado al recuperar de Función, para Empty necesitaría recibirse con AllTrim().
	Local cArchivoLog := AllTrim( SuperGetMV( "MV_XM143L", , "") ) //EET: Memotecnico: Mata143 con LoG
	Local lLogActivo := !Empty( cArchivoLog )
/* Título en el Documento mejor si está: 
    "Punto de Entrada", " Filial " + C_SEPARADOR + " Despacho " + C_SEPARADOR + " Numero del Item del Docto " + C_SEPARADOR
  + " Nro Documento " + C_SEPARADOR + " Serie " + C_SEPARADOR + " Proveedor " + C_SEPARADOR + " Tienda Prv. " + C_SEPARADOR
  + " Mensaje/Datos P.E. " + C_SEPARADOR + " Fecha " + C_SEPARADOR + " Hora " + CRLF */

	Private _aItens := AClone(ParamIXB[1])
	Private _nDifAUltimoItem := SuperGetMV( "MV_XDIF14", , 0.01)

    If lLogActivo
		// EET: DBB_FILIAL+DBB_HAWB+DBB_ITEM // Indice2 // DBB_FILIAL+DBB_DOC+DBB_SERIE+DBB_FORNEC+DBB_LOJA // Indice1
		u_ConsoleLog( "M143ITEM", DBB->DBB_FILIAL + C_SEPARADOR + DBB->DBB_HAWB + C_SEPARADOR + DBB->DBB_ITEM + C_SEPARADOR ;
			+ DBB->DBB_DOC + C_SEPARADOR + DBB->DBB_SERIE + C_SEPARADOR + DBB->DBB_FORNEC + C_SEPARADOR + DBB->DBB_LOJA + C_SEPARADOR ;
			+ " Iniciando Personalizacion M143ITEM", .T. /*lAbreFecha:=.F.*/, /*lCierraFecha:=.F.*/, cArchivoLog, C_SEPARADOR)
	EndIf

	If (DBB->DBB_TIPONF $ "5,8")
		cMsg += CpoDBCAcumula( cMsg, "'Falta en el Item:' + DBC->DBC_ITEM + ' la Cuenta Contable'", " .And. Empty(AllTrim(DBC->DBC_CONTA))")
	Else
		Do Case
			Case DBB->DBB_XPROES == 'E' // EET: ESPECIFICO; Clipper tiene IsField("DBB_UVLRPR"), pero ADVPL no.
				cMsg := AllTrim( VlrEspPror() )
			/*Case DBB->DBB_XPROES == 'C'
				cMsg := AllTrim( CampoPro("D1_QUANT", .T.   ) ) // Verifica que sea lMismaUM 
				If !Empty(cMsg)
					cMsg += CRLF + "Prorrateo por Cantidad"
				EndIf
			Case DBB->DBB_XPROES == 'P'
				cMsg := AllTrim( CampoPro("DBC_XPESO") )
				If !Empty(cMsg)
					cMsg += CRLF + "Prorrateo por Peso"
				EndIf*/
			Case DBB->DBB_XPROES == 'S' // EET: Si bien es el Estandar de igual forma tiene la diferencia de Ctvos:
				cMsg := AllTrim( DifEstandarAUltimoItem( "D1_TOTAL" ) )
				If !Empty(cMsg)
					cMsg += CRLF + "Prorrateo Estandar"
				EndIf
		EndCase
	EndIf

	If !Empty( cMsg )
		MsgStop( "No se Prorrateó el Documento " + DBB->DBB_DOC + CRLF + cMsg, ;
				"Prorrateo no se Completo" )
		_aItens := {} //EET: Nil no lo reconoce, debe ser {}.
	EndIf

    If lLogActivo
		u_ConsoleLog( "M143ITEM", DBB->DBB_FILIAL + C_SEPARADOR + DBB->DBB_HAWB + C_SEPARADOR + DBB->DBB_ITEM + C_SEPARADOR ;
			+ DBB->DBB_DOC + C_SEPARADOR + DBB->DBB_SERIE + C_SEPARADOR + DBB->DBB_FORNEC + C_SEPARADOR + DBB->DBB_LOJA + C_SEPARADOR ;
			+ " Finalizando Personalizacion M143ITEM", /*lAbreFecha:=.F.*/, .T./*lCierraFecha*/, cArchivoLog, C_SEPARADOR)
	EndIf

Return _aItens

Static Function VlrEspPror()

	Local cMsg := ""

	Local nY := 0
	Local nX := 1

	Local aItensEs := {}

	Local nPosUnit  := 0
	Local nPosTotal := 0
	Local nPosItem  := 0

	Local aArea	  := GetArea()
	Local cAlias  := CrearArea(DBB->DBB_HAWB)   ///PARA FOB TIENE QUE ESTAR GENERADO LA FOB

	Local nAcumlaProrrateo := 0
	Local nCampoTotal := 0

	nCampoTotal := CpoDBCAcumula( nCampoTotal, "DBC_TOTAL")

	Do While nX <= Len(_aItens)
		nPosUnit  := aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_VUNIT" })
		nPosTotal := aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_TOTAL" })
		nPosItem  := aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_ITEM" })

		//DbSetOrder(1) trabaja con MsSeek( cIndexKey ) // DbSetOrder(1) indica que debería guardarse primero.
		If Buscar( cAlias, KeyItens(nX) ) // cIndexKey
		   	If (cAlias)->DBC_XVLRPR != 0
				nY++
				_aItens[nX][nPosItem][2] := StrZero( nY, Len(_aItens[nX][nPosItem][2]) )
				_aItens[nX][nPosTotal][2]:= (cAlias)->DBC_XVLRPR
				_aItens[nX][nPosUnit][2] := _aItens[nX][nPosTotal][2]

				AAdd( aItensEs, _aItens[nX])

				nAcumlaProrrateo += _aItens[nX][nPosTotal][2] // EET: Ajuste para evitar la diferencia de Ctvos.
			EndIf
		Else
			cMsg := " No se encontró dentro la Factura FOB en los aItems "
			nX := Len( _aItens )
		EndIf
		nX++
	EndDo
    If nY > 0
    	_aItens := AClone( aItensEs )
		If Empty( AllTrim(cMsg) ) .and. len(_aItens) > 1
			cMsg := DifAUltimoItem( nCampoTotal, nAcumlaProrrateo, nPosTotal)
		EndIf 
    Else
    	cMsg := " No se encontró ningún Prorrateo Especifico a asignar "
    EndIf

	DbSelectArea(cAlias)
	DbCloseArea()
   	RestArea(aArea)

Return cMsg
/*
Static Function CampoPro( cCampo, lMismaUM )

	Local nX := 1

	Local nPosUnit  := 0
	Local nPosTotal := 0

	Local cMsg := ""

	Local aArea	  := GetArea()
	Local cAlias  := CrearArea( DBB->DBB_HAWB )

	Local nTotalProrrateo := TotProrr( DBB->DBB_HAWB )
	Local nCampoTotal := 0
	Local nAcumlaProrrateo := 0

	Default lMismaUM := .F.

	nCampoTotal := CampoTot( cAlias, cCampo, lMismaUM)
	
	Do Case
		Case nCampoTotal == 0
			cMsg := " Su Total es Cero, verifique los Datos a Prorratear "
		Case nCampoTotal < 0
			cMsg := " Tiene items que su Unidad no son las mismas "
		Case nCampoTotal > 0
			nX := 1
			Do While nX <= Len(_aItens)
		
				nPosUnit  := aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_VUNIT" }) // EET: Filial 107, HAWB = 10 Necesito que sea de esa fila diferente ¿?.
				nPosTotal := aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_TOTAL" })

				// DbSetOrder(1) trabaja con MsSeek( cIndexKey ) // DbSetOrder(1) indica que debería guardarse primero.
				If Buscar( cAlias, KeyItens(nX) )
					_aItens[nX][nPosTotal][2]:= Round( ( (cAlias)->&(cCampo) / nCampoTotal) * nTotalProrrateo, 2)
					_aItens[nX][nPosUnit][2] := _aItens[nX][nPosTotal][2]

					nAcumlaProrrateo += _aItens[nX][nPosTotal][2] // EET: Ajuste para evitar la diferencia de Ctvos.
				Else
					cMsg := " No se encontró dentro la Factura FOB en los aItems "
					nX := Len(_aItens)
				EndIf
		    	nX++
		  	EndDo

			If Empty( AllTrim(cMsg) )
				cMsg := DifAUltimoItem( nTotalProrrateo, nAcumlaProrrateo, nPosTotal)
			EndIf
	EndCase

	DbSelectArea(cAlias)
	DbCloseArea()
   	RestArea(aArea)

Return cMsg
*/
Static Function DifEstandarAUltimoItem( cCampo, lMismaUM )

	Local nX := 1

	Local nPosTotal := 0

	Local cMsg := ""

	Local aArea	  := GetArea()
	Local cAlias  := CrearArea( DBB->DBB_HAWB )

	Local nTotalProrrateo := TotProrr( DBB->DBB_HAWB )
	Local nCampoTotal := 0
	Local nAcumlaProrrateo := 0

	Default lMismaUM := .F.

	nCampoTotal := CampoTot( cAlias, cCampo, lMismaUM)

	If nCampoTotal > 0
		nX := 1
		Do While nX <= Len(_aItens)

			nPosTotal := aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_TOTAL" })

			// DbSetOrder(1) trabaja con MsSeek( cIndexKey ) // DbSetOrder(1) indica que debería guardarse primero.
			If Buscar( cAlias, KeyItens(nX) )
				nAcumlaProrrateo += _aItens[nX][nPosTotal][2]
			Else
				cMsg := " No se encontró dentro la Factura FOB en los aItems "
				nX := Len(_aItens)
			EndIf
			nX++
		EndDo

		If Empty( AllTrim(cMsg) )
			cMsg := DifAUltimoItem( nTotalProrrateo, nAcumlaProrrateo, nPosTotal)
		EndIf
	EndIf

	DbSelectArea(cAlias)
	DbCloseArea()
	RestArea(aArea)

Return cMsg

Static Function DifAUltimoItem( nTotalProrrateo, nAcumlaProrrateo, nPosTotal)
	Local cMsg := ""
	Local nDifAcumlador := 0

	nDifAcumlador := nTotalProrrateo - nAcumlaProrrateo  // EET: Ajuste para evitar la diferencia de Ctvos.
	If Abs(nDifAcumlador ) <= _nDifAUltimoItem
		_aItens[Len(_aItens)][nPosTotal][2]+= nDifAcumlador
	Else
		cMsg := "La diferencia del Prorrateo es " + CValToChar( nDifAcumlador ) + " y es mayor al permitido +/- " + CValToChar( _nDifAUltimoItem )
	EndIf

Return cMsg

Static Function KeyItens( nX )

	Local cIndexKey := ""
	Local aPosIndex := {,,,,}
	Local ni	    := 1

	// De la Factura C, no de la N
	aPosIndex[1]:= aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_FILIAL" })
	aPosIndex[2]:= aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_NFORI" })  // D1_DOC
	aPosIndex[3]:= aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_SERIORI" })  // D1_SERIE
	aPosIndex[4]:= aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_ITEMORI" })  // D1_ITEM
	aPosIndex[5]:= aScan(_aItens[nX],{|x|Alltrim(x[1]) == "D1_COD" })

	For ni := 1 To Len(aPosIndex)
		cIndexKey += _aItens[nX][aPosIndex[ni]][2]
	Next ni

Return cIndexKey

Static Function CrearArea( cHAWB )

	Local cAlias	:= GetNextAlias()

	// N, para DBB_TIPONF $ 5|8
	BeginSql Alias cAlias

	SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA,
	   D1_COD, D1_ITEM, F1_TIPO, D1_QUANT, D1_UM, D1_QTSEGUM, D1_SEGUM, D1_TOTAL, F1_MOEDA, F1_TXMOEDA, 
	   DBC_XVLRPR //, DBC_XPESO
	FROM %table:SF1% SF1
	   INNER JOIN %table:DBA% DBA
	   ON  SF1.D_E_L_E_T_ = ' ' AND F1_FILIAL = %xfilial:SF1%
	   AND DBA.D_E_L_E_T_ = ' ' AND DBA_FILIAL = %xfilial:DBA%
	   AND F1_HAWB = %Exp:cHAWB% AND F1_HAWB = DBA_HAWB  AND DBA_OK <> '3'
	   INNER JOIN %table:DBB% DBB
	   ON DBB.D_E_L_E_T_ = ' ' AND DBB_FILIAL = %xfilial:DBB%
	   AND DBA_HAWB = DBB_HAWB
	   AND DBB_FILIAL || DBB_DOC || DBB_SERIE || DBB_FORNEC || DBB_LOJA || 'N' =
	   	   F1_FILIAL  || F1_DOC  || F1_SERIE  || F1_FORNECE || F1_LOJA  || F1_TIPO
	   INNER JOIN %table:SD1% SD1
	   ON SD1.D_E_L_E_T_ = ' ' AND D1_FILIAL = %xfilial:SD1%
	   AND D1_FILIAL  || D1_DOC  || D1_SERIE  || D1_FORNECE || D1_LOJA  || D1_TIPO =
	   	   F1_FILIAL  || F1_DOC  || F1_SERIE  || F1_FORNECE || F1_LOJA  || F1_TIPO
	   INNER JOIN %table:DBC% DBC
	   ON DBC.D_E_L_E_T_ = ' ' AND DBC_FILIAL = %xfilial:DBC%
	   AND DBB_FILIAL || DBB_HAWB || DBB_ITEM  || D1_ITEM =
	   	   DBC_FILIAL || DBC_HAWB || DBC_ITDOC || DBC_ITEM
	   ORDER BY D1_FILIAL, D1_DOC, D1_SERIE, D1_ITEM, D1_COD

	EndSQL

	// %Order:SD1% // EET: No fue útil porque no crea el índice sólo lo recupera :(
	// D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

	// EET: Para Validar SQL antes de algún error
	// Aviso( "cQuery1", GetLastQuery()[2], {"OK"},,,,,.T.)
Return cAlias

// EET: Cuidado: NO Se puede reemplazar por:CpoDBCAcumula
Static Function CampoTot( cAlias, cCampo, lMismaUM)

	Local nCampoTotal := 0 // EET: Importante para definir el tipo.
	Local cUM := ""

	DbSelectArea(cAlias)
	DbGoTop()
	If !Eof() .And. lMismaUM
		cUM := D1_UM
	EndIf
	Do While !Eof() .And. Iif( lMismaUM, (cUM == D1_UM), .T. )
		nCampoTotal  += &(cCampo) //D1_QUANT
		cUM := D1_UM
		DbSkip()
	EndDo
	If !Eof()
		nCampoTotal := -1 * nCampoTotal
	EndIf

Return nCampoTotal

Static Function Buscar( cAlias, cLlave)
	DbSelectArea(cAlias)
	DbGoTop()
	Do While !Eof ()
		If ( cLlave == D1_FILIAL + D1_DOC + D1_SERIE + D1_ITEM  + D1_COD) //  + F1_FORNECE + F1_LOJA
			Return .T.
		EndIf
		DbSkip()
	EndDo

Return .F.

// EET: Mejora: Se puede reemplazar por:CpoDBCAcumula
Static Function TotProrr( cHAWB)
	Local nTotalProrrateo := 0
	Local cCondicion := "DBC_HAWB == '"+cHAWB+"'"

	DbSelectArea("DBC")
	aAreaDBC := GetArea()
	dbSetFilter({|| &cCondicion}, cCondicion)

	DbGoTop()
	While !Eof() .And. xFilial("DBC")+DBB->DBB_HAWB+DBB->DBB_ITEM != DBC->DBC_FILIAL+DBC->DBC_HAWB+DBC->DBC_ITDOC
		DbSkip()
	EndDo
	If !Eof() // XXX: Suponiendo que es Un Sólo GASTO.
		nTotalProrrateo := DBC->DBC_TOTAL
	EndIf

	DbClearFilter()
	RestArea(aAreaDBC)
Return nTotalProrrateo

// EET: Como parametro no es util DBB_HAWB (cHawb) ni DBB_FILIAL, porque DBB es una Area PUBLICA con que se trabaja
Static Function CpoDBCAcumula( uAcumulador, cMacroCpoDBC, cMacroCondicion)
	Local aArea := GetArea()
	Local aAreaDBC := {}

	Default cMacroCondicion := ""

	cCondicion := "DBC->DBC_FILIAL +DBC->DBC_HAWB + DBC->DBC_ITDOC == '" + xFilial("DBC") + DBB->DBB_HAWB + DBB->DBB_ITEM + "'" + cMacroCondicion

	DbSelectArea("DBC")
	aAreaDBC := GetArea()
	dbSetFilter({|| &cCondicion}, cCondicion)

	DbGoTop()
	While !Eof() .And. DBC->DBC_FILIAL + DBC->DBC_HAWB + DBC->DBC_ITDOC == xFilial("DBC") + DBB->DBB_HAWB + DBB->DBB_ITEM
		uAcumulador += &(cMacroCpoDBC)
		If ValType(uAcumulador) == "C"
			uAcumulador += CRLF
		EndIf
		DbSkip()
	EndDo

	DbClearFilter()
	RestArea(aAreaDBC)
	RestArea(aArea)
Return uAcumulador
