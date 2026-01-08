#Include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//PUnto de entrada que se ejecuta despues de grabar el documento(SF1 y SD1)
//Sirve para actualizar los costos al 87% en el kardex del producto
//--- Nahim Terrazas 16/01/2020

USER FUNCTION LOCXPE08()
	Local _cArea:=GetArea()
	Local nRet := 0
	Local cSinal:="+"



	// adicionado correlativo de remito 18/05/2021
	If alltrim(FunName()) $ "MATA102N" .and. aCfgNf[1]==60
		//+------------------------------------------------------------------------+
		//|En Remito de Entrada, guardando el campo correlativo F1_UCORREL						   |
		//+------------------------------------------------------------------------+
		//GetNumRem obtiene el Nro de Correaltivo que corresponde al remito
		cNumRem	:= U_GetNumRem("REM") 	
		If Empty(SF1->F1_UCORREL) .or. SF1->F1_UCORREL<>cNumRem 
			RecLock("SF1",.F.)
			SF1->F1_UCORREL :=  cNumRem
			MsUnlock()
			// Alert("Se grabó el Documento: "+M->F1_DOC+ " con el correlativo Remito número:"+SF1->F1_UCORREL)  

		Endif
	Endif	
	// adicionado correlativo de remito 18/05/2021



	DbSelectArea("SD1")
	DbSetOrder(3)
//	alert("NOVO")
	//If (FunName() == 'MATA102N' .OR. (FUNNAME() == 'MATA101N' .AND. SF1->F1_TIPODOC == '13')) .AND. INCLUI
	//If (FunName() == 'MATA102N' .OR. (FUNNAME() == 'MATA101N' .AND. SF1->F1_TIPODOC == '13') .OR. (FUNNAME()=='MATA465N' .AND. SF1->F1_TIPODOC == '04')) .AND. INCLUI
	If (FunName() == 'MATA102N' .OR. (FUNNAME() == 'MATA101N' .AND. SF1->F1_TIPODOC == '13') ) .AND. INCLUI //CUANDO ES REMITO REALIZA TODOS LOS CALCULOS NECESARIOS
		DbSeek(XFILIAL('SD1')+SF1->(DTOS(F1_EMISSAO)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) )
		While SD1->(!Eof()).AND. SF1->(DTOS(F1_EMISSAO)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)==SD1->(DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)

			total:=Round((SD1->D1_TOTAL  - SD1->D1_VALDESC),2)
			nRet :=  XMOEDA(total, SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA )

			nflete:=XMOEDA(SD1->D1_VALFRE , SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA )
			nGasto:=XMOEDA(SD1->D1_DESPESA , SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA )
			nSeguro:=XMOEDA(SD1->D1_SEGURO , SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA )
			nBaseImp:=0
			nValimp:=0
			nAlicuota:=0
			DbSelectArea("SFC")
			DbSetOrder(1)
			DbSeek(xFilial("SFC")+SD1->D1_TES)
			SFB->(DbSetOrder(1))
			//			If !(SFC->FC_IMPOSTO $ "RIR-RIV-RR1-IDE") .and. SFB->(DbSeek(xFilial("SFB")+SFC->FC_IMPOSTO))
			If SFC->FC_IMPOSTO $ "IVA" .and. SFB->(DbSeek(xFilial("SFB")+SFC->FC_IMPOSTO))
				If "IVA" $ upper(SFB->FB_FORMSAI) .and. SFB->FB_CODIGO == 'IVA' // Nahim sólo considera el IVA
					if SFC->FC_BASE <> 0// Caso el impuesto es variable (base imponible es diferente) Nahim 28/01/2021
						total := total - total * SFC->FC_BASE / 100
					ENDIF
					// if SFC->FC_CREDITA == '2' .AND. SFC->FC_BASE <> 0// RESTA COSTO
					// 	nRet := nRet - (nRet * SFC->FC_BASE / 100) // resta costo para la alicuota
					// ENDIF

