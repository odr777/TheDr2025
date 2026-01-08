#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPNCC ณErick Etcheverry Pe๑a		 บ Data ณ  07/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emision de nota de credito   			                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Emision de nota de credito Nacional                     	  บฑฑ
ฑฑฬออออออออออุอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Laboratorios VITA S.A.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IMPNCC(cxNro1,cxNro2,cxSerie,nLinInicial)  //U_GFATI301()
	FatLocal('Factura De Salida Local',.F.,cxNro1,cxNro2,cxSerie,nLinInicial)
	//	FatLocal('Factura De Salida Local',.F.,'000000000003','000000000003','A',1)
Return nil

Static function FatLocal(cTitulo,bImprimir,cNroFat1,cNroFat2,cSerie,nLinInicial)
	Private oPrn    := NIL
	Private oFont10  := NIL
	Private lPrevio	:=.T.
	private oDelete := delFiles():new()
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
	DEFINE FONT oFont11 NAME "Arial" SIZE 0,11  OF oPrn
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
	LOCAL cF2udir := ""
	LOCAL cF2unom := ""
	LOCAL cF2unit := ""
	local cF2vend := ""
	local cnfori := ""
	local ccserie := ""
	Local i

	Local cSql	:= "SELECT F1_FILIAL,F1_SERIE,F1_DOC,F1_NUMAUT,F1_EMISSAO,F1_UNOMBRE,F1_UNIT,F1_COND,F1_VALBRUT,ROUND(F1_DESCONT,2) F1_DESCONT,F1_BASIMP1,F1_CODCTR,FP_DTAVAL,F1_USRREG,D1_PEDIDO,A1_MUN, A1_BAIRRO,A1_END"
	cSql		:= cSql+",F1_FORNECE,F1_LOJA,F1_ESPECIE,'SFP' FP_SFC,F1_VEND1,D1_SERIORI,D1_NFORI FROM(SELECT F1_FILIAL,F1_SERIE,F1_DOC,F1_NUMAUT,F1_EMISSAO,F1_UNOMBRE,F1_UNIT,F1_COND,F1_VALBRUT,ROUND(F1_DESCONT,2) F1_DESCONT,F1_BASIMP1,F1_CODCTR,F1_USRREG,A1_MUN, A1_BAIRRO,A1_END,F1_FORNECE,F1_LOJA,F1_ESPECIE,F1_VEND1"
	cSql		:= cSql+" FROM " + RetSqlName("SF1 ") +" SF1 LEFT JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F1_FORNECE AND A1_LOJA=F1_LOJA AND SA1.D_E_L_E_T_ =' ')WHERE F1_DOC='"+cDoc1+"'  AND F1_SERIE='"+cSerie+"' AND F1_ESPECIE = 'NCC' AND SF1.D_E_L_E_T_ =' ')TAB "
	cSql		:= cSql+" JOIN " + RetSqlName("SD1") +" SD1 ON (D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_LOJA=F1_LOJA AND SD1.D_E_L_E_T_ = ' '  AND D1_ITEM = '0001')"
	cSql		:= cSql+" JOIN " + RetSqlName("SFP") +" SFP ON (FP_SERIE=F1_SERIE AND SFP.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" AND F1_FILIAL='" + xFilial("SF1") + "' "
	cSql		:= cSql+" Order By F1_DOC"

	//Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	cF2vend  := GETADVFVAL("SF2","F2_VEND1",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"")

	If !Empty(D1_SERIORI)
		cF2unom := GETADVFVAL("SF2","F2_UNOMCLI",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"erro")
		cF2unit := GETADVFVAL("SF2","F2_UNITCLI",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"erro")
	else
		cF2unom := GETADVFVAL("SA1","A1_NOME   ",XFILIAL("SF1")+F1_FORNECE+F1_LOJA,1,"erro")
		cF2unit := GETADVFVAL("SA1","A1_UNITFAC",XFILIAL("SF1")+F1_FORNECE+F1_LOJA,1,"erro")
	ENDIF

	cValfat := 0
	cFac 	:= GETADVFVAL("SF2","F2_DOC",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"erro")//No fac
	cAut 	:= GETADVFVAL("SF2","F2_NUMAUT",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"erro")//No autorizacion
	cFch 	:= GETADVFVAL("SF2","F2_EMISSAO",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"erro")//Fcha emision
	cValfat := GETADVFVAL("SF2","F2_VALFAT",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"erro")//valor factura
	cDescon := GETADVFVAL("SF2","F2_DESCONT",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"erro")//valor descuento
	cBasimp := GETADVFVAL("SF2","F2_BASIMP1",XFILIAL("SF1")+D1_NFORI+D1_SERIORI,1,"erro")//F2_BAS
	cnfori := D1_NFORI
	ccserie := D1_SERIORI

	AADD(aDupla,F1_FILIAL)		  	//1
	AADD(aDupla,F1_SERIE)           //2
	AADD(aDupla,F1_DOC)             //3
	AADD(aDupla,F1_NUMAUT)          //4 nroautorizacion
	AADD(aDupla,F1_EMISSAO)         //5
	AADD(aDupla,cF2unom)         //6//nombre
	AADD(aDupla,cF2unit)            //7 nit cliente
	AADD(aDupla,F1_COND)            //8 //condicionpago
	AADD(aDupla,F1_VALBRUT)          //9
	AADD(aDupla,F1_DESCONT)         //10
	AADD(aDupla,F1_BASIMP1)  		//11
	AADD(aDupla,F1_CODCTR)          //12
	AADD(aDupla,FP_DTAVAL)          //13
	AADD(aDupla,nil)
	//AADD(aDupla,F2_UNROIMP)		//14
	AADD(aDupla,D1_PEDIDO)		    //15 nropedido
	AADD(aDupla,A1_MUN)		    	//16
	AADD(aDupla,A1_BAIRRO)		    //17
	AADD(aDupla,A1_END)		    //18
	AADD(aDupla,F1_USRREG)		    //19
	AADD(aDupla,F1_FORNECE)		    //20
	AADD(aDupla,F1_LOJA)		    //21
	AADD(aDupla,F1_ESPECIE)		    //22
	AADD(aDupla,"")			    //23 ??? FP_SFC
	AADD(aDupla,NIL)			    //24
	AADD(aDupla,cF2vend)			//25
	AADD(aDupla,cFac)			//26
	AADD(aDupla,cAut)			//27
	AADD(aDupla,cFch)			//28
	AADD(aDupla,cValfat)			//29 VALFA
	AADD(aDupla,cDescon)			//30 DESCON
	AADD(aDupla,cBasimp)			//31 BASIM

	aDetalle:= FatDet (F1_DOC,F1_SERIE)                	   	//Datos detalle de factura
	aDetail := FatDetNf(cnfori,ccserie)

	nCantReg:=len(aDetalle)
	If nCantReg <= 33
		cFilFact := aDupla[1]
		DbSelectArea("SM0")
		SM0->(DBSETORDER(1))
		SM0->(DbSeek(cEmpAnt+cFilFact))

		cDireccion := AllTrim(SM0->M0_ENDENT)+"; "+ AllTrim(SM0->M0_CIDENT)
		cTelefono := "Telefono: "+AllTrim(SM0->M0_TEL)+If(!Empty(SM0->M0_FAX)," Fax: "+AllTrim(SM0->M0_FAX),"")

		FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"ORIGINAL",cDireccion,cTelefono,aDetail)    	//Imprimir Factura
		FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"COPIA",cDireccion,cTelefono,aDetail)	    	//Imprimir Factura

	Else
		MsgInfo ("AVERTENCIA: Este formato solo permite 33 Items, usted tiene "+CValToChar(nCantReg)+".... Favor elija otro formato o modifique la factura")
	EndIf
	dbSelectArea(NextArea)
	aDupla:={}

	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF

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

