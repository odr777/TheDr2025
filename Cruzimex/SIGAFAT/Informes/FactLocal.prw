#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ FactLocal x GFATI301 ³Denar Terrazas/Erick Etcheverry	 º Data ³ 03/08/18º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emision de Factura de salida con Codigo QR                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Emision de facturas de Salida Nacional                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP11BIB					query: Erick Etcheverry           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FactLocal(cxNro1,cxNro2,cxSerie,nLinInicial)
	FatLocal('Factura De Salida Local',.F.,cxNro1,cxNro2,cxSerie,nLinInicial)
Return nil

Static function FatLocal(cTitulo,bImprimir,cNroFat1,cNroFat2,cSerie,nLinInicial)
	Private oPrn    := NIL
	Private oFont10  := NIL
	Private nTotPags := 1
	private oDelete := delFiles():new()
	private nDespesa // nahim Terrazas 18/04/2019
	private lDespesUsada := .T. // nahim Terrazas 22/04/2019
	
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetCurrentPrinterInUse()
	oPrn:SetPortrait()
	oPrn:setPaperSize(DMPAPER_LETTER)

	DEFINE FONT oFont08 NAME "Arial" SIZE 0,08 OF oPrn
	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 OF oPrn
	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oFont10N NAME "Arial" SIZE 0,10 Bold  OF oPrn
	DEFINE FONT oFont105N NAME "Arial" SIZE 0,10.5 Bold  OF oPrn
	DEFINE FONT oFont11N NAME "Arial" SIZE 0,11 Bold  OF oPrn
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
	DEFINE FONT oFont12N NAME "Arial" SIZE 0,12 Bold  OF oPrn
	DEFINE FONT oFont40N NAME "Arial" SIZE 0,40 OF oPrn
	FatMat(cNroFat1,cNroFat2,cSerie,cTitulo,bImprimir,1,nLinInicial) //Impresion de factura
return Nil

static function FatMat(cDoc1,cDoc2,cSerie,cTitulo,bImprimir,nCopia,nLinInicial)
	Local aDupla   := {}
	Local aDetalle := {}
	Local nCantReg := 0
	Local bSw	   := .T.
	Local cMsgFat  := ""
	Local NextArea := GetNextAlias()
	Local cDireccion := ""
	Local cTelefono := ""
	Local cFilFact := ""
	LOCAL cPedid := ""
	local aDados
	local i

	Local cSql	:= "SELECT A1_UNITFAC,A1_UNOMFAC,F2_FILIAL,F2_REFTAXA,F2_REFMOED,F2_SERIE,F2_DOC,F2_NUMAUT,F2_EMISSAO,F2_UNOMCLI,F2_UNITCLI,F2_COND,F2_VALFAT,ROUND(F2_DESCONT,2) F2_DESCONT,F2_BASIMP1,F2_CODCTR,FP_DTAVAL,F2_USRREG,D2_PEDIDO,A1_MUN, A1_BAIRRO,A1_END"
	cSql		:= cSql+",F2_CLIENTE,F2_LOJA,F2_ESPECIE,F2_VEND1,D2_REMITO,D2_SERIREM,D2_CLIENTE,D2_COD,D2_ITEM,D2_FILIAL,D2_LOJA "
	cSql		:= cSql+" FROM " + RetSqlName("SF2 ") +" SF2 JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F2_CLIENTE AND (F2_DOC BETWEEN '"+cDoc1+"' AND '"+cDoc2+ "' ) AND F2_SERIE='"+cSerie+"' AND SF2.D_E_L_E_T_ =' ' AND SA1.D_E_L_E_T_ =' ' AND A1_LOJA=F2_LOJA AND F2_ESPECIE='NF' ) "
	cSql		:= cSql+" JOIN " + RetSqlName("SD2") +" SD2 ON (D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_LOJA=F2_LOJA AND D2_ITEM='01' AND SD2.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" JOIN " + RetSqlName("SFP") +" SFP ON (FP_FILUSO=F2_FILIAL AND FP_SERIE=F2_SERIE AND SFP.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" AND F2_FILIAL='" + xFilial("SF2") + "' "
	cSql		:= cSql+" Order By F2_DOC"

//	("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	If !Empty(D2_REMITO)
		cPedid:= GETADVFVAL("SD2","D2_PEDIDO",D2_FILIAL+D2_REMITO+D2_SERIREM+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM,3,"erro")
	else
		cPedid := D2_PEDIDO
	ENDIF

	//	Alert("FactLocal - F2_NUMAUT"+F2_NUMAUT)

	if(! EMPTY(F2_NUMAUT))//No deja imprimir si el numero de autorizacion esta mal realizado
		While !Eof()
			bSw		:= .T.
			//		If (F2_UNROIMP>0)
			//			If (VldImpFat()==.F.)
			//				bSw		º:= .F.
			//				cMsgFat := cMsgFat+AllTrim(F2_DOC)+";"
			//			EndIf
			//		EndIf

			If ( bSw == .T.)
				AADD(aDupla,F2_FILIAL)		  	//1
				AADD(aDupla,F2_SERIE)           //2
				AADD(aDupla,F2_DOC)             //3
				AADD(aDupla,F2_NUMAUT)          //4
				AADD(aDupla,F2_EMISSAO)         //5
				AADD(aDupla,IIF(!EMPTY(F2_UNOMCLI),F2_UNOMCLI,A1_UNOMFAC))         //6
				AADD(aDupla,IIF(!EMPTY(F2_UNITCLI),F2_UNITCLI,A1_UNITFAC))         //7
				AADD(aDupla,F2_COND)            //8
				AADD(aDupla,F2_VALFAT)          //9
				AADD(aDupla,F2_DESCONT)         //10
				AADD(aDupla,F2_BASIMP1)  		//11
				AADD(aDupla,F2_CODCTR)          //12
				AADD(aDupla,FP_DTAVAL)          //13
				AADD(aDupla,NIL)		    //14	//	AADD(aDupla,F2_UNROIMP)		    //14
				AADD(aDupla,cPedid)		    //15
				AADD(aDupla,A1_MUN)		    	//16
				AADD(aDupla,A1_BAIRRO)		    //17
				AADD(aDupla,A1_END)		    //18	//	AADD(aDupla,A1_UDIRFAC)		    //18
				AADD(aDupla,F2_USRREG)		    //19
				AADD(aDupla,F2_CLIENTE)		    //20
				AADD(aDupla,F2_LOJA)		    //21
				AADD(aDupla,F2_ESPECIE)		    //22
				AADD(aDupla,NIL)			    //23	//	AADD(aDupla,FP_SFC)			    //23
				AADD(aDupla,NIL)			//24	//	AADD(aDupla,F2_UAUTPRC)			//24
				AADD(aDupla,F2_VEND1)			//25
				AADD(aDupla,F2_REFTAXA)			//26
				AADD(aDupla,F2_REFMOED)			//27

				aDetalle:=FatDet (F2_DOC,F2_SERIE)                	   	//Datos detalle de factura
				
				//Aviso("Array IVA",u_zArrToTxt(aDetalle, .T.),{'ok'},,,,,.t.)
				
				nCantReg := len(aDetalle)
				
				//Acumula para sacar el total de paginas Erick
				for i := 1 to nCantReg
					if nCantReg >=37
						nCantReg = nCantReg - 37
						//	alert(nCantReg)
						nTotPags ++
					endif
				next i

				cFilFact := aDupla[1]
				DbSelectArea("SM0")
				SM0->(DBSETORDER(1))
				SM0->(DbSeek(cEmpAnt+cFilFact))

				cDireccion := AllTrim(SM0->M0_ENDENT)
				cTelefono := "Telefono: "+AllTrim(SM0->M0_TEL)+If(!Empty(SM0->M0_FAX)," Fax: "+AllTrim(SM0->M0_FAX),"")

				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"ORIGINAL",cDireccion,cTelefono)    	//Imprimir Factura
				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA",cDireccion,cTelefono)	    	//Imprimir Factura
