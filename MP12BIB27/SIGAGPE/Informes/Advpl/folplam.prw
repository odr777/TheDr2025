#Include "Protheus.Ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"
#include "fileio.ch"
#INCLUDE "GPER680.CH"
#INCLUDE "GPER012COL.CH"

#DEFINE NDATOS         36

#DEFINE NNUM           1
#DEFINE NCI            2
#DEFINE NCIEXP         3
#DEFINE NAPELLIDOS     4
#DEFINE NNACIONAL      5
#DEFINE NNASCIMENTO    6
#DEFINE NSEXO          7
#DEFINE NOCUPACION     8
#DEFINE NINGRESSO      9
#DEFINE NDIASHPM       10
#DEFINE NHORASDP       11
#DEFINE NHABERB        12
#DEFINE NBONOANT       13
#DEFINE NHENUMERO      14
#DEFINE NHEMONTO       15
#DEFINE NREMBONO       16
#DEFINE NREMOTROS      17
#DEFINE NSDSRNUM       18
#DEFINE NSDSRSUE       19
#DEFINE NTOTGANADO     20
#DEFINE NDAFP          21
#DEFINE NDRCIVA        22
#DEFINE NDODESC        23
#DEFINE NTOTDCTOS      24
#DEFINE NLIQUIDOP      25
#DEFINE NFIRMA         26
#DEFINE NMATRICULA     27
#DEFINE NCCOSTO        28	//Codigo Centro de Costo
#DEFINE NCCDESC        29	//Descripcion Centro de Costo
#DEFINE NAGRUPADO      30	//Agrupado por: 1:=Sucursal, 2:=Centro Costo
#DEFINE NSUCURSAL      31
#DEFINE NSUCNOMBR      32
#DEFINE NEMPCOD        33
#DEFINE NEMPDESC       34
#DEFINE NANTICIPO      35
#DEFINE NRETIRO		   36

#DEFINE VIGENTES	" A*FT"
#DEFINE DESPEDIDOS	"**D**"
#DEFINE TODOS		" ADFT"

#DEFINE NCOLNRO 1
#DEFINE NCOLCI 2
#DEFINE NCOLEXP 3
#DEFINE NCOLNOMAP 4
#DEFINE NCOLNACIO 5
#DEFINE NCOLFENAC 6
#DEFINE NCOLSEXO 7
#DEFINE NCOLOCUP 8
#DEFINE NCOLFECHIN 9
#DEFINE NCOLFECREP 10
#DEFINE NCOLDIPAG 11
#DEFINE NCOLHOPAG 12
#DEFINE NCOLHABAS 13
#DEFINE NCOLBOAN 14
#DEFINE NCOLNUMR 15
#DEFINE NCOLMONPA 16
#DEFINE NCOLBOPROD 17
#DEFINE NCOLOBON 18
#DEFINE NCOLNDOM 19
#DEFINE NCOLSUDO 20
#DEFINE NCOLTOTGA 21
#DEFINE NCOLAFPS 22
#DEFINE NCOLIVA 23
#DEFINE NCOLANTIP 24
#DEFINE NCOLOTRDES 25
#DEFINE NCOLTOTDES 26
#DEFINE NCOLLIPAG 27
#DEFINE NCOLFIRMA 28
///acaba
///adicionales
#DEFINE NCOLSUCU 29
#DEFINE NCOLCCOS 30
#DEFINE NCOLMAT 31


static oCellHorAlign := FwXlsxCellAlignment():Horizontal()
static oCellVertAlign := FwXlsxCellAlignment():Vertical()

/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³folplam   ³ Autor ³Erick Etcheverry       ³ Data ³ 31.07.24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Reporte de planilla de empleados para bolivia               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function folplam()
	Local aArea	:= GetArea()
	Local aDetalle		:= {}
	Local i
	Private cPerg   := "FOLPLAM"   // elija el Nombre de la pregunta
	Private cWTabAlias	:= "cWTabAlias"
	Private __cCmpSRa		:= ""
	Private aCmpSRA			:= {}
	Private cCamposEmp		:= ""

	CriaSX1(cPerg)

	Pergunte(cPerg,.t.)

	//variables privadas
	Private oTmpTabTRBX
	Private cProcesso 	:= MV_PAR01
	Private cProcedim 	:= MV_PAR02
	Private cCompet		:= MV_PAR03
	Private cSemana		:= MV_PAR04 //Nro de pago
	Private cFilDe   	:= MV_PAR05
	Private cFilAte  	:= MV_PAR06
	Private cCcDe    	:= MV_PAR07
	Private cCcAte   	:= MV_PAR08
	Private cMatDe   	:= MV_PAR09
	Private cMatAte  	:= MV_PAR10
	Private nSituacao  	:= MV_PAR11
	Private cSituacao  	:= VIGENTES
	Private cCategoria 	:= MV_PAR12
	Private nPerEvent	:= MV_PAR13
	Private cNomEmpr	:= MV_PAR14
	Private cNumDocId	:= MV_PAR15
	Private nOrdem		:= MV_PAR16
	
	//Private nAgrupa		:= IIF(EMPTY(MV_PAR17), 1, MV_PAR17)//Agrupado por: 1:=Empresa, 2:=Sucursal, 3:=Centro Costo
	Private aRoteiros	:= {}
	Private cPeriodo	:= ""
	Private dDiaIniPer	:= Nil
	//

	IF !TodoOK(cPerg)
		return .f.
	Endif

	GeraTemp(cWTabAlias)//gera tabla temporal

	///traemos los datos para rellenar
	aDetalle:= R680ImpR4()


	///rellenamos con reclock
	for i:= 1 to len(aDetalle)

		RecLock(cWTabAlias, .T.)

		(cWTabAlias)-> NUM        := aDetalle[i,NNUM       ]
		(cWTabAlias)-> CI         := aDetalle[i,NCI        ]
		(cWTabAlias)-> CIEXP      := aDetalle[i,NCIEXP     ]
		(cWTabAlias)-> MATRICULA  := aDetalle[i,NMATRICULA ]
		(cWTabAlias)-> APELLIDOS  := aDetalle[i,NAPELLIDOS ]
		(cWTabAlias)-> NACIONAL   := aDetalle[i,NNACIONAL  ]
		(cWTabAlias)-> NASCIMENTO := DTOC(STOD(Trim(aDetalle[i, NNASCIMENTO])))
		(cWTabAlias)-> SEXO       := aDetalle[i,NSEXO      ]
		(cWTabAlias)-> OCUPACION  := aDetalle[i,NOCUPACION ]
		(cWTabAlias)-> INGRESSO   := DTOC(STOD(Trim(aDetalle[i, NINGRESSO])))
		(cWTabAlias)-> RETIRO	  := aDetalle[i, NRETIRO]
		(cWTabAlias)-> DIASHPM    := aDetalle[i,NDIASHPM   ]
		(cWTabAlias)-> HORASDP    := aDetalle[i,NHORASDP   ]
		(cWTabAlias)-> HABERB     := aDetalle[i,NHABERB    ]
		(cWTabAlias)-> BONOANT    := aDetalle[i,NBONOANT   ]
		(cWTabAlias)-> HENUMERO   := aDetalle[i,NHENUMERO  ]
		(cWTabAlias)-> HEMONTO    := aDetalle[i,NHEMONTO   ]///MONTO PAGADO H EXTRA
		(cWTabAlias)-> REMBONO    := aDetalle[i,NREMBONO   ]  //BO PRODUCC
		(cWTabAlias)-> REMOTROS   := aDetalle[i,NREMOTROS  ]
		(cWTabAlias)-> SDSRNUM    := aDetalle[i,NSDSRNUM   ]  //N DOMINGOS
		(cWTabAlias)-> SDSRSUE    := aDetalle[i,NSDSRSUE   ]
		(cWTabAlias)-> TOTGANADO  := aDetalle[i,NTOTGANADO ]
		(cWTabAlias)-> DAFP       := aDetalle[i,NDAFP      ]
		(cWTabAlias)-> DRCIVA     := aDetalle[i,NDRCIVA    ]
		(cWTabAlias)-> DANTICIPO  := aDetalle[i,NANTICIPO  ]
		(cWTabAlias)-> DODESC     := aDetalle[i,NDODESC    ] ///O DESC
		(cWTabAlias)-> TOTDCTOS   := aDetalle[i,NTOTDCTOS  ]
		(cWTabAlias)-> LIQUIDOP   := aDetalle[i,NLIQUIDOP  ]
		(cWTabAlias)-> FIRMA      := aDetalle[i,NFIRMA     ]

		(cWTabAlias)-> CCOSTO  	  := aDetalle[i,NCCOSTO    ]
		(cWTabAlias)-> CCDESC  	  := aDetalle[i,NCCDESC    ]
		(cWTabAlias)-> AGRUPADO   := aDetalle[i,NAGRUPADO  ]
		(cWTabAlias)-> SUCURSAL   := aDetalle[i,NSUCURSAL  ]
		(cWTabAlias)-> SUCNOMBR   := aDetalle[i,NSUCNOMBR  ]
		(cWTabAlias)-> EMPCOD	  := aDetalle[i,NEMPCOD    ]
		(cWTabAlias)-> EMPDESC	  := aDetalle[i,NEMPDESC   ]

		(cWTabAlias)->(MsUnlock())

	next i

	//una vez rellenado cargamos los datos a excel

	exptoexc()

	///CERRAMOS LA TABLA TEMPORAL
	If( valtype(oTmpTabTRBX) == "O")
		dbSelectArea(cWTabAlias)
		oTmpTabTRBX:Delete()
		freeObj(oTmpTabTRBX)
		oTmpTabTRBX := nil
	EndIf

	RestArea(aArea)