static function FatImp(cTitulo,bImprimir,aMaestro,aDetalle,nLinInicial,cTipo,cDireccion,cTelefono,aDetail)
	Local _nInterLin := 880
	Local aInfUser := pswret()
	Local nI:=0
	//	Local nItemFact:=33
	Local nDim:=0
	Default nLinInicial := 0
	FatImpNF(aDetail,nLinInicial)
	nDim:=len(aDetalle)

	CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	_nInterLin += nLinInicial + 950 //erick

	For nI:=1 to nDim
		oPrn:Say(_nInterLin,100,aDetalle[nI][1],oFont10) //Codigo del Producto
		oPrn:Say(_nInterLin,320,aDetalle[nI][2],oFont08)  //Descripcion
		oPrn:Say(_nInterLin,1370,FmtoValor(aDetalle[nI][4],10,0),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,1590,FmtoValor(aDetalle[nI][5],14,2),oFont10)  //Precio Unitario
		oPrn:Say(_nInterLin,2000,FmtoValor(aDetalle[nI][6],16,2),oFont10)  //Total
		/*		oPrn:Say(_nInterLin,1850,TRANSFORM(aDetalle[nI][4],"@E 99,999,999"),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,2100,TRANSFORM(aDetalle[nI][5],"@E 99,999,999.99"),oFont10) //Precio Unitario
		oPrn:Say(_nInterLin,2360,TRANSFORM(aDetalle[nI][6],"@E 999,999,999.99"),oFont10) //Total
		*/
		_nInterLin:=_nInterLin+50
	Next

	PieFact(nLinInicial,aMaestro)