//				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA B",cDireccion,cTelefono)	    	//Imprimir Factura

				UpCntFat(aDupla[3],aDupla[2],aDupla[1],'NF')
				dbSelectArea(NextArea)
				aDupla:={}
			EndIf
			DbSkip()
		EndDo
		#IFDEF TOP
		dBCloseArea(NextArea)
		#ENDIF
		If (Len(cMsgFat)>0)
			cMsgFat	 :=SubStr(cMsgFat,1,Len(cMsgFat)-1)
			cMsgFat  :="Su Cuenta de Usuario No Esta Habilitado Para Imprimir Las Siguientes Facturas Ya Impresas:" +cMsgFat
			MsgInfo (cMsgFat)
		EndIf
		oPrn:Refresh()
		If bImprimir
			oPrn:Print()
		Else
			oPrn:Preview()
		End If

		/*Llama a la clase delFiles para que traiga los nombres a borrar Erick*/
		aDados := oDelete:getFiles()
		for i:= 1 to len(aDados)

			FERASE(aDados[i])//borra archivos

		next i

		oPrn:End()//Fin de la impresion
	ELSE
		MSGINFO("Código de Dosificación Invalido para imprimir la Factura")
	endif

return aDupla

//Private nContador := 0
static function FatImp(cTitulo,bImprimir,aMaestro,aDetalle,nLinInicial,cTipo,cDireccion,cTelefono)
	Local _nInterLin := 1020 
	Local aInfUser := pswret()
	Local nI:=0
	Local nItemFact:= 37
	Local nDim:=0
	Local _tamdesc:=80
	Local aDescTot := {}
	Local nDes1 := 0
	Local nDes2 := 0
	Local nDes3 := 0
	Local nDes4 := 0
	Local nIb
	Default nLinInicial := 0
	Private nCont := 0
	Private nContador := 0
	nDim:=len(aDetalle)

	CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	_nInterLin += nLinInicial

	For nI:=1 to nDim
		nDes1 = nDes1 + aDetalle[nI][7]
		nDes2 = nDes2 + aDetalle[nI][8]
		nDes3 = nDes3 + aDetalle[nI][9]
		nDes4 = nDes4 + aDetalle[nI][10]
	Next	
	aadd(aDescTot,nDes1)
	aadd(aDescTot,nDes2)
	aadd(aDescTot,nDes3)
	aadd(aDescTot,nDes4)
	
	For nI:=1 to nDim

		//		oPrn:Say(_nInterLin,100,aDetalle[nI][1],oFont10) //Codigo del Producto
		//		alert(nDim)
		nContador++	//edson. cuenta los item de la factura 		
		oPrn:Say(_nInterLin,110,cValtochar(nContador) ,oFont08)  //contador 		
		oPrn:Say(_nInterLin,220,memoline(aDetalle[nI][2],_tamdesc,1),oFont08)  //Descripcion
		//		oPrn:Say(_nInterLin,1330,aDetalle[nI][3],oFont10) //Lote
		oPrn:Say(_nInterLin,1330,FmtoValor(aDetalle[nI][4],10,0),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,1860,FmtoValor(aDetalle[nI][5],14,2),oFont10,,,,1)  //Precio Unitario
		oPrn:Say(_nInterLin,2240,FmtoValor(aDetalle[nI][6],14,2),oFont10,,,,1)  //Total

		/*		oPrn:Say(_nInterLin,1850,TRANSFORM(aDetalle[nI][4],"@E 99,999,999"),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,2100,TRANSFORM(aDetalle[nI][5],"@E 99,999,999.99"),oFont10) //Precio Unitario
		oPrn:Say(_nInterLin,2360,TRANSFORM(aDetalle[nI][6],"@E 999,999,999.99"),oFont10) //Total
		*/
		_nInterLin:=_nInterLin+50

		_nlindet:=mlcount(allTrim(aDetalle[nI][2]),_tamdesc)
		//_nlindet:=mlcount(aDetalle[nI][2],_tamdesc)
		//_nlindet:=noRound(len(aDetalle[nI][2])/50,0)

		If _nlindet > 1
			For nIb := 2 To  _nlindet
				//alert(memoline(aDetalle[nI][2],_tamdesc,nIb))
				oPrn:Say(_nInterLin,320,memoline(aDetalle[nI][2],_tamdesc,nIb),oFont08)  //Descripcion
				_nInterLin:=_nInterLin+50
			Next nIb
		EndIf
		if nI >= nItemFact	//Valida cambio de hoja
			PieFact(nLinInicial,aMaestro,nCont,aDescTot)
			_nInterLin := 720
			CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
			_nInterLin += nLinInicial
			nItemFact := nItemFact + 37
		Endif
	Next nI
	//Aviso("Array IVA",u_zArrToTxt(aDescTot, .T.),{'ok'},,,,,.t.)
	PieFact(nLinInicial,aMaestro,nCont,aDescTot)
