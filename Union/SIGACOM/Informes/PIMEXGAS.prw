#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  PIMEXGAS ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Excel de importacion del detalle de gastos	              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PIMEXGAS()
	Local aArea        := GetArea()
	Local cQuery        := ""
	Local oExcel
	Local cArquivo    := GetTempPath()+'PIMEXGAS.xml'
	Private oFWMsExcel
	Private nSubBruto := 0
	Private nSubIva := 0
	Private nSubNeto := 0
	Private nSubBrutoDesp := 0
	Private nSubIvaDesp := 0
	Private nSubNetoDesp := 0
	Private nSubBrutoIns := 0
	Private nSubIvaIns := 0
	Private nSubNetoIns := 0
	Private nSubBrutoIns := 0
	Private nSubIvaIns := 0
	Private nSubNetoIns := 0
	Private nSubBrutoFle := 0
	Private nSubIvaFle := 0
	Private nSubNetoFle := 0
	Private nSubBrutoOtr := 0
	Private nSubIvaOtr := 0
	Private nSubNetoOtr := 0
	Private nTotBru := 0
	Private nTotIva := 0
	Private nTotNet := 0
	PRIVATE cPerg   := "IMPPERG"   // elija el Nombre de la pregunta
	Private nValDUA := 0

	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	oFWMsExcel := FWMSExcel():New()

	getDBA() ///obtiene el/los despachos

	cObse := VW_DBA->DBA_UOBSER

	cUcob := VW_DBA->A2_UCODFAB

	cOrg := VW_DBA->DBA_ORIGEM

	nValMer := VW_DBA->DBC_TOTAL

	cDoc := VW_DBA->DBA_HAWB  /// loja

	nTxMoe := VW_DBA->DBB_TXMOED

	fImpCab(VW_DBA->DBA_HAWB,VW_DBA->DBB_FORNEC,VW_DBA->A2_NOME,cUcob,cOrg)

	if ! VW_DBA->(EoF())  ////despachos

		While ! VW_DBA->(EoF())// percorre despachos

			if VW_DBA->DBA_HAWB != cDoc //si es otro documento salta de pagina
				//fImpRod(.t.,nTotBru,nTotIva,nTotNet,nValMer)//
				fImpCab(VW_DBA->DBA_HAWB,VW_DBA->DBB_FORNEC,VW_DBA->A2_NOME,cUcob,cOrg)
				cDoc := VW_DBA->DBA_HAWB
			endif

			/////////tributos
			getTributo(VW_DBA->DBA_HAWB)

			if ! VW_PIMP->(EoF())
				nSubBruto := 0
				nSubIva := 0
				nSubNeto := 0

				While ! VW_PIMP->(EoF())

					nBruto := xMoeda(VW_PIMP->DBC_TOTAL,VW_PIMP->DBB_MOEDA,1,,2,VW_PIMP->DBB_TXMOED)

					nValDUA+= nBruto

					nIva := xMoeda(VW_PIMP->DBC_TOTAL,VW_PIMP->DBB_MOEDA,1,,2,VW_PIMP->DBB_TXMOED)
					nNeto := nBruto - nIva				
					
					oFWMsExcel:AddRow("Detalle Gastos","Gastos",{ VW_PIMP->TIPO , VW_PIMP->DBC_DESCRI , VW_PIMP->DBB_FORNEC , VW_PIMP->A2_NOME  ,;
					VW_PIMP->DBB_DOC  , DTOC(SToD(VW_PIMP->DBB_EMISSA)) , nBruto ,;
					IIF(MV_PAR04 == 1,nIva,VW_PIMP->DBB_SIMBOL+" "+ ALLTRIM(TRANSFORM(VW_PIMP->DBB_TXMOED,"@E 9,999,999.99"))) ,;
					IIF(MV_PAR04 == 1,nNeto,xMoeda(nBruto,1,2,,2,VW_PIMP->DBB_TXMOED) )})

					VW_PIMP->(DbSkip())
				enddo
				VW_PIMP->(DbCloseArea())

			Endif
			////////////////////////////////acaba tributo

			getDespacho(VW_DBA->DBA_HAWB)
			//Despacho
			if ! VW_DESP->(EoF())
				nSubBrutoDesp := 0
				nSubIvaDesp := 0
				nSubNetoDesp := 0
				While ! VW_DESP->(EoF())

					nBruto := xMoeda(VW_DESP->DBC_TOTAL,VW_DESP->DBB_MOEDA,1,,2,VW_DESP->DBB_TXMOED)

					nValDUA+= nBruto

					nIva := xMoeda(VW_DESP->DBC_VLIMP1,VW_DESP->DBB_MOEDA,1,,2,VW_DESP->DBB_TXMOED)					
					
					nNeto := nBruto - nIva
					
					oFWMsExcel:AddRow("Detalle Gastos","Gastos",{ VW_DESP->TIPO , VW_DESP->DBC_DESCRI , VW_DESP->DBB_FORNEC , VW_DESP->A2_NOME  ,;
					VW_DESP->DBB_DOC  , DTOC(SToD(VW_DESP->DBB_EMISSA)) , nBruto ,;
					IIF(MV_PAR04 == 1,nIva,VW_DESP->DBB_SIMBOL+" "+ ALLTRIM(TRANSFORM(VW_DESP->DBB_TXMOED,"@E 9,999,999.99"))) ,;
					IIF(MV_PAR04 == 1,nNeto,xMoeda(nBruto,1,2,,2,VW_DESP->DBB_TXMOED) )})

					VW_DESP->(DbSkip())
				enddo
			Endif
			//////////acaba despacho

			getInstitu(VW_DBA->DBA_HAWB)
			//Despacho
			if ! VW_INST->(EoF())
				nSubBrutoIns := 0
				nSubIvaIns := 0
				nSubNetoIns := 0
				While ! VW_INST->(EoF())

					nBruto := xMoeda(VW_INST->DBC_TOTAL,VW_INST->DBB_MOEDA,1,,2,VW_INST->DBB_TXMOED)

					nValDUA+= nBruto

					nIva := xMoeda(VW_INST->DBC_VLIMP1,VW_INST->DBB_MOEDA,1,,2,VW_INST->DBB_TXMOED)
					nNeto := nBruto - nIva

					oFWMsExcel:AddRow("Detalle Gastos","Gastos",{ VW_INST->TIPO , VW_INST->DBC_DESCRI , VW_INST->DBB_FORNEC , VW_INST->A2_NOME  ,;
					VW_INST->DBB_DOC  , DTOC(SToD(VW_INST->DBB_EMISSA)) , nBruto ,;
					IIF(MV_PAR04 == 1,nIva,VW_INST->DBB_SIMBOL+" "+ ALLTRIM(TRANSFORM(VW_INST->DBB_TXMOED,"@E 9,999,999.99"))) ,;
					IIF(MV_PAR04 == 1,nNeto,xMoeda(nBruto,1,2,,2,VW_INST->DBB_TXMOED) )})

					VW_INST->(DbSkip())
				enddo
			Endif
			////////////acaba institucional

			getFlete(VW_DBA->DBA_HAWB)
			//Despacho
			if ! VW_FLET->(EoF())
				nSubBrutoFle := 0
				nSubIvaFle := 0
				nSubNetoFle := 0
				While ! VW_FLET->(EoF())

					nBruto := xMoeda(VW_FLET->DBC_TOTAL,VW_FLET->DBB_MOEDA,1,,2,VW_FLET->DBB_TXMOED)

					nValDUA+= nBruto

					nIva := xMoeda(VW_FLET->DBC_VLIMP1,VW_FLET->DBB_MOEDA,1,,2,VW_FLET->DBB_TXMOED)
					nNeto := nBruto - nIva

					oFWMsExcel:AddRow("Detalle Gastos","Gastos",{ VW_FLET->TIPO , VW_FLET->DBC_DESCRI , VW_FLET->DBB_FORNEC , VW_FLET->A2_NOME  ,;
					VW_FLET->DBB_DOC  , DTOC(SToD(VW_FLET->DBB_EMISSA)) , nBruto ,;
					IIF(MV_PAR04 == 1,nIva,VW_FLET->DBB_SIMBOL+" "+ ALLTRIM(TRANSFORM(VW_FLET->DBB_TXMOED,"@E 9,999,999.99"))) ,;
					IIF(MV_PAR04 == 1,nNeto,xMoeda(nBruto,1,2,,2,VW_FLET->DBB_TXMOED) )})

					VW_FLET->(DbSkip())
				enddo

			Endif
			//////////// acaba flete

			getOtros(VW_DBA->DBA_HAWB)
			//Despacho
			if ! VW_OTRR->(EoF())
				nSubBrutoOtr := 0
				nSubIvaOtr := 0
				nSubNetoOtr := 0
				While ! VW_OTRR->(EoF())

					nBruto := xMoeda(VW_OTRR->DBC_TOTAL,VW_OTRR->DBB_MOEDA,1,,2,VW_OTRR->DBB_TXMOED)

					nValDUA+= nBruto

					nIva := xMoeda(VW_OTRR->DBC_VLIMP1,VW_OTRR->DBB_MOEDA,1,,2,VW_OTRR->DBB_TXMOED)
					nNeto := nBruto - nIva

					oFWMsExcel:AddRow("Detalle Gastos","Gastos",{ VW_OTRR->TIPO , VW_OTRR->DBC_DESCRI , VW_OTRR->DBB_FORNEC , VW_OTRR->A2_NOME  ,;
					VW_OTRR->DBB_DOC  , DTOC(SToD(VW_OTRR->DBB_EMISSA)) , nBruto ,;
					IIF(MV_PAR04 == 1,nIva,VW_OTRR->DBB_SIMBOL+" "+ ALLTRIM(TRANSFORM(VW_OTRR->DBB_TXMOED,"@E 9,999,999.99"))) ,;
					IIF(MV_PAR04 == 1,nNeto,xMoeda(nBruto,1,2,,2,VW_OTRR->DBB_TXMOED) )})

					VW_OTRR->(DbSkip())
				enddo

			Endif
			////////////acaba otros

			VW_DBA->(DbSkip())
		enddo
	endif

	//activando y generando
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//abriendo excel
	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open(cArquivo)//abre planilla
	oExcel:SetVisible(.T.)                 //Visualiza a planilla
	oExcel:Destroy()                        //cierra processo

	VW_DBA->(DbCloseArea())
	RestArea(aArea)
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De documento ?","De documento ?","De documento ?","mv_ch1","C",17,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A documento ?","A documento ?","A documento ?","mv_ch2","C",17,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","Sucursal ?","Sucursal ?","Sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	//xPutSx1(cPerg,"04","A sucursal ?","A sucursal ?","A sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	/*xPutSx1(cPerg,"07","De fecha ?","De fecha ?","De fecha ?",         "mv_ch5","D",08,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")*/
	xPutSX1(cPerg,"04","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par04","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")

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

