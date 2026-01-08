#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgram   ณProRecom    บAuthor ณYamyl Saavedra    บ Date ณ  10/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcion que valida el proceso de Re-compra.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUse       ณ CIMA                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function ProRecom()
	Local aArea    := GetArea()
	Local lContado := .F.
	Local lRet     := .T.
	local lRutinaAuto := If(IsInCallStack("A468RemFut"),.T.,.F.)
	
	if GetRemoteType() < 0 .or. lRutinaAuto // nahim Terrazas toma en cuenta s๓lo si no es un web services
		return .T.
	endif


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
		cEsta := 'S'
//		cEsta := GetAdvFVal("SA1","A1_UESTADO",xFilial("SA1")+cClie+cLoja,1,"") //Para la integraci๓n con el m๓dulo de Anแlisis de Riesgo
//		Alert(cClie)
//		Alert(cLoja)
//		Alert(GetAdvFVal("MA7","MA7_BLOQUE",xFilial("MA7")+cClie+cLoja,1,0))
		
		If cEsta = 'S'
			//20190404 If GetAdvFVal("MA7","MA7_BLOQUE",xFilial("MA7")+cClie+cLoja,1,0) <> '3'
			//Multiplicamos por *E1_TXMOEDA para sacar siempre en Bolivianos
				cQrySE1  := GetNextAlias()
				BeginSql alias cQrySE1
					SELECT ISNULL(SUM(CASE WHEN E1_TIPO = 'RA ' THEN E1_SALDO*E1_TXMOEDA*-1 ELSE E1_SALDO*E1_TXMOEDA END),0) E1_SALDO, ISNULL(MIN(CASE WHEN E1_TIPO = 'RA' THEN '29991231' ELSE E1_VENCTO END), '29991231') E1_VENCTO
					FROM %table:SE1% SE1
						WHERE SE1.D_E_L_E_T_ = ' '
							And E1_CLIENTE = %Exp:cClie%
							And E1_LOJA = %Exp:cLoja%
							And E1_TIPO IN('NF ','RA ', 'CH')
							And E1_SALDO > 0
				EndSql

/*				BeginSql alias cQrySE1
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
					nMoedLC  := GetAdvFVal("SA1","A1_MOEDALC",xFilial("SA1")+cClie+cLoja,1,"")
					nLimCred := xMoeda(nLimCred,nMoedLC,1,dDataBase)
					
					nTotalPV :=	xMoeda(U_TotPV(),M->C5_MOEDA,1,dDataBase)
					
					if ((cQrySE1)->E1_SALDO+nTotalPV >= nLimCred)
//						alert()
						Aviso("Validaci๓n Cr้dito ",'El Cliente supera su Lํmite de Cr้dito. ' ,{"Ok"},,"Atenci๓n")
						// lRet := .F.
						// Return lRet
					EndIf
					
					If dFecVcto >= dDataBase
						
						lRet     := .T.
						
						//Para la integraci๓n con el m๓dulo de Anแlisis de Riesgo
						/*
						
						nCanDias := GetNewPar("MV_CRDCDIA",30)
						
						If ( dFecVcto + nCanDias < dDataBase )
						
							dFecBlo := GetAdvFVal("MA7","MA7_DATABL",xFilial("MA7")+cClie+cLoja,1,0)
							
							If ( dFecBlo < dDataBase )
	
								Aviso("Validaci๓n Cr้dito",'Se deben actualizar los datos del cliente y hacer nuevamente el anแlisis de cr้dito',{"Ok"},,"Atenci๓n")
								
								DbSelectArea("SA1")
								dbsetorder(1)			//A1_FILIAL+A1_COD+A1_LOJA
								dbgotop()
								SA1->(dbseek(xFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
								RecLock("SA1", .F.)
									//SA1->A1_UESTADO := ' ' //Para la integraci๓n con el m๓dulo de Anแlisis de Riesgo
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
						*/
					Else
						Aviso("Validaci๓n Cr้dito",'El cliente tiene cuentas morosas.',{"Ok"},,"Atenci๓n")
						//lRet     := .F.
						//Return lRet
					EndIf
												
	//			Else
	//				Alert("El cliente no tiene registros en Cuentas por Cobrar")	//RS Quitar este alert
				EndIf
				
			/*20190404 Else
				20190404 Aviso("Validaci๓n Cr้dito",'El Cliente no tiene cr้dito aprobado.',{"Ok"},,"Atenci๓n")
				// lRet := .F.
				// Return lRet
			endIf*/
		Else
			Aviso("Validaci๓n Cr้dito",'Falta realizar el anแlisis al Cliente.',{"Ok"},,"Atenci๓n")
			lRet := .F.
			Return lRet
		endIf
		
	EndIf
	
Return lRet