//					alert("IVA")
					//						If SFB->FB_ALIQ == 10
					nAlicuota:= SFB->FB_ALIQ // NTP
					nValimp:= total * nAlicuota / 100// round( total/11,IIF(SF1->F1_MOEDA>1,2,0)  )
					nRet -= nValimp// (nRet * nAlicuota / 100) //round( nRet/11,4  )
					//						Else
					//							If SFB->FB_ALIQ ==5
					//								nValimp:=round( total/21,IIF(SF1->F1_MOEDA>1,2,0)  )
					//								nRet -= round( nRet/21,4   )
					//								nAlicuota:=5
					//							end
					//						EndIf

					// nBaseImp:= round(total-nValimp,IIF(SF1->F1_MOEDA>1,2,0))
					nBaseImp:= round(total,IIF(SF1->F1_MOEDA>1,2,0))
				EndIf
			End
			nTmpCosto:= SD1->D1_CUSTO
			nTmpCosto2:= SD1->D1_CUSTO2
			nTmpCosto3:= SD1->D1_CUSTO3
			nTmpCosto4:= SD1->D1_CUSTO4
			nTmpCosto5:= SD1->D1_CUSTO5

			nRet+=	nGasto + nSeguro	 + nflete

			RecLock("SD1" , .F.)
			D1_BASIMP1 := nBaseImp
			D1_ALQIMP1 := nAlicuota
			D1_VALIMP1 := nValimp
			D1_CUSTO  := Round( xMoeda( nRet   , 1, 1 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)
			iF SF1->F1_MOEDA == 2
				D1_CUSTO2 := Round( xMoeda( nRet   , 1 , 2 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ,SF1->F1_TXMOEDA) ,4)
			ELSE
				D1_CUSTO2 := Round( xMoeda( nRet   , 1 , 2 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)
			END

			iF SF1->F1_MOEDA == 3
				D1_CUSTO3 := Round( xMoeda( nRet   , 1 , 3 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ,SF1->F1_TXMOEDA) ,4)
			ELSE
				D1_CUSTO3 := Round( xMoeda( nRet   , 1 , 3 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)
			END

			iF SF1->F1_MOEDA == 4
				D1_CUSTO4 := Round( xMoeda( nRet   , 1 , 4 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ,SF1->F1_TXMOEDA) ,4)
			ELSE
				D1_CUSTO4 := Round( xMoeda( nRet   , 1 , 4 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)
			END

			iF SF1->F1_MOEDA == 5
				D1_CUSTO5 := Round( xMoeda( nRet   , 1 , 5 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ,SF1->F1_TXMOEDA) ,4)
			ELSE
				D1_CUSTO5 := Round( xMoeda( nRet   , 1 , 5 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)
			END

			MsUnLock()
			//	EndIf

			If Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_ESTOQUE") == 'S'
				dbSelectArea("SB2")
				dbSetOrder(1)
				If !MsSeek(xFilial("SB2")+SD1->D1_COD+SD1->D1_LOCAL, .F.)
					//³ Se nao existir , ele cria                             ³
					CriaSB2(SD1->D1_COD,SD1->D1_LOCAL)
				Else
					RecLock("SB2",.F.)
				EndIf

				B2_VATU1 := round(B2_VATU1 + SD1->D1_CUSTO - nTmpCosto,4)
				B2_VATU2 := round(B2_VATU2 + SD1->D1_CUSTO2 - nTmpCosto2,4)
				B2_VATU3 := round(B2_VATU3 + SD1->D1_CUSTO3 - nTmpCosto3,4)
				B2_VATU4 := round(B2_VATU4 + SD1->D1_CUSTO4 - nTmpCosto4,4)
				B2_VATU5 := round(B2_VATU5 + SD1->D1_CUSTO5 - nTmpCosto5,4)

				B2_CM1 := round(B2_VATU1/B2_QATU,4)
				B2_CM2 := round(B2_VATU2/B2_QATU,4)
				B2_CM3 := round(B2_VATU3/B2_QATU,4)
				B2_CM4 :=round( B2_VATU4/B2_QATU,4)
				B2_CM5 := round(B2_VATU5/B2_QATU,4)
				MsUnLock()

			END
			SD1->(DbSkip())

		End
	else
		If FunName() == 'MATA101N'//  COMENTANDO FACTURA 28/01/2020
			U_UpdateCosto(.F.)
		end
	EndIf
	RestArea(_cArea)
	If Alltrim(FunName()) == "MATA102N" .and. aCfgNf[1]==60
		u_ImpRemito()
	Endif
	// Endif
	/*
	If FunName() $ ('MATA102DN|MATA466N')
		MsgRun("Insertando Registros Tabla Temporal","Processando - CXP",{||InsertAFSPMS() })
	End If*/

	RestArea(_cArea)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// FUNCION PARA ACTUALIZAR LOS COSTOS
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
User Function UpdateCosto(lDelete)
	Local _Area:=GetArea()

	If !lDelete
		BeginSQL Alias 'TRBRTD'
			Select * from  %Table:SD1% SD1
			Where D1_DOC=%Exp:SF1->F1_DOC%
			AND D1_SERIE=%Exp:SF1->F1_SERIE%
			AND D1_FORNECE=%Exp:SF1->F1_FORNECE%
			AND D1_LOJA=%Exp:SF1->F1_LOJA% AND D1_ESPECIE='NF '
			AND D1_REMITO<>'' AND SD1.%NotDel%
		EndSQL
	else
		BeginSQL Alias 'TRBRTD'
			Select * from  %Table:SD1% SD1
			Where D1_DOC=%Exp:SF1->F1_DOC%
			AND D1_SERIE=%Exp:SF1->F1_SERIE%
			AND D1_FORNECE=%Exp:SF1->F1_FORNECE%
			AND D1_LOJA=%Exp:SF1->F1_LOJA% AND D1_ESPECIE='NF '
			AND D1_REMITO<>''
		EndSQL
	End

	nMoneda :=0
	nTxMoneda :=0
	IF TRBRTD->(!EOF()) .AND. TRBRTD->(!BOF())
		TRBRTD->(DbGoTop())
		While TRBRTD->(!Eof())
			aMonedas:= GetMoneda(TRBRTD->D1_REMITO,TRBRTD->D1_SERIREM,TRBRTD->D1_FORNECE,TRBRTD->D1_LOJA,TRBRTD->D1_TIPO)
			nMoneda := aMonedas[1] //GetAdvFVal("SF1","F1_MOEDA",xFilial("SF1")+TRBRTD->(D1_REMITO+D1_SERIREM+D1_FORNECE+D1_LOJA+D1_TIPO),1,"")
			nTxMoneda := aMonedas[2] // GetAdvFVal("SF1","F1_TXMOEDA",xFilial("SF1")+TRBRTD->(D1_REMITO+D1_SERIREM+D1_FORNECE+D1_LOJA+D1_TIPO),1,"")
			DbSelectArea("SD1")
			DbSetOrder(1)
			DbSeek(XFILIAL('SD1')+TRBRTD->(D1_REMITO+D1_SERIREM+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEMREM))
			//-------------Actualiza el Costo en el Remito -----------------------------------
			total:=Round((SD1->D1_TOTAL  - SD1->D1_VALDESC),2)
			nRet :=  XMOEDA(total, nMoneda,1,SD1->D1_EMISSAO,4,nTxMoneda )

			nflete:=XMOEDA(SD1->D1_VALFRE , nMoneda,1,SD1->D1_EMISSAO,4,nTxMoneda )
			nGasto:=XMOEDA(SD1->D1_DESPESA , nMoneda,1,SD1->D1_EMISSAO,4,nTxMoneda )
			nSeguro:=XMOEDA(SD1->D1_SEGURO , nMoneda,1,SD1->D1_EMISSAO,4,nTxMoneda )
			nBaseImp:=0
			nValimp:=0
			nAlicuota:=0
			DbSelectArea("SFC")
			DbSetOrder(1)
			DbSeek(xFilial("SFC")+SD1->D1_TES)
			SFB->(DbSetOrder(1))
//			If !(SFC->FC_IMPOSTO $ "RIR-RIV-RR1-IDE") .and. SFB->(DbSeek(xFilial("SFB")+SFC->FC_IMPOSTO))
//				If "IVAI" $ upper(SFB->FB_FORMSAI) NTP 30/12/2019
			If SFC->FC_IMPOSTO $ "IVA" .and. SFB->(DbSeek(xFilial("SFB")+SFC->FC_IMPOSTO))
//				ALERT("ACTUALIZA COSTOS")
				If "IVA" $ upper(SFB->FB_FORMSAI) .and. SFB->FB_CODIGO == 'IVA' // Nahim sólo considera el IVA
//					If SFB->FB_ALIQ == 10
//						nValimp:=round( total/11,IIF(nMoneda>1,2,0)  )
//						nRet -= round( nRet/11,4  )
//						nAlicuota:=10
//					Else
//						If SFB->FB_ALIQ ==5
//							nValimp:=round( total/21,IIF(nMoneda>1,2,0)  )
//							nRet -= round( nRet/21,4   )
//							nAlicuota:=5
//						end
//					EndIf
//					nBaseImp:= round(total-nValimp,IIF(nMoneda>1,2,0))
					if SFC->FC_BASE <> 0// Caso el impuesto es variable (base imponible es diferente) Nahim 28/01/2021
						total := total - total * SFC->FC_BASE / 100
					ENDIF
					// if SFC->CREDITA == '2' .AND. SFC->BASE <> 0// RESTA COSTO
					// 	total := nRet - (nRet * SFC->BASE / 100) // resta costo para la alicuota
					// ENDIF
					nAlicuota:= SFB->FB_ALIQ // NTP
					nValimp:= total * nAlicuota / 100// round( total/11,IIF(SF1->F1_MOEDA>1,2,0)  )
					nRet -= nValimp// (nRet * nAlicuota / 100) //round( nRet/11,4  )
					nBaseImp:= round(total,IIF(SF1->F1_MOEDA>1,2,0))
					// nAlicuota:= SFB->FB_ALIQ // NTP
					// nValimp:= total * nAlicuota / 100// round( total/11,IIF(SF1->F1_MOEDA>1,2,0)  )
					// nRet -= (nRet * nAlicuota / 100) //round( nRet/11,4  )
					// nBaseImp:= round(total-nValimp,IIF(SF1->F1_MOEDA>1,2,0))
				EndIf
			else // Nahim cuando no sea IVA no realiza ninguna acción 09/09/2020
				TRBRTD->(DbSkip())
				loop
			ENDIF
			nTmpCosto:= SD1->D1_CUSTO
			nTmpCosto2:= SD1->D1_CUSTO2
			nTmpCosto3:= SD1->D1_CUSTO3
			nTmpCosto4:= SD1->D1_CUSTO4
			nTmpCosto5:= SD1->D1_CUSTO5

			nRet+=	nGasto + nSeguro	 + nflete

			RecLock("SD1" , .F.)
			// D1_BASIMP1 := nBaseImp
			// D1_ALQIMP1 := nAlicuota
			// D1_VALIMP1 := nValimp
			D1_CUSTO  := Round( xMoeda( nRet   , 1, 1 , SD1->D1_EMISSAO, 4 ,nTxMoneda ) ,4)
			iF nMoneda == 2
				D1_CUSTO2 := Round( xMoeda( nRet   , 1 , 2 , SD1->D1_EMISSAO, 4 ,nTxMoneda ,nTxMoneda) ,4)
			ELSE
				D1_CUSTO2 := Round( xMoeda( nRet   , 1 , 2 , SD1->D1_EMISSAO, 4 ,nTxMoneda ) ,4)
			END

			iF nMoneda == 3
				D1_CUSTO3 := Round( xMoeda( nRet   , 1 , 3 , SD1->D1_EMISSAO, 4 ,nTxMoneda ,nTxMoneda) ,4)
			ELSE
				D1_CUSTO3 := Round( xMoeda( nRet   , 1 , 3 , SD1->D1_EMISSAO, 4 ,nTxMoneda ) ,4)
			END

			iF nMoneda == 4
				D1_CUSTO4 := Round( xMoeda( nRet   , 1 , 4 , SD1->D1_EMISSAO, 4 ,nTxMoneda ,nTxMoneda) ,4)
			ELSE
				D1_CUSTO4 := Round( xMoeda( nRet   , 1 , 4 , SD1->D1_EMISSAO, 4 ,nTxMoneda ) ,4)
			END

			iF nMoneda == 5
				D1_CUSTO5 := Round( xMoeda( nRet   , 1 , 5 , SD1->D1_EMISSAO, 4 ,nTxMoneda ,nTxMoneda) ,4)
			ELSE
				D1_CUSTO5 := Round( xMoeda( nRet   , 1 , 5 , SD1->D1_EMISSAO, 4 ,nTxMoneda ) ,4)
			END

			MsUnLock()
			If Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_ESTOQUE") == 'S'
				dbSelectArea("SB2")
				dbSetOrder(1)
				If !MsSeek(xFilial("SB2")+SD1->D1_COD+SD1->D1_LOCAL, .F.)
					//³ Se nao existir , ele cria                             ³
					CriaSB2(SD1->D1_COD,SD1->D1_LOCAL)
				Else
					RecLock("SB2",.F.)
				EndIf

				B2_VATU1 := round(B2_VATU1 + (SD1->D1_CUSTO - nTmpCosto),4)
				B2_VATU2 := round(B2_VATU2 + (SD1->D1_CUSTO2 - nTmpCosto2),4)
				B2_VATU3 := round(B2_VATU3 + (SD1->D1_CUSTO3 - nTmpCosto3),4)
				B2_VATU4 := round(B2_VATU4 + (SD1->D1_CUSTO4 - nTmpCosto4),4)
				B2_VATU5 := round(B2_VATU5 + (SD1->D1_CUSTO5 - nTmpCosto5),4)

				B2_CM1 := round(B2_VATU1/B2_QATU,4)
				B2_CM2 := round(B2_VATU2/B2_QATU,4)
				B2_CM3 := round(B2_VATU3/B2_QATU,4)
				B2_CM4 :=round( B2_VATU4/B2_QATU,4)
				B2_CM5 := round(B2_VATU5/B2_QATU,4)
				MsUnLock()

			END
			//--------------------------------------------------------------------------------
			TRBRTD->(DbSkip())
		END

	END
	TRBRTD->(dbCloseArea())
	RestArea(_Area)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function GetMoneda(cDoc,cSerie,cFornece,cLoja,cTipo)
	Local aArea    := GetArea()
	Local aDatos:={0,0}
	BeginSQL Alias 'TRBSF1'
		Select * from  %Table:SF1% SF1
		Where F1_DOC=%Exp:cDoc%
		AND F1_SERIE=%Exp:cSerie%
		AND F1_FORNECE=%Exp:cFornece%
		AND F1_LOJA=%Exp:cLoja% AND F1_ESPECIE='RCN'
		AND F1_TIPO=%Exp:cTipo% AND SF1.%NotDel%
	EndSQL
	IF TRBSF1->(!EOF()) .AND. TRBSF1->(!BOF())
		TRBSF1->(DbGoTop())
		aDatos[1]:= TRBSF1->F1_MOEDA
		aDatos[2]:= TRBSF1->F1_TXMOEDA
	END
	TRBSF1->(dbCloseArea())
	RestArea( aArea )
Return aDatos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Insertar en la tabla AFS de PMS por el Item Contable relacionado con la Tarea³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function InsertAFSPMS
	Local StrSql:=""
	StrSql:="INSERT INTO AFS010(AFS_FILIAL,AFS_COD,AFS_LOCAL,AFS_MOVPRJ,AFS_NUMSEQ,AFS_EMISSA,AFS_DOC,AFS_SERIE,AFS_PROJET,AFS_REVISA,AFS_EDT,"
	StrSql+="AFS_TAREFA,AFS_QUANT,AFS_QTSEGU,AFS_TRT,AFS_ID,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_)                                               "
	StrSql+="(                                                                                                                                "
	StrSql+="SELECT D2_FILIAL, D2_COD, D2_LOCAL, '1' INGRESO, SD2010.D2_NUMSEQ, D2_EMISSAO, D2_DOC, D2_SERIE,                                 "
	StrSql+="AF8_PROJET, AF8_REVISA, AF9_EDTPAI, AF9_TAREFA, D2_QUANT, D2_QTSEGUM, ' ' AFN_TRT, 'NT-001' AFN_ID,                              "
	StrSql+="' ' DELE                                                                                                                         "
	StrSql+=", (SELECT MAX(R_E_C_N_O_) FROM AFS010 ) + ROWNUM RECNO, 0 RECDEL                                           "
	StrSql+="FROM SD2010, AF9010, AF8010, SF4010                                                                                              "
	StrSql+="WHERE SD2010.D_E_L_E_T_ = ' '                                                                                                    "
	StrSql+="AND AF9010.D_E_L_E_T_ = ' '                                                                                                      "
	StrSql+="AND AF8010.D_E_L_E_T_ = ' '                                                                                                      "
	StrSql+="AND SF4010.D_E_L_E_T_ = ' '                                                                                                      "
	StrSql+="AND D2_ITEMCC = AF9_ITEMCC                                                                                                       "
	StrSql+="AND AF9_PROJET = AF8_PROJET                                                                                                      "
	StrSql+="AND AF9_REVISA = AF8_REVISA                                                                                                      "
	StrSql+="AND AF9_FILIAL = AF8_FILIAL                                                                                                      "
	StrSql+="AND D2_TES = F4_CODIGO                                                                                                           "
	StrSql+="AND D2_REMITO = ' '                                                                                                              "
	StrSql+="AND D2_ITEMCC <> ' '                                                                                                             "
	StrSql+="AND AF9_ITEMCC <> ' '                                                                                                            "
	StrSql+="AND AF9_TAREFA NOT LIKE 'ERR%'                                                                                                   "
	StrSql+="AND D2_REMITO = ' '                                                                                                              "
	StrSql+="AND (D2_DOC||D2_SERIE||D2_NUMSEQ) NOT IN                                                                                         "
	StrSql+="(                                                                                                                                "
	StrSql+="SELECT AFS_DOC||AFS_SERIE||AFS_NUMSEQ                                                                                            "
	StrSql+="FROM AFS010                                                                                                                      "
	StrSql+="WHERE D_E_L_E_T_ = ' '                                                                                                           "
	StrSql+=")                                                                                                                                "
	StrSql+=")                                                                                                                                "

	MEMOWRITE("StrSql_AFSPMS.SQL",StrSql)
	if tcSQLexec(StrSql) < 0   //para verificar se a query funciona
		MsgAlert("Error al Insertar Registros a la Tabla AFS de PMS")
		return .F.
	Endif

Return .T.
