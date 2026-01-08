#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  ParDiGra  ºAutor: ³Carlos Egüez     Query: Carlos Egüez    ±±
±±                         Data: 28/02/2018      						   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ Parte Diario de Equipos Pesados y Otros  		          º±±
±±º          ³ MIT041                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±                     		Reporte Gráfico                                ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Casa Grande                                      		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ParDiGra()
	Local cString 	:= "SD1"
	Local cDesc1  	:= " "
	Local cDesc2    := " "
	Local cDesc3    := " "
	Local cQuery 	:= ""
	Private cPerg   := "ParDiGraGD"
	Private nNroLin := 60
	Private nNroCol := 120

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	³ Define Variaveis Private(Basicas)³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

	Private aReturn := {"A rayas", 1,"Administracion", 1, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
	Private titulo  := "Parte Diario de Equipos Pesados y Otros"
	Private tamanho := "P"

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	³Declaracion de Fuentes Utilizadas.³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

	Private oFont08, oFont08n, oFont09, oFont09n,oFont10n, oFont28n
	Private oPrint

	CriaSX1(cPerg)
	Pergunte(cPerg,.F.)
	GuarDate()	

	oFont28n  := TFont():New("Times New Roman",28,28,,.T.,,,,.T.,.F.)
	oFont08	  := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	oFont08n  := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.) //Negrito
	oFont09   := TFont():New("Courier New",09,09,,.F.,,,,.T.,.F.)
	oFont09n  := TFont():New("Courier New",09,09,,.T.,,,,.T.,.F.) //Negrito
	oFont10n  := TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.) //Negrito
	oFont11n  := TFont():New("Courier New",11,11,,.T.,,,,.T.,.F.) //Negrito
	oFontTitn := TFont():New("Courier New",17,17,,.T.,,,,.T.,.F.) //Negrito

	oPrint := TMSPrinter():New("Parte Diario")
	wnRel:= "ReporteGrafico"
	wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
	RptStatus({|lEnd| IMPREP(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)  //SE IMPRIME EL REPORTE
	oPrint:Preview()

Static Function IMPREP(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)

	cQuery := "SELECT D1_DOC, D1_SERIE, D1_UDESC, D1_UHRINIE, D1_UHRFINE, D1_UHORAEQ, D1_UNROPTD, D1_UDTPTD, D1_UOPERPT, D1_UCOMBUS, "
	cQuery += "D1_URENDPT, D1_CLVL, D1_UACTPTD, D1_ITEMCTA, D1_CC, AF8_DESCRI, AF9_DESCRI, AF9_HORAI, AF9_HORAF, AF9_HUTEIS, SD1.R_E_C_N_O_ D1RECNO "
	cQuery += "FROM "+ RetSqlName("AF8") + " AF8, "+ RetSqlName("AFN") + " AFN, "+ RetSqlName("SD1") + " SD1, "+ RetSqlName("AF9") + " AF9, "+ RetSqlName("SF1") + " SF1 "
	cQuery += "WHERE D1_DOC = AFN_DOC "
	cQuery += "AND D1_SERIE = AFN_SERIE "
	cQuery += "AND D1_FORNECE = AFN_FORNEC "
	cQuery += "AND D1_LOJA = AFN_LOJA "
	cQuery += "AND D1_ITEM = AFN_ITEM "
	cQuery += "AND AF8_REVISA = AFN_REVISA "
	cQuery += "AND AF8_PROJET = AF9_PROJET "
	cQuery += "AND AF8_FILIAL = AF9_FILIAL "
	cQuery += "AND AF9_PROJET = AFN_PROJET "
	cQuery += "AND AF9_TAREFA = AFN_TAREFA "
	cQuery += "AND AF9_REVISA = AFN_REVISA "
	cQuery += "AND F1_FILIAL = D1_FILIAL "
	cQuery += "AND F1_DOC = D1_DOC "
	cQuery += "AND F1_EMISSAO = D1_EMISSAO "
	cQuery += "AND SF1.F1_SERIE BETWEEN '"+trim(mv_par01)+ "' AND '"+trim(mv_par02)+ "'"
	cQuery += "AND SD1.D1_UDTPTD BETWEEN '"+DtoS(mv_par03)+ "' AND '"+DtoS(mv_par04)+ "'"
	cQuery += "AND SD1.D1_UOPERPT BETWEEN '"+trim(mv_par05)+ "' AND '"+trim(mv_par06)+ "'"
	cQuery += "AND SF1.F1_DOC BETWEEN '"+trim(mv_par07)+ "' AND '"+trim(mv_par08)+ "'"
	cQuery += "AND AF8.AF8_PROJET BETWEEN '"+trim(mv_par09)+ "' AND '"+trim(mv_par10)+ "'"
	cQuery += "AND AF8.D_E_L_E_T_ = ' ' "
	cQuery += "AND AFN.D_E_L_E_T_ = ' ' "
	cQuery += "AND SD1.D_E_L_E_T_ = ' ' "
	cQuery += "AND AF9.D_E_L_E_T_ = ' ' "
	
	Aviso("PARDIGRA",cQuery,{'ok'},,,,,.t.)

	TCQUERY cQuery NEW ALIAS "InfCom"
	fImpCab() /*Imprime la Cabecera*/
	controlador := InfCom->D1_DOC
	While InfCom->(!EOF())  /*Mientras sigan Existiendo Items*/
		FImpItems()   /*imprime items*/
		If(nNroLin > 2700 .OR. InfCom->D1_DOC !=  controlador) /*Si los Items superan el Tamaño de la Hoja o Nro de Documento Cambia*/
			fImpPie()  /*imprime el pie y Salta de Pagina*/
			fImpCab() /*Imprime Cabecera de Nuevo*/
			controlador = InfCom->D1_DOC
		Endif
		InfCom->(dbSkip()) /* avanza de registra*/
	Enddo
	FImpFirmas() /*Imprime Firmas*/
	fImpPie() /*Imprime Pie de Pagina*/
	InfCom->(DbCloseArea())
	//Return NIL

Return

Static Function GuarDate()

If(FUNNAME() == 'MATA102N')
   SX1->(DbSetOrder(1))
   
   If SX1->(DbSeek(cPerg+'01'))               
   	RecLock('SX1',.F.)                              
   	SX1->X1_CNT01 := SF1->F1_SERIE //SD1->D1_SERIE
   	SX1->(MsUnlock())
   End
   
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+'02'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 := SF1->F1_SERIE //SD1->D1_SERIE
    SX1->(MsUnlock())
   End
  
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+'03'))
    RecLock('SX1',.F.)                
    SX1->X1_CNT01 := '19901201' //DTOS(CTOD(DTOC(SD1->D1_UDTPTD)))
    SX1->(MsUnlock())
   End
   
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+'04'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 := '20180401' //DTOS(CTOD(DTOC(SD1->D1_UDTPTD)))
    SX1->(MsUnlock())
   End
   
   SX1->(DbSetOrder(1)) 
   If SX1->(DbSeek(cPerg+'05'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 := '      '//D1->D1_UOPERPT
    SX1->(MsUnlock())
   End
   
   SX1->(DbSetOrder(1)) 
     If SX1->(DbSeek(cPerg+'06'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 := 'ZZZZZZ'//SD1->D1_UOPERPT
    SX1->(MsUnlock())
   End
   
   SX1->(DbSetOrder(1)) 
   If SX1->(DbSeek(cPerg+'07'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 := SF1->F1_DOC //SD1->D1_REMITO
    SX1->(MsUnlock())
   End  
   
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+'08'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 := SF1->F1_DOC //SD1->D1_REMITO
    SX1->(MsUnlock())
   End
   
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+'09'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 := '         ' //AF8->AF8_PROJET
    SX1->(MsUnlock())
   End    
   
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+'10'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 := 'ZZZZZZZZZZ' //AF8->AF8_PROJET
    SX1->(MsUnlock())
   End        

EndIf	
Return 

Static Function fImpCab()
	Private aAtexto := {}
	oPrint:StartPage() /*Inicia nueva Pagina*/
	nNroCol := 0080
	cFLogo 	:= GetSrvProfString("Startpath","") + "LogoCasGran.bmp"
	nNroLin := 60
	oPrint:SayBitmap(nNroLin,nNroCol-10,cFLogo,480,350)
	nNroLin	+= 90
	oPrint:Say(nNroLin,0750,"PARTE DIARIA DE EQUIPOS PESADOS Y OTROS" ,oFontTitn)
	nNroLin	+= 220
	oPrint:Say(nNroLin,0080,"MAQUINA: " + alltrim(InfCom->D1_UDESC),oFont11n)
	oPrint:Say(nNroLin,1600,"NO INT: " + alltrim(InfCom->D1_UNROPTD),oFont11n)
	nNroLin	+= 80
	oPrint:Say(nNroLin,0080,"OPERADOR: " + alltrim(InfCom->D1_UOPERPT),oFont11n)
	oPrint:Say(nNroLin,1600,"FECHA DE IMPRESIÓN: " + ffechalatin(Dtos(date())),oFont11n)
	nNroLin	+= 80
	oPrint:Say(nNroLin,0080,"AYUDANTE OPERADOR: " ,oFont11n)
	oPrint:Say(nNroLin,1600,"NÚMERO DE REMITO: " + alltrim(InfCom->D1_DOC),oFont11n)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	//³Nueva Linea y Box³±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Say(nNroLin+30,1100,"HOROMETRO" ,oFont11n)

	nNroLin	+= 100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Line(nNroLin, 0550, nNroLin+100, 0550) //Linea Vertical
	oPrint:Line(nNroLin, 1020, nNroLin+100, 1020) //Linea Vertical
	oPrint:Line(nNroLin, 1500, nNroLin+100, 1500) //Linea Vertical
	oPrint:Line(nNroLin, 1950, nNroLin+100, 1950) //Linea Vertical
	oPrint:Say(nNroLin+30,0230,"ENTRADA",oFont10n)
	oPrint:Say(nNroLin+30,0720,"SALIDA",oFont10n)
	oPrint:Say(nNroLin+30,1160,"DE HORAS",oFont10n)
	oPrint:Say(nNroLin+30,1640,"A HORAS",oFont10n)
	oPrint:Say(nNroLin+30,2030,"TOTAL HORAS",oFont10n)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	//³Box en Blancos³±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Line(nNroLin, 0550, nNroLin+100, 0550) //Linea Vertical
	oPrint:Line(nNroLin, 1020, nNroLin+100, 1020) //Linea Vertical
	oPrint:Line(nNroLin, 1500, nNroLin+100, 1500) //Linea Vertical
	oPrint:Line(nNroLin, 1950, nNroLin+100, 1950) //Linea Vertical
	oPrint:Say(nNroLin+30,0000, STR(InfCom->D1_UHRINIE),oFont11n)
	oPrint:Say(nNroLin+30,0400, STR(InfCom->D1_UHRFINE),oFont11n)
	oPrint:Say(nNroLin+30,1790, STR(InfCom->D1_UHORAEQ),oFont11n)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	//³Nueva Linea y Box³±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Say(nNroLin+30,0900,"LUBRICANTES Y COMBUSTIBLES" ,oFont11n)
	nNroLin+=100
	oPrint:Say(nNroLin+30,0150,"DIESEL: " +              "                                   Lts.",oFont10n)
	oPrint:Say(nNroLin+30,1250,"ACEITE HIDRAULICO: " ,oFont10n)                                         
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro                                      
	oPrint:Line(nNroLin, 1200, nNroLin+100, 1200)                                                        
	nNroLin+=100                                                                                   
	oPrint:Say(nNroLin+30,0150,"ACEITE MOTOR: " +              "                             Lts.",oFont10n)
	oPrint:Say(nNroLin+30,1250,"ACEITE TRANSMISION: ",oFont10n)                                       
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro                                        
	oPrint:Line(nNroLin, 1200, nNroLin+100, 1200)                                                     
	nNroLin+=100                                                                                               
	oPrint:Say(nNroLin+30,0150,"GRASA: " +              "                            	       Kgs.",oFont10n)
	oPrint:Say(nNroLin+30,1250,"FILTRO ACEITE: " ,oFont10n)                                         
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro                                          
	oPrint:Line(nNroLin, 1200, nNroLin+100, 1200)                                                    
	nNroLin+=100                                                                                                
	oPrint:Say(nNroLin+30,0150,"LIQUIDOS DE FRENOS: " +              "                       Lts.",oFont10n)
	oPrint:Say(nNroLin+30,1250,"FILTRO COMBUSTIBLE: " ,oFont10n)                                                                  
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro                                	                             
	oPrint:Line(nNroLin, 1200, nNroLin+100, 1200)                                                                         
	nNroLin+=100                                                                                                    
	oPrint:Say(nNroLin+30,0150,"GASOLINA: " +              "                                 Lts.",oFont10n)
	oPrint:Say(nNroLin+30,1250,"AGUA DESTILADA: " ,oFont10n)
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Line(nNroLin, 1200, nNroLin+100, 1200)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	//³Nueva Linea y Box³±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Line(nNroLin, 1660, nNroLin+100, 1660) //Linea Vertical
	oPrint:Line(nNroLin, 1890, nNroLin+100, 1890) //Linea Vertical
	oPrint:Line(nNroLin, 2120, nNroLin+100, 2120) //Linea Vertical
	oPrint:Say(nNroLin+30,0600,"ACTIVIDADES REALIZADAS",oFont10n)
	oPrint:Say(nNroLin+30,1750,"DE",oFont10n)
	oPrint:Say(nNroLin+30,1990,"A",oFont10n)
	oPrint:Say(nNroLin+30,2190,"TOTAL",oFont10n)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	//³Cuadros en Blancos³±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Line(nNroLin, 1660, nNroLin+100, 1660) //Linea Vertical
	oPrint:Line(nNroLin, 1890, nNroLin+100, 1890) //Linea Vertical
	oPrint:Line(nNroLin, 2120, nNroLin+100, 2120) //Linea Vertical
	oPrint:Say(nNroLin+30,1730,alltrim(InfCom->AF9_HORAI),oFont10n)
	oPrint:Say(nNroLin+30,1960,alltrim(InfCom->AF9_HORAF),oFont10n)
	oPrint:Say(nNroLin+30,1900,STR(InfCom->AF9_HUTEIS),oFont10n)

	aAtexto = CabToAry(AF9_DESCRI,1000)

	For i := 1 to Len(aAtexto)
		oPrint:Say(nNroLin+30,0150,aAtexto[i] ,oFont10n)
	Next

	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Line(nNroLin, 1660, nNroLin+100, 1660) //Linea Vertical
	oPrint:Line(nNroLin, 1890, nNroLin+100, 1890) //Linea Vertical
	oPrint:Line(nNroLin, 2120, nNroLin+100, 2120) //Linea Vertical
	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Line(nNroLin, 1660, nNroLin+100, 1660) //Linea Vertical
	oPrint:Line(nNroLin, 1890, nNroLin+100, 1890) //Linea Vertical
	oPrint:Line(nNroLin, 2120, nNroLin+100, 2120) //Linea Vertical
	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Line(nNroLin, 1660, nNroLin+100, 1660) //Linea Vertical
	oPrint:Line(nNroLin, 1890, nNroLin+100, 1890) //Linea Vertical
	oPrint:Line(nNroLin, 2120, nNroLin+100, 2120) //Linea Vertical

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	//³Nueva Linea y Box³±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Say(nNroLin+30,0150,"TRABAJOS PARA: " + alltrim(InfCom->AF8_DESCRI),oFont10n)
	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
	oPrint:Say(nNroLin+30,0150,"SECTOR DE TRABAJO: " ,oFont10n)
	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
	//Funcion para mostrar Campo Memo±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±

	SD1->(DbGoTo(InfCom->(D1RECNO)))
	_nlindet := mlcount(SD1->D1_UACTPTD,200)
	If _nlindet >= 1
		For nIb := 1 To _nlindet
			If(nIb == 1)
				oPrint:Say(nNroLin+30,0150,"OBSERVACIONES: "+ memoline(SD1->D1_UACTPTD,200,nIb),oFont10n)
			Else
        		oPrint:Say(nNroLin+30,0150,memoline(SD1->D1_UACTPTD,200,nIb),oFont10n)
			Endif
			nNroLin := nNroLin + 100
			oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro
		Next nIb
	Else
			oPrint:Say(nNroLin+30,0150,"OBSERVACIONES: ",oFont10n)
	EndIf

	nNroLin+=100
	oPrint:Box (nNroLin, 0080, nNroLin+100, 2350) //Recuadro

	Return nil
Return

Static Function fImpPie()
	oPrint:EndPage()
	Return nil
Return

Static Function FImpFirmas()
	oPrint:Line( 3100, 0100, 3100, 0600) //Linea Horizontal
	oPrint:Line( 3100, 0980, 3100, 1480) //Linea Horizontal
	oPrint:Line( 3100, 1850, 3100, 2350) //Linea Horizontal
	oPrint:Say(3150,0270,"OPERADOR",oFont09n)
	oPrint:Say(3150,1130,"JEFE DE OBRA",oFont09n)
	oPrint:Say(3150,2000,"JEFE SECCION",oFont09n)
	//return nil
Return

Static Function FImpItems()
	nNroLinAnterior := nNroLin //Dibuja el contorno de los items
	Return nil
Return

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
	//Descripcion: Carga las Preguntas ±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±

Static Function CriaSX1(cPerg)
	xPutSx1(cPerg,"01","¿De Serie?"        ,"¿De Serie?"	   	,"¿De Serie?"		,"MV_CH1","C",3,0,0,"G","","","",""	,"MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"02","¿A Serie?"  	   ,"¿A Serie?"	   	    ,"¿A Serie?"		,"MV_CH2","C",3,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"03","¿De Fecha PTD?"    ,"¿De Fecha PTD?"    ,"¿De Fecha PTD?"   ,"MV_CH3","D",8,0,0,"G",""," ","","","MV_PAR03",""       ,""            ,""        ,""     ,,"")
	xPutSx1(cPerg,"04","¿A Fecha PTD?" 	   ,"¿A Fecha PTD?"     ,"¿A Fecha PTD?"	,"MV_CH4","D",8,0,0,"G",""," ","","","MV_PAR04",""       ,""            ,""        ,""     ,,"")
	xPutSx1(cPerg,"05","¿De Operador PTD?" ,"¿De Operador PTD?" ,"De Operador PTD?" ,"MV_CH5","C",6,0,0,"G","","SRA" ,"" ,"" ,"MV_PAR05",""       ,""            ,""        ,""     ,,"")
	xPutSx1(cPerg,"06","¿A Operador PTD?"  ,"¿A Operador PTD?"  ,"¿A Operador PTD?" ,"MV_CH6","C",6,0,0,"G","","SRA" ,"" ,"" ,"MV_PAR06",""       ,""            ,""        ,""     ,,"")
	xPutSx1(cPerg,"07","¿De Remito?"       ,"¿De Remito?"		,"¿De Remito?"	    ,"MV_CH7","C",13,0,0,"G","","","",""	,"MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"08","¿A Remito?" 	   ,"¿A Remito?"	 	,"¿A Remito?"		,"MV_CH8","C",13,0,0,"G","","","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"09","¿De Projecto?"     ,"¿De Projecto?"	    ,"¿De Projecto?"	,"MV_CH9","C",10,0,0,"G","","","",""	,"MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"10","¿A Projecto?" 	   ,"¿A Projecto?"	 	,"¿A Projecto?"	    ,"MV_CH10","C",10,0,0,"G","","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
Return

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme   := Iif( cPyme   == Nil, " ", cPyme)
	cF3     := Iif( cF3     == NIl, " ", cF3)
	cGrpSxg := Iif( cGrpSxg == Nil, " ", cGrpSxg)
	cCnt01  := Iif( cCnt01  == Nil, "" , cCnt01)
	cHelp   := Iif( cHelp   == Nil, "" , cHelp)

	dbSelectArea( "SX1" )
	dbSetOrder(1)

	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " ")

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt := If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt) + " ?",cPergunt)
		cPerSpa := If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) + " ?",cPerSpa)
		cPerEng := If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) + " ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
		Replace X1_VAR01   With cVar01
		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return

Static Function ffechalatin(sfechacorta)

	Local ffechalatin := ""
	Local sdia := SUBSTR(sfechacorta,7,2)
	Local smes := SUBSTR(sfechacorta,5,2)
	Local sano := SUBSTR(sfechacorta,0,4)
	ffechalatin := sdia + "/" + smes + "/" + sano
Return(ffechalatin)

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
	//Funcion para bajar de Linea en un Box±±
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±

Static Function CabToAry(cTexto,nTamLine)
	Local aTexto := {}
	Local aText2 := {}
	Local cToken := " "
	Local nX
	Local nTam := 0
	Local cAux := ""

	aTexto := STRTOKARR ( cTexto , cToken )
	cToken := cToken + cToken

	For nX := 1 To Len(aTexto)
		nTam := Len(cAux) + Len(aTexto[nX])
		If nTam <= nTamLine
			cAux += aTexto[nX] + IIF((nTam+2) <= nTamLine, cToken,"")
		Else
			AADD(aText2,cAux)
			cAux := aTexto[nX] + cToken
		Endif
	Next nX

	If !Empty(cAux)
		AADD(aText2,cAux)
	Endif
Return(aText2)

/*Static Function MemLin()
Local nZ := 1

//	alert(MLCount(cText,1000))
For nZ := 1 to MLCount(cText,1000)
MemoLine(cText, 1000, nZ)
Next nZ

//	cMemo := (SD1->D1_UACTPTD,1000)
//	For i := 1 to cMemo
//		oPrint:Say(nNroLin+30,0150,"OBSERVACIONES: "+ cMemo[i] ,oFont10n)
//	next

Return( Nil )*/
