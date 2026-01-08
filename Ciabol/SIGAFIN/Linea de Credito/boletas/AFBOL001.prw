#include "Protheus.ch"
//#define cGrupos = GETNEWPAR( MV_GRAFGAR, "('0001','9999')") //"('0001','9999')"

//Adicionando activos para la linea de credito

USER FUNCTION AFBOL001() //VALOR ACTUAL DE LINEA, VLRLIN LIMITE DE LA LINEA
	Local aCpos		    := {}
	Local aCampos		:= {}
	Local nI			:= 0
	Local cAlias		:= "SN1"
	Local cTexto := ""
	Local oMemo
	Private cEOL := CHR(10)+CHR(13)
	Private LINEA  := ZEH->ZEH_NUMERO
	Private VALOR  := 0.00                //VALOR EN ACTIVOS PARA LINEA
	Private VLRLIN := ZEH->ZEH_VALOR    //VALOR DE LA LINEA antes ZEH->ZEH_LIMCRED
	Private aRotina     := {}
	Private aRecLC 	:= {}
	Private cCadastro   := "Registro de Activos para boleta/poliza :"+LINEA
	Private aCores := {}
	Private oDlgAF

	//SetKey( K_ALT_F4, 		{ || MsgAlert( "Tecla 'Alt + F4' foi pressionada", "UniversoADVPL" ) } )

	if ZEH->ZEH_STATUS == 'A' .and. ZEH->ZEH_ULINEA == '2' //if ZEH->ZEH_ULINEA == '1' .and. ZEH->ZEH_BLOCKED == '2'

		/*aCores := { {"empty(N1_UBOLPO1).and.empty(N1_UBOLPO2)","BR_VERDE"} ,;
		{"((!empty(N1_UBOLPO1).and.empty(N1_UBOLPO2)).or.(!empty(N1_UBOLPO1).and.!empty(N1_UBOLPO2)) ","BR_LARANJA"} ,;
		{"!empty(N1_UBOLPO1).and.!empty(N1_UBOLPO2) ","BR_VERMELHO"}}
		*/

		aCores := { {"empty(N1_UBOLPO1).and.empty(N1_UBOLPO2) ","BR_VERDE"} ,;
		{"(!empty(N1_UBOLPO1).and.empty(N1_UBOLPO2) ","BR_AZUL"} ,;
		{"(empty(N1_UBOLPO1).and.!empty(N1_UBOLPO2) ","BR_LARANJA"} ,;
		{"!empty(N1_UBOLPO1).and.!empty(N1_UBOLPO2) ","BR_VERMELHO"}}

		AADD(aRotina,{"Añadir Activos Seleccionados","u_AddbolCr" ,0,1})
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
		//AADD(aCpos,"N1_UPRCONT"	)
		//AADD(aCpos,"N1_UPRES"	)

		AADD(aCpos,"N1_UDOCCON"	)
		AADD(aCpos,"N1_VLRCONT"	)

		AADD(aCpos,"N1_UBOLPO1"	)
		AADD(aCpos,"N1_VLRPOL1"	)
		AADD(aCpos,"N1_UBOLPO2"	)
		AADD(aCpos,"N1_VLRPOL2"	)
		AADD(aCpos,"N1_UVLHIPO"	)

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
		//cGrupos = GETNEWPAR( "MV_GRAFGAR","('0001','9999')")  //"('0001','9999')"

		cExprFilTop := " SUBSTRING(N1_GRUPO,1,1) IN " + cGrupos //+ " AND (TRIM(N1_UBOLPO1)='' OR TRIM(N1_UBOLPO2)='')"

		//" AND TRIM(N1_DTCLASS) <> '' AND (TRIM(N1_UBOLPO1)='' OR TRIM(N1_UBOLPO2)='')"
		//cExprFilTop := " ((N1_VLRPOL1+N1_VLRPOL2) < (round(N1_VLIHIPO,2))) OR (N1_VLRCONT < (round(N1_VLHIPO,2)))  AND (N1_VLRPOL1+N1_VLRPOL2+N1_VLRCONT <N1_VLHIPO) AND N1_GRUPO IN "+cGrupos //" AND TRIM(N1_DTCLASS) <> '' AND (TRIM(N1_UBOLPO1)='' OR TRIM(N1_UBOLPO2)='')"

		MarkBrow(cAlias,aCpos[1],,aCampos,.F., GetMark(,"SN1","N1_OK"),,,,,,,cExprFilTop,,,)
		// MarkBrow(cAlias,campoMarca,CONDICION CAMPOS NO SELCCIONABLES,aCampos,.F., GET ESTADO DE MARCA)
		//"N1_DTCLASS != STOD('//').and.(empty(N1_UBOLPO1).or.empty(N1_UBOLPO2))"
	else
		alert("Solo se puede asociar activos a boletas/polizas vigentes o sin linea de credito")
	endif

