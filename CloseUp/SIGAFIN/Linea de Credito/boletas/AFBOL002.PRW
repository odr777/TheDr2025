#include "Protheus.ch"
//#define cGrupos = GETNEWPAR( MV_GRAFGAR, "('0001','9999')") //"('0001','9999')"

USER FUNCTION AFBOL002() //VALOR ACTUAL DE LINEA, VLRLIN LIMITE DE LA LINEA
	Local aCpos		    := {}
	Local aCampos		:= {}
	Local nI			:= 0
	Local cAlias		:= "SN1"
	Local cTexto := ""
	Local oDlg
	Local oMemo
	Private cEOL := CHR(10)+CHR(13)
	Private LINEA  := ZEH->ZEH_NUMERO
	Private VALOR  := 0.00                //VALOR EN ACTIVOS PARA LINEA
	Private VLRLIN := ZEH->ZEH_VALOR //VALOR DE LA LINEA antes A6_LIMCRED se retiro porqu se suma al saldo del estracto

	Private aRotina     := {}
	Private aRecLC 	:= {}
	Private cCadastro   := "Retirar Activos en garantía de boletas/polizas"

	Private aCores := { {"empty(N1_UBOLPO1).and.empty(N1_UBOLPO2) ","BR_VERDE"} ,;
	{"(!empty(N1_UBOLPO1).and.empty(N1_UBOLPO2) ","BR_AZUL"} ,;
	{"(empty(N1_UBOLPO1).and.!empty(N1_UBOLPO2) ","BR_LARANJA"} ,;
	{"!empty(N1_UBOLPO1).and.!empty(N1_UBOLPO2) ","BR_VERMELHO"}}

	AADD(aRotina,{"Retirar Activos de boleta/poliza","u_Elimbol" ,0,1})
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

	AADD(aCpos,"N1_UBOLPO1"	)
	AADD(aCpos,"N1_VLRPOL1"	)
	AADD(aCpos,"N1_UBOLPO2"	)
	AADD(aCpos,"N1_VLRPOL2"	)

	//DbSelectArea("SE5")
	//DbSetOrder(11)

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
	cExprFilTop := " SUBSTRING(N1_GRUPO,1,1) IN "+cGrupos +" AND( N1_UBOLPO1 = '" + LINEA + "' OR N1_UBOLPO2 = '" + LINEA+"')"

	//" AND TRIM(N1_DTCLASS) <> '' AND (TRIM(N1_UBOLPO1)='' OR TRIM(N1_UBOLPO2)='')"

	MarkBrow(cAlias,aCpos[1],,aCampos,.F., GetMark(,"SN1","N1_OK"),,,,,,,cExprFilTop,,,)

	// MarkBrow(cAlias,campoMarca,CONDICION CAMPOS NO SELCCIONABLES,aCampos,.F., GET ESTADO DE MARCA)
	//"N1_DTCLASS != STOD('//').and.(empty(N1_UBOLPO1).or.empty(N1_UBOLPO2))"

	//else
	//alert("Solo se puede desasociar activos de Linea de credito y estas no deben tener movmientos")
	//endif

Return

//------------------------------------------------------------------------------------------------

