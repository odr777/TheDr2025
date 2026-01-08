#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FacturaMCL  ³Amby Arteaga	     º Data ³  10/06/15       º±±
±±º			 ³Nahim Terrazas	 			     º Data ³  15/02/16       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emision de Factura de salida con Codigo QR                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Emision de facturas de Salida Nacional                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØ con impresion de lotes				   				      ¹±±
±±ºUso       ³ Especifico Mercantil LEON - SAnta Cruz                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FacturaMCL(cxNro1,cxNro2,cxSerie,cxClient)

	FatLocal('Factura De Salida Local',.F.,cxNro1,cxNro2,cxSerie,cxClient)

Return nil

Static function FatLocal(cTitulo,bImprimir,cNroFat1,cNroFat2,cSerie,cClient)
	Private oPrn    := NIL
	Private oFont10  := NIL
	Private lPrevio	:=.T.
	private oDelete := delFiles():new()
	Private nLinIni := 0
	Private nLinFin := 0
	Private nTCol1 := 0
	Private nTCol2 := 0
	Private nTCol3 := 0

	Private nDCol0 := 0
	Private nDCol1 := 0
	Private nDCol2 := 0
	Private nDCol3 := 0
	Private nDCol4 := 0
	Private nDCol5 := 0

	Private nColF := 0
	Private nLinAdd := 0

	Private nTotDes2 := 0
	Private nTotLote := 0
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetCurrentPrinterInUse()
	oPrn:SetPortrait()
	oPrn:setPaperSize(DMPAPER_LETTER)

	DEFINE FONT oFont06 NAME "Arial" SIZE 0,06.90 OF oPrn
	DEFINE FONT oFont07 NAME "Arial" SIZE 0,07 OF oPrn
	DEFINE FONT oFont07N NAME "Arial" SIZE 0,07 Bold OF oPrn
	DEFINE FONT oFont08 NAME "Arial" SIZE 0,08 OF oPrn
	DEFINE FONT oFont08N NAME "Arial" SIZE 0,08 Bold OF oPrn
	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09  OF oPrn
	DEFINE FONT oFont09N NAME "Arial" SIZE 0,09 Bold OF oPrn
	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oFont10N NAME "Arial" SIZE 0,10 Bold OF oPrn
	DEFINE FONT oFont105N NAME "Arial" SIZE 0,10.5 Bold OF oPrn
	DEFINE FONT oFont11N NAME "Arial" SIZE 0,11 Bold OF oPrn
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
	DEFINE FONT oFont12N NAME "Arial" SIZE 0,12 Bold OF oPrn
	DEFINE FONT oFont16N NAME "Arial" SIZE 0,16 Bold OF oPrn
	DEFINE FONT oFont20N NAME "Arial" SIZE 0,20 Bold OF oPrn

	FatMat(cNroFat1,cNroFat2,cSerie,cClient,cTitulo,bImprimir,1) //Impresion de factura
return Nil

