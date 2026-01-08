#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
----------------------------------------------------------------------------
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------------------------------------------------------+||
|| Programa  | FactLocal  autor |   Edson             Data  | 22/11/2019  ||
||+----------------------------------------------------------------------+||
|| Descricao | Emision de Factura de salida con Codigo QR                 ||
||+----------------------------------------------------------------------+||
|| Uso       | MP12BIB      				                          	  ||
||+----------------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
----------------------------------------------------------------------------
*/

User Function FactLocal(cxNro1,cxNro2,cxSerie,nLinInicial,cxTitulo)

	FatLocal('Factura De Salida Local',.F.,cxNro1,cxNro2,cxSerie,nLinInicial,cxTitulo)

Return nil

Static function FatLocal(cTitulo,bImprimir,cNroFat1,cNroFat2,cSerie,nLinInicial,cxTitulo)
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
	DEFINE FONT oFont11 NAME "Arial" SIZE 0,11 OF oPrn
	DEFINE FONT oFont11N NAME "Arial" SIZE 0,11 Bold  OF oPrn
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
	DEFINE FONT oFont12N NAME "Arial" SIZE 0,12 Bold  OF oPrn
	DEFINE FONT oFont30N NAME "Arial" SIZE 0,30 OF oPrn
	DEFINE FONT oFont40N NAME "Arial" SIZE 0,40 OF oPrn
	FatMat(cNroFat1,cNroFat2,cSerie,cTitulo,bImprimir,1,nLinInicial,cxTitulo) //Impresion de factura
return Nil

static function FatMat(cDoc1,cDoc2,cSerie,cTitulo,bImprimir,nCopia,nLinInicial,cxTitulo)
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
	local nI
	local i
	Local cSql	:= "SELECT F2_VALBRUT,A1_CGC,A1_NOME,F2_FILIAL,F2_REFTAXA,F2_REFMOED,F2_SERIE,F2_DOC,F2_NUMAUT,F2_EMISSAO,F2_UNOME,F2_UNITCLI,F2_COND,F2_VALFAT,ROUND(F2_DESCONT,2) F2_DESCONT,F2_BASIMP1,F2_CODCTR,FP_DTAVAL,F2_USRREG,D2_PEDIDO,A1_MUN, A1_BAIRRO,A1_END"
	cSql		:= cSql+",F2_CLIENTE,F2_LOJA,F2_ESPECIE,F2_VEND1,D2_REMITO,D2_SERIREM,D2_CLIENTE,D2_COD,D2_ITEM,D2_FILIAL,D2_LOJA ,F2_MOEDA,FP_UACTIVI "
	cSql		:= cSql+" FROM " + RetSqlName("SF2 ") +" SF2 JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F2_CLIENTE AND (F2_DOC BETWEEN '"+cDoc1+"' AND '"+cDoc2+ "' ) AND F2_SERIE='"+cSerie+"' AND SF2.D_E_L_E_T_ =' ' AND SA1.D_E_L_E_T_ =' ' AND A1_LOJA=F2_LOJA AND F2_ESPECIE='NF' ) "
	cSql		:= cSql+" JOIN " + RetSqlName("SD2") +" SD2 ON (D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_LOJA=F2_LOJA AND D2_ITEM='01' AND SD2.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" JOIN " + RetSqlName("SFP") +" SFP ON (FP_FILUSO=F2_FILIAL AND FP_SERIE=F2_SERIE AND SFP.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" AND F2_FILIAL='" + xFilial("SF2") + "' "
	cSql		:= cSql+" Order By F2_DOC"

	// Aviso("",cSql,{'ok'},,,,,.t.)

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
				AADD(aDupla,IIF(!EMPTY(F2_UNOME),F2_UNOME,A1_NOME))         //6
				AADD(aDupla,IIF(!EMPTY(F2_UNITCLI),F2_UNITCLI,A1_CGC))         //7
				AADD(aDupla,F2_COND)            //8
				AADD(aDupla,F2_VALFAT)          //9
				AADD(aDupla,F2_DESCONT)         //10
				AADD(aDupla,F2_VALBRUT)  		//11 F2_BASIMP1
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
				AADD(aDupla,F2_MOEDA)			//28
				AADD(aDupla,'FP_UACTIVI')			//29

				aDetalle:=FatDet(F2_DOC,F2_SERIE)                	   	//Datos detalle de factura

				//Aviso("Array IVA",u_zArrToTxt(aDetalle, .T.),{'ok'},,,,,.t.)

				nCantReg := len(aDetalle)

				//Acumula para sacar el total de paginas Erick
				for nI:= 1 to nCantReg
					if nCantReg >=37
						nCantReg = nCantReg - 37
						//	alert(nCantReg)
						nTotPags ++
					endif
				next

				cFilFact := aDupla[1]
				DbSelectArea("SM0")
				SM0->(DBSETORDER(1))
				SM0->(DbSeek(cEmpAnt+cFilFact))

				cDireccion := AllTrim(SM0->M0_ENDENT)
				cTelefono := "Telefono: "+AllTrim(SM0->M0_TEL)+If(!Empty(SM0->M0_FAX)," Fax: "+AllTrim(SM0->M0_FAX),"")

				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,cxTitulo,cDireccion,cTelefono)    	//Imprimir Factura
