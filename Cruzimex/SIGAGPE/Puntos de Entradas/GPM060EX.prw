#Include 'protheus.ch'
#Include 'parmtype.ch'

User Function GPM060EX
Local cPrefix		:= RC1->RC1_PREFIX
Local lRotinaEai 	:= FWHasEAI("GPEM660",.T.) //VERIFICA SE A INTEGRACAO DE TITULOS COM SISTEMAS EXTERNOS ESTA HABILITADO
Local lRetBx		:= .T.
Local lExclui		:= .T.
Local nX			:= 0
Local cArqSE2
local lRotinaEai	:=  .F.

If  RC1->RC1_INTEGR $"0.2"
			RecLock("RC1",.F.,.F.)
			dbDelete()
			MsUnLock()
			//integracao com modulo SIGAPCO
			PcoDetLan("000092","01","GPEM660", .T.)
Else
    //QUANDO HA INTEGRACAO DE TITULOS COM SISTEMAS EXTERNO, NAO EH GERADO O TITULO NO SIGAFIN
	If !lRotinaEai 
				
		//Verifica se os titulos ja foram integrados e exclui do SIGAFIN
		dbSelectArea("SE2")

		//Criado indice temporario para exclusao apenas pelo prefixo (GPE) + numero do titulo.
		//Na exclusao, nao podemos veriricar a filial, pois ela pode ser diferente entre a RC1 e SE2 (financeiro)
		cArqSE2 := criatrab("",.F.)
		IndRegua("SE2",cArqSE2,"E2_PREFIXO+E2_NUM",,,"Selecionando Registros") //"Selecionando Registros..."
		nIndex 	:= RetIndex("SE2")
		#IFNDEF TOP
		dbSetIndex(cArqSE2+OrdBagExt())
		#ENDIF
		SE2->( dbSetOrder(nIndex+1))
		
  		If dbSeek(cPrefix+RC1->RC1_NUMTIT, .F.)
			While !Eof() .And. SE2->E2_FILORIG = RC1->RC1_FILTIT .AND. SE2->E2_NUM == RC1->RC1_NUMTIT .And. cPrefix == SE2->E2_PREFIXO
				lRetBx	:= .T.
				//Titulo Principal ou Titulo Filho ja baixado no SIGAFIN nao pode ser excluido
				If	( !Empty(E2_BAIXA) .And. ( E2_VALOR # E2_SALDO ) ) .AND. ALLTRIM(E2_ORIGEM) == 'GPEM670'
					MsgAlert( OemToAnsi( "El titulo " +  RC1->RC1_NUMTIT + " no puede excluirse pues ya fue bajado en el Modulo Financiero"), OemToAnsi("Atencion") ) //"O título "##" nao pode ser excluido pois já foi baixado no Módulo Financeiro" ##"Atencao"
					lRetBx:= .F.
					Exit
				Endif
				dbSkip()
			Enddo

			If lRetBx
				//Exclui o titulo do SE2
				dbSelectArea("SE2")
		 		dbSeek(cPrefix+RC1->RC1_NUMTIT, .F.)
				lExclui	:=	.T.
				While  SE2-> ( !Eof() ) .AND. SE2->E2_FILORIG = RC1->RC1_FILTIT .And. SE2->E2_NUM = RC1->RC1_NUMTIT .And. cPrefix == SE2->E2_PREFIXO
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o titulo nao esta em bordero (Rotina Prov: FINA050)   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If lExclui .AND. !Empty(SE2->E2_NUMBOR)
						lExclui	:= .F.
					Else
						// Caso seja o titulo principal, verifica se existe titulo de impostos
						// gerado, e confirma se estes estao ou nao em um outro bordero.
						aTitImp := ImpCtaPg()
						For nX := 1 To Len(aTitImp)
							If !Empty(aTitImp[nX][8]) .and. (aTitImp[nX][7] == aTitImp[nX][6])
								lExclui	:= .F.
							Endif
						Next
					EndIf
                    
					If ( !lExclui )
						Help("",1,"FA050BORD")
					Else
						//Grava o historico do titulo excluido na tabela FJU (Financeiro)
						If AliasIndic("FJU")	
							FinGrvEx('P')
						EndIf

						// ODR 20/09/2019
						// SE2->E2_PREFIXO == "GP2", se debe cambiar por algún parámetro o campo
						// Está fijo para cliente Belen
						If Alltrim(SE2->E2_ORIGEM) == "GPEM670" .AND. SE2->E2_PREFIXO == "GP2" 
							/*
							RecLock("SE2",.F.,.F.)
							dbDelete()
							MsUnLock()
							SE2->( FKCOMMIT() )							
							*/
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Contabilização de apagado do Título/Pagar - EDUAR 09/09/2019	³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							PRIVATE lMsErroAuto := .F.
							XFIN050EXC()
							
							If lMsErroAuto
								lRetBx := .F.
								lExclui:= .F.
							    MostraErro()
							Else
							    Alert("Exclusão do Título com sucesso! Se procedió a revertir el asiento.")
							Endif
						else
							RecLock("SE2",.F.,.F.)
							dbDelete()
							MsUnLock()
							SE2->( FKCOMMIT() )	
							Alert("Exclusão do Título com sucesso! No corresponde reversión contable.")
						Endif
					EndIf
					SE2-> ( dbSkip() )
				Enddo

		 		//Exclui o titulo do GPE
		 		If ( lExclui )
					RecLock("RC1",.F.,.F.)
					dbDelete()
					MsUnLock()
					//integracao com modulo SIGAPCO
					PcoDetLan("000092","01","GPEM660", .T.)
				EndIf
			Endif
		Endif
	Else
		FwIntegDef("GPEM660")
		RecLock("RC1",.F.,.F.)
		If pRetEAI = .T.
			dbDelete()
			MsUnLock()
	 	endif
		//integracao com modulo SIGAPCO
		PcoDetLan("000092","01","GPEM660", .T.)
		Alert("Exclusão do Título com sucesso!")
	Endif
Endif

Return (lRetBx)



Static Function XFIN050EXC
	Local aArray := {}
	                        
	aArray := { { "E2_PREFIXO" , SE2->E2_PREFIXO , NIL },;
	            { "E2_NUM"     , SE2->E2_NUM     , NIL } }
	 
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão 
Return