static function fimpcab(cDoc,cProv,cProvDes,cUcob,cOrg)

	//anhade hoja
	oFWMsExcel:AddworkSheet("Detalle Cabecera")

	oFWMsExcel:AddTable("Detalle Cabecera","Cabecera")
	oFWMsExcel:AddColumn("Detalle Cabecera","Cabecera","Sucursal",1)
	oFWMsExcel:AddColumn("Detalle Cabecera","Cabecera","Numero OC",1)
	oFWMsExcel:AddColumn("Detalle Cabecera","Cabecera","Proveedor",1)

	oFWMsExcel:AddRow("Detalle Cabecera","Cabecera",{ Alltrim(SM0->M0_NOME)+ " / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL) ;
	,cDoc + space(10) + cUcob + space(7) + cOrg,cProv + space(20) + cProvDes})

	//creando tabla
	oFWMsExcel:AddworkSheet("Detalle Gastos")
	oFWMsExcel:AddTable("Detalle Gastos","Gastos")
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos","Gasto",1)
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos","Descripcion",1)
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos","Cod Proveedor",1)
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos","Proveedor",1)
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos","Nro Documento",1)
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos","Fecha",1)
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos",IIF(MV_PAR04==1,"Bruto(Bs)","Monto"),2,2)
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos", IIF (MV_PAR04==1,"IVA(Bs)","Mon TC"),2,2)
	oFWMsExcel:AddColumn("Detalle Gastos","Gastos",IIF(MV_PAR04==1,"NETO(Bs)","Monto USD"),2,2)

