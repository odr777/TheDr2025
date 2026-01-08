#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE CRLF Chr(13)+Chr(10)

Static cTmSequen := PadL(GetNewPar( "MV_CV1SEQ" , '9999' ),TamSx3("CV1_SEQUEN")[1],"0") // Tamanho do campo do cv1_sequen

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CT390BTE  ºAutor  ³EDUAR ANDIA		º Data ³  25/11/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE usado para a inclusão de botões na tela do orçamento.   º±±
±±º          ³ É chamado na montagem da tela de inclusão/alteração        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT390BTE
Local aButton 	:= ParamIxb

If INCLUI
	aAdd( aButton, { "Cargar" , {|| CtbCarga()} , "Carrega","Carga" } )
Endif
Return(aButton)


//+-------------------------------------+
//|Carga de Cuentas Contables			|
//+-------------------------------------+
Static Function CtbCarga
Local aSaveArea := GetArea()
Local aAreaSX1 	:= SX1->( GetArea() )
Local nCpo
Local nTotOrc 	:= 0
Local nCont	  	:= 1
Local cRevisa 	:= CV2->CV2_REVISA
Local lSeqMaior := .F.
Local nDifCols  := 0
Local cPerg		:= "XPRECTB"
Local cPictVal 	:= PesqPict("CV1","CV1_VALOR")
Local lCab		:= .T.

Local __cCtaIni	:= ""
Local __cCtaFim	:= ""
Local __cCCusto	:= ""

criaPerg(cPerg)
Pergunte(cPerg,.T.)

__cCtaIni := mv_par01
__cCtaFim := mv_par02
__cCCusto := mv_par03
RestArea(aAreaSX1)

If !Empty(__cCCusto)
	CTT->(DbSetOrder(1))
	If !CTT->(DbSeek(xFilial("CTT")+__cCCusto))
		Aviso("CT390BTE","Centro de Costo '"+__cCCusto+"' no Existe, verificar.",{"OK"})
		Return
	Endif
EndIf

DbSelectArea("TMP")
__cSequen := STRZERO( 0, TamSX3("CV1_SEQUEN")[1] )

DbSelectArea("CT1")
CT1->(DbSetOrder(1))
CT1->(DbSeek(xFilial("CT1")))
While CT1->(!Eof())
	
	If CT1->CT1_CONTA >= __cCtaIni .AND. CT1->CT1_CONTA <= __cCtaFim
		If CT1->CT1_CLASSE=="2"
			
			DbSelectArea("TMP")
			If lCab
				DBDelete()
				lCab := .F.
			Endif
			DbAppend()
			
			ProcRegua( 1 )
			__cSequen := SOMA1(__cSequen)
			
			For nCpo := 1 To Len(aHeader)
				If ( aHeader[nCpo][08] <> "M" .And. aHeader[nCpo][10] <> "V" )
					If AllTrim(aHeader[nCpo][02]) $ "CV1_CT1INI|CV1_CT1FIM"
						Replace &(aHeader[nCpo][2]) With CT1->CT1_CONTA
					Else
						If AllTrim(aHeader[nCpo][02]) $ "CV1_CTTINI|CV1_CTTFIM"
							Replace &(aHeader[nCpo][2]) With __cCCusto
						Else	
							Replace &(aHeader[nCpo][2]) With CriaVar(aHeader[nCpo][2], .T.)
						Endif	
					Endif
					
				ElseIf aHeader[nCpo][08] = "M"
					Replace &(aHeader[nCpo][2]) With CriaVar(aHeader[nCpo][2])
				EndIf
			Next nCpo
			
			REPLACE TMP->CV1_SEQUEN	WITH __cSequen	//STRZERO( 1, Len(CV1->CV1_SEQUEN) )
			TMP->CV1_ENTIDA := 1
			TMP->CV1_MOEDA	:= M->CV1_MOEDA
						
			M->CV1_REVISA	:= "001"
			M->CV1_STATUS 	:= "1"
			M->CV1_APROVA   := " "
			M->CV1_CALEND	:= "019"			
			nTotOrc 		:= 0.00
			
			// carrego a array com todas as sequencias diponiveis
			If Val(__cSequen) > 1
				If Len(aColsP[1]) > 0
					AADD( aColsP, aColsP[1]  )
				Endif
			Endif
			
			//Aviso("CT390BTE -aColsP"		,u_zArrToTxt(aColsP, .T.)	,{"Ok"},,,,,.T.)
			//Alert(Val(TMP->CV1_SEQUEN))
			
			Pergunte("CTB390",.F.)			
			/*
			oPeriodo:nAt := Val(TMP->CV1_SEQUEN)
			StaticCall(ctba390,ct390OnChg,oPeriodo, oOrcado, oVlrOrc, nOrc, oTotOrc, nTotOrc, PesqPict("CV1","CV1_VALOR"), .T.)			
			CTB390LOk()
			*/			
			Ctb390CarCal(Val(TMP->CV1_SEQUEN),oPeriodo)	 			//Carrega calendario
			CTB390DspOrc(oOrcado,oVlrOrc,@nOrc,oTotOrc,@nTotOrc)
		Endif
	Endif
	CT1->(DbSkip())
