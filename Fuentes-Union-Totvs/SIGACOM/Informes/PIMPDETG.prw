#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"
//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Colunas
#Define COL_GRUPO  0015
#Define COL_DESCR  0045
#Define COL_PROV  0180
#Define COL_PROVDES  0220
#Define	COL_SUBLOTE	0250
#Define	COL_NRODOC	0310
#Define	COL_FECHA 0380
#Define COL_BRUTO 0430
#Define COL_IVA 0530
#Define COL_NETO 0630

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  MOVINT  ºAutor  ³ERICK ETCHEVERRY º   º Date 07/09/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Movimientos internos resumido                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PIMPDETG()
	LOCAL cString		:= "SD3"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Movimientos internos resumido"
	LOCAL cDesc1	    := "Relatorio de mov. Internos resumen"
	LOCAL cDesc2	    := "conforme parametro"
	LOCAL cDesc3	    := "Especifico UNION"
	Local cObse := ""
	Private nValMer := 0
	Private nValGas := 0
	Private nTxMoe := 0
	Private nValDUA := 0
	PRIVATE nomeProg 	:= "PIMPDETG"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Courier New"
	Private oFontDet  := TFont():New(cNomeFont,07,07,,.F.,,,,.T.,.F.)
	Private oFontDetN := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontDetNN := TFont():New(cNomeFont,012,012,,.T.,,,,.F.,.F.)
	Private oFontRod  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTit  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTitt:= TFont():New(cNomeFont,015,015,,.T.,,,,.F.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0
	PRIVATE cPerg   := "IMPPERG"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	/*If funname() == 'MATA241'
	Pergunte(cPerg,.F.)
	Else
	Pergunte(cPerg,.T.)
	Endif*/

	Processa({ |lEnd| MOVD3CONF("Impresion de detalle gastos")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'movinterno'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zTstRQl_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
	//Criando o objeto do FMSPrinter
	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrint, "", , , , .T.)

	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetLandscape()
	oPrint:SetPaperSize(1)
	oPrint:SetMargin(60, 60, 60, 60)

Return Nil

Static Function fImpPres(lEnd,WnRel,cString,nReg)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local nTotal := 0
	Local lRetCF := .f.
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 530
	Private nColIni   := 010
	Private nColFin   := 730
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
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

	getDBA()
	cObse := VW_DBA->DBA_UOBSER
	
	cUcob := VW_DBA->A2_UCODFAB
	
	cOrg := VW_DBA->DBA_ORIGEM
	
	nValMer := VW_DBA->DBC_TOTAL

	cDoc := VW_DBA->DBA_HAWB  /// loja

	nTxMoe := VW_DBA->DBB_TXMOED

	fImpCab(VW_DBA->DBA_HAWB,VW_DBA->DBB_FORNEC,VW_DBA->A2_NOME,cUcob,cOrg)

	if ! VW_DBA->(EoF())

		While ! VW_DBA->(EoF())

			if VW_DBA->DBA_HAWB != cDoc //si es otro documento salta de pagina
				fImpRod(.t.,nTotBru,nTotIva,nTotNet,nValMer)//
				fImpCab(VW_DBA->DBA_HAWB,VW_DBA->DBB_FORNEC,VW_DBA->A2_NOME,cUcob,cOrg)
				cDoc := VW_DBA->DBA_HAWB
			else
				If nLinAtu + nTamLin > nLinFin
					fImpRod()//
					fImpCab(VW_DBA->DBA_HAWB,VW_DBA->DBB_FORNEC,VW_DBA->A2_NOME,cUcob,cOrg)
				EndIf
				cDoc := VW_DBA->DBA_HAWB
			endif

			getTributo(VW_DBA->DBA_HAWB)
			//Tributo
			if ! VW_PIMP->(EoF())
				nSubBruto := 0
				nSubIva := 0
				nSubNeto := 0

				While ! VW_PIMP->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab()//CABEC
					EndIf

					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_PIMP->TIPO,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_DESCR, VW_PIMP->DBC_DESCRI ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROV, VW_PIMP->DBB_FORNEC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu,COL_PROVDES,  SUBSTR(VW_PIMP->A2_NOME,1,20) ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NRODOC, VW_PIMP->DBB_DOC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_FECHA, DTOC(SToD(VW_PIMP->DBB_EMISSA)) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nBruto := xMoeda(VW_PIMP->DBC_TOTAL,VW_PIMP->DBB_MOEDA,1,,2,VW_PIMP->DBB_TXMOED)

					nValDUA+= nBruto

					nIva := xMoeda(VW_PIMP->DBC_TOTAL,VW_PIMP->DBB_MOEDA,1,,2,VW_PIMP->DBB_TXMOED)
					nNeto := nBruto - nIva

					oPrint:SayAlign(nLinAtu, COL_BRUTO,ALLTRIM(TRANSFORM(nBruto,"@E 9,999,999.99"));
					, oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_IVA, IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM(nIva,"@E 9,999,999.99")),VW_PIMP->DBB_SIMBOL+" "+ ;
					ALLTRIM(TRANSFORM(VW_PIMP->DBB_TXMOED,"@E 9,999,999.99"))),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_NETO,IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM((nNeto),"@E 9,999,999.99"));
					,ALLTRIM(TRANSFORM(xMoeda(nBruto,1,2,,2,VW_PIMP->DBB_TXMOED),"@E 9,999,999.99")) ) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:Box( nLinAtu, COL_DESCR, nLinAtu+020, COL_DESCR, "-2")
					oPrint:Box( nLinAtu, COL_PROV, nLinAtu+020, COL_PROV, "-2")
					oPrint:Box( nLinAtu, COL_PROVDES, nLinAtu+020, COL_PROVDES, "-2")
					oPrint:Box( nLinAtu, COL_NRODOC, nLinAtu+020, COL_NRODOC, "-2")
					oPrint:Box( nLinAtu, COL_FECHA, nLinAtu+020, COL_FECHA, "-2")
					oPrint:Box( nLinAtu, COL_BRUTO, nLinAtu+020, COL_BRUTO, "-2")
					oPrint:Box( nLinAtu, COL_IVA, nLinAtu+020, COL_IVA, "-2")
					oPrint:Box( nLinAtu, COL_NETO, nLinAtu+020, COL_NETO, "-2")

					nLinAtu += nTamLin
					//Subtotais
					nSubBruto += nBruto
					nSubIva += nIva
					nSubNeto += nNeto

					VW_PIMP->(DbSkip())
				enddo
				nLinAtu -= nTamLin
				nLinAtu += (nTamLin * 2)
				oPrint:SayAlign(nLinAtu, 210, "SUBTOTAL: TRIBUTO ADUANERO",     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				if MV_PAR04 == 2
					nSubBruto := xMoeda(nSubBruto,1,2,,2,nTxMoe)
					nSubIva := xMoeda(nSubIva,1,2,,2,nTxMoe)
					nSubNeto := xMoeda(nSubNeto,1,2,,2,nTxMoe)
				ENDIF

				IF MV_PAR04 == 1
					oPrint:SayAlign(nLinAtu, COL_BRUTO, ALLTRIM(TRANSFORM(nSubBruto,"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_IVA, ALLTRIM(TRANSFORM(nSubIva,"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM(nSubNeto,"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				else
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM(nSubBruto,"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				ENDIF

				nTotBru += nSubBruto
				nTotIva += nSubIva
				nTotNet += nSubNeto

				nLinAtu += (nTamLin * 2)
			Endif
			//acaba tributo
			getDespacho(VW_DBA->DBA_HAWB)
			//Despacho
			if ! VW_DESP->(EoF())
				nSubBrutoDesp := 0
				nSubIvaDesp := 0
				nSubNetoDesp := 0
				While ! VW_DESP->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab()//CABEC
					EndIf

					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_DESP->TIPO,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_DESCR, VW_DESP->DBC_DESCRI ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROV, VW_DESP->DBB_FORNEC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROVDES, SUBSTR(VW_DESP->A2_NOME,1,20) ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NRODOC, VW_DESP->DBB_DOC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_FECHA, DTOC(SToD(VW_DESP->DBB_EMISSA)) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nBruto := xMoeda(VW_DESP->DBC_TOTAL,VW_DESP->DBB_MOEDA,1,,2,VW_DESP->DBB_TXMOED)
					nIva := xMoeda(VW_DESP->DBC_VLIMP1,VW_DESP->DBB_MOEDA,1,,2,VW_DESP->DBB_TXMOED)
					nNeto := nBruto - nIva

					oPrint:SayAlign(nLinAtu, COL_BRUTO,ALLTRIM(TRANSFORM(nBruto,"@E 9,999,999.99"));
					, oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_IVA, IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM(nIva,"@E 9,999,999.99")),VW_DESP->DBB_SIMBOL+" "+ ;
					ALLTRIM(TRANSFORM(VW_DESP->DBB_TXMOED,"@E 9,999,999.99"))),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_NETO,IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM((nNeto),"@E 9,999,999.99"));
					,ALLTRIM(TRANSFORM(xMoeda(nBruto,1,2,,2,VW_DESP->DBB_TXMOED),"@E 9,999,999.99")) ) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:Box( nLinAtu, COL_DESCR, nLinAtu+020, COL_DESCR, "-2")
					oPrint:Box( nLinAtu, COL_PROV, nLinAtu+020, COL_PROV, "-2")
					oPrint:Box( nLinAtu, COL_PROVDES, nLinAtu+020, COL_PROVDES, "-2")
					oPrint:Box( nLinAtu, COL_NRODOC, nLinAtu+020, COL_NRODOC, "-2")
					oPrint:Box( nLinAtu, COL_FECHA, nLinAtu+020, COL_FECHA, "-2")
					oPrint:Box( nLinAtu, COL_BRUTO, nLinAtu+020, COL_BRUTO, "-2")
					oPrint:Box( nLinAtu, COL_IVA, nLinAtu+020, COL_IVA, "-2")
					oPrint:Box( nLinAtu, COL_NETO, nLinAtu+020, COL_NETO, "-2")

					nLinAtu += nTamLin

					nSubBrutoDesp += nBruto
					nSubIvaDesp += nIva
					nSubNetoDesp += nNeto

					VW_DESP->(DbSkip())
				enddo
				nLinAtu -= nTamLin
				nLinAtu += (nTamLin * 2)
				oPrint:SayAlign(nLinAtu, 210, "SUBTOTAL: DESPACHO ADUANERO",     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				nValGas += nSubBrutoDesp

				if MV_PAR04 == 2
					nSubBrutoDesp := xMoeda(nSubBrutoDesp,1,2,,2,nTxMoe)
					nSubIvaDesp := xMoeda(nSubIvaDesp,1,2,,2,nTxMoe)
					nSubNetoDesp := xMoeda(nSubNetoDesp,1,2,,2,nTxMoe)
				ENDIF

				IF MV_PAR04 == 1
					oPrint:SayAlign(nLinAtu, COL_BRUTO, ALLTRIM(TRANSFORM(nSubBrutoDesp,"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_IVA, ALLTRIM(TRANSFORM(nSubIvaDesp,"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM(nSubNetoDesp,"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				else
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM(nSubBrutoDesp,"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				ENDIF

				nLinAtu += (nTamLin * 2)

				nTotBru += nSubBrutoDesp
				nTotIva += nSubIvaDesp
				nTotNet += nSubNetoDesp
			Endif
			//acaba tributo
			getInstitu(VW_DBA->DBA_HAWB)
			//Despacho
			if ! VW_INST->(EoF())
				nSubBrutoIns := 0
				nSubIvaIns := 0
				nSubNetoIns := 0
				While ! VW_INST->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab()//CABEC
					EndIf

					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_INST->TIPO,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_DESCR, VW_INST->DBC_DESCRI ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROV, VW_INST->DBB_FORNEC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROVDES, SUBSTR(VW_INST->A2_NOME,1,20) ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NRODOC, VW_INST->DBB_DOC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_FECHA, DTOC(SToD(VW_INST->DBB_EMISSA)) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nBruto := xMoeda(VW_INST->DBC_TOTAL,VW_INST->DBB_MOEDA,1,,2,VW_INST->DBB_TXMOED)
					nIva := xMoeda(VW_INST->DBC_VLIMP1,VW_INST->DBB_MOEDA,1,,2,VW_INST->DBB_TXMOED)
					nNeto := nBruto - nIva

					oPrint:SayAlign(nLinAtu, COL_BRUTO,ALLTRIM(TRANSFORM(nBruto,"@E 9,999,999.99"));
					, oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_IVA, IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM(nIva,"@E 9,999,999.99")),VW_INST->DBB_SIMBOL+" "+ ;
					ALLTRIM(TRANSFORM(VW_INST->DBB_TXMOED,"@E 9,999,999.99"))),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_NETO,IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM((nNeto),"@E 9,999,999.99"));
					,ALLTRIM(TRANSFORM(xMoeda(nBruto,1,2,,2,VW_INST->DBB_TXMOED),"@E 9,999,999.99")) ) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:Box( nLinAtu, COL_DESCR, nLinAtu+020, COL_DESCR, "-2")
					oPrint:Box( nLinAtu, COL_PROV, nLinAtu+020, COL_PROV, "-2")
					oPrint:Box( nLinAtu, COL_PROVDES, nLinAtu+020, COL_PROVDES, "-2")
					oPrint:Box( nLinAtu, COL_NRODOC, nLinAtu+020, COL_NRODOC, "-2")
					oPrint:Box( nLinAtu, COL_FECHA, nLinAtu+020, COL_FECHA, "-2")
					oPrint:Box( nLinAtu, COL_BRUTO, nLinAtu+020, COL_BRUTO, "-2")
					oPrint:Box( nLinAtu, COL_IVA, nLinAtu+020, COL_IVA, "-2")
					oPrint:Box( nLinAtu, COL_NETO, nLinAtu+020, COL_NETO, "-2")

					nLinAtu += nTamLin

					nSubBrutoIns += nBruto
					nSubIvaIns += nIva
					nSubNetoIns += nNeto

					VW_INST->(DbSkip())
				enddo
				nLinAtu -= nTamLin
				nLinAtu += (nTamLin * 2)
				oPrint:SayAlign(nLinAtu, 210, "SUBTOTAL: INSTITUCIONAL",     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nValGas += nSubBrutoIns

				if MV_PAR04 == 2
					nSubBrutoIns := xMoeda(nSubBrutoIns,1,2,,2,nTxMoe)
					nSubIvaIns := xMoeda(nSubIvaIns,1,2,,2,nTxMoe)
					nSubNetoIns := xMoeda(nSubNetoIns,1,2,,2,nTxMoe)
				ENDIF

				IF MV_PAR04 == 1
					oPrint:SayAlign(nLinAtu, COL_BRUTO, ALLTRIM(TRANSFORM((nSubBrutoIns),"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_IVA, ALLTRIM(TRANSFORM((nSubIvaIns),"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM((nSubNetoIns),"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				else
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM((nSubBrutoIns),"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				ENDIF

				nLinAtu += (nTamLin * 2)

				nTotBru += nSubBrutoIns
				nTotIva += nSubIvaIns
				nTotNet += nSubNetoIns
			Endif
			//acaba tributo
			getFlete(VW_DBA->DBA_HAWB)
			//Despacho
			if ! VW_FLET->(EoF())
				nSubBrutoFle := 0
				nSubIvaFle := 0
				nSubNetoFle := 0
				While ! VW_FLET->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab()//CABEC
					EndIf

					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_FLET->TIPO,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_DESCR, VW_FLET->DBC_DESCRI ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROV, VW_FLET->DBB_FORNEC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROVDES, SUBSTR(VW_FLET->A2_NOME,1,20) ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NRODOC, VW_FLET->DBB_DOC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_FECHA, DTOC(SToD(VW_FLET->DBB_EMISSA)) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nBruto := xMoeda(VW_FLET->DBC_TOTAL,VW_FLET->DBB_MOEDA,1,,2,VW_FLET->DBB_TXMOED)
					nIva := xMoeda(VW_FLET->DBC_VLIMP1,VW_FLET->DBB_MOEDA,1,,2,VW_FLET->DBB_TXMOED)
					nNeto := nBruto - nIva

					oPrint:SayAlign(nLinAtu, COL_BRUTO,ALLTRIM(TRANSFORM(nBruto,"@E 9,999,999.99"));
					, oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_IVA, IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM(nIva,"@E 9,999,999.99")),VW_FLET->DBB_SIMBOL+" "+ ;
					ALLTRIM(TRANSFORM(VW_FLET->DBB_TXMOED,"@E 9,999,999.99"))),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_NETO,IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM((nNeto),"@E 9,999,999.99"));
					,ALLTRIM(TRANSFORM(xMoeda(nBruto,1,2,,2,VW_FLET->DBB_TXMOED),"@E 9,999,999.99")) ) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:Box( nLinAtu, COL_DESCR, nLinAtu+020, COL_DESCR, "-2")
					oPrint:Box( nLinAtu, COL_PROV, nLinAtu+020, COL_PROV, "-2")
					oPrint:Box( nLinAtu, COL_PROVDES, nLinAtu+020, COL_PROVDES, "-2")
					oPrint:Box( nLinAtu, COL_NRODOC, nLinAtu+020, COL_NRODOC, "-2")
					oPrint:Box( nLinAtu, COL_FECHA, nLinAtu+020, COL_FECHA, "-2")
					oPrint:Box( nLinAtu, COL_BRUTO, nLinAtu+020, COL_BRUTO, "-2")
					oPrint:Box( nLinAtu, COL_IVA, nLinAtu+020, COL_IVA, "-2")
					oPrint:Box( nLinAtu, COL_NETO, nLinAtu+020, COL_NETO, "-2")

					nLinAtu += nTamLin

					nSubBrutoFle += nBruto
					nSubIvaFle += nIva
					nSubNetoFle += nNeto

					VW_FLET->(DbSkip())
				enddo
				nLinAtu -= nTamLin
				nLinAtu += (nTamLin * 2)
				oPrint:SayAlign(nLinAtu, 210, "SUBTOTAL: FLETE",     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nValGas += nSubBrutoFle

				if MV_PAR04 == 2
					nSubBrutoFle := xMoeda(nSubBrutoFle,1,2,,2,nTxMoe)
					nSubIvaFle := xMoeda(nSubIvaFle,1,2,,2,nTxMoe)
					nSubNetoFle := xMoeda(nSubNetoFle,1,2,,2,nTxMoe)
				ENDIF

				IF MV_PAR04 == 1
					oPrint:SayAlign(nLinAtu, COL_BRUTO, ALLTRIM(TRANSFORM((nSubBrutoFle),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_IVA, ALLTRIM(TRANSFORM((nSubIvaFle),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM((nSubNetoFle),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				else
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM((nSubBrutoFle),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				ENDIF

				nLinAtu += (nTamLin * 2)

				nTotBru += nSubBrutoFle
				nTotIva += nSubIvaFle
				nTotNet += nSubNetoFle
			Endif

			//acaba tributo
			getOtros(VW_DBA->DBA_HAWB)
			//Despacho
			if ! VW_OTRR->(EoF())
				nSubBrutoOtr := 0
				nSubIvaOtr := 0
				nSubNetoOtr := 0
				While ! VW_OTRR->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab()//CABEC
					EndIf

					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
					//verticales
					oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_OTRR->TIPO,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_DESCR, VW_OTRR->DBC_DESCRI ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROV, VW_OTRR->DBB_FORNEC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_PROVDES, SUBSTR(VW_OTRR->A2_NOME,1,20) ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NRODOC, VW_OTRR->DBB_DOC ,     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_FECHA, DTOC(SToD(VW_OTRR->DBB_EMISSA)) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nBruto := xMoeda(VW_OTRR->DBC_TOTAL,VW_OTRR->DBB_MOEDA,1,,2,VW_OTRR->DBB_TXMOED)
					nIva := xMoeda(VW_OTRR->DBC_VLIMP1,VW_OTRR->DBB_MOEDA,1,,2,VW_OTRR->DBB_TXMOED)
					nNeto := nBruto - nIva

					oPrint:SayAlign(nLinAtu, COL_BRUTO,ALLTRIM(TRANSFORM(nBruto,"@E 9,999,999.99"));
					, oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_IVA, IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM(nIva,"@E 9,999,999.99")),VW_OTRR->DBB_SIMBOL+" "+ ;
					ALLTRIM(TRANSFORM(VW_OTRR->DBB_TXMOED,"@E 9,999,999.99"))),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_NETO,IIF(MV_PAR04 == 1,ALLTRIM(TRANSFORM((nNeto),"@E 9,999,999.99"));
					,ALLTRIM(TRANSFORM(xMoeda(nBruto,1,2,,2,VW_OTRR->DBB_TXMOED),"@E 9,999,999.99")) ) ,     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:Box( nLinAtu, COL_DESCR, nLinAtu+020, COL_DESCR, "-2")
					oPrint:Box( nLinAtu, COL_PROV, nLinAtu+020, COL_PROV, "-2")
					oPrint:Box( nLinAtu, COL_PROVDES, nLinAtu+020, COL_PROVDES, "-2")
					oPrint:Box( nLinAtu, COL_NRODOC, nLinAtu+020, COL_NRODOC, "-2")
					oPrint:Box( nLinAtu, COL_FECHA, nLinAtu+020, COL_FECHA, "-2")
					oPrint:Box( nLinAtu, COL_BRUTO, nLinAtu+020, COL_BRUTO, "-2")
					oPrint:Box( nLinAtu, COL_IVA, nLinAtu+020, COL_IVA, "-2")
					oPrint:Box( nLinAtu, COL_NETO, nLinAtu+020, COL_NETO, "-2")

					nLinAtu += nTamLin

					nSubBrutoOtr += nBruto
					nSubIvaOtr += nIva
					nSubNetoOtr += nNeto

					VW_OTRR->(DbSkip())
				enddo
				nLinAtu -= nTamLin
				nLinAtu += (nTamLin * 2)
				oPrint:SayAlign(nLinAtu, 210, "SUBTOTAL: OTRO",     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nValGas += nSubBrutoOtr

				if MV_PAR04 == 2
					nSubBrutoOtr := xMoeda(nSubBrutoOtr,1,2,,2,nTxMoe)
					nSubIvaOtr := xMoeda(nSubIvaOtr,1,2,,2,nTxMoe)
					nSubNetoOtr := xMoeda(nSubNetoOtr,1,2,,2,nTxMoe)
				ENDIF

				IF MV_PAR04 == 1
					oPrint:SayAlign(nLinAtu, COL_BRUTO, ALLTRIM(TRANSFORM((nSubBrutoOtr),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_IVA, ALLTRIM(TRANSFORM((nSubIvaOtr),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM((nSubNetoOtr),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				else
					oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM((nSubBrutoOtr),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				ENDIF

				nLinAtu += (nTamLin * 2)

				nTotBru += nSubBrutoOtr
				nTotIva += nSubIvaOtr
				nTotNet += nSubNetoOtr
			Endif

			VW_OTRR->(DbCloseArea())
			VW_INST->(DbCloseArea())
			VW_DESP->(DbCloseArea())
			VW_PIMP->(DbCloseArea())
			VW_FLET->(DbCloseArea())

			VW_DBA->(DbSkip())
		enddo

	endif

	nLinAtu += nTamLin

	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod(.t.,nTotBru,nTotIva,nTotNet,nValMer)
	EndIf

	VW_DBA->(DbCloseArea())

	//Mostrando o relatório
	oPrint:Preview()

	RestArea(aArea)

RETURN

Static Function fImpCab(cDoc,cProv,cProvDes,cUcob,cOrg)
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "Logo01.bmp"
	//Iniciando Página
	oPrint:StartPage()

	oPrint:SayBitmap(030,10, cFLogo,070,060)

	cDesMoeda := ""
	cSymb := ""
	IF MV_PAR04 == 1
		cDesMoeda = "Bolivianos"
		cSymb := "Bs"
	else
		cDesMoeda = "Dolares"
		cSymb := "$"
	ENDIF
	//Cabeçalho
	cTexto := "Planilla de Importaciones en " + cDesMoeda // poner moneda
	oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 20, , PAD_CENTER, 0)
	nLinCab += (nTamLin * 6)
	oPrint:SayAlign(nLinCab, COL_GRUPO, Alltrim(SM0->M0_NOME)+ " / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL), oFontTit, 240, 20, , PAD_LEFT, 0)

	//Linha Separatória
	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)

	//Cabeçalho das colunas
	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Numero OC",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:Box( nLinCab, 80, nLinCab+015, 450, "-2")
	
	oPrint:SayAlign(nLinCab, COL_GRUPO+0170, cDoc + space(10) + cUcob + space(7) + cOrg,     oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	//recuadro

	nLinCab += (nTamLin * 1.8)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Proveedor", oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:Box( nLinCab, 80, nLinCab+015, nColFin, "-2")
	oPrint:SayAlign(nLinCab, COL_GRUPO+0170, cProv + space(20) + cProvDes, oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	nLinCab += (nTamLin * 0.5)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Detalle de Gastos", oFontDetNN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.4)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	nLinCab += (nTamLin * 1.2)
	oPrint:Box( nLinCab, COL_GRUPO, nLinCab+020, nColFin, "-2")//sub detalle
	//verticales
	oPrint:Box( nLinCab, COL_DESCR, nLinCab+020, COL_DESCR, "-2")
	oPrint:Box( nLinCab, COL_PROV, nLinCab+020, COL_PROV, "-2")
	oPrint:Box( nLinCab, COL_PROVDES, nLinCab+020, COL_PROVDES, "-2")
	oPrint:Box( nLinCab, COL_NRODOC, nLinCab+020, COL_NRODOC, "-2")
	oPrint:Box( nLinCab, COL_FECHA, nLinCab+020, COL_FECHA, "-2")
	oPrint:Box( nLinCab, COL_BRUTO, nLinCab+020, COL_BRUTO, "-2")
	oPrint:Box( nLinCab, COL_IVA, nLinCab+020, COL_IVA, "-2")
	oPrint:Box( nLinCab, COL_NETO, nLinCab+020, COL_NETO, "-2")

	oPrint:SayAlign(nLinCab, COL_GRUPO, "Gasto",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, "Descripcion",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PROV, "Cod Prov",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab,COL_PROVDES , "Proveedor",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	//oPrint:SayAlign(nLinCab, COL_SUBLOTE, "Documento",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_NRODOC, "Nro Doc",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FECHA, "Fecha",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_BRUTO, IIF(MV_PAR04==1,"Bruto(Bs)","Monto"),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_IVA, IIF (MV_PAR04==1,"IVA(Bs)","Mon TC"),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_NETO, IIF(MV_PAR04==1,"NETO(Bs)","Monto USD"),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod(lTot,nTotBru,nTotIva,nTotNet,nValMer)//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

	//Linha Separatória
	//oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_GRAY)

	nLinRod += 3
	if lTot
		oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_BLACK)
		oPrint:SayAlign(nLinRod, COL_SUBLOTE, "TOTAL GENERAL GASTOS(Bs)", oFontDetN, 0140, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		if MV_PAR04 == 2
			oPrint:SayAlign(nLinRod, COL_NETO, ALLTRIM(TRANSFORM((nTotBru),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		ELSE
			oPrint:SayAlign(nLinRod, COL_BRUTO, ALLTRIM(TRANSFORM((nTotBru),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinRod, COL_IVA, ALLTRIM(TRANSFORM((nTotIva),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinRod, COL_NETO, ALLTRIM(TRANSFORM((nTotNet),"@E 9,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		ENDIF

		nLinRod += 15
		oPrint:SayAlign(nLinRod, COL_SUBLOTE, "VALOR EN ALMACEN(Bs)", oFontDetN, 0140, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		IF MV_PAR04 == 2
			oPrint:SayAlign(nLinRod, COL_NETO, ALLTRIM(TRANSFORM((nTotBru+nValMer),"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		ELSE
			nValAlm := xMoeda(nValMer,2,1,,2,nTxMoe)//A bs
			oPrint:SayAlign(nLinRod, COL_BRUTO, ALLTRIM(TRANSFORM((nTotBru + nValAlm),"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinRod, COL_IVA, ALLTRIM(TRANSFORM((nTotIva + nValAlm ),"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinRod, COL_NETO, ALLTRIM(TRANSFORM((nTotNet + nValAlm),"@E 9,999,999.99")) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		ENDIF

		nLinRod += 15
		oPrint:SayAlign(nLinRod, COL_GRUPO, "Observaciones", oFontTit, 240, 20, , PAD_LEFT, 0)
		oPrint:Box( nLinRod, COL_GRUPO+100, nLinRod+015, nColFin, "-2")//sub detalle
		oPrint:SayAlign(nLinRod, COL_GRUPO+110, cObse , oFontTit, 240, 20, , PAD_LEFT, 0)
		nLinRod += 17
		oPrint:SayAlign(nLinRod, COL_GRUPO, "% Internacion CPI", oFontTit, 240, 20, , PAD_LEFT, 0)
		nMed := (nColFin-(nColFin/2))
		oPrint:Box( nLinRod, COL_GRUPO+100, nLinRod+015, nMed, "-2")//sub detalle

		nValGas := xMoeda(nValGas,1,2,,2,nTxMoe)//A DOLAR

		nValDUA:= xMoeda(nValDUA,1,2,,2,nTxMoe)// A DOLAR

		nValGasto := nValGas + nValDUA // suma gasto total

		nValGasCpi := ((nValMer + nValGasto)/nValMer) -1  //cpi		
		
		nValGasCpa := ((nValMer + iif(mv_par04 == 1,nTotNet/nTxMoe,nTotNet))/nValMer) -1  //cpa

		oPrint:SayAlign(nLinRod, COL_GRUPO+110,ALLTRIM(TRANSFORM((nValGasCpi * 100),"@E 9,999,999.99"))+ " %"  , oFontTit, 240, 20, , PAD_LEFT, 0)
		oPrint:SayAlign(nLinRod, nMed+10, "% Internacion CPA", oFontTit, 240, 20, , PAD_LEFT, 0)
		oPrint:Box( nLinRod,nMed+110 , nLinRod+015,nColFin , "-2")//sub detalle
		oPrint:SayAlign(nLinRod, nMed+140, ALLTRIM(TRANSFORM((nValGasCpa * 100),"@E 9,999,999.99"))+ " %" , oFontTit, 240, 20, , PAD_LEFT, 0)
	else
		nLinRod += 47
	endif

	nLinRod += 25
	//Dados da Esquerda e Direita
	cTextoEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
	cTextoDir := "Página " + cValToChar(nPagAtu)

	//Imprimindo os textos
	oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_BLACK)
	oPrint:SayAlign(nLinRod, nColIni,    cTextoEsq, oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, nColFin-50, cTextoDir, oFontRod, 60, 05, CLR_GRAY, PAD_RIGHT, 0)

	nValDUA := 0
	nValGas := 0
	nValMer := 0
	//Finalizando a página e somando mais um
	oPrint:EndPage()
	nPagAtu++
Return

Static Function ffechalarga(sfechacorta)

	//20101105

	Local sFechalarga:=""
	Local descmes := ""
	Local sdia:=substr(sfechacorta,7,2)
	Local smes:=substr(sfechacorta,5,2)
	Local sano:=substr(sfechacorta,0,4)

	if smes=="01"
		descmes :="Enero"
	endif
	if smes=="02"
		descmes :="Febrero"
	endif
	if smes=="03"
		descmes :="Marzo"
	endif
	if smes=="04"
		descmes :="Abril"
	endif
	if smes=="05"
		descmes :="Mayo"
	endif
	if smes=="06"
		descmes :="Junio"
	endif
	if smes=="07"
		descmes :="Julio"
	endif
	if smes=="08"
		descmes :="Agosto"
	endif
	if smes=="09"
		descmes :="Septiembre"
	endif
	if smes=="10"
		descmes :="Octubre"
	endif
	if smes=="11"
		descmes :="Noviembre"
	endif
	if smes=="12"
		descmes :="Diciembre"
	endif

	sFechalarga := sdia + " de " + descmes + " de " + sano

Return(sFechalarga)

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

/*  TRAER VALOR DEL FOB
SELECT SUM(DBC_TOTAL) FROM DBB010 DBB
JOIN DBC010 DBC
ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBC_ITDOC=DBB_ITEM AND DBB.DBB_HAWB = DBC.DBC_HAWB  AND DBC.D_E_L_E_T_ = ''
WHERE DBB_HAWB BETWEEN 'OC/132/19/A' AND 'OC/132/19/A'
AND DBB.D_E_L_E_T_ = '' AND DBB.DBB_TIPONF = '5'

*/

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

	//Aviso("",cQuery,{'ok'},,,,,.t.)
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