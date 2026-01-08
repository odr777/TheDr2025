#include 'protheus.ch'
#include 'parmtype.ch'
#DEFINE nFinHoja 3000
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ GCTBI101 ³ Autor ³ Ariel Dominguez         ³ Data ³ 19/02/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Comprobantes Contables			                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GCTBI101()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACIONES SUFRIDAS DESDE A CONSTRUCCION INICIAL.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Fecha    ³   Motivo da Alteracao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		  ³	                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function GCTBI101()    
	Local cString  :="CT2"									// Alias del archivo principal
	Local aOrd     := {"Correlativo","Tipo de Comprobante"}// Formas de Ordenamiento
	Local cDesc1   := "COMPROBANTES CONTABLES"                       // Descripciones que aparecen en la pantalla de parametros
	Local cDesc2   := "Muestra los Comprobantes Contables"
	Local cDesc3   := "ordenado por correlativo o tipo"			   						
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variables Private(Basicas)                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aReturn 	:= {"A Raya", 1,"Administracion", 1, 2, 1, "",1 }
	Private nLastKey 	:= 0
	Private cPerg   	:= "GNR101"
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variables Utilizadas en la funcion IMPR                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private Titulo  := "COMPROBANTE CONTABLE"
	Private nLi     := 0
	Private nTamanho:="G"
	Private nOrden
	Private dFechaDe	:= Ctod("//") // Almacena la fecha inicial para el informe en los parametros (mv_par01).
	Private dFechaA		:= Ctod("//") // Almacena la fecha final para el informe en los parametros (mv_par02).
	Private cTipo		:= "3" // Almacena el tipo de comprobante a imprimir en los parametros (mv_par03). 1=Ingreso 2=Egreso 3=Traspaso 4=Manuales
	Private cCorrDe		:= ""
	Private cCorrA		:= ""
	Private cLoteDe		:= ""
	Private cLoteA		:= ""
	Private cSbLtDe		:= ""
	Private cSbLtA		:= ""
	Private cDocDe		:= ""
	Private cDocA		:= "" 
	Private cNroCmp		:= ""	
	
	//Objetos p/ Impresion Grafica 
	Private oFont07,oFont08, oFont10, oFont15, oFont10n, oFont21, oFont12,oFont12n,oFont16, oFont07n, oFont08n, oFont10n ,oFont09n
	Private oPrint
	
	oFont06	:= TFont():New("Courier New",06,06,,.F.,,,,.T.,.F.)
	oFont07	:= TFont():New("Courier New",07,07,,.F.,,,,.T.,.F.)
	oFont07n:= TFont():New("Courier New",07,07,,.T.,,,,.T.,.F.)		//negrito
	oFont08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	oFont08n:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)		//negrito
	oFont09n:= TFont():New("Courier New",09,09,,.T.,,,,.T.,.F.)     //negrito
	oFont10	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	oFont10n:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)     //negrito
	oFont12	:= TFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)		//Normal s/negrito
	oFont12n:= TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)		//Normal s/negrito
	oFont15	:= TFont():New("Courier New",15,15,,.T.,,,,.T.,.F.)
	oFont21 := TFont():New("Courier New",21,21,,.T.,,,,.T.,.T.)
	oFont16	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica las perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte(cPerg,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia control para la funcion SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:="GCTBI101"            //Nombre por defecto del informe cuando se graba en disco   

	wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

	If nLastKey = 27
   		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
  		Return
	Endif
	
	/*/   
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis utilizadas para parametros                         ³
	³ mv_par01        //  Fecha Inicial     			           ³
	³ mv_par02        //  Fecha Final   					       ³
	³ mv_par03        //  Tipo Comprobante		                   ³
    ³ mv_par04        //  De Correlativo		                   ³
    ³ mv_par05        //  A Correlativo 		                   ³	
    ³ mv_par06        //  De Lote				                   ³
    ³ mv_par07        //  A Lote		 		                   ³	
    ³ mv_par08        //  De SubLote			                   ³
    ³ mv_par09        //  A SubLote		 		                   ³	
    ³ mv_par10        //  De Documento			                   ³
    ³ mv_par11        //  A Documento	 		                   ³ 
	³ mv_par12        //  Numero completo del asiento              ³     	
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*/
	/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
	nOrden   := aReturn[8]
	
	dFechaDe	:= mv_par01
	dFechaA		:= mv_par02
	cTipo		:= ALLTRIM(STR(mv_par03)) 
	cCorrDe		:= ALLTRIM(mv_par04)
	cCorrA		:= ALLTRIM(mv_par05)
	cLoteDe		:= ALLTRIM(mv_par06)
	cLoteA		:= ALLTRIM(mv_par07)
	cSbLtDe		:= ALLTRIM(mv_par08)
	cSbLtA		:= ALLTRIM(mv_par09)
	cDocDe		:= ALLTRIM(mv_par10)
	cDocA		:= ALLTRIM(mv_par11)	
	cNroCmp		:= ALLTRIM(mv_par12)   
	
	oPrint 	:= TMSPrinter():New(Titulo) 
	oPrint	:SetPortrait() // Vertical
	//oPrint	:SetLandscape()	//Horizontal
   
	RptStatus({|lEnd| GCTBI10101(lEnd,WnRel,cString)})
	oPrint:Preview()  		// Visualiza impressao grafica antes de imprimir
	
	oPrint:End()	                                            
	MS_FLUSH()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GCTBI101  ºAutor  ³Ariel Dominguez     º Data ³  18/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion encargada de controlar la impresion                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GCTBI10101(lEnd,WnRel,cString)  	
	Local _cSQL			:=""	//Consulta para SQL
    Local dFecha		:= Ctod("//")    //Fecha del Asiento
    Local cLote			:= ""    //Lote del Asiento
	Local cSubLote		:= ""    //SubLote del Asiento
	Local cDoc			:= ""    //Documento del Asiento  
    Local cCorre		:= ""    //Correlativo del Asiento
    Local cGlosa		:= "" 	 //Glosa del Asiento
    Local cGestion		:= ""	 //Gestion del Asiento
    Local cPeriodo		:= ""	 //Periodo del Asiento
    
    Local cConta		:= ""	 //Cuenta del Asiento Debito y Credito
    Local cDescConta	:= ""    //Decripcion de la Cuenta
    Local cItemC		:= ""    //Item Contable 
    Local cDescItem		:= ""	 //Descripcion del Item Contable
    Local cClvl			:= ""    //Clase de Valor
    Local cHist			:= ""	 //Historial
    Local nValorD		:= 0     //Valor al Debito
    Local nValorC		:= 0     //Valor al Credito
    
    Local cContaC		:= ""	 //Cuenta del Asiento Debito y Credito
    Local cDContaC		:= ""    //Decripcion de la Cuenta
    Local cItemCC		:= ""    //Item Contable 
    Local cDItemC		:= ""	 //Descripcion del Item Contable
    
    Local cEC05C		:= ""    //Entidad 05 C
    Local cEC05D		:= ""    //Entidad 05 D
    Local cEC05 		:= ""    //Entidad 05 
    

    Local cCCC			:= ""    //C.Costo C
    Local cCCD			:= ""    //C.Costo D
    Local cCC			:= ""

    
    Local nSumaD		:= 0     //Suma de valor al Debito
	Local nSumaC		:= 0     //Suma de valor al Credito 
	
	Local nCorteH		:= 88	 //Corte de Linea para el historial  
	Local nPosFin		:= 0	 //Posicion para corte de linea
    
	Private nInicio		:= 650   //430   //Coordenada en "y" para comenzar a imprimir el primer empleado por cada pagina
	Private nFin		:= 50 	//Cantidad a restar en coordenada "x" para imprimir los datos del empleado
	Private nSepara		:= 50   //Cantidad a restar en coordenada "x" para imprimir los datos del empleado	
    Private nContPage	:= 0    //Conta N. de Pagina      
    Private cTpCompr	:= ""
    
	Private nMaxCtb		:= 36   //N. maximo de lineas del asiento por pagina
	
	Private nCol01		:= 80  	//Coordenada "Y" de la columna 1 - CTA.
	Private nCol02		:= 250	//Coordenada "Y" de la columna 2 - DESC. CTA.
	Private nCol03		:= 80 //780	//Coordenada "Y" de la columna 3 - ITEM CUENTA
	Private nCol04		:= 230 //Coordenada "Y" de la columna 4 - DESC. ITEM
  //	Private nCol05		:= 580 //Coordenada "Y" de la columna 5 - CLASE DE VALOR //no se usa
	Private nCol06		:= 1200 //Coordenada "Y" de la columna 6 - entidad05 
	Private nCol07		:= 1280 //Coordenada "Y" de la columna 7 - desc entidad 05
	Private nCol08		:= 840 //2280 //Coordenada "Y" de la columna 8 - centro de costo 
	Private nCol09		:= 950 //Coordenada "Y" de la columna 7 - desccentro de costo  
	Private nCol10		:= 1700 //2280 //Coordenada "Y" de la columna 8 - VALOR DEBITO 
	Private nCol11		:= 2000 //Coordenada "Y" de la columna 7 - VALOR CREDITO 
	Private nCol12		:= 850 //2280 //Coordenada "Y" de la columna 8 - HISTORIAL      
	Private nCol13		:= 850 //2280 //Coordenada "Y" de la columna 8 - HISTORIAL      	
	
  	
	_cSQL:="SELECT CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_DC,"
	_cSQL:=_cSQL+"CT2_DEBITO,(SELECT CT1_DESC01 FROM CT1010 WHERE CT1010.D_E_L_E_T_ <> '*' AND CT1_CONTA = CT2_DEBITO) AS CTADEB,"
	_cSQL:=_cSQL+"CT2_CREDIT,(SELECT CT1_DESC01 FROM CT1010 WHERE CT1010.D_E_L_E_T_ <> '*' AND CT1_CONTA = CT2_CREDIT) AS CTACDT,"
	_cSQL:=_cSQL+"CT2_VALOR,
	_cSQL:=_cSQL+"CT2_CCD,'' AS CCDDSC," 
	_cSQL:=_cSQL+"CT2_CCC,'' AS CCCDSC," 
	_cSQL:=_cSQL+"CT2_SEGOFI,CT2_HIST,'' CT2_EC05DB,'' CT2_EC05CR,"
	_cSQL:=_cSQL+"CT2_ITEMD,'' AS ITMDEB,"
	_cSQL:=_cSQL+"CT2_ITEMC,'' AS ITMCTR,"
	_cSQL:=_cSQL+"CT2_CLVLDB,CT2_CLVLCR,"
	_cSQL:=_cSQL+"'' CT2_EC05DB,'' AS EC05DSCD,"
	_cSQL:=_cSQL+"'' CT2_EC05CR,'' AS EC05DSCC "    //AND  CV0_CLASSE='2'
	_cSQL:=_cSQL+" FROM CT2010"	
	_cSQL:=_cSQL+" WHERE D_E_L_E_T_ <> '*'" 
	_cSQL:=_cSQL+" AND CT2_DATA BETWEEN	'" + DTOS(dFechaDe) + "' AND '" + DTOS(dFechaA) + "'"  
	
	If !EMPTY(cNroCmp)
		_cSQL:=_cSQL+" AND CT2_LOTE =	'" + SUBSTR(cNroCmp,1,6) + "'"
		_cSQL:=_cSQL+" AND CT2_SBLOTE =	'" + SUBSTR(cNroCmp,7,3) + "'"
		_cSQL:=_cSQL+" AND CT2_DOC =	'" + SUBSTR(cNroCmp,10,6)+ "'"
	Else
		_cSQL:=_cSQL+" AND CT2_SEGOFI BETWEEN	'" + cCorrDe + "' AND '" + cCorrA + "'" 										
		_cSQL:=_cSQL+" AND CT2_LOTE BETWEEN	'" + cLoteDe + "' AND '" + cLoteA + "'" 										
		_cSQL:=_cSQL+" AND CT2_SBLOTE BETWEEN	'" + cSbLtDe + "' AND '" + cSbLtA + "'" 										
		_cSQL:=_cSQL+" AND CT2_DOC BETWEEN	'" + cDocDe + "' AND '" + cDocA + "'" 										
	Endif
	
	_cSQL:=_cSQL+" AND CT2_MOEDLC = '01'"   
	_cSQL:=_cSQL+" AND CT2_TPSALD = '1'"   			 	
	DO CASE 
		case cTipo = '1'
			_cSQL:=_cSQL+" AND CT2_DIACTB = '07'"
			cTpCompr := "INGRESO" 
	 	case cTipo = '2'
			_cSQL:=_cSQL+" AND CT2_DIACTB = '08'"	
			cTpCompr := "EGRESO"
		case cTipo = '3'
	   		_cSQL:=_cSQL+" AND CT2_DIACTB = '09'"	 
	   		cTpCompr := "TRASPASO"
		case cTipo = '4'
	   		_cSQL:=_cSQL+" AND CT2_DIACTB = '06'"
	   		cTpCompr := "MANUAL"			
	END CASE
	_cSQL:=_cSQL+" ORDER BY CT2_DATA,CT2_NODIA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA"

   	_cSQL:= ChangeQuery(_cSQL)
   	//MemoWrite("cDebugctb.sql",_cSQL)   
	cArea1 := "CTBCOM"			
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL), cArea1 ,.T.,.F.)   
	dbSelectArea(cArea1)
	dbGoTop()
	//Imprimir encabezado 
	GCTBI10102()	
	dbSelectArea(cArea1)
	
	//Asignacion del primer registro
	If !EOF()
		dFecha		:= stod(alltrim(CT2_DATA))    //Fecha del Asiento
		cLote		:= ALLTRIM(CT2_LOTE)    //Lote del Asiento
		cSubLote	:= ALLTRIM(CT2_SBLOTE)    //SubLote del Asiento
		cDoc		:= ALLTRIM(CT2_DOC)    //Documento del Asiento
		cTpAsiento	:= CT2_DC //Tipo de Asiento
		cCorre		:= ALLTRIM(CT2_SEGOFI)    //Correlativo del Asiento
    	cGestion	:= substr(CT2_DATA,1,4)	 //Gestion del Asiento
    	cPeriodo	:= substr(CT2_DATA,5,2)	 //Periodo del Asiento	 
    	oPrint:say (270 + (nSepara * (nLi)),nCol01 - nFin,"FECHA:       "+ ALLTRIM(dtoc(dFecha)) +"         PERIODO: "+cPeriodo+" GESTION: "+cGestion,oFont12)          				
    	oPrint:say (270 + (nSepara * (nLi + 1.5)),nCol01 - nFin,"LOTE:        "+cLote+"             SUBLOTE: "+cSubLote+"        DOCUMENTO: "+cDoc + "        CORRELATIVO: "+cCorre,oFont12)          				
    	//oPrint:say (270 + (nSepara * (nLi + 3)),nCol01 - nFin,"CORRELATIVO: "+cCorre,oFont12n)
    //	nLi += 1
	EndIf
	
	//Impresion del cuerpo de imforme       
	
	while !EOF()
		//Pregunta para imprimir y comenzar una nueva pagina
		If nLi > nMaxCtb        
			oPrint:EndPage()
			oPrint:StartPage()
			GCTBI10102()			
		   	nLi		:= 1
		EndIf        

		If cCorre <> ALLTRIM(CT2_SEGOFI)
			oPrint:line(nInicio + ((nSepara + 3) * (nLi - 1.2)),0080 - nFin,nInicio + ((nSepara + 3) * (nLi - 1.2)),2300)
			oPrint:say (nInicio + (nSepara * (nLi)),nCol01 - nFin,"TOTAL DEBITO:",oFont10)          				
			oPrint:say (nInicio + (nSepara * (nLi)),nCol10 - nFin,PADR(Transform(nSumaD,'@E 9,999,999,999.99'),18," "),oFont10)
			nLi += 1
			oPrint:say (nInicio + (nSepara * (nLi)),nCol01 - nFin,"TOTAL CREDITO:",oFont10)          							
			oPrint:say (nInicio + (nSepara * (nLi)),nCol11 - nFin,PADR(Transform(nSumaC,'@E 9,999,999,999.99'),18," "),oFont10)
			nSumaD := 0
			nSumaC := 0 
			nLi += 4
			oPrint:Say(nInicio + (nSepara * (nLi)), nCol03 +  50 , Replicate("_",20), oFont10)
   			oPrint:Say(nInicio + (nSepara * (nLi)) + 60, nCol03 + 100, "Emitido por", oFont10)  
   			
			oPrint:Say(nInicio + (nSepara * (nLi)), nCol08 +  50 , Replicate("_",20), oFont10)
		 	oPrint:Say(nInicio + (nSepara * (nLi)) + 60, nCol08 + 100, "Revisado por", oFont10)   			
   			
			oPrint:Say(nInicio + (nSepara * (nLi)), nCol06 +  50 , Replicate("_",20), oFont10)
   			oPrint:Say(nInicio + (nSepara * (nLi)) + 60, nCol06 + 100, "Aprobado por", oFont10)
			
			
			oPrint:EndPage()
			oPrint:StartPage()
			GCTBI10102()			
		   	nLi		:= 0
		   	
		   	dFecha		:= stod(alltrim(CT2_DATA))    //Fecha del Asiento
			cLote		:= ALLTRIM(CT2_LOTE)    //Lote del Asiento
			cSubLote	:= ALLTRIM(CT2_SBLOTE)    //SubLote del Asiento
			cDoc		:= ALLTRIM(CT2_DOC)    //Documento del Asiento
			cTpAsiento	:= CT2_DC //Tipo de Asiento
			cCorre		:= ALLTRIM(CT2_SEGOFI)    //Correlativo del Asiento
    		cGestion	:= substr(CT2_DATA,1,4)	 //Gestion del Asiento
    		cPeriodo	:= substr(CT2_DATA,5,2)	 //Periodo del Asiento	 
    		oPrint:say (270 + (nSepara * (nLi)),nCol01 - nFin,"FECHA:       "+ ALLTRIM(dtoc(dFecha)) +"         PERIODO: "+cPeriodo+" GESTION: "+cGestion,oFont12)          				
    		//oPrint:say (270 + (nSepara * (nLi + 1.5)),nCol01 - nFin,"LOTE:        "+cLote+"             SUBLOTE: "+cSubLote,oFont12)  
    		oPrint:say (270 + (nSepara * (nLi + 1.5)),nCol01 - nFin,"LOTE:        "+cLote+"             SUBLOTE: "+cSubLote+"        DOCUMENTO: "+cDoc,oFont12)          				        				
    		oPrint:say (270 + (nSepara * (nLi + 3)),nCol01 - nFin,"CORRELATIVO: "+cCorre,oFont12n)
    		nLi += 1
		EndIf
		
		DO CASE 
		case CT2_DC = '1'
			cConta 		:= ALLTRIM(CT2_DEBITO)
			cDescConta 	:= ALLTRIM(CTADEB)
			cItemC		:= ALLTRIM(CT2_ITEMD)
			cDescItem	:= ALLTRIM(ITMDEB)
			cClvl		:= ALLTRIM(CT2_CLVLDB)
			cEC05       := ""//ALLTRIM(CT2_EC05DB)
			cEC05DESC   := ""//ALLTRIM(EC05DSCD)
			cCC			:= Alltrim(CT2_CCD)//centro de costo debito
			CCDDESC		:= Alltrim(CCDDSC)//centro de costo debito descripcion
			nValorD		:= CT2_VALOR   
			nValorC		:= 0
			nSumaD		:= nSumaD + CT2_VALOR 	
	 	case CT2_DC = '2'
			cConta 		:= ALLTRIM(CT2_CREDIT)
			cDescConta 	:= ALLTRIM(CTACDT)
			cItemC		:= ALLTRIM(CT2_ITEMC)
			cDescItem	:= ALLTRIM(ITMCTR)
			cClvl		:= ALLTRIM(CT2_CLVLCR)
			cEC05       := ""//ALLTRIM(CT2_EC05CR)
			cEC05DESC   := ""//ALLTRIM(EC05DSCC)
			cCC		:= ALLTRIM(CT2_CCC) //centro de costo debito
			CCDDESC		:= Alltrim(CCCDSC)//centro de costo debito
			nValorC		:= CT2_VALOR   
			nValorD		:= 0
			nSumaC		:= nSumaC + CT2_VALOR 	
		case CT2_DC = '3'
			cConta 		:= ALLTRIM(CT2_DEBITO)
			cDescConta 	:= ALLTRIM(CTADEB)
			cItemC		:= ALLTRIM(CT2_ITEMD)
			cDescItem	:= ALLTRIM(ITMDEB)
			
			cContaC 	:= ALLTRIM(CT2_CREDIT)
			cDContaC	:= ALLTRIM(CTACDT)
			cItemCC		:= ALLTRIM(CT2_ITEMC)
			cDItemC		:= ALLTRIM(ITMCTR)

			cEC05       := "" // ALLTRIM(CT2_EC05DB)
			cEC05DESC  := "" // ALLTRIM(EC05DSCD)
			cCC			:= ALLTRIM(CT2_CCD)//centro de costo debito
			CCDDESC		:= Alltrim(CCDDSC)//centro de costo debito descripcion

			cEC05C      := ""//ALLTRIM(CT2_EC05CR)
			cEC05DESCC  := ""//ALLTRIM(EC05DSCC)
			cCCC		:= ALLTRIM(CT2_CCC)//centro de costo credito
			CCCDESC		:= Alltrim(CCCDSC)//centro de costo credtio desc
			
			cClvl		:= ALLTRIM(CT2_CLVLDB)
			nValorD		:= CT2_VALOR   
			nValorC		:= CT2_VALOR   
			nSumaD		:= nSumaD + CT2_VALOR 	
			nSumaC		:= nSumaC + CT2_VALOR 				
		END CASE
		//cHist:=""
		cHist := ALLTRIM(CT2_HIST)
		
		If CT2_DC == '4'
			oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol12 - nFin,cHist,oFont08)
		Else
			oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol01 - nFin,cConta,oFont10)          				
			oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol02 - nFin,cDescConta,oFont10) 
						
		   //	oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol05 - nFin,cClvl,oFont10)  no se esta usando clase valor
		   	If !EMPTY(cEC05)
		     	oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol06 - nFin,cEC05,oFont08)
			    oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol07 - nFin,substr(cEC05DESC,1,30),oFont08)	
			endif
		    If !EMPTY(cCC)	    
		   		oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol08 - nFin,cCC,oFont08)
		   		oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol09 - nFin,CCDDESC,oFont08)			
			endif
			oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol10 - nFin,PADR(Transform(nValorD,'@E 9,999,999,999.99'),18," "),oFont10)
		
			If CT2_DC <> '3'
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol11 - nFin,PADR(Transform(nValorC,'@E 9,999,999,999.99'),18," "),oFont10)
			else
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol11 - nFin,PADR(Transform(0,'@E 9,999,999,999.99'),18," "),oFont10) //verificar 			
			endif
			
			//nLi += 1
			If !EMPTY(cItemC)				
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol03 - nFin,cItemC,oFont08) 
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol04 - nFin,cDescItem,oFont08) 
			EndIF
			
			If Len(cHist) <= nCorteH
  				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol13 - nFin,cHist,oFont08)
			Else
	  			nPosFin := RAT( " ", SubStr( cHist, 1, nCorteH) )
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol13 - nFin,AllTrim(SubStr(cHist,1,nPosFin)),oFont08)
				nLi += 1
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol13 - nFin,AllTrim(SubStr(cHist,nPosFin,Len(cHist) - nPosFin + 1)),oFont08)				
			EndIf
		
		EndIf
		
		If CT2_DC == '3'
			nLi += 1
			oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol01 - nFin,cContaC,oFont10)          				
			oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol02 - nFin,cDContaC,oFont10) 
						
		   //	oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol05 - nFin,cClvl,oFont10)
		   	If !EMPTY(cEC05C)				
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol06 - nFin,cEC05C,oFont08)
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol07 - nFin,substr(cEC05DESCC,1,30),oFont08)				
			endif  
			If !EMPTY(cCCC)
		   		oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol08 - nFin,cCCC,oFont08)
		   		oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol09 - nFin,CCCDESC,oFont08)
			endif
			oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol10 - nFin,PADR(Transform(0,'@E 9,999,999,999.99'),18," "),oFont10)
			oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol11 - nFin,PADR(Transform(nValorC,'@E 9,999,999,999.99'),18," "),oFont10)
			
