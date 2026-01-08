#include "Protheus.ch"
//#define cGrupos = GETNEWPAR( MV_GRAFGAR, "('0001','9999')") //"('0001','9999')"

USER FUNCTION AFLCR004() //VALOR ACTUAL DE LINEA, VLRLIN LIMITE DE LA LINEA

	Local aCpos		    := {}
	Local aCampos		:= {}
	Local nI			:= 0
	Local cAlias		:= "SN1"

	Local cTexto := ""

	Local oDlg
	Local oMemo
	Private cEOL := CHR(10)+CHR(13)
	Private LINEA  := SA6->A6_NUMCON
	Private VALOR  := 0.00                //VALOR EN ACTIVOS PARA LINEA
	Private VLRLIN := SA6->A6_LIMCRED //VALOR DE LA LINEA

	Private aRotina     := {}
	Private aRecLC 	:= {}
	Private cCadastro   := "Activos en garantía de lineas de crédito"

	/*Private aCores := { {"empty(N1_ULINEA1).and.empty(N1_ULINEA2) ","BR_VERDE"} ,;
	{"!(empty(N1_ULINEA1).and.empty(N1_ULINEA2) ","BR_AZUL"} ,;
	{"(empty(N1_ULINEA1).and.!empty(N1_ULINEA2) ","BR_LARANJA"} ,;
	{"!empty(N1_ULINEA1).and.!empty(N1_ULINEA2) ","BR_VERMELHO"}}
	*/

	Private aCores := { {"empty(N1_ULINEA1).and.empty(N1_ULINEA2) ","BR_VERDE"} ,;
	{"(!empty(N1_ULINEA1).and.empty(N1_ULINEA2) ","BR_AZUL"} ,;
	{"(empty(N1_ULINEA1).and.!empty(N1_ULINEA2) ","BR_LARANJA"} ,;
	{"!empty(N1_ULINEA1).and.!empty(N1_ULINEA2) ","BR_VERMELHO"}}

	AADD(aRotina,{"Visualizar"	,"U_VISN1()"	 ,0,2})
	AADD(aRotina,{"Buscar"	,"AxPesqui"	 ,0,3})
	AADD(aRotina,{"Legenda","U_LEGAFLC()",0,4})

	AADD(aCpos,"N1_OK"	)
	AADD(aCpos,"N1_CBASE"	)
	AADD(aCpos,"N1_ITEM"	)
	AADD(aCpos,"N1_DESCRIC"	)
	AADD(aCpos,"N1_CHAPA"	)
	AADD(aCpos,"N1_PLACA"	)
	AADD(aCpos,"N1_GRUPO"	)
	AADD(aCpos,"N1_STATUS"	)
	AADD(aCpos,"N1PENHORA"	)
	AADD(aCpos,"N1_VLCOMER"	)
	AADD(aCpos,"N1_UPRCONT"	)
	AADD(aCpos,"N1_UPRES"	)

	AADD(aCpos,"N1_UDOCCON"	)
	AADD(aCpos,"N1_VLRCONT"	)

	AADD(aCpos,"N1_ULINEA1"	)
	AADD(aCpos,"N1_VLRLIN1"	)
	AADD(aCpos,"N1_ULINEA2"	)
	AADD(aCpos,"N1_VLRLIN2"	)

	DbSelectArea("SE5")
	DbSetOrder(11)

	//if !DbSeek(xFilial("SE5")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON).and.SA6->A6_ULINEA == '1'

	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len(aCpos)
		IF dbSeek(aCpos[nI])
			aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),;
			Trim(X3_PICTURE)})
		Endif
	Next

	DbSelectArea(cAlias)
	DbSetOrder(1)
	cGrupos = "('1','2','4','6','9')" //GETNEWPAR( MV_GRAFGAR, "('0001','9999')") //"('0001','9999')"
	cExprFilTop := " SUBSTRING(N1_GRUPO,1,1) IN "+cGrupos +" AND( N1_ULINEA1 = '" + LINEA + "' OR N1_ULINEA2 = '" + LINEA +"')"
	//" AND TRIM(N1_DTCLASS) <> '' AND (TRIM(N1_ULINEA1)='' OR TRIM(N1_ULINEA2)='')"

	MarkBrow(cAlias,aCpos[1],,aCampos,.F., GetMark(,"SN1","N1_OK"),,,,,,,cExprFilTop,,,)

	// MarkBrow(cAlias,campoMarca,CONDICION CAMPOS NO SELCCIONABLES,aCampos,.F., GET ESTADO DE MARCA)
	//"N1_DTCLASS != STOD('//').and.(empty(N1_ULINEA1).or.empty(N1_ULINEA2))"

	/*else
	alert("Solo se puede desasociar activos de Linea de credito y estas no deben tener movmientos")
	endif
	*/
Return

//Exemplo: Função LimpaMarca() - utilização das funções acessórias da MarkBrow()
/*/
+-----------------------------------------------------------------------------
| Programa | LimpaMarca | Autor | ARNALDO RAYMUNDO JR. | Data | |
+-----------------------------------------------------------------------------
| Desc. | Função utilizada para demonstrar o uso do recurso da MarkBrowse|
+-----------------------------------------------------------------------------
| Uso | Curso de ADVPL |
+-----------------------------------------------------------------------------
/*/
STATIC FUNCTION LimpaMarca()
	Local nX := 0
	For nX := 1 to Len(aRecLC)
		SN1->(DbGoto(aRecLC[nX]))
		RecLock("SN1",.F.)
		SN1->N1_OK := SPACE(2)
		MsUnLock()
	Next nX
RETURN

STATIC FUNCTION LEGAFLC()

	Brwlegenda(cCadastro,"Valores",{ {"BR_VERMELHO","Usado en dos Lineas de crédito"} ,;
	{"BR_LARANJA","Usado en segunda linea"},;
	{"BR_AZUL","Usado en primera linea"},;
	{"BR_VERDE","Disponible 100%"}})
RETURN