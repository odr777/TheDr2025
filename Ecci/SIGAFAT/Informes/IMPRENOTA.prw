#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPRENTA  ³Erick Etcheverry		 	º Data ³  22/02/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ EMISION DE NOTA DE ENTREGA PARA CIMA              	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Emision de facturas de Salida Nacional                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIMA 											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPRENTA(cxNro1,cxNro2,cxSerie,nLinInicial)  //U_GFATI301()
	FatLocal('Factura De Salida Local',.F.,cxNro1,cxNro2,cxSerie,nLinInicial)
	//	FatLocal('Factura De Salida Local',.F.,'000000000003','000000000003','A',1)
Return nil

Static function FatLocal(cTitulo,bImprimir,cNroFat1,cNroFat2,cSerie,nLinInicial)
	Private oPrn    := NIL
	Private oFont10  := NIL
	Private lPrevio	:=.T.
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
	FatMat(cNroFat1,cNroFat2,cSerie,cTitulo,bImprimir,1,nLinInicial) //Impresion de factura
	//Ms_Flush()
	//If lPrevio
	//	oPrn:Preview()
	//End If
	//oPrn:End()
return Nil

static function FatMat(cDoc1,cDoc2,cSerie,cTitulo,bImprimir,nCopia,nLinInicial) //Datos Maestro de factura; ,nLinInicial
	Local aDupla   := {}
	Local aDetalle := {}
	Local nCantReg := 0
	Local bSw	   := .T.
	Local cMsgFat  := ""
	Local NextArea := GetNextAlias()
	Local cDireccion := ""
	Local cTelefono := ""
	Local cFilFact := ""
	LOCAL ccond := ""
	local cDescri := ""
	local cFile := ""
	LOCAL cLocal:= ""
	local cVend := ""

	Local cSql	:= "SELECT F2_FILIAL,D2_LOCAL,F2_SERIE,F2_TXMOEDA,F2_MOEDA,F2_DOC,F2_NUMAUT,F2_EMISSAO,F2_COND,F2_VALMERC,F2_VALBRUT,ROUND(F2_DESCONT,2) F2_DESCONT,F2_BASIMP1,F2_CODCTR,A1_MUN, A1_BAIRRO,A1_NOME"
	cSql		:= cSql+",A1_END,F2_CLIENTE,F2_LOJA,F2_ESPECIE,F2_VEND1,D2_PEDIDO"
	cSql		:= cSql+" FROM " + RetSqlName("SF2 ") +" SF2 JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND SF2.D_E_L_E_T_ =' ' AND SA1.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" JOIN " + RetSqlName("SD2") +" SD2 ON (D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_LOJA=F2_LOJA AND D2_ITEM='01' AND D2_ESPECIE=F2_ESPECIE AND SD2.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" WHERE F2_FILIAL='" + xFilial("SF2") + "' AND  F2_DOC='"+cDoc1+"' AND F2_SERIE='"+cSerie+"' AND F2_ESPECIE='RFN' Order By F2_DOC"

//	Aviso("",cSql,{'ok'},,,,,.t.)
	//FALTA EL AND DE FILIAL F2_FILIAL XFILIAL(SF2)
	//	SELECT F2_FILIAL,F2_SERIE,F2_DOC,F2_NUMAUT,F2_EMISSAO,F2_COND,F2_VALFAT,F2_VALBRUT,
	//ROUND(F2_DESCONT,2) F2_DESCONT,F2_BASIMP1,F2_CODCTR,A1_MUN, A1_BAIRRO
	//,F2_CLIENTE,F2_LOJA,F2_ESPECIE,F2_VEND1
	//FROM  SF2990 JOIN  SA1990
	//ON (A1_COD=F2_CLIENTE AND (F2_DOC= '010101000001')AND F2_SERIE='REM' AND A1_LOJA=F2_LOJA AND F2_ESPECIE='RFN' )
	//JOIN SD2990 ON (D2_FILIAL=F2_FILIAL AND D2_LOJA=F2_LOJA AND D2_DOC=F2_DOC AND F2_SERIE=D2_SERIE AND D2_ITEM='01')
	//ORDER BY F2_DOC

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
	

	While !Eof()
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
			AADD(aDupla,A1_END)		    //18
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

			aDetalle:=FatDet (F2_DOC,F2_SERIE,aDupla[1])                	   	//Datos detalle de factura
			nCantReg:=len(aDetalle)
			If nCantReg <= 33
				cFilFact := aDupla[1]

				//alert(SM0->(dbSeek( SM0->M0_CODIGO + SM0->M0_CODFIL )))
				//
				//				DbSelectArea("SM0")
				//					SM0->(DBSETORDER(1))
				//					SM0->(DbSeek(cFilFact))
				//cFilFact := "0102"
				//cFilFact := "0102"	//alert
				oBrush := TBrush():New(,CLR_HGRAY)

				If (AllTrim(cFilFact) == "0101")
					oBrush := TBrush():New(,Rgb(219,219,219))
					cFile := "LogoMarkas"

				EndIf
				If (AllTrim(cFilFact) == "0102")
					oBrush := TBrush():New(,Rgb(219,219,219))
					cFile := "Logo Easy Home"
				EndIf

				cDireccion := AllTrim(SM0->M0_ENDENT)
				cTelefono := "Telefono: "+AllTrim(SM0->M0_TEL)+If(!Empty(SM0->M0_FAX)," Fax: "+AllTrim(SM0->M0_FAX),"")

				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"ORIGINAL",cDireccion,cTelefono,oBrush,cFile)    	//Imprimir Factura
				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA ALMACEN",cDireccion,cTelefono,oBrush,cFile)	    	//Imprimir Factura
				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA ARCHIVO",cDireccion,cTelefono,oBrush,cFile)	    	//Imprimir Factura
				FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA CONTABILIDAD",cDireccion,cTelefono,oBrush,cFile)	    	//Imprimir Factura
				//Static Function UpCntFat(cNroFat,cSerie,cFilVta,cEspecie)
				//UpCntFat(aDupla[3],aDupla[2],aDupla[1],'NF')
			Else
				MsgInfo ("AVERTENCIA: Este formato solo permite 33 Items, usted tiene "+CValToChar(nCantReg)+".... Favor elija otro formato o modifique la factura")
			EndIf
			dbSelectArea(NextArea)
			aDupla:={}
		EndIf
		DbSkip()
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
	Local _nInterLin := 880
	Local aInfUser := pswret()
	Local nI:=0
	//	Local nItemFact:=33
	Local nDim:=0
	Default nLinInicial := 0

	nDim:=len(aDetalle)

	CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono,oBrush,cFile)
	_nInterLin += nLinInicial

	For nI:=1 to nDim
		oPrn:Say(_nInterLin,100,aDetalle[nI][1],oFont10) //Codigo del Producto
		oPrn:Say(_nInterLin,480,aDetalle[nI][2],oFont10)  //Descripcion
		//oPrn:Say(_nInterLin,1465,aDetalle[nI][3],oFont10) //unidad medida
		oPrn:Say(_nInterLin,1680,FmtoValor(aDetalle[nI][4],10,0),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,1870,FmtoValor(aDetalle[nI][5],14,2),oFont10)  //Precio Unitario
		oPrn:Say(_nInterLin,2130,FmtoValor(aDetalle[nI][6],16,2),oFont10)  //Total
		/*		oPrn:Say(_nInterLin,1850,TRANSFORM(aDetalle[nI][4],"@E 99,999,999"),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,2100,TRANSFORM(aDetalle[nI][5],"@E 99,999,999.99"),oFont10) //Precio Unitario
		oPrn:Say(_nInterLin,2360,TRANSFORM(aDetalle[nI][6],"@E 999,999,999.99"),oFont10) //Total
		*/
		_nInterLin:=_nInterLin+50
	Next

	PieFact(nLinInicial,aMaestro)