static function FatMat(cDoc1,cDoc2,cSerie,cClient,cTitulo,bImprimir) //Datos Maestro de factura;
	Local aDupla   := {}
	Local aDetalle := {}
	Local nI       := 0
	Local bSw	   := .T.
	Local cMsgFat  := ""
	Local NextArea := GetNextAlias()
	Local aDados
	Local i := 1
	Local cSql     := "SELECT F2_LOJA,F2_FILIAL,F2_SERIE,F2_DOC,F2_VALBRUT,F2_MOEDA,F2_NUMAUT,F2_EMISSAO,F2_UNOMCLI,F2_UNITCLI,F2_COND,F2_VALFAT,F2_DESCONT,F2_BASIMP1,F2_CODCTR,FP_DTAVAL,FP_ULEYE,F2_UNROIMP,D2_PEDIDO,F2_CLIENTE,D2_SERIREM,D2_REMITO,F2_VEND1 "
	cSql           := cSql+" FROM " + RetSqlName("SF2 ") +" SF2 JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F2_CLIENTE AND A1_LOJA = F2_LOJA AND (F2_DOC BETWEEN '" + cDoc1 + "' AND '"+cDoc2+ "' ) AND F2_SERIE='"+cSerie+"' AND F2_CLIENTE='" + cClient + "' AND SF2.D_E_L_E_T_ =' ' AND SA1.D_E_L_E_T_ =' ' AND A1_LOJA=F2_LOJA AND F2_ESPECIE='NF' ) "
	cSql		   := cSql+" JOIN " + RetSqlName("SD2") +" SD2 ON (D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND  D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2_ITEM='01' AND SD2.D_E_L_E_T_ =' ') "
	cSql           := cSql+" JOIN " + RetSqlName("SFP") +" SFP ON (FP_SERIE=F2_SERIE AND SFP.D_E_L_E_T_ =' ') "
	cSql           := cSql+" Order By F2_DOC"

	private nMoedax := 0
	private nTxMoe := 0

	//Aviso("cSql",cSql,{"OK"},,,,,.T.)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	nMoedax := Posicione("SC5",1,xFilial("SC5")+D2_PEDIDO,"C5_MOEDA")
	nTxMoe  := Posicione("SC5",1,xFilial("SC5")+D2_PEDIDO,"C5_TXMOEDA")
	nMoeFac := F2_MOEDA
	dEmiss  := F2_EMISSAO

	While !Eof()
		bSw		:= .T.
		If (F2_UNROIMP>0)
			If (VldImpFat()==.F.)
				bSw		:= .F.
				cMsgFat := cMsgFat+AllTrim(F2_DOC)+";"
			EndIf
		EndIf

		If ( bSw == .T.)
			AADD(aDupla,F2_FILIAL)		  	//1
			AADD(aDupla,F2_SERIE)           //2
			AADD(aDupla,F2_DOC)             //3
			AADD(aDupla,F2_NUMAUT)          //4
			AADD(aDupla,F2_EMISSAO)         //5
			AADD(aDupla,F2_UNOMCLI)         //6
			AADD(aDupla,F2_UNITCLI)         //7
			AADD(aDupla,F2_COND)            //8
			AADD(aDupla,F2_VALBRUT)          //9
			AADD(aDupla,F2_DESCONT)         //10
			AADD(aDupla,F2_BASIMP1)  		//11
			AADD(aDupla,F2_CODCTR)          //12
			AADD(aDupla,FP_DTAVAL)          //13
			AADD(aDupla,F2_UNROIMP)		    //14
			AADD(aDupla,D2_PEDIDO)		    //15
			AADD(aDupla,F2_CLIENTE)		    //16
			AADD(aDupla,D2_SERIREM)		    //17
			AADD(aDupla,D2_REMITO)		    //18
			AADD(aDupla,F2_VEND1)		    //19
			AADD(aDupla,FP_ULEYE)			//20
			AADD(aDupla,F2_LOJA)			//21
			aDetalle:=FatDet (F2_DOC,F2_SERIE,F2_CLIENTE)                	   	//Datos detalle de factura
			FatImp (cTitulo,bImprimir,aDupla,aDetalle,"ORIGINAL")    	//Imprimir Factura
			FatImp (cTitulo,bImprimir,aDupla,aDetalle,"COPIA")    	//Imprimir Factura
			FatImp (cTitulo,bImprimir,aDupla,aDetalle,"COPIA")    	//Imprimir Factura
			UpCntFat(aDupla[3],aDupla[2],aDupla[16],aDupla[1],'NF')
			dbSelectArea(NextArea)
			aDupla := {}
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

	aDados := oDelete:getFiles()
	for i:= 1 to len(aDados)

		FERASE(aDados[i])//borra archivos

	next i

	oPrn:End()
return aDupla

