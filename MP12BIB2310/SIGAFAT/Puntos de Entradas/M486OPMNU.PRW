#include 'protheus.ch'
#include 'parmtype.ch'
// #INCLUDE "M486XFUNBO.CH" 
 
User Function M486OPMNU()
     Local aOpcAdi := {}
     aAdd(aOpcAdi, {"Imprimir", "U_ImpFacTra()",  0,1,0,NIL})    // Imprimir Factura Seleccionada
     aAdd(aOpcAdi, {"Anular"  , "U_AnuFac()",     0,1,0,NIL})    // Anular Factura Seleccionada
	 aAdd(aOpcAdi, {"Mon. Anulación"  , "U_MonAnuFac()",     0,1,0,NIL})    // Anular Factura Seleccionada
Return aOpcAdi
 
User Function ImpFacTra()
	_cDoc := SF2->F2_DOC
	_cSerieFac := SF2->F2_SERIE
	//cNomArq 	:= 'l01000000000000000031nf.pdf'		
	cNomArq	:= _cSerieFac + _cDoc + TRIM(SF2->F2_ESPECIE) + '.pdf'
	cDirUsr := GetTempPath()
	cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
	__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
	nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
	If nRet <= 32
		MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
	EndIf 
return nil

User Function AnuFac()
     cPerg := "MATA486G"
     u_zAtuPerg(cPerg+Space(2), "MV_PAR01", SF2->F2_SERIE)
     u_zAtuPerg(cPerg+Space(2), "MV_PAR02", SF2->F2_DOC)
     u_zAtuPerg(cPerg+Space(2), "MV_PAR03", SF2->F2_DOC)
     M486XFBOLB()
return nil

User Function MonAnuFac()
     cPerg := "MATA486G"
     u_zAtuPerg(cPerg+Space(2), "MV_PAR01", SF2->F2_SERIE)
     u_zAtuPerg(cPerg+Space(2), "MV_PAR02", SF2->F2_DOC)
     u_zAtuPerg(cPerg+Space(2), "MV_PAR03", SF2->F2_DOC)
     U_XM486XFBOLB()
return nil

/*/{Protheus.doc} XM486XFBOLB
  Función que comunica la anulacion de documentos electrónicos SIN.
  @type
  @author Omar Delgadillo
  @since 02/06/2025
  @version 1.0
  @param N/A
  @return ${return}, ${return_description}
  @example
  (examples)
  @see (links_or_references)
  /*/