Return

//------------------------------------------------------------------------------------------------

user FUNCTION AddbolCr() //añade los activos a la linea de credito
	Local cMarca  := ThisMark()
	Local nX	  := 0
	Local lInvert := ThisInv()
	Local aErr := {}
	Local aAFtoLC := {}
	Local nSumVal := VALOR
	Local nLinCred := VLRLIN
	Local cSayTSal := ""
	Local nRadio   := 0
	Local oSayTSal, oRadio
	Private lCondic := .f.

	aRecLC:={}

	DbSelectArea("SN1")
	DbGoTop()
	While SN1->(!EOF())

		// ESTE ES EL ALGORITMO DE VALIDACION DE MARCA
		// PARA CUALQUIER TABLA OJO!!
		// POR COMO FUNCIONA LA MARCA Y DESMARCA QUE VA ASIGNANDO
		// UN VALOR DE MARCA O DEJANDO BLANCO AL INVERTIR

		cGrp = substr(SN1->N1_GRUPO,1,1)

		DO CASE
			CASE cGrp = '1'
			nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRHIP/100,2),2)  //Inmuebles
			CASE cGrp = '2'
			nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRHIP/100,2),2)  //Inmuebles
			CASE cGrp = '4'
			nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRMYV/100,2),2)  //Maquinaria y equipo
			CASE cGrp = '6'
			nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPOROP/100,2),2)  //vehiculos
			CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '7'  //PIGNORADO
			nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRMPI/100,2),2)
			CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '8'  //DPFs
			nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UHIPDP/100,2),2)
			CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '9'  //Y asfaltos
			nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UASFAL/100,2),2)
			OTHERWISE
			nValAtf := 0
		ENDCASE

		If SN1->N1_OK == cMarca .AND. !lInvert
			AADD(aRecLC,SN1->(Recno()))
			nSumVal+= nValAtf //SN1->N1_UVLHIPO
		ElseIf SN1->N1_OK != cMarca .AND. lInvert
			AADD(aRecLC,SN1->(Recno()))
			nSumVal-= nValAtf//SN1->N1_UVLHIPO
		Endif

		SN1->(dbSkip())
	End

	nValAtf := 0

	If Len(aRecLC) > 0 .AND. MsgYesNo( "Confirma asociar a la boleta/poliza, los Activos selecionados? ")
		cContrato := PADR(' ',12)
		For nX := 1 to Len(aRecLC)
			DbSelectArea("SN1")
			SN1->(DbGoto(aRecLC[nX]))
			cGrp = substr(SN1->N1_GRUPO,1,1)

			DO CASE
				CASE cGrp = '1'
				nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRHIP/100,2),2)  //Inmuebles
				CASE cGrp = '2'
				nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRHIP/100,2),2)  //Inmuebles
				CASE cGrp = '4'
				nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRMYV/100,2),2)  //Maquinaria y equipo
				CASE cGrp = '6'
				nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPOROP/100,2),2)  //vehiculos
				CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '7'  //DPFs
				nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRMPI/100,2),2)
				CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '8'  //DPFs
				nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UHIPDP/100,2),2)
				CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '9'  //Y asfaltos
				nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UASFAL/100,2),2)
				OTHERWISE
				nValAtf := 0
			ENDCASE

			nPorcentaje := 100 //SN1->N1_UPRPRES
			nRadio = 1
			Define MsDialog oDlgAF Title "Ingrese Valor de activo: "+SN1->N1_CBASE+" para poliza/boleta: " + LINEA From 0,0 To 280, 500 Of oMainWnd Pixel OF oDlgAF PIXEL

			@ 010, 010 SAY "No.Documento" SIZE 041, 010 OF oDlgAF COLORS 0, 16777215 PIXEL

			@ 010, 100 MSGET cDocumento VAR cContrato OF oDlgAF SIZE 100, 11 COLORS 0, 16777215 PIXEL VALID !VAZIO()

			@ 030,10 Say "Valor comercial del activo: "+ALLTRIM(SN1->N1_DESCRIC)+" : " +cValtochar(SN1->N1_VLCOMER) Pixel Of oDlgAF
			@ 050,10 Say "Tipo de garantía:" Pixel Of oDlgAF

			@ 050,100 Radio oRadio Var nRadio Items "Prestamo","Informado Prestamo" Size 70,9 On Change TRadio(nRadio, oSayTSal,@oValAtf,@nValAtf) Pixel Of oDlgAF
			@ 050,180 Say oSayTSal Var cSayTSal Size 50,10 Pixel Of oDlgAF

			@ 080,10 Say "Valor garantía Activo :" Pixel Of oDlgAF
			@ 080,100 MSGET oValAtf var nValAtf SIZE 55,11 OF oDlgAF PIXEL PICTURE X3Picture( "N1_VLCOMER" ) VALID !VAZIO().and.POSITIVO() when lCondic

			DEFINE SBUTTON FROM 122,40 TYPE 1 ACTION oDlgAF:End() ENABLE OF oDlgAF
			Activate MSDialog oDlgAF Centered

			RecLock("SN1",.F.)

			if empty(SN1->N1_UBOLPO1).and.(nRadio == 1.or.nRadio == 2)
				SN1->N1_UBOLPO1 := LINEA
				SN1->N1_VLRPOL1 := nValAtf  // SN1->N1_UVLHIPO == valorcomercial* porcentaje(bco x tipo bien)
				SN1->N1_UDOCCON := cContrato
				SN1->N1_UVLHIPO := nValAtf
				AADD(aAFtoLC,{SN1->N1_CBASE,"Boleta1",cValtoChar(nValAtf),dtos(DDATABASE),SN1->N1_DESCRIC,SN1->N1_GRUPO})
			elseif empty(SN1->N1_UBOLPO2).and.(nRadio == 1.or.nRadio == 2)
				SN1->N1_UBOLPO2 := LINEA
				SN1->N1_VLRPOL2 := nValAtf  // SN1->N1_UVLHIPO == valorcomercial* porcentaje(bco x tipo bien)
				SN1->N1_UDOCCON := cContrato
				SN1->N1_UVLHIPO := nValAtf
				AADD(aAFtoLC,{SN1->N1_CBASE,"Boleta2",cValtoChar(nValAtf),dtos(DDATABASE),SN1->N1_DESCRIC,SN1->N1_GRUPO})
			else
				AADD(aErr,{SN1->N1_CBASE,SN1->N1_UBOLPO1+":"+SN1->N1_UBOLPO2,cValtoChar(SN1->N1_VLRCONT),SN1->N1_DESCRIC,SN1->N1_GRUPO})
			endif
			MsUnLock()
		Next nX
		LimpaMarca()

		IF Len(aAFtoLC) > 0

			cTexto := "CódigoAF | LineaAF | Valor | Fecha"+cEol
			// "1234567890123456789012345678901234567890
			// "CCCCCC | LL | NNNNNNNNNNNNNNNNNNNN +cEol
			For nX := 1 to Len(aAFtoLC)
				AddGar(val(aAFtoLC[nX][3]),alltrim(aAFtoLC[nX][6]))
				cTexto += aAFtoLC[nX][1]+Space(1)+ "|" + aAFtoLC[nX][2]+Space(1)+ "|"+Space(2) + aAFtoLC[nX][3]+Space(3)+"|"
				cTexto += Space(1)+SUBSTRING(aAFtoLC[nX][5],1,20)+Space(1)
				cTexto += cEOL
			Next nX
			MSGINFO( "Actualizados con exito", "AVISO" )
			DEFINE MSDIALOG oDlg0 TITLE "Activos Selecionados" From 000,000 TO 350,400	PIXEL
			@ 005,005 GET oMemo VAR cTexto MEMO SIZE 150,350 OF oDlg0 PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			DEFINE SBUTTON FROM 005,165 TYPE 1 ACTION oDlg0:End() ENABLE OF oDlg0 PIXEL
			ACTIVATE MSDIALOG oDlg0 CENTER
			LimpaMarca()
			oDlg0:End
			return
		Endif

		IF Len(aErr) > 0
			alert("Items no procesados")
			cTexto := "CódigoAF | LineasAF          | Valor   | Observacion                            "+cEol
			//        "12345678901234567890123456789012345678901234567890012345678901234567890123456789
			// "CCCCCC | LL | NNNNNNNNNNNNNNNNNNNN +cEol
			For nX := 1 to Len(aErr)
				cTexto += aErr[nX][1]+Space(1)+ "|" + aErr[nX][2]+Space(1)+ "|"+Space(2) + aErr[nX][3]+Space(3)+"|"
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

	Endif