return

/*
Descricao Gera arquivos temporarios
*/

Static Function GeraTemp(cWTabAlias)
	Local aStru		:= {}
	Local aOrdem	:= {}

	aAdd(aStru, {"NUM"	, "N", 004, 0})
	aAdd(aStru, {"CI"	, "C", tamSX3("RA_RG")[1], 0})
	aAdd(aStru, {"CIEXP"		, "C", tamSX3("RA_UFCI")[1], 0})
	aAdd(aStru, {"APELLIDOS"	, "C", tamSX3("RA_NOMECMP")[1], 0})
	aAdd(aStru, {"NACIONAL"	, "C", tamSX3("X5_DESCRI")[1], 0})
	aAdd(aStru, {"NASCIMENTO"	, "C", (tamSX3("RA_NASC")[1] + 2), 0})
	aAdd(aStru, {"SEXO"	, "C", tamSX3("RA_SEXO")[1], 0})
	aAdd(aStru, {"OCUPACION"	, "C", tamSX3("RJ_DESC")[1], 0})
	aAdd(aStru, {"INGRESSO"	, "C", (tamSX3("RA_ADMISSA")[1] + 2), 0})
	aAdd(aStru, {"RETIRO"	, "C", (tamSX3("RA_ADMISSA")[1] + 2), 0})
	aAdd(aStru, {"DIASHPM"	, "N", tamSX3("RD_HORAS")[1], 2})
	aAdd(aStru, {"HORASDP"	, "N", tamSX3("RCF_HRSDIA")[1], 2})
	aAdd(aStru, {"HABERB"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"BONOANT"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"HENUMERO"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"HEMONTO"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"REMBONO"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"REMOTROS"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"SDSRNUM"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"SDSRSUE"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"TOTGANADO"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"DAFP"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"DRCIVA"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"DODESC"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"TOTDCTOS"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"LIQUIDOP"	, "N", tamSX3("RD_VALOR")[1], 2})
	aAdd(aStru, {"FIRMA"	, "C", 015, 0})
	aAdd(aStru, {"MATRICULA"	, "C", tamSX3("RA_MAT")[1], 0})
	aAdd(aStru, {"CCOSTO"	, "C", tamSX3("RA_CC")[1], 0})
	aAdd(aStru, {"CCDESC"	, "C", tamSX3("CTT_DESC01")[1], 0})
	aAdd(aStru, {"AGRUPADO"	, "N", 001, 0})
	aAdd(aStru, {"SUCURSAL"	, "C", tamSX3("RA_FILIAL")[1], 0})
	aAdd(aStru, {"SUCNOMBR"	, "C", 030, 0})
	aAdd(aStru, {"EMPCOD"	, "C", 004, 0})
	aAdd(aStru, {"EMPDESC"	, "C", 060, 0})
	aAdd(aStru, {"DANTICIPO"	, "N", tamSX3("RD_VALOR")[1], 2})


	aOrdem := {"MATRICULA"}   ///ordena por columa O INDICE QUE SERA EJ NUMSEQ

	oTmpTabTRBX := FWTemporaryTable():New(cWTabAlias)
	oTmpTabTRBX:SetFields(aStru)///DEFINE COLUMNAS A USAR
	oTmpTabTRBX:AddIndex("IN1", aOrdem) ///CUAL ES EL
	oTmpTabTRBX:Create() ///CREA TABLA

Return Nil

