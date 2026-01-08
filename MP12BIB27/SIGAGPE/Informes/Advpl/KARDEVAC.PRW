#Include 'Protheus.ch'

#Define VACCODFOL	'0072' //CODFOL del concepto de Vacaciones

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ KARDEVAC ³ Autor ³ Yamyl Saavedra        ³ Data ³ 25.03.12 ³±±
±±³                     ³ Modificado ³ Denar Terrazas   ³ Data ³ 02.04.20 ³±±
±±³                     ³ Modificado ³ Omar Delgadillo  ³ Data ³ 15.07.21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripcion Impresion de Kardex Vacaciones                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TdeP													      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function kardevac()
	Public _PAR01

	KarPerg()
	cPerg:="KAV580"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variables utilizadas para parametros                         ³
	//³ mv_par01             // Matricula de Empleados               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cString  := "SRA"
	titulo   := PADC("Kardex Vacaciones" ,74)
	cDesc1   := PADC("Sera solicitado la matricula para la emision del ",74)
	cDesc2   := PADC("kardex",74)
	cDesc3   := ""
	aReturn  := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci¢n"), 1, 2, 1,"",1 }
	NomeProg := "KARDEVAC"
	nLin	 := 0

	PERGUNTE(cPerg,.F.)
	wnrel:=SetPrint(cString,NomeProg,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"M")

	If nLastKey!=27
		SetDefault(aReturn,cString)
		If nLastKey!=27
			VerImp()
			RptStatus({|| RptKardeV()})
		endif
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPTKARDEV ºAutor  ³    ºFecha ³  25/03/13					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao del remito transferencias                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INESCO								                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RptKardeV()
	Local cCidade	:= space(10)
	Local nTotAbo	:= 0
	Local nTotGoz	:= 0
	Local nTotRet	:= 0
	Local nRet		:= 0
	Local nGoz		:= 0
	Local cPDVac	:= GetAdvFVal("SRV","RV_COD",xFilial("SRV")+VACCODFOL,2,"")
	Local cTipoAfa	:= GetAdvFVal("RCM","RCM_TIPO",xFilial("RCM")+cPDVac,3,"")
	Local cPeriodo	:= ""
	Local nAux 		:= 0

	//Filtra do SRA: filial, matricula
	cAlias  := "SRA"
	cQrySRA := "QSRA"

	//montagem da query
	cQuery := "SELECT "
	cQuery += "RA_FILIAL, RA_MAT, RA_NOME, RA_ADMISSA, RA_CODFUNC, RA_DEPTO, RA_CC, RA_PROCES"
	cQuery += " FROM " + RetSqlName(cAlias)
	cQuery += " WHERE "
	cQuery += " RA_MAT = '" + mv_par01 + "'"
	cQuery += "  AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY RA_FILIAL, RA_MAT"

	cQuery := ChangeQuery(cQuery)
	aStruct := (cAlias)->(dbStruct())

	If  MsOpenDbf(.T.,"TOPCONN",TcGenQry(, ,cQuery),cQrySRA,.T.,.T.)
		For nAux := 1 To Len(aStruct)
			If ( aStruct[nAux][2] <> "C" )
				TcSetField(cQrySRA,aStruct[nAux][1],aStruct[nAux][2],aStruct[nAux][3],aStruct[nAux][4])
			EndIf
		Next nAux
	Endif

	dbSelectArea(cQrySRA)
	(cQrySRA)->(dbGoTop())

	//dbselectarea("SRA")
	//dbsetorder(1)		// RA_FILIAL+RA_MAT
	//dbgotop()
	//SRA->(dbseek(xfilial("SRA")+mv_par01))

	dbselectarea("SRF")
	dbsetorder(1)		// RF_FILIAL+RJ_FUNCAO
	dbgotop()
	SRF->(dbseek(xFILIAL("SRF")+(cQrySRA)->RA_MAT))

	dbselectarea("SR8")
	dbsetorder(1)		// R8_FILIAL+R8_MAT+DTOS(R8_DATAINI)+R8_TIPO
	dbgotop()
	SR8->(dbseek(xfilial("SR8")+(cQrySRA)->RA_MAT))

	dbselectarea("SRJ")
	dbsetorder(1)		// RJ_FILIAL+RJ_FUNCAO
	dbgotop()
	SRJ->(dbseek(xfilial("SRJ")+(cQrySRA)->RA_CODFUNC))

	dbselectarea("SQB")
	dbsetorder(1)		// QB_FILIAL+QB_DEPTO
	dbgotop()
	SQB->(dbseek(xfilial("SQB")+(cQrySRA)->RA_DEPTO))

	dbselectarea("CTT")
	dbsetorder(1)		// CTT_FILIAL+CTT_CUSTO
	dbgotop()
	CTT->(dbseek(xfilial("CTT")+(cQrySRA)->RA_CC))

	// ciudad a imprimir en el formulario
	cCidade := FWFilName(FWCodEmp(), (cQrySRA)->RA_FILIAL)

	(cQrySRA)->( setRegua(LastRec()) )

	while (cQrySRA)->( !eof() )
		IF (cQrySRA)->RA_MAT==mv_par01
			cPeriodo:= getPeriodo((cQrySRA)->RA_PROCES)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			@ 00, 00 PSAY AvalImp(132)

			nLin := 1
			@ nLin,050 PSAY "K A R D E X  -  V A C I O N E S"
			nLin++
			@ nLin,035 PSAY "============================================================="
			nLin++
			@ nLin,005 PSAY "CODIGO EMPLEADO : "+ (cQrySRA)->RA_MAT
			nLin++
			@ nLin,005 PSAY "NOMBRE          : "+ Alltrim((cQrySRA)->RA_NOME)
			nLin++
			@ nLin,005 PSAY "FECHA INGRESO   : "+ DtoC((cQrySRA)->RA_ADMISSA)
			nLin++
			@ nLin,005 PSAY "CARGO           : "+ Alltrim(SRJ->RJ_DESC)
			nLin++
			@ nLin,005 PSAY "DEPARTAMENTO    : "+ Alltrim(SQB->QB_DESCRIC)
			nLin++
			@ nLin,005 PSAY "CENTRO DE COSTOS: "+ Alltrim(CTT->CTT_DESC01)
			nLin++
			@ nLin,005 PSAY replicate("-",115)
			nLin++
			@ nLin,005 PSAY replicate(" ",70) + "ABONOS      UTILIZADOS      REGISTRO"
			nLin++
			@ nLin,005 PSAY replicate(" ",82) + "COMPUTADOS      RETROACTIVO"
			nLin++
			@ nLin,005 PSAY replicate("-",115)
			nLin++
			@ nLin,015 PSAY "Abono dias Correspondientes a la gestion: "

			while SRF->RF_MAT==(cQrySRA)->RA_MAT .and. SRF->(!eof())
				@ nLin,060 PSAY Substr(DtoC(SRF->RF_DATABAS),7,4)+"-"+Substr(DtoC(SRF->RF_DATAFIM),7,4)+"       "+Transform(SRF->RF_DFERVAT+SRF->RF_DFERAAT, "999.99")
				nTotAbo += SRF->RF_DFERVAT+SRF->RF_DFERAAT
				nLin++
				SRF->(dbskip())
			enddo

			if SR8->(!eof())
				@ nLin,005 PSAY "                              Gozados "
				nLin++
			endif

			while SR8->R8_MAT==(cQrySRA)->RA_MAT .and. SR8->(!eof())
				If(SR8->R8_TIPOAFA == cTipoAfa)
					//If( (SR8->R8_PER == cPeriodo .AND. ALLTRIM(SR8->R8_STATUS) == '') .OR. (SR8->R8_PER <> cPeriodo .AND. ALLTRIM(SR8->R8_STATUS) <> '') )
						If ALLTRIM(SR8->R8_STATUS) == 'T' .AND. SR8->R8_DPAGAR == SR8->R8_DPAGOS	// RETROACTIVO TOTAL
							nRet := SR8->R8_DPAGOS
							nGoz := SR8->R8_DPAGAR - nRet
						elseif ALLTRIM(SR8->R8_STATUS) == 'T' .AND. SR8->R8_DPAGAR <> SR8->R8_DPAGOS	// RETROACTIVO PARCIAL		
							nRet := SR8->R8_DPAGAR - SR8->R8_DPAGOS
							nGoz := SR8->R8_DPAGAR - nRet
						elseif ALLTRIM(SR8->R8_STATUS) == ''	// PERIODO ABIERTO
							nRet := 0
							nGoz := SR8->R8_SDPAGAR
						elseif ALLTRIM(SR8->R8_STATUS) == 'C'	// PERIODO CALCULADO
							nRet := 0
							nGoz := SR8->R8_DPAGOS
						endIf												

						nTotRet += nRet
						nTotGoz += nGoz
						If( ALLTRIM(SR8->R8_STATUS) == 'T')							
							//@ nLin,042 PSAY "De:"+DtoC(SR8->R8_DATAINI)+"  Hasta:"+DtoC(SR8->R8_DATAFIM) + space(30) + Transform(nRet, "999.99")
							@ nLin,042 PSAY "De:"+DtoC(SR8->R8_DATAINI)+"  Hasta:"+DtoC(SR8->R8_DATAFIM) + space(15) + Transform(nGoz, "999.99") + space(9) + Transform(nRet, "999.99")							
						Else
							@ nLin,042 PSAY "De:"+DtoC(SR8->R8_DATAINI)+"  Hasta:"+DtoC(SR8->R8_DATAFIM) + space(15) + Transform(nGoz, "999.99")
						ENDIF
						nLin++
					//EndIf
				EndIf
				SR8->(dbskip())
			enddo
			nLin += 3
			@ nLin,005 psay CHR(15)+"TOTALES      :"+CHR(18)
			@ nLin,076 psay Transform(nTotAbo, "999.99")
			@ nLin,088 psay Transform(nTotGoz, "999.99")
			@ nLin,103 psay Transform(nTotRet, "999.99")
			nLin++
			@ nLin,005 psay replicate("-",115)
			nLin++
			@ nLin,005 psay "SALDO VACACIÓN:"
			@ nLin,088 psay Transform(nTotAbo-nTotGoz, "999.99")
			nLin++
			@ nLin,005 psay replicate("-",115)
			nLin+=2
			@ nLin,000 psay space(01)	// para "saltar" efetivamente e passar para a proxima pagina.
			setprc(0,0)
			incregua()
		ENDIF

		(cQrySRA)->( DBSKIP() )
	enddo
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Return