static function FatImp(cTitulo,bImprimir,aMaestro,aDetalle,cTipo)
	Local _nInterLin := 760
	Local aInfUser := pswret()
	Local nI:=0
	Local nNroItem:=1

	Local nItemFact:=36
	Local nDim:=0
	Local nNroTotPag := 0
	Local nNroPag := 1
	Local nTotPag := 0
	Local nLinInicial := 0
	//	if()

	nDim:=len(aDetalle)
	nTotPag := (nDim + nTotDes2 + nTotLote) / nItemFact
	If ((nTotPag-INT(nTotPag)) == 0)
		nNroTotPag := nTotPag
	Else
		nNroTotPag := INT(nTotPag) + 1
	EndIf

	CabFact(nNroPag,nNroTotPag,aMaestro,cTipo)
	_nInterLin += nLinInicial

	For nI:=1 to nDim

		oPrn:Say(_nInterLin, nDCol0-5, AllTrim(aDetalle[nI][1]), oFont08) //codigo
		oPrn:Say(_nInterLin, nDCol1 + 180, TRANSFORM(aDetalle[nI][4],"@A 99,999,999.99"), oFont08,,,,1)  //Cantidad
		oPrn:Say(_nInterLin, nDCol2+10, aDetalle[nI][3], oFont08) //UM
		oPrn:Say(_nInterLin, nDCol3+20, aDetalle[nI][2], oFont07)  //Descripcion
		oPrn:Say(_nInterLin, nDCol4 + 200, TRANSFORM(aDetalle[nI][5],"@A 999,999,999.99"), oFont08,,,,1) //Precio Unitario
		oPrn:Say(_nInterLin, nDCol5 + 250, TRANSFORM(aDetalle[nI][6],"@A 99,999,999,999.99"), oFont08,,,,1) //Total

		_nInterLin:=_nInterLin+50
		If !Empty(aDetalle[nI][7])
			If nNroItem >= nItemFact .And. nNroItem < (nDim + nTotDes2 + nTotLote)  //modificado
				PieFact(nNroPag,nNroTotPag,aMaestro)
				nNroItem := 1
				nLinInicial:= 1
				nNroPag += 1
				CabFact(nNroPag,nNroTotPag,aMaestro,cTipo)    	//Imprimir Factura
				_nInterLin := 760 + nLinInicial
			Else
				nNroItem += 1
			EndIf
			oPrn:Say(_nInterLin, nDCol3+20, aDetalle[nI][7], oFont07)  //Descripcion
			_nInterLin:=_nInterLin+50
		EndIf
		If !Empty(aDetalle[nI][8])
			If nNroItem >= nItemFact .And. nNroItem < (nDim + nTotDes2 + nTotLote)  //modificado
				PieFact(nNroPag,nNroTotPag,aMaestro)
				nNroItem := 1
				nLinInicial:= 1
				nNroPag += 1
				CabFact(nNroPag,nNroTotPag,aMaestro,cTipo)    	//Imprimir Factura
				_nInterLin := 760 + nLinInicial
			Else
				nNroItem += 1
			EndIf
			oPrn:Say(_nInterLin, nDCol3+20, aDetalle[nI][8], oFont07)  //lote
			_nInterLin:=_nInterLin+50
		EndIf
		If nNroItem >= nItemFact .And. nNroItem < (nDim + nTotDes2 + nTotLote)
			PieFact(nNroPag,nNroTotPag,aMaestro)
			nNroItem := 1
			nLinInicial:= 1
			nNroPag += 1
			CabFact(nNroPag,nNroTotPag,aMaestro,cTipo)    	//Imprimir Factura
			_nInterLin := 760 + nLinInicial
		Else
			nNroItem += 1
		EndIf
	Next

	PieFact(nNroPag,nNroTotPag,aMaestro)
return nil

