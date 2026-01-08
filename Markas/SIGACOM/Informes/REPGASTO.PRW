#DEFINE CRLF Chr(13)+Chr(10)
#Include "protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"  
#INCLUDE "report.ch"

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½REPGASTO  ï¿½Autor  ï¿½EDUAR ANDIA TAPIA   ï¿½Fecha ï¿½  01/03/12   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Reporte Detallado de Gastos de Importaciï¿½n por Pedido      ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½ Pedido - Remitos - Gastos - Facturas Regularizadas         ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ SAGITARIO                                                  ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

User Function RepGasto
Local aArea	  := GetArea()
Local oReport
Private cPerg := "REPGASTO"
Private cTitulo
Private cDesMoeda
                      
If TRepInUse()
	ValidPerg(cPerg)	//Cargamos los preguntas por codigo
	Pergunte(cPerg,.F.)
	oReport	:= Tcr460RptDef()
	oReport:PrintDialog()
EndIf
RestArea(aArea)
Return
               

Static Function Tcr460RptDef()
Local oReport
//Local oSection1
Local aOrdem
local cTitle  := "GASTOS DE IMPORTACION"
local cHelp   := "Permite generar reporte segun parametros seleccionados" 

oReport	:= TReport():New('REPGASTO',cTitle,cPerg,{|oReport|Tcr460PrtRpt(oReport,aOrdem)},cHelp)

//DEFINE REPORT oReport NAME "RepGasto" TITLE "Reporte Gasto" PARAMETER cPerg ACTION {|oReport| Tcr460PrtRpt(oReport,aOrdem)} DESCRIPTION "Reporte Gasto"
oReport:SetLandscape(.F.) 			// Horizontal
oReport:SetPortrait(.T.) 			// Vertical
oReport:lHeaderVisible	:= .F.		// Habilita a impressï¿½o do cabeï¿½alho
oReport:HideParamPage()
oReport:setLeftMargin(3)
oReport:nFontBody		:= 10
oReport:cFontBody		:= "Arial"
oReport:lFooterVisible 	:= .F.		// Habilita a impressï¿½o do rodapï¿½.
oReport:SetLineHeight(43)

oSection0  := TRSection():New( oReport, "Proveedor" , {"CT5"},, .F., .F. )		//"Data dos Lanï¿½amentos"
TRCell():New( oSection0, "proveedor"		, 		 ,"Proveedor" 	,/*Picture*/,15	,/*lPixel*/,/*CodeBlock*/,"LEFT",,"LEFT")		//codigo
TRCell():New( oSection0, "codigo"		, 		 ,"Codigo" 	,/*Picture*/,12	,/*lPixel*/,/*CodeBlock*/,"LEFT",,"LEFT")		//codigo
TRCell():New( oSection0, "razon"		, 		 ,"Nombre" 	,/*Picture*/,35	,/*lPixel*/,/*CodeBlock*/,"LEFT",,"LEFT")		//codigo

//	DEFINE SECTION oSection1 OF oReport TITLE "Seccion 1" TABLES "SF2", "SD2" ORDERS aOrdem
Return oReport


Static Function Tcr460PrtRpt( oReport, aOrdem )
Local oSection0 := oReport:Section(1)				// Define a secao 1 do relatorio
//Local oSection1 := oReport:Section(2)				// Define a secao 1 do relatorio
//Local nMoneda	:= MV_PAR01
Local aArrPed := {}
Local aArrRem := {}
Local lVisuaPed := MV_PAR02 == 1
Local lVisuaGas := MV_PAR03 == 1
Local nI, nR, _nContRem, nGR, nTRem, _nCont
Private nMoneda	:= MV_PAR01

oFont12T  := TFont():New("Times New Roman",,12,,.F.)
oFont12TN := TFont():New("Times New Roman",,12,,.T.)
oFont20TN := TFont():New("Times New Roman",,20,,.T.)

//OrdenesCom	:= GetNextAlias()
oReport:StartPage()
oReport:SetTitle(oReport:Title() + Space(05))

//oSection1:Init()
oReport:PrintText(" ")	;	oReport:SkipLine(3)

fCabec(oReport,oSection0)
/*                                              
cDesMoeda 	:= If( nMoneda==1,"(en Pesos)","(en Dolar)")
cTitulo 	:= "Informe de Gastos de Importacion "
oReport:SAY(oReport:Row(), 500, Upper(cTitulo)  , oFont20TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.8)
oReport:SAY(oReport:Row(), 800, Upper(cDesMoeda), oFont20TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
oReport:PrintText(" ")	;	oReport:SkipLine(6)
*/