Static Function VerImp()
	nLin:= 0
	Set Device To Screen
	If aReturn[5]==2
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif
	//	MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ KarPerg  ³ Autor ³             ³ Data ³ 22/02/12           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam...     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 				                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function KarPerg()
	Local i := 0
	Local j := 0
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR("KAV580",10)
	aRegs := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Matricula de Empleados               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aAdd(aRegs,{cPerg,"01","Matricula ? ","¿Matricula ?","Matricula ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		endif
	Next
	dbSelectArea(_sAlias)
Return

/**
*
* @author: Denar Terrazas Parada
* @since: 18/06/2020
* @description: Funcion que devuelve el periodo vigente del procedimiento FOL
* @parameter: cProceso -> Proceso al que pertenece el funcionario RA_PROCES
* @return: cRet -> Periodo vigente del procedimiento FOL
*/
static function getPeriodo(cProceso)
	Local aArea			:= getArea()
	Local OrdenConsul	:= GetNextAlias()
	Local cRet			:= ""
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT TOP 1 RCH_PER
		FROM %table:RCH% RCH
		WHERE RCH_FILIAL = %exp:xFilial('RCH')%
		AND RCH_PROCES = %exp:cProceso%
		AND RCH_ROTEIR = 'FOL'
		AND RCH_DTFECH = ''
		AND RCH.%notdel%
		ORDER BY RCH_PER

	EndSql

	DbSelectArea(OrdenConsul)
	(OrdenConsul)->(DbGoTop())
	If (OrdenConsul)->(!Eof())
		cRet:= (OrdenConsul)->RCH_PER
	endIf
	(OrdenConsul)->(DbCloseArea())
	restArea(aArea)
return cRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg, "01", "Filial De ?" , "¿De Sucursal ?", "Branch From ?", "MV_CH1","C",04,0,0,"G","","SM0","033","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "02", "Filial Ate ?" , "¿A Sucursal ?", "Branch to ?", "MV_CH2","C",04,0,0,"G","naovazio()","SM0","033","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "03", "Matricula De ?" , "¿De matricula ?", "Registration From ?", "MV_CH3","C",06,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "04", "Matricula Ate ?" , "¿A matricula ?", "Registration To ?", "MV_CH4","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
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