Static Function CabFact(nNroPag,nNroTotPag,aMaestro,cTipo)
	nLinIni := 170     //190
	nLinFin := 2555
	nTCol1 := 80
	nTCol2 := 1100
	nTCol3 := 1700

	nDCol0 := 100
	nDCol1 := 280
	nDCol2 := 500
	nDCol3 := 600
	nDCol4 := 1980
	nDCol5 := 2190

	nColF := 2460
	nLinAdd := 40

	oPrn:StartPage()
	//	If nNroTotPag > 1
	// 	oPrn:Say( 30, nTCol2 + 50,AllTrim(str(nNroPag)) + " de " + AllTrim(str(nNroTotPag)) ,oFont10 ) 								//Nro Factura
	//	EndIf
	cFLogo := GetSrvProfString("Startpath","") + "logo1.bmp"
	oPrn:SayBitmap(nLinIni-140,nTCol1, cFLogo,730,150)
	oPrn:Say( nLinIni + (0.5*nLinAdd), nTCol1, "CASA MATRIZ", oFont10N )
	oPrn:Say( nLinIni + (1.5*nLinAdd), nTCol1, "Av. Viedma N° 51", oFont09 )
	oPrn:Say( nLinIni + (2.5*nLinAdd), nTCol1, "Zona Barrio Cementerio General", oFont09 )
	oPrn:Say( nLinIni + (3.5*nLinAdd), nTCol1, "Telfs.: 3 3326174 - 3 3331447", oFont09 )
	oPrn:Say( nLinIni + (4.5*nLinAdd), nTCol1, "3 3364244 - Fax: 3 3368672", oFont09 )
	oPrn:Say( nLinIni + (5.5*nLinAdd), nTCol1, "www.mercantilleon.com", oFont09 )
	oPrn:Say( nLinIni + (6.5*nLinAdd), nTCol1, "Santa Cruz - Bolivia", oFont09 )

	oPrn:Say( nLinIni - 030, nTCol2, "FACTURA" ,oFont20N )
	oPrn:Say( nLinIni - 030, nTCol3 + 100, "NIT: 143953021", oFont16N )

	nLinAdd += 10
	oPrn:Say( nLinIni + (1.0*nLinAdd), nTCol3, "FACTURA No: " + alltrim(str(val(aMaestro[3]))), oFont12N ) //Nro Factura
	oPrn:Say( nLinIni + (2.0*nLinAdd), nTCol3, "AUTORIZACION: " + aMaestro[4], oFont12N ) //Nro Autorizacion
	oPrn:Say( nLinIni + (3.0*nLinAdd), nTCol3, cTipo  ,oFont12N )
	nLinAdd += 10
	oPrn:Say( nLinIni + (4.0*nLinAdd), nTCol3, "COMERCIO MAYORISTA Y MINORISTA"  ,oFont10N )

	nLinAdd -= 20
	oPrn:Say( nLinIni + (8*nLinAdd), nTCol1 + 10, "SANTA CRUZ, " + Fecha(aMaestro[5]), oFont12 )  //Fecha Factura

	//oPrn:Say( nLinIni + (9*nLinAdd) + 10, nTCol1 + 10, "SEÑOR (ES): " + alltrim("GUATAPE SERVICIOS ELECTRICOS E ILUMINACION SRL") ,oFont12 ) // Nombre del Cliente
	//AAR 	oPrn:Say( nLinIni + (9*nLinAdd) + 10, nTCol1 + 10, "SEÑOR (ES): " + alltrim(aMaestro[6]) ,oFont12 ) // Nombre del Cliente
	oPrn:Say( nLinIni + (8*nLinAdd), nTCol3 + 50, "NIT/C.I.: " + alltrim(aMaestro[7]) ,oFont12 ) //NIT del Cliente

	nLargo := 60
	cNombre := ALLTRIM(aMaestro[6])
	nLen := LEN(ALLTRIM(cNombre))
	IF nLen > nLargo
		cNombre1 := AllTrim(TextoCompleto(cNombre,nLargo))
		oPrn:Say( nLinIni + (9*nLinAdd) + 10, nTCol1 + 10, "SEÑOR (ES): " + cNombre1 ,oFont12 ) // Nombre del Cliente
		oPrn:Say( nLinIni + (10*nLinAdd) + 10, nTCol1 + 300, AllTrim(SUBSTR(cNombre, Len(cNombre1)+1, nLen)) ,oFont12 ) // Nombre del Cliente
	ELSE
		oPrn:Say( nLinIni + (9*nLinAdd) + 10, nTCol1 + 10, "SEÑOR (ES): " + alltrim(aMaestro[6]) ,oFont12 ) // Nombre del Cliente
	ENDIF

	nLinAdd := nLinAdd * 12
	oPrn:Box( nLinIni + nLinAdd, nTCol1, nLinFin + 200, nColF )
	oPrn:Box( nLinFin, nTCol1, nLinFin, nColF )
	oPrn:Box( nLinFin + 70, nDCol4, nLinFin + 70, nColF )
	oPrn:Box( nLinFin + 140, nDCol4, nLinFin + 140, nColF )

	oPrn:Box( nLinIni + nLinAdd, nDCol1 , nLinFin, nDCol2)
	oPrn:Box( nLinIni + nLinAdd, nDCol2 , nLinFin, nDCol2 )
	oPrn:Box( nLinIni + nLinAdd, nDCol3 , nLinFin, nDCol3 )
	oPrn:Box( nLinIni + nLinAdd, nDCol4,  nLinFin + 200, nDCol4 )
	oPrn:Box( nLinIni + nLinAdd, nDCol5 , nLinFin + 200, nDCol5)

	nLinAdd += 20
	oPrn:Say( nLinIni + nLinAdd, nDCol0, "CODIGO" ,oFont09N ) 													//Nombre
	oPrn:Say( nLinIni + nLinAdd, nDCol1+10, "CANTIDAD" ,oFont09N ) 													//Nombre
	oPrn:Say( nLinIni + nLinAdd, nDCol2+10, "U/M" ,oFont09N ) 													//Nombre
	oPrn:Say( nLinIni + nLinAdd, nDCol3+20, "DESCRIPCION DEL PRODUCTO" ,oFont09N ) 													//Nombre
	iif(nMoedax == 1,oPrn:Say( nLinIni + nLinAdd, nDCol4 + 45, "P.UNIT Bs." ,oFont09N ),oPrn:Say( nLinIni + nLinAdd, nDCol4 + 45, "P.UNIT $us" ,oFont09N ))
	//iif(nMoedax == 1,oPrn:Say( nLinIni + nLinAdd, nDCol5 + 65, "TOTAL Bs." ,oFont09N ),oPrn:Say( nLinIni + nLinAdd, nDCol5 + 65, "TOTAL $us" ,oFont09N ))
	iif(nMoedax == 1,oPrn:Say( nLinIni + nLinAdd, nDCol5 + 65, "TOTAL Bs." ,oFont09N ),oPrn:Say( nLinIni + nLinAdd, nDCol5 + 65, " " ,oFont09N ))

	nLinAdd += 60
	oPrn:Box( nLinIni + nLinAdd, nTCol1 ,  nLinIni + nLinAdd, nColF  )