return nil

Static Function CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono,oBrush,cFile)
	Local cFecVen := ""
	Local nInDe
	//oPrn:StartPage()
	fImpCab(cFile,cDireccion,cTelefono)
	oPrn:FillRect({nLinInicial + 155, 1700, 325, 2370}, oBrush)
	oPrn:Box( nLinInicial + 155 , 1700 ,  325 , 2370 )//box fecha
	oPrn:Say( nLinInicial + 185, 1800,"Fecha: " ,oFont12N ) //FECHA
	oPrn:Say( nLinInicial + 185, 2045,DTOC(STOD(aMaestro[5])) ,oFont12 ) //Fecha Factura
	oPrn:Say( nLinInicial + 250, 1800,"T.C. "  ,oFont12N )//TIPO CAMBIO
	oPrn:Say( nLinInicial + 250, 2045,transform(aMaestro[23],"@E 999,999.99"),oFont12N )

	// 	oPrn:Say( nLinInicial + 330, 0100,cDireccion  ,oFont08 )
	//	oPrn:Say( nLinInicial + 360, 0100,cTelefono  ,oFont08 )
	if(cTipo <> 'ORIGINAL')
		oPrn:Say( nLinInicial + 300, 880,cTipo ,oFont12N )//ORIGINAL COPIA
	else
		oPrn:Say( nLinInicial + 300, 1100,cTipo ,oFont12N )//ORIGINAL COPIA
	endif

	oPrn:Say( nLinInicial + 370, 770,"NOTA   DE   ENTREGA   NRO.",oFont12N )//nota
	oPrn:Say( nLinInicial + 370, 1410,alltrim(str(val(aMaestro[3]))) ,oFont12N ) //Nro Factura

	oPrn:Box( nLinInicial + 430 , 80 ,  780 , 2370 )
	oPrn:Box( nLinInicial + 430 , 1510 ,  640 , 1510 )

	oPrn:Say( nLinInicial + 450, 100,"CLIENTE",oFont12N ) // Cliente
	//oPrn:Say( nLinInicial + 450, 100,aMaestro[20] + "  -  " + aMaestro[21],oFont12N ) // Codigo del Cliente
	oPrn:Say( nLinInicial + 450, 1570,"Condiciones de Venta: " ,oFont12N )// condiciones
	oPrn:Say( nLinInicial + 450, 2050,Iif(aMaestro[8]=="002","CONTADO","CREDITO") ,oFont12 ) // credito etc

	oPrn:Say( nLinInicial + 510, 100,"Nombre: " ,oFont12N )
	oPrn:Say( nLinInicial + 510, 290,aMaestro[6] ,oFont12 ) // Nombre del Cliente
	oPrn:Say( nLinInicial + 510, 1570,"Plazo (Dias) : " ,oFont12N )//plazo dias
	oPrn:Say( nLinInicial + 510, 1900,aMaestro[24] ,oFont12 )

	oPrn:Say( nLinInicial + 570, 100, "Codigo: " ,oFont12N )
	oPrn:Say( nLinInicial + 570, 290, aMaestro[20] ,oFont12 ) //cod del Cliente
	oPrn:Say( nLinInicial + 570, 1570, "Vendedor: " ,oFont12N ) 	//vendedor
	oPrn:Say( nLinInicial + 570, 1900,aMaestro[25],oFont12 ) //

	oPrn:Box( nLinInicial + 640 , 80 ,  640 , 2370 )

	oPrn:Say( nLinInicial + 660, 100,"DIRECCION: " ,oFont12N )
	oPrn:Say( nLinInicial + 665, 375,aMaestro[18] ,oFont10 ) //Direccion Factura
	oPrn:Say( nLinInicial + 660, 1570,"Almacen: " ,oFont12N )
	oPrn:Say( nLinInicial + 660, 2050,aMaestro[19] ,oFont12 ) //Fecha del Pedido
	oPrn:Say( nLinInicial + 715, 1780,aMaestro[26] ,oFont12 ) //Fecha del Pedido
	//oPrn:Say( nLinInicial + 660, 2145,cFecVen ,oFont12 ) //Fecha del Pedido
	//	oPrn:Say( nLinInicial + 700, 1725,"Vendedor:" ,oFont12 )
	//	oPrn:Say( nLinInicial + 700, 2120,"Marcelo Huertas:" ,oFont12 )

	oPrn:Say( nLinInicial + 715, 100,aMaestro[16]+ "  " + AllTrim(aMaestro[17]) ,oFont10 )
	//oPrn:Say( nLinInicial + 715, 360,aMaestro[17] ,oFont10 ) //Fecha Factura

	oPrn:Box(nLinInicial + 785 , 80 ,  2560 , 2370 )
	oPrn:fillRect({nLinInicial + 780, 81, 860, 2370}, oBrush)

	oPrn:Say(nLinInicial + 800, 110, "CODIGO" ,oFont11N )													//Nombre
	oPrn:Say(nLinInicial + 800, 480, "DESCRIPCION DEL PRODUCTO" ,oFont11N ) 													//Nombre
	//oPrn:Say(nLinInicial + 800, 1460, "UNIDAD" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 800, 1680, "CANT" ,oFont10N ) 													//Nombre
	oPrn:Say(nLinInicial + 800, 1870, "PREC.UNIT" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 800, 2130, "SUBTOTAL" ,oFont11N ) 													//Nombre

	oPrn:Box( nLinInicial + 860 , 80 ,  860 , 2370 )

	oPrn:Box( nLinInicial + 785 , 0475 ,  2560 , 0475 )

	//oPrn:Box( nLinInicial + 785 , 1450 ,  2560 , 1450 )
	oPrn:Box( nLinInicial + 785 , 1670 ,  2560 , 1670 )
	oPrn:Box( nLinInicial + 785 , 1860 ,  2560 , 1860 )
	oPrn:Box( nLinInicial + 785 , 2120 ,  2560 , 2120 )