User Function XM486XFBOLB()
	#define STR0007 "serie"
 	#define STR0008 "Cliente"
    #define STR0009 "Tienda"
    #define STR0014 "Anulación"
    #define STR0015 "No se encontraron facturas para anular"
    //#define STR0016 "revise los parametros de selección"
	#define STR0016 "Ok"
    #define STR0017 "Anulacción de Facturas"
    #define STR0018 "Buscar"
    #define STR0019 "Leyenda"
    #define STR0020 "Factura + Serie"
    #define STR0021 "Documento"
    #define STR0022 "Fecha de emisión"
    #define STR0023 "Fecha de autorización (SUNAT)"
    #define STR0024 "Nombre"   
    #define STR0025 "Marcar Todos"
    #define STR0026 "Desmarcar Todos"
    #define STR0027 "Invierte selección"
    #define STR0028 "Ocurrieron inconvenientes al momento de solicitud de anulación" 
    #define STR0029 "¿Desea visualizar log de anulación?"
    #define STR0030 "Solicitud de anulación exitosa"  
	#define STR0031 "Anulación de Facturas"
    #define STR0037 "Transmitiendo Documentos..."

	Local cDesc		:= ""
	Local cFlftex	:= ""
	Local cFechTim	:= ""
	Local cHoraTim	:= ""

	Local cPergBC     := "MATA486G"
	Local aDocs       := {}
	Local aArea       := GetArea()
	Local aTamaho     := MsAdvSize()
	Local aIndx	      := {STR0020}   //"Factura + Serie"
	Local cIndx	      := aIndx[1]
	Local nOpc        := 0
	Local cBusca      := Space(TAMSX3("F2_LOJA")[1]+TAMSX3("F2_CLIENTE")[1]+TAMSX3("F2_DOC")[1]+TAMSX3("F2_SERIE")[1])
	Local oOkS        := LoadBitmap(GetResources(),"br_verde")//disponible para anular
	Local oNoS        := LoadBitmap(GetResources(),"br_vermelho")//Anulación Rechazada
	Local oOkP        := LoadBitmap(GetResources(),"br_pink")//Anulación Pendiente
	Local oOk	      := LoadBitmap(GetResources(),"LBOK")
	Local oNo	      := LoadBitmap(GetResources(),"LBNO")
	Local oDlgFat     := Nil
	Local bSet15	  := {|| U_VALGENBOL(oLbx1,oDlgFat,@nOpc,aDocs)}
	Local bSet24	  := {|| nOpc:=0, oDlgFat:End()}
	Local aButtons    := {{"S4WB011N", {|| LeyendaCB()}, STR0019, STR0019}} //"Leyenda"
	Local bDialogInit := { || EnchoiceBar(oDlgFat,bSet15,bSet24,nil,aButtons)}
	Local nX          := 0
	Local nPosLbx     := 0
	Local aFact       := {}
	Local oBoton      := Nil
	Local oBusca      := Nil
	Local oMarTodos   := Nil
	Local oDesTodos   := Nil
	Local oInvSelec   := Nil
	Local cMsgLog     := ""	
	Local aError      := {}	
	Local aTrans	  := {}							
    Local nArch 
    Local lRet		  := .T.
    // Local cNomArc	  :=""
    Local aDocsA      := {}
	Local cPath		  := &(SuperGetMV("MV_CFDDOCS",,"")) 
	Local cRutaSMR	  := &(SuperGetMV("MV_CFDSMAR",,""))//ruta donde reside el cliente de WS 
	Local n 		  := 0
	Local cProvFE	  := SuperGetMV("MV_PROVFE",,"")
	private aRetObs	  := {}	
	Private aCabsSF1  := {}
	Private aCabsSF2  := {}
	Private aItensSD1 := {}
	Private aItensSD2 := {}
		
	If nTDTras = 1 .Or. nTDTras = 4 //Factura/Boleta de Venta
		cTipo := "N"
	ElseIf nTDTras = 2 //Nota de Débito
		cTipo := "D"
	ElseIf nTDTras = 3 //Nota de Crédito
		cTipo := "C"
	EndIf
	
	If Pergunte(cPergBC,.T.)

		cToken	:= U_VulcanTkn()

		aDocs := U_M486SFANU(MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04)
		
		If Len(aDocs) == 0
			Aviso(STR0014,STR0015,{STR0016})// "Anulación", "No se encontraron facturas para anular, revise los parametros de selección", {"Ok"}
			Return Nil
		Else	
			M486SX3(@aCabsSF1, @aCabsSF2, @aItensSD1, @aItensSD2)
			DEFINE MSDIALOG oDlgFat FROM aTamaho[1],aTamaho[2] TO aTamaho[6],aTamaho[5] TITLE STR0017 PIXEL   //"Anulacción de Facturas"
		
			@ c(30),c(05) MSCOMBOBOX oIndx VAR cIndx ITEMS aIndx SIZE c(90),c(10) PIXEL OF oDlgFat
			@ c(30),c(98) BUTTON oBoton PROMPT STR0018 SIZE c(35),c(10) ; //"Buscar"
					 ACTION (oLbx1:nAT := M486BusBol(oLbx1,aDocs,cBusca,oIndx:nAT), ;
							oLbx1:bLine := {|| {If(aDocs[oLbx1:nAt,11] == "6",oOkS,If(aDocs[oLbx1:nAt,11]=="9",oNoS,oOkP)),If(aDocs[oLbx1:nAt,2],oOk,oNo),aDocs[oLbx1:nAt,3],aDocs[oLbx1:nAt,4],;
							aDocs[oLbx1:nAt,5],aDocs[oLbx1:nAt,6],aDocs[oLbx1:nAt,7],aDocs[oLbx1:nAt,8],aDocs[oLbx1:nAt,9]}},;
							oLbx1:SetFocus()) PIXEL OF oDlgFat
			@ c(42),c(05)  MSGET oBusca VAR cBusca PICTURE "@!" SIZE c(130),c(10) PIXEL  OF oDlgFat
			@ c(58),c(05)  LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER ;
							OemToAnsi(""),;     //Status
							OemToAnsi(""),;     //Check
							STR0007,;           //serie
							STR0021,;    		//Documento
							STR0022,;			//Fecha de emisión
							STR0023,;			//Fecha de autorización (SUNAT)
							STR0009,;	        //"Tienda"
							STR0008,;	        //"Cliente"
							STR0024;	        //"Nombre"   
			          SIZE aTamaho[3] - 25,IIf(aTamaho[6]>700,(aTamaho[4] * .775)-25, IIf(aTamaho[6]<500,aTamaho[4] * .6,aTamaho[4] * .7)) OF oDlgFat ; //aTamaho[6] * .875
			          PIXEL ON DBLCLICK ( IIf(aDocs[oLbx1:nAt,1] ;			          
			          .And. (IIf(aDocs[oLbx1:nAt,10]$"NF|NDC",MaCanDelF2("SF2",aDocs[oLbx1:nAt,12],,,,aDocs[oLbx1:nAt,13]),LxMaCanDelF1(aDocs[oLbx1:nAt,12],,,,,,.F.,aDocs[oLbx1:nAt,13]))), ;
			          (M486MrcBol(oLbx1,@aDocs,@oDlgFat),oLbx1:nColPos:= 1,oLbx1:Refresh()), ) ) NOSCROLL
			oLbx1:SetArray(aDocs)
			oLbx1:bLine := {|| {If(aDocs[oLbx1:nAt,11] == "6",oOkS,If(aDocs[oLbx1:nAt,11]=="9",oNoS,oOkP)),If(aDocs[oLbx1:nAt,2],oOk,oNo),aDocs[oLbx1:nAt,3],aDocs[oLbx1:nAt,4],;
							aDocs[oLbx1:nAt,5],aDocs[oLbx1:nAt,6],aDocs[oLbx1:nAt,7],aDocs[oLbx1:nAt,8],aDocs[oLbx1:nAt,9]}}
			oLbx1:Refresh()
		
			@ aTamaho[4] * .953,c(005) BUTTON oMarTodos PROMPT STR0025 SIZE c(45),c(10) ACTION M486MarcaI( oLbx1 , @aDocs , @oDlgFat , "M" ) PIXEL OF oDlgFat //aTamaho[4] * .92 //"Marcar Todos"
			@ aTamaho[4] * .953,c(055) BUTTON oDesTodos PROMPT STR0026 SIZE c(45),c(10) ACTION M486MarcaI( oLbx1 , @aDocs , @oDlgFat , "D" ) PIXEL OF oDlgFat //"Desmarcar Todos"
			@ aTamaho[4] * .953,c(110) BUTTON oInvSelec PROMPT STR0027 SIZE c(45),c(10) ACTION M486MarcaI( oLbx1 , @aDocs , @oDlgFat , "I" ) PIXEL OF oDlgFat //"Invierte selección"
		
			ACTIVATE MSDIALOG oDlgFat ON INIT Eval(bDialogInit) CENTERED
		
			CursorWait()
		
			If  nOpc == 1
				If "VULCAN" $ cProvFE					
					nTotDoc := Len(aDocs)
					For nX := 1 To nTotDoc
						If aDocs[nX][2] //Seleccionado							
							// cFlftex := aDocs[nX][11] // (cToken, cExternId, 										aError,  cFil, 			cFactura, 	cSerie, 		cCliente, 	cLoja, 		cEspecie, 	cDesc, 	cFlftex, cFechTim, 	cHoraTim)
							cStatus := U_VulcanCkIn(cToken, AllTrim(aDocs[nX][3]) + AllTrim(aDocs[nX][4]), @aError, aDocs[nX][14],aDocs[nX][4], aDocs[nX][3], aDocs[nX][8], aDocs[nX][7], cEspecie, @cDesc, cFlftex, @cFechTim, @cHoraTim)
							//cStatus := U_VulcanCkIn(cToken, AllTrim(aDocs[nX][2]) + AllTrim(aDocs[nX][3]), @aRetObs, aDocs[nX][1],aDocs[nX][3], aDocs[nX][2], aDocs[nX][4], aDocs[nX][5], cEspecie, @cDesc, cFlftex, @cFechTim, @cHoraTim)
							alert(cStatus)
							If cStatus == "8"	// oObj:INVOICESTATE == "CANCELED"								
								U_CompletaAnul(aDocs[nX][17], aDocs[nX][18], @aError, @aTrans, aDocs[nX][14],aDocs[nX][4], aDocs[nX][3], aDocs[nX][8], aDocs[nX][7],cESpecie)
							else
								//if !VulVerifAnu(aDocs[nX][17], aDocs[nX][18], @aError, @aTrans, aDocs[nX][14],aDocs[nX][4], aDocs[nX][3], aDocs[nX][8], aDocs[nX][7],cESpecie)							
								VulcanCaIn(aDocs[nX][17], aDocs[nX][18], @aError, @aTrans, aDocs[nX][14],aDocs[nX][4], aDocs[nX][3], aDocs[nX][8], aDocs[nX][7],cESpecie)
							EndIf
						EndIf
					Next nX
				/*Else
					nArch:= FCREATE(cPath + "listaxmlA.ini")
					If nArch != -1
						fwrite(nArch, '[XML]' + chr(13)+ Chr(10))
						nTotDoc := Len(aDocs)
						For nX := 1 To nTotDoc
							If aDocs[nX][2] //Seleccionado
								aAdd(aFact,{aDocs[nX][3], aDocs[nX][4], aDocs[nX][7], aDocs[nX][8], aDocs[nX][5], aDocs[nX][14], .F., ""})
								AADD(aDocsA,{aDocs[nX,3],aDocs[nX,4],aDocs[nX,8],aDocs[nX,7],aDocs[nX,16],aDocs[nX,14],.F.,"",} ) 
								fwrite(nArch, alltrim(aDocs[nX,3]) + "|" +  alltrim(aDocs[nX,4]) + "|" + alltrim(aDocs[nX,15]) + "|" + alltrim(aDocs[nX,16]) + "|" + alltrim(aDocs[nX,17]) + "|" + alltrim(MV_PAR04) + "|" + alltrim(aDocs[nX,18]) + chr(13)+ Chr(10))
							EndIf
						Next nX		
					EndIf
					fclose(nArch)
					//Copia el archivo listaxml.ini del servidor a la ruta del smartclient 
					CpyS2T(cPath + "listaxmlA.ini", cRUTASMR)
					//ejecuta .exe para consumir servicios web de anulación
					Processa({|lEnd| lRet := M486XFUNBOL(aDocsA,@aError,@aTrans,"C", @aRetObs)},STR0037) //"Transmitiendo Documentos..."	*/
				EndIf
			EndIf
			
			If Len(aError) > 0 .And. Len(aTrans) <> Len(aError)
				cMsgLog := STR0028  + cCRLF + STR0029 // "Ocurrieron inconvenientes al momento de solicitud de anulación" // "¿Desea visualizar log de anulación?"
			ElseIf Len(aError) > 0 .And. Len(aTrans) == Len(aError)
				cMsgLog := STR0030 + cCRLF + STR0029// "Solicitud de anulación exitosa"  // "¿Desea visualizar log de anulación?"
			EndIf
			
			nDetalle := Len(aRetObs)
			If nDetalle > 0
				for n:= 1 to nDetalle
					AADD(aError,{aRetObs[n][1], aRetObs[n][2], aRetObs[n][3], aRetObs[n][4], aRetObs[n][5]})
				next
			EndIf

			If !Empty(cMsgLog)
				If MsgYESNO(cMsgLog) 
					M486GENLOG(aError, nTotDoc, Len(aTrans))				
				EndIf
			EndIf
		
			DeleteObject(oOk)
			DeleteObject(oNo)
			DeleteObject(oOkS)
			DeleteObject(oNoS)
			DeleteObject(oOkP)
		
			CursorArrow()
			bFiltraBrw := {|| FilBrowse(cAliasB,@aIndArqE,@cFiltro) }
			Eval(bFiltraBrw)	

			CursorArrow()
			RestArea(aArea)		
		EndIf
	EndIf