Return Nil

Static Function PieFact(nNroPag,nNroTotPag,aMaestro)
	_nTipoCambio = POSICIONE("SM2",1,aMaestro[5],"M2_MOEDA2")
	nLargo := 85
	cTotalLiteral := ALLTRIM(Extenso(aMaestro[11],.F.,1))+" BOLIVIANOS"
	nLenLit := LEN(ALLTRIM(cTotalLiteral))
	IF nLenLit > nLargo
		cTotLit1 := AllTrim(TextoCompleto(cTotalLiteral,nLargo))
		oPrn:Say( nLinFin + 20, nTCol1 + 20, "SON: " + cTotLit1, oFont09N ) 							//Total  Escrito
		oPrn:Say( nLinFin + 70, nTCol1 + 100, AllTrim(SUBSTR(cTotalLiteral, Len(cTotLit1)+1, nLenLit)), oFont09N ) //Total  Escrito
	ELSE
		oPrn:Say( nLinFin + 20, nTCol1 + 20, "SON: " + cTotalLiteral,oFont09N ) 							//Total  Escrito
	ENDIF

	if nMoedax == 1
		oPrn:Say( nLinFin + 20, nDCol4 + 20, "TOTAL Bs." ,oFont08N )
		oPrn:Say( nLinFin + 90, nDCol4 + 20, "T/C" ,oFont08N )
		//oPrn:Say( nLinFin + 150, nDCol4 + 20, "TOTAL $us." ,oFont08N )
		oPrn:Say( nLinFin + 20, nDCol5 + 250, TRANSFORM(aMaestro[11],"@A 99,999,999,999.99") ,oFont08N,,,,1)  //Total Bolivianos
		oPrn:Say( nLinFin + 90, nDCol5 + 250, TRANSFORM(_nTipoCambio,"@A 99,999,999,999.99") ,oFont08N,,,,1)  //Tipo Cambio
		//oPrn:Say( nLinFin + 150, nDCol5 + 250, TRANSFORM(aMaestro[11]/_nTipoCambio,"@A 99,999,999,999.99") ,oFont08N,,,,1)  //Total Dolares
	else
		//oPrn:Say( nLinFin + 150, nDCol4 + 20, "TOTAL $us." ,oFont08N )
		oPrn:Say( nLinFin + 90, nDCol4 + 20, "T/C" ,oFont08N )
		oPrn:Say( nLinFin + 20, nDCol4 + 20, "TOTAL Bs." ,oFont08N )		
		//oPrn:Say( nLinFin + 150, nDCol5 + 250, TRANSFORM(aMaestro[11]/_nTipoCambio,"@A 99,999,999,999.99") ,oFont08N,,,,1)  //Total Dolares
		oPrn:Say( nLinFin + 90, nDCol5 + 250, TRANSFORM(_nTipoCambio,"@A 99,999,999,999.99") ,oFont08N,,,,1)  //Tipo Cambio
		oPrn:Say( nLinFin + 20, nDCol5 + 250, TRANSFORM(aMaestro[11],"@A 99,999,999,999.99") ,oFont08N,,,,1)  //Total Bolivianos				
	endif

	nAddLin := 210
	If !Empty(GetAdvFVal("SC5","C5_MENNOTA",xFilial("SC5") + aMaestro[15],1,""))
		oPrn:Say( nLinFin + nAddLin, nTCol1, "OBSERVACION: " + GetAdvFVal("SC5","C5_MENNOTA",xFilial("SC5") + aMaestro[15],1,""), oFont10 )  //Observacion del Pedido
		nAddLin += 50
	EndIf
	If !Empty(aMaestro[19])
		oPrn:Say( nLinFin + nAddLin, nTCol1, "VENDEDOR: " + aMaestro[19], oFont10 )  //Codigo Cliente
		nAddLin += 50
	EndIf
	If !Empty(aMaestro[16])
		oPrn:Say( nLinFin + nAddLin, nTCol1, "CLIENTE: " + alltrim(aMaestro[16]) , oFont10 )  //Codigo Cliente
		nAddLin += 50
	EndIf
	If !Empty(aMaestro[8])
		oPrn:Say( nLinFin + nAddLin, nTCol1, "CONDICION DE VENTA: " + Iif(aMaestro[8]=="002","CONTADO","CREDITO"), oFont10 ) // Numero del Pedido
		nAddLin += 50
	EndIf
	If !Empty(aMaestro[15])
		oPrn:Say( nLinFin + nAddLin, nTCol1, "PEDIDO DE VENTA: " + aMaestro[15], oFont10 )  //Pedido de Venta
		nAddLin += 50
	EndIf
	If !Empty(aMaestro[17])
		oPrn:Say( nLinFin + nAddLin, nTCol1, "REMITO DE SALIDA: " + AllTrim(aMaestro[17]) + "-" + aMaestro[18], oFont10 )  //Remito de Salida
		nAddLin += 50
	EndIf
	If !Empty(GetAdvFVal("SC5","C5_UNUCOCL",xFilial("SC5") + aMaestro[15],1,""))
		oPrn:Say( nLinFin + nAddLin, nTCol1, "PEDIDO COMPRA CLIENTE:  "+GetAdvFVal("SC5","C5_UNUCOCL",xFilial("SC5") + aMaestro[15],1,""), oFont10 ) //Pedido Compra del Cliente													//Codigo Control
	EndIf

	oPrn:Say( 2920, 1070, "CODIGO DE CONTROL:  "+aMaestro[12] ,oFont12N ) 													//Codigo Control
	oPrn:Say( 2980, 1070, "Fecha Limite de Emision:  "+DTOC(STOD(aMaestro[13])) ,oFont12N ) 													//Nombre
	oPrn:Say( 3100, 110, "''ESTA FACTURA CONTRIBUYE AL DESARROLLO DEL PAÍS. EL USO ILÍCITO DE ÉSTA SERÁ SANCIONADO DE ACUERDO A LEY''" ,oFont08N )
	oPrn:Say( 3130, 110,aMaestro[20],oFont08N)
	oPrn:Say( 3150, nDCol5 + 80,AllTrim(str(nNroPag)) + " de " + AllTrim(str(nNroTotPag)) ,oFont10 ) 								//Nro Factura
	//	oPrn:Say( 3150, 570, "Ley No 453: Los productos deben suministrarse en condiciones de inocuidad, calidad y seguridad" ,oFont09 ) 													//Nombre

	qr := AllTrim(SM0->M0_CGC) +"|"  			                       //NIT EMPRESA
	qr += AllTrim(str(val(aMaestro[3]))) +"|" 	                       //NUMERO DE FACTURA
	qr += AllTrim(aMaestro[4]) +"|"                                    //NUMERO DE AUTORIZACION
	qr += DTOC(STOD(aMaestro[5])) +"|"                                 //FECHA DE EMISION
	qr += AllTrim(Transform(aMaestro[9],"@A 99,999,999,999.99")) +"|" //MONTO TOTAL CONSIGNADO EN LA FACTURA
	qr += AllTrim(Transform(aMaestro[11],"@A 99,999,999,999.99")) +"|" //IMPORTE BASE PARA CREDITO FISCAL
	qr += AllTrim(aMaestro[12]) +"|"                                   //CODIGO DE CONTROL
	qr += AllTrim(aMaestro[7])+"|"                    			  	   //NIT DEL COMPRADOR
	qr += "0" +"|"                                                     //IMPORTE ICE/ IEHD / TASAS
	qr += "0" +"|"                                                     //IMPORTE POR VENTAS NO GRAVADAS O GRAVADAS A TASA CERO
	qr += "0" +"|"                                                     //IMPORTE NO SUJETO A CREDITO FISCAL
	qr += "0"

	cFile = u_TDEPQR(qr) //llama al qrtdep

	oPrn:SayBitmap(2780,2070,cFile,300,300)

	oPrn:EndPage()
	
	oDelete:setFile(cFile) // carga rutas de los archivos para despues borrar
