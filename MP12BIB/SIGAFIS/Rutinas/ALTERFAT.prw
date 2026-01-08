#include 'protheus.ch'
#include 'parmtype.ch'

#define NOPCNO	1
#define NOPCSI	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MODIFACT    ³ Autor ³Erick Etcheverry     ³ Data ³15.06.2018³±±
±±³						  	      ³Denar Terrazas						   ±±
±±³			 ³CAMBIOS													   ±±
±±³Omar Delgadillo		³Quitar validación del código de control	       ±±
±±						³que permita vacío.				³ Data ³16.09.2019³±±
±±³Denar Terrazas		³Se agregó el campo "Fecha de la Factura".	       ±±
±±						³Se agregó un boton para cancelar.                 ±±
±±						³Se agregó una pregunta de confirmación.           ±±
±±						³								³ Data ³03.06.2020³±±
±±³Omar Delgadillo		³Modificar funcionalidad parámetro MV_UMODLC que   ±±
±±						³permite modificar Nombre y Razon Social Proveedor ±±
±±						³Vacío no modifica								   ±±
±±						³Código fijo solo modifica ese proveedor 		   ±±		
±±						³ZZZZZZ permite modificar cualquier proveedor	   ±±
±±						³								³ Data ³07.09.2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri³ Browse con campos alterar factura compra llamado desde modifact³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALTERFAT
	Local ocNitCli
	Local ocNomCli
	Local ocNpoliz
	Local odFchFact
	Local ocNitPrv
	Local ocNrazPrv
	Local _oDlg
	Private cCpoPza		:= GetNewPar("MV_DAVINC2","")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
	Private ccNumAut	:= SF1->F1_NUMAUT
	Private ccCodCtr	:= SF1->F1_CODCTR
	Private ccCodPoliz	:= SF1->&(cCpoPza)
	Private dFchFact	:= SF1->F1_EMISSAO
	Private cCnit		:= ""
	Private cCnomRaz	:= ""
	Private cC_nit		:= ""
	Private cC_nomRaz	:= ""
	Private dEmissao	:= SF1->F1_EMISSAO

	cCnit := POSICIONE("SA2", 1, xFilial("SA2") + SF1->F1_FORNECE + F1_LOJA,"A2_CGC")	
	if FieldPos("F1_UNIT") > 0
		if TRIM(SF1->F1_UNIT) <> ""
			cCnit := SF1->F1_UNIT
		Endif
	Endif
	cC_nit := cCnit
	
	cCnomRaz := POSICIONE("SA2", 1, xFilial("SA2") + SF1->F1_FORNECE + F1_LOJA,"A2_NOME")
	If FieldPos("F1_UNOMBRE") > 0
		If TRIM(SF1->F1_UNOMBRE) <> ""
			cCnomRaz := SF1->F1_UNOMBRE
		Endif
	ENDIF	
	cC_nomRaz := cCnomRaz
	
	lModifica := .f.
	If SF1->F1_FORNECE $ GetNewPar("MV_UMODLC","") .or. GetNewPar("MV_UMODLC","") = "ZZZZZZ"
		lModifica := .t.
	Endif

	DEFINE MSDIALOG _oDlg TITLE "Datos de la Factura" FROM C(288),C(463) TO C(550),C(859) PIXEL

	// Cria as Groups do Sistema
	@ C(004),C(004) TO C(0115),C(192) LABEL "Datos para Facturar" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(017),C(011) Say "Código  de  Control: " 	Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(017),C(060) MSGET ocNomCli Var ccCodCtr 	Size C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(034),C(011) Say "Número Autorizacion: " 	Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(034),C(060) MSGET ocNitCli Var ccNumAut 	Size C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut)
	@ C(051),C(011) Say "Nro. Póliza Importación:" 	Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(051),C(060) MSGET ocNpoliz VAR ccCodPoliz  	SIZE C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut)
	@ C(068),C(011) Say "Fecha de la Factura:" 		Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(068),C(060) MSGET odFchFact VAR dFchFact  	SIZE C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut) .AND. validDate(dFchFact)
	@ C(085),C(011) Say "Razón Social Proveedor:" 	Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(085),C(060) MSGET ocNrazPrv VAR cCnomRaz  	SIZE C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut) WHEN lModifica
	@ C(102),C(011) Say "Nit Proveedor:" 			Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(102),C(060) MSGET ocNitPrv VAR cCnit  		SIZE C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut) WHEN lModifica

	@ C(119),C(110) Button "&Cancelar" Size C(037),C(012) PIXEL OF _oDlg ACTION _oDlg:END()
	@ C(119),C(156) Button "&Confirmar" Size C(037),C(012) PIXEL OF _oDlg ACTION confirm(_oDlg)

	ACTIVATE MSDIALOG _oDlg CENTERED

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para tema "Flat"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

/**
*
* @author		Denar Terrazas Parada
* @since		03/06/2020
* @description	Funcion para validar que el cambio de fecha sea dentro del mismo mes
* @parameter	dFchFact -> Fecha modificada
*/
Static function validDate(dFchFact)
	Local aArea	:= getArea()
	Local lRet	:= .F.

	If(YEAR(dEmissao) == YEAR(dFchFact) .AND. MONTH(dEmissao) == MONTH(dFchFact))
		lRet:= .T.
	else
		alert("No es posible modificar la fecha a un mes diferente de la fecha de la factura.")
	EndIf

	restArea(aArea)
Return lRet

/**
*
* @author		Denar Terrazas Parada
* @since		03/06/2020
* @description	Funcion para confirmar el cambio realizado
* @parameter	_oDlg -> MSDIALOG
*/
static function confirm(_oDlg)
	Local nOpcAviso
	Local cTitulo	:= "Totvs"
	nOpcAviso:= Aviso(cTitulo,'¿Está seguro(a) que desea realizar el cambio?',{'No', 'Si'})
	if(nOpcAviso == NOPCSI)
		MsgRun("Ejecutando proceso...","Espere",{|| updateFact() })
		Aviso(cTitulo,"Proceso ejecutado con éxito!",{'Ok'})
		_oDlg:END()
	EndIf
return

Static Function updateFact()
	Local aArea	:= getArea()
	SF1->(RecLock('SF1', .F.))

	SF1->&(cCpoPza)	:= ccCodPoliz
	SF1->F1_NUMAUT	:= ccNumAut
	SF1->F1_CODCTR	:= ccCodCtr
	SF1->F1_EMISSAO := dFchFact

	if cCnit <> cC_nit
		SF1->F1_UNIT := cCnit
	Endif
	if cCnomRaz <> cC_nomRaz
		SF1->F1_UNOMBRE	:= cCnomRaz
	Endif

	SF1->(MsUnlock())

	dbSelectArea("SF3")
	dbSetOrder(4)
	IF dbSeek(xFilial("SF3") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE)
		WHILE !EOF() .AND. SF1->F1_FORNECE == SF3->F3_CLIEFOR .AND. SF1->F1_LOJA == SF3->F3_LOJA .AND.;
		SF1->F1_DOC == SF3->F3_NFISCAL .AND. SF1->F1_SERIE == SF3->F3_SERIE

			SF3->(RecLock('SF3', .F.))

			SF3->F3_NUMAUT	:= ccNumAut
			SF3->F3_CODCTR	:= ccCodCtr
			SF3->F3_EMISSAO	:= dFchFact

			SF3->(MsUnlock())
			DBSKIP()
		ENDDO
	ENDIF
	restArea(aArea)
Return