return nil

static function FatImpNF(aDetalle,nLinInicial)
	Local _nInterLin := 680
	//Local aInfUser := pswret()
	Local nI:=0
	//	Local nItemFact:=33
	Local nDim:=0
	Default nLinInicial := 0

	nDim:=len(aDetalle)

	//CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	_nInterLin += nLinInicial + 70 //erick

	For nI:=1 to nDim
		oPrn:Say(_nInterLin,100,aDetalle[nI][1],oFont10) //Codigo del Producto
		oPrn:Say(_nInterLin,320,aDetalle[nI][2],oFont08)  //Descripcion
		oPrn:Say(_nInterLin,1370,FmtoValor(aDetalle[nI][4],10,0),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,1590,FmtoValor(aDetalle[nI][5],14,2),oFont10)  //Precio Unitario
		oPrn:Say(_nInterLin,2000,FmtoValor(aDetalle[nI][6],16,2),oFont10)  //Total
		/*		oPrn:Say(_nInterLin,1850,TRANSFORM(aDetalle[nI][4],"@E 99,999,999"),oFont10)  //Cantidad
		oPrn:Say(_nInterLin,2100,TRANSFORM(aDetalle[nI][5],"@E 99,999,999.99"),oFont10) //Precio Unitario
		oPrn:Say(_nInterLin,2360,TRANSFORM(aDetalle[nI][6],"@E 999,999,999.99"),oFont10) //Total
		*/
		_nInterLin:=_nInterLin+50
	Next

	//PieFact(nLinInicial,aMaestro)
return nil

