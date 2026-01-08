#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ FACTMEDC ³ Erick Etcheverry	 º Data ³ 22/03/17º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emision de Factura de salida con Codigo QR   media carta    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Emision de facturas de Salida Nacional                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIMA					query: Erick Etcheverry               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NOTAMED(cxNro1,cxNro2,cxSerie,nLinInicial)
	FatLocal('Factura De Salida Local',.F.,cxNro1,cxNro2,cxSerie,nLinInicial)
Return nil

Static function FatLocal(cTitulo,bImprimir,cNroFat1,cNroFat2,cSerie,nLinInicial)
	Private oPrn    := NIL
	Private oFont10  := NIL
	Private nTotPags := 1
	private oDelete := delFiles():new()
	private lFis

	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetCurrentPrinterInUse()
	oPrn:SetPortrait()
	oPrn:setPaperSize(DMPAPER_LETTER)

	DEFINE FONT oFont08 NAME "Arial" SIZE 0,08 OF oPrn
	DEFINE FONT oFont08N NAME "Arial" SIZE 0,08 Bold OF oPrn
	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 OF oPrn
	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oFont10N NAME "Arial" SIZE 0,10 Bold  OF oPrn
	DEFINE FONT oFont105N NAME "Arial" SIZE 0,10.5 Bold  OF oPrn
	DEFINE FONT oFont11N NAME "Arial" SIZE 0,11 Bold  OF oPrn
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
	DEFINE FONT oFont12N NAME "Arial" SIZE 0,12 Bold  OF oPrn
	FatMat(cNroFat1,cNroFat2,cSerie,cTitulo,bImprimir,1,nLinInicial) //Impresion de factura
return Nil

