#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Tbiconn.ch"
#include "Topconn.ch"
#Include "FileIO.ch"
#include 'parmtype.ch'

#Define ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MigraSE1  ºAutor  ³Edson  		 ºFecha ³  30/05/2019     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa Importação de Remisão de entrada         	  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\Inesco                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Importrem()
	Private oDlg
	Private oModel  := FWModelActive()
	Private oView := FWViewActive()
	//	oView:SetModel( oModel )
	//	oModel := FWLoadModel( oModel)
	//alert(FUNNAME())
	/*

	@ 000,000 TO 120,380 DIALOG oDlg TITLE OemToAnsi("Importación de Remisiones/OwnerShip")
	@ 003,003 TO 058,188
	@ 010,018 Say "Este programa tiene como objetivo importar uno o mas "
	@ 018,018 Say "productos de una lista de precio desde un archivo *.csv"
	//.xlsx

	@ 040,128 BMPBUTTON TYPE 01 ACTION MsAguarde({|| Importar(),"Procesando. Hora de inicio: " + Time()})
	@ 040,158 BMPBUTTON TYPE 02 ACTION oDlg:End()

	Activate Dialog oDlg Centered
	*/
	Importar()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Importar  ºAutor  ³Edson 		         ºFecha ³  27/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11.3                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Importar()

	Local cTabla		:= ""
	Local cStrCpos		:= ""
	Local nX			:= 1
	Local cTitulo1  	:= "Seleccione Archivo"
	Local cExtens   	:= "Archivo | "
	Local cFile 		:= ""
	Local aArchi		:= {}
	Local cLinea		:= ""
	Local cCampo		:= ""
	Local cNumPed		:= ""
	Local cNumAux		:= ""
	Local cCposCab		:= "DA1_ITEM|DA1_CODTAB|DA1_CODPRO|DA1_PRCVEN"
	Local lFirst		:= .T.
	Local lGrabCab		:= .T.
	Local aValores		:= {}
	Local aCpos			:= {}
	Local cHoraIni		:= Time()
	Local cProxReg		:= ""
	Local cFileLog		:= ""
	Local cDirLog		:= ""
	Local cPath			:= ""
	Local lError		:= .F.
	Local nCantReg		:= 0
	Local lFin			:= .F.
	Local aArray		:= {}
	Local aTotCabs		:= {}
	Local aItArray		:= {}
	Local xValor
	Local cxDoc			:= ""
	Local aCabec		:= {}
	Local aItem			:= {}
	Local aLinha		:= {}

	Private lMSHelpAuto := .T. //.F. // Para nao mostrar os erro na tela
	Private lMSErroAuto := .F. //.F. // Inicializa como falso, se voltar verdadeiro e' que deu erro

	oModelGrid := oModel:GetModel( "DA1DETAIL" ) // obtener el modelo del grid
	nTotLin := oModelGrid:Length( .F. ) // obtenes el TOTAL de lineas del grid
	//				"LT15199ELF     "
	// Adicionando pergunte.
	
	IF !pergunte("FASAL",.t.) // sólo sigue caso que seleccione ok
		RETURN  // retorna vacio
	ENDIF

	//	F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	//		F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	cQuery := "Select F1_DOC,F1_SERIE,F1_FORNECE,D1_ITEM"
	cQuery += ",D1_COD,D1_VUNIT "
	cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
	cQuery += " INNER JOIN " +RetSqlName("SD1") + " SD1 ON F1_DOC = D1_DOC AND F1_FILIAL = D1_FILIAL AND F1_SERIE = D1_SERIE AND SD1.D_E_L_E_T_ <> '*'  AND F1_FORNECE = D1_FORNECE"
	cQuery += " WHERE "// F1_FILIAL Between '"+trim(mv_par01)+"' AND '"+trim(mv_par02)+"'"
	cQuery += " F1_EMISSAO Between '"+DTOS(mv_par01)+"' and '"+DTOS(mv_par02)+"'"
	cQuery += " AND F1_FORNECE Between '"+mv_par06+"' AND '"+mv_par07+"'"
	cQuery += " AND LTRIM(RTRIM(F1_DOC)) Between '"+trim(mv_par03)+"' AND '"+trim(mv_par04)+"'"
	cQuery += " AND upper(F1_SERIE)= upper('"+mv_par05+"') "
	cQuery += " AND F1_ESPECIE = 'RCN' "
	cQuery += " AND SF1.D_E_L_E_T_ <> '*' "
	cQuery += " order by D1_ITEM "

	//MemoWrite("SqlUFacEnt.sql",cQuery)
	//Alert(cQuery)

	TCQUERY cQuery NEW ALIAS "OrdenesCom"

	While OrdenesCom->(!EOF())
		//	impArcExcel(OrdenesCom->D1_COD, 2000,2, nX)
		// Nahim Valida que siempre sea en dólares 
		nValor := xMoeda(1,OrdenesCom->D1_VUNIT,2,DDATABASE)
		
		impArcExcel(OrdenesCom->D1_COD, nValor,2, nX)
		OrdenesCom->(dbSkip())
	enddo
	OrdenesCom->(DbCloseArea())

	/***
	* _________________________________________________________
	* cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
	* ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	* <ExpC1> - Expressao de filtro
	* <ExpC2> - Titulo da janela
	* <ExpN1> - Numero de mascara default 1 para *.Exe
	* <ExpC3> - Diretório inicial se necessário
	* <ExpL1> - .F. botão salvar - .T. botão abrir
	* <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
	*/
	oView:Refresh() // haces un refresh a la VIEW
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³          ³ Autor ³                     ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Str2Array(cString,cSep)
	Local 	aReturn := { }		,;
	cAux    := cString	,;
	nPos    := 0

	While At( cSep, cAux ) > 0
		nPos  := At( cSep, cAux )
		cVal  := SubStr( cAux, 1, nPos-1 )
		Aadd( aReturn,  cVal )
		cAux  := SubStr( cAux, nPos+1 )
	EndDo

	Aadd(aReturn,cAux)