//				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA",cDireccion,cTelefono)	    	//Imprimir Factura
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
		MSGINFO("Codigo de Dosificacion Invalido para imprimir la Factura")
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
	local nIb
	Default nLinInicial := 0
	Private nCont := 0
//	Private nContador := 0
	nDim:=len(aDetalle)

	CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	_nInterLin += nLinInicial

	For nI:=1 to nDim
		nDes1 = nDes1 + aDetalle[nI][9]
	Next
	aadd(aDescTot,nDes1)


	For nI:=1 to nDim

		//		oPrn:Say(_nInterLin,100,aDetalle[nI][1],oFont10) //Codigo del Producto
		//		alert(nDim)
//		nContador++	//edson. cuenta los item de la factura 		
		oPrn:Say(_nInterLin,110, alltrim(aDetalle[nI][1]) ,oFont08)  //contador
		cDetdesc := alltrim(aDetalle[nI][2])
		if !EMPTY(aDetalle[nI][8])
			cDetdesc+= " - "+ alltrim(SubStr(aDetalle[nI][8], 1, 5 ))
		ENDIF
		if !EMPTY(aDetalle[nI][7])
			cDetdesc+= " - "+alltrim(aDetalle[nI][7])
		ENDIF
		oPrn:Say(_nInterLin,430,cDetdesc,oFont08)  //Descripcion

		//		oPrn:Say(_nInterLin,1330,aDetalle[nI][3],oFont10) //Lote
//		oPrn:Say(_nInterLin,1330,FmtoValor(aDetalle[nI][4],10,0),oFont10)  //Cantidad
//		xMoeda(aDetalle[nI][5],aMaestro[28],1,,2,1,aMaestro[26])
//		alert(aMaestro[28])
//		alert(aDetalle[nI][6])
//		alert(xMoeda(aDetalle[nI][6],2,1,,2,,))
		oPrn:Say(_nInterLin,1890,FmtoValor(xMoeda(aDetalle[nI][6],aMaestro[28],1,,2,,),14,2),oFont10,,,,1)  //Precio Unitario
		oPrn:Say(_nInterLin,2300,FmtoValor(xMoeda(aDetalle[nI][6],aMaestro[28],1,,2,,),14,2),oFont10,,,,1)  //Total

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
				oPrn:Say(_nInterLin,430,memoline(aDetalle[nI][2],_tamdesc,nIb,,.T.),oFont08)  //Descripcion
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