return

Static Function CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	Local cFecVen := ""

	nCont ++ // cuenta hojas Erick
	oPrn:StartPage()
	cFechaPed := If(!Empty(aMaestro[15]),DTOC(Posicione("SC5",1,xFilial("SC5")+aMaestro[15],"C5_EMISSAO")),"") //fecha pedido

	//oPrn:Box( nLinInicial + 100 , 1548 ,  325 , 2370 ) // cuadro nit Edson 
	//oPrn:Say(s nLinInicial + 120, 1620,"NIT: "  ,oFont12N )
	//oPrn:Say( nLinInicial + 120, 1995, AllTrim(SM0->M0_CGC) ,oFont12N )
	oPrn:Say( nLinInicial + 153, 1620,"FACTURA No: "  ,oFont11N )
	oPrn:Say( nLinInicial + 153, 1995,AllTrim(str(val(aMaestro[3]))) ,oFont12N ) //Nro Factura	
	oPrn:Say( nLinInicial + 213, 1620,"AUTORIZACION: "  ,oFont11N )
	oPrn:Say( nLinInicial + 213, 1995, aMaestro[4] ,oFont11N ) //Nro Autorizacion
	oPrn:Say( nLinInicial + 273, 1800 ,cTipo,oFont11N )


	//oPrn:Say( nLinInicial + 350, 080,cDireccion  ,oFont08 )
	//oPrn:Say( nLinInicial + 385, 080,cTelefono  ,oFont08 )

	oPrn:Say( nLinInicial + 345, 1530,"Actividad Economica: Fabricación de otros"  ,oFont10 )
	//oPrn:Say( nLinInicial + 370, 0510,"SFC - " ,oFont12N )	//oPrn:Say( nLinInicial + 370, 0510,"SFC - " + aMaestro[23] ,oFont12N )
	if nTotPags >= 2 	
		oPrn:Say( nLinInicial + 375, 1100,"Pag: "+ cvaltochar(nCont) + " de " + cvaltochar(nTotPags) ,oFont09 )
	endif
	oPrn:Say( nLinInicial + 380, 1530,"productos de plásticos (envases plásticos)"  ,oFont10 )

	//oPrn:Box( nLinInicial + 430 , 80 ,  640 , 2370 )//cuadro cliente
	//oPrn:Box( nLinInicial + 430 , 1540 ,  640 , 1540 )//cuadro pedido

	//oPrn:Say( nLinInicial + 450, 100,aMaestro[20] + "  -  " + aMaestro[21],oFont12N ) // Codigo del Cliente  //Denar
	oPrn:Say( nLinInicial + 670, 100,"Fecha...: " ,oFont12N )
	oPrn:Say( nLinInicial + 670, 290,DTOC(STOD(aMaestro[5])) ,oFont12 ) //Fecha Factura
	//oPrn:Say( nLinInicial + 450, 1200,"V: " + aMaestro[25] ,oFont12 ) //Fecha Factura
	//oPrn:Say( nLinInicial + 450, 1710,"Fecha de Pedido: " ,oFont12N )
	//oPrn:Say( nLinInicial + 450, 2120,cFechaPed ,oFont12 ) //Fecha del Pedido

	//Edson 22/03/2019 
	oPrn:Say( nLinInicial + 430, 900,"FACTURA" ,oFont40N )

	oPrn:Say( nLinInicial + 730, 100,"Nombre: " ,oFont12N )
	oPrn:Say( nLinInicial + 730, 290,aMaestro[6] ,oFont12 ) // Nombre del Cliente
	oPrn:Say( nLinInicial + 790, 1650,"Numero de Pedido: " ,oFont12N )
	oPrn:Say( nLinInicial + 790, 2120,aMaestro[15] ,oFont12 ) // Numero del Pedido
	
	/*IF aMaestro[27] == 2
		oPrn:Say( nLinInicial + 510, 1650,"T.C.: " ,oFont12N )
		oPrn:Say( nLinInicial + 510, 2120,alltrim(TRANSFORM(aMaestro[26],"@E 9,999,999,999.99")) ,oFont12 ) // TAXA
	endif*///  Edson 20/03 /2019 

	oPrn:Say( nLinInicial + 790, 100, "NIT/C.I.: " ,oFont12N )
	oPrn:Say( nLinInicial + 790, 290, aMaestro[7] ,oFont12 ) //NIT del Cliente
	//oPrn:Say( nLinInicial + 570, 1710,"Condiciones de Venta: " ,oFont12N )x
	//oPrn:Say( nLinInicial + 570, 2120,Iif(aMaestro[8]=="002","CONTADO","CREDITO") ,oFont12 ) // Numero del Pedido
	//oPrn:Box( nLinInicial + 640 , 80 ,  641 , 2370 )  // Edson 22/03/2019

	If aMaestro[8]=="002"
		cFecVen := DTOC(STOD(aMaestro[5]))
	Else
		cFecVen := FechVcto(aMaestro[1],aMaestro[3],aMaestro[2],aMaestro[20],aMaestro[21])
		If !Empty(cFecVen)
			cFecVen := DTOC(STOD(cFecVen))
		Else
			cFecVen := DTOC(STOD(aMaestro[5]))
		EndIf
	EndIf

	//oPrn:Box( nLinInicial + 640 , 80 ,  2560 , 2370 )
	//Titulos reporte
	oPrn:Say(nLinInicial + 945, 80, "ITEM" ,oFont11N )
	oPrn:Say(nLinInicial + 945, 220, "DESCRIPCION DEL PRODUCTO" ,oFont11N )
	oPrn:Say(nLinInicial + 945, 1330, "CANTIDAD" ,oFont10N )   
	oPrn:Say(nLinInicial + 945, 1635, "PRECIO UNITARIO" ,oFont11N )
	oPrn:Say(nLinInicial + 945, 2100, "SUBTOTAL" ,oFont11N )
		