Return(aReturn)

static Function impArcExcel(codigoPro, cxPrecio,nPosMoeda, nX)

	//	local oModel := Model
	local oModelGrid
	//	oModel := FWModelActive()
	local nLin
	//oModelGrid := oModel:GetModel( "FLYDETAIL" ) // obtener el modelo del grid
	// Retorna o total de linhas, incluindo as deletadas.*
	local lEncontro := .F.
	oModelGrid := oModel:GetModel( "DA1DETAIL" ) // obtener el modelo del grid
	nTotLin := oModelGrid:Length( .F. ) // obtenes el TOTAL de lineas del grid

	For nLin := 1 To nTotLin

		oModelGrid:SetLine( nLin  ) // le das el total

		If !oModelGrid:IsDeleted( nLin ) // si es que NO está borrada
			if (trim(oModelGrid:getvalue("DA1_CODPRO")) == TRIM(codigoPro) )// comprobar)
				lEncontro = oModelGrid:DeleteLine()    // modificas el VALOR
				//				oModelGrid:SetValue("DA1_PRCBAS", U_GetCosPro()     )    // modificas el VALOR
//				lEncontro := .T.
//				alert(lEncontro)
				Exit
			EndIf
		EndIf
	Next
	oModelGrid:AddLine() // AGREGAS UNA LINEA
	oModelGrid:SetLine( nTotLin++ )
	oModelGrid:SetValue("DA1_CODPRO",  codigoPro )    // modificas el VALOR
	oModelGrid:SetValue("DA1_PRCBAS", cxPrecio )    // modificas el VALOR
	//		oModelGrid:SetValue("DA1_PRCBAS", nPosMoeda )   // nPosMoeda

	//				oModelGrid:SetValue("DA1_MOEDA",  nPosMoeda )    // modificas el VALOR
	//		oModelGrid:SetValue("DA1_PRCVEN",  cxPrecio )    // modificas el VALOR
	//	else // eoncontró
	//		oModelGrid:SetLine( nTotLin)
	//		oModelGrid:SetValue("DA1_CODPRO",  codigoPro )    // modificas el VALOR
	//		oModelGrid:SetValue("DA1_PRCBAS", cxPrecio )    // modificas el VALOR
	// importar en si
	/*oModelGrid:AddLine() // AGREGAS UNA LINEA
	oModelGrid:SetLine( nLin++ ) // TE VAS A ESA LINEA
	oModelGrid:SetValue("DA1_PRCVEN", 23 )   // agregas segun la columna el valor deseado*/
	//aAdd(bLoadGrd,{0,{1, ddatabase, 12, 12,12,12,12}})
	nTotLin++
	oModelGrid:SetLine( 1 )

return