/* *********************************************************************************** */
cPedido		:= SC7->C7_NUM
aDataPed 	:= aDatosPed(cPedido)
If Len(aDataPed) > 0 .AND. lVisuaPed
	oReport:SAY(oReport:Row(), 100, "PEDIDO: "+cPedido, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
	oReport:ThinLine()												//Imprime Una Linea
	oReport:PrintText( "Item"		,oReport:Row(),100)
	oReport:PrintText( "Producto"	,oReport:Row(),230)
	oReport:PrintText( "Descripcion"	,oReport:Row(),550)
	oReport:PrintText( "Cant."		,oReport:Row(),1540)
	oReport:PrintText( "Importe"	,oReport:Row(),1820)			;	oReport:SkipLine(1.5)
	oReport:ThinLine()    
	_nTotPCVal :=0
	For nI := 1 to Len(aDataPed)
		//cargando al array de pedidos
		aadd(aArrPed,{aDataPed[nI][1],aDataPed[nI][2],aDataPed[nI][6],aDataPed[nI][3]})
		
		oReport:PrintText( aDataPed[nI][1]	,	oReport:Row(),100)
		oReport:PrintText( aDataPed[nI][2]	,	oReport:Row(),230)
		oReport:PrintText( aDataPed[nI][6]  , oReport:Row(),550)
		
		cCant	:= TRANSFORM( aDataPed[nI][3],"@E 999,999,999.99")
		cTotal	:= TRANSFORM( aDataPed[nI][5],"@E 999,999,999.99" )
		oReport:PrintText( cCant		,	oReport:Row(),1520)
		oReport:PrintText( cTotal		,	oReport:Row(),1800)
		oReport:SkipLine(1.5)     
		
	    _nTotPCVal +=aDataPed[nI][5]
	Next nI         

	oReport:ThinLine() 
	oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
	cTotal	:= TRANSFORM( _nTotPCVal ,"@E 999,999,999.99" )
	oReport:PrintText( cTotal		,	oReport:Row(),1800)
	oReport:SkipLine(1.5)     	
Endif

/* FACTURA COMERCIAL*/     
nTotDif := 0
aPedido	:= 	{cPedido}
aGastosImp	:= aGastosAnt(aPedido,3)
If Len(aGastosImp) > 0  

    nGerFacturas:=0    //Suma de montos de todas las facturas - Uso para hacer el Prorrateo para Costos 
	nTotMonto := 0
	cDoc	:= ''
	cSerie	:= ''  
	For nI := 1 to Len(aGastosImp)		
        
   	    If 	cDoc  <> AllTrim(aGastosImp[nI][2]) 

		    If 	nTotMonto > 0         //Imprimir TOTAL DA FACTURA COMERCIAL
				oReport:ThinLine()                                               
				nGerFacturas+=nTotMonto
				cTotMonto	:= TRANSFORM( nTotMonto	,"@E 999,999,999.99" )
				oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
				oReport:PrintText( cTotMonto	,oReport:Row(),1200)
				oReport:SkipLine(1.5)   	    
            EndIf
            
			cDoc	:= AllTrim(aGastosImp[nI][2])
 			cSerie	:= aGastosImp[nI][3]    
 			oReport:SkipLine(1.5)
 			oReport:SAY(oReport:Row(), 100, "FACTURA COMERCIAL: "+cDoc +'/'+cSerie , oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
			oReport:ThinLine()												//Imprime Una Linea
			oReport:PrintText( "Item"		,oReport:Row(),100)
			oReport:PrintText( "Producto"	,oReport:Row(),230)
			oReport:PrintText( "Descripcion"	,oReport:Row(),550)
			oReport:PrintText( "Cant."		,oReport:Row(),1200)			
			oReport:PrintText( "Valor"		,oReport:Row(),1520)
			oReport:SkipLine(1.5)
			oReport:ThinLine() 
			nTotMonto := 0
        EndIf

		nTotMonto	+= aGastosImp[nI][5]

		cMonto	:= TRANSFORM( aGastosImp[nI][5],"@E 999,999,999.99" ) 
		cCant	:= TRANSFORM( aGastosImp[nI][12],PesqPict('SD1','D1_QUANT'))		
		
		oReport:PrintText( aGastosImp[nI][11]	,	oReport:Row(),100)  	 						// Item
		oReport:PrintText( aGastosImp[nI][10]	,	oReport:Row(),230)							    // Producto   
		oReport:PrintText( Left(Alltrim(Posicione('SB1',1,xFilial('SB1')+aGastosImp[nI][10],'B1_DESC')),Len(sc7->c7_descri))	,	oReport:Row(),550)							    // Descripcion  		
		oReport:PrintText( cCant			,	oReport:Row(),1200)  								// Cantidad
		oReport:PrintText( cMonto			,	oReport:Row(),1500)  								// Monto
		oReport:SkipLine(1.5)

	Next nI 

	oReport:ThinLine()
	cTotMonto	:= TRANSFORM( nTotMonto	,"@E 999,999,999.99" )
	oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
	oReport:PrintText( cTotMonto	,oReport:Row(),1500)
	oReport:SkipLine(1.5)
	nGerFacturas+=nTotMonto
    
EndIf


/* *********************************************************************************** */
/*lista cantidad de remitos*/
cPedido		:= SC7->C7_NUM   
aCompleto :={}
aTotCompleto:={}
aRemitos 	:= aRemitos(cPedido)

If Len(aRemitos) > 0 
aTotRem := {}
aTodoRem := {}     
oReport:SkipLine(02)
oReport:SAY(oReport:Row(), 100, "REMITOS: ", oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
For _nContRem := 1 to Len(aRemitos)

	oReport:ThinLine()										//Imprime Una Linea
	oReport:PrintText( "Item"		,oReport:Row(),100)
	oReport:PrintText( "Producto"	,oReport:Row(),230)
	nCol	:= 280
	For nI := _nContRem to If(Len(aRemitos) <(_nContRem+2),Len(aRemitos),(_nContRem+2))
		cDoc	:= AllTrim(aRemitos[nI][3])
		cSer	:= AllTrim(aRemitos[nI][4])
		nCol += 600
		oReport:PrintText( cDoc	,oReport:Row(),nCol)
	Next nI
	oReport:SkipLine(1.5)

	nCol	:= 200
	For nI :=  _nContRem to If(Len(aRemitos) <(_nContRem+2),Len(aRemitos),(_nContRem+2))
		nCol += 600
   		oReport:PrintText( "Cant."		,oReport:Row(),nCol)
		oReport:PrintText( "Importe"	,oReport:Row(),nCol+250)
	Next nI
	oReport:SkipLine(1.5)	
	oReport:ThinLine()
	
	aDataPed 	:= aDatosPed(cPedido)
	For nI := 1 to Len(aDataPed)
		oReport:PrintText( aDataPed[nI][1]	,	oReport:Row(),100)  								//Item
		oReport:PrintText( aDataPed[nI][2]	,	oReport:Row(),230)		//;	oReport:SkipLine(1.5)	//Prod
		nCol		:= 150

	    aTotFilRem	:={}
		For nR := _nContRem to If(Len(aRemitos) <(_nContRem+2),Len(aRemitos),(_nContRem+2))

  				//buscar el producto en el array aCompleto - WCS - 27/08/2015
				bSeek := {|buscar|  buscar[3]+buscar[10]== aRemitos[nR][3]+aDataPed[nI][2] }
				nPos := aScan(aCompleto,bSeek)
				If nPos > 0
					//existe  
					nCantidad := aCompleto[nPos][6] 
					nTotal	  := aCompleto[nPos][8] 
					
				Else		
					nCantidad := nTotal := 0	            
				End
				    
				aadd(aTotFilRem,nTotal)
								
				//buscar el producto en el array aArrRem    
				bSeek := {|buscar| buscar[1]==aDataPed[nI][2] }
				nPos := aScan(aArrRem,bSeek)
				If nPos > 0
					//existe
					aArrRem[nPos][2] += nCantidad
				Else
					//no existe
					aadd(aArrRem,{aDataPed[nI][2],nCantidad})
				Endif
				
		  		nCol += 600
				cCantidad	:= TRANSFORM( nCantidad,"@E 999,999,999.99" )
				oReport:PrintText( cCantidad	,	oReport:Row(),nCol)  
				cValor	:= TRANSFORM( nTotal,"@E 999,999,999.99" )
				oReport:PrintText( cValor	,	oReport:Row(),nCol+250)				

		Next nR		 
		
 		aadd(aTodoRem,aTotFilRem)			
		oReport:SkipLine(1.5)
	Next nI	  

	oReport:ThinLine()
	oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
	nCol	:= 400

	For nI  := _nContRem to If(Len(aTotCompleto) <(_nContRem+2),Len(aTotCompleto),(_nContRem+2))
		nCol += 600
		cValor	:= TRANSFORM( aTotCompleto[nI,3],"@E 999,999,999.99" )		
		oReport:PrintText( cValor	,oReport:Row(),nCol)
	Next nI     

	oReport:SkipLine(1.5)	 	

	_nContRem+=2   //Para tener 3 columnas para REMITOS
	
Next _nContRem 	         

Endif

/* *********************************************************************************** */
/*lista valorada de remitos*/
//cPedido		:= SC7->C7_NUM  
aCompleto :={}
aRemitos 	:= aRemitos(cPedido)

If Len(aRemitos) > 0
	oReport:SkipLine(02)
	oReport:SAY(oReport:Row(), 100, "REMITOS PRORRATEADO: ", oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
	oReport:ThinLine()										//Imprime Una Linea
	oReport:PrintText( "Item"		,oReport:Row(),100)
	oReport:PrintText( "Producto"	,oReport:Row(),230)
	nCol	:= 280
	For nI := 1 to Len(aRemitos)
		cDoc	:= AllTrim(aRemitos[nI][3])
		cSer	:= AllTrim(aRemitos[nI][4])
		nCol += 270
		oReport:PrintText( cDoc	,oReport:Row(),nCol)
	Next nI
	oReport:SkipLine(1.5)
	oReport:ThinLine()
	
	aDataPed 	:= aDatosPed(cPedido)
	aTodoRem	:= {}
	For nI := 1 to Len(aDataPed)
		oReport:PrintText( aDataPed[nI][1]	,	oReport:Row(),100)  								//Item
		oReport:PrintText( aDataPed[nI][2]	,	oReport:Row(),230)		//;	oReport:SkipLine(1.5)	//Prod
		nCol		:= 280
		aTotFilRem	:= {}
		For nR := 1 to Len(aRemitos)
			aRecnoRem	:= {aRemitos[nR]}
			aDataGReg	:= aDataGReg(aRecnoRem)
			nCol += 270
			//Aviso("","fila: "+AllTrim(Str(nI)) + " - Rem: "+AllTrim(aRemitos[nR][3]),{"OK"})
			If Len(aDataGReg) > 0
				nValor	:= 0
				For nGR := 1 to Len(aDataGReg)
					cItemPCGR	:= aDataGReg[nGR][12]
					If aDataPed[nI][1] == cItemPCGR
						nValor	+= aDataGReg[nGr][7]	//D1_TOTAL
					Endif
					
				Next nGR
				
				cValor	:= TRANSFORM( nValor,"@E 999,999,999.99" )
				oReport:PrintText( cValor	,	oReport:Row(),nCol)
				aadd(aTotFilRem,nValor)
			Else
				aadd(aTotFilRem,0)
			Endif
		Next nR
		
		oReport:SkipLine(1.5)
		aadd(aTodoRem,aTotFilRem)		
	Next nI	
		
	aTotRem := {}     
	For nR := 1 to Len(aRemitos)
		nValor := 0
		For nTRem := 1 to Len(aTodoRem)			
			nValor += aTodoRem[nTRem][nR]
		Next nTRem
		aadd(aTotRem, nValor) 
	Next nR
		
	oReport:ThinLine()
	oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
	nCol	:= 280
	For nI  := 1 to Len(aRemitos)
		nCol += 270
		cValor	:= TRANSFORM( aTotRem[nI],"@E 999,999,999.99" )		
		oReport:PrintText( cValor	,oReport:Row(),nCol)
	Next nI
	oReport:SkipLine(1.5)	

Endif


/* *********************************************************************************** */	
aPedido	:= 	{cPedido}
aGastosEst	:= aGastosAnt(aPedido,2)
If Len(aGastosEst) > 0  

	nTotMonto := 0
	cDoc	:= ''
	cSerie	:= ''  
	For nI := 1 to Len(aGastosEst)		
        
   	    If 	cDoc  <> AllTrim(aGastosEst[nI][2]) 

		    If 	nTotMonto > 0         //Imprimir TOTAL DA FACTURA COMERCIAL
				oReport:ThinLine()
				cTotMontoOrig	:= TRANSFORM( nTotMontoOrig	,"@E 999,999,999.99" )
				cTotMonto 		:= TRANSFORM( nTotMonto	,"@E 999,999,999.99" )
				oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
				oReport:PrintText( cTotMontoOrig,oReport:Row(),1000)
				oReport:PrintText( cTotMonto	,oReport:Row(),1350)
				oReport:SkipLine(1.5)
            EndIf

			cDoc	:= AllTrim(aGastosEst[nI][2])
			cSerie	:= aGastosEst[nI][3]   
			
			oReport:SkipLine(02)
			oReport:SAY(oReport:Row(), 100, "GASTOS ESTIMADOS: " +cDoc +'/'+cSerie, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
			oReport:ThinLine() 
			oReport:PrintText( "Producto"		,oReport:Row(),100)			
			oReport:PrintText( "Tipo Gasto"		,oReport:Row(),300)
			oReport:PrintText( "Valor Bruto"	,oReport:Row(),1000)
			oReport:PrintText( "Importe"		,oReport:Row(),1370)
			oReport:SkipLine(1.5)
			oReport:ThinLine()
	
			nTotMontoOrig	:= 0
			nTotMonto 		:= 0    
		EndIf	

		cTipo	:= SubStr(AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+aGastosEst[nI][10],"B1_DESC")),1,20)

		nTotMontoOrig	+= aGastosEst[nI][13]		
		nTotMonto 		+= aGastosEst[nI][5]

		cMontoOrig	:= TRANSFORM( aGastosEst[nI][13],"@E 999,999,999.99" )
		cMonto		:= TRANSFORM( aGastosEst[nI][5],"@E 999,999,999.99" )
		
		oReport:PrintText( aGastosEst[nI][10]	,	oReport:Row(),100)  								// Producto
		oReport:PrintText( cTipo				,	oReport:Row(),300)  								// Tipo
		oReport:PrintText( cMontoOrig  			,	oReport:Row(),1000)  								// Monto Original
		oReport:PrintText( cMonto		 		,	oReport:Row(),1350)  								// Monto
		oReport:SkipLine(1.5)  			
	Next nI
	
	oReport:ThinLine()
	cTotMontoOrig	:= TRANSFORM( nTotMontoOrig	,"@E 999,999,999.99" )
	cTotMonto 		:= TRANSFORM( nTotMonto	,"@E 999,999,999.99" )
	oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
	oReport:PrintText( cTotMontoOrig,oReport:Row(),1000)
	oReport:PrintText( cTotMonto	,oReport:Row(),1350)
	oReport:SkipLine(1.5)
Endif
/* *********************************************************************************** */	
/* *********************************************************************************** */	
aPedido	:= 	{cPedido}
aGastosAnt	:= aGastosAnt(aPedido,1)
If Len(aGastosAnt) > 0
	oReport:SkipLine(02)
	oReport:SAY(oReport:Row(), 100, "GASTOS REALIZADOS: ", oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
	oReport:ThinLine()
	oReport:PrintText( "Producto"		,oReport:Row(),100)
	oReport:PrintText( "Tipo Gasto"		,oReport:Row(),300)
	oReport:PrintText( "Documento"		,oReport:Row(),870)
	oReport:PrintText( "Monto Original"	,oReport:Row(),1270)
	oReport:PrintText( "Monto"			,oReport:Row(),1570)
	oReport:PrintText( "Prorrateado"	,oReport:Row(),1870)
	oReport:PrintText( "Por Prorratear"	,oReport:Row(),2170)
	oReport:SkipLine(1.5)
	oReport:ThinLine()

	nTotMontoOrig	:= 0	
	nTotMonto 		:= 0
	nTotPror   		:= 0
	nTotDisp  		:= 0
	
	For nI := 1 to Len(aGastosAnt)		
	   //	cTipo	:= SubStr(AllTrim(POSICIONE("SX5",1,XFILIAL("SX5")+"ZN"+aGastosAnt[nI][8],"X5_DESCRI")),1,20)
	  	cTipo	:= SubStr(AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+aGastosAnt[nI][10],"B1_DESC")),1,20)
		cDoc	:= AllTrim(aGastosAnt[nI][2])
		cSerie	:= aGastosAnt[nI][3]                                  

		nTotMontoOrig	+= aGastosAnt[nI][13]		
		nTotMonto 		+= aGastosAnt[nI][5]
		nTotPror  		+= aGastosAnt[nI][6]
		nTotDisp  		+= aGastosAnt[nI][7]

		cMontoOrig	:= TRANSFORM( aGastosAnt[nI][13],"@E 999,999,999.99" )
		cMonto 		:= TRANSFORM( aGastosAnt[nI][5],"@E 999,999,999.99" )
		cPror  		:= TRANSFORM( aGastosAnt[nI][6],"@E 999,999,999.99" )
		cDisp  		:= TRANSFORM( aGastosAnt[nI][7],"@E 999,999,999.99" )
		
		oReport:PrintText( aGastosAnt[nI][10]	,	oReport:Row(),100)  								// Producto
		oReport:PrintText( cTipo				,	oReport:Row(),300)  								// Tipo
		oReport:PrintText( cDoc+"/"+cSerie		,	oReport:Row(),870)									// Doc /Serie
		oReport:PrintText( cMontoOrig			,	oReport:Row(),1270)  								// Monto Original
		oReport:PrintText( cMonto				,	oReport:Row(),1570)  								// Monto
		oReport:PrintText( cPror				,	oReport:Row(),1870)  								// Prorrateado
		oReport:PrintText( cDisp				,	oReport:Row(),2170)	;	oReport:SkipLine(1.5)  		// Por Prorratear		
	Next nI
	
	oReport:ThinLine()                                          
	cTotMontoOrig	:= TRANSFORM( nTotMontoOrig	,"@E 999,999,999.99" )
	cTotMonto 		:= TRANSFORM( nTotMonto	,"@E 999,999,999.99" )
	cTotPror  		:= TRANSFORM( nTotPror	,"@E 999,999,999.99" )
	cTotDisp 		:= TRANSFORM( nTotDisp	,"@E 999,999,999.99" )		
	oReport:PrintText( "TOTAL: "	,oReport:Row(),100) 
	oReport:PrintText( cTotMontoOrig,oReport:Row(),1270)	
	oReport:PrintText( cTotMonto	,oReport:Row(),1570)
	oReport:PrintText( cTotPror		,oReport:Row(),1870)
	oReport:PrintText( cTotDisp		,oReport:Row(),2170)		;	oReport:SkipLine(1.5)
Endif
/* *********************************************************************************** */

/* *********************************************************************************** */	
If Len(aGastosEst) > 0    
    aGastosDif:={}
    
    //Comparando Gastos  Gastos Estimados x Realizados
    For _nCont:=1 to Len(aGastosEst)

	    _nPos:=Ascan(aGastosAnt,{|x| x[10] == aGastosEst[_nCont,10]})
	    If _nPos == 0     
	    	//No Existe Gasto Realizado com el mismo código que el Gasto Estimado
	    	//Entonces ya es una diferencia   
	    	AADD(aGastosDif,{SubStr(AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+aGastosEst[_nCont][10],"B1_DESC")),1,20),;
					    	AllTrim(aGastosEst[_nCont][2]),;
					    	aGastosEst[_nCont][3],;
					    	0,aGastosEst[_nCont][5], -aGastosEst[_nCont][5] , aGastosEst[_nCont][10]})
	    	
	    Else
	    	//Existe Gasto Realizado com el mismo código que el Gasto Estimado	
	    	//Verificar se el MOnto es diferente  
	       //	If aGastosEst[_nCont,5]  <> aGastosAnt[_nPos,5]  
	    	   
	    		AADD(aGastosDif,{SubStr(AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+aGastosEst[_nCont][10],"B1_DESC")),1,20),;
					    	AllTrim(aGastosEst[_nCont][2]),;
					    	aGastosEst[_nCont][3],;
					    	aGastosAnt[_nPos][5], aGastosEst[_nCont,5], (aGastosAnt[_nPos,5] - aGastosEst[_nCont,5]) , aGastosEst[_nCont][10] })

	       // End		    	  
	    End	
	    
    Next _nCont 
    
 
    //Comparando Gastos Realizados x Gastos Estimados
    For _nCont:=1 to Len(aGastosAnt)

	    _nPos:=Ascan(aGastosEst,{|x| x[10] == aGastosAnt[_nCont,10]})
	    If _nPos == 0     
	    	//No Existe Gasto Estimado com el mismo código que el Gasto Realizado
	    	//Entonces ya es una diferencia   
	    	AADD(aGastosDif,{SubStr(AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+aGastosAnt[_nCont][10],"B1_DESC")),1,20),;
					    	AllTrim(aGastosAnt[_nCont][2]),;
					    	aGastosAnt[_nCont][3],;
					    	aGastosAnt[_nCont][5],0,  aGastosAnt[_nCont][5], aGastosAnt[_nCont][10]})
	    	
	    Else
	    	//Existe Gasto Estimado com el mismo código que el Gasto Realizado	
	    	//Verificar se el MOnto es diferente  
	    //	If aGastosAnt[_nCont,5]  <> aGastosEst[_nPos,5]       
	    	   //Verificar se la diferencia ya no fue acumulada
	    	   _nPos2:=Ascan(aGastosDif,{|x| x[1] == SubStr(AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+aGastosAnt[_nCont][10],"B1_DESC")),1,20) })
	    	   If _nPos2 == 0
		    		AADD(aGastosDif,{SubStr(AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+aGastosAnt[_nCont][10],"B1_DESC")),1,20),;
					    	AllTrim(aGastosAnt[_nCont][2]),;
					    	aGastosAnt[_nCont][3],;
					    	aGastosAnt[_nCont][5], aGastosEst[_nPos2,5], (aGastosAnt[_nCont,5] - aGastosEst[_nPos2,5]) , aGastosAnt[_nCont][10] }) 
		  		End	    		    	
	      //  End		    	  
	    End	
	    
    Next _nCont 
                  */
    //Imprimindo Diferencias
    If Len(aGastosDif) > 0

		oReport:SkipLine(02)
		oReport:SAY(oReport:Row(), 100, "DIFERENCIAS GASTOS ESTIMADOS X REALIZADOS: ", oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
		oReport:ThinLine()
		oReport:PrintText( "Producto"		,oReport:Row(),100)
		oReport:PrintText( "Tipo Gasto"		,oReport:Row(),300)
		oReport:PrintText( "Documento"		,oReport:Row(),870)
		oReport:PrintText( "Realizado" 		,oReport:Row(),1370)
		oReport:PrintText( "Estimado"		,oReport:Row(),1720)
		oReport:PrintText( "Diferencia"		,oReport:Row(),2070)
		oReport:SkipLine(1.5)
		oReport:ThinLine()

		nTotRea 		:= 0
		nTotEst  		:= 0
		nTotDif  		:= 0
		
	    For _nCont:=1 to Len(aGastosDif)

 	   		nTotRea 		+= aGastosDif[_nCont][4]
	   		nTotEst  		+= aGastosDif[_nCont][5]
	   		nTotDif  		+= aGastosDif[_nCont][6]

	   		cRea    	:= TRANSFORM( aGastosDif[_nCont][4],"@E 999,999,999.99" )
   	   		cEst 		:= TRANSFORM( aGastosDif[_nCont][5],"@E 999,999,999.99" )
	   		cDif 		:= TRANSFORM( aGastosDif[_nCont][6],"@E 999,999,999.99" )

			oReport:PrintText( aGastosDif[_nCont,7]			,	oReport:Row(),100)  								// Producto
			oReport:PrintText( aGastosDif[_nCont,1]			,	oReport:Row(),300)  								// Tipo
   			oReport:PrintText( aGastosDif[_nCont,2]+'/'+aGastosDif[_nCont,3]		,	oReport:Row(),870)			// Doc /Serie
  			oReport:PrintText( cRea		,	oReport:Row(),1370)  								// Realizado
			oReport:PrintText( cEst		,	oReport:Row(),1720)  								// Estimado
			oReport:PrintText( cDif		,	oReport:Row(),2070)  								// Diferencia
	    	oReport:SkipLine(1.5)
   	
   		 Next _nCont
    
		oReport:ThinLine()
		cTotRea	:= TRANSFORM( nTotRea	,"@E 999,999,999.99" )
		cTotEst	:= TRANSFORM( nTotEst	,"@E 999,999,999.99" )
		cTotDif	:= TRANSFORM( nTotDif	,"@E 999,999,999.99" )		
		oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
		oReport:PrintText( cTotRea 		,oReport:Row(),1370)
		oReport:PrintText( cTotEst		,oReport:Row(),1720)
		oReport:PrintText( cTotDif		,oReport:Row(),2070)		;	oReport:SkipLine(1.5)   

	EndIf
Endif
/* *********************************************************************************** */	

//Impresion de Datos para Prorrateo de Costos   
oReport:SkipLine(02)
If Len(aGastosImp) > 0    .and. nTotDif <> 0         
   //aGastosCos:={}
   nTotCos:=nTotProrr:=0
   
	oReport:SAY(oReport:Row(), 100, "DATOS PARA PRORRATEO DE COSTOS: ", oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
	oReport:ThinLine()												//Imprime Una Linea
	oReport:PrintText( "Item"		,oReport:Row(),100)
	oReport:PrintText( "Producto"	,oReport:Row(),230)    
	oReport:PrintText( "Descripcion"	,oReport:Row(),550)    
	oReport:PrintText( "% Prorr"	,oReport:Row(),1540)		
	oReport:PrintText( "A Prorratear"	,oReport:Row(),1820)			;	oReport:SkipLine(1.5)
	oReport:ThinLine()    

	For nI := 1 to Len(aGastosImp)

        If nI < Len(aGastosImp)
			nProrr	:= Round(((aGastosImp[nI][5]/ nGerFacturas)*100),2)
	  		nMonto  := (nTotDif * nProrr)/100
	  	Else
	  		//Garantizando que el  100% del total sera prorrateado
	  		nProrr  := 100 - nTotProrr
	  		nMonto  := nTotDif - nTotCos
	  	EndIf	
  		nTotProrr+=nProrr
  		nTotCos  +=nMonto
	  			  			
		cProrr	:= TRANSFORM( nProrr	,"@E 999.99" ) + '%'
		cMonto	:= TRANSFORM( nMonto	,"@E 999,999,999.99" )		

		oReport:PrintText( aGastosImp[nI][11]	,	oReport:Row(),100)  	 			// Item
		oReport:PrintText( aGastosImp[nI][10]	,	oReport:Row(),230)				    // Producto   		
		oReport:PrintText( Left(Alltrim(Posicione('SB1',1,xFilial('SB1')+aGastosImp[nI][10],'B1_DESC')),Len(sc7->c7_descri))	,	oReport:Row(),550)							    // Descripcion  		
		oReport:PrintText( cProrr	,	oReport:Row(),1540)  	 						// % Prorrateio
		oReport:PrintText( cMonto	,	oReport:Row(),1820)							    // Monto a Prorratear   		

		oReport:SkipLine(1.5)     
		
   Next nI              

	oReport:ThinLine()
	cTotPror:= TRANSFORM( nTotProrr	,"@E 999.99" ) + '%'
	cTotCos	:= TRANSFORM( nTotCos	,"@E 999,999,999.99" )            
	oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
	oReport:PrintText( cTotPror		,oReport:Row(),1540)
	oReport:PrintText( cTotCos		,oReport:Row(),1820)		;	oReport:SkipLine(1.5)   

EndIf



//Facturas Regularizadas
If Len(aRemitos) > 0
	aGastosRegu	:= aGastosRegu(aRemitos)	
	If Len(aGastosRegu) > 0
		oReport:SkipLine(02)
	
		oReport:SAY(oReport:Row(), 100, "FACTURAS REGULARIZADAS: ", oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
		oReport:ThinLine()	;	oReport:SkipLine(1.5)
		oReport:PrintText( "Documento"	,oReport:Row(),550)
		oReport:PrintText( "Monto"		,oReport:Row(),900)
		oReport:PrintText( "Remito"		,oReport:Row(),1250)
		oReport:SkipLine(1.5)
		oReport:ThinLine()
		nTotMonto	:= 0
		
		For nI := 1 to Len(aGastosRegu)
			cDoc	:= aGastosRegu[nI][2]
			cSer	:= aGastosRegu[nI][3]
			cRemito := AllTrim(aGastosRegu[nI][5])
			cSerRem	:= aGastosRegu[nI][6]
			nTotMonto	+= aGastosRegu[nI][7]
			cMonto	:= TRANSFORM( aGastosRegu[nI][7],"@E 999,999,999.99" )
			
			oReport:PrintText( cDoc+"/"+cSer		,	oReport:Row(),500)									// Doc /Serie
			oReport:PrintText( cMonto				,	oReport:Row(),850)  								// Monto
			oReport:PrintText( cRemito+"/"+cSerRem	,	oReport:Row(),1200)	;	oReport:SkipLine(1.5)  		// Remito/Serie
		Next nI
		
		oReport:ThinLine()
		cTotMonto	:= TRANSFORM( nTotMonto	,"@E 999,999,999.99" )
			
		oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
		oReport:PrintText( cTotMonto	,oReport:Row(),850)		;	oReport:SkipLine(1.5)
	Endif
Endif
/* *********************************************************************************** */
//aGastImp
/* *********************************************************************************** */

If Len(aRemitos) > 0 .AND. lVisuaGas
	aGastImp	:= aGastImp(aRemitos)	
	If Len(aGastImp) > 0
		oReport:SkipLine(02)
	
		oReport:SAY(oReport:Row(), 100, "FACTURAS GASTOS IMPORT - NORMAL: ", oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
		oReport:ThinLine()
		oReport:PrintText( "Documento"	,oReport:Row(),500)
		oReport:PrintText( "Monto"		,oReport:Row(),900)
		oReport:PrintText( "Remito"		,oReport:Row(),1250)
		oReport:SkipLine(1.5)
		oReport:ThinLine()
		nTotMonto	:= 0
		
		For nI := 1 to Len(aGastImp)
			cDoc	:= aGastImp[nI][2]
			cSer	:= aGastImp[nI][3]
			cRemito := AllTrim(aGastImp[nI][5])
			cSerRem	:= aGastImp[nI][6]
			nTotMonto	+= aGastImp[nI][7]
			cMonto	:= TRANSFORM( aGastImp[nI][7],"@E 999,999,999.99" )
			
			oReport:PrintText( cDoc+"/"+cSer		,	oReport:Row(),500)									// Doc /Serie
			oReport:PrintText( cMonto				,	oReport:Row(),850)  								// Monto
			oReport:PrintText( cRemito+"/"+cSerRem	,	oReport:Row(),1200)	;	oReport:SkipLine(1.5)  		// Remito/Serie
		Next nI
		
		oReport:ThinLine()
		cTotMonto	:= TRANSFORM( nTotMonto	,"@E 999,999,999.99" )
			
		oReport:PrintText( "TOTAL: "	,oReport:Row(),100)
		oReport:PrintText( cTotMonto	,oReport:Row(),850)		;	oReport:SkipLine(1.5)
	Endif
Endif
/* *********************************************************************************** */
  	
  	//oSection1:Finish()	
	oReport:SkipLine(20)		

Return


//--------------------------------------------------------------------------------------------
Static Function aDatosPed(cPedido)
Local aItens := {}
Local cQuery := ""
cQuery := " Select DISTINCT C7_NUM, C7_ITEM, C7_PRODUTO, C7_QUANT, C7_PRECO, C7_TOTAL,C7_MOEDA,C7_EMISSAO,C7_DESCRI"
cQuery += " From " + RetSqlName("SC7") + " SC7, " + RetSqlName("SD1") + " SD1, " + RetSqlName("SF1") + " SF1 ," + RetSqlName("DBB") + " DBB "
cQuery += " Where C7_FILIAL = '" + xFilial("SC7")+ "' "
cQuery += " AND F1_HAWB = '" + DBA->DBA_HAWB  +"'  "
cQuery += " AND DBB_HAWB = '" + DBA->DBA_HAWB  +"' AND DBB_OK = 'S' "
cQuery += " And SF1.F1_SERIE = 'FOB' "       //FACTURA COMERCAL 
cQuery += " And SF1.F1_SERIE = SD1.D1_SERIE "       
cQuery += " And SF1.F1_DOC = SD1.D1_DOC "   
cQuery += " and f1_fornece = D1_FORNECE AND F1_LOJA = D1_LOJA "   
cQuery += " and DBB.DBB_FILIAL = SF1.F1_FILIAL "
cQuery += " and DBB.DBB_SERIE = SF1.F1_SERIE "
cQuery += " and DBB.DBB_DOC = SF1.F1_DOC "
cQuery += " and DBB.DBB_FORNEC = SF1.F1_FORNECE "
cQuery += " and DBB.DBB_LOJA = SF1.F1_LOJA "
cQuery += " AND C7_NUM = D1_PEDIDO "
cQuery += " And SC7.D_E_L_E_T_ <> '*' "
cQuery += " And SF1.D_E_L_E_T_ <> '*' "  
cQuery += " And SD1.D_E_L_E_T_ <> '*' "
cQuery += " And DBB.D_E_L_E_T_ <> '*' "
cQuery += " Order By C7_NUM, C7_ITEM"
Memowrite('reporte_gastos_pedidos.sql',cQuery)

If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
End   
TcQuery cQuery New Alias "StrSQL" 

While StrSQL->(!EOF())	
    cPedido:=StrSQL->C7_NUM 
	If StrSQL->C7_MOEDA == nMoneda
		AAdd( aItens, {	StrSQL->C7_ITEM , StrSQL->C7_PRODUTO, StrSQL->C7_QUANT, ;
						StrSQL->C7_PRECO, StrSQL->C7_TOTAL, StrSQL->C7_DESCRI } )
	Else		
		//Aviso("Emissao: ",DTOC(STOD(StrSQL->C7_EMISSAO)),{"OK"})		
		nPrecio := xMoeda(StrSQL->C7_PRECO,StrSQL->C7_MOEDA,nMoneda,STOD(StrSQL->C7_EMISSAO),8)
		nTotal	:= xMoeda(StrSQL->C7_TOTAL,StrSQL->C7_MOEDA,nMoneda,STOD(StrSQL->C7_EMISSAO),8)
		AAdd( aItens, {	StrSQL->C7_ITEM , StrSQL->C7_PRODUTO, StrSQL->C7_QUANT, ;
						nPrecio,nTotal, StrSQL->C7_DESCRI } )
	Endif
	StrSQL->(dbSkip())   
End
StrSQL->(DbCloseArea())
Return(aItens)
//--------------------------------------------------------------------------------------------
Static Function aRemitos(cPedido)
Local aItens :={}    
Local cQuery := ""
cQuery := " Select D1_ITEM, D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_QUANT, D1_VUNIT, D1_TOTAL, D1_PEDIDO,D1_EMISSAO, F1_MOEDA,F1_EMISSAO, D1_COD"
cQuery += " From " + RetSqlName("SD1") + " SD1 , "+RetSqlName("SF1")+ " SF1"
cQuery += " Where D1_FILIAL = '" + xFilial("SD1")+ "' "
cQuery += " And D1_TIPODOC = '60' AND D1_PEDIDO = '"+cPedido+"'"
cQuery += " And SD1.D_E_L_E_T_ <> '*' "
cQuery += " And F1_FILIAL = D1_FILIAL And F1_TIPODOC = D1_TIPODOC And D1_DOC = F1_DOC And F1_SERIE = D1_SERIE And F1_FORNECE = D1_FORNECE And SF1.D_E_L_E_T_ <> '*' "
cQuery += " Order By D1_DOC, D1_SERIE, D1_FORNECE, D1_ITEM"

If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
End
TcQuery cQuery New Alias "StrSQL"
MemoWrite("repgasto_remito_cantidad.sql",cQuery)

cLLave := ""
While StrSQL->(!EOF())		
	If cLLave <> StrSQL->D1_DOC+StrSQL->D1_SERIE+StrSQL->D1_FORNECE
    	If StrSQL->F1_MOEDA == nMoneda
	    	AAdd( aItens, {	StrSQL->D1_FILIAL,StrSQL->D1_ITEM,StrSQL->D1_DOC, StrSQL->D1_SERIE, ;
							StrSQL->D1_FORNECE, StrSQL->D1_QUANT, ;
							StrSQL->D1_VUNIT, ;
							StrSQL->D1_TOTAL, ;
							StrSQL->D1_PEDIDO } )
		Else
			AAdd( aItens, {	StrSQL->D1_FILIAL,StrSQL->D1_ITEM,StrSQL->D1_DOC, StrSQL->D1_SERIE,  ;
							StrSQL->D1_FORNECE, StrSQL->D1_QUANT,     							 ;
							xMoeda(StrSQL->D1_VUNIT,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->D1_EMISSAO),8),;
							xMoeda(StrSQL->D1_TOTAL,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->D1_EMISSAO),8),;
							StrSQL->D1_PEDIDO } )
		Endif
 	Endif                
 	
 	//WCS - 27/08/15 - Acumulando todas as informações do REMITO
    	If StrSQL->F1_MOEDA == nMoneda
	    	AAdd( aCompleto, {	StrSQL->D1_FILIAL,StrSQL->D1_ITEM,StrSQL->D1_DOC, StrSQL->D1_SERIE, ;
							StrSQL->D1_FORNECE, StrSQL->D1_QUANT, ;
							StrSQL->D1_VUNIT, ;
							StrSQL->D1_TOTAL, ;
							StrSQL->D1_PEDIDO , 	StrSQL->D1_COD})
		Else
			AAdd( aCompleto, {	StrSQL->D1_FILIAL,StrSQL->D1_ITEM,StrSQL->D1_DOC, StrSQL->D1_SERIE,  ;
							StrSQL->D1_FORNECE, StrSQL->D1_QUANT,     							 ;
							xMoeda(StrSQL->D1_VUNIT,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->D1_EMISSAO),8),;
							xMoeda(StrSQL->D1_TOTAL,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->D1_EMISSAO),8),;
							StrSQL->D1_PEDIDO, 	StrSQL->D1_COD } )
		Endif 	                                        
	
	//WCS - 12/09/15 - Acumulando TOTAIS DOS REMITOS
    _nPos:=Ascan(aTotCompleto,{|x| x[1]+x[2] == StrSQL->D1_DOC+StrSQL->D1_SERIE}) 
    If _nPos == 0
       AADD(aTotCompleto,{StrSQL->D1_DOC, StrSQL->D1_SERIE, xMoeda(StrSQL->D1_TOTAL,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->D1_EMISSAO),8) })
    Else
       aTotCompleto[_nPos,3]+= xMoeda(StrSQL->D1_TOTAL,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->D1_EMISSAO),8)
    End 
			
    cLLave := StrSQL->D1_DOC+StrSQL->D1_SERIE+StrSQL->D1_FORNECE	
	StrSQL->(dbSkip())   