static function exptoexc()
	local cPath := "\system\"  // /spool/ para uma geração no server
	Local cNomArq  := "plahab" + dToS(date()) + "_" + StrTran(time(), ':', '-')
	local cArquivo := cPath + cNomArq + ".rel"
	local lRet := .F.
	local oFileW := FwFileWriter():New(cArquivo)
	local oPrtXlsx := FwPrinterXlsx():New()

	//datos para cabecera
	Local i
	Local cCompet	:= MV_PAR03
	Local cFilDe   	:= MV_PAR05
	Local cFilAte  	:= MV_PAR06
	Local nPerEvent	:= MV_PAR13
	Local cNomEmpr	:= MV_PAR14
	Local cNumDocId	:= MV_PAR15
	Local cFilLegal	:= FWCodFil()
	Local cTabU001	:= "U001"
	Local aInfoLegal:= {}
	Local cEmpresa	:= TRIM(OemToAnsi(STR0008)) + ": " + TRIM(FWCompanyName())//TRIM(SM0->M0_NOME)
	Local nCon
	Private aTabU001:= {}


	lRet := oPrtXlsx:Activate(cArquivo, oFileW)

	// Nova página
	lRet := oPrtXlsx:AddSheet("Planilla Haberes")

	//config
	cFont := FwPrinterFont():Calibri()
	nSize := 07
	lItalic := .F.
	lBold := .T.
	lUnderlined := .F.
	lRet := oPrtXlsx:SetFont(cFont, nSize, lItalic, lBold, lUnderlined)

	cHorAlignment := oCellHorAlign:Left()
	cVertAlignment := oCellVertAlign:Center()
	lWrapText := .T.  ///AUTOAJUSTABLE
	nRotation := 0
	cCustomFormat := ""
	// Seta texto vermelho com alinhamento horizontal e vertical centralizado e com rotação de texto vertical
	lRet := oPrtXlsx:SetCellsFormat(cHorAlignment, cVertAlignment, lWrapText, nRotation, "000000", "FFFFFF", cCustomFormat)

	/*CACEBERA*/
	//unir de 1 a 28 hasta la row 9

	dDataRef := cToD( "01/" + SubStr(cCompet,1,2) + "/" + SubStr(cCompet,3,4))
	fCarrTab ( @aTabU001, cTabU001, dDataRef, .T.)
	if(!Empty(cFilDe) .AND. ( TRIM(cFilDe) == TRIM(cFilAte) ) )
		cFilLegal:= cFilDe
	endIf

	//Se recorre el array para filtrar la sucursal del empleado
	for i:= 1 to Len(aTabU001)
		if(TRIM(aTabU001[i][2]) == TRIM(cFilLegal))
			aInfoLegal:= aTabU001[i]
			exit
		endIf
	next i

	cEmpresa := cEmpresa ///nombre o razon social
	cEmplead	:= aInfoLegal[8]  ///
	cEmpMTrab	:= OemToAnsi(STR0009) + ": " + allTrim(cEmplead)  //NºEMPLEADOR MINISTERIO DE TRABAJO
	cNroEmpCps	:= "N°EMPLEADOR CNS: " + aInfoLegal[5]
	cNit		:= "NÚMERO DE NIT: " + aInfoLegal[6]

	cDescMes := "CORRESPONDIENTE AL MES DE ABRIL" +" "+ UPPER(FDESC_MES(Val(SubStr(cCompet,1,2)))) +" "+ "DE" +" "+ SubStr(cCompet,3,4)

	cFechImp	:= DtoC(dDataBase)

	cNomEmpr := cNomEmpr  ///nombre del empleador o representante pie pagina
	cNumDocId := cNumDocId  ///nro documento identidad pie pagina

	nRowFrom := 1   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 1     //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	nRow := 1
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "NOMBRE O RAZON SOCIAL:"+ TRIM(FWCompanyName()))

	nRowFrom := 2   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 2     //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	nRow := 2
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "NºEMPLEADOR MINISTERIO DE TRABAJO:"+ allTrim(cEmplead))

	nRowFrom := 3   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 3     //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	nRow := 3
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "N°EMPLEADOR CNS:"+ aInfoLegal[5])

	nRowFrom := 4   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 4    //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	nRow := 4
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "NÚMERO DE NIT:"+ aInfoLegal[6])

	nRowFrom := 5   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 5     //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	nRow := 5
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)

	cHorAlignment := oCellHorAlign:Center()
	cVertAlignment := oCellVertAlign:Center()
	lWrapText := .T.  ///AUTOAJUSTABLE
	nRotation := 0
	cCustomFormat := ""
	// Seta texto vermelho com alinhamento horizontal e vertical centralizado e com rotação de texto vertical
	lRet := oPrtXlsx:SetCellsFormat(cHorAlignment, cVertAlignment, lWrapText, nRotation, "000000", "FFFFFF", cCustomFormat)


	lRet := oPrtXlsx:SetText(nRow, nCol, "PLANILLA DE SUELDOS Y SALARIOS")

	cxCabPer := ""
	IIF(nPerEvent == 1,cxCabPer := "PERSONAL PERMANENTE",cxCabPer :="PERSONAL EVENTUAL")

	nRowFrom := 6   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 6     //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	nRow := 6
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, cxCabPer)

	nRowFrom := 7   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 7     //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	nRow := 7
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "(En Bolivianos)")

	nRowFrom := 8   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 8    //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	nRow := 8
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)

	cHorAlignment := oCellHorAlign:Right()
	cVertAlignment := oCellVertAlign:Center()
	lWrapText := .T.  ///AUTOAJUSTABLE
	nRotation := 0
	cCustomFormat := ""
	// Seta texto vermelho com alinhamento horizontal e vertical centralizado e com rotação de texto vertical
	lRet := oPrtXlsx:SetCellsFormat(cHorAlignment, cVertAlignment, lWrapText, nRotation, "000000", "FFFFFF", cCustomFormat)

	lRet := oPrtXlsx:SetText(nRow, nCol, cDescMes)

	nRowFrom := 9   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 9    //hasta que fila
	nColTo := 28    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	/*
	IZQUIERDA
	NOMBRE O RAZON SOCIAL: Agrocentro S.A.
	NºEMPLEADOR MINISTERIO DE TRABAJO: 1028743028-01					
	N°EMPLEADOR CNS: 036230001
	NÚMERO DE NIT: 1028743028																				
	CENTRAR								
	PLANILLA DE SUELDOS Y SALARIOS									
	PERSONAL PERMANENTE
	(En Bolivianos)
	TIRAR A LA DERECHA
	CORRESPONDIENTE AL MES DE ABRIL     DE 2024
	*/

	////

	cHorAlignment := oCellHorAlign:Center()
	cVertAlignment := oCellVertAlign:Center()
	lWrapText := .T.  ///AUTOAJUSTABLE
	nRotation := 0
	cCustomFormat := ""
	// Seta texto vermelho com alinhamento horizontal e vertical centralizado e com rotação de texto vertical
	lRet := oPrtXlsx:SetCellsFormat(cHorAlignment, cVertAlignment, lWrapText, nRotation, "000000", "FFFFFF", cCustomFormat)


	/*CABECERA items*/

	lTop := .T.
	lBottom := .T.
	lLeft:= .T.
	lRight := .T.
	cStyle := FwXlsxBorderStyle():Thin()
	cColor := "000000"  ////RGB  008000 VERDE
	// Borda
	lRet := oPrtXlsx:SetBorder(lLeft, lTop, lRight, lBottom, cStyle, cColor)

	nRowFrom := 10   //desde que fila
	nColFrom := 1   //desde que columna
	nRowTo := 11     //hasta que fila
	nColTo := 1    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 1
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "N°")

	/////////
	nRowFrom := 10   //desde que fila
	nRowTo := 11     //hasta que fila
	nColFrom := 2   //desde que columna
	nColTo := 2    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 2

	lRet := oPrtXlsx:SetText(nRow, nCol, "CI")
	////

	/////////
	nRowFrom := 10   //desde que fila
	nRowTo := 11     //hasta que fila
	nColFrom := 3   //desde que columna
	nColTo := 3    //hasta que columna
	// Mezcla intervalo A10:A11
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 3

	lRet := oPrtXlsx:SetText(nRow, nCol, "EXP.")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 4
	nColTo := 4

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 4

	lRet := oPrtXlsx:SetText(nRow, nCol, "NOMBRE Y APELLIDOS")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 5
	nColTo := 5

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 5

	lRet := oPrtXlsx:SetText(nRow, nCol, "NACIONALIDAD")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 6
	nColTo := 6

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 6

	lRet := oPrtXlsx:SetText(nRow, nCol, "FECHA DE NACIMIENTO")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 7
	nColTo := 7

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 7

	lRet := oPrtXlsx:SetText(nRow, nCol, "SEXO")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 8
	nColTo := 8

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 8

	lRet := oPrtXlsx:SetText(nRow, nCol, "OCUPACION")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 9
	nColTo := 9

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 9

	lRet := oPrtXlsx:SetText(nRow, nCol, "FECHA DE INGRESO")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 10
	nColTo := 10

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 10

	lRet := oPrtXlsx:SetText(nRow, nCol, "FECHA DE RETIRO")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 11
	nColTo := 11

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 11

	lRet := oPrtXlsx:SetText(nRow, nCol, "DIAS HAB. PAGADOS MES")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 12
	nColTo := 12

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 12

	lRet := oPrtXlsx:SetText(nRow, nCol, "HORAS / DIAS PAGADAS")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 13
	nColTo := 13

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 13

	lRet := oPrtXlsx:SetText(nRow, nCol, "HABER BASICO (A)")
	////

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 14
	nColTo := 14

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 14

	lRet := oPrtXlsx:SetText(nRow, nCol, "BONO DE ANTIGUEDAD (B)")

	/////

	/*MERGE O MEZCLA DE CELDAS*/
	nRowFrom := 10   //desde que fila
	nRowTo := 10     //hasta que fila
	nColFrom := 15  //desde que columna
	nColTo := 16    //hasta que columna
	// Mezcla
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 15
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "HORAS EXTRAS")

	nRow := 11
	nCol := 15
	lRet := oPrtXlsx:SetText(nRow, nCol, "NUMERO")

	nRow := 11
	nCol := 16
	lRet := oPrtXlsx:SetText(nRow, nCol, "MONTO PAGADO (C)")

	/////

	/////

	/*MERGE O MEZCLA DE CELDAS*/
	nRowFrom := 10   //desde que fila
	nRowTo := 10     //hasta que fila
	nColFrom := 17  //desde que columna
	nColTo := 18    //hasta que columna
	// Mezcla
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 17
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "REMUNERACION")

	nRow := 11
	nCol := 17
	lRet := oPrtXlsx:SetText(nRow, nCol, "BONO DE PRODUCCION (D)")

	nRow := 11
	nCol := 18
	lRet := oPrtXlsx:SetText(nRow, nCol, "OTROS BONOS (E)")

	/////

	/////

	/*MERGE O MEZCLA DE CELDAS*/
	nRowFrom := 10   //desde que fila
	nRowTo := 10     //hasta que fila
	nColFrom := 19  //desde que columna
	nColTo := 20    //hasta que columna
	// Mezcla
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 19
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "SUELDO DSR")

	nRow := 11
	nCol := 19
	lRet := oPrtXlsx:SetText(nRow, nCol, "NUMERO DE DOMINGOS")

	nRow := 11
	nCol := 20
	lRet := oPrtXlsx:SetText(nRow, nCol, "SUELDO DOMINICAL (F)")

	/////

	/////

	nRow := 10
	nCol := 21
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "TOTAL")

	nRow := 11
	nCol := 21
	lRet := oPrtXlsx:SetText(nRow, nCol, "TOTAL GANADO (G) A+B+C+D+E+F")

	/////

	/*MERGE O MEZCLA DE CELDAS*/
	nRowFrom := 10   //desde que fila
	nRowTo := 10     //hasta que fila
	nColFrom := 22  //desde que columna
	nColTo := 25   //hasta que columna
	// Mezcla
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 22
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "DESCUENTOS")

	nRow := 11
	nCol := 22
	lRet := oPrtXlsx:SetText(nRow, nCol, "AFP 12.71% (H)")

	nRow := 11
	nCol := 23
	lRet := oPrtXlsx:SetText(nRow, nCol, "RC-IVA 13% (I)")

	nRow := 11
	nCol := 24
	lRet := oPrtXlsx:SetText(nRow, nCol, "ANTICIPOS")

	nRow := 11
	nCol := 25
	lRet := oPrtXlsx:SetText(nRow, nCol, "OTROS DCTOS. (J)")

	/////

	nRow := 10
	nCol := 26
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "TOTAL")

	nRow := 11
	nCol := 26
	lRet := oPrtXlsx:SetText(nRow, nCol, "DESCUENTOS (K) H+I+J")

	/////

	nRow := 10
	nCol := 27
	// Texto das células Mezcladas (apontando sempre para a primeira célula do intervalo)
	lRet := oPrtXlsx:SetText(nRow, nCol, "LIQUIDO")

	nRow := 11
	nCol := 27
	lRet := oPrtXlsx:SetText(nRow, nCol, "PAGABLE (L) G+K")

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 28
	nColTo := 28

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 28

	lRet := oPrtXlsx:SetText(nRow, nCol, "FIRMA")

	/////////
	/*
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 29
	nColTo := 29

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 29

	lRet := oPrtXlsx:SetText(nRow, nCol, "SUCURSAL")

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 30
	nColTo := 30

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 30

	lRet := oPrtXlsx:SetText(nRow, nCol, "C COSTO")

	/////////
	nRowFrom := 10
	nRowTo := 11
	nColFrom := 31
	nColTo := 31

	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)

	nRow := 10
	nCol := 31

	lRet := oPrtXlsx:SetText(nRow, nCol, "MATRICULA")
	*/
	
	If len(aCmpSRA) > 0
		//agrega Campos de SRA
		For nCon := 1 to len(aCmpSRA)
			cAux1 := REPLACE(AllTrim(aCmpSRA[nCon]), "'", "" )

			//CAMPO RA_FILIAL
			nCol = nCol+1
			nColFrom := nCol
			nColTo := nCol
			//fixo
			nRow := 10
			nRowFrom := 10
			nRowTo := 11
			///merge celdas
			lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
			lRet := oPrtXlsx:SetText(nRow, nCol, FWX3Titulo(cAux1))///titulo columna
		Next
	EndIf

	////termina columnas

	/*EMPIEZA ITEMS*/
	cFont := FwPrinterFont():Calibri()
	nSize := 07
	lItalic := .F.
	lBold := .F.
	lUnderlined := .F.
	lRet := oPrtXlsx:SetFont(cFont, nSize, lItalic, lBold, lUnderlined)

	nFilaIni := 12

	dbSelectArea(cWTabAlias)
	dbGoTop()

	While (cWTabAlias)->(!EoF())
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLNRO, (cWTabAlias)-> NUM)
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Left(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLCI, (cWTabAlias)-> CI)
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLEXP, (cWTabAlias)-> CIEXP)
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Left(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLNOMAP,(cWTabAlias)-> APELLIDOS )
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLNACIO,(cWTabAlias)-> NACIONAL  )
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLFENAC,(cWTabAlias)-> NASCIMENTO) //FECHA YA ESTA EN CARACTER CON DTOC
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLSEXO,(cWTabAlias)-> SEXO      )
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Left(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLOCUP,(cWTabAlias)-> OCUPACION )
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLFECHIN,(cWTabAlias)-> INGRESSO  ) ///FECHA YA ESTA EN CARACTER CON DTOC
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLFECREP,(cWTabAlias)-> RETIRO	)  //FECHA YA ESTA EN CARACTER CON DTOC
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLDIPAG,(cWTabAlias)-> DIASHPM   ) //NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLHOPAG,(cWTabAlias)-> HORASDP   ) //NRO
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Right(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLHABAS,(cWTabAlias)-> HABERB    ) //NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLBOAN,(cWTabAlias)-> BONOANT   ) //NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLNUMR,(cWTabAlias)-> HENUMERO  ) //NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLMONPA,(cWTabAlias)-> HEMONTO   ) //NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLBOPROD,(cWTabAlias)-> REMBONO   ) //NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLOBON,(cWTabAlias)-> REMOTROS  ) //NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLNDOM,(cWTabAlias)-> SDSRNUM   ) //NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLSUDO,(cWTabAlias)-> SDSRSUE   )//NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLTOTGA,(cWTabAlias)-> TOTGANADO )//NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLAFPS,(cWTabAlias)-> DAFP      )//NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLIVA,(cWTabAlias)-> DRCIVA    )//NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLANTIP,(cWTabAlias)-> DANTICIPO )//NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLOTRDES,(cWTabAlias)-> DODESC    )//NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLTOTDES,(cWTabAlias)-> TOTDCTOS  )//NRO
		lRet := oPrtXlsx:SetNumber(nFilaIni, NCOLLIPAG,(cWTabAlias)-> LIQUIDOP  )//NRO
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
		lRet := oPrtXlsx:SetText(nFilaIni, NCOLFIRMA,(cWTabAlias)-> FIRMA     )
		lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Left(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")

		nUltLinha = NCOLFIRMA

		If len(aCmpSRA)>0
			//agrega Campos de SRA
			For nCon := 1 to len(aCmpSRA)
				cAux1 := REPLACE( aCmpSRA[nCon], "'", "" )

				nUltLinha = nUltLinha+1

				lRet := oPrtXlsx:SetText(nFilaIni, nUltLinha, Posicione("SRA", 1, (cWTabAlias)-> SUCURSAL+(cWTabAlias)-> MATRICULA,cAux1))

			Next
		EndIf

		nFilaIni++

		(cWTabAlias)->(dbSkip())

	ENDDO

	///luego de terminar items hacer los totales de suma

	lRet := oPrtXlsx:SetFormula(nFilaIni, 13, "=SUM(N12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 14, "=SUM(O12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 15, "=SUM(P12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 16, "=SUM(Q12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 17, "=SUM(R12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 18, "=SUM(S12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 19, "=SUM(T12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 20, "=SUM(U12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 21, "=SUM(V12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 22, "=SUM(W12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 23, "=SUM(X12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 24, "=SUM(Y12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 25, "=SUM(Z12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 26, "=SUM(AA12:N"+cvaltochar(nFilaIni-1)+")")
	lRet := oPrtXlsx:SetFormula(nFilaIni, 27, "=SUM(AB12:N"+cvaltochar(nFilaIni-1)+")")

	////TERMINA PIE PAGINA
	lTop := .F.
	lBottom := .F.
	lLeft:= .F.
	lRight := .F.
	cStyle := FwXlsxBorderStyle():None()
	cColor := "000000"  ////RGB  008000 VERDE
	lRet := oPrtXlsx:SetBorder(lLeft, lTop, lRight, lBottom, cStyle, cColor)

	//config
	cFont := FwPrinterFont():Calibri()
	nSize := 07
	lItalic := .F.
	lBold := .T.
	lUnderlined := .F.
	lRet := oPrtXlsx:SetFont(cFont, nSize, lItalic, lBold, lUnderlined)


	nColFrom := 4
	nColTo := 6
	lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
	lRet := oPrtXlsx:MergeCells(nFilaIni+2, nColFrom, nFilaIni+2, nColTo)
	lRet := oPrtXlsx:SetText(nFilaIni+2, nColFrom,  cNomEmpr   )
	lRet := oPrtXlsx:SetBorder(.F., .T., .F., .F., FwXlsxBorderStyle():Thin(), "000000" )///TOP BORDE
	lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Top(), .T., 0, "000000", "FFFFFF", "")
	nRowFrom := nFilaIni+3
	nRowTo := nFilaIni+4
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	lRet := oPrtXlsx:SetText(nFilaIni+3, nColFrom, "NOMBRE DEL EMPLEADOR O REPRESENTANTE LEGAL"     )
	lRet := oPrtXlsx:SetBorder(.F., .F., .F., .F., FwXlsxBorderStyle():None(), "000000" )///SIN BORDE

	nColFrom := 9
	nColTo := 11
	lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Center(), .T., 0, "000000", "FFFFFF", "")
	lRet := oPrtXlsx:MergeCells(nFilaIni+2, nColFrom, nFilaIni+2, nColTo)
	lRet := oPrtXlsx:SetText(nFilaIni+2, nColFrom,  cNumDocId   )
	lRet := oPrtXlsx:SetBorder(.F., .T., .F., .F., FwXlsxBorderStyle():Thin(), "000000" )
	lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Top(), .T., 0, "000000", "FFFFFF", "")
	nRowFrom := nFilaIni+3
	nRowTo := nFilaIni+3
	lRet := oPrtXlsx:MergeCells(nRowFrom, nColFrom, nRowTo, nColTo)
	lRet := oPrtXlsx:SetText(nFilaIni+3, nColFrom, "Nº DE DOCUMENTO DE IDENTIDAD"     )

	lRet := oPrtXlsx:SetCellsFormat(oCellHorAlign:Center(), oCellVertAlign:Top(), .T., 0, "000000", "FFFFFF", "")
	lRet := oPrtXlsx:SetText(nFilaIni+3, 15, "FIRMA"     )

	////IMPRIMIR PIE DE PAGINA

	lRet := oPrtXlsx:toXlsx()

	cNomArq	:= cNomArq + '.xlsx'
	cDirUsr := GetTempPath()  //temporales
	cDirSrv := GetSrvProfString('startpath','')  ///direccion del archivo
	__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
	nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
	If nRet <= 32
		MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
	EndIf

return


Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	//xPutSX1(cPerg,"01","¿Proceso?"	, "¿Proceso?"	,"¿Proceso?"	,"MV_CH1","C",50,0,0,"G","fListProc(NIL,NIL,10)","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"01","¿Proceso?"	, "¿Proceso?"	,"¿Proceso?"	,"MV_CH1","C",05,0,0,"G","","RCJ","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	//xPutSX1(cPerg,"02","¿Procedimiento?", "¿Procedimiento?"	,"¿Procedimiento?"	,"MV_CH2","C",30,0,0,"G","fRoteiro()","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿Procedimiento?", "¿Procedimiento?"	,"¿Procedimiento?"	,"MV_CH2","C",03,0,0,"G","","SRY","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿Mes/Año Competenc. (MMYYYY)?" 		, "¿Mes/Año Competenc. (MMYYYY)?"		,"¿Mes/Año Competenc. (MMYYYY)?"		,"MV_CH3","C",06,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"04","¿N° Pago?" 		, "¿N° Pago?"		,"¿N° Pago?"		,"MV_CH4","C",02,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"05","¿De Sucursal?"	, "¿De Sucursal?"	,"¿De Sucursal?"	,"MV_CH5","C",04,0,0,"G","","SM0","033","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿A Sucursal?" 	, "¿A Sucursal?"	,"¿A Sucursal?"		,"MV_CH6","C",04,0,0,"G","","SM0","033","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿De Centro de costo?" , "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH7","C",11,0,0,"G","","CTT","004","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿A Centro de costo?" 	, "¿A Centro de costo?"	,"¿A Centro de costo?"	,"MV_CH8","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿De Matrícula?" , "¿De Matrícula?"	,"¿De Matrícula?"	,"MV_CH9","C",06,0,0,"G","","SRA","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿A Matrícula?" 	, "¿A Matrícula?"	,"¿A Matrícula?"	,"MV_CHA","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	/*xPutSX1(cPerg,"10","¿De Nombre?" , "¿De Nombre?"	,"¿De Nombre?"	,"MV_CH10","C",30,0,0,"G","","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿A Nombre?" 	, "¿A Nombre?"	,"¿A Nombre?"	,"MV_CH11","C",30,0,0,"G","NaoVazio()","","","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")*/
	
	//xPutSX1(cPerg,"10","¿Situaciones por imprimir?" , "¿Situaciones por imprimir?"	,"¿Situaciones por imprimir?"	,"MV_CH10","C",05,0,0,"G","fSituacao()","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿Situaciones por imprimir?"	, "¿Situaciones por imprimir?"	,"¿Situaciones por imprimir?"	,"MV_CHB","N",01,0,0,"C","","","","","MV_PAR11","Vigentes","Vigentes","Vigentes","","Despedidos","Despedidos","Despedidos"	,"Todos","Todos","Todos")
	
	xPutSX1(cPerg,"12","¿Categorías por imprimir?" 	, "¿Categorías por imprimir?"	,"¿Categorías por imprimir?"	,"MV_CHC","C",15,0,0,"G","fCategoria()","","","","MV_PAR12",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"13","¿Permanente/Eventual?" , "¿Permanente/Eventual?"	,"¿Permanente/Eventual?"	,"MV_CHD","C",01,0,0,"C","","","","","MV_PAR13","Permanente","Permanente","Permanente","","Eventual","Eventual","Eventual")
	xPutSX1(cPerg,"14","¿Nombre del Empleador?" 	, "¿Nombre del Empleador?"	,"¿Nombre del Empleador?"	,"MV_CHE","C",30,0,0,"G","","","","","MV_PAR14",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"15","¿Nº Doc. de Identidad?" , "¿Nº Doc. de Identidad?"	,"¿Nº Doc. de Identidad?"	,"MV_CHF","C",16,0,0,"G","","","","","MV_PAR15",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"16","¿Orden?"		, "¿Orden?"			,"¿Orden?"			,"MV_CHG","N",01,0,0,"C","","","","","MV_PAR16","Sucursal+Matric.","Sucursal+Matric.","Sucursal+Matric.","","Sucursal+C.Costo","Sucursal+C.Costo","Sucursal+C.Costo"	,"Apellido Paterno","Apellido Paterno","Apellido Paterno")
	xPutSX1(cPerg,"17","Campos do Funcionário ?", "¿Campos del Empleado ?"	,"Employee fields ?","MV_CHE","C",99,0,0,"G","u_Gpr017Cmp(mv_par17)","CPSR2","","","MV_PAR17","","","","","","",""	,"","","")
	
return

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

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
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
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ R680ImpR4  ³ Autor ³ Marcelo Silveira      ³ Data ³05/11/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de Saldos e Salarios                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPER680                                                      ³±±
±±³Modificado³ ³ Denar Terrazas      					  ³ Data ³15/03/2019³±±
±±³Descri‡ao ³ Modificado para imprimir en birt                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R680ImpR4()
	Local nX		:= 0
	Local nReg		:= 0
	Local nTamProc	:= 0
	Local nVHDiaPg 	:= 0
	Local nDiaPgMes	:= 0
	Local cMatAnt	:= ""
	Local cSitQuery	:= ""
	Local cCatQuery	:= ""
	Local cAuxPrc	:= ""
	Local cProcs	:= ""
	Local cFilPd	:= ""
	Local cFilPer	:= ""
	Local cPersona	:= ""
	Local cEmpMTrab	:= ""
	Local cCondicao := ""

	Local cFirma	:= "..............."
	Local nCon
	Local i			:= 0
	Local iX		:= 0
	Local nQtdFun	:= 0
	Local nTotPage	:= 0
	Local nPageAtu	:= 1
	Local aVerba 	:= Array(15,2)
	Local aCols		:= ARRAY(NDATOS)
	Local aRet		:= {}
	Local lAddCol := .F.
	Local cRoteiro := ""

	Local nPerEvent

	//nOrdem		:= 1//oReport:GetOrder()

	cPersona 	:= If( nPerEvent == 1, STR0010, STR0075) 	//1-PERMANENTE / 2-EVENTUAL
	cEmpMTrab	:= OemToAnsi(STR0009) +": "+ allTrim(FWCompanyName())

	If !Empty(cCompet)
		cPeriodo := SubStr(cCompet,3,4) + SubStr(cCompet,1,2)
	EndIf

	if(!Empty(cPeriodo))
		dDiaIniPer:= dIniPer()
	EndIf

	cSitQuery	:= ""
	if(nSituacao == 1)//Empleados vigentes
		cSituacao:= VIGENTES
	elseIf(nSituacao == 2)//Empleado despedidos
		cSituacao:= DESPEDIDOS
	else//Todos los empleados
		cSituacao:= TODOS
	endIf
	//If !Empty(cSituacao)
	For nReg:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cSituacao)
			cSitQuery += ","
		Endif
	Next nReg
	cSitQuery := "%" + cSitQuery + "%"
	//EndIf

	cCatQuery	:= ""
	//If !Empty(cSituacao)
	For nReg:=1 to Len(cCategoria)
		cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cCategoria)
			cCatQuery += ","
		Endif
	Next nReg
	cCatQuery := "%" + cCatQuery + "%"
	//EndIf

	//Trata os roteiros para a query
	SelecRoteiros()
	For nX := 1 to Len(aRoteiros)
		cRoteiro += "'" + aRoteiros[nX, 1] + "'"
		If( nX+1 ) <=  Len(aRoteiros)
			cRoteiro += ","
		EndIf
	Next
	//TODO revisar funcion SelecRoteiros()
	cRoteiro:= "'" + cProcedim + "'"//"'FOL', 'FIN'"
	cRoteiro := "%" + cRoteiro + "%"

	//Trata os processos para a query
	/*nTamProc := GetSx3Cache( "RCJ_CODIGO", "X3_TAMANHO" )
	For nX := 1 to Len(Alltrim(cProcesso)) Step 5
	If Len(Subs(cProcesso,nX,5)) < nTamProc
	cAuxPrc := Subs(cProcesso,nX,5) + Space(nTamProc - Len(Subs(cProcesso,nX,5)))
	Else
	cAuxPrc := Subs(cProcesso,nX,5)
	EndIf
	cProcs += "'" + cAuxPrc + "',"
	Next nX
	cProcs := "%" + Substr( cProcs, 1, Len(cProcs)-1) + "%"*/

	cAliasFun := GetNextAlias()
	cAliasQry := GetNextAlias()

	lExeQry	  := .T.

	If(nOrdem == 1)
		cOrdFun   := "% RA_FILIAL, RA_MAT %"
		cOrdLan	  := "% RA_FILIAL, RA_MAT, PD, SEQ %"
		cCondicao := "(cAliasQry)->FILIAL == (cAliasFun)->RA_FILIAL .And. (cAliasQry)->RA_MAT == (cAliasFun)->RA_MAT"
	ElseIf(nOrdem == 2)
		cOrdFun   := "% RA_FILIAL, RA_CC, RA_MAT %"
		cOrdLan   := "% RA_FILIAL, RA_CC, RA_MAT, PD, SEQ %"
		cCondicao := "(cAliasQry)->FILIAL == (cAliasFun)->RA_FILIAL .And. (cAliasQry)->RA_CC == (cAliasFun)->RA_CC .And. (cAliasQry)->RA_MAT == (cAliasFun)->RA_MAT"
	else
		cOrdFun   := "% RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME %"
		cOrdLan	  := "% RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME %"
		cCondicao := "(cAliasQry)->FILIAL == (cAliasFun)->RA_FILIAL .And. (cAliasQry)->RA_MAT == (cAliasFun)->RA_MAT"
	EndIf

	cFilPd	:= If( Alltrim(FWModeAccess("SRV",3)) == "C", "%'" + xFilial("SRV") + "'%", "%SRA.RA_FILIAL%" )
	cFilPer	:= If( Alltrim(FWModeAccess("RCF",3)) == "C", "%'" + xFilial("RCF") + "'%", "%SRA.RA_FILIAL%" )

	BeginSql alias cAliasFun

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,			SRA.RA_NOME,	SRA.RA_NOMECMP,	SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,		SRA.RA_SALARIO,		SRA.RA_SITFOLH,	SRA.RA_DEMISSA,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,		SRA.RA_RG,  		SRA.RA_UFCI,			SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,		SRA.RA_ADMISSA,		SRA.RA_CODFUNC,
		SRA.RA_TNOTRAB,			SRA.RA_PROCES,		SRA.RA_HRSMES,		SRA.RA_CARGO,
		SRC.RC_FILIAL FILIAL,	SRC.RC_CC CCUSTO, 	SRC.RC_HORAS HORAS,
		RCF.RCF_HRSDIA,			RCF.RCF_DIATRA
		FROM %table:SRA% SRA
		INNER JOIN  %table:SRC% SRC
		ON 	    SRA.RA_FILIAL = SRC.RC_FILIAL	AND
		SRA.RA_MAT    = SRC.RC_MAT
		INNER JOIN %table:RCF% RCF
		ON		RCF.RCF_FILIAL	=	%exp:cFilPer%	AND
		RCF.RCF_PROCES	=	SRA.RA_PROCES	AND
		RCF.RCF_PER 	=	%exp:Upper(cPeriodo)%
		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRC.RC_PROCES  IN (%exp:Upper(cProcesso)%)  	AND
		SRC.RC_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRC.RC_SEMANA =   %exp:Upper(cSemana)%   AND
		SRC.RC_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:Upper(cPeriodo)% AND
		(SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:Upper(cPeriodo)%) AND
		SRA.%notDel% AND SRC.%notDel% AND RCF.%notDel%

		UNION

		(SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,			SRA.RA_NOME,	SRA.RA_NOMECMP,	SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,		SRA.RA_SALARIO,		SRA.RA_SITFOLH,	SRA.RA_DEMISSA,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,		SRA.RA_RG,  		SRA.RA_UFCI,			SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,		SRA.RA_ADMISSA,		SRA.RA_CODFUNC,
		SRA.RA_TNOTRAB,			SRA.RA_PROCES,		SRA.RA_HRSMES,		SRA.RA_CARGO,
		SRD.RD_FILIAL FILIAL,	SRD.RD_CC CCUSTO,	SRD.RD_HORAS HORAS,
		RCF.RCF_HRSDIA,			RCF.RCF_DIATRA
		FROM %table:SRA% SRA
		INNER JOIN  %table:SRD% SRD
		ON 	    SRA.RA_FILIAL = SRD.RD_FILIAL	AND
		SRA.RA_MAT    = SRD.RD_MAT
		INNER JOIN %table:RCF% RCF
		ON		RCF.RCF_FILIAL	=	%exp:cFilPer%	AND
		RCF.RCF_PROCES	=	SRA.RA_PROCES	AND
		RCF.RCF_PER 	=	%exp:Upper(cPeriodo)%
		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRD.RD_PROCES  IN (%exp:Upper(cProcesso)%)  	AND
		SRD.RD_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRD.RD_SEMANA =   %exp:Upper(cSemana)%   AND
		SRD.RD_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:Upper(cPeriodo)% AND
		(SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:Upper(cPeriodo)%) AND
		SRA.%notDel% AND SRD.%notDel% AND RCF.%notDel%)
		ORDER BY %exp:cOrdFun%

	EndSql
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.t.)//   usar este en esste caso cuando es BEGIN SQL

	BeginSql alias cAliasQry

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,				SRA.RA_CC,				SRA.RA_NOME,	SRA.RA_NOMECMP,	SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,			SRA.RA_SALARIO,			SRA.RA_SITFOLH,	SRA.RA_DEMISSA,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,			SRA.RA_RG,				SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,			SRA.RA_ADMISSA,			SRA.RA_CODFUNC,
		SRA.RA_CARGO,
		SRC.RC_FILIAL FILIAL,	SRC.RC_MAT MAT,			SRC.RC_CC CCUSTO,		SRC.RC_PD PD,
		SRC.RC_TIPO1 TIPO1,		SRC.RC_QTDSEM QTDSEM,	SRC.RC_HORINFO HORINFO,	SRC.RC_HORAS HORAS,
		SRC.RC_VALINFO VALINFO,	SRC.RC_VALOR VALOR,		SRC.RC_VNAOAPL VNAOAPL,	SRC.RC_DATA DATPGT,
		SRC.RC_DTREF DTREF,		SRC.RC_SEMANA SEMANA,	SRC.RC_SEQ SEQ,			SRC.RC_PROCES PROCES,
		SRC.RC_PERIODO PERIODO,	SRC.RC_NUMID NUMID,		SRC.RC_ROTEIR ROTEIR,
		SRV.RV_COD,				SRV.RV_INFSAL INFSAL,	SRV.RV_CODFOL CODFOL
		FROM %table:SRA% SRA
		INNER JOIN	%table:SRC% SRC
		ON 	    SRA.RA_FILIAL = SRC.RC_FILIAL	AND
		SRA.RA_MAT    = SRC.RC_MAT
		INNER JOIN 	%table:SRV% SRV
		ON		SRV.RV_FILIAL = %exp:cFilPd%	AND
		SRV.RV_COD    = SRC.RC_PD
		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRC.RC_PROCES  IN (%exp:Upper(cProcesso)%)  	AND
		SRC.RC_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRC.RC_SEMANA =   %exp:Upper(cSemana)%   AND
		SRC.RC_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRV.RV_INFSAL <> (%exp:""%) AND
		SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:Upper(cPeriodo)% AND
		(SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:Upper(cPeriodo)%) AND
		SRA.%notDel% AND SRC.%notDel% AND SRV.%notDel%

		UNION

		(SELECT SRA.RA_FILIAL,			SRA.RA_MAT,				SRA.RA_CC,				SRA.RA_NOME, SRA.RA_NOMECMP,	SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,			SRA.RA_SALARIO,			SRA.RA_SITFOLH,	SRA.RA_DEMISSA,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,			SRA.RA_RG,				SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,			SRA.RA_ADMISSA,			SRA.RA_CODFUNC,
		SRA.RA_CARGO,
		SRD.RD_FILIAL FILIAL,	SRD.RD_MAT MAT,			SRD.RD_CC CCUSTO,		SRD.RD_PD PD,
		SRD.RD_TIPO1 TIPO1,		SRD.RD_QTDSEM QTDSEM,	SRD.RD_HORINFO HORINFO,	SRD.RD_HORAS HORAS,
		SRD.RD_VALINFO VALINFO,	SRD.RD_VALOR VALOR,		SRD.RD_VNAOAPL VNAOAPL,	SRD.RD_DATPGT DATPGT,
		SRD.RD_DTREF DTREF,		SRD.RD_SEMANA SEMANA,	SRD.RD_SEQ SEQ,			SRD.RD_PROCES PROCES,
		SRD.RD_PERIODO PERIODO,	SRD.RD_NUMID NUMID,		SRD.RD_ROTEIR ROTEIR,
		SRV.RV_COD,				SRV.RV_INFSAL INFSAL,	SRV.RV_CODFOL CODFOL
		FROM %table:SRA% SRA
		INNER JOIN %table:SRD% SRD
		ON 	    SRA.RA_FILIAL = SRD.RD_FILIAL	AND
		SRA.RA_MAT    = SRD.RD_MAT
		INNER JOIN %table:SRV% SRV
		ON		SRV.RV_FILIAL 	= %exp:cFilPd%	AND
		SRV.RV_COD    	= SRD.RD_PD
		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_SITFOLH	IN	(%exp:Upper(cSitQuery)%)	AND
		SRA.RA_CATFUNC	IN	(%exp:Upper(cCatQuery)%)	AND
		SRD.RD_PROCES	IN	(%exp:Upper(cProcesso)%)		AND
		SRD.RD_PERIODO	=	%exp:Upper(cPeriodo)%		AND
		SRD.RD_SEMANA =   %exp:Upper(cSemana)%   AND
		SRD.RD_ROTEIR	IN	(%exp:Upper(cRoteiro)%)		AND
		SRV.RV_INFSAL	<>	(%exp:""%) AND
		SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:Upper(cPeriodo)% AND
		(SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:Upper(cPeriodo)%) AND
		SRA.%notDel% AND SRD.%notDel% AND SRV.%notDel%)
		ORDER BY %exp:cOrdLan%

	EndSql
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.t.)//   usar este en esste caso cuando es BEGIN SQL
	(cAliasFun)->( dbGoTop())

	Do While (cAliasFun)->(!Eof())

		nDiaPgMes := 0
		nVHDiaPg  := 0

		For i := 1 To 15
			For iX := 1 to 2
				aVerba[i,iX] := 0
			Next iX
		Next i

		//(cAliasQry)->(dbGoTop())
		Do While (cAliasQry)->(!Eof()) .And. &cCondicao

			if(&cCondicao)
				If (cAliasQry)->CODFOL $ "0031|0048"
					nVHDiaPg := (cAliasFun)->RCF_HRSDIA
					nDiaPgMes:= (cAliasQry)->HORAS
				EndIf

				If (cAliasQry)->RA_SALARIO > 0
					lAddCol := .T.
				EndIf

				Do Case
					Case (cAliasQry)->INFSAL == "A"
					aVerba[1,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "B"
					aVerba[2,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "C"
					aVerba[3,1] += (cAliasQry)->VALOR
					aVerba[3,2] += (cAliasQry)->HORAS
					Case (cAliasQry)->INFSAL == "D"
					aVerba[4,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "F"
					aVerba[5,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "E"
					aVerba[6,1] += (cAliasQry)->VALOR
					aVerba[6,2] += (cAliasQry)->HORAS
					Case (cAliasQry)->INFSAL == "H"
					aVerba[7,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "I"
					aVerba[8,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "J"
					aVerba[9,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "K" 			//Nao mais usado (retirado em 2013/11)
					aVerba[13,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "L"
					aVerba[14,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "N"     		//Nao mais usado (retirado em 2013/11)
					aVerba[14,1] += (cAliasQry)->VALOR
					Case (cAliasQry)->INFSAL == "Z"	//Z utilizado para anticipos
					aVerba[15,1] += (cAliasQry)->VALOR
				EndCase
			endif

			(cAliasQry)->(DbSkip())
		EndDo

		If lAddCol	//If aVerba[1,1] > 0

			aVerba[10,1] := aVerba[1,1] + aVerba[2,1] + aVerba[3,1] + aVerba[4,1] + aVerba[5,1] + aVerba[6,1]	//TOTAL GANADO (G)
			aVerba[11,1] := aVerba[7,1] + aVerba[8,1] + aVerba[9,1] + aVerba[15,1] 				 				//TOTAL DESCONTOS (L)
			aVerba[12,1] := aVerba[10,1] - aVerba[11,1] 														//LIQUIDO PAGABLE (N)

			aCols := ARRAY(NDATOS)
			cOcupa:= fDesc("SRJ",(cAliasFun)->RA_CODFUNC,"RJ_DESC")
			//cOcupa:= Left(cOcupa, 1) + LOWER(Right(cOcupa, len(cOcupa)-1))

			aCols[NNUM       ]:= ( nQtdFun += 1 )
			aCols[NCI        ]:= ( AllTrim((cAliasFun)->RA_RG) )
			aCols[NCIEXP	 ]:= ( AllTrim((cAliasFun)->RA_UFCI) )
			aCols[NAPELLIDOS ]:= ( (cAliasFun)->RA_NOMECMP )
			aCols[NNACIONAL  ]:= ( fDesc("SX5","34"+(cAliasFun)->RA_NACIONA,"X5_DESCRI") )
			aCols[NNASCIMENTO]:= ( (cAliasFun)->RA_NASC )
			aCols[NSEXO      ]:= ( (cAliasFun)->RA_SEXO )
			aCols[NOCUPACION ]:= ( cOcupa )
			aCols[NINGRESSO  ]:= ( (cAliasFun)->RA_ADMISSA )
			aCols[NRETIRO    ]:= ""
			If( !Empty((cAliasFun)->RA_DEMISSA) .AND. TRIM(AnoMes(STOD(TRIM((cAliasFun)->RA_DEMISSA)))) == TRIM(cPeriodo))
				aCols[NRETIRO]:= ( DTOC(STOD(Trim( (cAliasFun)->RA_DEMISSA ))) )
			EndIf
			aCols[NDIASHPM   ]:= ( nDiaPgMes)
			aCols[NHORASDP   ]:= ( nVHDiaPg)
			aCols[NHABERB    ]:= ( aVerba[1,1])
			aCols[NBONOANT   ]:= ( aVerba[2,1])
			aCols[NHENUMERO  ]:= ( aVerba[3,2])
			aCols[NHEMONTO   ]:= ( aVerba[3,1])
			aCols[NREMBONO   ]:= ( aVerba[4,1])
			aCols[NREMOTROS  ]:= ( aVerba[5,1])
			aCols[NSDSRNUM   ]:= ( aVerba[6,2])
			aCols[NSDSRSUE   ]:= ( aVerba[6,1])
			aCols[NTOTGANADO ]:= ( aVerba[10,1])
			aCols[NDAFP      ]:= ( aVerba[7,1])
			aCols[NDRCIVA    ]:= ( aVerba[8,1])
			aCols[NANTICIPO	 ]:= ( aVerba[15,1])	//Anticipos
			aCols[NDODESC    ]:= ( aVerba[9,1])
			aCols[NTOTDCTOS  ]:= ( aVerba[11,1])
			aCols[NLIQUIDOP  ]:= ( aVerba[12,1])
			aCols[NFIRMA     ]:= ( cFirma )
			aCols[NMATRICULA ]:= ( (cAliasFun)->RA_MAT )
			aCols[NCCOSTO	 ]:= ( (cAliasFun)->RA_CC )
			aCols[NCCDESC	 ]:= ( TRIM(fDesc("CTT", (cAliasFun)->RA_CC, "CTT->CTT_DESC01", 30)) )
			aCols[NAGRUPADO	 ]:= 0
			aCols[NSUCURSAL  ]:= ( (cAliasFun)->RA_FILIAL )
			aCols[NSUCNOMBR  ]:= ( FWFilName(FWCodEmp(), (cAliasFun)->RA_FILIAL) )
			aCols[NEMPCOD    ]:= ( SUBSTR((cAliasFun)->RA_FILIAL,1,2))
			aCols[NEMPDESC   ]:= ( TRIM(FWCompanyName())/*FWEmpName(SUBSTR((cAliasFun)->RA_FILIAL,1,2))*/)


			AADD(aRet, aCols)
			lAddCol:= .F.
		EndIf

		cMatAnt:= (cAliasFun)->RA_MAT
		(cAliasFun)->(DbSkip())

	EndDo

Return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 26/12/2019
* @description: Funcion que devuelve la fecha del dia de inicio del periodo para el calculo de los dias
trabajados para los empleados despedidos
*/
static function dIniPer()
	Local aArea	:= getArea()
	Local dRet	:= Nil
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RFQ_DTINI
		FROM %table:RFQ% RFQ
		WHERE RFQ_MODULO = 'GPE'
		AND RFQ_PERIOD = %exp:cPeriodo%
		AND RFQ.%notdel%

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		dRet:= STOD((OrdenConsul)->RFQ_DTINI)
	endIf
	restArea(aArea)
return dRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Gpr017Cmp  ³ Autor ³ Alfredo Medrano       ³ Data ³27/07/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida que los campos existan en SRA                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Gpr017Cmp(ExpC1)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Campo                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lRet                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³TodoOK() Y X1_VALID de MV_PAR14 Preg. GPER012COL              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function Gpr017Cmp(cLtaCam)
	Local aArea 	:= getArea()
	Local nCon 		:= 0
	Local lRet 		:= .T.
	Local cCpoSRA	:= ""
	Local cCmpRet 	:= ""
	Local cCmpNE 	:= ""
	Local cCampo    := ""

	cLtaCam := StrTran(cLtaCam,'"','')
	cLtaCam := StrTran(cLtaCam,"'","")
	cLtaCam := "'" + AllTrim(cLtaCam) + "'"

	aCmpSRA:={}

	If !Empty(cLtaCam)
		dbselectarea("SRA")
		aCmpSRA := STRTOKARR(ALLTRIM(cLtaCam), ';')

		For nCon := 1 to len(aCmpSRA)
			If !Empty(aCmpSRA[nCon])
				cCpoSRA += aCmpSRA[nCon] + ","
				cCampo := StrTran(aCmpSRA[nCon],"'","")
				cCampo := StrTran(cCampo,";","")
				If GetSx3Cache(AllTrim(cCampo),"X3_ARQUIVO") == "SRA"
					cCmpRet += AllTrim(cCampo) + ", "
				ElseIf !Empty(AllTrim(cCampo))
					cCmpNE += AllTrim(cCampo) + ", "
				EndIf
			EndIf
		Next

		If !Empty(cCmpNE)
			MSGALERT( OemToAnsi(STR0036) + cCmpNE + OemToAnsi(STR0037),  OemToAnsi(STR0018) ) // "Los campos" + " no existen en la Tabla SRA " +   "Atencion"
			lRet := .F.
		EndIf
	EndIf

	RestArea(aArea)

return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fCampSRA   ³ Autor ³ Alfredo Medrano       ³ Data ³28/07/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Genera dialogo para consulta Campos de  SRA                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCampSRA()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NA                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ __cCmpSRa = Campos seleccionados                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ X1_F3 de MV_PAR17 Preg. FOLPLAM                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function fCampSR2()
	Local aArea		:= getArea()
	Local cCamp		:= ""
	Local cDesc		:= ""
	Local cNomCam	:= ""
	Local cCampSRA	:= ""
	Local oDlgRec	:= NIL
	Local oBoton	:= NIL
	Local oBusca	:= NIL
	Local aRCampo	:= {}
	Local aOrdenes	:= {1}
	Local lRet		:= .T.
	Local nPos		:= 0
	Local nPosLbx	:= 0
	Local nCont		:= 0
	Local nOrd		:= 1
	Local cBusca	:= Space(80)
	Local cClave	:= MV_PAR17

	Private cIndx	:= ""
	Private bLinea	:= {||}
	Private aIndx	:= {}
	Private aItems	:= {}
	Private oLbx	:= Nil

	cClave := rtrim(cClave)
	__cCmpSRa := cClave

	CursorWait()
	//-- Campos por los que hara las busquedas
	aAdd(aIndx, OemToAnsi(STR0026))
	aAdd(aIndx, OemToAnsi(STR0027))
	cCampSRA:= fTablesBox(2, "SRA")
	//Se obtienen los campos
	aRCampo := STRTOKARR(ALLTRIM(cCampSRA), ';')
	If Len(aRCampo) > 0
		For nCont := 1 to Len(aRCampo)
			cCamp:= SUBSTR(aRCampo[nCont],1, AT("=",aRCampo[nCont])-1)
			cDesc:= SUBSTR(aRCampo[nCont],AT("=",aRCampo[nCont]) + 1, Len(aRCampo[nCont]) )
			AADD(aItems,{cCamp,cDesc } )
		Next
	EndIf
	CursorArrow()

	//Si no existen Campos se envía mensaje en pantalla
	If Valtype(aItems) <> 'A'//Len(aItems) == 0
		Aviso(OemToAnsi(STR0030),OemToAnsi(STR0031),{OemToAnsi(STR0032)})//"Atencion" "No hay informaci¢n para consultar." 'Ok'
		lRet:= .F.
		Return lRet
	ElseIf	 Len(aItems) == 0
		Aviso(OemToAnsi(STR0030),OemToAnsi(STR0031),{OemToAnsi(STR0032)})//"Atencion" "No hay informaci¢n para consultar." 'Ok'
		lRet:= .F.
		RestArea(aArea)
		Return lRet
	Endif

	bLinea := {|| {	aItems[oLbx1:nAt,1], aItems[oLbx1:nAt,2]}}

	//-- Posicion en el arreglo donde esta la actual clave de producto
	If !Empty(cClave)
		nPos := aScan(aItems,{|x| x[1] = cClave}) //posiciona en el producto contenid en el campo ReadVar
	EndIf

	//-- Despliega consulta
	DEFINE MSDIALOG oDlgRec Title OemToAnsi(STR0029) From 000,000 To 421,522 Pixel //"Campos SRA"

	@ 02,05 MSCOMBOBOX oIndx VAR cIndx ITEMS aIndx size 210,08 PIXEL OF oDlgRec
	oIndx:bChange := {|| (nOrd:=oIndx:nAt, Reordena(@oLbx1, aItems, nOrd)) }

	@ 02,220 BUTTON oBoton PROMPT OemToAnsi(STR0028) SIZE 35,10 ; //"Buscar"
	ACTION (oLbx1:nAT := BuscaCve(oLbx1, aItems, nOrd, aOrdenes, cBusca), ;
		oLbx1:bLine := bLinea, ;
		oLbx1:SetFocus());
		PIXEL OF oDlgRec
	@ 14,05 MSGET oBusca VAR cBusca PICTURE "@!" SIZE 210,08 PIXEL OF oDlgRec
	@ 28,05 LISTBOX oLbx1 VAR nPosLbx FIELDS HEADER OemToAnsi(STR0026),  OemToAnsi(STR0027),; //"Campo","Descripción"
	SIZE 255,149 OF oDlgRec PIXEL
	oLbx1:SetArray(aItems)

	If nPos > 0
		oLbx1:nAt := nPos
	Endif

	oLbx1:bLine:= if(len(aItems)>0,bLinea,{||})
	oLbx1:BlDblClick := {||(lRet:=.T.,nPos:=oLbx1:nAt,oDlgRec:End())}
	oLbx1:Refresh()

	DEFINE SBUTTON FROM 195, 05 TYPE 1 ENABLE OF oDlgRec ACTION (lRet:=.T.,nPos:=oLbx1:nAt,oDlgRec:End())
	DEFINE SBUTTON FROM 195, 36 TYPE 2 ENABLE OF oDlgRec ACTION (lRet:=.F.,nPos:=0,oDlgRec:End())

	ACTIVATE MSDIALOG oDlgRec CENTERED

	If lRet .and. nPos <> 0

		if !Empty(cClave)
			cNomCam :=  cClave + ";" + aItems[nPos][1]
		else
			cNomCam := aItems[nPos][1]
		endif

	EndIf

	__cCmpSRa := cNomCam

	RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaCve  ºAutor  ³Alfredo Medrano     º Data ³ 28/07/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca la posición de una clave en el listbox y retorna      º±±
±±º          ³su posición                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CTBA093                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaCve(oLbx1, aItems, nOrd, aOrdenes, cBusca)
	Local nPos := 0
	Local nCol := aOrdenes[nOrd]

	cBusca := Upper(Trim(cBusca))
	nPos := ASCAN(aItems, {|aVal| aVal[nCol]=cBusca} )

	If nPos == 0
		nPos := oLbx1:nAt
	EndIf

Return nPos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReOrdena  ºAutor  ³Alfredo Medrano     º Data ³ 28/07/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Re Ordena los elementos de un listbox según el índice.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CTBA093                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Reordena(oLbx1,aItems,nOrd)

	CursorWait()

	If nOrd == 1
		aItems := aSort(aItems,,,{|x,y| x[1]+x[2] <= y[1]+y[2] })
	ElseIf nOrd == 2
		aItems := aSort(aItems,,,{|x,y| x[2]+x[1] <= y[2]+y[1] })
	Endif

	oLbx1:SetArray(aItems)
	oLbx1:nAt := 1
	oLbx1:bLine := bLinea
	oLbx1:Refresh()

	CursorArrow()

Return Nil

Static Function TodoOK(cPerg)

	Pergunte(cPerg,.F.)

	cCamposEmp	:= MV_PAR17 //Lista de Conceptos 2

	makesqlExpr(cPerg)

	If Len(aCmpSRA) == 0
		u_Gpr017Cmp(cCamposEmp)
	EndIf


Return (.T.)
