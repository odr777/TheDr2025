#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³ProRecom    ºAuthor ³Yamyl Saavedra    º Date ³  10/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que valida el proceso de Re-compra.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ CIMA                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ProRecom()
	Local aArea    := GetArea()
	Local lContado := .F.
	Local lRet     := .T.

	If Posicione('SE4',1,xFilial('SE4')+M->C5_CONDPAG,'E4_TIPO') == '1'
		If AllTrim(SE4->E4_COND)$ '0|00' //AL CONTADO
			lContado := .T.         
		End	   
	End 
	
	RestArea(aArea)
	
//	Alert(M->C5_CONDPAG)
//	Alert(SC5->C5_CONDPAG)
//	Alert(lContado)
	
	If !lContado
		cClie := M->C5_CLIENTE
		cLoja := M->C5_LOJACLI
		cEsta := GetAdvFVal("SA1","A1_UESTADO",xFilial("SA1")+cClie+cLoja,1,"")
//		Alert(cClie)
//		Alert(cLoja)
//		Alert(GetAdvFVal("MA7","MA7_BLOQUE",xFilial("MA7")+cClie+cLoja,1,0))
		
		If cEsta = 'S'
			If GetAdvFVal("MA7","MA7_BLOQUE",xFilial("MA7")+cClie+cLoja,1,0) <> '3'
			
				cQrySE1  := GetNextAlias()
				BeginSql alias cQrySE1
					SELECT ISNULL(SUM(CASE WHEN E1_TIPO = 'RA ' THEN E1_XSALDO*-1 ELSE E1_XSALDO END),0) E1_SALDO
						 , ISNULL(MIN(CASE WHEN E1_TIPO = 'RA ' THEN '29991231' ELSE E1_VENCTO END), '29991231') E1_VENCTO
					FROM (
						SELECT 
							CASE 
								WHEN E1_MOEDA = 1 THEN E1_SALDO /M2_MOEDA2
						WHEN E1_MOEDA = 2 THEN E1_SALDO 	  	
								ELSE E1_SALDO
							END E1_XSALDO
							,SE1.*
						FROM %table:SE1% SE1
							LEFT JOIN %table:SM2% SM2 ON SM2.D_E_L_E_T_ = ' ' AND E1_EMISSAO = M2_DATA
						WHERE SE1.D_E_L_E_T_ = ' '
							And E1_FILIAL = %xFilial:SE1%
							And E1_CLIENTE = %Exp:cClie%
							And E1_LOJA = %Exp:cLoja%
							And E1_TIPO IN('NF ','RA ')
							And E1_SALDO > 0
					)TAB
				EndSql				
				
				/*
				BeginSql alias cQrySE1
					SELECT E1_SALDO, E1_VENCTO
					FROM %table:SE1% SE1
					WHERE R_E_C_N_O_ IN
					(
						SELECT MIN(R_E_C_N_O_)
						FROM %table:SE1% SE1
						WHERE SE1.D_E_L_E_T_ = ' '
							And E1_CLIENTE = %Exp:cClie%
							And E1_LOJA = %Exp:cLoja%
							And E1_TIPO = 'NF '
							And E1_EMISSAO <> E1_VENCTO
							And E1_BAIXA > 0
					)
				EndSql*/
				
				if (cQrySE1)->( !Eof() )
					//(cQrySE1)->( DBGOBOTTOM() )
					
					
	//				While ( (cQrySE1)->( !Eof() ) )
	//					Alert((cQrySE1)->E1_SALDO)
	//					Alert((cQrySE1)->E1_BAIXA)
						
	//					(cQrySE1)->(dbSkip())
	//				EndDo
	
					dFecVcto := StoD((cQrySE1)->E1_VENCTO)
					
					nLimCred := GetAdvFVal("SA1","A1_LC",xFilial("SA1")+cClie+cLoja,1,"")
					nTotalPV :=	U_TotPV()
					
					if ((cQrySE1)->E1_SALDO+nTotalPV >= nLimCred)
						Aviso("Validación Crédito",'El Cliente supera su Límite de Crédito.',{"Ok"},,"Atención")
						lRet := .F.
						Return lRet
					EndIf
					
					
					If dFecVcto >= dDataBase
						
						nCanDias := GetNewPar("MV_CRDCDIA",30)
						
						If ( dFecVcto + nCanDias < dDataBase )
						
							dFecBlo := GetAdvFVal("MA7","MA7_DATABL",xFilial("MA7")+cClie+cLoja,1,0)
							
							If ( dFecBlo < dDataBase )
	
								Aviso("Validación Crédito",'Se deben actualizar los datos del cliente y hacer nuevamente el análisis de crédito',{"Ok"},,"Atención")
								
								DbSelectArea("SA1")
								dbsetorder(1)			//A1_FILIAL+A1_COD+A1_LOJA
								dbgotop()
								SA1->(dbseek(xFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
								RecLock("SA1", .F.)
									SA1->A1_UESTADO := ' '
									SA1->A1_LC      := 0
									SA1->A1_RISCO   := ' '
									SA1->A1_VENCLC  := dDataBase
									SA1->A1_XTIPOCL := '   '
								MsUnlock()	
								
								cQuery := " UPDATE " + RetSqlName("MA7") + " SET MA7_FILIAL = 'TDEP' "
								cQuery += " WHERE D_E_L_E_T_ = ' '"
								cQuery += "   AND MA7_CODCLI = '" + M->C5_CLIENTE + "' "
								cQuery += "   AND MA7_LOJA	 = '" + M->C5_LOJACLI + "' "
								TCSqlExec( cQuery )
								
								cQuery := " UPDATE " + RetSqlName("MA8") + " SET MA8_FILIAL = 'TDEP' "
								cQuery += " WHERE D_E_L_E_T_ = ' '"
								cQuery += "   AND MA8_CODCLI = '" + M->C5_CLIENTE + "' "
								cQuery += "   AND MA8_LOJA	 = '" + M->C5_LOJACLI + "' "
								TCSqlExec( cQuery )
								
								cQuery := " UPDATE " + RetSqlName("MAB") + " SET MAB_FILIAL = 'TDEP' "
								cQuery += " WHERE D_E_L_E_T_ = ' '"
								cQuery += "   AND MAB_CODCLI = '" + M->C5_CLIENTE + "' "
								cQuery += "   AND MAB_LOJA	 = '" + M->C5_LOJACLI + "' "
								TCSqlExec( cQuery )
								
								cQuery := " UPDATE " + RetSqlName("MAE") + " SET MAE_FILIAL = 'TDEP' "
								cQuery += " WHERE D_E_L_E_T_ = ' '"
								cQuery += "   AND MAE_CODCLI = '" + M->C5_CLIENTE + "' "
								cQuery += "   AND MAE_LOJA	 = '" + M->C5_LOJACLI + "' "
								TCSqlExec( cQuery )
								
								cCueActi := GetMV("MV_QUEST")
								cQuery := " UPDATE " + RetSqlName("MAI") + " SET MAI_FILIAL = 'TDEP' "
								cQuery += " WHERE D_E_L_E_T_ = ' '"
								cQuery += "   AND MAI_CODCLI = '" + M->C5_CLIENTE + "' "
								cQuery += "   AND MAI_LOJA	 = '" + M->C5_LOJACLI + "' "
								cQuery += "   AND MAI_QUEST	 = '" + cCueActi		 + "' "
								TCSqlExec( cQuery )
								
								lRet := .F.
								Return lRet
							endif
	//					Else
	//						Alert("Proceso normal")
						endif
					Else
						Aviso("Validación Crédito",'El cliente tiene cuentas pendientes.',{"Ok"},,"Atención")
						lRet := .F.
						Return lRet
					EndIf
												
	//			Else
	//				Alert("El cliente no tiene registros en Cuentas por Cobrar")	//RS Quitar este alert
				EndIf
				
			Else
				Aviso("Validación Crédito",'El Cliente no tiene crédito aprobado.',{"Ok"},,"Atención")
				lRet := .F.
				Return lRet
			endIf
		Else
			Aviso("Validación Crédito",'Falta realizar el análisis al Cliente.',{"Ok"},,"Atención")
			lRet := .F.
			Return lRet
		endIf
		
	EndIf
	
Return lRet