Return

/*/{Protheus.doc} VulcanCaIn
Realiza la solicitud de cancelación de una factura.
@type function
@author Omar Delgadillo
@since 06/2025
@version 1.0
@param cCUF,	    string, 	Identificador de la factura. Codigo unico de facturación
@param cDesc,		string, 	Razón por la cual se realiza la cancelación de la factura.
@param aError,		array, 		Arreglo con errores de la transmisión.
@param aTrans,		array, 		Arreglo con las transmisiones exitosas.
@param cFil,		Caracter, 	Filial de la factura.
@param cFactura,	Caracter, 	Número de la factura.
@param cSerie,		Caracter, 	Serie de la factura.
@param cCliente,	Caracter, 	Cliente de la factura.
@param cLoja,		Caracter, 	Loja de la factura.
@param cEspecie,	Caracter, 	Especie de la factura.
*/
/*Function VulcanCaIn(cCUF, cCodDesc, aError, aTrans, cFil, cFactura, cSerie, cCliente, cLoja, cEspecie)
Local cURL			:= SuperGetMV("MV_WSRTSS",,"")
Local aHeader		:= {}
Local oRest			:= Nil
Local OOBJ			:= Nil
Local cToken		:= ""
Local cJSON			:= ""
Local aFieldErro	:= {}
Local nI			:= 0
Local cMsg			:= ""
Local lOK			:= .F.
Local aArea			:= GetArea()
Local aAreaSF		:= {}
Local cEndPoint		:= ""
Local cTypeUrl		:= ""

Default cCUF		:= ""
Default cCodDesc	:= ""
Default cEspecie	:= ""


	If !Empty(cCUF)

		cToken	:= VulcanTkn()

		cJSON	:= '{'
		cJSON	+=	'"cuf": "' + AllTrim(cCUF) + '", '
		cDesc	:= ObtColSAT('S016',Alltrim(cCodDesc),1,4,5,50)
		cJSON	+=	'"reason": "' + cDesc + '"'
		cJSON	+= '}'

		oRest := FWRest():New(cUrl)
		aAdd(aHeader, "Content-Type: application/json")
		aAdd(aHeader, "Authorization: Bearer " + cToken)
		If AllTrim(cEspecie) $ "NF"
			cEndPoint := "/msinvoice/api/integrations/cancel"
			cTypeUrl  := "Cancelacion"
		Else
			cEndPoint := "/msinvoice/api/integrations/cancel-create-debit"
			cTypeUrl  := "Cancelacion-credito-debito"
		EndIf

		cEndPoint := ChckUrlV(cTypeUrl, cEndPoint)
		
		oRest:SetPath(cEndPoint)
		oRest:SetPostParams(cJson)

		lRest := oRest:Post(aHeader)
	
		If FWJsonDeserialize(oRest:GetResult(),@oObj)
			If oObj <> Nil
				
				If !lRest
					If AttIsMemberOf(oObj,"FIELDERRORS")
						aFieldErro := oObj:FIELDERRORS
						For nI := 1 To Len(aFieldErro)
							aAdd(aError, {cSerie, cFactura, cCliente, cLoja, aFieldErro[nI]:FIELD + ": " + aFieldErro[nI]:MESSAGE })
						Next nI
					Else
						If AttIsMemberOf(oObj,"TITLE")
							cMsg += oObj:TITLE + ": "
						EndIf
						If AttIsMemberOf(oObj,"DETAIL")
							cMsg += oObj:DETAIL
						ElseIf AttIsMemberOf(oObj,"ERRORKEY")
							cMsg += oObj:ERRORKEY
						ElseIf AttIsMemberOf(oObj,"MESSAGE")
							cMsg += oObj:MESSAGE
						EndIf
						If !Empty(cMsg)
							aAdd(aError, {cSerie, cFactura ,cCliente, cLoja, cMsg })
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf AttIsMemberOf(oRest,"ORESPONSEH")

			If AttIsMemberOf(oRest:ORESPONSEH, "CSTATUSCODE")
				
				If oRest:ORESPONSEH:CSTATUSCODE == "200"
					If Alltrim(cEspecie) $ "NCI|NCC"
						aAreaSF := SF1->(GetArea())
						DbSelectArea("SF1")
						DbSetOrder(1)//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO 
						lOK := MsSeek(xFilial("SF1")+cFactura+cSerie+cCliente+cLoja)
					Else
						aAreaSF := SF2->(GetArea())
						DbSelectArea("SF2")
						DbSetOrder(1)//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
						lOK := MsSeek(xFilial("SF2")+cFactura+cSerie+cCliente+cLoja)
					EndIf
					If lOK
						V486UPDST("8", cEspecie,,,,dDatabase)
						M486BOAUTO(cEspecie)
					EndIf
					aAdd(aTrans, {cFil,cSerie,cFactura,cCliente,cLoja, STR0055 + cCUF + STR0056})
					aAdd(aError, {cSerie, cFactura, cCliente, cLoja, STR0055 + cCUF + STR0056})
				Else
					cMsg += oRest:ORESPONSEH:CSTATUSCODE +  ": "

					If AttIsMemberOf(oRest:ORESPONSEH, "CREASON")
						cMsg += oRest:ORESPONSEH:CREASON
					EndIf
					If !Empty(cMsg)
						aAdd(aError, {cSerie, cFactura, cCliente, cLoja, cMsg })
					EndIf
				EndIf
			EndIf
		EndIf
		oRest:= Nil
	EndIf

	If Len(aAreaSF) > 0 
		RestArea(aAreaSF)
	EndIf
	RestArea(aArea)

Return*/