End
StrSQL->(DbCloseArea())
Return(aItens)

//--------------------------------------------------------------------------------------------
Static Function aGastosAnt(aPedido,nTipo)

//nTipo = 1 - Factura Gastos Realizados
//nTipo = 2 - Factura Gastos Estimados
//nTipo = 3 - Factura Comercial

Local aItens := {}    
Local cQuery := "" 
Local nValTotal := 0
Local _nCont

cQuery := " Select DISTINCT F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_VALBRUT, F1_MOEDA, F1_EMISSAO, F1_VALIMP1, F1_HAWB, D1_COD, D1_ITEM, D1_TOTAL, D1_QUANT, D1_VALIMP1, D1_TOTAL, F1_HAWB"
cQuery += " From " + RetSqlName("SF1") + " SF1, "+ RetSqlName("SD1") + " SD1, " + RetSqlName("DBB") + " DBB "
cQuery += " Where F1_FILIAL = '" + xFilial("SF1")+ "' "
cQuery += " And F1_TIPODOC = '10' AND "
/*
For nI:= 1 to Len(aPedido)
	If nI == Len(aPedido)
		cQuery += " F1_POLIZA = '"+aPedido[nI]+"' )"
	Else
		cQuery += " F1_POLIZA = '"+aPedido[nI]+"' OR "
	Endif	
Next nI
*/   
cQuery += " F1_HAWB = '" + DBA->DBA_HAWB  +"'  "
cQuery += " AND DBB_HAWB = '" + DBA->DBA_HAWB  +"' AND DBB_OK = 'S' "