Static Function CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	Local cFecVen := ""
	Local nInDe
	oPrn:StartPage()
	cFechaPed := If(!Empty(aMaestro[15]),DTOC(Posicione("SC5",1,xFilial("SC5")+aMaestro[15],"C5_EMISSAO")),"")
	oPrn:Box( nLinInicial + 155 , 1600 ,  325 , 2370 )
	oPrn:Say( nLinInicial + 185, 1670,"FACTURA No: "  ,oFont12N )
	oPrn:Say( nLinInicial + 185, 2045,alltrim(str(val(aMaestro[3]))) ,oFont12N ) //Nro Factura
	oPrn:Say( nLinInicial + 250, 1620,"AUTORIZACION: "  ,oFont12N )
	oPrn:Say( nLinInicial + 250, 1995, aMaestro[4] ,oFont12N ) //Nro Autorizacion

	oPrn:Say( nLinInicial + 340, 0100,cDireccion  ,oFont08 )
	oPrn:Say( nLinInicial + 370, 0100,cTelefono  ,oFont08 )

	oPrn:Say( nLinInicial + 330, 1650,"Fabricaci๓n de otros productos de"  ,oFont12N )
	//oPrn:Say( nLinInicial + 370, 0510,"SFC - " + aMaestro[23] ,oFont12N )
	//oPrn:Say( nLinInicial + 370, 1100,cTipo ,oFont12N )
	oPrn:Say( nLinInicial + 370, 1650,"plแsticos (envases plแsticos)"  ,oFont12N )

	oPrn:Box( nLinInicial + 430 , 80 ,  430 , 2370 ) // nit

	oPrn:Box( nLinInicial + 570 , 80 ,  571 , 2370 ) // parte

	oPrn:Say( nLinInicial + 450, 100,"Fecha...: " ,oFont12N )
	oPrn:Say( nLinInicial + 450, 290,DTOC(STOD(aMaestro[5])) ,oFont12 ) //Fecha Factura

	oPrn:Say( nLinInicial + 510, 100,"Nombre: " ,oFont12N )
	oPrn:Say( nLinInicial + 510, 290,aMaestro[6] ,oFont12 ) // Nombre del Cliente

	oPrn:Say( nLinInicial + 510, 1585, "NIT/C.I.: " ,oFont12N )
	oPrn:Say( nLinInicial + 510, 2070, aMaestro[7] ,oFont12 ) //NIT del Cliente

	oPrn:Say( nLinInicial + 580, 850,"DATOS DE LA TRANSACCIำN ORIGINAL: " ,oFont11N )
	oPrn:Say( nLinInicial + 630, 100,"Nบ Factura: " ,oFont11N )
	oPrn:Say( nLinInicial + 630, 380,alltrim(str(val(aMaestro[26]))) ,oFont11N) //Nro Factura
	oPrn:Say( nLinInicial + 630, 650,"Nบ Autorizaci๓n: " ,oFont11N )
	oPrn:Say( nLinInicial + 630, 1000,aMaestro[27] ,oFont12N )
	oPrn:Say( nLinInicial + 630, 1550,"Fecha de Emisi๓n: " ,oFont11N )
	oPrn:Say( nLinInicial + 630, 1950,DTOC(aMaestro[28]) ,oFont11N )

	//oPrn:Box( nLinInicial + 675 , 80 ,  2730 , 2370 )//borde
	oPrn:Say(nLinInicial + 680, 110, "NRO" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 680, 310, "DESCRIPCION DEL PRODUCTO" ,oFont11N ) 													//Nombre
	//oPrn:Say(nLinInicial + 890, 1450, "LOTE" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 680, 1370, "CANTIDAD" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 680, 1600, "PRECIO UNITARIO" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 680, 2020, "SUBTOTAL" ,oFont11N ) 													//Nombre
	//dos lineas por nro y descripcion
	oPrn:Box( nLinInicial + 675 , 80 ,  675 , 2370 )
	oPrn:Box( nLinInicial + 740 , 80 ,  740 , 2370 )
	//linea subtotal
	oPrn:Box( nLinInicial + 1640 , 80 ,  1640 , 2370 )
	//oPrn:Box( nLinInicial + 740 , 80 ,  740 , 2370 )

	PieFactf2(nLinInicial,aMaestro)
	//////////////////////// seguir
	oPrn:Say( nLinInicial + 1720, 700,"DETALLE DE LA DEVOLUCIำN O RESCISIำN DE SERVICIO: " ,oFont11N )
	//nLinInicial := nLinInicial + 70
	oPrn:Box(nLinInicial + 1765 , 80 ,  1765 , 2370)
	oPrn:Say(nLinInicial + 1770, 110, "NRO" ,oFont11N) 													//Nombre
	oPrn:Say(nLinInicial + 1770, 310, "DESCRIPCION DEL PRODUCTO" ,oFont11N) 													//Nombre												//Nombre
	oPrn:Say(nLinInicial + 1770, 1370, "CANTIDAD" ,oFont11N) 													//Nombre
	oPrn:Say(nLinInicial + 1770, 1600, "PRECIO UNITARIO" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 1770, 2020, "SUBTOTAL" ,oFont11N )
	oPrn:Box(nLinInicial + 1820 , 80 ,  1820 , 2370)
	//Nombre
	/*oPrn:Box( nLinInicial + 1750 , 80 ,  1900 , 2370)//cierra arriba
	oPrn:Box( nLinInicial + 1750 , 80 ,  1990 , 2370)//cierra abajo*/

	cFLogoMarkas := GetSrvProfString("Startpath","") + "Logo01.bmp"
	oPrn:SayBitmap(090,80, cFLogoMarkas,400,180)
	oPrn:Say(270, 80, "Industrias Belen Srl." ,oFont10 )
	oPrn:Say(305, 80, "PRODUCTOS TERMINADOS" ,oFont10 )

Return Nil

