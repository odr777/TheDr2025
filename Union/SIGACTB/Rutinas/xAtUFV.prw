#INCLUDE "RWMAKE.CH"
#INCLUDE "FileIO.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBINFO.CH"

#DEFINE CRLF Chr(13)+Chr(10)

Static __cExt	 := GetDbExtension()
Static lBlind	 := IsBlind()
Static lFWCodFil := FindFunction("FWCodFil")
Static lCtbafin  := FwIsInCallStack("CTBAFIN")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ xAtUFV   	ºAutor  ³EDUAR ANDIA 	  º Data ³ 12/12/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que gera o lançamento da atualização da UFV         º±±
±±ºDesc.     ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xAtUFV

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpca 		:= 0
Local aSays			:= {}
Local aButtons		:= {}
Local cFunction		:= "XGERAITB"
Local cTitle		:= "CONTABILIZACIÓN DE LA AITB"
Local bProcess		:= {|oSelf|AITBProcessa(oSelf)}
Local cDescription	:= "El Objectivo de este programa es contabilizar " +CRLF +"Actualización de la AITB" 
Local cPathLog 		:= GetMv("MV_DIRDOC")
Local cLogArq 		:= "XAITBLog.TXT"
Local cCaminho 		:= cPathLog + cLogArq

Private cPerg		:= "XATUAITB"
Private cCadastro 	:= "Actualización de la AITB"

fErase(cCaminho)
CriaPerg(cPerg)
		
ProcLogIni(aButtons)
tNewProcess():New( cFunction, cTitle, bProcess, cDescription, cPerg )
//oProcess := tNewProcess():New( cFunction, cTitle, {|oSelf| FA210NewPerg ( oSelf ) }, cDescription, cPerg )

Return

//+------------------------------------------------------------------------+
//|Función que verifica si existe la Pregunta, caso no exista lo crea	   |
//+------------------------------------------------------------------------+
Static Function CriaPerg(cPerg)
Local aRegs 	:= {}
Local i			:= 0

cPerg := PADR(cPerg,10)

aAdd(aRegs,{"01","De Fecha ? :"			,"mv_ch1","D",TamSx3("CT2_DATA")[1],0,1,"G","mv_par01",""       ,""            ,""        ,""     ,""		,""})
aAdd(aRegs,{"02","A Fecha ? :"			,"mv_ch2","D",TamSx3("CT2_DATA")[1],0,1,"G","mv_par02",""       ,""            ,""        ,""     ,""		,""})

DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aRegs)
   dbSeek(cPerg+aRegs[i][1])
   If !Found()
      RecLock("SX1",!Found())
         SX1->X1_GRUPO    := cPerg
         SX1->X1_ORDEM    := aRegs[i][01]
         SX1->X1_PERSPA   := aRegs[i][02]
         SX1->X1_VARIAVL  := aRegs[i][03]
         SX1->X1_TIPO     := aRegs[i][04]
         SX1->X1_TAMANHO  := aRegs[i][05]
         SX1->X1_DECIMAL  := aRegs[i][06]
         SX1->X1_PRESEL   := aRegs[i][07]
         SX1->X1_GSC      := aRegs[i][08]
         SX1->X1_VAR01    := aRegs[i][09]
         SX1->X1_DEFSPA1  := aRegs[i][10]
         SX1->X1_DEFSPA2  := aRegs[i][11]
         SX1->X1_DEFSPA3  := aRegs[i][12]
         SX1->X1_DEFSPA4  := aRegs[i][13]
         SX1->X1_F3       := aRegs[i][14]
         SX1->X1_VALID    := aRegs[i][15]         
      MsUnlock()
   Endif
Next i
Return


Static Function AITBProcessa(oSelf)
Local aRet		:= {}
Local nOpc 		:= 0
Local aCposF4	:= {}
Local aRecs 	:= {}
Local cSeek		:= ""
Local cWhile	:= ""
Local cCondicao	:= ""
Local cTitulo	:= 'Facturas de Venta'
Local cAliasCab	:= "SF2"
Local cSerie	:= "   "
Local lRetSer	:= .F.
Local cNccSFP	:= If(cPaisLoc == "COL","2","4")
Local xMarcaOk	:= ""		//"AlwaysTrue()"
Local lRet		:= .T.