Return

STATIC FUNCTION LEGAFLC()

	Brwlegenda(cCadastro,"Valores",{ {"BR_VERMELHO","Usado en dos Lineas de crédito"} ,;
	{"BR_LARANJA","Usado en segunda linea"},;
	{"BR_AZUL","Usado en primera linea"},;
	{"BR_VERDE","Disponible 100%"}})
RETURN

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

static Function TRadio(nRadio, oSayTSal,oValAtf,nValAtf)
	Local nPorcentaje
	DO CASE
		CASE cGrp = '1'
		nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRHIP/100,2),2)  //Inmuebles
		nPorcentaje := round(ZEH->ZEH_UPRHIP/100,2)
		CASE cGrp = '2'
		nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRHIP/100,2),2)  //Inmuebles
		nPorcentaje:=round(ZEH->ZEH_UPRHIP/100,2)
		CASE cGrp = '4'
		nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRMYV/100,2),2)  //Maquinaria y equipo
		nPorcentaje := round(ZEH->ZEH_UPRMYV/100,2)
		CASE cGrp = '6'
		nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPOROP/100,2),2)  //vehiculos
		nPorcentaje := round(ZEH->ZEH_UPOROP/100,2)
		CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '8'  //DPFs
		nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UPRMPI/100,2),2)
		nPorcentaje := round(ZEH->ZEH_UPRMPI/100,2)
		CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '8'  //DPFs
		nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UHIPDP/100,2),2)
		nPorcentaje := round(ZEH->ZEH_UHIPDP/100,2)
		CASE cGrp = '9' .and. substr(SN1->N1_GRUPO,4,4) = '9'  //ASFALTOS
		nValAtf := round(SN1->N1_VLCOMER * round(ZEH->ZEH_UASFAL/100,2),2)
		nPorcentaje := round(ZEH->ZEH_UASFAL/100,2)
		OTHERWISE
		nValAtf := 0
		nPorcentaje := 1
	ENDCASE

	If nRadio == 1
		//nPorcentaje := 100
		oSayTSal:SetText("Prestamo % :" + cValtochar(nPorcentaje))
		nValAtf := round(SN1->N1_VLCOMER*nPorcentaje,2)
		lCondic = .f.
	Else
		nValAtf := SN1->N1_VLCOMER
		lCondic = .t.
	EndIf

	oValAtf:Setfocus()
	oDlgAF:Refresh()