//			nLi += 1
			If !EMPTY(cItemCC)				
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol03 - nFin,cItemCC,oFont08) 
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol04 - nFin,cDItemC,oFont08) 
			EndIF
			
			If Len(cHist) <= nCorteH
  				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol13 - nFin,cHist,oFont08)
			Else
	  			nPosFin := RAT( " ", SubStr( cHist, 1, nCorteH) )
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol13 - nFin,AllTrim(SubStr(cHist,1,nPosFin)),oFont08)
				nLi += 1
				oPrint:say (nInicio + (nSepara * (nLi - 1)),nCol13 - nFin,AllTrim(SubStr(cHist,nPosFin,Len(cHist) - nPosFin + 1)),oFont08)				
			EndIf
		
		EndIf
		//Asignacion de Datos a las Variables
		dFecha		:= stod(alltrim(CT2_DATA))    //Fecha del Asiento
		cLote		:= CT2_LOTE    //Lote del Asiento
		cSubLote	:= CT2_SBLOTE    //SubLote del Asiento
		cDoc		:= CT2_DOC    //Documento del Asiento
		cTpAsiento	:= CT2_DC //Tipo de Asiento
		cCorre		:= CT2_SEGOFI    //Correlativo del Asiento
    	cGestion	:= substr(CT2_DATA,1,4)	 //Gestion del Asiento
    	cPeriodo	:= substr(CT2_DATA,5,2)	 //Periodo del Asiento
		dbSkip()	
		nLi += 1		
	End Do                                                                                                          
	oPrint:line(nInicio + ((nSepara + 3) * (nLi - 1.2)),0080 - nFin,nInicio + ((nSepara + 3) * (nLi - 1.2)),2300)
	oPrint:say (nInicio + (nSepara * (nLi)),nCol01 - nFin,"TOTAL DEBITO:",oFont10)          				
	oPrint:say (nInicio + (nSepara * (nLi)),nCol10 - nFin,PADR(Transform(nSumaD,'@E 9,999,999,999.99'),18," "),oFont10)
	nLi += 1
	oPrint:say (nInicio + (nSepara * (nLi)),nCol01 - nFin,"TOTAL CREDITO:",oFont10)          							
	oPrint:say (nInicio + (nSepara * (nLi)),nCol11 - nFin,PADR(Transform(nSumaC,'@E 9,999,999,999.99'),18," "),oFont10)
	
	nLi += 8
	oPrint:Say(nInicio + (nSepara * (nLi)), nCol03 +  50 , Replicate("_",20), oFont10)
 	oPrint:Say(nInicio + (nSepara * (nLi)) + 60, nCol03 + 100, "Emitido por", oFont10) 
 	
	oPrint:Say(nInicio + (nSepara * (nLi)), nCol08 +  50 , Replicate("_",20), oFont10)
 	oPrint:Say(nInicio + (nSepara * (nLi)) + 60, nCol08 + 100, "Revisado por", oFont10)
 	
	oPrint:Say(nInicio + (nSepara * (nLi)), nCol06 +  50 , Replicate("_",20), oFont10)
   	oPrint:Say(nInicio + (nSepara * (nLi)) + 60, nCol06 + 100, "Aprobado por", oFont10)
		
	#IFDEF TOP
	    dBCloseArea(cArea1)
    #ENDIF
    