Private aFiltro	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida /Monedas					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := lRet .AND. TudOkSM2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida /Plan de Cuentas			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := lRet .AND. TudOkCT1()
If lRet	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Generar Asiento (AITB)			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LancAitb(oSelf)	
Endif
//oProcess := MsNewProcess():New( { | lEnd | lOk := AtuSE5( @lEnd, aRecs ) }, "Atualizando", "Aguarde, atualizando ...", .F. )				
//oProcess:Activate()

Return

//+-------------------------------------+
//|Gera Lançamento AITB  				|
//+-------------------------------------+
Static Function LancAitb(oSelf)
Local nI 		:= 0
Local cQuery	:= ""
Local cMsg		:= ""
Local cTxtReg1	:= ""
Local nMoedAITB := 4
Local nTxMoeFim	:= 0

Local lLancPad  := VerPadrao("110") .AND. VerPadrao("111")
Local cArquivo  := ""
Local nHdlPrv   := 0
Local nTotal    := 0
Local lMostra   := .T.
Local lAglutina := .F.

//Local cMsg	:= "Problema en Tasa de cambio /Monedas: " +CRLF
Private cAliasTRB 		:= GetNextAlias()
Private nVlrAITB		:= 0
Private aErro          	:= {}
Private lAutoErrNoFile 	:= .F.
Private lMSErroAuto    	:= .F.

cTxtReg1 :=	"..... Generando La contabilización (AITB)"
If oSelf <> nil		
	oSelf:IncRegua1(cTxtReg1)
	//oSelf:SetRegua1(Len(aRecs)+1)
Else
	IncProc(cTxtReg1)
	//ProcRegua(Len(aRecs)+1)
EndIf

Pergunte(cPerg,.F.)

If Type("MV_PAR02")=="D"
	SM2->(dbSetOrder(1))
	If SM2->(MsSeek(MV_PAR02))
		nTxMoeFim := SM2->&("M2_MOEDA"+Alltrim(Str(nMoedAITB)))
	Endif
Endif