Return Nil

static function FatDet (cDoc,cSerie,cClient) // Datos detalle de factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT D2_PEDIDO,D2_ITEMPV,D2_ITEM,B1_COD,B1_ESPECIF,B1_UESPEC2,B1_UM,D2_QUANT,D2_PRCVEN,D2_LOTECTL,D2_TOTAL "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"'  AND D2_CLIENTE='" +cClient + "' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"ORDER BY D2_PEDIDO,D2_ITEMPV,D2_ITEM"
	//Aviso("cSql",cSql,{"OK"},,,,,.T.)

	nTotDes2	:= 0
	nTotLote	:= 0
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	While !Eof()
		cProducto	:= B1_COD
		cNombre		:= B1_ESPECIF
		cNombre2	:= B1_UESPEC2
		cUM	        := B1_UM
		nCant		:= D2_QUANT
		nPrecio		:= ROUND(xMoeda(D2_PRCVEN,nMoeFac,nMoedax,dEmiss,4),2)
		nTotal		:= ROUND(xMoeda(D2_TOTAL,nMoeFac,nMoedax,dEmiss,4),2)
		cLote		:= D2_LOTECTL
		If !Empty(cNombre2)
			nTotDes2 += 1
		EndIf
		If !Empty(cLote)
			nTotLote += 1
		EndIf
		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,cUM)   	    //3
		AADD(aDupla,nCant)      //4
		AADD(aDupla,nPrecio)    //5
		AADD(aDupla,nTotal)     //6
		AADD(aDupla,cNombre2)   //7
		AADD(aDupla,cLote)      //8
		AADD(aDatos,aDupla)
		DbSkip()
	end do
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
return  aDatos