EndDo

If Val(__cSequen) <= 0
	Aviso("CT390BTE","No se encontró ningún registro para cargar",{"OK"})
Endif

RestArea(aAreaSX1)
RestArea(aSaveArea)
Return
		
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB390DspOrc³ Autor ³ Wagner Mobile Costa ³ Data ³ 05/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para atualizar a entidade atual da GetDb            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB390DspOrc(oOrcado,oVlrOrc,nOrc,oTotOrc,nTotOrc)         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA390                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oOrcado   = Objeto com a descricao do tipo de orcamento    ³±±
±±³          ³ oVlrOrc   = Objeto com o valor do orcamento da linha       ³±±
±±³          ³ nOrc      = Variavel com o valor da linha atual orcamento  ³±±
±±³          ³ oTotOrc   = Objeto com o total do orcamento          	  ³±±
±±³          ³ nTotOrc   = Variavel com o valor total do orcamento  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTB390DspOrc(oOrcado,oVlrOrc,nOrc,oTotOrc,nTotOrc,nSeqColsP)

Local cTitulo 		:= cF3 := "", lMostra, nCont, nCols, nRecno := TMP->(Recno())
Local cCpoDsc
Local nEntidades	:= Ct390CtEnt(, @cF3, @lMostra, @cTitulo, @cCpoDsc)
Local nTtOrc		:= 0

Pergunte("CTB390",.F.)

If mv_par03 # 1
	Return .T.
EndIf

If ValType(nSeqColsP) <> "N"
	nSeqColsP := Val(TMP->CV1_SEQUEN)
EndIf

TMP->CV1_ENTIDA := nEntidades

If nOrc # Nil .And. nSeqColsP <= Len(aColsP) .And. nSeqColsP > 0
	nOrc := 0
	For nCont := 1 To Len(aColsP[nSeqColsP])
		nOrc += aColsP[nSeqColsP][nCont][4] * TMP->CV1_ENTIDA
	Next
Endif

If oOrcado <> Nil
	If cF3 $ "CT1,CTT,CTD,CTH"
		If M->CV1_MOEDA > "01" .And. Empty(&(cF3 + "->" + cF3 + "_DESC" + M->CV1_MOEDA))
			oOrcado:cCaption := &(cF3 + "->" + cF3 + "_DESC01")
		Else
			oOrcado:cCaption := &(cF3 + "->" + cF3 + "_DESC" + M->CV1_MOEDA)
		Endif
	ElseIf cF3 == "CV0"
		oOrcado:cCaption := &(cF3 + "->" + cF3 + "_DESC")
	Else
		oOrcado:cCaption := &(cF3 + "->" + cCpoDsc)
	EndIf					
	
	oOrcado:cCaption := "Presupuestado " + AllTrim(cTitulo) + " "+ /*"Orcado "*/If(lMostra, AllTrim(oOrcado:cCaption) + " ", "")
	oVlrOrc:cCaption := AllTrim(Trans(nOrc, Tm(0, 21, 2)))
	oOrcado:Refresh()
	oVlrOrc:Refresh()
Endif

If nTotOrc <> Nil
	nTtOrc := 0
	TMP->(DbGoTop())
	While TMP->(!Eof())
		If TMP->CV1_FLAG
			TMP->(dbSkip())
			Loop
		Endif
		
		If ( ! Empty( TMP->CV1_SEQUEN ) .And. TMP->CV1_SEQUEN <> Nil .And. TMP->CV1_SEQUEN <= cTmSequen  )
		
			nSeqColsP := Val(TMP->CV1_SEQUEN)

			IF ( nSeqColsP > 0 .And. nSeqColsP <> nil )

				For nCont := 1 To Len(aColsP[nSeqColsP])
					nTtOrc += aColsP[nSeqColsP][nCont][4] * TMP->CV1_ENTIDA
				Next

			Endif
		Endif

		TMP->(dbSkip())
	EndDo
	TMP->(DbGoTo(nRecno))
	
	If nTtOrc <> 0
		nTotOrc := nTtOrc

		If oTotOrc <> Nil
			oTotOrc:Refresh()
		Endif
	Endif
	
Endif

Return .T.

//+------------------------------------------------------------------------+
//|Función que verifica si existe la Pregunta, caso no exista lo crea	   |
//+------------------------------------------------------------------------+
Static Function CriaPerg(cPerg)
Local aRegs 	:= {}
Local i			:= 0

cPerg := PADR(cPerg,10)
aAdd(aRegs,{"01","De Cuenta? :"			,"mv_ch1","C",TamSx3("CT1_CONTA")[1],0,1,"G","mv_par01",""       ,""            ,""        ,""     ,"CT1"  	,""})
aAdd(aRegs,{"02","A Cuenta?  :"			,"mv_ch2","C",TamSx3("CT1_CONTA")[1],0,1,"G","mv_par02",""       ,""            ,""        ,""     ,"CT1"   ,""})
aAdd(aRegs,{"03","Centro de Costo? :"	,"mv_ch3","C",TamSx3("CTT_CUSTO")[1],0,1,"G","mv_par03",""       ,""            ,""        ,""     ,"CTT"	,""})


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