If nTipo <> 3  
	cQuery += " And SF1.F1_SERIE = 'FOB' "       //FACTURA COMERCAL 
	If nTipo == 1
		cQuery += " And SF1.F1_SERIE <> 'GAS' "       //GASTOS ESTIMADOS  
	Else
		cQuery += " And SF1.F1_SERIE = 'GAS' "       //GASTOS ESTIMADOS  
	EndIf
Else
	cQuery += " And SF1.F1_SERIE = 'FOB' "       //FACTURA COMERCAL 
EndIf

cQuery += " And SF1.F1_SERIE = SD1.D1_SERIE "       
cQuery += " And SF1.F1_DOC = SD1.D1_DOC "   
cQuery += " and f1_fornece = D1_FORNECE AND F1_LOJA = D1_LOJA "   
cQuery += " and DBB.DBB_FILIAL = SF1.F1_FILIAL "
cQuery += " and DBB.DBB_SERIE = SF1.F1_SERIE "
cQuery += " and DBB.DBB_DOC = SF1.F1_DOC "
cQuery += " and DBB.DBB_FORNEC = SF1.F1_FORNECE "
cQuery += " and DBB.DBB_LOJA = SF1.F1_LOJA "
cQuery += " And SF1.D_E_L_E_T_ <> '*' "  
cQuery += " And SD1.D_E_L_E_T_ <> '*' "
cQuery += " And DBB.D_E_L_E_T_ <> '*' "

