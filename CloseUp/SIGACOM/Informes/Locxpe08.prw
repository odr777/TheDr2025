#Include 'protheus.ch'
#include "Topconn.ch"
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXPE08  ºAutor  ³Microsiga           ºFecha ³  02/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada luego de actualizar todos los datos       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Locxpe08()

	Local _aArea 	 := GetArea()  // guardo el Area actual
	Local _aAreaSE2	 := SE2->(GetArea())  // guardo el Area de la Se2
	Local _aAreaSF1	 := SF1->(GetArea())  // guardo el Area de la Sf1
	Local _aAreaSD1	 := SD1->(GetArea())  // guardo el Area de la Sd1
	Local _aAreaSF2	 := SF2->(GetArea())  // guardo el Area de la Sf2
	Local _aAreaSD2	 := SD3->(GetArea())  // guardo el Area de la Sd2
	Local _aAreaSC7	 := SC7->(GetArea())  // guardo el Area de la SC7
	Local _aAreaSA2	 := SA2->(GetArea())  // guardo el Area de la SA2
	Local _aAreaSE5	 := SE5->(GetArea())  // guardo el Area de la SE5
	Local _aAreaSE8	 := SE8->(GetArea())  // guardo el Area de la SE8
	Local _aAreaSEU	 := SEU->(GetArea())  // guardo el Area de la SEU
	Local lRet		 :=	.T.
	Local cCodApro	 := ""
	Local cClaveSE2	 := ""
	Local nPosProd   := 0
	Local cNoesFacDi := .T.
	Local _nTotal	 := 0
	Local nMoeda	 := 0
	Local nTxmoeda	 := 0
	Local _RemitoEnt
	Local _PedAe
	Local _DocOrig
	Local _ConRemito := .F.
	Local _ConAe	 := .F.
	Local _ConDocOri := .F.
	Local nPOsRmt    := 0
	Local nPOsPed	 := 0
	Local nPosNFOri  := 0
	Local nPOsQuant	 := 0
	Local nPosCod	 := 0
	Local nPosPedC	 := 0
	Local nPosItmPc	 := 0
	Local cBanGen    := ""//Substr(GETMV("MV_CXFIN"),1,3) // Banco general
	Local cComprb    := ""
	Local cAntc      := ""
	Local nValDev    := 0
	Local cSeqCxa    := ""
	Local cNRREND
	Local cContad
	Local cDiactb
	Local cNodia
	Local cMoeda
	Local cStatus
	Local cUsualib
	Local cXdesNat
	Local cDespJur
	Local cRatJur
	Local cNaturez
	Local cFatjur
	Local cBenef
	Local cHistor
	Local cCaixaA
	Local __nCxValor
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agregados para integracion con CRM                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Gabriel ÄÄÄÄÙ
	Local aItems   := {}
	Local cTipo 	:= ""
	Local cFecha	:= ""
	Local cProv		:= ""
	Local cTienda	:= ""
	Local cNumero	:= ""
	Local cSerie	:= ""
	Local cErro    := ""
	Local cCodBem := ""
	local aPartesApuntes := {}
	local i
	Private nTMcbase := TamSX3("N1_CBASE")[1]

	// COPIA LOS DATOS DE LA COMPRA AL ACTIVO FIJO
	If FUNNAME()=="MATA101N" .OR. FUNNAME()$ ("MATA102N|IMPORTREM") 
		ActFijo(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,nTMcbase)
	EndIf

	If FUNNAME()$ ("MATA102N|IMPORTREM") .AND. SF1->F1_SERIE = 'PTD'

		// dbSelectArea("STP")
		// dbSetOrder(1)
		// STP->( dbGoBottom() )
		// cOrdem  := STP->TP_ORDEM

		//nPosCod := GdFieldPos("D1_COD")
		oTable := table_appo()
    	cAlias := oTable:GetAlias()
		For i:= 1 to Len(aCols)
			lhorometro = .t.
			// cCodBem := POSICIONE("ST9",1,XFILIAL("ST9")+POSICIONE("SB1",1,XFILIAL("SB1")+GDFIELDGET('D1_COD',i),"B1_UCODBEM"),"T9_CODBEM")
			clvlbien := GDFIELDGET('D1_CLVL',i)
			getATF(clvlbien,XFILIAL("SD1"))// Busca posiciona sobre el b
			cCodBien = VW_ATF->N3_CBASE
			cItem = VW_ATF->N3_ITEM

			dbSelectArea("STP")
			dbSetOrder(1)
			STP->( dbGoBottom() )
			cOrdem  := STP->TP_ORDEM
			cCodBem := POSICIONE("ST9",8,XFILIAL("ST9")+cCodBien+cItem,"T9_CODBEM")


			// D1_UHRFINE,D1_UHRINIE
			nCONTiniV := GDFIELDGET('D1_UHRINIE',i) // HORA INICIAL
			nCONT1V := GDFIELDGET('D1_UHRFINE',i) // HORA FINAL
			if !EMPTY(GDFIELDGET('D1_UKMINI',i))
				nCONTiniV := GDFIELDGET('D1_UKMINI',i) // KM INICIAL
				nCONT1V := GDFIELDGET('D1_UKMFIN',i) // KM FINAL
				lhorometro = .f.
			endif
			// dDTLEIV := GDFIELDGET('D1_EMISSAO',i)
			dDTLEIV :=M->F1_EMISSAO
			cHORA1V := GDFIELDGET('D1_UHORACO',i)
			// T9_FILIAL+T9_CODIMOB
			if empty(cCodBem) <> nil 
				// MNTA830FIF(cCodBem,nCONT1V,dDTLEIV,cHORA1V,clvlbien) // Nahim 
				// Aadd(aPartesApuntes,{cCodBem,nCONT1V,dDTLEIV,cHORA1V,clvlbien})
				(cAlias)->(DBAppend())
				(cAlias)->CODBIEN := cCodBem
				(cAlias)->EMISSAO := dDTLEIV
				if lhorometro
					(cAlias)->D1_UHRINIE := nCONTiniV
					(cAlias)->D1_UHRFINE := nCONT1V
				else
					(cAlias)->D1_UKMINI := nCONTiniV
					(cAlias)->D1_UKMFIN := nCONT1V
				endif
				(cAlias)->D1_UHORACO := cHORA1V
				(cAlias)->D1_CLVL := clvlbien
				(cAlias)->(DBCommit())

			ELSE
				alert("No se encontró el bien" + cCodBien+cItem + " relacionado en la ST9 (CAMPO T9_CODIMOB).")
			endif
		next
		
		(cAlias)->(DBGOTOP())
	    (cAlias)->(DBSetOrder(1))
		While (cAlias)->(!Eof()) // recorre toda la tabla
			cBienAp   :=    (cAlias)->CODBIEN
			dEmAp 	  := 	(cAlias)->EMISSAO
			if lhorometro
				nContaIni := 	(cAlias)->D1_UHRINIE // toma hora inicial (si o si se debería hacer el apunte de la misma)
				cHoraCont := 	(cAlias)->D1_UHORACO //HORA CONTADOR
			else
				nContaIni := 	(cAlias)->D1_UKMINI // toma hora inicial (si o si se debería hacer el apunte de la misma)
				cHoraCont := 	(cAlias)->D1_UKMFIN //HORA CONTADOR
			endif
			cclvlAp   := 	(cAlias)->D1_CLVL    // obtengo la clase de valor 
			while (cAlias)->(!Eof()) .and. (cAlias)->CODBIEN == cBienAp // verifica todo los items de los Bienes
				if lhorometro
					nContaFinal := 	(cAlias)->D1_UHRFINE //debería tomar la hora final de todo el apunte 
				else
					nContaFinal := 	(cAlias)->D1_UKMFIN //debería tomar la hora final de todo el apunte 
				endif
				(cAlias)->(DbSkip())
			enddo
			// hago un apunte al comienzo y al final
			// toma la diferencia
			cMinenMin:= "00" // 
			nDiferHora := nContaFinal -nContaIni // obtengo la diferencia numérica con decimales
			nHoras = NOROUND(nDiferHora,0)// cantidad de horas
			nMinutoNum =Mod(nDiferHora,1) * 100 //  NOROUND(nDiferHora,0)// cantidad de horas
			if nMinutoNum <> 0
				nValConvertir := 60 * nMinutoNum / 100
				cMinenMin := CValToChar(nValConvertir)
			endif
			cHorasStr := StrZero( nHoras,2)
			cHoraFinal := cHorasStr + ":" + cMinenMin
			// NGTRETCON(cBienAp,dEmAp,nContaIni,"00:00",1,,,"C") // considera horario inicial como 00
			// NGTRETCON(cBienAp,dEmAp,nContaFinal,cHoraFinal,1,,,"C")      //
			// MNTA830FIF(cBienAp,nContaIni,dEmAp,cHoraCont,cclvlAp) // Apunte inicial
			MNTA830FIF(cBienAp,nContaFinal,dEmAp,cHoraCont,cclvlAp) // Nahim hace el apunte de todo
			// (cAlias)->(DbSkip())
		enddo
		(cAlias)->(DBCLOSEAREA())
		// ordenar aPartesApuntes por cCodBem + dDTLEIV + cHORA1V
	EndIf

	RestArea(_aAreaSA2)
	RestArea(_aAreaSD2)
	RestArea(_aAreaSF2)
	RestArea(_aAreaSD1)
	RestArea(_aAreaSF1)
	RestArea(_aAreaSE2)
	RestArea(_aAreaSC7)
	RestArea(_aAreaSE5)
	RestArea(_aAreaSE8)
	RestArea(_aAreaSEU)
	RestArea(_aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ ACTFIJO  ³ Autor ³ Francisco Guerrero     ³Fecha ³04/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Actualiza los datos de clasificacion del bien ( tasas, ctas³±±
±±³          ³ informadas en el grupo al cual pertenece dicho bien        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Para la automatizacion de la clasificacion de activos      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³         Motivo de la Alteracion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION ActFijo(cDoc,cSer,cFornece,cLoja, nTMcbase)

	Local aArea     := GetArea()
	Local aAreaSN1  := SN1->(GetArea())
	Local aAreaSN3  := SN3->(GetArea())
	Local aAreaSD1  := SD1->(GetArea())
	Local aAreaSB1  := SB1->(GetArea())
	Local aAreaSE2  := SE2->(GetArea())
	local cCBASEAF  := ""
	Local nImpAdu	:= 0

	IF alltrim(cEspecie)='NF' .Or. alltrim(cEspecie)='RCN' .or. alltrim(cEspecie)='NDP'
		//Factura de entrada | Remito de entrada | Nota de debito proveedor

		dbselectarea("SD1")
		DbSetOrder(1)
		DbSeek(xFilial('SD1')+cDoc+cSer+cFornece+cLoja)

		WHILE SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)==(cDoc+cSEr+cFornece+cLoja)

			IF ALLTRIM(SD1->D1_ESPECIE)==alltrim(cEspecie)//valida especie por si se repiten los numeros

				IF U_MCTESAF(SD1->D1_TES) .and. !EMPTY(SD1->D1_CBASEAF) // Si es un TES de activo fijo

					cCBASEAF:=SUBSTR(SD1->D1_CBASEAF,1,nTMcbase)//obtiene los primeros 10 caracteres

					// clasificacion automatica
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))

					_cGrupoAtf := SB1->B1_XGRATF  //Grupo de bienes de activo fijo

					SNG->(DbSetOrder(1))
					IF !empty(_cGrupoAtf) .and. SNG->(DbSeek(xFilial("SNG") + _cGrupoAtf))

						_cCtCtb   := SNG->NG_CCONTAB
						_cCDeprec := SNG->NG_CDEPREC
						_cCDepr   := SNG->NG_CCDEPR
						_cCusBem  := SNG->NG_CUSTBEM
						_cCCusto  := SNG->NG_CCDESP
						_cCCorrec := SNG->NG_CCCDES
						_cTpdepr  := SNG->NG_TPDEPR
						_Caldepr  := SNG->NG_CALDEPR
						_Cridepr  := SNG->NG_CRIDEPR
						nTxDepr1  := SNG->NG_TXDEPR1
						nTxDepr2  := SNG->NG_TXDEPR2

						aDatosN1 := {}
						//Actualiza datos de cabecera de bienes
						Dbselectarea("SN1")
						Dbsetorder(8)

						//If Dbseek(xFilial("SN1")+cCBASEAF)

						If Dbseek(xFilial("SN1") + SD1->(D1_FORNECE + D1_LOJA + D1_ESPECIE + D1_DOC + D1_SERIE + D1_ITEM) )

							//SD1->(D1_FILIAL + D1_FORNECE + D1_LOJA + D1_ESPECIE + D1_DOC + D1_SERIE + D1_ITEM)
							Do While !SN1->(Eof()) .and.;
							SD1->(D1_FILIAL + D1_FORNECE + D1_LOJA + D1_ESPECIE + D1_DOC + D1_SERIE + D1_ITEM) == SN1->(N1_FILIAL + N1_FORNEC + N1_LOJA + N1_NFESPEC + N1_NFISCAL + N1_NSERIE + N1_NFITEM)

								cChapa := SubStr(SN1->N1_PRODUTO,1,2) + Trim(SN1->N1_CBASE) + "-" + SN1->N1_ITEM
								Reclock("SN1",.F.)
								Replace SN1->N1_GRUPO	With _cGrupoAtf
								Replace SN1->N1_DESCRIC With SUBSTR(SD1->D1_UDESC,1,40)
								Replace SN1->N1_STATUS	With "1"
								Replace SN1->N1_CHAPA	With cChapa
								Replace SN1->N1_LOCAL	With "DEP"
								MsUnlock()
								aAdd( aDatosN1, SN1->N1_CBASE + SN1->N1_ITEM )
								SN1->(DBSKIP())
							Enddo
						ENDIF

						//actualiza datos de los items
						For nX := 1 To Len(aDatosN1)
							Dbselectarea("SN3")
							Dbsetorder(1)
							If Dbseek(xFilial("SN3")+aDatosN1[nX])
								Do While !SN3->(Eof()) .and. aDatosN1[nX] == SN3->N3_CBASE + SN3->N3_ITEM

									IF SN3->(Reclock("SN3",.F.))
										Replace SN3->N3_TIPO	 With "01"
										Replace SN3->N3_TPSALDO  With "1"
										Replace SN3->N3_TPDEPR   With _cTpdepr
										Replace SN3->N3_CALDEPR  With _Caldepr
										Replace SN3->N3_CRIDEPR  With _Cridepr
										Replace SN3->N3_CCONTAB  With _cCtCtb
										Replace SN3->N3_CDEPREC  With _cCDeprec
										Replace SN3->N3_CCDEPR   With _cCDepr
										Replace SN3->N3_CUSTBEM	 With SD1->D1_CC
										Replace SN3->N3_CCUSTO   With SD1->D1_CC
										Replace SN3->N3_TXDEPR1  With nTxDepr1
										Replace SN3->N3_CALCDEP  With GetMV("MV_CALCDEP",.F.,"1")
										Replace SN3->N3_HISTOR With SUBSTR(SD1->D1_UDESC,1,40)
									ENDIF
									SN3->(MsUnlock())
									SN3->(DBSKIP())
								Enddo
							Endif

						Next nX
					ENDIF
				ENDIF
			ENDIF
			SD1->(DBSKIP())
		ENDDO
	ENDIF

	Restarea(aAreaSE2)
	Restarea(aAreaSB1)
	Restarea(aAreaSN1)
	Restarea(aAreaSN3)
	Restarea(aAreaSD1)
	Restarea(aArea)

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ TESAF    ³ Autor ³ Microsiga              ³Fecha ³04/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Verifica si el TES mueve activo fijo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Para la automatizacion de la clasificacion de activos      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha  ³         Motivo de la Alteracion                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³  /  /  ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user function MCTESAF(TES)

	Local AF := .F.
	Local carea:= getarea()

	Dbselectarea("SF4")
	dbsetorder(1)
	IF DBSEEK(xfilial("SF4")+ TES)
		IF F4_ATUATF = "S"
			AF := .T.
		ENDIF
	ENDIF
	Restarea(carea)