user FUNCTION Elimbol()

	Local cMarca  := ThisMark()
	Local nX	  := 0
	Local lInvert := ThisInv()
	Local aErr := {}
	Local aAFtoLC := {}
	Local nSumVal := VALOR
	Local nLinCred := VLRLIN
	//Local bCondic := { | |  SN1->N1_UBOLPO1 = SA6->A6_NUMCON .OR. SN1->N1_UBOLPO2 = SA6->A6_NUMCON }

	DbSelectArea("SN1")
	DbGoTop()

	//DbSetFilter(bCondic)

	aRecLC := {}

	While SN1->(!EOF())

		// ESTE ES EL ALGORITMO DE VALIDACION DE MARCA
		// PARA CUALQUIER TABLA OJO!!
		// POR COMO FUNCIONA LA MARCA Y DESMARCA QUE VA ASIGNANDO
		// UN VALOR DE MARCA O DEJANDO BLANCO AL INVERTIR

		If SN1->N1_OK == cMarca .AND. !lInvert
			AADD(aRecLC,SN1->(Recno()))
			nSumVal+= SN1->N1_UVLHIPO
		ElseIf SN1->N1_OK != cMarca .AND. lInvert
			AADD(aRecLC,SN1->(Recno()))
			nSumVal-= SN1->N1_UVLHIPO
		Endif

		SN1->(dbSkip())
	End

	//alert(cValToChar(nSumVal)+"/"+cValToChar(nLinCred))
	//if nSumVal > nLinCred .and.
	//if MsgYesNo( "La suma de valores comerciales elegida excede valor de linea de crédito (Suma Valores Comerciales/Valor linea de Crédito) (" + cValToChar(nSumVal)+"/"+cValToChar(nLinCred)+"), desea continuar?" )

	If Len(aRecLC) > 0 .AND. MsgYesNo( "Desea retirar de boletas/polizas, los :" + cValToChar(Len(aRecLC)) + " Activos selecionados, "+cEOL+" por valor de: " + cValToChar(nSumVal) + "Bolivianos ? ")
		cContrato := PADR(' ',12)
		For nX := 1 to Len(aRecLC)

			Define MsDialog oDlgAF Title "Ingrese Documento de liberación" From 0,0 To 280, 500 Of oMainWnd Pixel OF oDlgAF PIXEL
			@ 0100, 010 SAY "No.Doc.Lib" SIZE 040, 10 OF oDlgAF COLORS 0, 16777215 PIXEL

			@ 0100, 100 MSGET cDocumento VAR cContrato OF oDlgAF SIZE 100, 11 COLORS 0, 16777215 PIXEL VALID !VAZIO()

			DEFINE SBUTTON FROM 122,40 TYPE 1 ACTION oDlgAF:End() ENABLE OF oDlgAF
			Activate MSDialog oDlgAF Centered

			SN1->(DbGoto(aRecLC[nX]))
			RecLock("SN1",.F.)
			//dbDelete()
			if !empty(SN1->N1_UBOLPO1) .and. SN1->N1_UBOLPO1 = LINEA  // Verificar que l LINEA NO TENGA MOVIMIENTO
				SN1->N1_UBOLPO1 := ""
				SN1->N1_VLRPOL1 := 0
				SN1->N1_UDOCCON := cContrato
				AADD(aAFtoLC,{SN1->N1_CBASE,"BOLETA1", cValtoChar(SN1->N1_UVLHIPO),dtos(DDATABASE),SN1->N1_DESCRIC,SN1->N1_GRUPO})
			elseif !empty(SN1->N1_UBOLPO2) .and. SN1->N1_UBOLPO2 = LINEA// Verificar que l LINEA NO TENGA MOVIMIENTO
				SN1->N1_UBOLPO2 := ""
				SN1->N1_VLRPOL2 := 0
				SN1->N1_UDOCCON := cContrato
				AADD(aAFtoLC,{SN1->N1_CBASE,"BOLETA2", cValtoChar(SN1->N1_UVLHIPO),dtos(DDATABASE),SN1->N1_DESCRIC,SN1->N1_GRUPO})
			else
				AADD(aErr,{SN1->N1_CBASE,SN1->N1_UBOLPO1+":"+SN1->N1_UBOLPO2, cValtoChar(SN1->N1_UVLHIPO),SN1->N1_DESCRIC+" Linea con movimiento"})
			endif
			MsUnLock()

		Next nX

		IF Len(aAFtoLC) > 0

			cTexto := "CódigoAF | LineaAF | Valor | Fecha"+cEol
			// "1234567890123456789012345678901234567890
			// "CCCCCC | LL | NNNNNNNNNNNNNNNNNNNN +cEol
			For nX := 1 to Len(aAFtoLC)
				ResGar(val(aAFtoLC[nX][3]),aAFtoLC[nX][6])
				cTexto += aAFtoLC[nX][1]+Space(1)+ "|" + aAFtoLC[nX][2]+Space(1)+ "|"+Space(2) + " -" + aAFtoLC[nX][3]+Space(3)+"|"
				cTexto += Space(1)+SUBSTRING(aAFtoLC[nX][5],1,20)+Space(1)
				cTexto += cEOL
			Next nX
			MSGINFO( "Retirados con exito", "AVISO" )
			DEFINE MSDIALOG oDlg TITLE "Activos Desasociados" From 000,000 TO 350,400	PIXEL
			@ 005,005 GET oMemo VAR cTexto MEMO SIZE 150,150 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			DEFINE SBUTTON FROM 005,165 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
			ACTIVATE MSDIALOG oDlg CENTER
			LimpaMarca()
			oDlg:End
			return
		Endif

		IF Len(aErr) > 0
			alert("Items no procesados")
			cTexto := "CódigoAF | LineasAF          | Valor   | Observacion                            "+cEol
			//        "12345678901234567890123456789012345678901234567890012345678901234567890123456789
			// "CCCCCC | LL | NNNNNNNNNNNNNNNNNNNN +cEol
			For nX := 1 to Len(aErr)
				cTexto += aErr[nX][1]+Space(1)+ "|" + aErr[nX][2]+Space(1)+ "|"+Space(2) + " -" +  aErr[nX][3]+Space(3)+"|"
				cTexto += Space(1)+SUBSTRING(aErr[nX][4],1,40)+Space(1)
				cTexto += cEOL
			Next nX

			DEFINE MSDIALOG oDlg1 TITLE "Activos No Procesados" From 000,000 TO 350,400	PIXEL
			@ 005,005 GET oMemo VAR cTexto MEMO SIZE 150,150 OF oDlg1 PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			DEFINE SBUTTON FROM 005,165 TYPE 1 ACTION oDlg1:End() ENABLE OF oDlg1 PIXEL
			ACTIVATE MSDIALOG oDlg1 CENTER
			LimpaMarca()
			oDlg1:End
		Endif

		//Endif
	Endif
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

