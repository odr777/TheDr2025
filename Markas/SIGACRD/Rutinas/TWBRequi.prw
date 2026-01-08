#DEFINE CRLF Chr(13)+Chr(10)
#Include "PROTHEUS.CH"
#Include 'RWMAKE.CH'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TWBRequi  ºAutor  ³EDUAR ANDIA TAPIA   ºFecha ³  16/04/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pantalla de Selección de Requisitos /Tipo de Crédito  	  º±±
±±º          ³ 				                      						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIMA\Bolivia                                            	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TWBRequi()
Local oOK		:= LoadBitmap(GetResources(),'lbok.png')
Local oNO 		:= LoadBitmap(GetResources(),'lbno.png')
Local aCabec 	:= {}
Local aTam	 	:= {}
Local aItens 	:= {}
Local nI		:= 0
Local aTipCrd	:= {}
Static lRet	 	:= .T.
Static oDlg, oQtdReq,oTexto

Private cTipCrd	:= ZTC->ZTC_CODIGO 
Private cQtdReq	:= "000"
	
	aReqGrv	:= CargaReq(cTipCrd)	//Busca en ZRC - Tip.Crd/Requi	-Vector
	aItens	:= aRequisitos(aReqGrv)	//Busca en ZRQ - Requisitos 	-Array
	cQtdReq	:= TotalReq(aItens)
	
	If Len(aItens) <= 0
		Aviso("TWBRequi","No existe ningun Requisito registrado / 1ro Registrar el Requisito",{"OK"})
		Return(.F.)
	Endif	
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 350,800 PIXEL TITLE 'Requisitos'
	aCabec 	:= {'','Suc','Codigo','Descripcion'}
	aTam	:= {10,20,20,100}
	oBrowse := TWBrowse():New( 01 , 01, 400, 150,,;
							aCabec,aTam, oDlg, ,,,,;
							{||},,,,,,,.F.,,.T.,,.F.,,, )
	
	If Len(aItens) > 0
		oBrowse:SetArray(aItens)			
		//oBrowse:bLine := { || aItens[ oBrowse:nAT ] }	
		oBrowse:bLine :={||{;
				If(aItens[oBrowse:nAt,01],oOK,oNO),;	//Mark
				aItens[oBrowse:nAt,02],;				//Filial
				aItens[oBrowse:nAt,03],;				//Codigo
				aItens[oBrowse:nAt,04]	} }        		//Descripción
	Endif
	oBrowse:bLDblClick 	:= {|| DobleClick(@aItens,@oBrowse)} 
	
	TButton():New(160,010,'Cancelar',oDlg,{|| Salir() 		 },40,10,,,,.T.)
	TButton():New(160,080,'Aceptar'	,oDlg,{|| Aceptar(aItens)},60,10,,,,.T.)
	
	@ 160, 230 SAY oTexto PROMPT "Cant. Requisitos : " SIZE 066, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 160, 296 SAY oQtdReq PROMPT cQtdReq SIZE 040, 007 OF oDlg PICTURE PesqPict("SB2","B2_QATU") COLORS 0, 16777215 PIXEL  	
	
	oBrowse:SetFocus()
	oBrowse:Refresh() 
	
	ACTIVATE MSDIALOG oDlg CENTERED
Return(lRet)
                                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloque de codigo que se ejecuta al dar Click en en Boton Salir 			  	  - EDUAR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function Salir()
aItCmp	:= {}
lRet 	:= .F.
Close(oDlg)
Return 
       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloque de codigo que se ejecuta al dar Click en en Boton Aceptar 			  - EDUAR ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function Aceptar(aItens)
Local nI	 := 0

If Len(aItens) > 0
	For nI:= 1 To Len(aItens)
		
		ZRC->(DbSetOrder(1))
		If ZRC->(DbSeek(aItens[nI][2] + cTipCrd + aItens[nI][3]))
			If !aItens[nI][1]
				//Borrar
				RecLock("ZRC",.F.)   
		        DbDelete()
		        MsUnlock()
			Endif
		Else
			If aItens[nI][1]
				RecLock("ZRC",.T.)
				ZRC->ZRC_FILIAL	:= aItens[nI][2]
				ZRC->ZRC_TIPO   := cTipCrd
				ZRC->ZRC_REQUIS := aItens[nI][3]
				MsUnLock()
			Endif
		Endif
	Next nI
Endif

lRet := .T.
Close(oDlg)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloque de codigo que se ejecuta al dar Doble Click en la Grilla Gasto TwBrowse - EDUAR ³
//³Marca los checkBox y realiza validación por Linea y por monto total del valor digitado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function DobleClick(aItens,oBrowse)

aItens[oBrowse:nAt][1] := !aItens[oBrowse:nAt][1]
//oBrowse:Refresh()

cQtdReq	:= TotalReq(aItens)
oQtdReq:Refresh()

oBrowse:DrawSelect()                 
oBrowse:Refresh()
oDlg:Refresh()
oDlg:oWnd:Refresh()
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query que carga en un array todos los Requisitos de Tipo de Creditos (ZRQ)			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function aRequisitos(aReqGrv)
Local aItens 	:= {}    
Local cQuery	:= ""
Local lCheck	:= .F.
Local nI		:= 0

cQuery := " SELECT *"
cQuery += " FROM " + RetSqlName("ZRQ") + " ZRQ "
cQuery += " WHERE ZRQ_FILIAL = '" + xFilial("ZRQ")+ "' "
cQuery += " AND ZRQ_BLQ <> 'B'" 
cQuery += " AND ZRQ.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY ZRQ_CODIGO "
//Aviso("cQuery1",cQuery,{"OK"},,,,,.T.)

If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
EndIF   
TcQuery cQuery New Alias "StrSQL"
While StrSQL->(!EOF())
	
	For nI := 1 To Len(aReqGrv)
		lCheck := aReqGrv[nI]==StrSQL->ZRQ_CODIGO
		If lCheck
			Exit
		Endif
	Next nI
	
	AAdd( aItens, {	lCheck, ;
					StrSQL->ZRQ_FILIAL	, ;
					StrSQL->ZRQ_CODIGO	, ;
					StrSQL->ZRQ_DESCRI	, ;
					StrSQL->R_E_C_N_O_ 	} )	
	StrSQL->(DbSkip())   
End
StrSQL->(DbCloseArea())
Return(aItens)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma o valor Total da Grilla dos Titulos a Compensar         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function TotalReq(aItens)
Local nTotal := 0
Local nI	 := 0

For nI:= 1 to Len(aItens)
	If aItens[nI][1]	//Si está marcado el check
		nTotal	+= 1
	Endif	
Next nI
Return(nTotal)


Static Function CargaReq(cTipCrd)
Local aRet 		:= {}    
Local cQuery	:= ""

cQuery := " SELECT *"
cQuery += " FROM " + RetSqlName("ZRC") + " ZRC "
cQuery += " WHERE ZRC_FILIAL = '" + xFilial("ZRC")+ "' "
cQuery += " AND ZRC_TIPO = '" + cTipCrd +"'" 
cQuery += " AND ZRC.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY ZRC_TIPO "
//Aviso("cQuery1",cQuery,{"OK"},,,,,.T.)

If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
EndIF   
TcQuery cQuery New Alias "StrSQL"
While StrSQL->(!EOF())	
	AAdd( aRet, StrSQL->(ZRC_REQUIS)  )	
	StrSQL->(DbSkip())   
End
StrSQL->(DbCloseArea())
Return(aRet)