If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
End 
MemoWrite("repgasto_gastos.sql",cQuery)
TcQuery cQuery New Alias "StrSQL"
While StrSQL->(!EOF())
	   	nValTotal	:= StrSQL->D1_TOTAL - StrSQL->D1_VALIMP1 
		
        //Verificando se ha duplicidades de lancamentos para a fatura e serie WCS 01-FEV-2016
	    _nPos:=Ascan(aItens,{|x| x[2] == StrSQL->F1_DOC .and. x[3] == StrSQL->F1_SERIE})
	    If _nPos == 0  .OR. nTipo == 3
		
			If StrSQL->F1_MOEDA == nMoneda
				If !IsGasImpuesto(StrSQL->F1_FILIAL,StrSQL->F1_DOC,StrSQL->F1_SERIE,StrSQL->F1_FORNECE,StrSQL->F1_EMISSAO,StrSQL->F1_HAWB)
					AAdd( aItens, {	StrSQL->F1_FILIAL,StrSQL->F1_DOC, StrSQL->F1_SERIE,	;
									StrSQL->F1_FORNECE, nValTotal, 0, 	;
									0, 0, StrSQL->F1_MOEDA ,StrSQL->D1_COD, StrSQL->D1_ITEM, StrSQL->D1_QUANT, StrSQL->D1_TOTAL , StrSQL->D1_TOTAL    } )
				Endif
			Else
				If !IsGasImpuesto(StrSQL->F1_FILIAL,StrSQL->F1_DOC,StrSQL->F1_SERIE,StrSQL->F1_FORNECE,StrSQL->F1_EMISSAO,StrSQL->F1_HAWB)
					AAdd( aItens, {	StrSQL->F1_FILIAL, StrSQL->F1_DOC, StrSQL->F1_SERIE, ;
									StrSQL->F1_FORNECE, ;
									xMoeda(nValTotal		 ,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->F1_EMISSAO),8),;
									xMoeda(0			 ,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->F1_EMISSAO),8),;
									xMoeda(0			 ,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->F1_EMISSAO),8),;
									0,	;
									StrSQL->F1_MOEDA ,StrSQL->D1_COD, StrSQL->D1_ITEM, StrSQL->D1_QUANT, StrSQL->D1_TOTAL, StrSQL->D1_TOTAL    } )
				Endif
			EndIf	  
		Else	
	        
	        //Buscando descripcion del producto com monto mas grande WCS 04-FEV-2016
	        For _nCont := 1 to Len(aItens)
	           If  StrSQL->D1_TOTAL > aItens[_nCont,14]            
		           aItens[_nPos,10] := StrSQL->D1_COD
	           End
	        Next _nCont

	        aItens[_nPos,5] := aItens[_nPos,5] + nValTotal      
	        aItens[_nPos,7] := aItens[_nPos,5] - 0      
	        aItens[_nPos,13] := aItens[_nPos,13] + StrSQL->D1_TOTAL      
	
		Endif
	StrSQL->(dbSkip())   