If nTxMoeFim > 0

	cQuery := " SELECT CT2_FILIAL"
	cQuery += " 	,CASE WHEN SUM(VLRACT) >= 0 THEN '1' ELSE '2' END AS CT2_DC"
	cQuery += " 	,CT1_CONTA,CTT_CUSTO,SUM(CT2_VALOR) CT2_VALOR,SUM(VLRACT) VLRACT"
	
	cQuery += " FROM ("
	 
	cQuery += " SELECT"
	cQuery += " CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_SEGOFI"
	cQuery += " 	,CT1_CONTA	"
	cQuery += " 	,CT2_DEBITO	"
	cQuery += " 	,CT2_CREDIT	"
	cQuery += " 	,CT1_DESC01	"
	cQuery += " 	,CT2_VALOR	"
	cQuery += " 	,CT2_DC		"
	cQuery += " 	,CT2_LINHA	"
	cQuery += " 	,CT2_HIST	"
	cQuery += " 	,CTT_CUSTO 	"
	cQuery += " 	,(CT2_VALOR * " + AllTrim(Str(nTxMoeFim)) + " /M2_MOEDA" + AllTrim(Str(nMoedAITB)) +") - CT2_VALOR AS VLRACT"
	cQuery += " FROM " + RetSqlName("CT2") + " CT2 	"
	cQuery += " LEFT JOIN " + RetSqlName("CT1") + " CT1 ON (CT2_DEBITO = CT1_CONTA) AND CT1_FILIAL = '" + xFilial("CT1") + "' AND CT1.D_E_L_E_T_ <> '*'	" 
	cQuery += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON (CT2_CCD    = CTT_CUSTO) AND CTT_FILIAL = '" + xFilial("CTT") + "' AND CTT.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + RetSqlName("SM2") + " SM2 ON M2_DATA = CT2_DATA AND SM2.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE  CT1_FILIAL = '" + xFilial("CT1") + "'"
	cQuery += " 	AND CT1_XATUFV = 'S' "
	cQuery += " 	AND CT2_FILIAL = '" + xFilial("CT2") + "'"
	cQuery += " 	AND CT2_DATA BETWEEN '" + DTOS(MV_PAR01) +"' AND '" + DTOS(MV_PAR02) + "'" 
	cQuery += " 	AND CT2_MOEDLC = '01' "
	cQuery += " 	AND CT2_TPSALD = '1' "
	cQuery += " 	AND CT2_DC IN ('1','3')	" 
	cQuery += " 	AND CT2.D_E_L_E_T_ <> '*'" 
	cQuery += " UNION ALL   "
	cQuery += " SELECT 		"
	cQuery += " 	CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_SEGOFI"
	cQuery += " 	,CT1_CONTA	"
	cQuery += " 	,CT2_DEBITO	"
	cQuery += " 	,CT2_CREDIT	"
	cQuery += " 	,CT1_DESC01	"
	cQuery += " 	,CT2_VALOR	"
	cQuery += " 	,CT2_DC		"
	cQuery += " 	,CT2_LINHA	"
	cQuery += " 	,CT2_HIST	"
	cQuery += " 	,CTT_CUSTO	"
	cQuery += " 	,((CT2_VALOR * " + AllTrim(Str(nTxMoeFim)) + " /M2_MOEDA" + AllTrim(Str(nMoedAITB)) +") - CT2_VALOR) * -1 AS VLRACT"
	cQuery += " FROM " + RetSqlName("CT2") + " CT2 	"
	cQuery += " LEFT JOIN " + RetSqlName("CT1") + " CT1 ON (CT2_CREDIT = CT1_CONTA) AND CT1_FILIAL = '" + xFilial("CT1") + "' AND CT1.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + RetSqlName("CTT") + " CTT ON (CT2_CCC    = CTT_CUSTO) AND CTT_FILIAL = '" + xFilial("CTT") + "' AND CTT.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + RetSqlName("SM2") + " SM2 ON M2_DATA = CT2_DATA AND SM2.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE  CT1_FILIAL = '" + xFilial("CT1") + "'"
	cQuery += " 	AND CT1_XATUFV = 'S' "
	cQuery += " 	AND CT2_FILIAL = '" + xFilial("CT2") + "'"
	cQuery += " 	AND CT2_DATA BETWEEN '" + DTOS(MV_PAR01) +"' AND '" + DTOS(MV_PAR02) + "'"
	cQuery += " 	AND CT2_MOEDLC = '01' 		"
	cQuery += " 	AND CT2_TPSALD = '1' 		"
	cQuery += " 	AND CT2_DC IN ('2','3')		"
	cQuery += " 	AND CT2.D_E_L_E_T_ <> '*'	"
	
	cQuery += " )TAB "
	cQuery += " GROUP BY CT2_FILIAL,CT1_CONTA,CTT_CUSTO "
	cQuery += " ORDER BY CT2_FILIAL,CT1_CONTA,CTT_CUSTO " 
	
	cQuery := ChangeQuery(cQuery)
	//Aviso("cQuery1",cQuery,{"OK"},,,,,.T.)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)
	DbSelectArea(cAliasTRB)
	
	If lLancPad	
		oSelf:SetRegua1((cAliasTRB)->(FCount())+1)	
	
		Begin Transaction
		cLoteCtr :=	"CONTAB"
		nHdlPrv	 :=	HeadProva(cLoteCtr,"AITB",Subs(cUsuario,7,6),@cArquivo)
			
		While (cAliasTRB)->(!Eof())
			
			If Round((cAliasTRB)->VLRACT , 2) <> 0
				nTotal 	 += DetProva(nHdlPrv,"110","AITB",cLoteCtr)
				nVlrAITB := nVlrAITB + Round((cAliasTRB)->VLRACT,2)
				//cMsg := cMsg + (cAliasTRB)->CT1_CONTA + " / " +(cAliasTRB)->CTT_CUSTO + " / " + AllTrim(Str((cAliasTRB)->VLRACT)) + CRLF
			Endif
			
			(cAliasTRB)->(DbSkip())
		EndDo
		
		If lLancPad .and. nTotal > 0
        	SaveInter()
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Envia para Lancamento Contabil, se gerado arquivo   ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            nTotal 	 += DetProva(nHdlPrv,"111","AITB",cLoteCtr)
            RodaProva(nHdlPrv,nTotal)

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Envia para Lancamento Contabil, se gerado arquivo   ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            lOk := CA100Incl( cArquivo, nHdlPrv, 3, cLoteCtr, lMostra,.F.)
            
            If lOk
            	//Aviso("AVISO -AITB","Se contabilizó la actualización UFV",{"OK"},,,,,.T.)
            Endif
            RestInter()
        ENDIF
		
		End Transaction
	Endif
	(cAliasTRB)->(DbCloseArea())