Return Nil  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion	 ³ GCTBI10102  ³ Autor ³ Ariel Dominguez    ³ Data ³23/11/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripcion³ Imprimie el encabezado de las paginas                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     ³ CGPE30101  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GCTBI10102()
	oPrint:StartPage()
	nContPage++  
	cDescEmpr:= "MARKAS S.A."

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Montagem del encabezado Principal del Informe                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	//oPrint:say (50,80,cDescEmpr,oFont08)
	cFLogoMarkas := GetSrvProfString("Startpath","") + "LogoMarkas.jpg"
	
	oPrint:SayBitmap(50,100-nFin, cFLogoMarkas,200,200)
	//oPrint:Say(200,nCol02 - nFin, "MARKAS SRL." ,oFont10 )
	    
	oPrint:say (50,1850,"Pagina:"+' '+Str(nContPage,3),oFont08)

	oPrint:say (100,1850,"Fecha:",oFont08)  			//Fecha:
	oPrint:say (100,1950,DtoC(dDataBase),oFont08)  		//Fecha el Sistema	
	
	oPrint:say (100,750,"COMPROBANTE CONTABLE",oFont15)
	oPrint:say (150,900,cTpCompr,oFont15)    
	oPrint:say (200,850,"Expresado en Bolivianos",oFont08)

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Montagem das Linas e Colunas dos Titulos da Planilha         ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

	oPrint:Box(0500,0020,0580,2300)
	
	//Titulos
   	oPrint:say (0520,nCol01 - nFin,"CTA.",oFont10n)          
	oPrint:say (0520,nCol02 - nFin,"DESC. CTA",oFont10n)
	//oPrint:say (0570,nCol03 - nFin + 70,"ITEM",oFont09n) 	
	//oPrint:say (0570,nCol04 - nFin,"DESC.ITEM",oFont09n) 	
	//oPrint:say (0520,nCol08 - nFin,"C.COSTO",oFont09n) 	
	//oPrint:say (0520,nCol09 - nFin,"DESC.C.COSTO",oFont09n) 	
	//oPrint:say (0520,nCol06 - nFin,"ENT05",oFont09n) 		
	//oPrint:say (0520,nCol07 - nFin,"DESC.ENT05",oFont09n) 		
   //	oPrint:say (0520,nCol05 - nFin,"CLVL.",oFont10n) 	
	oPrint:say (0520,nCol10 - nFin,"VALOR DEBITO",oFont10n)
	oPrint:say (0520,nCol11 - nFin,"VALOR CREDITO",oFont10n)
	oPrint:say (0520,nCol08 - nFin,"HISTORIAL",oFont09n)
Return Nil  