End
StrSQL->(DbCloseArea())
Return(aItens)

//-------------------------------------------------------------------------------------------------
Static Function aGastosRegu(aRemitos)
Local aItens := {}    
Local cQuery := ""
Local nI	 := 0
cQuery := " Select D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_TOTAL, D1_NFORI, D1_SERIORI, F1_VALBRUT, F1_MOEDA, F1_EMISSAO"
cQuery += " From " + RetSqlName("SD1") + " SD1 , " + RetSqlName("SF1") + " SF1" 
cQuery += " Where D1_FILIAL = '" + aRemitos[1][1]+ "' AND D1_FILIAL = F1_FILIAL"
cQuery += " And D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE And D1_FORNECE = F1_FORNECE"
cQuery += " And D1_TIPODOC = '13' AND D1_TIPODOC = F1_TIPODOC"
cQuery += " AND ( "
For nI:= 1 to Len(aRemitos)
	If nI == Len(aRemitos)
		cQuery += " (D1_NFORI = '" + aRemitos[nI][3] +"' AND D1_SERIORI = '" + aRemitos[nI][4]+"'))"
	Else
		cQuery += " (D1_NFORI = '" + aRemitos[nI][3] +"' AND D1_SERIORI = '" + aRemitos[nI][4]+"') OR"
	Endif