Static Function CabFact(nLin,aMaestro,cTipo,cDireccion,cTelefono)
	Local cFecVen := ""
	local nLinInicial := nLin
	local i
	nCont ++ // cuenta hojas Erick
	oPrn:StartPage()
	cFechaPed := If(!Empty(aMaestro[15]),DTOC(Posicione("SC5",1,xFilial("SC5")+aMaestro[15],"C5_EMISSAO")),"") //fecha pedido

	oPrn:Say( nLinInicial + 270,  290,SM0->M0_FULNAME  ,oFont09 )
	oPrn:Say( nLinInicial + 310,  210,SM0->M0_ENDENT  ,oFont09 )
	oPrn:Say( nLinInicial + 350,  130,SM0->M0_BAIRENT  ,oFont09 )
	oPrn:Say( nLinInicial + 390,  160,SM0->M0_TEL ,oFont09 )
	oPrn:Say( nLinInicial + 430,  250,SM0->M0_CIDENT  ,oFont09 )

	oPrn:Say( nLinInicial + 100, 1600,"NIT: "  ,oFont12N )
	oPrn:Say( nLinInicial + 100, 1995, AllTrim(SM0->M0_CGC) ,oFont12N ) // NIT EMPRESA
	oPrn:Say( nLinInicial + 160, 1600,"FACTURA No: "  ,oFont12N )
	oPrn:Say( nLinInicial + 160, 1995,AllTrim(str(val(aMaestro[3]))) ,oFont12N ) //Nro Factura
	oPrn:Say( nLinInicial + 220, 1600,"AUTORIZACION: "  ,oFont12 )
	oPrn:Say( nLinInicial + 220, 1995, aMaestro[4] ,oFont12 ) //Nro Autorizacion


	oPrn:Say( nLinInicial + 310, 1900 ,cTipo,oFont11N )

	cTexto := TexToArray(aMaestro[29],36)
	nLinInicial := nLinInicial + 330
//	cDireccion := TexToArray(AllTrim(SM0->M0_ENDENT),29)
	for i := 1 to len(cTexto)
		oPrn:Say( nLinInicial := nLinInicial + 45 , 1615,ALLTRIM(cTexto[i])  , oFont10 )
	next i

	nLinInicial := 0

