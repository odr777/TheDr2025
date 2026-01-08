//Bibliotecas
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³copysx1   ºAutor  ³COPIA DE PREGUNTA   º Data ³  10/05/2023 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function copysx1()
	Local aArea        := GetArea()
	Local aAreaX1        := SX1->(GetArea())
	Local aX1Estr        := SX1->(DbStruct())
	Local aAreaAux
	Local nColuna        := 0
	Local aConteu        := {}
	PRIVATE cPerg   := "UXCOPSX1"   // elija el Nombre de la pregunta
	Default cPergAnt    := ""
	Default cPergNov    := ""
	Default lExcNov    := .T.

	CriaSX1(cPerg)

	Pergunte(cPerg,.T.)

	cPergAnt := MV_PAR01
	cPergNov := MV_PAR02
	lExcNov := IIF(MV_PAR03 == 1, .T.,.F.)

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	SX1->(DbGoTop())

	//Se a pergunta antiga ou a nova estiverem em branco, mostra mensagem de erro
	If Empty(cPergAnt) .Or. Empty(cPergNov)
		MsgStop("Pergunta antiga e/ou nova estão em branco!", "Atenção")

		//Senão, se as perguntas forem iguais, mostra erro
	ElseIf Alltrim(cPergAnt) == Alltrim(cPergNov)
		MsgStop("Pergunta antiga é igual à nova!", "Atenção")

		//Senão, define que as perguntas terão um tamanho de 10 de caracteres, pega a estrutura da SX1 e efetua a cópia
	Else
		cPergAnt := PadR(cPergAnt, Len(SX1->X1_GRUPO))
		cPergNov := PadR(cPergNov, Len(SX1->X1_GRUPO))

		//Se o grupo de perguntas não existir, mostra mensagem de erro
		If !SX1->(DbSeek(cPergAnt))
			MsgStop("Pergunta antiga não existe! Logo, não pode ser copiada!", "Atenção")

			//Senão prossegue com a cópia
		Else
			aAreaAux := SX1->(GetArea())

			//Se for para excluir o grupo novo
			If lExcNov
				//Posiciona no grupo novo
				If SX1->(DbSeek(cPergNov))
					//Enquanto não for fim da tabela e tiver registros da pergunta nova
					While !SX1->(EoF()) .And. SX1->X1_GRUPO == cPergNov
						RecLock("SX1", .F.)
						DbDelete()
						SX1->(MsUnlock())

						SX1->(DbSkip())
					EndDo
				EndIf
			EndIf

			RestArea(aAreaAux)
			//Enquanto não for o fim da tabela e tiver registros na pergunta antiga
			While !SX1->(EoF()) .And. SX1->X1_GRUPO == cPergAnt
				aAreaAux := SX1->(GetArea())
				aConteu := {}

				//Primeiro é armazenado tudo em um array, para não divergir os ponteiros de registros
				For nColuna := 1 To Len(aX1Estr)
					//Se a coluna for a X1_GRUPO, define o nome da pergunta nova
					If Alltrim(aX1Estr[nColuna][1]) == "X1_GRUPO"
						aAdd(aConteu, cPergNov)
						//Senão, efetua a cópia da coluna
					Else
						aAdd(aConteu, &("SX1->"+aX1Estr[nColuna][1]))
					EndIf
				Next

				//Gravando os dados na tabela nova, conforme estrutura da SX1
				RecLock("SX1", .T.)
				For nColuna := 1 To Len(aX1Estr)
					&(aX1Estr[nColuna][1]) := aConteu[nColuna]
				Next
				SX1->(MsUnlock())

				//Restaurando a área da pergunta antiga
				RestArea(aAreaAux)
				SX1->(DbSkip())
			EndDo
		EndIf
	EndIf

	RestArea(aAreaX1)
	RestArea(aArea)
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSX1(cPerg,"01","¿Pregunta anterior?"	, "¿Pregunta anterior?"	,"¿Pregunta anterior?"	,"MV_CH1","C",10,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿Pregunta nueva?" 	, "¿Pregunta nueva?"	,"¿Pregunta nueva?"	,"MV_CH2","C",10,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","Borra nueva y copia?     ","Borra nueva y copia?     ","Borra nueva y copia?     ","MV_CH3","N",01,0,0,"C","","","","","MV_PAR03","SI","SI","SI","","NO","NO","NO")
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