Next nI
cQuery += " And SD1.D_E_L_E_T_ <> '*' And SF1.D_E_L_E_T_ <> '*' "
//cQuery += " And D1_UREGUL = 'R'"
cQuery += " Order By D1_DOC, D1_SERIE, D1_FORNECE"
If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
End   
TcQuery cQuery New Alias "StrSQL"

cLLave := ""
While StrSQL->(!EOF())
	If cLLave <> StrSQL->D1_DOC+StrSQL->D1_SERIE+StrSQL->D1_FORNECE
		If StrSQL->F1_MOEDA == nMoneda
			AAdd( aItens, {StrSQL->D1_FILIAL,StrSQL->D1_DOC, StrSQL->D1_SERIE, ;
						StrSQL->D1_FORNECE, StrSQL->D1_NFORI, StrSQL->D1_SERIORI, StrSQL->F1_VALBRUT } )
		Else
			AAdd( aItens, {StrSQL->D1_FILIAL,StrSQL->D1_DOC, StrSQL->D1_SERIE, 			;
							StrSQL->D1_FORNECE, StrSQL->D1_NFORI, StrSQL->D1_SERIORI, 	; 
					 		xMoeda(StrSQL->F1_VALBRUT,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->F1_EMISSAO),8) } )
		Endif
		
	Endif
	cLLave := StrSQL->D1_DOC+StrSQL->D1_SERIE+StrSQL->D1_FORNECE	
	StrSQL->(dbSkip())   
End
StrSQL->(DbCloseArea())
Return(aItens)

//-------------------------------------------------------------------------------------------------
Static Function aDataGReg(aRemitos)
Local aItens := {}    
Local cQuery := ""
Local nI	 := 0

cQuery := " Select D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_QUANT, D1_TOTAL, D1_NFORI, D1_SERIORI, F1_VALBRUT, D1_ITEMORI, D1_ITEM, D1_COD, F1_MOEDA, F1_EMISSAO "
cQuery += " From " + RetSqlName("SD1") + " SD1 , " + RetSqlName("SF1") + " SF1" 
cQuery += " Where D1_FILIAL = '" + aRemitos[1][1]+ "' AND D1_FILIAL = F1_FILIAL"
cQuery += " And D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE And D1_FORNECE = F1_FORNECE"
cQuery += " And D1_TIPODOC = '13' AND D1_TIPODOC = F1_TIPODOC"
cQuery += " AND ( "
For nI:= 1 to Len(aRemitos)
	If nI == Len(aRemitos)
		cQuery += " (D1_NFORI = '" + aRemitos[nI][3] +"' AND D1_SERIORI = '" + aRemitos[nI][4]+"'))"
	Else
		cQuery += " (D1_NFORI = '" + aRemitos[nI][3] +"' AND D1_SERIORI = '" + aRemitos[nI][4]+"') OR"
	Endif
Next nI
cQuery += " And SD1.D_E_L_E_T_ <> '*' And SF1.D_E_L_E_T_ <> '*' "
//cQuery += " And D1_UREGUL = 'R'"
cQuery += " Order By D1_DOC, D1_SERIE, D1_FORNECE"
If Select("SQLReg") > 0  //En uso
   SQLReg->(DbCloseArea())
End   
TcQuery cQuery New Alias "SQLReg"

While SQLReg->(!EOF())
	aRecnoRem 	:= {SQLReg->D1_FILIAL, SQLReg->D1_NFORI, SQLReg->D1_SERIORI, SQLReg->D1_FORNECE, SQLReg->D1_ITEMORI }
	cItemPc 	:= ItemPC(aRecnoRem)	
	If SQLReg->F1_MOEDA == nMoneda
		AAdd( aItens, {	SQLReg->D1_FILIAL, SQLReg->D1_DOC, SQLReg->D1_SERIE, ;
						SQLReg->D1_FORNECE, SQLReg->D1_ITEM, SQLReg->D1_COD, ;
						SQLReg->D1_TOTAL, ;
						SQLReg->D1_ITEMORI, SQLReg->D1_NFORI, SQLReg->D1_SERIORI,;
						SQLReg->F1_VALBRUT, ;
						cItemPc, SQLReg->D1_QUANT } )
	Else
		AAdd( aItens, {	SQLReg->D1_FILIAL, SQLReg->D1_DOC, SQLReg->D1_SERIE, ;
						SQLReg->D1_FORNECE, SQLReg->D1_ITEM, SQLReg->D1_COD, ;
						xMoeda(SQLReg->D1_TOTAL,SQLReg->F1_MOEDA,nMoneda,STOD(SQLReg->F1_EMISSAO),8), 	;
						SQLReg->D1_ITEMORI, SQLReg->D1_NFORI, SQLReg->D1_SERIORI, 				;
						xMoeda(SQLReg->F1_VALBRUT,SQLReg->F1_MOEDA,nMoneda,STOD(SQLReg->F1_EMISSAO),8), ;
						cItemPc, SQLReg->D1_QUANT } )
	Endif
	SQLReg->(dbSkip())
End
SQLReg->(DbCloseArea())
Return(aItens)

//-------------------------------------------------------------------------------------------------
Static Function ItemPC(aRecnoRem)
Local cItemPC	:= ""
Local cQuery	:= ""
cQuery := " Select D1_ITEM, D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_QUANT, D1_VUNIT, D1_TOTAL, D1_ITEMPC, D1_PEDIDO"
cQuery += " From " + RetSqlName("SD1") + " SD1 "
cQuery += " Where D1_FILIAL = '"+ aRecnoRem[1]+ "' "
cQuery += " And D1_DOC = '" 	+ aRecnoRem[2]+ "' "
cQuery += " And D1_SERIE = '" 	+ aRecnoRem[3]+ "' "
cQuery += " And D1_FORNECE = '" + aRecnoRem[4]+ "' "
cQuery += " And D1_TIPODOC = '60' AND D1_PEDIDO = '"+cPedido+"'"
cQuery += " And D1_ITEM = '" 	+ aRecnoRem[5]+ "' "
cQuery += " And SD1.D_E_L_E_T_ <> '*' "