Static Function UpCntFat(cNroFat,cSerie,cClient,cFilVta,cEspecie)
	Local bSw	:= .F.
	Local cSql	:= ""
	Local nSql	:= 0
	cSql	:=cSql+ "Update " + RetSqlName("SF2") +" Set "
	cSql	:=cSql+ "F2_UNROIMP = F2_UNROIMP +1 "
	cSql	:=cSql+ "Where "
	cSql	:=cSql     +"F2_DOC		= '"+cNroFat+"'  And "
	cSql	:=cSql     +"F2_SERIE	= '"+cSerie+"' 	 And "
	cSql	:=cSql     +"F2_CLIENTE	= '"+cClient+"'	 And "
	cSql	:=cSql     +"F2_FILIAL	= '"+cFilVta+"'	 And "
	cSql	:=cSql     +"F2_ESPECIE	= '"+cEspecie+"' And "
	cSql	:=cSql     +RetSqlName("SF2") +".D_E_L_E_T_ = ' ' "
	nSql	:=TCSQLExec(cSql)
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

Static function fecha(_dFecha)
	Local _cFecha
	Local _nMes

	_cFecha :=  SubStr(_dFecha,7,2) + " DE "
	_nMes := Val(SubStr(_dFecha,5,2))
	Do Case
		Case _nMes == 1
		_cFecha += "ENERO"
		Case _nMes == 2
		_cFecha += "FEBRERO"
		Case _nMes == 3
		_cFecha += "MARZO"
		Case _nMes == 4
		_cFecha += "ABRIL"
		Case _nMes == 5
		_cFecha += "MAYO"
		Case _nMes == 6
		_cFecha += "JUNIO"
		Case _nMes == 7
		_cFecha += "JULIO"
		Case _nMes == 8
		_cFecha += "AGOSTO"
		Case _nMes == 9
		_cFecha += "SEPTIEMBRE"
		Case _nMes == 10
		_cFecha += "OCTUBRE"
		Case _nMes == 11
		_cFecha += "NOVIEMBRE"
		Case _nMes == 12
		_cFecha += "DICIEMBRE"
	EndCase
	_cFecha += " DE " + SubStr(_dFecha,1,4)
return _cFecha

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

