#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MODIFACT    ³ Autor ³Erick Etcheverry     ³ Data ³15.06.2018³±±
±±³						  	      ³Denar Terrazas						   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri³ Browse con campos alterar factura compra llamado desde modifact³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALTERFAT
	Local cCpoPza	  := GetNewPar("MV_DAVINC2","")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
	Local ccNumAut	  := SF1->F1_NUMAUT
	Local ccCodCtr	  := SF1->F1_CODCTR
	Local ccCodPoliz  := SF1->&(cCpoPza)
	Local cCnit		  := ""
	Local cCnomRaz	  := ""
	Local ocNitCli
	Local ocNomCli
	Local ocNpoliz
	Local ocNitPrv
	Local ocNrazPrv
	Local _oDlg

	cCnit	:= POSICIONE("SA2", 1, xFilial("SA2") + SF1->F1_FORNECE + F1_LOJA,"A2_CGC")
	cCnomRaz:= POSICIONE("SA2", 1, xFilial("SA2") + SF1->F1_FORNECE + F1_LOJA,"A2_NOME")
	lModifica := .f.
	//alert(SF1->F1_FORNECE)
	//alert(GetNewPar("MV_UMODLC",""))
	If SF1->F1_FORNECE $ GetNewPar("MV_UMODLC","")
		lModifica := .t.
	Endif

	lClick = .F.	// et saber que clicko boton
	DEFINE MSDIALOG _oDlg TITLE "Datos de la Factura" FROM C(288),C(463) TO C(510),C(859) PIXEL

	// Cria as Groups do Sistema
	@ C(004),C(004) TO C(0100),C(192) LABEL "Datos para Facturar" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(017),C(011) Say "Codigo  de  Control: " Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(017),C(060) MsGet ocNomCli Var ccCodCtr Size C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg VALID !EMPTY(ccCodCtr)
	@ C(034),C(011) Say "Numero Autorizacion: " Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(034),C(060) MsGet ocNitCli Var ccNumAut Size C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut)
	@ C(051),C(011) Say "Nro Póliza Importación" Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(051),C(060) MSGET ocNpoliz VAR ccCodPoliz  SIZE C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut)
	@ C(068),C(011) Say "Razon Social Proveedor" Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(068),C(060) MSGET ocNrazPrv VAR cCnomRaz  SIZE C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut) WHEN lModifica
	@ C(085),C(011) Say "Nit Proveedor" Size C(050),C(020) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(085),C(060) MSGET ocNitPrv VAR cCnit  SIZE C(081),C(005) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNumAut) WHEN lModifica

	@ C(101),C(146) Button "&Confirmar" Size C(037),C(012) PIXEL OF _oDlg ACTION (_oDlg:END(),lClick := .t.)

	ACTIVATE MSDIALOG _oDlg CENTERED

	//et procesar los valores actualizar la tabla SF1| SF3
	if lClick == .t.

		SF1->(RecLock('SF1', .F.))
		SF1->&(cCpoPza):= ccCodPoliz
		F1_NUMAUT      := ccNumAut
		F1_CODCTR      := ccCodCtr
		F1_UNIT := cCnit
		F1_UNOMBRE := cCnomRaz
		SF1->(MsUnlock())

		dbSelectArea("SF3")
		dbSetOrder(4)
		IF dbSeek(xFilial("SF3") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE)
			WHILE !EOF() .AND. SF1->F1_FORNECE == SF3->F3_CLIEFOR .AND. SF1->F1_LOJA == SF3->F3_LOJA .AND.;
			SF1->F1_DOC == SF3->F3_NFISCAL .AND. SF1->F1_SERIE == SF3->F3_SERIE

				SF3->(RecLock('SF3', .F.))
				F3_NUMAUT  := ccNumAut
				F3_CODCTR  := ccCodCtr
				SF3->(MsUnlock())
				DBSKIP()
			ENDDO
		ENDIF

	endif

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