/*/{Protheus.doc} VulVerifAnu
Verificar si la factura ya está anulada en SIAT/Vulcan.
@type function
@author Omar Delgadillo
@since 06/2025
@version 1.0
@param cCUF,	    string, 	Identificador de la factura. Codigo unico de facturación
@param cDesc,		string, 	Razón por la cual se realiza la cancelación de la factura.
@param aError,		array, 		Arreglo con errores de la transmisión.
@param aTrans,		array, 		Arreglo con las transmisiones exitosas.
@param cFil,		Caracter, 	Filial de la factura.
@param cFactura,	Caracter, 	Número de la factura.
@param cSerie,		Caracter, 	Serie de la factura.
@param cCliente,	Caracter, 	Cliente de la factura.
@param cLoja,		Caracter, 	Loja de la factura.
@param cEspecie,	Caracter, 	Especie de la factura.
*/
/*Function VulVerifAnu(cCUF, cCodDesc, aError, aTrans, cFil, cFactura, cSerie, cCliente, cLoja, cEspecie)
Local cURL			:= SuperGetMV("MV_WSRTSS",,"")
Local aHeader		:= {}
Local oRest			:= Nil
Local OOBJ			:= Nil
Local cToken		:= ""
Local cJSON			:= ""
Local aFieldErro	:= {}
Local nI			:= 0
Local cMsg			:= ""
Local lOK			:= .F.
Local aArea			:= GetArea()
Local aAreaSF		:= {}
Local cEndPoint		:= ""
Local cTypeUrl		:= ""

Default cCUF		:= ""
Default cCodDesc	:= ""
Default cEspecie	:= ""


	If !Empty(cCUF)

		cToken	:= VulcanTkn()

		cJSON	:= '{'
		cJSON	+=	'"cuf": "' + AllTrim(cCUF) + '", '
		cJSON	+=	'"checkSiat": "true", '
  		cJSON	+=	'"invoiceType": "GENERIC"
		cJSON	+= '}'

		oRest := FWRest():New(cUrl)
		aAdd(aHeader, "Content-Type: application/json")
		aAdd(aHeader, "Authorization: Bearer " + cToken)
		If AllTrim(cEspecie) $ "NF"
			cEndPoint := "/msinvoice/api/integrations/invoice-status"
			cTypeUrl  := "Cancelacion"
		Else
			//cEndPoint := "/msinvoice/api/integrations/cancel-create-debit"
			//cTypeUrl  := "Cancelacion-credito-debito"
		EndIf

		cEndPoint := ChckUrlV(cTypeUrl, cEndPoint)
		
		oRest:SetPath(cEndPoint)
		oRest:SetPostParams(cJson)

		lRest := oRest:Post(aHeader)
	
		If FWJsonDeserialize(oRest:GetResult(),@oObj)
			If oObj <> Nil
				
				If !lRest
					If AttIsMemberOf(oObj,"FIELDERRORS")
						aFieldErro := oObj:FIELDERRORS
						For nI := 1 To Len(aFieldErro)
							aAdd(aError, {cSerie, cFactura, cCliente, cLoja, aFieldErro[nI]:FIELD + ": " + aFieldErro[nI]:MESSAGE })
						Next nI
					Else
						If AttIsMemberOf(oObj,"TITLE")
							cMsg += oObj:TITLE + ": "
						EndIf
						If AttIsMemberOf(oObj,"DETAIL")
							cMsg += oObj:DETAIL
						ElseIf AttIsMemberOf(oObj,"ERRORKEY")
							cMsg += oObj:ERRORKEY
						ElseIf AttIsMemberOf(oObj,"MESSAGE")
							cMsg += oObj:MESSAGE
						EndIf
						If !Empty(cMsg)
							aAdd(aError, {cSerie, cFactura ,cCliente, cLoja, cMsg })
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf AttIsMemberOf(oRest,"ORESPONSEH")

			If AttIsMemberOf(oRest:ORESPONSEH, "CSTATUSCODE")
				
				If oRest:ORESPONSEH:CSTATUSCODE == "200"				
					If Alltrim(cEspecie) $ "NF"
						If AttIsMemberOf(oObj,"INVOICESTATE")
							cMsg += oObj:INVOICESTATE
						EndIf

						aAreaSF := SF2->(GetArea())
						DbSelectArea("SF2")
						DbSetOrder(1)//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
						lOK := MsSeek(xFilial("SF2")+cFactura+cSerie+cCliente+cLoja)
					//ELSE	// Alltrim(cEspecie) $ "NCI|NCC"
					EndIf

					If lOK
						V486UPDST("8", cEspecie,,,,dDatabase)
						M486BOAUTO(cEspecie)
					EndIf
					aAdd(aTrans, {cFil,cSerie,cFactura,cCliente,cLoja, STR0055 + cCUF + STR0056})
					//aAdd(aError, {cSerie, cFactura, cCliente, cLoja, STR0055 + cCUF + STR0056})
				Else
					cMsg += oRest:ORESPONSEH:CSTATUSCODE +  ": "

					If AttIsMemberOf(oRest:ORESPONSEH, "CREASON")
						cMsg += oRest:ORESPONSEH:CREASON
					EndIf
					If !Empty(cMsg)
						aAdd(aError, {cSerie, cFactura, cCliente, cLoja, cMsg })
					EndIf
				EndIf
			EndIf
		EndIf
		oRest:= Nil
	EndIf

	If Len(aAreaSF) > 0 
		RestArea(aAreaSF)
	EndIf
	RestArea(aArea)

Return*/