//	oPrn:Say( nLinInicial + 375, 1615,"CONSTRUCCION DE EDIFICIOS COMPLETOS"  ,oFont10 )
//	oPrn:Say( nLinInicial + 420, 1680,"O PARTE DE EDIFICIOS; OBRAS DE"  ,oFont10 )
//	oPrn:Say( nLinInicial + 465, 1810,"INGENIERIA CIVIL"  ,oFont10 )

	if nTotPags >= 2
		oPrn:Say( nLinInicial + 375, 1100,"Pag: "+ cvaltochar(nCont) + " de " + cvaltochar(nTotPags) ,oFont09 )
	endif


	//Edson 22/03/2019
	oPrn:Say( nLinInicial + 430, 950,"FACTURA" ,oFont30N )

	oPrn:Say( nLinInicial + 670, 80,"Lugar y Fecha: " ,oFont11N )

	nfechavalidez   := 		alltrim(aMaestro[5])
	cAnho			:= 		SubStr(nfechavalidez, 1,4 )
	cMes			:= 		SubStr(nfechavalidez, 5,2 )
	cDia			:= 		SubStr(nfechavalidez, 7,2 )
	nfechavalidez	:= 		"SANTA CRUZ, "+cDia + " de " + MesExtenso(cMes) + " de " + cAnho

	oPrn:Say( nLinInicial + 670, 380, nfechavalidez ,oFont11 ) //Fecha Factura

	nLargo := 60
	cNombre := ALLTRIM(aMaestro[6])
	nLen := LEN(ALLTRIM(cNombre))

	cNombre1 := TextoCompleto(cNombre,nLargo)

	IF nLen > nLargo
		cNombre1 := AllTrim(TextoCompleto(cNombre,nLargo))

		oPrn:Say( nLinInicial + 730, 80,"Senor(es): " ,oFont11N )
		oPrn:Say( nLinInicial + 730, 80,"                      "  + cNombre1 ,oFont11 )
		oPrn:Say( nLinInicial + 730, 1850, "NIT: " ,oFont11N )
		oPrn:Say( nLinInicial + 730, 2000, aMaestro[7] ,oFont11 ) //NIT del Cliente
		oPrn:Say( nLinInicial + 790, 80, AllTrim(SUBSTR(cNombre, Len(cNombre1)+1, nLen)),oFont11 )
		oPrn:Say( nLinInicial + 850, 80,"Direccion: " ,oFont11N )
		oPrn:Say( nLinInicial + 850, 80,"                      " + alltrim(aMaestro[18]) ,oFont11 )
	ELSE
		oPrn:Say( nLinInicial + 730, 80,"Senor(es): ",oFont11N )
		oPrn:Say( nLinInicial + 730, 80,"                      "  + cNombre1 ,oFont11 )
		oPrn:Say( nLinInicial + 730, 1850, "NIT: " ,oFont11N )
		oPrn:Say( nLinInicial + 730, 2000, aMaestro[7] ,oFont11 ) //NIT del Cliente
		oPrn:Say( nLinInicial + 790, 80,"Direccion: ",oFont11N )
		oPrn:Say( nLinInicial + 790, 80,"                      " + alltrim(aMaestro[18]) ,oFont11 )
	ENDIF

	/**IF nLen > nLargo  /// SI MAYOR 60
		oPrn:Say( nLinInicial + 790, 80, "DIRECCION: " ,oFont11N )
		oPrn:Say( nLinInicial + 790, 380, cNombre ,oFont11 ) //NIT del Cliente
		oPrn:Say( nLinInicial + 790, 380, substr(cNombre) ,oFont11 ) //NIT del Cliente
	ELSE
		oPrn:Say( nLinInicial + 790, 80, "DIRECCION: " ,oFont11N )
		oPrn:Say( nLinInicial + 790, 380, cNombre ,oFont11 ) //NIT del Cliente
	ENDIF*/


	//Titulos reporte
	oPrn:Say(nLinInicial + 945, 110, "CODIGO" ,oFont11N )
	oPrn:Say(nLinInicial + 945, 430, "DESCRIPCION DEL PRODUCTO" ,oFont11N )
	oPrn:Say(nLinInicial + 945, 1635, "PRECIO UNITARIO" ,oFont11N )
	oPrn:Say(nLinInicial + 945, 2150, "TOTAL" ,oFont11N )

//				x                 y     x      y
	oPrn:Box( nLinInicial + 930 , 80 ,  930 , 2360 )  // Edson  linea superior
	oPrn:Box( nLinInicial + 1005 , 80 ,  1005 , 2360 )  // Edson  linea superior
	oPrn:Box( nLinInicial + 2480 , 80 ,  2480 , 2360 )  // Edson  linea inferior
	oPrn:Box( nLinInicial + 2600 , 80 ,  2600 , 2360 )  // Edson  linea inferior
	//Lineas verticales
	oPrn:Box( nLinInicial + 930 , 80 ,  2600 , 80 )
	oPrn:Box( nLinInicial + 930 , 390 ,  2480 , 390 )
	oPrn:Box( nLinInicial + 930 , 1560 ,  2480 , 1560 )
	oPrn:Box( nLinInicial + 930 , 2010 ,  2600 , 2010 )
	oPrn:Box( nLinInicial + 930 , 2360 ,  2600 , 2360 )

	cFLogo := GetSrvProfString("Startpath","") + "logopr2.png"
	oPrn:SayBitmap(80 , 110 , cFLogo,600,200)
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
	
	oPrn:Say( nLinInicial + 2510, 100, "Son: "+Extenso(aMaestro[11],.F.,1)+" BOLIVIANOS" ,oFont11 ) //Total  Escrito
		
	oPrn:Say(nLinInicial + 2330, 1610, "Subtotal :" ,oFont12N )

	nTotGral := Round(aMaestro[9]+aMaestro[10],2) 

	oPrn:Say(nLinInicial + 2330, 2300,FmtoValor(nTotGral,14,2) ,oFont12N,,,,1 )
	

    oPrn:Say(nLinInicial + 2400, 1610, "Descuentos :" ,oFont12N )