Static Function PieFact(nLinInicial,aMaestro)
	Local nTotGral := 0
	Local cFile := ""
	oPrn:Box( nLinInicial + 2740 , 80 ,  2740 , 2370 )
	
	oPrn:Say( nLinInicial + 2740, 100, "Son: "+Extenso(aMaestro[11],.F.,1)+" BOLIVIANOS" ,oFont10N ) 							//Total  Escrito

	oPrn:Say(nLinInicial + 2870, 0100, aMaestro[19] ,oFont12 ) //Usuario que gener๓ la factura

	oPrn:Say(nLinInicial + 2800, 870, "Total Gral" ,oFont11N ) 													//Codigo Control
	oPrn:Say(nLinInicial + 2800, 1400, "Descuentos" ,oFont11N ) 													//Codigo Control
	oPrn:Say(nLinInicial + 2800, 1920, "Total Bs." ,oFont11N ) 													//Codigo Control

	nTotGral := Round(aMaestro[9]+aMaestro[10],2)
	oPrn:Say(nLinInicial + 2850, 0100, Time() ,oFont12 ) //Hora en que se imprimi๓ la factura
	oPrn:Say(nLinInicial + 2800, 1050, TRANSFORM(nTotGral,"@E 9,999,999,999.99") ,oFont11N ) //Total General
	oPrn:Say(nLinInicial + 2800, 1610, TRANSFORM(aMaestro[10],"@E 9,999,999,999.99") ,oFont11N ) //Descuentos
	oPrn:Say(nLinInicial + 2800, 2080, TRANSFORM(aMaestro[11],"@E 9,999,999,999.99") ,oFont11N )  //Total Bolivianos

	oPrn:Say(nLinInicial + 2790, 0100, "F:"+AllTrim(aMaestro[2])+"-"+Right(AllTrim(aMaestro[3]), 6) ,oFont11 )  //Serie + Factura
	//oPrn:Say(nLinInicial + 2840, 0100, "CAPC:"+AllTrim(aMaestro[24]) ,oFont12 )  //Codigo de Autorizacion Productos Controlados ERICK

	//oPrn:Box( nLinInicial + 2880 , 940 ,  2950 , 1830 )
	//oPrn:Say(nLinInicial + 2890, 970, "CODIGO DE CONTROL:  "+aMaestro[12] ,oFont12N ) 													//Codigo Control
	oPrn:Box( nLinInicial + 2970 , 940 ,  3040 , 1830 )
	oPrn:Say(nLinInicial + 2980, 970, "Fecha Limite de Emision:  "+DTOC(STOD(aMaestro[13])) ,oFont11N ) 													//Nombre

	oPrn:Say(nLinInicial + 3000, 100, "___________________________" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 3040, 250, "Recibi Conforme" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 3100, 090, "''ESTA FACTURA CONTRIBUYE AL DESARROLLO DEL PAIS. EL USO ILICITO DE ESTA SERA SANCIONADO DE ACUERDO A LEY''" ,oFont10N ) 													//Nombre
	//oPrn:Say(nLinInicial + 3150, 560, "Ley No 453: Los productos deben suministrarse en condiciones de inocuidad, calidad y seguridad" ,oFont09 ) 													//Nombre
	oPrn:Say(nLinInicial + 3150, 100, U_GetExNCC(alltrim(aMaestro[2]),alltrim(aMaestro[1])) ,oFont08 ) 													//Nombre

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

	//cFile = u_TDEPQR(qr) //llama al qrtdep

	//oPrn:SayBitmap(2930,2070,cFile,300,300)

	oPrn:EndPage()

	//oDelete:setFile(cFile)

Return Nil

Static Function PieFactf2(nLinInicial,aMaestro)
	Local nTotGral := 0
	nTotGral := Round(aMaestro[29]+aMaestro[30],2)
	oPrn:Say(nLinInicial + 1640, 870, "Total Gral" ,oFont11N )
	oPrn:Say(nLinInicial + 1640, 1050, TRANSFORM(nTotGral,"@E 9,999,999,999.99") ,oFont11N ) //Total General
	oPrn:Say(nLinInicial + 1640, 1400, "Descuentos" ,oFont11N )
	oPrn:Say(nLinInicial + 1640, 1610, TRANSFORM(aMaestro[30],"@E 9,999,999,999.99") ,oFont11N ) //Descuentos
	oPrn:Say(nLinInicial + 1640, 1920, "Total Bs." ,oFont11N )
	oPrn:Say(nLinInicial + 1640, 2080, TRANSFORM(aMaestro[31],"@E 9,999,999,999.99") ,oFont11N )  //Total Bolivianos