static function FatMat(cDoc1,cDoc2,cSerie,cTitulo,bImprimir,nCopia,nLinInicial)
	Local aDupla   := {}
	Local aDetalle := {}
	Local nCantReg := 0
	Local bSw	   := .T.
	Local cMsgFat  := ""
	Local NextArea := "MYVWSF2"
	Local cDireccion := ""
	LOCAL ccond := ""
	local cDescri := ""
	Local cTelefono := ""
	Local cFilFact := ""
	LOCAL cPedid := ""
	local aDados

	Local cSql	:= "SELECT F2_FILIAL,D2_LOCAL,F2_SERIE,D2_UOBSERV,F2_TXMOEDA,F2_MOEDA,F2_DOC,F2_NUMAUT,F2_EMISSAO,F2_COND,F2_VALMERC,F2_VALBRUT,ROUND(F2_DESCONT,2) F2_DESCONT,F2_BASIMP1,F2_CODCTR,A1_MUN, A1_BAIRRO,A1_NOME"
	cSql		:= cSql+",A1_END,F2_CLIENTE,F2_LOJA,F2_ESPECIE,F2_VEND1,D2_PEDIDO,C5_UOBSERV"
	cSql		:= cSql+" FROM " + RetSqlName("SF2 ") +" SF2 JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND SF2.D_E_L_E_T_ =' ' AND SA1.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" JOIN " + RetSqlName("SD2") +" SD2 ON (D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_LOJA=F2_LOJA AND D2_ITEM='01' AND D2_ESPECIE=F2_ESPECIE AND SD2.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" JOIN " + RetSqlName("SC5") +" SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ' ' "
	cSql		:= cSql+" WHERE F2_FILIAL='" + xFilial("SF2") + "' AND  F2_DOC='"+cDoc1+"' AND F2_SERIE='"+cSerie+"' AND F2_ESPECIE='RFN' Order By F2_DOC"

	If Select("MYVWSF2") > 0  //En uso
		MYVWSF2->(DbCloseArea())
	End
	If __CUSERID = '000000' .OR. cUserName = 'nterrazas' .OR. cUserName = 'jbravo'
		Aviso("",cSql,{'ok'},,,,,.t.)	
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)

	dbGoTop()
	If !Empty(D2_PEDIDO)
		ccond  := GETADVFVAL("SC5","C5_CONDPAG",XFILIAL("SF2")+D2_PEDIDO,1,"")//condicion de pago
	ENDIF
	If !Empty(D2_PEDIDO)
		cDescri  := GETADVFVAL("SE4","E4_DESCRI",XFILIAL("SE4")+ ccond,1,"")//descripcion cnd pago
	ENDIF
	If !Empty(D2_LOCAL)
		cLocal  := GETADVFVAL("NNR","NNR_DESCRI",XFILIAL("SF2")+D2_LOCAL,1,"")//descripcion cnd pago
	ENDIF
	If !Empty(F2_VEND1)
		cVend  := GETADVFVAL("SA3","A3_NOME",XFILIAL("SA3")+F2_VEND1,1,"")//descripcion cnd pago
	ENDIF

	While !(NextArea)->(Eof())
		bSw		:= .T.
		//		If (F2_UNROIMP>0)
		//			If (VldImpFat()==.F.)
		//				bSw		:= .F.
		//				cMsgFat := cMsgFat+AllTrim(F2_DOC)+";"
		//			EndIf
		//		EndIf

		If ( bSw == .T.)
			AADD(aDupla,F2_FILIAL)		  	//1
			AADD(aDupla,F2_SERIE)           //2
			AADD(aDupla,F2_DOC)             //3
			//AADD(aDupla,F2_NUMAUT)          //4
			AADD(aDupla,"D")          //4
			AADD(aDupla,F2_EMISSAO)         //5
			//			AADD(aDupla,F2_UNOMCLI)
			AADD(aDupla,A1_NOME)         //6
			//AADD(aDupla,F2_UNITCLI)
			AADD(aDupla,"DAS")         //7
			AADD(aDupla,ccond)            //8
			AADD(aDupla,F2_VALBRUT)          //9
			AADD(aDupla,F2_DESCONT)         //10
			AADD(aDupla,F2_VALMERC)  		//11
			AADD(aDupla,F2_CODCTR)          //12
			AADD(aDupla,"fpdataval")          //13
			//AADD(aDupla,FP_DTAVAL)
			//AADD(aDupla,F2_UNROIMP)		    //14
			AADD(aDupla,"DS")
			//			AADD(aDupla,D2_PEDIDO)		    //15
			AADD(aDupla,F2_MOEDA)
			AADD(aDupla,A1_MUN)		    	//16
			AADD(aDupla,A1_BAIRRO)		    //17
			//			AADD(aDupla,A1_END)		    //18 //
			AADD(aDupla,SM0->M0_ENDENT)		    //18 // NT 03/18

			AADD(aDupla,D2_LOCAL)		    //19
			AADD(aDupla,F2_CLIENTE)		    //20
			AADD(aDupla,F2_LOJA)		    //21
			AADD(aDupla,F2_ESPECIE)		    //22
			AADD(aDupla,F2_TXMOEDA)			    //23 tasa
			//AADD(aDupla,FP_SFC)			    //23
			//AADD(aDupla,F2_UAUTPRC)			//24
			AADD(aDupla,cDescri)			//24
			AADD(aDupla,cVend)			//25 //vendedor
			AADD(aDupla,cLocal)			//26
			AADD(aDupla,D2_UOBSERV)			//27
			AADD(aDupla,C5_UOBSERV)			//28
			//alert((NextArea)->F2_DOC)
			aDetalle:=FatDet (F2_DOC,F2_SERIE,aDupla[1])                	   	//Datos detalle de factura

			nCantReg := len(aDetalle)
			if nCantReg >= 6
				MsgAlert("Demasiados items, por favor imprima con el otro formato")
				dBCloseArea(NextArea)
				oPrn:End()
				return
			endif

			cFilFact := aDupla[1]

			oBrush := TBrush():New(,CLR_HGRAY)

			// NTP 15/03
			oBrush := TBrush():New(,Rgb(219,219,219))
			cFile := "Logo" + AllTrim(cFilFact)

			cDireccion := "" // AllTrim(SM0->M0_ENDENT) NT 18/03/2019
			cTelefono := "Telefono: "+AllTrim(SM0->M0_TEL)+If(!Empty(SM0->M0_FAX)," Fax: "+AllTrim(SM0->M0_FAX),"")

			FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"ORIGINAL",cDireccion,cTelefono,oBrush,cFile)    	//Imprimir Factura
			FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA ALMACEN",cDireccion,cTelefono,oBrush,cFile)	    	//Imprimir Factura
			FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA ARCHIVO",cDireccion,cTelefono,oBrush,cFile)	    	//Imprimir Factura
			FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA CONTABILIDAD",cDireccion,cTelefono,oBrush,cFile)	    	//Imprimir Factura

			dbSelectArea(NextArea)
			aDupla:={}
		EndIf
		(NextArea)->(DbSkip())
	EndDo
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF

	oPrn:Refresh()
	If bImprimir
		oPrn:Print()
	Else
		oPrn:Preview()
	End If
	oPrn:End()

