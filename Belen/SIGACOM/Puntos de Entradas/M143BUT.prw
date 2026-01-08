#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ M143BUT  º Autor ³ Erick Etcheverry 	   º Data ³  28/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Botones en despacho dentro al vis inclui ldeleta             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function M143BUT()
	Local _aButton:={}
	Local nOpcX := ParamIxb[1]

	iif(nOpcX == 4,_aButton := {{'bmpord1',{|| U_uautgas()}, "Gastos Factura", "Gastos Factura"}},nil) ////si es modificar

Return (_aButton)

user function uautgas()
	Local aArea	:= GetArea()
	Local lSalto := .f.
	////////dbb pos
	Local nPFormu    := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_FORMUL"})
	Local nPNota     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_DOC"})
	Local nPSerie    := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_SERIE"})
	Local nPosTipo   := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_TIPONF"})
	Local nPEmissao  := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_EMISSA"}) ///
	Local nPosFornec := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_FORNEC"})
	Local nPLoja     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_LOJA"})
	Local nPCond     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_COND"})
	Local nPosMoeda	 := aScan(aHeader1,{|x| Alltrim(x[2]) =="DBB_MOEDA" })
	Local nPosSimbol := aScan(aHeader1,{|x| Alltrim(x[2]) =="DBB_SIMBOL" })
	Local nPosTxMoeda:= aScan(aHeader1,{|x| Alltrim(x[2]) =="DBB_TXMOED" })
	Local nPosIncot	 := aScan(aHeader1,{|x| Alltrim(x[2]) =="DBB_INCOTE" })
	Local nPosUndb	 := aScan(aHeader1,{|x| Alltrim(x[2]) =="DBB_UNDB" })	
	//Local nPosUpoli	 := aScan(aHeader1,{|x| Alltrim(x[2]) =="DBB_UDPOLI" })	
	//Local nPPolz    := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_UPOLIZ"}) 
	//Local nPosUmon	 := aScan(aHeader1,{|x| Alltrim(x[2]) =="DBB_UMONTO" })
	Local nPItem     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_ITEM"})
	Local nPDesp     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_DESPES"})
	Local nPFrete    := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_FRETE"})"
	Local nPSegur    := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_SEGURO"})
	Local nPValb     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_VALBRU"})
	Local nPDesc     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_DESCON"})
	Local nPPeso     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_PESOL"})
	Local nPOKks     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_OK"})
	Local nPCodct    := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_CODCTR"})
	
	Local nPNuma     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_NUMAUT"})
	Local nPWttt     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_ALI_WT"})
	Local nPRecn     := aScan(aHeader1,{|x| AllTrim(x[2]) =="DBB_REC_WT"})
	///////DBC
	Local nPosItemC  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ITEM"})
	Local nPItDoc    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ITDOC" })
	Local nPosProd   := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_CODPRO"})
	Local nPosQtde   := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_QUANT" })
	Local nPosUnit   := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_PRECO" })
	Local nPosTotal  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_TOTAL" })
	Local nPosNumPO  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_PEDIDO"})
	Local nPosItemPO := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ITEMPC"})
	Local nPosTes    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_TES"   })
	Local nPosTec    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_TEC"   })
	Local nPosLoc    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_LOCAL"   })
	Local nPosCon    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_CONTA"   })
	Local nPosUme    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_UM"   })
	Local nPosUDu    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_UVALDU"   })
	Local nPosQtse   := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_QTSEGU"   })
	Local nPosSegum  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_SEGUM"   })
	Local nPosDescric:= aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_DESCRI"   })
	Local nPosDatpf  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_DATPRF"   }) 
	Local nPosCC  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_CC"   }) 
	Local nPosSegu   := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_SEGURO"   }) 
	Local nPosItca   := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ITCTA"   })  
	Local nPosVldes  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLDESC"   })   	
	Local nPosCVlde  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_CLVL"   }) 
	Local nPosValfr  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VALFRE"   }) 
	Local nPosDespe  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_DESPES"   }) 
	Local nPosBasi  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP1"   })
	Local nPosBasi2  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP2"   })
	Local nPosBasi3  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP3"   })
	Local nPosBasi4  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP4"   })
	Local nPosBasi5  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP5"   })
	Local nPosBasi6  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP6"   })
	Local nPosBasi7  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP7"   })
	Local nPosBasi8  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP8"   })
	Local nPosBasi9  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_BSIMP9"   })

	Local nPosAli1  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP1"   })
	Local nPosAli2  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP2"   })
	Local nPosAli3  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP3"   })
	Local nPosAli4  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP4"   })
	Local nPosAli5  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP5"   })
	Local nPosAli6  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP6"   })
	Local nPosAli7  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP7"   })
	Local nPosAli8  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP8"   })
	Local nPosAli9  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALIMP9"   })

	
	Local nPosVli1  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP1"   })
	Local nPosVli2  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP2"   })
	Local nPosVli3  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP3"   })
	Local nPosVli4  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP4"   })
	Local nPosVli5  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP5"   })
	Local nPosVli6  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP6"   })
	Local nPosVli7  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP7"   })
	Local nPosVli8  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP8"   })
	Local nPosVli9  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_VLIMP9"   })
	
	Local nPeWtdbc    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_EX_NCM"})
	Local nPeXWtdbc    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_EX_NBM"})
	Local nPWtdbc    := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_ALI_WT"})
	Local nPRecndbc  := aScan(aHeader2,{|x| AllTrim(x[2]) == "DBC_REC_WT"})

	////var debug
	private aAuxCols := aCols   /////DBB
	private aAuxColsIt := aColsIt ///DBC

	//TRAER LOS DOCUMENTOS Y AÑADIR A LA ACOLS DE LA SF1
	getFactsF1(DBA->DBA_HAWB) ///paso actual despacho

	if !QRY_F1->(EoF())

		//RECORRER SF1 PARA ACOLS
		while !QRY_F1->(EoF())

			for i:= 1 to len(aCols)
				if alltrim(aCols[i][nPNota]) == alltrim(QRY_F1->F1_DOC) +"-DP" ////nos fijamos que no este jalado ya
					lSalto := .t.
					exit
				endif
			next i

			if ! lSalto ///si es falso
			///llenamos el acols
			cxItem := soma1(aCols[len(aCols)][nPItem])
			aadd(aCols,Array(Len(aHeader1)+1))  ///revisar si no metio una linea mas en blanco

			aCols[len(aCols)][nPFormu] := "2"
			aCols[len(aCols)][nPNota] := alltrim(QRY_F1->F1_DOC) +"-DP"
			aCols[len(aCols)][nPSerie] := QRY_F1->F1_SERIE
			aCols[len(aCols)][nPosTipo] := "A"   //GASTO 5 FOB ETC
			aCols[len(aCols)][nPEmissao] := dDataBase
			aCols[len(aCols)][nPosFornec] := QRY_F1->F1_FORNECE
			aCols[len(aCols)][nPLoja] := QRY_F1->F1_LOJA
			aCols[len(aCols)][nPCond] := QRY_F1->F1_COND
			aCols[len(aCols)][nPosMoeda] := QRY_F1->F1_MOEDA
			aCols[len(aCols)][nPosSimbol] := IIF(QRY_F1->F1_MOEDA == 1,"BS.","U$S"  )
			aCols[len(aCols)][nPosTxMoeda] := QRY_F1->F1_TXMOEDA
			aCols[len(aCols)][nPosUndb] := ""
			//aCols[len(aCols)][nPosUmon] := 0 	
			//aCols[len(aCols)][nPPolz] := "" 
			//aCols[len(aCols)][nPosUpoli] := ddatabase  		
			aCols[len(aCols)][nPosIncot] := "   "
			aCols[len(aCols)][nPItem] := cxItem
			aCols[len(aCols)][nPDesp] := 0
			aCols[len(aCols)][nPFrete] := 0
			aCols[len(aCols)][nPSegur] := 0
			aCols[len(aCols)][nPCodct] := ""
			aCols[len(aCols)][nPNuma] := ""
			aCols[len(aCols)][nPValb] := 0
			aCols[len(aCols)][nPDesc] := 0
			aCols[len(aCols)][nPPeso] := 0
			aCols[len(aCols)][nPOKks] := ""
			aCols[len(aCols)][nPWttt] := ""
			aCols[len(aCols)][nPRecn] := 0
			aCols[len(aCols)][Len(aHeader1)+1] := .f.

			//RECORRER SD1 PARA ACOLSIT
			////aColsIt primero lineas con la cantidad como la DBB luego la cantidad de items y luego su interior

			///cxItemdbc := soma1(aColsIt[len(aColsIt)][nPosItemC])
			aadd(aColsIt,{Array(Len(aHeader2)+1)})

			aColsIt[len(aColsIt)][1][nPosItemC] := "0001"
			aColsIt[len(aColsIt)][1][nPItDoc] := cxItem
			aColsIt[len(aColsIt)][1][nPosProd] := QRY_F1->D1_COD
			aColsIt[len(aColsIt)][1][nPosQtde] := QRY_F1->D1_QUANT
			aColsIt[len(aColsIt)][1][nPosUnit] := QRY_F1->D1_VUNIT
			aColsIt[len(aColsIt)][1][nPosTotal] := QRY_F1->D1_TOTAL
			aColsIt[len(aColsIt)][1][nPosNumPO] := ""
			aColsIt[len(aColsIt)][1][nPosItemPO] := ""
			aColsIt[len(aColsIt)][1][nPosTes] := SuperGetMv('MV_UTESDES',.f.,"330")
			aColsIt[len(aColsIt)][1][nPosTec] := ""//SuperGetMv('MV_UTESDES',.f.,"330")
			aColsIt[len(aColsIt)][1][nPosLoc] := QRY_F1->D1_LOCAL
			aColsIt[len(aColsIt)][1][nPosCon] := QRY_F1->D1_CONTA
			aColsIt[len(aColsIt)][1][nPosUme] := QRY_F1->D1_UM
			aColsIt[len(aColsIt)][1][nPosSegum] := QRY_F1->D1_SEGUM
			aColsIt[len(aColsIt)][1][nPosDescric] := SUBSTR(QRY_F1->D1_UDESC,1,30)
			aColsIt[len(aColsIt)][1][nPosUDu] := 0
			aColsIt[len(aColsIt)][1][nPosQtse] := 0 
			aColsIt[len(aColsIt)][1][nPosDatpf] := ddatabase
			aColsIt[len(aColsIt)][1][nPosCC] := ""			
			aColsIt[len(aColsIt)][1][nPosBasi] :=0
			aColsIt[len(aColsIt)][1][nPosBasi2] :=0
			aColsIt[len(aColsIt)][1][nPosBasi3] :=0
			aColsIt[len(aColsIt)][1][nPosBasi4] :=0
			aColsIt[len(aColsIt)][1][nPosBasi5] :=0
			aColsIt[len(aColsIt)][1][nPosBasi6] :=0
			aColsIt[len(aColsIt)][1][nPosBasi7] :=0
			aColsIt[len(aColsIt)][1][nPosBasi8] :=0
			aColsIt[len(aColsIt)][1][nPosBasi9] :=0
			
			aColsIt[len(aColsIt)][1][nPosAli1] :=0
			aColsIt[len(aColsIt)][1][nPosAli2] :=0
			aColsIt[len(aColsIt)][1][nPosAli3] :=0
			aColsIt[len(aColsIt)][1][nPosAli4] :=0
			aColsIt[len(aColsIt)][1][nPosAli5] :=0
			aColsIt[len(aColsIt)][1][nPosAli6] :=0
			aColsIt[len(aColsIt)][1][nPosAli7] :=0
			aColsIt[len(aColsIt)][1][nPosAli8] :=0
			aColsIt[len(aColsIt)][1][nPosAli9] :=0

			aColsIt[len(aColsIt)][1][nPosVli1] :=0
			aColsIt[len(aColsIt)][1][nPosVli2] :=0
			aColsIt[len(aColsIt)][1][nPosVli3] :=0
			aColsIt[len(aColsIt)][1][nPosVli4] :=0
			aColsIt[len(aColsIt)][1][nPosVli5] :=0
			aColsIt[len(aColsIt)][1][nPosVli6] :=0
			aColsIt[len(aColsIt)][1][nPosVli7] :=0
			aColsIt[len(aColsIt)][1][nPosVli8] :=0
			aColsIt[len(aColsIt)][1][nPosVli9] :=0
			

			aColsIt[len(aColsIt)][1][nPosVldes] :=0
			aColsIt[len(aColsIt)][1][nPosItca] := ""
			aColsIt[len(aColsIt)][1][nPosCVlde] := "" 
			aColsIt[len(aColsIt)][1][nPosSegu] := 0 				
			aColsIt[len(aColsIt)][1][nPosDespe] := 0
			aColsIt[len(aColsIt)][1][nPosValfr] := 0					
			aColsIt[len(aColsIt)][1][nPeWtdbc] := ""
			aColsIt[len(aColsIt)][1][nPWtdbc] := ""
			aColsIt[len(aColsIt)][1][nPeXWtdbc] := "" 
			aColsIt[len(aColsIt)][1][nPRecndbc] := 0
			aColsIt[len(aColsIt)][1][Len(aHeader2)+1] := .f.
			ENDIF

			QRY_F1->(DbSkip())
		enddo
	else
		MSGINFO( "No hay gastos para este despacho" , "AVISO:"  )
	endif

	QRY_F1->(DbCloseArea())

	RestArea(aArea)