/*/{Protheus.doc} VulcanCaIn
Completa la anulación en protheus, cuando ya está anulada en el SIAT.
@type function
@author Omar Delgadillo
@since 06/2025
@version 1.0
@param cCUF,	    string, 	Identificador de la factura. Codigo unico de facturación
@param cDesc,		string, 	Razón por la cual se realiza la cancelación de la factura.
@param aError,		array, 		Arreglo con errores de la transmisión.
@param aTrans,		array, 		Arreglo con las transmisiones exitosas.
@param cFil,		Caracter, 	Filial de la factura.
@param cFactura,	Caracter, 	Número de la factura.
@param cSerie,		Caracter, 	Serie de la factura.
@param cCliente,	Caracter, 	Cliente de la factura.
@param cLoja,		Caracter, 	Loja de la factura.
@param cEspecie,	Caracter, 	Especie de la factura.
*/

User Function CompletaAnul(cCUF, cCodDesc, aError, aTrans, cFil, cFactura, cSerie, cCliente, cLoja, cEspecie)
	V486UPDST("8", cEspecie,,,,dDatabase)
	M486BOAUTO(cEspecie)
return

// ***************** 
// Copia de original 
// ***************** 

/*/{Protheus.doc} M486SFANU
//Carga datos a ser mostrados para anulaciónd e documentos electrónicos.
@author Alfredo Medrano
@since 26/11/2019
@version 1.0
@return Nil
@type function
/*/
User Function M486SFANU(cSerie, cDocIni, cDocFin, cMotivo)
	Local cAliasTmp := GetNextAlias() 
	Local cEsp      := ""
	Local cCampos   := ""
	Local cTablas   := ""
	Local cCond     := ""
	// Local cCondFB   := ""
	Local cOrder    := ""
	Local aFacturas := {}
	Local nReg 		:= 0
	Local cRutina   := ""

	If nTDTras == 1 .Or. nTDTras == 2 .Or. nTDTras == 4 //Factura de Venta - Nota de Débito
		cRutina := "MATA467N|MATA460"
		If nTDTras == 1 //Factura/
			cEsp := "NF"
		ElseIf nTDTras == 2 //nota de débito
			cEsp := "NDC"
			cRutina := "MATA465N"
		EndIf
		cCampos	:= "% SF2.F2_FILIAL FILIAL, SF2.F2_CLIENTE CLIENTE, SF2.F2_LOJA LOJA, SF2.F2_DOC DOC, SF2.F2_SERIE SERIE, SF2.F2_EMISSAO EMISSAO, SF2.F2_FECTIMB FECHATRANS, F2_TPDOC TIPDOC, "
		cCampos	+= "  SF2.F2_FECANTF FECHCANCEL, SA1.A1_NOME, SF2.F2_FLFTEX STATUS, SF2.F2_ESPECIE ESPECIE, SF2.R_E_C_N_O_ SFRECNO, F2_UUIDC IDANULA , F2_UUID IDTRANS, F2_CODDOC CUF, F2_NUMAUT NUMAUT %"
		cTablas := "% " + RetSqlName("SF2") + " SF2, " + RetSqlName("SA1") + " SA1 %"
		cCond	:= "% SF2.F2_FILIAL = '" + xFilial("SF2") + "'"
		cCond	+= " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
		cCond	+= " AND SF2.F2_CLIENTE = SA1.A1_COD"
		cCond	+= " AND SF2.F2_LOJA = SA1.A1_LOJA"
		cCond	+= " AND SF2.F2_ESPECIE = '" + cEsp + "'"
		cCond	+= " AND SF2.F2_SERIE = '" + cSerie + "'"
		cCond	+= " AND SF2.F2_DOC >= '" + cDocIni + "'"
		cCond	+= " AND SF2.F2_DOC <= '" + cDocFin + "'"
		cCond	+= " AND SF2.F2_FLFTEX  IN ('6','7') "
		cCond	+= " AND SF2.D_E_L_E_T_  = ' ' "
		cCond	+= " AND SA1.D_E_L_E_T_  = ' ' %"
		cOrder 	:= "% SF2.F2_SERIE, SF2.F2_DOC %"
	ElseIf nTDTras == 3 //Nota de Crédito
		cEsp    := "NCC"
		cRutina := "MATA465N"
		cCampos	:= "% SF1.F1_FILIAL FILIAL, SF1.F1_FORNECE CLIENTE, SF1.F1_LOJA LOJA, SF1.F1_DOC DOC, SF1.F1_SERIE SERIE, SF1.F1_EMISSAO EMISSAO, SF1.F1_FECTIMB FECHATRANS,F1_TIPNOTA TIPDOC, "
		cCampos	+= "  SF1.F1_FECANTF FECHCANCEL, SA1.A1_NOME, SF1.F1_FLFTEX STATUS, SF1.F1_ESPECIE ESPECIE, SF1.R_E_C_N_O_ SFRECNO, F1_UUIDC IDANULA, F1_UUID IDTRANS, F1_CODDOC CUF, F1_NUMAUT NUMAUT  %"
		cTablas := "% " + RetSqlName("SF1") + " SF1, " + RetSqlName("SA1") + " SA1 %"
		cCond	:= "% SF1.F1_FILIAL = '" + xFilial("SF1") + "'"
		cCond	+= " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
		cCond	+= " AND SF1.F1_FORNECE = SA1.A1_COD"
		cCond	+= " AND SF1.F1_LOJA = SA1.A1_LOJA"
		cCond	+= " AND SF1.F1_ESPECIE = '" + cEsp + "'"
		cCond	+= " AND SF1.F1_SERIE = '" + cSerie + "'"
		cCond	+= " AND SF1.F1_DOC >= '" + cDocIni + "'"
		cCond	+= " AND SF1.F1_DOC <= '" + cDocFin + "'"
		cCond	+= " AND SF1.F1_FLFTEX  IN ('6','7') "
		cCond	+= " AND SF1.D_E_L_E_T_  = ' ' "
		cCond	+= " AND SA1.D_E_L_E_T_  = ' ' %"
		cOrder 	:= "% SF1.F1_SERIE, SF1.F1_DOC %"		
	EndIf

	BeginSql alias cAliasTmp
		SELECT %exp:cCampos%
		FROM  %exp:cTablas%
		WHERE %exp:cCond%
		ORDER BY %exp:cOrder%
	EndSql
	
	TCSetField(cAliasTmp,"EMISSAO","D")
	TCSetField(cAliasTmp,"FECHATRANS","D")

	Count to nReg
	
	If nReg > 0
		dbSelectArea(cAliasTmp)
		(cAliasTmp)->(dbGotop())
		
		While  (cAliasTmp)->(!EOF())
			aAdd(aFacturas,{(cAliasTmp)->STATUS $ "5|6|7", ;                    //[1]Status/ 9=anulacion Rechazada /6=disponible p/anulación/7=anulacion pendiente 
							.F., ;                                              //[2]Selección al cargar
			                (cAliasTmp)->SERIE, ;                               //[3]Serie
			                (cAliasTmp)->DOC, ;                                 //[4]Documento
							(cAliasTmp)->FECHATRANS, ;                          //[5]Fecha de emisión
							(cAliasTmp)->FECHCANCEL, ;                          //[6]Fecha de autorización SUNAT
							(cAliasTmp)->LOJA, ;                                //[7]Tienda
							(cAliasTmp)->CLIENTE, ;                             //[8]Cód. Cliente
							Alltrim((cAliasTmp)->A1_NOME), ;                    //[9]Nombre Cliente
							Alltrim((cAliasTmp)->ESPECIE), ;                    //[10]Especie
							(cAliasTmp)->STATUS, ;                              //[11]Status
							(cAliasTmp)->SFRECNO, ;                             //[12]RecNo
							cRutina, ;                                          //[13]Rutina
							(cAliasTmp)->FILIAL, ;                              //[14]Filial
							(cAliasTmp)->IDANULA,;                              //[15]ID de anulación
							(cAliasTmp)->IDTRANS,;                              //[16]ID de transmisión
							Iif(!Empty((cAliasTmp)->CUF),(cAliasTmp)->CUF,(cAliasTmp)->NUMAUT),;                                   //[17]CUF
							(cAliasTmp)->TIPDOC})                               //[18]Docto Sector
			(cAliasTmp)->(dbSkip())
		EndDo
		
		(cAliasTmp)->( dbCloseArea())
	EndIf