Endif

Return

//+-------------------------------------+
//|Tela /Botão "OK"			  			|
//+-------------------------------------+
Static Function ValidaOk
oDlg:End()
Return

//+-------------------------------------+
//|Verifica /valida las Monedas UFV		|
//+-------------------------------------+
Static Function TudOkSM2()
Local lRet 		:= .T.
Local cQuery	:= ""
Local cAliasTRB := GetNextAlias()
Local cMsg		:= "Problema en Tasa de cambio /Monedas: " +CRLF

cQuery := " SELECT			"
cQuery += " 	CT2_FILIAL 	"
cQuery += " 	,CT2_DATA	"
cQuery += " 	,M2_DATA	"
cQuery += " 	,MAX(M2_MOEDA4) M2_MOEDA_UFV	" 
cQuery += " FROM " + RetSqlName("CT2") + " CT2 	"
cQuery += " LEFT JOIN "+ RetSqlName("SM2") + " SM2 ON M2_DATA = CT2_DATA AND SM2.D_E_L_E_T_ <> '*'	"
cQuery += " WHERE CT2_DATA BETWEEN '" +DTOS(MV_PAR01) +"' AND '" + DTOS(MV_PAR02)+ "' "
cQuery += " AND CT2.D_E_L_E_T_ <> '*' 				"
cQuery += " AND CT2_FILIAL = '" + xFilial("CT2")+ "'"
cQuery += " AND (M2_DATA IS NULL OR M2_MOEDA4 = 0)	"
cQuery += " GROUP BY CT2_FILIAL,CT2_DATA,M2_DATA	"
cQuery += " ORDER BY CT2_FILIAL,CT2_DATA			"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)
DbSelectArea(cAliasTRB)
        
While (cAliasTRB)->(!Eof())
	lRet := .F.
	cMsg := cMsg + (cAliasTRB)->CT2_DATA + " / "	
	(cAliasTRB)->(DbSkip())
EndDo
(cAliasTRB)->(DbCloseArea())
        
If !lRet
	Aviso("xAtUFV",cMsg,{"OK"},,,,,.T.)
Endif

Return(lRet)


//+-------------------------------------+
//|Verifica /valida El Plan de Cuentas	|
//+-------------------------------------+
Static Function TudOkCT1()
Local lRet 		:= .F.
Local cQuery	:= ""
Local cAliasTRB := GetNextAlias()
Local cMsg		:= "Problema en Plan de cuentas: " +CRLF

If CT1->(FieldPos("CT1_XATUFV")) > 0

	cQuery := " SELECT CT1_FILIAL,CT1_CONTA,CT1_DESC01,CT1_CLASSE,CT1_XATUFV "
	cQuery += " FROM " + RetSqlName("CT1") + " CT1 	"
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND CT1_XATUFV = 'S'"
	cQuery += " ORDER BY CT1_FILIAL,CT1_CONTA"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)
	DbSelectArea(cAliasTRB)
	        
	While (cAliasTRB)->(!Eof())
		lRet := .T.
		(cAliasTRB)->(DbSkip())
	EndDo
	(cAliasTRB)->(DbCloseArea())
Endif

If !lRet
	cMsg := cMsg + "No se encontró ninguna cuenta que indique que realizará la actualización (CT1_XATUFV) "
	Aviso("xAtUFV",cMsg,{"OK"},,,,,.T.)
Endif

Return(lRet)