//				x                 y     x      y 
	oPrn:Box( nLinInicial + 1000 , 80 ,  1000 , 2360 )  // Edson  linea superior
	oPrn:Box( nLinInicial + 2480 , 80 ,  2480 , 2360 )  // Edson  linea inferior
	//Lineas verticales
	oPrn:Box( nLinInicial + 940 , 180 ,  2480 , 180 )
	oPrn:Box( nLinInicial + 940 , 1280 ,  2480 , 1280 )
	oPrn:Box( nLinInicial + 940 , 1540 ,  2480 , 1540 )
	oPrn:Box( nLinInicial + 940 , 2010 ,  2480 , 2010 )


	// Edson 22/03/2019	
	/*cFLogo := GetSrvProfString("Startpath","") + "Logo01.bmp"
	oPrn:SayBitmap(090,80, cFLogo,200,200)
	oPrn:Say(280, 80, SM0->M0_NOME ,oFont11N )
	oPrn:Say(315, 80, "Casa Matriz" ,oFont10N )*/
	
	
Return Nil

Static Function PieFact(nLinInicial,aMaestro,nCont,aDesc)
	Local nTotGral := 0
	Local cFile := ""
	Local nLin := 00.0
	oPrn:Say( nLinInicial + 2500, 100, "Son: "+Extenso(aMaestro[11],.F.,1)+" BOLIVIANOS" ,oFont11N ) //Total  Escrito
	
	
	// -------- Edson 20/03/2019 -------- 		
	//C:\TOTVS\TotvsDeveloperStudio-11.3
	//nTotGral := Round(aMaestro[9]+aMaestro[10],2)			
	oPrn:Say(nLinInicial + 2500, 1610, "Subtotal :" ,oFont12N )
	nTotGral := Round(aMaestro[9]+aMaestro[10],2)		
	oPrn:Say(nLinInicial + 2500, 2220,FmtoValor(nTotGral,14,2) ,oFont12N,,,,1 )
	//oPrn:Say(nLinInicial + 2500, 2060, TRANSFORM(nTotGral,"@E 9,999,999,999.99") ,oFont12N ) //Total General
	// Nahim obtiene para ver si hay diferencia en los descuentos
	nTotDes :=  round(aDesc[1],2) + round(aDesc[4],2) // sumo el descuento
	if nTotDes <> 0 .and. (nTotGral - nTotDes) <> round(aMaestro[11],2) // verifico si existe diferencia en el descuento vs el final
		if aDesc[1] > 0
			aDesc[1] += nTotGral   - nTotDes - round(aMaestro[11],2)// restando la diferencia
		else
			aDesc[4] += nTotGral - nTotDes - round(aMaestro[11],2) // restando la diferencia			
		endif
	endif
	// termina ajuste
	if(aDesc[1] > 0)	
		oPrn:Say(nLinInicial + 2550, 1610, "Descuentos :" ,oFont12N )
	//oPrn:Say(Tpix(nLin+21.2), Tpix(17.0),FmtoValor(aDesc[4],14,2) ,oFont12N )
	//oPrn:Say(nLinInicial + 2550, 2220,FmtoValor(aDesc[4],14,2) ,oFont12N,,,,1 ) //Descuentos Nahim Temporal 18/04
		oPrn:Say(nLinInicial + 2550, 2220,FmtoValor(aDesc[1] ,14,2)  ,oFont12N,,,,1 ) //Descuentos Nahim Temporal 18/04
	//oPrn:Say(nLinInicial + 2550, 2060, TRANSFORM(aDesc[4],"@E 9,999,999,999.99") ,oFont12N ) //Descuentos
	end if
	
	if(aDesc[4] > 0)	
		oPrn:Say(nLinInicial + 2600, 1610, "Descuento adicional :",oFont12N )
	//oPrn:Say(Tpix(nLin+21.6), Tpix(17.0),FmtoValor(aDesc[1],14,2) ,oFont12N )
		oPrn:Say(nLinInicial + 2600, 2220,FmtoValor(aDesc[4],14,2) ,oFont12N,,,,1) //Descuentos	
	//oPrn:Say(nLinInicial + 2600, 2060, TRANSFORM(aDesc[1],"@E 9,999,999,999.99") ,oFont12N ) //desc adic	
	end if		
		
	oPrn:Say(nLinInicial + 2650, 1610, "Total Bs :",oFont12N )
	oPrn:Say(nLinInicial + 2650, 2220,FmtoValor(aMaestro[11],14,2) ,oFont12N,,,,1) //Descuentos	
	//oPrn:Say(nLinInicial + 2650, 2060, TRANSFORM(aMaestro[11],"@E 9,999,999,999.99") ,oFont12N )  //Total Bolivianos
	
	IF aMaestro[27] == 2
		oPrn:Say( nLinInicial + 2700, 1610,"T.C.: " ,oFont12N )
		oPrn:Say( nLinInicial + 2700, 1800,alltrim(TRANSFORM(aMaestro[26],"@E 9,999,999,999.99")) ,oFont12 ) // TAXA
	endif	
		
	if aMaestro[27] == 2
		//oPrn:Box( nLinInicial + 2880 , 1490 ,  2950 , 1920 )
		//oPrn:Box( nLinInicial + 2970 , 1490 ,  3040 , 1920 )
		oPrn:Say(nLinInicial + 2700, 1890, "Us. :" ,oFont12N )		
		//oPrn:Say(nLinInicial + 2700, 2060,FmtoValor(xMoeda(aMaestro[11],1,2,,2,1,aMaestro [26])), oFont12N ) //Descuentos
		oPrn:Say(nLinInicial + 2700, 2220, TRANSFORM(xMoeda(aMaestro[11],1,2,,2,1,aMaestro[26]),"@E 9,999,999,999.99") ,oFont12N,,,,1 )  //Total Bolivianos
		
	endif	
	// -------- Edson end-------- 
						
	//cuadro totales descuento y etc
	/*oPrn:Box( nLinInicial + 2630 , 590 ,  2780 , 1020 )
	oPrn:Box( nLinInicial + 2700 , 590 ,  2700 , 1020 )

	oPrn:Box( nLinInicial + 2630 , 1040 ,  2780 , 1470 )
	oPrn:Box( nLinInicial + 2700 , 1040 ,  2700 , 1470 )

	oPrn:Box( nLinInicial + 2630 , 1490 ,  2780 , 1920 )
	oPrn:Box( nLinInicial + 2700 , 1490 ,  2700 , 1920 )

	oPrn:Box( nLinInicial + 2630 , 1940 ,  2780 , 2370 )
	oPrn:Box( nLinInicial + 2700 , 1940 ,  2700 , 2370 )*/

	//oPrn:Say(nLinInicial + 2670, 0100, aMaestro[19] ,oFont12 ) //Usuario que generó la factura

	/*oPrn:Say(nLinInicial + 2640, 650, "Total General" ,oFont12N )
	oPrn:Say(nLinInicial + 2640, 1050, "Descuento adicional" ,oFont12N )
	oPrn:Say(nLinInicial + 2640, 1570, "Descuentos" ,oFont12N )
	oPrn:Say(nLinInicial + 2640, 1990, "Total Bolivianos" ,oFont12N )*/

	//nTotGral := Round(aMaestro[9]+aMaestro[10],2)
	
	//oPrn:Say(nLinInicial + 2710, 0100, Time() ,oFont12 ) //Hora en que se imprimió la factura  
	/*oPrn:Say(nLinInicial + 2710, 0640, TRANSFORM(nTotGral,"@E 9,999,999,999.99") ,oFont12N ) //Total General
	oPrn:Say(nLinInicial + 2710, 1100, TRANSFORM(aDesc[1],"@E 9,999,999,999.99") ,oFont12N ) //desc adic
	oPrn:Say(nLinInicial + 2710, 1520, TRANSFORM(aDesc[4],"@E 9,999,999,999.99") ,oFont12N ) //Descuentos
	oPrn:Say(nLinInicial + 2710, 1960, TRANSFORM(aMaestro[11],"@E 9,999,999,999.99") ,oFont12N )  //Total Bolivianos*/

	oPrn:Say(nLinInicial + 2600, 0100, "F:"+AllTrim(aMaestro[2])+"-"+AllTrim(str(val(aMaestro[3]))) ,oFont12 )  //Serie + Factura
	//oPrn:Say(nLinInicial + 2840, 0100, "USR: " + cUserName,oFont12 ) //Edson 20/03/2019
			

	oPrn:Box( nLinInicial + 2880 , 590 ,  2950 , 1470 )//control
	oPrn:Say(nLinInicial + 2890, 605, "CODIGO DE CONTROL:  "+aMaestro[12] ,oFont12N )	//Codigo Control
	oPrn:Box( nLinInicial + 2970 , 590 ,  3040 , 1470 )//fecha
	oPrn:Say(nLinInicial + 2980, 605, "Fecha Limite de Emision:  "+DTOC(STOD(aMaestro[13])) ,oFont12N )//Fecha limite emision
		

	//oPrn:Say(nLinInicial + 2980, 840, "Fecha Limite de Emision:  "+DTOC(STOD(aMaestro[13])) ,oFont12N )//Fecha limite emision

	/*oPrn:Say(nLinInicial + 3000, 100, "__________________" ,oFont12N )
	oPrn:Say(nLinInicial + 3040, 140, "Recibi Conforme" ,oFont12N )*/ // edson 20/03/2019
	oPrn:Say(nLinInicial + 3050, 085, "''ESTE DOCUMENTO FISCAL CONTRIBUYE AL DESARROLLO DE NUESTRO PAÍS. EL USO ILÍCITO ES SANCIONADO PENALMENTE''" ,oFont10N )
	oPrn:Say(nLinInicial + 3100, 100, U_GetExFis(aMaestro[2],aMaestro[1]) ,oFont08 )//obtiene la dosificacion libro fiscales

	qr := AllTrim(SM0->M0_CGC) +"|"  			                       //NIT EMPRESA
	qr += AllTrim(str(val(aMaestro[3]))) +"|" 	                       //NUMERO DE FACTURA
	qr += AllTrim(aMaestro[4]) +"|"                                    //NUMERO DE AUTORIZACION
	qr += DTOC(STOD(aMaestro[5])) +"|"                                 //FECHA DE EMISION
	qr += AllTrim(Transform(nTotGral,"@E 99,999,999,999.99")) +"|"     //MONTO TOTAL CONSIGNADO EN LA FACTURA
	qr += AllTrim(Transform(aMaestro[11],"@E 99,999,999,999.99")) +"|" //IMPORTE BASE PARA CREDITO FISCAL
	qr += AllTrim(aMaestro[12]) +"|"                                   //CODIGO DE CONTROL
	qr += AllTrim(aMaestro[7])+"|"                    			  	   //NIT DEL COMPRADOR
	qr += "0" +"|"                                                     //IMPORTE ICE/ IEHD / TASAS
	qr += "0" +"|"                                                     //IMPORTE POR VENTAS NO GRAVADAS O GRAVADAS A TASA CERO
	qr += "0" +"|"                                                     //IMPORTE NO SUJETO A CREDITO FISCAL
	qr += AllTrim(Transform(aMaestro[10],"@E 99,999,999,999.99"))       //DESCUENTOS, BONIFICACIONES Y REBAJAS OBTENIDAS

	cFile = u_TDEPQR(qr) //llama al qrtdep

	oPrn:SayBitmap(2750,0150,cFile,300,300)

	oPrn:EndPage()

	oDelete:setFile(cFile) // carga rutas de los archivos para despues borrar