Return aFacturas

/*/{Protheus.doc} VALGENBOL
//Valida que hayan sido seleccionado al menos un documento para anular.
@author Alfredo Medrano
@since 26/11/2019
@version 1.0
@return Nil
@type function
/*/
User Function VALGENBOL(oLbx1, oDlgFat, nOpc, aItems)
	Local lRet  := .F.
	Local nPos  := 0
	
	nPos := aScan(aItems, {|aVal| aVal[2] == .T.} )
	If  nPos>0
		lRet := .T.
		nOpc := 1
		oDlgFat:End()
	Else
		Aviso(STR0017, STR0031 ,{STR0016}) //"Anulación de Facturas" //"Es necesario selecionar al menos una factura." //"Ok"
	EndIf
Return lRet

/*/{Protheus.doc} VulcanTkn
Realiza la solicitud del token para los webservices de Vulcan
@type function
@author raul.medina
@since 10/2021
@version 1.0
*/

User Function VulcanTkn()
Local lRest			:= .F.
Local cURL			:= SuperGetMV("MV_WSRTSS",,"")
Local cMVCFDIUS  	:= SuperGetMV("MV_CFDI_US",,"")
Local cMVCFDICO   	:= SuperGetMV("MV_CFDI_CO",,"")
Local aHeader		:= {}
Local oRest			:= Nil
Local oObj	 		:= Nil
Local cJson			:= ""
Local cToken		:= ""
Local cEndPoint		:= "/gateway/api/authenticate"

	oRest := FWRest():New(cUrl)
	aAdd(aHeader, "Content-Type: application/json")

	cJson	:= '{'
	cJson	+= 		'"username" : "' + cMVCFDIUS + '",'
	cJson	+= 		'"password" : "' + cMVCFDICO + '",'
	cJson	+= 		'"rememberMe" : "false"'
	cJson	+= '}'

	// cEndPoint := ChckUrlV("authenticate", cEndPoint)
	oRest:setPath(cEndPoint)
	oRest:SetPostParams(cJson)

	lRest := oRest:Post(aHeader)

	If FWJsonDeserialize(oRest:GetResult(),@oObj)
		If oObj <> Nil
			If lRest
				If AttIsMemberOf(oObj,"id_token")
					cToken := oObj:id_token
				EndIf
			EndIf
		EndIf
	EndIF

	oRest:= Nil