return

static function getDBA()
	Local cQuery	:= ""

	If Select("VW_DBA") > 0
		dbCloseArea()
	Endif

	/*SELECT 'TRIBUTO ADUANERO',DBC.DBC_DESCRI,DBB.DBB_DOC,DBB.DBB_EMISSA,DBC.DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED FROM DBC010 DBC
	JOIN DBB010 DBB
	ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'D' AND DBB.D_E_L_E_T_ = ''
	WHERE DBC_HAWB BETWEEN 'OC/077/19/A' AND 'OC/077/19/A'
	AND DBC.DBC_QUANT = 0 AND DBC.DBC_UVALDU > 0
	AND DBC.D_E_L_E_T_ =' '*/

	cQuery := "	SELECT DISTINCT DBA_HAWB,DBB_FORNEC,A2_NOME,DBA_UOBSER,SUM(DBC_TOTAL) DBC_TOTAL,DBB_TXMOED,A2_UCODFAB,DBA_ORIGEM "
	cQuery += " FROM " + RetSqlName("DBA") + " DBA "
	cQuery += " LEFT JOIN " + RetSqlName("DBB") + " DBB "
	cQuery += " ON DBB.DBB_FILIAL = DBA.DBA_FILIAL AND DBB.DBB_HAWB = DBA.DBA_HAWB AND DBB.DBB_TIPONF = '5' AND DBB.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("DBC") + " DBC "
	cQuery += " ON DBC_ITDOC = DBB_ITEM AND DBC_FILIAL = DBB_FILIAL AND DBB_HAWB = DBC_HAWB AND DBC.D_E_L_E_T_ = ''"
	cQuery += " WHERE DBA_HAWB BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND DBA.D_E_L_E_T_ =' ' AND DBA_FILIAL = '" + MV_PAR03 + "' "
	cQuery += " GROUP BY DBA_HAWB,DBB_FORNEC,A2_NOME,DBA_UOBSER,DBB_TXMOED,A2_UCODFAB,DBA_ORIGEM ORDER BY DBA_HAWB "

	TCQuery cQuery New Alias "VW_DBA"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getTributo(cHawb)
	Local cQuery	:= ""

	If Select("VW_PIMP") > 0
		dbSelectArea("VW_PIMP")
		dbCloseArea()
	Endif

	/*SELECT 'TRIBUTO ADUANERO',DBC.DBC_DESCRI,DBB.DBB_DOC,DBB.DBB_EMISSA,DBC.DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED FROM DBC010 DBC
	JOIN DBB010 DBB
	ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'D' AND DBB.D_E_L_E_T_ = ''
	WHERE DBC_HAWB BETWEEN 'OC/077/19/A' AND 'OC/077/19/A'
	AND DBC.DBC_QUANT = 0 AND DBC.DBC_UVALDU > 0
	AND DBC.D_E_L_E_T_ =' '*/

	cQuery := "	SELECT DBC_CODPRO TIPO,DBC_UVALDU,DBB_FORNEC,DBC_VLIMP1,DBC_DESCRI,DBB_SERIE,DBB_LOJA,DBB_FORNEC,DBB_HAWB,DBB_DOC,DBB_EMISSA,DBC_UVALDU DBC_TOTAL,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED,A2_NOME "
	cQuery += "  FROM " + RetSqlName("DBC") + " DBC "
	cQuery += "  JOIN " + RetSqlName("DBB") + " DBB "
	cQuery += "  ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'D' AND DBB_ITEM =DBC_ITDOC AND DBB.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += "  WHERE DBC_HAWB BETWEEN '" + cHawb + "' AND '" + cHawb + "' "
	cQuery += "  AND DBC.DBC_QUANT = 0 AND DBC.DBC_UVALDU > 0 AND DBC.D_E_L_E_T_ =' ' AND DBC_FILIAL = '" + MV_PAR03 + "' ORDER BY DBB_ITEM"

	TCQuery cQuery New Alias "VW_PIMP"

	Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getDespacho(cHawb)
	Local cQuery	:= ""

	If Select("VW_DESP") > 0
		dbSelectArea("VW_DESP")
		dbCloseArea()
	Endif
	/*
	SELECT 'DESPACHO ADUANERO'TIPO,DBC.DBC_CODPRO,DBC.DBC_DESCRI,DBB.DBB_DOC,DBB.DBB_EMISSA,DBC.DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED,DBC.DBC_ITDOC
	FROM DBC010 DBC
	JOIN DBB010 DBB
	ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND  DBB.DBB_TIPONF = 'A'
	AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.D_E_L_E_T_ = ''
	WHERE DBC_HAWB BETWEEN 'OC/077/19/A' AND 'OC/077/19/A'
	AND DBC.DBC_CODPRO IN ('GI0007','GI0008','GI0012','GI0004',
	'GI0009')
	AND DBC.D_E_L_E_T_ =' '*/

	cQuery := "	SELECT DBC_CODPRO TIPO,DBB_FORNEC,DBB_EMISSA,CASE DBC_TES WHEN '330' THEN '0' ELSE DBC.DBC_TOTAL END  DBC_TOTAL,DBB_MOEDA,DBB_SIMBOL, "
	cQuery += " DBB_TXMOED,DBC_ITDOC,DBC_VLIMP1,DBC_CODPRO,DBC_DESCRI,DBB_DOC,A2_NOME "
	cQuery += " FROM " + RetSqlName("DBC") + " DBC "
	cQuery += " JOIN " + RetSqlName("DBB") + " DBB "
	cQuery += " ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND  DBB.DBB_TIPONF = 'A' "
	cQuery += " AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += "  WHERE DBC_HAWB BETWEEN '" + cHawb + "' AND '" + cHawb + "' AND DBC.D_E_L_E_T_ =' ' "
	cQuery += "  AND DBC.DBC_CODPRO IN ('GI0007','GI0008','GI0012','GI0004','GI0009') AND DBC_FILIAL = '" + MV_PAR03 + "'  ORDER BY DBB_ITEM"

	TCQuery cQuery New Alias "VW_DESP"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getInstitu(cHawb)
	Local cQuery	:= ""

	If Select("VW_INST") > 0
		dbSelectArea("VW_INST")
		dbCloseArea()
	Endif

	/*
	SELECT 'INSTITUCIONAL'TIPO,DBC.DBC_CODPRO,DBC.DBC_DESCRI,DBB.DBB_DOC,DBB.DBB_EMISSA,DBC.DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED,DBC.DBC_ITDOC
	FROM DBC010 DBC
	JOIN DBB010 DBB
	ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'A'
	AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.D_E_L_E_T_ = ''
	WHERE DBC_HAWB BETWEEN 'OC/077/19/A' AND 'OC/077/19/A'
	AND DBC.DBC_CODPRO = 'GI0014'
	AND DBC.D_E_L_E_T_ =' '
	*/

	cQuery := "	SELECT DBC_CODPRO TIPO,DBB_FORNEC,DBC_VLIMP1,DBC_CODPRO,DBC_DESCRI,DBB_DOC,DBB_EMISSA,CASE DBC_TES WHEN '330' THEN '0' ELSE DBC.DBC_TOTAL END  DBC_TOTAL "
	cQuery += " ,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED,DBC_ITDOC,A2_NOME  "
	cQuery += " FROM " + RetSqlName("DBC") + " DBC "
	cQuery += " JOIN " + RetSqlName("DBB") + " DBB "
	cQuery += " ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'A' "
	cQuery += " AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.D_E_L_E_T_ = ''"
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += "  WHERE DBC_HAWB BETWEEN '" + cHawb + "' AND '" + cHawb + "' "
	cQuery += "  AND DBC.DBC_CODPRO = 'GI0014' AND DBC.D_E_L_E_T_ =' ' AND DBC_FILIAL = '" + MV_PAR03 + "' ORDER BY DBB_ITEM"

	TCQuery cQuery New Alias "VW_INST"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getFlete(cHawb)
	Local cQuery	:= ""

	If Select("VW_FLET") > 0
		dbSelectArea("VW_FLET")
		dbCloseArea()
	Endif
	/*
	SELECT 'FLETE'TIPO,DBC.DBC_CODPRO,DBC.DBC_DESCRI,DBB.DBB_DOC,DBB.DBB_EMISSA,DBC.DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED,DBC.DBC_ITDOC
	FROM DBC010 DBC
	JOIN DBB010 DBB
	ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'A'
	AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.D_E_L_E_T_ = ''
	WHERE DBC_HAWB BETWEEN 'OC/077/19/A' AND 'OC/077/19/A'
	AND DBC.DBC_CODPRO IN ('GI0016','GI0017','GI0018')
	AND DBC.D_E_L_E_T_ =' '
	*/
	cQuery := "	SELECT DBC_CODPRO TIPO,DBB_FORNEC,DBC_VLIMP1,DBC_CODPRO,DBC_DESCRI,DBB_DOC,DBB_EMISSA,CASE DBC_TES WHEN '330' THEN '0' ELSE DBC.DBC_TOTAL END  DBC_TOTAL,DBB_MOEDA "
	cQuery += " ,DBB_SIMBOL,DBB_TXMOED,DBC_ITDOC,A2_NOME "
	cQuery += "  FROM " + RetSqlName("DBC") + " DBC "
	cQuery += "  JOIN " + RetSqlName("DBB") + " DBB "
	cQuery += "  ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'A' "
	cQuery += "  AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += "  WHERE DBC_HAWB BETWEEN '" + cHawb + "' AND '" + cHawb + "' "
	cQuery += "  AND DBC.DBC_CODPRO IN ('GI0016','GI0017','GI0018') AND DBC.D_E_L_E_T_ =' ' AND DBC_FILIAL = '" + MV_PAR03 + "' ORDER BY DBB_ITEM"

	TCQuery cQuery New Alias "VW_FLET"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getOtros(cHawb)
	Local cQuery	:= ""

	If Select("VW_OTRR") > 0
		dbSelectArea("VW_OTRR")
		dbCloseArea()
	Endif

	/*
	SELECT 'OTRO'TIPO,DBC.DBC_CODPRO,DBC.DBC_DESCRI,DBB.DBB_DOC,DBB.DBB_EMISSA,DBC.DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED,DBC.DBC_ITDOC
	FROM DBC010 DBC
	JOIN DBB010 DBB
	ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'A'
	AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.D_E_L_E_T_ = ''
	WHERE DBC_HAWB BETWEEN 'OC/077/19/A' AND 'OC/077/19/A'
	AND DBC.DBC_CODPRO NOT IN ('GI0016','GI0017','GI0018','GI0014','GI0004','GI0007','GI0008','GI0009','GI0012')
	AND DBC.D_E_L_E_T_ =' '
	*/

	cQuery := "	SELECT DBC_CODPRO TIPO,DBB_FORNEC,DBC_VLIMP1,DBC_CODPRO,DBC_DESCRI,DBB_DOC,DBB_EMISSA,CASE DBC_TES WHEN '330' THEN '0' ELSE DBC.DBC_TOTAL END  DBC_TOTAL, "
	cQuery += " DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED,DBC_ITDOC,A2_NOME "
	cQuery += " FROM " + RetSqlName("DBC") + " DBC "
	cQuery += " JOIN " + RetSqlName("DBB") + " DBB "
	cQuery += " ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'A' "
	cQuery += " AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += " WHERE DBC_HAWB BETWEEN '" + cHawb + "' AND '" + cHawb + "' "
	cQuery += " AND DBC.DBC_CODPRO NOT IN ('GI0016','GI0017','GI0018','GI0014','GI0004','GI0007','GI0008','GI0009','GI0012') "
	cQuery += " AND DBC.D_E_L_E_T_ =' ' AND DBC_FILIAL = '" + MV_PAR03 + "' ORDER BY DBB_ITEM "

	TCQuery cQuery New Alias "VW_OTRR"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return