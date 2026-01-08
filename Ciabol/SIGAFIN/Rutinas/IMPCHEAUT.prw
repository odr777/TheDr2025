#Include "Protheus.Ch"
#include "rwmake.ch"
#include "topconn.ch"
#Include "Colors.ch"
#Define BOLD		.T.
#Define ITALIC		.T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ISIMPCH  ³ Autor ³ Jorge Saavedra        ³ Data ³ 03.01.13 ³±±
±±³Fun‡„o   Modified Erick Etcheverry			        ³ Data ³ 03.01.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que Guarda y Imprime los Cheques                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CHFINP07(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Exclusivo:  Especifico INESCO              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPCHEAUT(aOrpag)
	Local oDlg
	Private _cBanco     := Space(003)
	Private _cAgencia   := Space(005)
	Private _cConta     := Space(035)
	Private _cPrimChq   := Space(012)
	Private _cNomeBco   := Space(050)
	Private _cOrdenIni  := Space(012)

	_cBanco     := aOrpag[1][3]
	_cAgencia   := aOrpag[1][4]
	_cConta     := aOrpag[1][5]
	cEFnum := aOrpag[1][6]
	If SA6->(DbSeek(xFilial("SA6")+_cBanco))
		_cNomeBco	:= ALLTRIM(SA6->A6_NOME)
	Else
		MsgAlert("El código de banco ingresado es incorrecto.","Atención")
	Endif
	_cOrdenIni  := aOrpag[1][1]

	SfRevBenef(_cBanco,_cAgencia,_cConta,_cOrdenIni,cEFnum)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SfRevBenef³ Autor ³ Rodrigo Olivares      ³ Data ³ 02.12.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SfRevBenef()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SfRevBenef(_cBanco,_cAgencia,_cConta,_cOrdPg,cEFnum)
	Local   lRet	:= .T.
	Local   lReGra	:= .T.
	Private   aRegSef := {}

	/*Dbselectarea("SEF")//EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM
	dbSetOrder(1)
	if SEF->(DbSeek(xFilial("SEF")+_cBanco+_cAgencia+_cConta+_cOrdPg))*/

	/*aviso("Array 1",alltrim(SEF->EF_FILIAL)+alltrim(SEF->EF_BANCO)+alltrim(SEF->EF_AGENCIA)+alltrim(SEF->EF_CONTA)+alltrim(SEF->EF_NUM),{'ok'},,,,,.t.)
	aviso("Array 2",alltrim(xFilial("SEF"))+alltrim(_cBanco)+alltrim(_cAgencia)+alltrim(_cConta)+alltrim(_cOrdPg),{'ok'},,,,,.t.)*/

	While !SEF->(Eof()) .and. alltrim(SEF->EF_FILIAL)+alltrim(SEF->EF_BANCO)+alltrim(SEF->EF_AGENCIA)+alltrim(SEF->EF_CONTA);
	+alltrim(SEF->EF_NUM);
	== alltrim(xFilial("SEF"))+alltrim(_cBanco)+alltrim(_cAgencia)+alltrim(_cConta)+alltrim(cEFnum)
		lRegra:=.T.
		While lRegra
			If RecLock("SEF",.F.)
				lRegra:=.F.
				Aadd(aRegSef,Array(10))
				aRegSef[Len(aRegSef),1] := SEF->EF_TITULO
				aRegSef[Len(aRegSef),2] := Dtoc(SEF->EF_VENCTO)  //aRegSef[Len(aRegSef),2] := Dtoc(SEF->EF_DATA) //POR DEFINICION DE BETTY EN LA PLANILLA

				aRegSef[Len(aRegSef),3] := IIF(EMPTY(SEF->EF_BENEF),Alltrim(Posicione("SA2",1,XFILIAL("SA2")+SEF->EF_FORNECE + SEF->EF_LOJA,"A2_NOME")),SEF->EF_BENEF)//

				DBSELECTAREA("SEK")
				SEK->(DBSETORDER(3))
				SEK->(DBGOTOP())
				//Moneda del EK titulo
				IF SEK->(DbSeek(xFilial("SEK")+DTOS(SEF->EF_DATA)+ALLTRIM(SEF->EF_TITULO)))
					IF ALLTRIM(SEK->EK_FORNECE)==(ALLTRIM(SEF->EF_FORNECE)) .AND. ALLTRIM(SEF->EF_TITULO) == ALLTRIM(SEK->EK_ORDPAGO)
						aRegSef[Len(aRegSef),4] := SEK->EK_MOEDA
						RecLock("SEF",.F.)
						SEF->EF_ALINEA2 := SEK->EK_MOEDA
						MsUnlock()
						aRegSef[Len(aRegSef),7] := SEF->EF_NUM         //aRegSef[Len(aRegSef),7] := SEK->EK_NUM
					ENDIF
				ENDIF
				aRegSef[Len(aRegSef),5] := SEF->EF_VALOR
				aRegSef[Len(aRegSef),6] := SEF->(Recno())
				aRegSef[Len(aRegSef),8] := SEF->EF_DATA
				aRegSef[Len(aRegSef),9] := SEF->EF_AGENCIA
				aRegSef[Len(aRegSef),10] := SEF->EF_CONTA
				SEK->(DBCLOSEAREA())
			Endif
		EndDO
		Dbselectarea("SEF")
		Dbskip()
	Enddo

	SfSeleChq(_cBanco,_cAgencia,_cConta,_cOrdenIni,aRegSef )

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SfSeleChq ³ Autor ³ Rodrigo Olivares      ³ Data ³ 02.12.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SfSeleChq()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SfSeleChq(_cBanco,_cAgencia,_cConta,_cOrdenIni,aRegSef)
	Local   	nVeces	:= 0
	Local   	lRet	:= .T.
	Private 	aCols		:= {}
	private aRecnos := {}

	For nVeces := 1 To Len( aRegSef )
		Dbselectarea("SEF")
		Dbgoto(aRegSef[nVeces,6])
		If SEF->EF_IMPRESS <> 'S' .And. SEF->EF_IMPRESS <> 'C'

			Aadd(aCols,Array(11))
			aCols[Len(aCols),1]:=Padl(Alltrim(Str(Len(aCols))),2,"0")
			aCols[Len(aCols),2]:=Alltrim(aRegSef[nVeces,1])

			aCols[Len(aCols),3]:=Alltrim(aRegSef[nVeces,7])
			/*cBenef := jbenefview(aRegSef[nVeces,3])
			if empty(cBenef)*/
			cBenef := SEF->EF_BENEF
			//endif

			aCols[Len(aCols),4]:=cBenef//If (len(alltrim(aRegSef[nVeces,3]))=40,alltrim(aRegSef[nVeces,3]),alltrim(aRegSef[nVeces,3]) +space(40-len(alltrim(aRegSef[nVeces,3]))))
			aCols[Len(aCols),5]:=aRegSef[nVeces,4]
			aCols[Len(aCols),6]:=aRegSef[nVeces,5]
			aCols[Len(aCols),7]:=aRegSef[nVeces,6]
			aCols[Len(aCols),8]:=aRegSef[nVeces,8]
			aCols[Len(aCols),9]:=aRegSef[nVeces,9]//agencia
			aCols[Len(aCols),10]:=aRegSef[nVeces,10]//conta
			aCols[Len(aCols),11]:=.t.
			AADD(aRecnos,aRegSef[nVeces,6])
		Endif

	Next nVeces

	dbclosearea()
	ImpCheques(_cBanco,aRecnos,cBenef)
Return(lRet)

Static Function ImpCheques(_cBanco,aRecnos,cBenef)
	cLugar:=POSICIONE('SM0',1,cEmpAnt+SEF->EF_FILIAL,'M0_ESTCOB')
	cDesLugar := Posicione("SX5",1,xFilial("SX5")+ "12" + alltrim(cLugar) ,"X5_DESCRI")
	_cBanco:=alltrim(_cBanco)
	aDetFE := {}
	For nCont := 1 To Len(aCols)
		aDet := DETBANK(aCols[nCont,6],cDesLugar,aCols[nCont,4],aCols[nCont,8],1,_cBanco)
		AADD(aDetFE,aDet)
	Next

	U_CHIMPOR(aDetFE)//llama impresion

	for i:=1 to len(aRecnos) //ACTUALIZA BENEFICIARIOS
		Dbselectarea("SEF")
		Dbgoto(aRecnos[i])
		RecLock("SEF",.F.)
		SEF->EF_BENEF := cBenef
		If Empty(SEF->EF_IMPRESS)
			SEF->EF_IMPRESS := "S" // actualiza para no reimprimir
		EndIf
		MsUnlock()
	next i

Return

Static Function DETBANK(Monto,Lugar,Beneficiario,Fecha,NroParte,_cBanco)
	Local aDatos := {}
	aAfecha := StrTokArr2(DTOC(Fecha),"/")
	aadd(aDatos,{alltrim(Lugar),alltrim(str(Day(Fecha))),alltrim(MesExtenso(month(Fecha)));
	,alltrim(str(year(Fecha))),alltrim(Beneficiario),Extenso(Monto),Monto,_cBanco,aAfecha[1],;
	aAfecha[2],aAfecha[3]})

Return aDatos

static function jbenefview(ccOper)
	Local ccNroBank	 := ccOper
	Local ocNroOpe
	Local _oDlg				// Dialog Principal

	nSpace := 40 - len(ccNroBank)

	ccNroBank = ccNroBank + space(nSpace)

	iF EMPTY(ccNroBank)
		ccNroBank	 := Space(40)
	END

	DEFINE MSDIALOG _oDlg TITLE "Nombre del beneficiario" FROM C(288),C(463) TO C(474),C(859) PIXEL

	// Cria as Groups do Sistema
	@ C(004),C(004) TO C(061),C(192) LABEL "Benefeciario" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(017),C(011) Say "Beneficiario: " Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(017),C(042) MsGet ocNroOpe Var ccNroBank Size C(138),C(009) COLOR CLR_BLACK PIXEL OF _oDlg VALID !EMPTY(ccNroBank)
	@ C(068),C(146) Button "&Confirmar" Size C(037),C(012) PIXEL OF _oDlg ACTION _oDlg:END()

	ACTIVATE MSDIALOG _oDlg CENTERED

Return cValtoChar(ccNroBank)

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