return aDupla

static function FatImp(cTitulo,bImprimir,aMaestro,aDetalle,nLinInicial,cTipo,cDireccion,cTelefono,oBrush,cFile)
	Local _nInterLin := 720
	Local aInfUser := pswret()
	Local nI:=0
	Local nItemFact:= 37
	Local nDim:=0
	Default nLinInicial := 0
	Private nCont := 0
	nDim:=len(aDetalle)
	//alert(nDim)

	CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono,oBrush,cFile)
	_nInterLin += nLinInicial

	For nI:=1 to nDim
		oPrn:Say(_nInterLin,110,aDetalle[nI][1],oFont08) //Codigo del Producto
		oPrn:Say(_nInterLin,410,aDetalle[nI][2],oFont08)  //Descripcion
		//oPrn:Say(_nInterLin,1465,aDetalle[nI][3],oFont10) //unidad medida
		oPrn:Say(_nInterLin,1530,FmtoValor(aDetalle[nI][4],10,0),oFont08)  //Cantidad
		oPrn:Say(_nInterLin,1790,FmtoValor(aDetalle[nI][5],14,2),oFont08)  //Precio Unitario
		oPrn:Say(_nInterLin,2090,FmtoValor(aDetalle[nI][6],16,2),oFont08)  //Total
		
		_nInterLin:=_nInterLin+40
	Next

	PieFact(nLinInicial,aMaestro)
return

Static Function CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	Local cFecVen := ""
	Local nInDe

	fImpCab(cFile,cDireccion,cTelefono)

	//oPrn:FillRect({nLinInicial + 100, 1548, 325, 2370}, oBrush)
	oPrn:Box( nLinInicial + 100 , 1548 ,  325 , 2370 ) // cuadro nit

	oPrn:Say( nLinInicial + 185, 1800,"Fecha: " ,oFont12N ) //FECHA
	oPrn:Say( nLinInicial + 185, 2045,DTOC(STOD(aMaestro[5])) ,oFont12 ) //Fecha Factura
	oPrn:Say( nLinInicial + 250, 1800,"T.C. "  ,oFont12N )//TIPO CAMBIO
	oPrn:Say( nLinInicial + 250, 2045,transform(aMaestro[23],"@E 999,999.99"),oFont12N )

	// 	oPrn:Say( nLinInicial + 330, 0100,cDireccion  ,oFont08 )
	//	oPrn:Say( nLinInicial + 360, 0100,cTelefono  ,oFont08 )
	oPrn:Say( nLinInicial + 250, 880,SM0->M0_NOMECOM,oFont12N )//nota
	if(cTipo <> 'ORIGINAL')
		oPrn:Say( nLinInicial + 300, 880,cTipo ,oFont12N )//ORIGINAL COPIA
	else
		oPrn:Say( nLinInicial + 300, 1100,cTipo ,oFont12N )//ORIGINAL COPIA
	endif

	oPrn:Say( nLinInicial + 370, 770,"NOTA   DE   ENTREGA   NRO.",oFont12N )//nota
	oPrn:Say( nLinInicial + 370, 1410,alltrim(str(val(aMaestro[3]))) ,oFont12N ) //Nro Factura

	oPrn:Box( nLinInicial + 430 , 80 ,  680 , 2370 )//cuadro cliente
	oPrn:Box( nLinInicial + 430 , 1540 ,  680 , 1540 )//cuadro pedido

	oPrn:Say( nLinInicial + 450, 100,"CLIENTE",oFont10N ) // Cliente
	//oPrn:Say( nLinInicial + 450, 100,aMaestro[20] + "  -  " + aMaestro[21],oFont12N ) // Codigo del Cliente
	oPrn:Say( nLinInicial + 450, 1570,"Condiciones de Venta: " ,oFont08N )// condiciones
	oPrn:Say( nLinInicial + 450, 2050,Iif(aMaestro[8]=="002","CONTADO","CREDITO") ,oFont12 ) // credito etc

	oPrn:Say( nLinInicial + 510, 100,"Nombre: " ,oFont08N )
	oPrn:Say( nLinInicial + 510, 290,aMaestro[6] ,oFont08 ) // Nombre del Cliente
	//oPrn:Say( nLinInicial + 510, 1570,"Plazo (Dias) : " ,oFont08N )//plazo dias
	//oPrn:Say( nLinInicial + 510, 1900,aMaestro[24] ,oFont08 )

	oPrn:Say( nLinInicial + 550, 100, "Codigo: " ,oFont08N )
	oPrn:Say( nLinInicial + 550, 290, aMaestro[20] ,oFont08 ) //cod del Cliente
	oPrn:Say( nLinInicial + 550, 1570, "Vendedor: " ,oFont08N ) 	//vendedor
	oPrn:Say( nLinInicial + 550, 1800,aMaestro[25],oFont08 ) //

	oPrn:Box( nLinInicial + 710 , 80 ,  711 , 2370 )

	oPrn:Say( nLinInicial + 610, 100,"DIRECCION: " ,oFont08N )
	oPrn:Say( nLinInicial + 610, 375,aMaestro[18] ,oFont08 ) //Direccion Factura
	oPrn:Say( nLinInicial + 610, 1570,"Almacen: " ,oFont08N )
	oPrn:Say( nLinInicial + 610, 2050,aMaestro[19] ,oFont08 ) //Fecha del Pedido
	oPrn:Say( nLinInicial + 610, 1780,aMaestro[26] ,oFont08 ) //Fecha del Pedido
	
	oPrn:Say( nLinInicial + 640, 100,"Teléfono : " + AllTrim(SM0->M0_TEL) ,oFont08N ) // NTP 18/03/2019
	oPrn:Say( nLinInicial + 640, 1900, AllTrim(aMaestro[17]) ,oFont08 )

	//oPrn:fillRect({nLinInicial + 636, 81, 641, 2370}, oBrush)
	oPrn:Box( nLinInicial + 600 , 80 ,  1030 , 2370 )

	oPrn:Say(nLinInicial + 680, 110, "CODIGO" ,oFont08N )													//Nombre
	oPrn:Say(nLinInicial + 680, 410, "DESCRIPCION DEL PRODUCTO" ,oFont08N ) 													//Nombre
	//oPrn:Say(nLinInicial + 800, 1460, "UNIDAD" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 680, 1560, "CANT" ,oFont08N ) 													//Nombre
	oPrn:Say(nLinInicial + 680, 1820, "PREC.UNIT" ,oFont08N ) 													//Nombre
	oPrn:Say(nLinInicial + 680, 2130, "SUBTOTAL" ,oFont08N ) 													//Nombre

	//oPrn:Box( nLinInicial + 680 , 80 ,  780 , 2370 )
	//Lineas verticales
	oPrn:Box( nLinInicial + 680 , 0390 ,  1030 , 0390 )
	oPrn:Box( nLinInicial + 680 , 1500 ,  1030 , 1500 )
	oPrn:Box( nLinInicial + 680 , 1700 ,  1030 , 1700 )
	oPrn:Box( nLinInicial + 680 , 2040 ,  1030 , 2040 )