return nil

static function FatDet (cDoc,cSerie) // Datos detalle de factura ERICK MOD
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT D1_ITEM,B1_COD,B1_DESC,D1_LOTECTL,D1_DTVALID,D1_QUANT,D1_VUNIT,CASE WHEN D1_VUNIT!=0 THEN D1_QUANT*D1_VUNIT ELSE D1_QUANT*D1_VUNIT END D1_TOTAL,D1_ITEM "
	cSql				:= cSql+"FROM " + RetSqlName("SD1") +" SD1 JOIN	" + RetSqlName("SB1") +" SB1 ON (D1_DOC='"+cDoc+"' AND D1_SERIE='"+cSerie+"' AND  D1_COD=B1_COD AND D1_ESPECIE='NCC' AND SD1.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"ORDER BY SD1.D1_ITEM"
	//Aviso("items",cSql,{'ok'},,,,,.t.)

	//	SELECT B1_COD,B1_DESC,D1_LOTECTL,D1_DTVALID,D1_QUANT, D1_VUNIT,CASE WHEN D1_VUNIT!=0 THEN D1_QUANT*D1_VUNIT ELSE D1_QUANT*D1_VUNIT END D1_TOTAL,D1_ITEM
	//	FROM  SD1010 SD1 JOIN SB1010 SB1 ON (D1_DOC='0000000000001' AND D1_SERIE='MO1' AND  D1_COD=B1_COD AND D1_ESPECIE='NF' AND SD1.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' )
	//	ORDER BY D1_ITEM

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	While !Eof()
		cProducto	:=D1_ITEM
		cNombre		:=B1_DESC
		If Len(AllTrim(D1_DTVALID+D1_DTVALID))>0
			cLote       :="L:"+AllTrim(D1_LOTECTL)+" V:"+ALLTRIM(STRZERO(MONTH(STOD(D1_DTVALID)),2))+ALLTRIM("/")+ALLTRIM(STRZERO(Year(STOD(D1_DTVALID)),4))
		Else
			cLote       := ""
		EndIf
		cPedido		:=""
		cItPedido	:=""
		nCant		:=D1_QUANT
		//		If !Empty(cPedido)
		//			nPrecio		:=NoRound(Posicione('SC6',1,xFilial('SC6')+cPedido+cItPedido,'C6_PRCVEN'),6)
		//	    Else
		nPrecio		:=D1_VUNIT
		//	    End
		nTotal		:=Round(nCant*nPrecio,2)

		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,cLote)      //3
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

static function FatDetNf (cDoc,cSerie) // Datos detalle de factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT D1_ITEM,B1_COD,B1_DESC,D2_LOTECTL,D2_DTVALID,D2_QUANT,CASE WHEN D2_PRUNIT!=0 THEN D2_PRUNIT ELSE D2_PRCVEN END D2_PRUNIT,CASE WHEN D2_PRUNIT!=0 THEN D2_QUANT*D2_PRUNIT ELSE D2_QUANT*D2_PRCVEN END D2_TOTAL, D2_PEDIDO, D2_ITEMPV "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"JOIN " + RetSqlName("SD1") + " SD1 ON (D2_DOC=D1_NFORI AND D2_SERIE=D1_SERIORI AND D2_ITEM=D1_ITEMORI"
	cSql				:= cSql+" and D1_FORNECE=D2_CLIENTE AND D1_LOJA=D2_LOJA AND D2_FILIAL=D1_FILIAL)ORDER BY B1_COD"
	//Aviso("items",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	While !Eof()
		cProducto	:= D1_ITEM
		cNombre		:=B1_DESC
		If Len(AllTrim(D2_DTVALID+D2_DTVALID))>0
			cLote       :="L:"+AllTrim(D2_LOTECTL)+" V:"+ALLTRIM(STRZERO(MONTH(STOD(D2_DTVALID)),2))+ALLTRIM("/")+ALLTRIM(STRZERO(Year(STOD(D2_DTVALID)),4))
		Else
			cLote       := ""
		EndIf
		cPedido		:=D2_PEDIDO
		cItPedido	:=D2_ITEMPV
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
		AADD(aDupla,cLote)      //3
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