Return Nil

Static Function PieFact(nLinInicial,aMaestro)
	Local nTotGral := 0
	cMoeda := "Bolivianos"
	if(aMaestro[15] == 2)
		cMoeda := "Dolares"
	endif

	oPrn:Say( nLinInicial + 2580, 100, "Son: "+Extenso(aMaestro[11],.F.,1)+ upper(cMoeda) ,oFont11N ) 							//Total  Escrito

	// 	oPrn:Box( nLinInicial + 2630 , 810 ,  2780 , 1170 )
	// 	oPrn:Box( nLinInicial + 2700 , 810 ,  2700 , 1170 )
	//
	// 	oPrn:Box( nLinInicial + 2630 , 1210 ,  2780 , 1570 )
	// 	oPrn:Box( nLinInicial + 2700 , 1210 ,  2700 , 1570 )
	//
	// 	oPrn:Box( nLinInicial + 2630 , 1610 ,  2780 , 1970 )
	// 	oPrn:Box( nLinInicial + 2700 , 1610 ,  2700 , 1970 )

	oPrn:Box( nLinInicial + 2630 , 2010 ,  2780 , 2370 )
	oPrn:Box( nLinInicial + 2700 , 2010 ,  2700 , 2370 )

	//oPrn:Say(nLinInicial + 2670, 0100, aMaestro[19] ,oFont12 ) //Usuario que generó la factura

	//	oPrn:Say(nLinInicial + 2640, 870, "Total General" ,oFont12N ) 													//Codigo Control
	//	oPrn:Say(nLinInicial + 2640, 1270, "% Descuento" ,oFont12N ) 													//Codigo Control
	//	oPrn:Say(nLinInicial + 2640, 1690, "Descuentos" ,oFont12N ) 													//Codigo Control
	oPrn:Say(nLinInicial + 2640, 2020, "Total "+ cMoeda ,oFont12N ) 													//Codigo Control

	//	nTotGral := Round(aMaestro[9]+aMaestro[10],2)
	//	oPrn:Say(nLinInicial + 2710, 0100, Time() ,oFont12 ) //Hora en que se imprimió la factura
	//	oPrn:Say(nLinInicial + 2710, 0860, TRANSFORM(nTotGral,"@E 9,999,999,999.99") ,oFont12N ) //Total General
	//	oPrn:Say(nLinInicial + 2710, 1300, TRANSFORM(Round((aMaestro[10]/nTotGral)*100,2),"@E 9,999,999,999.99") ,oFont12N ) //% Descuento
	//	oPrn:Say(nLinInicial + 2710, 1660, TRANSFORM(aMaestro[10],"@E 9,999,999,999.99") ,oFont12N ) //Descuentos

	oPrn:Say(nLinInicial + 2710, 2060, TRANSFORM(aMaestro[11],"@E 9,999,999,999.99") ,oFont12N )  //Total Bolivianos

	oPrn:Say(nLinInicial + 2670, 0100, "F:"+AllTrim(aMaestro[2])+"-"+Right(AllTrim(aMaestro[3]), 6) ,oFont12 )  //Serie + Factura
	oPrn:Say(nLinInicial + 2770, 0100, "Usr: " + cUserName + "  " + time(),oFont12 )  //Usuario

	// 	oPrn:Box( nLinInicial + 2880 , 940 ,  2950 , 1830 )
	//	oPrn:Say(nLinInicial + 2890, 970, "CODIGO DE CONTROL:  "+aMaestro[12] ,oFont12N ) 													//Codigo Control
	// 	oPrn:Box( nLinInicial + 2970 , 940 ,  3040 , 1830 )
	//	//oPrn:Say(nLinInicial + 2980, 970, "Fecha Limite de Emision:  "+DTOC(STOD(aMaestro[13])) ,oFont12N ) 													//Nombre

	oPrn:Say(nLinInicial + 3000, 100, "_________________________" ,oFont12N ) 													//Nombre
	oPrn:Say(nLinInicial + 3040, 250, "Almacen" ,oFont12N ) 													//Nombre
	oPrn:Say(nLinInicial + 3000, 900, "_________________________" ,oFont12N ) 													//Nombre
	oPrn:Say(nLinInicial + 3040, 1030, "Vendedor" ,oFont12N )
	oPrn:Say(nLinInicial + 3000, 1700, "________________________" ,oFont12N ) 													//Nombre
	oPrn:Say(nLinInicial + 3040, 1800, "Recibi Conforme" ,oFont12N )

	//oPrn:Say(nLinInicial + 3100, 090, "''ESTA FACTURA CONTRIBUYE AL DESARROLLO DEL PAIS. EL USO ILICITO DE ESTA SERA SANCIONADO DE ACUERDO A LEY''" ,oFont10N)

	//	qr := AllTrim(SM0->M0_CGC) +"|"  			                       //NIT EMPRESA
	//	qr += AllTrim(str(val(aMaestro[3]))) +"|" 	                       //NUMERO DE FACTURA
	//	qr += AllTrim(aMaestro[4]) +"|"                                    //NUMERO DE AUTORIZACION
	//	qr += DTOC(STOD(aMaestro[5])) +"|"                                 //FECHA DE EMISION
	//	qr += AllTrim(Transform(nTotGral,"@E 99,999,999,999.99")) +"|"     //MONTO TOTAL CONSIGNADO EN LA FACTURA
	//	qr += AllTrim(Transform(aMaestro[11],"@E 99,999,999,999.99")) +"|" //IMPORTE BASE PARA CREDITO FISCAL
	//	qr += AllTrim(aMaestro[12]) +"|"                                   //CODIGO DE CONTROL
	//	qr += AllTrim(aMaestro[7])+"|"                    			  	   //NIT DEL COMPRADOR
	//	qr += "0" +"|"                                                     //IMPORTE ICE/ IEHD / TASAS
	//	qr += "0" +"|"                                                     //IMPORTE POR VENTAS NO GRAVADAS O GRAVADAS A TASA CERO
	//	qr += "0" +"|"                                                     //IMPORTE NO SUJETO A CREDITO FISCAL
	//	qr += AllTrim(Transform(aMaestro[10],"@E 99,999,999,999.99"))       //DESCUENTOS, BONIFICACIONES Y REBAJAS OBTENIDAS
	//	U_QRTDEP(oPrn,2800,2070,300,300,qr)
	oPrn:EndPage()