Return


Static Function TPix(nTam,cBorder,cTipo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desconta area nao imprimivel (Lexmark Optra T) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cBorder == "lb"			// Left Border
		nTam := nTam - 0.40
	ElseIf cBorder == "tb" 		// Top Border
		nTam := nTam - 0.60
	EndIf

	nPix := nTam * 120

Return(nPix)

static function FatDet (cDoc,cSerie) // Datos detalle de factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT B1_COD, ISNULL (CASE WHEN LEN(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),''))=0 THEN C6_DESCRI "
	cSql				:= cSql+"ELSE ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),'') END,B1_DESC) B1_DESC, "
	cSql				:= cSql+"D2_LOTECTL,D2_DTVALID,D2_QUANT,CASE WHEN D2_PRUNIT!=0 THEN D2_PRUNIT ELSE D2_PRCVEN END D2_PRUNIT,CASE WHEN D2_PRUNIT!=0 THEN D2_QUANT*D2_PRUNIT ELSE D2_QUANT*D2_PRCVEN END D2_TOTAL, D2_PEDIDO, D2_ITEMPV , D2_DOC ,D2_FILIAL "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"LEFT JOIN "+ RetSqlName("SC6") +" SC6 ON (C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM) AND SC6.D_E_L_E_T_=' ' "
	cSql				:= cSql+"ORDER BY D2_PEDIDO,D2_ITEM"

	//Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	
	//Descuentos para 
	//getDescont(cNota,cFilla,cPed)
	cPedc5 := ""
	aDescon := {}
	
	While !Eof()
		if cPedc5 <> D2_PEDIDO
			aDescon := getDescont(D2_DOC,D2_FILIAL,D2_PEDIDO)
		endif
		cPedc5 := D2_PEDIDO
		
		cProducto	:=B1_COD
		cNombre		:=B1_DESC
		If Len(AllTrim(D2_DTVALID+D2_DTVALID))>0
			cLote       :="L:"+AllTrim(D2_LOTECTL)+" V:"+ALLTRIM(STRZERO(MONTH(STOD(D2_DTVALID)),2))+ALLTRIM("/")+ALLTRIM(STRZERO(Year(STOD(D2_DTVALID)),4))
		Else
			cLote       := ""
		EndIf
		cPedido		:=D2_PEDIDO
		cItPedido	:=D2_ITEMPV
		nCant		:=D2_QUANT
		nPrecio		:=D2_PRUNIT
		nTotal		:=Round(nCant*nPrecio,2)
				
		aPerc := getDescPerc(nCant,aDescon,nPrecio) //Descuentos		
		
		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,cLote)      //3
		AADD(aDupla,nCant)      //4
		AADD(aDupla,nPrecio)    //5
		AADD(aDupla,nTotal)     //6		
		AADD(aDupla,aPerc[1])     //7 desc 1 usados de cliente
		AADD(aDupla,aPerc[2])     //8 desc 2
		AADD(aDupla,aPerc[3])     //9 desc 3
		AADD(aDupla,aPerc[4])     //10 desc 4 usados otros
		
		AADD(aDatos,aDupla)
		DbSkip()
	end do
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
return  aDatos