return

static function getFactsF1(cUxhawb)
	Local cQuery	:= ""

	/*
	SELECT F1_UFLAG,F1_UFLAGRA,
	F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_COND,F1_MOEDA,F1_TXMOEDA,F1_UHAWB,* FROM SF1010
	WHERE F1_ESPECIE = 'NF' AND F1_UHAWB = ''
	AND F1_UFLAG <> 'S' AND F1_UFLAGRA <> 'S'*/

	If Select("QRY_F1") > 0
		dbCloseArea()
	Endif

	cQuery := " SELECT F1_UFLAGRA, "
	cQuery += " F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_COND,F1_MOEDA,F1_TXMOEDA,F1_UHAWB, "
	cQuery += " D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_LOCAL,D1_CONTA,D1_UM,D1_SEGUM,D1_UDESC "
	cQuery += " FROM "
	cQuery += " "+RetSQLName("SF1")+" SF1 "
	cQuery += " JOIN  "
	cQuery += " "+RetSQLName("SD1")+" SD1 "
	cQuery += " ON D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND F1_FILIAL = D1_FILIAL AND F1_FORNECE = D1_FORNECE "
	cQuery += " AND D1_LOJA = F1_LOJA AND D1_ESPECIE = 'NF' AND SD1.D_E_L_E_T_ = '' "
	cQuery += " WHERE F1_ESPECIE = 'NF' AND F1_UHAWB = '" + cUxhawb + "' AND SF1.D_E_L_E_T_ = '' AND F1_ESPECIE='NF' "
	cQuery += " AND F1_UFLAGRA <> 'S' AND F1_FILIAL = '" + xfilial("SF1") + "' AND SF1.D_E_L_E_T_ = '' "

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery New Alias "QRY_F1"

return
