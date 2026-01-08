#Include "PROTHEUS.CH"
#Include "ADMXFUN.CH"

USER Function ADMGETFIL(lTodasFil,lSohFilEmp,cAlias,lSohFilUn,lHlp, lExibTela)

	Local cEmpresa 	:= cEmpAnt
	Local cTitulo	:= ""
	Local MvPar		:= ""
	Local MvParDef	:= ""
	Local nI 		:= 0
	Local aArea 	:= GetArea() 					 // Salva Alias Anterior
	Local nReg	    := 0
	Local nSit		:= 0
	Local aSit		:= {}
	Local aSit_Ant	:= {}
	Local aFil 		:= {}
	Local nTamFil	:= Len(xFilial("CT2"))
	Local lDefTop 	:= IIF( FindFunction("IfDefTopCTB"), IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
	Local nInc		:= 0
	Local aSM0		:= AdmAbreSM0()
	Local aFilAtu	:= {}
	Local lPEGetFil := ExistBlock("CTGETFIL")
	Local lPESetFil := ExistBlock("CTSETFIL")
	Local aFil_Ant
	Local lGestao	:= AdmGetGest()
	Local lFWCompany := FindFunction( "FWCompany" )
	Local cEmpFil 	:= " "
	Local cUnFil	:= " "
	Local nTamEmp	:= 0
	Local nTamUn	:= 0
	Local lOk		:= .T.
	Local nCount    := 0

	Default lTodasFil 	:= .F.
	Default lSohFilEmp 	:= .F.	//Somente filiais da empresa corrente (Gestao Corporativa)
	Default lSohFilUn 	:= .F.	//Somente filiais da unidade de negocio corrente (Gestao Corporativa)
	Default lHlp		:= .T.
	Default cAlias		:= ""
	Default lExibTela	:= .T.

	/*
	Defines do SM0
	SM0_GRPEMP  // C�digo do grupo de empresas
	SM0_CODFIL  // C�digo da filial contendo todos os n�veis (Emp/UN/Fil)
	SM0_EMPRESA // C�digo da empresa
	SM0_UNIDNEG // C�digo da unidade de neg�cio
	SM0_FILIAL  // C�digo da filial
	SM0_NOME    // Nome da filial
	SM0_NOMRED  // Nome reduzido da filial
	SM0_SIZEFIL // Tamanho do campo filial
	SM0_LEIAUTE // Leiaute do grupo de empresas
	SM0_EMPOK   // Empresa autorizada
	SM0_GRPEMP  // C�digo do grupo de empresas
	SM0_USEROK  // Usu�rio tem permiss�o para usar a empresa/filial
	SM0_RECNO   // Recno da filial no SIGAMAT
	SM0_LEIAEMP // Leiaute da empresa (EE)
	SM0_LEIAUN  // Leiaute da unidade de neg�cio (UU)
	SM0_LEIAFIL // Leiaute da filial (FFFF)
	SM0_STATUS  // Status da filial (0=Liberada para manuten��o,1=Bloqueada para manuten��o)
	SM0_NOMECOM // Nome Comercial
	SM0_CGC     // CGC
	SM0_DESCEMP // Descricao da Empresa
	SM0_DESCUN  // Descricao da Unidade
	SM0_DESCGRP // Descricao do Grupo
	*/

	//Caso o Alias n�o seja passado, traz as filiais que o usuario tem acesso (modo padrao)
	lSohFilEmp := IF(Empty(cAlias),.F.,lSohFilEmp)
	lSohFilUN  := IF(Empty(cAlias),.F.,lSohFilUn) .And. lSohFilEmp

	//Caso use gest�o corporativa , busca o codigo da empresa dentro do M0_CODFIL
	//Em caso contrario, , traz as filiais que o usuario tem acesso (modo padrao)
	cEmpFil := IIF(lGestao .and. lFwCompany, FWCompany(cAlias)," ")
	cUnFil  := IIF(lGestao .and. lFwCompany, FWUnitBusiness(cAlias)," ")

	//Tamanho do codigo da filial
	nTamEmp := Len(cEmpFil)
	nTamUn  := Len(cUnFil)

	If lDefTop
		If !IsBlind()
			PswOrder(1)
			If PswSeek( __cUserID, .T. )

				aSit		:= {}
				aFilNome	:= {}
				aFilAtu		:= FWArrFilAtu( cEmpresa, cFilAnt )
				If Len( aFilAtu ) > 0
					cTxtAux := IIF(lGestao,STR0047,STR0048)//"Empresa/Unidade/Filial de "##"Filiais de "
					cTitulo := cTxtAux + AllTrim( aFilAtu[6] )
				EndIf

				// Adiciona as filiais que o usuario tem permiss�o
				For nInc := 1 To Len( aSM0 )
					//DEFINES da SMO encontra-se no arquivo FWCommand.CH
					//Na fun��o FWLoadSM0(), ela retorna na posicao [SM0_USEROK] se esta filial � v�lida para o user
					If (aSM0[nInc][SM0_GRPEMP] == cEmpAnt .And. ((ValType(aSM0[nInc][SM0_EMPOK]) == "L" .And. aSM0[nInc][SM0_EMPOK]) .Or. ValType(aSM0[nInc][SM0_EMPOK]) <> "L") .And. aSM0[nInc][SM0_USEROK] )

						//Verificacao se as filiais a serem apresentadas serao
						//Apenas as filiais da empresa conrrente (M0_CODFIL)
						If lGestao .and. lFwCompany .and. lSohFilEmp
							//Se for exclusivo para empresa
							If !Empty(cEmpFil)
								lOk := IIf(cEmpFil == Substr(aSM0[nInc][2],1,nTamEmp),.T.,.F.)
								/*
								Verifica se as filiais devem pertencer a mesma unidade de negocio da filial corrente*/
								If lOk .And. lSohFilUn
									//Se for exclusivo para unidade de negocio
									If !Empty(cUnFil)
										lOk := IIf(cUnFil == Substr(aSM0[nInc][2],nTamEmp + 1,nTamUn),.T.,.F.)
									Endif
								Endif
							Else
								//Se for tudo compartilhado, traz apenas a filial corrente
								lOk := IIf(cFilAnt == aSM0[nInc][SM0_CODFIL],.T.,.F.)
							Endif
						Endif

						If lOk
							AAdd(aSit, {aSM0[nInc][SM0_CODFIL],aSM0[nInc][SM0_NOMRED],Transform(aSM0[nInc][SM0_CGC],PesqPict("SA1","A1_CGC"))})
							MvParDef += aSM0[nInc][SM0_CODFIL]
							nI++
						Endif

						//ponto de entrada para usuario poder manipular as filiais selecionada
						//por exemplo para um usuario especifico poderia adicionar uma filial que normalmente nao tem acesso
						If lPESetFil
							aSit_Ant := aClone(aSit)
							aSit := ExecBlock("CTSETFIL",.F.,.F.,{aSit,nI})

							If aSit == NIL .Or. Empty(aSit) .Or. !Valtype( "aSit" ) <> "A"
								aSit := aClone(aSit_Ant)
							EndIf
							nI := Len(aSit)
						EndIf

					Endif

				Next
				If Len( aSit ) <= 0
					// Se n�o tem permiss�o ou ocorreu erro nos dados do usuario, pego a filial corrente.
					Aadd(aSit, aFilAtu[2]+" - "+aFilAtu[7] )
					MvParDef := aFilAtu[2]
					nI++
				EndIf
			EndIf
			If lExibTela
				aFil := {}
				If ExistBlock("ADMSELFIL")	// PE para substituir a AdmOpcoes
					aFil := ExecBlock("ADMSELFIL",.F.,.F.,{cTitulo,aSit,MvParDef,nTamFil})
				ElseIf AdmOpcoes(@MvPar,cTitulo,aSit,MvParDef,,,.F.,nTamFil,nI,.T.,,,,,,,,.T.)  // Chama funcao Adm_Opcoes
					nSit := 1
					For nReg := 1 To len(mvpar) Step nTamFil  // Acumula as filiais num vetor
						If SubSTR(mvpar, nReg, nTamFil) <> Replicate("*",nTamFil)
							AADD(aFil, SubSTR(mvpar, nReg, nTamFil) )
						endif
						nSit++
					next
					If Empty(aFil) .And. lHlp
						Help(" ",1,"ADMFILIAL",,STR0042,1,0)		//"Por favor selecionar pelo menos uma filial"
					EndIF

					If Len(aFil) == Len(aSit)
						lTodasFil := .T.
					EndIf
				Endif
			Else
				aFil := aClone(aSit)
			EndIf
		Else
			aFil := {cFilAnt}
		EndIf

		//ponto de entrada para usuario poder manipular as filiais selecionada
		//por exemplo para um usuario especifico poderia adicionar uma filial que normalmente nao tem acesso
		If lExibTela .and. lPEGetFil
			aFil_Ant := aClone(aFil)
			aFil := ExecBlock("CTGETFIL",.F.,.F.,{aFil})
			If aFil == NIL .Or. Empty(aFil)
				aFil := aClone(aFil_Ant)
			EndIf
		EndIf

	Else
		Help("  ",1,"ADMFILTOP",,STR0043,1,0) //"Functiono disponivel apenas para ambientes TopConnect"
	EndIf

	If Len(aFil) < 1
		CRET := ""
		return lOk
	else	
		CRET := aFil[1]
		FOR nCount:= 2 TO Len(aFil) Step 1
			CRET += "," + aFil[nCount]
		Next
	EndIf

	RestArea(aArea)

Return lOk