Static Function UpCntFat(cNroFat,cSerie,cFilVta,cEspecie)
	Local bSw	:= .F.
	Local cSql	:= ""
	Local nSql	:= 0
	cSql	:=cSql+ "Update " + RetSqlName("SF2") +" Set "
	cSql	:=cSql+ "Where "
	cSql	:=cSql + "F2_DOC		= '"+cNroFat+"'  And "
	cSql	:=cSql + "F2_SERIE	= '"+cSerie+"' 	 And "
	cSql	:=cSql + "F2_FILIAL	= '"+cFilVta+"'	 And "
	cSql	:=cSql + "F2_ESPECIE	= '"+cEspecie+"' And "
	cSql	:=cSql + RetSqlName("SF2") +".D_E_L_E_T_ = ' ' "
	If ( nSql >=0)
		bSw:=.T.
	EndIf
Return bSw

Static Function  VldImpFat ()
	Local bSw 		:= .F.
	Local aDtsUsr	:=  &(GETMV("MV_UIMPFAC"))
	Local cUsrLocal	:= Alltrim(__CUSERID)
	Local nI		:= 0
	Local nDim		:= Len(aDtsUsr)
	For nI := 1 To  nDim
		If (aDtsUsr[nI] == cUsrLocal)
			bSw := .T.
		EndIf
	Next nI