Return

static function AddGar(nValact,cGrupo)

	cGaspdf = substr(cGrupo,4,4)
	cGrupo = substr(cGrupo,1,1)

	DO CASE

		CASE cGrupo = '1'
		Reclock("ZEH",.F.)
		ZEH_USINMU +=nValact  //Inmuebles
		MsUnlock()
		CASE cGrupo = '2'
		Reclock("ZEH",.F.)
		ZEH_USIMMU +=nValact  //Inmuebles
		MsUnlock()
		CASE cGrupo = '4'
		Reclock("ZEH",.F.)
		ZEH_USMYV +=nValact  //Maquinaria y equipo
		MsUnlock()
		CASE cGrupo = '6'
		Reclock("ZEH",.F.)
		ZEH_USVEI +=nValact  //vehiculos
		MsUnlock()
		CASE cGrupo = '9' .and. cGaspdf = '7' //DPFs
		Reclock("ZEH",.F.)
		ZEH_UMNPIG +=nValact
		CASE cGrupo = '9' .and. cGaspdf = '8' //DPFs
		Reclock("ZEH",.F.)
		ZEH_USDPF +=nValact
		CASE cGrupo = '9' .and. cGaspdf = '9' //asfaltos
		Reclock("ZEH",.F.)
		ZEH_UASFAL +=nValact
		MsUnlock()
		OTHERWISE
	ENDCASE

return