Return Nil

Static Function PieFact(nLinInicial,aMaestro,nCont)
	Local nTotGral := 0
	Local cFile := ""
	cMoeda := "Bolivianos"
	if(aMaestro[15] == 2)
		cMoeda := "Dolares"
	endif

	nLinInicial := - 1541
	oPrn:Say( nLinInicial + 2580, 100, "Son: "+Extenso(aMaestro[11],.F.,1)+ upper(cMoeda) ,oFont11N ) 							//Total  Escrito

	oPrn:Box( nLinInicial + 2630 , 2010 ,  nLinInicial + 2780 , 2370 )
	oPrn:Box( nLinInicial + 2700 , 2010 ,  nLinInicial + 2700 , 2370 )

	oPrn:Say(nLinInicial + 2640, 2020, "Total "+ cMoeda ,oFont11N )
	oPrn:Say(nLinInicial + 2710, 2060, TRANSFORM(aMaestro[11],"@E 9,999,999,999.99") ,oFont11N )  //Total Bolivianos

	oPrn:Say(nLinInicial + 2670, 0100, "F:"+AllTrim(aMaestro[2])+"-"+Right(AllTrim(aMaestro[3]), 6) ,oFont10 )  //Serie + Factura
	oPrn:Say(nLinInicial + 2670, 0700, "Usr: " + cUserName + "  " + time(),oFont10 )  //Usuario
	
	nUax := nLinInicial
	aObs := TexToArray(aMaestro[28],200)
	for i := 1 to len(aObs)
		if i <= 1
			oPrn:Say(nLinInicial + 2790, 0100, "Obs:   " + aObs[i],oFont10 )  //observacion
		else
			oPrn:Say(nLinInicial + 2790, 0100, aObs[i],oFont12 )  //observacion
		endif
		nLinInicial +=40
	next i

	oPrn:Say(nUax + 3000, 100, "_________________________" ,oFont11N ) 													//Nombre
	oPrn:Say(nUax + 3040, 250, "Almacen" ,oFont12N ) 													//Nombre
	oPrn:Say(nUax + 3000, 900, "_________________________" ,oFont11N ) 													//Nombre
	oPrn:Say(nUax + 3040, 1030, "Vendedor" ,oFont12N )
	oPrn:Say(nUax + 3000, 1700, "________________________" ,oFont11N ) 													//Nombre
	oPrn:Say(nUax + 3040, 1800, "Recibi Conforme" ,oFont11N )
	nUax = 0
	oPrn:EndPage()