//	F2_DESCONT
	oPrn:Say(nLinInicial + 2400, 2300,FmtoValor(aMaestro[10],14,2) ,oFont12N,,,,1 )  // Nahim Descuentos.


	oPrn:Say(nLinInicial + 2510, 2300,FmtoValor(xMoeda(aMaestro[11],aMaestro[28],1,,2,,),14,2) ,oFont12N,,,,1) //Descuentos	


	oPrn:Say(nLinInicial + 2650, 100, "CODIGO DE CONTROL:  "+aMaestro[12] ,oFont12 )	//Codigo Control

	oPrn:Say(nLinInicial + 2650, 1700, "T/C." ,oFont12N )	//Codigo Control
//	oPrn:Say(nLinInicial + 2650, 2300,FmtoValor(aMaestro[28],14,2) ,oFont12N,,,,1 )
	oPrn:Say(nLinInicial + 2650, 2300,FmtoValor(ROUND(aMaestro[11]/xMoeda(aMaestro[11],aMaestro[28],2,,2,,),2),14,2) ,oFont12N,,,,1 )

	oPrn:Say(nLinInicial + 2700, 100, "FECHA LIMITE DE EMISION:  "+DTOC(STOD(aMaestro[13])) ,oFont12 )//Fecha limite emision

	oPrn:Say(nLinInicial + 2700, 1700, "TOTAL $us.:  " ,oFont12N )//Fecha limite emision

	oPrn:Say(nLinInicial + 2700, 2300, FmtoValor(xMoeda(aMaestro[11],aMaestro[28],2,,2,,),14,2),oFont12N,,,,1 )
			
	oPrn:Say(nLinInicial + 3050, 085 , "''ESTA FACTURA CONTRIBUYE AL DESARROLLO DEL PAIS, EL USO ILICITO DE ESTA SERA SANCIONADA DE ACUERDO A LEY''" ,oFont10N )
	oPrn:Say(nLinInicial + 3100, 085, alltrim(U_GetExFis(aMaestro[2],aMaestro[1])) ,oFont10N )//obtiene la dosificacion libro fiscales
	

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

	oPrn:SayBitmap(2750,2000,cFile,320,320)

	oPrn:EndPage()

	oDelete:setFile(cFile) // carga rutas de los archivos para despues borrar
	