static function ResGar(nValact,cGrupo)

	cGaspdf = substr(cGrupo,4,4)
	cGrupo = substr(cGrupo,1,1)

	DO CASE

		CASE cGrupo = '1'
		Reclock("ZEH",.F.)
		ZEH_USINMU = ZEH->ZEH_USINMU - nValact  //Inmuebles
		MsUnlock()
		CASE cGrupo = '2'
		Reclock("ZEH",.F.)
		ZEH_USIMMU = ZEH->ZEH_USIMMU - nValact  //Inmuebles
		MsUnlock()
		CASE cGrupo = '4'
		Reclock("ZEH",.F.)
		ZEH_USMYV = ZEH->ZEH_USMYV - nValact  //Maquinaria y equipo
		MsUnlock()
		CASE cGrupo = '6'
		Reclock("ZEH",.F.)
		ZEH_USVEI = ZEH->ZEH_USVEI - nValact  //vehiculos
		MsUnlock()
		CASE cGrupo = '9' .and. cGaspdf = '7' //DPFs
		Reclock("ZEH",.F.)
		ZEH_UMNPIG = ZEH->ZEH_UMNPIG - nValact
		CASE cGrupo = '9' .and. cGaspdf = '8' //DPFs
		Reclock("ZEH",.F.)
		ZEH_USDPF = ZEH->ZEH_USDPF - nValact
		CASE cGrupo = '9' .and. cGaspdf = '9' //asfaltos
		Reclock("ZEH",.F.)
		ZEH_UASFALT = ZEH->ZEH_UASFAL - nValact
		MsUnlock()
		OTHERWISE
	ENDCASE

return