Return

static function FatDet (cDoc,cSerie,cFillal) // Datos detalle de factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT B1_COD,B1_UM,B1_DESC,D2_LOTECTL,D2_DTVALID,D2_QUANT,CASE WHEN D2_PRUNIT!=0 THEN D2_PRUNIT ELSE D2_PRCVEN END D2_PRUNIT,CASE WHEN D2_PRUNIT!=0 THEN D2_QUANT*D2_PRUNIT ELSE D2_QUANT*D2_PRCVEN END D2_TOTAL, D2_PEDIDO, D2_ITEMPV "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_COD=B1_COD AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"WHERE D2_DOC='"+cDoc+"' AND  D2_SERIE='"+cSerie+"' AND D2_ESPECIE='RFN' AND D2_FILIAL='"+cFillal+"' ORDER BY B1_COD"
	//Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	While !Eof()
		cProducto	:=B1_COD
		cNombre		:=B1_DESC
		cUm			:= B1_UM
		//cPedido		:=D2_PEDIDO
		//cItPedido	:=D2_ITEMPV
		nCant		:=D2_QUANT
		//		If !Empty(cPedido)
		//			nPrecio		:=NoRound(Posicione('SC6',1,xFilial('SC6')+cPedido+cItPedido,'C6_PRCVEN'),6)
		//	    Else
		nPrecio		:=D2_PRUNIT
		//	    End
		nTotal		:=Round(nCant*nPrecio,2)

		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,cUm)      //3
		AADD(aDupla,nCant)      //4
		AADD(aDupla,nPrecio)    //5
		AADD(aDupla,nTotal)     //6
		AADD(aDatos,aDupla)
		DbSkip()
	end do
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
return  aDatos

Static Function fImpCab(cFile,cDireccion,cTelefono)// modifica mi cabecera
	oPrn:StartPage() 			//Inicia una nueva pagina
	nNroCol 	:= 100
	cFLogo 		:= GetSrvProfString("Startpath","") + "/"+cFile+".bmp" // imprime logo

	//cFLogo 		:= GetSrvProfString("Startpath","") + "/Logo Easy Home.bmp" // imprime logo

	nNroLin 	:= 130
	oPrn:SayBitmap(nNroLin,nNroCol-10,cFLogo,200,230)
	oPrn:Say( nNroLin + 225, 100,cDireccion  ,oFont08 )
	//oPrn:Say( nNroLin + 250, 100,cTelefono  ,oFont08 )

	return nil

return

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
	Local 	NextArea	:= "MYVWSE1"

	Local cSql	:= "SELECT TOP 1 E1_VENCREA "
	cSql		:= cSql+" FROM " + RetSqlName("SE1") +" SE1 "
	cSql		:= cSql+" WHERE E1_FILIAL='"+cFil+"' AND E1_NUM='"+cNroDoc+"' AND E1_PREFIXO='"+cPrefijo+"' AND E1_CLIENTE='"+cCliente+"' AND E1_LOJA='"+cLoja+"' AND E1_SALDO <> 0 AND SE1.D_E_L_E_T_=' ' "
	cSql		:= cSql+" ORDER BY E1_PARCELA"

	If Select("MYVWSE1") > 0  //En uso
		MYVWSE1->(DbCloseArea())
	End
	//Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	cFechVcto	:= (NextArea)->E1_VENCREA

Return cFechVcto

Static Function FmtoValor(cVal,nLen,nDec)
	Local cNewVal := ""
	If nDec == 2
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal

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