Return

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

	Local   cSql		:= "SELECT B1_COD,"

	cSql				:= cSql+ " MIN(D2_ITEM) D2_ITEM,"
	cSql				:= cSql+ "   CONVERT(varchar(500),ISNULL (                                                                                 "
	cSql				:= cSql+ "   CASE                                                                                     "
	cSql				:= cSql+ "      WHEN                                                                                  "
	cSql				:= cSql+ "         MAX(LEN(RTRIM(LTRIM(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)), ''))))) > 1  "
	cSql				:= cSql+ "      THEN                                                                                  "
	cSql				:= cSql+ "         max(C6_UDESCLA)                                                                          "
	cSql				:= cSql+ "      WHEN                                                                                  "
	cSql				:= cSql+ "         max(LEN(C6_DESCRI)) > 0 																"
	cSql				:= cSql+ "	  THEN                                                                                    "
	cSql				:= cSql+ "         max(C6_DESCRI)                                                                         "
	cSql				:= cSql+ "     ELSE                                                                                  "
	cSql				:= cSql+ "      	 B1_DESC                                                                          "
	cSql				:= cSql+ "   END                                                                                      "
	cSql				:= cSql+ "	, B1_DESC)) B1_DESC,                                                                       "
	cSql				:= cSql+"D2_LOTECTL,D2_DTVALID,SUM(D2_QUANT) D2_QUANT,(ROUND(SUM(D2_TOTAL),2) / SUM(D2_QUANT))  D2_PRUNIT,(ROUND(SUM(D2_TOTAL),2) / SUM(D2_QUANT)) * SUM(D2_QUANT) D2_TOTAL, D2_PEDIDO , D2_DOC ,D2_FILIAL,C6_UPLACA,C6_UCLVL, C6_UNOMCLV "
	// cSql				:= cSql+"D2_LOTECTL,D2_DTVALID,D2_QUANT,CASE WHEN D2_PRUNIT!=0 THEN D2_PRUNIT ELSE D2_PRCVEN END D2_PRUNIT,CASE WHEN D2_PRUNIT!=0 THEN D2_QUANT*D2_PRUNIT ELSE D2_QUANT*D2_PRCVEN END D2_TOTAL, D2_PEDIDO, D2_ITEMPV , D2_DOC ,D2_FILIAL,C6_UPLACA,C6_UCLVL, C6_UNOMCLV "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"LEFT JOIN "+ RetSqlName("SC6") +" SC6 ON (C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM) AND SC6.D_E_L_E_T_=' ' "
	cSql				:= cSql+" WHERE D2_COD = 'SERVIC101000431' "
	cSql				:= cSql+"GROUP BY B1_COD,B1_DESC,D2_PEDIDO , D2_DOC ,D2_FILIAL,C6_UPLACA,C6_UCLVL, C6_UNOMCLV,D2_LOTECTL,D2_DTVALID"

	cSql				:= cSql+ " UNION ALL "
	cSql				:= cSql+ "SELECT B1_COD,"
	cSql				:= cSql+ " D2_ITEM,"
	cSql				:= cSql+ "   CONVERT(varchar(120),ISNULL (                                                                                 "
	cSql				:= cSql+ "   CASE                                                                                     "
	cSql				:= cSql+ "      WHEN                                                                                  "
	cSql				:= cSql+ "         LEN(RTRIM(LTRIM(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)), '')))) > 1  "
	cSql				:= cSql+ "      THEN                                                                                  "
	cSql				:= cSql+ "         C6_UDESCLA                                                                          "
	cSql				:= cSql+ "      WHEN                                                                                  "
	cSql				:= cSql+ "         LEN(C6_DESCRI) > 0 																"
	cSql				:= cSql+ "	  THEN                                                                                    "
	cSql				:= cSql+ "         C6_DESCRI                                                                         "
	cSql				:= cSql+ "     ELSE                                                                                  "
	cSql				:= cSql+ "      	 B1_DESC                                                                          "
	cSql				:= cSql+ "   END                                                                                      "
	cSql				:= cSql+ "	, B1_DESC)) B1_DESC,                                                                       "
	cSql				:= cSql+"D2_LOTECTL,D2_DTVALID,D2_QUANT,(ROUND(D2_TOTAL,2) / D2_QUANT)  D2_PRUNIT,(ROUND(D2_TOTAL,2) / D2_QUANT) * D2_QUANT D2_TOTAL, D2_PEDIDO , D2_DOC ,D2_FILIAL,C6_UPLACA,C6_UCLVL, C6_UNOMCLV "
	// cSql				:= cSql+"D2_LOTECTL,D2_DTVALID,D2_QUANT,CASE WHEN D2_PRUNIT!=0 THEN D2_PRUNIT ELSE D2_PRCVEN END D2_PRUNIT,CASE WHEN D2_PRUNIT!=0 THEN D2_QUANT*D2_PRUNIT ELSE D2_QUANT*D2_PRCVEN END D2_TOTAL, D2_PEDIDO, D2_ITEMPV , D2_DOC ,D2_FILIAL,C6_UPLACA,C6_UCLVL, C6_UNOMCLV "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"LEFT JOIN "+ RetSqlName("SC6") +" SC6 ON (C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM) AND SC6.D_E_L_E_T_=' ' "
	cSql				:= cSql+"WHERE D2_COD <> 'SERVIC101000431'"
	cSql				:= cSql+"ORDER BY D2_ITEM"
    
	// Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	
	//Descuentos para 
	//getDescont(cNota,cFilla,cPed)
	cPedc5 := ""
	aDescon := {}
	
	While !Eof()
		if cPedc5 <> D2_PEDIDO   ////TIENE PEDIDO LA LINEA
			aDescon := getDescont(D2_DOC,D2_FILIAL,D2_PEDIDO) ///TRAE DESCUENTO DEL PEDIDO
		endif
		cPedc5 := D2_PEDIDO
		
		cProducto	:=B1_COD
		cNombre		:=B1_DESC
		If Len(AllTrim(D2_DTVALID+D2_DTVALID))>0
			cLote       :="L:"+AllTrim(D2_LOTECTL)+" V:"+ALLTRIM(STRZERO(MONTH(STOD(D2_DTVALID)),2))+ALLTRIM("/")+ALLTRIM(STRZERO(Year(STOD(D2_DTVALID)),4))
		Else
			cLote       := ""
		EndIf
		cPedido		:= D2_PEDIDO
		nCant		:= D2_QUANT
		nPrecio		:= D2_PRUNIT
		nTotal		:= Round(nCant*nPrecio,2)
		nPlaca      := C6_UPLACA
		nUclvl      := C6_UNOMCLV
				