Return(AF)







//---------------------------------------------------------------------
/*/{Protheus.doc} MNTA830FIF
Consist?ncia final do informa contador
@author Inácio Luiz Kolling
@since 27/05/2003
@version P12
@return
/*/
//---------------------------------------------------------------------
static Function MNTA830FIF(cBemInF,nCONT1V,dDTLEIV,cHORA1V,cCcD1)

	Local nX
	Local lRet := .T.
    Local aRet := {}


	vNRCONT1 := {}
	vNRCONT2 := {}

	Dbselectarea('ST9')
	Dbsetorder(1)
	Dbseek(xFILIAL("ST9")+cBemInF)

	oSTP:= MNTCounter():New()
	oSTP:setOperation(3)

	If nCONT1V > 0
		oSTP:setValue("TP_CODBEM" ,cBemInF)
		oSTP:setValue("TP_POSCONT",nCONT1V)
		oSTP:setValue("TP_DTLEITU",dDTLEIV)
		if LHOROMETRO
			if empty(chORA1V)
				oSTP:setValue("TP_HORA"   ,substr(Time(),1,5))
			ELSE
				oSTP:setValue("TP_HORA"   ,cHORA1V)
			ENDIF
		ELSE
				oSTP:setValue("TP_HORA"   ,substr(Time(),1,5))
		endif
   EndIf

	lRet := oSTP:inform(vNRCONT1,vNRCONT2)
	If !lRet .And. !Empty(oSTP:getErrorList())
		cError := oSTP:getErrorList()[1]
		Help(,,'HELP',, cError,1,0)
		MsgInfo( cError, 'SIGAMNT' )
	// else // sólo muestra si hay error
		// MsgInfo( 'Contador actualizado con éxito...', 'SIGAMNT' )
	EndIf