If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
End   
TcQuery cQuery New Alias "StrSQL"

If !Empty(StrSQL->D1_ITEMPC)	
	cItemPc := StrSQL->D1_ITEMPC
Endif
StrSQL->(DbCloseArea())
Return(cItemPc)

//-------------------------------------------------------------------------------------------------
Static Function aGastImp(aRemitos)
Local aItens := {}    
Local cQuery := ""
Local nI	 := 0
cQuery := " Select D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_TOTAL, D1_NFORI, D1_SERIORI, F1_VALBRUT, F1_MOEDA, F1_EMISSAO"
cQuery += " From " + RetSqlName("SD1") + " SD1 , " + RetSqlName("SF1") + " SF1" 
cQuery += " Where D1_FILIAL = '" + aRemitos[1][1]+ "' AND D1_FILIAL = F1_FILIAL"
cQuery += " And D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE And D1_FORNECE = F1_FORNECE"
cQuery += " And D1_TIPODOC = '13' AND D1_TIPODOC = F1_TIPODOC"
cQuery += " AND ( "
For nI:= 1 to Len(aRemitos)
	If nI == Len(aRemitos)
		cQuery += " (D1_NFORI = '" + aRemitos[nI][3] +"' AND D1_SERIORI = '" + aRemitos[nI][4]+"'))"
	Else
		cQuery += " (D1_NFORI = '" + aRemitos[nI][3] +"' AND D1_SERIORI = '" + aRemitos[nI][4]+"') OR"
	Endif
Next nI
cQuery += " And SD1.D_E_L_E_T_ <> '*' And SF1.D_E_L_E_T_ <> '*' "
//cQuery += " And D1_UREGUL <> 'R'"
cQuery += " Order By D1_DOC, D1_SERIE, D1_FORNECE"
If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
Endif
TcQuery cQuery New Alias "StrSQL"

cLLave := ""
While StrSQL->(!EOF())
	If cLLave <> StrSQL->D1_DOC+StrSQL->D1_SERIE+StrSQL->D1_FORNECE
		If StrSQL->F1_MOEDA == nMoneda
			AAdd( aItens, {StrSQL->D1_FILIAL,StrSQL->D1_DOC, StrSQL->D1_SERIE, ;
						StrSQL->D1_FORNECE, StrSQL->D1_NFORI, StrSQL->D1_SERIORI, StrSQL->F1_VALBRUT } )
		Else
			AAdd( aItens, {StrSQL->D1_FILIAL,StrSQL->D1_DOC, StrSQL->D1_SERIE, ;
						StrSQL->D1_FORNECE, StrSQL->D1_NFORI, StrSQL->D1_SERIORI, ;
						xMoeda(StrSQL->F1_VALBRUT,StrSQL->F1_MOEDA,nMoneda,STOD(StrSQL->F1_EMISSAO),8) } )
		Endif
	Endif
	cLLave := StrSQL->D1_DOC+StrSQL->D1_SERIE+StrSQL->D1_FORNECE	
	StrSQL->(dbSkip())
End
StrSQL->(DbCloseArea())
Return(aItens)         

//-------------------------------------------------------------------------------------------------
Static Function IsGasImpuesto(cSuc,cDoc,cSer,cProv,dFech,cPoliza)
Local cQuery := ""
Local lRet	 := .F.
         
cPoliza := AllTrim(cPoliza)
If Empty(cPoliza) .Or. cPoliza == '0'
	Return(.F.)
Endif
cQuery := " Select D1_TES"
cQuery += " From " + RetSqlName("SD1") + " SD1 , " + RetSqlName("SF1") + " SF1" 
cQuery += " Where D1_FILIAL = '" + cSuc+ "' And D1_DOC = '"+ cDoc+ "' And D1_SERIE = '"+ cSer+ "' And D1_FORNECE = '"+ cProv+ "' "
cQuery += " And D1_FILIAL = F1_FILIAL And D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE And D1_FORNECE = F1_FORNECE"
cQuery += " And D1_TIPODOC = '10' AND D1_TIPODOC = F1_TIPODOC And D1_EMISSAO = F1_EMISSAO"
cQuery += " And SD1.D_E_L_E_T_ <> '*' And SF1.D_E_L_E_T_ <> '*' "
cQuery += " Order By D1_TES"
If Select("SqlImpuesto") > 0  //En uso
   SqlImpuesto->(DbCloseArea())
Endif
TcQuery cQuery New Alias "SqlImpuesto"

While SqlImpuesto->(!EOF())
	If SqlImpuesto->D1_TES == '010'
		lRet := .T.
	Else
		Return(.F.)
	Endif

	SqlImpuesto->(dbSkip())
End
SqlImpuesto->(DbCloseArea())
Return(lRet)

//-------------------------------------------------------------------------------------------------
Static Function ValidPerg(cPerg)
Local aRegs := {}
Local i
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{"01","Moneda             		:","mv_ch1","N",01,0,1,"C","mv_par01","BOLIVIANO"  	,"DOLAR"   	,""        ,""     ,""	,""})
aAdd(aRegs,{"02","Mostrar datos Pedido 		:","mv_ch2","N",01,0,1,"C","mv_par02","Si"  		,"No"   	,""        ,""     ,""	,""})
aAdd(aRegs,{"03","Mostrar Gasto Imp (Normal):","mv_ch3","N",01,0,1,"C","mv_par03","Si"  		,"No"   	,""        ,""     ,""	,""})

DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aRegs)
   DbSeek(cPerg+aRegs[i][1])
   If !Found()
      RecLock("SX1",!Found())
         SX1->X1_GRUPO    	:= cPerg
         SX1->X1_ORDEM    	:= aRegs[i][01]
         SX1->X1_PERSPA   	:= aRegs[i][02]
         SX1->X1_VARIAVL  	:= aRegs[i][03]
         SX1->X1_TIPO     	:= aRegs[i][04]
         SX1->X1_TAMANHO  	:= aRegs[i][05]
         SX1->X1_DECIMAL  	:= aRegs[i][06]
         SX1->X1_PRESEL   	:= aRegs[i][07]
         SX1->X1_GSC      	:= aRegs[i][08]
         SX1->X1_VAR01    	:= aRegs[i][09]
         SX1->X1_DEFSPA1  	:= aRegs[i][10]
         SX1->X1_DEFSPA2  	:= aRegs[i][11]
         SX1->X1_DEFSPA3  	:= aRegs[i][12]
         SX1->X1_DEFSPA4  	:= aRegs[i][13]
         SX1->X1_F3       	:= aRegs[i][14]
         SX1->X1_VALID    	:= aRegs[i][15]
      MsUnlock()
   Endif
Next
Return

Static function fCabec(oReport,oSection0)
cDesMoeda 	:= If( nMoneda==1,"(en Pesos)","(en Dolar)")
cTitulo 	:= "Informe de Gastos de Importacion "
oReport:SAY(oReport:Row(), 700, Upper(cTitulo)  , oFont20TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.8)
oReport:SAY(oReport:Row(), 1000, Upper(cDesMoeda), oFont20TN	,1000,CLR_BLACK ,CLR_BLACK )	;	oReport:SkipLine(1.5)
oReport:PrintText(" ")
oReport:SkipLine(3)
//imprimendo la primera seccion
oSection0:init()
oSection0:Cell("proveedor"):HideHeader() := .T.
oSection0:Cell("codigo"):HideHeader() := .T.
oSection0:Cell("nombre"):HideHeader() := .T.

oSection0:Cell("proveedor"):SetValue("PROVEEDOR: ")
oSection0:Cell("codigo"):SetValue(SC7->C7_FORNECE)
//buscamos al proveedor
dbSelectArea("SA2")
dbSetOrder(1)
If dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
	oSection0:Cell("nombre"):SetValue(SA2->A2_NOME)
Endif
oSection0:printline()
oSection0:finish()
oReport:thinline()
oReport:SkipLine(1)
return nil