Return cToken

/*/{Protheus.doc} VulcanCkIn
Verifica el estatus de la factura.
@type function
@author raul.medina
@since 10/2021
@version 1.0
@param cToken,string, Token de conexión.
@param cExternId,string, Identificador de la factura.
@param aError,Array, Identificador de la factura.
@param cFil,		Caracter, 	Filial de la factura.
@param cFactura,	Caracter, 	Número de la factura.
@param cSerie,		Caracter, 	Serie de la factura.
@param cCliente,	Caracter, 	Cliente de la factura.
@param cLoja,		Caracter, 	Loja de la factura.
@param cEspecie,	Caracter, 	Especie de la factura.
@param cDesc,		Caracter, 	Descripción del estatus.
@param cFlftex,		Caracter, 	Status actual de la factura.
*/
User Function VulcanCkIn(cToken, cExternId, aError, cFil, cFactura, cSerie, cCliente, cLoja, cEspecie, cDesc, cFlftex, cFechTim, cHoraTim)
Local cURL			:= SuperGetMV("MV_WSRTSS",,"")
Local aHeader		:= {}
Local oRest			:= Nil
Local oObj			:= Nil
Local cJson			:= ""
Local cMsg			:= ""
Local nI			:= 0
Local cStatus		:= ""
Local cEndPoint		:= "/msinvoice/api/integrations/invoice-status"

