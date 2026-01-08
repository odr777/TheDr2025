#Include 'protheus.ch'

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

Private nTMcbase := TamSX3("N1_CBASE")[1]

If FUNNAME()=="MATA101N"
	ActFijo(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,nTMcbase)
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


/*
STATIC FUNCTION ActFijo(cDoc,cSer,cFornece,cLoja, nTMcbase)

Local aArea     := GetArea()
Local aAreaSN1  := SN1->(GetArea())
Local aAreaSN3  := SN3->(GetArea())
Local aAreaSD1  := SD1->(GetArea())
Local aAreaSB1  := SB1->(GetArea())
Local aAreaSE2  := SE2->(GetArea())
local cCBASEAF  := ""
Local nImpAdu	:= 0

IF alltrim(cEspecie)='NF' //.Or. alltrim(cEspecie)='RCN' .or. alltrim(cEspecie)='NDP'//Factura de entrada | Remito de entrada | Nota de debito proveedor
	
	dbselectarea("SD1")
	DbSetOrder(1)
	DbSeek(xFilial('SD1')+cDoc+cSer+cFornece+cLoja)
	WHILE SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)==(cDoc+cSEr+cFornece+cLoja)
		
		IF ALLTRIM(SD1->D1_ESPECIE)==alltrim(cEspecie)//valida especie por si se repiten los numeros
			
			
			IF U_MCTESAF(SD1->D1_TES) .and. !EMPTY(SD1->D1_CBASEAF) // Si es un TES de activo fijo
				
				cCBASEAF:=SUBSTR(SD1->D1_CBASEAF,1,nTMcbase)//obtiene los primeros 10 caracteres
				
				
				aDatosN1 := {}
				//Actualiza datos de cabecera de bienes
				Dbselectarea("SN1")
				Dbsetorder(8)
				//If Dbseek(xFilial("SN1")+cCBASEAF)
				If Dbseek(xFilial("SN1") + SD1->(D1_FORNECE + D1_LOJA + D1_ESPECIE + D1_DOC + D1_SERIE + D1_ITEM) )
					Do While !SN1->(Eof()) .and. SD1->(D1_FILIAL + D1_FORNECE + D1_LOJA + D1_ESPECIE + D1_DOC + D1_SERIE + D1_ITEM) == SN1->(N1_FILIAL + N1_FORNEC + N1_LOJA + N1_NFESPEC + N1_NFISCAL + N1_NSERIE + N1_NFITEM)
						cChapa := SubStr(SN1->N1_PRODUTO,1,2) + Trim(SN1->N1_CBASE) + "-" + SN1->N1_ITEM
						cAfdesc := SD1->D1_UDESC
						Reclock("SN1",.F.)
						//Replace SN1->N1_GRUPO	With _cGrupoAtf
						Replace SN1->N1_DESCRIC	With cAfdesc
						Replace SN1->N1_CHAPA	With cChapa
						MsUnlock()
						//aAdd( aDatosN1, SN1->N1_CBASE + SN1->N1_ITEM )
						SN1->(DBSKIP())
					Enddo
				endif
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
*/

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
/*
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
*/