//		aPerc := getDescPerc(nCant,aDescon,nPrecio) //Descuentos		
		
		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,cLote)      //3
		AADD(aDupla,nCant)      //4
		AADD(aDupla,nPrecio)    //5
		AADD(aDupla,nTotal)     //6		
		AADD(aDupla,nPlaca)     //7
		AADD(aDupla,nUclvl)     //8
		AADD(aDupla,aDescon[1]) //9 desc 1 usados de cliente
//		AADD(aDupla,aPerc[2])     //8 desc 2
//		AADD(aDupla,aPerc[3])     //9 desc 3
//		AADD(aDupla,aPerc[4])     //10 desc 4 usados otros
		
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

Static Function TexToArray(cTexto,nTamLine)
	Local aTexto	:= {}
	Local aText2	:= {}
	Local cToken	:= " "
	Local nX
	Local nTam		:= 0
	Local cAux		:= ""

	aTexto := STRTOKARR ( cTexto , cToken )

	For nX := 1 To Len(aTexto)
		nTam := Len(cAux) + Len(aTexto[nX])
		If nTam <= nTamLine
			cAux += aTexto[nX] + IIF((nTam+1) <= nTamLine, cToken,"")
		Else
			AADD(aText2,cAux)
			cAux := aTexto[nX] + cToken
		Endif
	Next nX

	If !Empty(cAux)
		AADD(aText2,cAux)
	Endif

Return(aText2)

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
	
//	Aviso("",cQuery,{'ok'},,,,,.t.)
	
	cQuery := ChangeQuery(cQuery)

	//Executando consulta
	TCQuery cQuery New Alias "qrr_SC5"

	//Percorrendo os registros
	if ! qrr_SC5->(EoF())
		While ! qrr_SC5->(EoF())
			
			AADD(acNped,qrr_SC5->C5_DESC1)

			qrr_SC5->(DbSkip())
		EndDo
	else
		AADD(acNped,0)
	endif


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
//	alert(nDestos) 
	
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
	
	if(nDestos == 0)// en caso que el cliente no cuente con ningun descuento . edson 21/05/2019
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

Static Function TextoCompleto(cTexto,nTamLine)
	Local aTexto	:= {}
	Local cToken	:= " "
	Local nX
	Local cTextoNvo := ""

	aTexto := STRTOKARR ( cTexto , cToken )

	For nX := 1 To Len(aTexto)
		If Len(AllTrim(cTextoNvo+cToken+aTexto[nX])) <= nTamLine
			cTextoNvo := AllTrim(cTextoNvo) + cToken + aTexto[nX]
		Else
			nX := Len(aTexto)
		Endif
	Next nX

Return(cTextoNvo)