Return lRet
//carga atf

static function getATF(cCvl,cFilla)
	Local cQuery	:= ""

	If Select("VW_ATF") > 0
		dbSelectArea("VW_ATF")
		dbCloseArea()
	Endif

	cQuery := "	SELECT N3_FILIAL,N3_CBASE,N3_ITEM,N3_TIPO,N3_SEQ, N3_HISTOR "
	cQuery += "  FROM " + RetSqlName("SN3") + " SN3 "
	cQuery += "  WHERE N3_CLVL = '" + cCvl + "' "
	cQuery += "  AND N3_FILIAL = '" + cFilla + "' AND SN3.D_E_L_E_T_ = '' "

	TCQuery cQuery New Alias "VW_ATF"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return



static function table_appo()


//Cria a temporária
oTempTable := FWTemporaryTable():New("APUNTES")
//  cCodBem,nCONT1V,dDTLEIV,cHORA1V,clvlbien
//Adiciona no array das colunas as que serão incluidas (Nome do Campo, Tipo do Campo, Tamanho, Decimais)
aFields := {}
aAdd(aFields, {"CODBIEN" ,"C",16, 0})
aAdd(aFields, {"EMISSAO" ,"D", 8, 0})
aAdd(aFields, {"D1_UHRINIE","N",10,2})
aAdd(aFields, {"D1_UHRFINE","N",10,2})
aAdd(aFields, {"D1_UKMINI","N",10,2})
aAdd(aFields, {"D1_UKMFIN","N",10,2})
aAdd(aFields, {"D1_UHORACO","C",5,0})
aAdd(aFields, {"D1_CLVL","C",11,0})


//  D1_UHRFINE,D1_UHRINIE
//Define as colunas usadas
oTempTable:SetFields( aFields )
 
//Cria índice com colunas setadas anteriormente
oTempTable:AddIndex("INDICE1", {"CODBIEN", "EMISSAO","D1_UHRINIE","D1_UHRFINE"} )
 
//Efetua a criação da tabela
oTempTable:Create()

return oTempTable