Return bSw

Static Function FechVcto(cFil,cNroDoc,cPrefijo,cCliente,cLoja)
	Local cFechVcto := ""
	Local 	NextArea	:= GetNextAlias()

	Local cSql	:= "SELECT TOP 1 E1_VENCREA "
	cSql		:= cSql+" FROM " + RetSqlName("SE1") +" SE1 "
	cSql		:= cSql+" WHERE E1_FILIAL='"+cFil+"' AND E1_NUM='"+cNroDoc+"' AND E1_PREFIXO='"+cPrefijo+"' AND E1_CLIENTE='"+cCliente+"' AND E1_LOJA='"+cLoja+"' AND E1_SALDO <> 0 AND SE1.D_E_L_E_T_=' ' "
	cSql		:= cSql+" ORDER BY E1_PARCELA"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	cFechVcto	:= E1_VENCREA

Return cFechVcto

Static Function FmtoValor(cVal,nLen,nDec)
	Local cNewVal := ""
	If nDec == 2
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 9,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal

static Function getDescont(cNota,cFilla,cPed) //una linea debería ser
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local acNped := {}

	//Montando a Consulta... Tentem evitar o SELECT * pois isso pode travar o TOPCONN
	cQuery := " SELECT "
	cQuery += "   C5_DESC1, C5_DESC2, C5_DESC3, C5_DESC4,C5_DESPESA, "
	cQuery += "   (SELECT (SUM(C6_VALDESC) / (SUM(C6_VALOR) + SUM(C6_VALDESC))) * 100.00 C5_DESCONT FROM " + RetSQLName("SC6") + " WHERE C6_NUM = '"+ cPed +"') C5_DESCONT"
	cQuery += " FROM "
	cQuery += "   " + RetSQLName("SC5") + " SC5 "
	cQuery += " WHERE "
	//cQuery += " C5_NOTA = '"+cNota+"' AND SC5.D_E_L_E_T_ = ' ' "  // edson
	cQuery += " SC5.D_E_L_E_T_ = ' ' "  // edson
	cQuery += " and C5_FILIAL = '"+cFilla+"' AND C5_NUM = '"+ cPed +"'"
	
	cQuery := ChangeQuery(cQuery)

	//Executando consulta
	TCQuery cQuery New Alias "qrr_SC5"

	//Percorrendo os registros
	While ! qrr_SC5->(EoF())
		AADD(acNped,qrr_SC5->C5_DESC1)
		AADD(acNped,qrr_SC5->C5_DESC2)
		AADD(acNped,qrr_SC5->C5_DESC3)
		if qrr_SC5->C5_DESCONT <> 0
		AADD(acNped,qrr_SC5->C5_DESCONT)
		else
		AADD(acNped,qrr_SC5->C5_DESC4 )
		endif
		nDespesa := qrr_SC5->C5_DESPESA
		qrr_SC5->(DbSkip())
	EndDo

	qrr_SC5->(DbCloseArea())
	RestArea(aArea)