Return Nil

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

//Static Function UpCntFat(cNroFat,cSerie,cFilVta,cEspecie)
//	Local bSw	:= .F.
//	Local cSql	:= ""
//	Local nSql	:= 0
//	cSql	:=cSql+ "Update " + RetSqlName("SF2") +" Set "
//	cSql	:=cSql+ "F2_UNROIMP = F2_UNROIMP +1 "
//	cSql	:=cSql+ "Where "
//	cSql	:=cSql + "F2_DOC		= '"+cNroFat+"'  And "
//	cSql	:=cSql + "F2_SERIE	= '"+cSerie+"' 	 And "
//	cSql	:=cSql + "F2_FILIAL	= '"+cFilVta+"'	 And "
//	cSql	:=cSql + "F2_ESPECIE	= '"+cEspecie+"' And "
//	cSql	:=cSql + RetSqlName("SF2") +".D_E_L_E_T_ = ' ' "
//	If ( nSql >=0)
//		bSw:=.T.
//	EndIf
//Return bSw

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
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal

Static Function fImpCab(cFile,cDireccion,cTelefono)// modifica mi cabecera
	oPrn:StartPage() 			//Inicia una nueva pagina
	nNroCol 	:= 100
	cFLogo 		:= GetSrvProfString("Startpath","") + "/"+cFile+".bmp" // imprime logo

	//cFLogo 		:= GetSrvProfString("Startpath","") + "/Logo Easy Home.bmp" // imprime logo

	nNroLin 	:= 130
	oPrn:SayBitmap(nNroLin,nNroCol-10,cFLogo,200,230)
	oPrn:Say( nNroLin + 225, 100,cDireccion  ,oFont08 )
	oPrn:Say( nNroLin + 250, 100,cTelefono  ,oFont08 )

	return nil

return