Default cToken		:= ""
Default cExternId	:= ""
Default aError		:= ""

	cDesc := ""
	If !Empty(cExternId)

		cJson	:= '{'
		cJson	+= 		'"externalId" : "' + cExternId + '"'
		cJson	+= '}'

		oRest := FWRest():New(cUrl)
		aAdd(aHeader, "Content-Type: application/json")
		aAdd(aHeader, "Authorization: Bearer " + cToken)

		// cEndPoint := ChckUrlV("Status", cEndPoint)
		oRest:setPath(cEndPoint)
		oRest:SetPostParams(cJson)

		lRest := oRest:Post(aHeader)

		If FWJsonDeserialize(oRest:GetResult(),@oObj)
			If oObj <> Nil
				If lRest
					If AttIsMemberOf(oObj,"INVOICESTATE")
						//0=No Enviado; 1=Enviado; 4=Esperando procesamiento; 5=Rechazado; 6=Autorizado; 7=Anulación Pendiente; 8=Anulación Confirmada    
						If oObj:INVOICESTATE == "VALIDATED"
							cStatus := "6"
						Elseif oObj:INVOICESTATE == "PENDING"
							If cFlftex == "4"
								cStatus := "4"
							ElseIf cFlftex == "7"
								cStatus := "7"
							EndIf
						ElseIf oObj:INVOICESTATE == "CANCELED"
							cStatus := "8"
						ElseIf oObj:INVOICESTATE == "REJECTED"
							cStatus := "5"
						EndIf
						cDesc := oObj:INVOICESTATE
						If AttIsMemberOf(oObj,"EMISSIONDATE")
							cFechTim := Substr(oObj:EMISSIONDATE,1,10)
							cFechTim := STRTRAN(cFechTim,"-","")
							cFechTim := SToD(cFechTim)
							cHoraTim := Substr(oObj:EMISSIONDATE,12)
						EndIf
					EndIf
					aAdd(aError, {cSerie, cFactura ,cCliente, cLoja, cDesc })
				Else
					
					If AttIsMemberOf(oObj,"FIELDERRORS")
						aFieldErro := oObj:FIELDERRORS
						For nI := 1 To Len(aFieldErro)
							aAdd(aError, {cSerie, cFactura, cCliente, cLoja, aFieldErro[nI]:FIELD + ": " + aFieldErro[nI]:MESSAGE })
						Next nI
					Else
						If AttIsMemberOf(oObj,"TITLE")
							cMsg += oObj:TITLE + ": "
							cDesc := oObj:TITLE 
						EndIf
						If AttIsMemberOf(oObj,"DETAIL")
							cMsg += oObj:DETAIL
						ElseIf AttIsMemberOf(oObj,"ERRORKEY")
							cMsg += oObj:ERRORKEY
						ElseIf AttIsMemberOf(oObj,"MESSAGE")
							cMsg += oObj:MESSAGE
						EndIf
						If !Empty(cMsg)
							aAdd(aError, {cSerie, cFactura ,cCliente, cLoja, cMsg })
						EndIf
					EndIf
				EndIf
			ElseIf AttIsMemberOf(oRest,"ORESPONSEH")
				If AttIsMemberOf(oRest:ORESPONSEH, "CSTATUSCODE")
					cMsg += oRest:ORESPONSEH:CSTATUSCODE +  ": "

					If AttIsMemberOf(oRest:ORESPONSEH, "CREASON")
						cMsg += oRest:ORESPONSEH:CREASON
						cDesc := oRest:ORESPONSEH:CREASON
					EndIf
					If !Empty(cMsg)
						aAdd(aError, {cSerie, cFactura, cCliente, cLoja, cMsg })
					EndIf
				EndIf
			EndIf
		EndIf
		oRest:= Nil
	EndIf

Return cStatus