Return acNped
//nQuan cantidad aPerDes - Array de descuentos hay 4 -  nPrunit precio unitario eet
static function getDescPerc(nQuan,aPerDes,nPrunit)
	Local aDesc := {}
	Local nPrUnitari := nPrunit
	Local nTmpDesc := 0 //Descuento al precio unitario 23 - 10% = 2,3
	Local nPrUnAct := 0 //Descuento al precio unitario 23 - 10 = 20,7
	// Nahim Temporal
	
	nDestos := len(aPerDes) 
	
	While nDestos > 0
		if aPerDes[nDestos] > 0
//			alert(nPrUnitari) //23
			//alert(aPerDes[i]) //5
			nPrUnAct := nPrUnitari * (aPerDes[nDestos]/100) // 1,15
			//alert(nPrUnAct)
			nTmpDesc := nPrUnitari - nPrUnAct // 21,85
			//alert(nTmpDesc) 
			//actualiz 23 a 20,7
			nPrUnitari := nTmpDesc
			nDescont := nPrUnAct*nQuan // nahim quitando redondeo
			if lDespesUsada 
				nDescont += nDespesa
				lDespesUsada := .F.
			endif
//			nDescont := noround(nPrUnAct*nQuan,1) Nahim quitando redondeo
			
			aadd(aDesc,nDescont)
		else
			aadd(aDesc,0)
		endif
		nDestos-- 
	enddo
	
	if(nDestos == 0)// en caso de que el cliente no cuente con ningun descuento . edson 21/05/2019 
		aadd(aDesc,0)
		aadd(aDesc,0)
		aadd(aDesc,0)
		aadd(aDesc,0)
	end if
	
//	for i:=1 to len(aPerDes)
//		if aPerDes[i] > 0
////			alert(nPrUnitari) //23
//			//alert(aPerDes[i]) //5
//			nPrUnAct := nPrUnitari * (aPerDes[i]/100) // 1,15
//			//alert(nPrUnAct)
//			nTmpDesc := nPrUnitari - nPrUnAct // 21,85
//			//alert(nTmpDesc) 
//			//actualiz 23 a 20,7
//			nPrUnitari := nTmpDesc
//			nDescont := nPrUnAct*nQuan // nahim quitando redondeo
//			if lDespesUsada 
//				nDescont += nDespesa
//				lDespesUsada := .F.
//			endif
////			nDescont := noround(nPrUnAct*nQuan,1) Nahim quitando redondeo
//			
//			aadd(aDesc,nDescont)
//		else
//			aadd(aDesc,0)
//		endif
//	next i

return aDesc