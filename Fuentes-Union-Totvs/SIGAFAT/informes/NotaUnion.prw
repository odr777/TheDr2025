#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

///https://centraldeatendimento.totvs.com/hc/pt-br/articles/360020223571-MP-ADVPL-FWMsPRINTER-Rel-n%C3%A3o-pode-ser-criado
//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Colunas
#Define COL_GRUPO   0015
#Define COL_BOXIN   0085
#Define COL_BOXIN2  0320
#Define COL_BOXIN3  0570
#Define COL_DESCR   00100
#Define COL_FABRIC  0160
#Define	COL_LOTE 	0190
#Define	COL_SUBLOTE		0259
#Define	COL_UBICACION	0300
#Define	COL_CANTIDAD	0350
#Define	COL_COSTO		0500
#Define	COL_TOTAL		0455
#Define COL_VALIDEZ    0510
#Define COL_FECHA 0610
#Define COL_BOXU 0120
#Define COL_BOXD 0320
#Define COL_BOXT 0520

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  NotaUnion  ºAutor  ³ERICK ETCHEVERRY º 	 Date 0/04/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Factura impresora a rollo	                                  º±±
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

User Function NotaUnion(cxNro1,cxNro2,cxSerie,nLinInicia,cOrigCop)
	LOCAL cString		:= "SF2"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Devolucion Factura"
	LOCAL cDesc1	    := "Devolucion Factura de venta Bolivia"
	LOCAL cDesc2	    := "conforme parametro"
	LOCAL cDesc3	    := "Especifico UNION"
	PRIVATE nomeProg 	:= "FactLocal"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Arial"
	Private oFontDet  := TFont():New(cNomeFont,10,10,,.F.,,,,.T.,.F.)
	Private oFontDetN9 := TFont():New(cNomeFont,10,10,,.T.,,,,.F.,.F.)
	Private oFontDet2  := TFont():New(cNomeFont,11,11,,.F.,,,,.T.,.F.)
	Private oFontDet3  := TFont():New(cNomeFont,12,12,,.F.,,,,.T.,.F.)
	Private oFontDetN := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontDetNN := TFont():New(cNomeFont,012,012,,.T.,,,,.F.,.F.)
	Private oFontDetN := 	 TFont():New(cNomeFont,09,09,,.T.,,,,.F.,.F.)
	Private oFontRod  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTit  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTitt:= TFont():New(cNomeFont,011,011,,.T.,,,,.F.,.F.)
	private cArquivo := ""
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0

	Processa({ |lEnd| MOVD3CONF("Impresion de devolucion de factura",cxNro1,cxSerie)},"Imprimindo , aguarde...") ////configuraciones de impresion
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg,cxNro1,cxSerie,nLinInicia,cOrigCop)},titulo)

Return

Static Function MOVD3CONF(Titulo,cDoc,cSerie)
	Local cFilename := 'movinterno'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "znccfact" + dToS(date()) + "_" + alltrim(SUBSTR(TIME(), 1, 2))+ alltrim(SUBSTR(TIME(), 4, 2)) + alltrim(SUBSTR(TIME(), 7, 2))

	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., cCaminho, .T., , @oPrint, "", , , , .T.)
	//FErase( cCaminho+cArquivo+".pdf" )
	oPrint:cPathPDF := cCaminho
	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetLandscape()
	oPrint:SetPaperSize(0, getSize(cDoc,cSerie) + getSize2(cDoc,cSerie), 215.9)///largo x ancho     milimetros
	//
Return Nil

Static Function fImpPres(lEnd,WnRel,cString,nReg,cDoc1,cSerie,nLinInicial,cOrigCop)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local nTotal := 0
	Local _linAux := 0
	Local lRetCF := .f.
	Local aDupla   := {}
	Local aDetalle := {}
	Local nCantReg := 0
	Local bSw	   := .T.
	Local cMsgFat  := ""
	Local NextArea := GetNextAlias()
	Local cDireccion := ""
	Local cTelefono := ""
	Local cNombreSucursal := ""
	Local cDepartamento := ""
	Local cFilFact := ""
	Local cPedid := ""
	local aDados
	Local aDescTot := {}
	Local nDes1 := 0
	Local nDes2 := 0
	Local nDes3 := 0
	Local nDes4 := 0
	Local nAuxboni := 0
	Local aProds := {}
	Local _tamdesc:=80
	Local _nInterLin := 0
	Local lret := .t.
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 600
	Private nColIni   := 010
	Private nColFin   := 730
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
	private valorBoni := 0.0
	private cBonusTes  := SuperGetMv("MV_BONUSTS")
	private cBonustesNCC := Posicione("SF4",1,XFILIAL("SF4")+cBonusTes,"F4_TESDV")
	private nDescPor := 0.0
	private valorBoniNcc := 0.0
	private nDescPorNcc := 0.0

	//alert("")
	If Select("VW_PIMP") > 0
		dbCloseArea()
	Endif

	cSql	:= "SELECT F1_MOEDA,F1_FILIAL,F1_SERIE,F1_DOC,F1_NUMAUT,F1_EMISSAO,F1_HORA,F1_UNOMBRE,F1_UNIT,F1_COND,F1_VALBRUT,ROUND(F1_DESCONT,2) F1_DESCONT,F1_BASIMP1,F1_CODCTR,FP_DTAVAL,FP_ESPECIE ,FP_LOTE ,F1_USRREG,D1_PEDIDO,A1_MUN, A1_BAIRRO,A1_END"
	cSql		:= cSql+",F1_FORNECE,F1_LOJA,F1_ESPECIE,'SFP' FP_SFC,F1_VEND1,D1_SERIORI,D1_NFORI FROM(SELECT F1_MOEDA,F1_FILIAL,F1_SERIE,F1_DOC,F1_NUMAUT,F1_EMISSAO,F1_HORA,F1_UNOMBRE,F1_UNIT,F1_COND,F1_VALBRUT,ROUND(F1_DESCONT,2) F1_DESCONT,F1_BASIMP1,F1_CODCTR,F1_USRREG,A1_MUN, A1_BAIRRO,A1_END,F1_FORNECE,F1_LOJA,F1_ESPECIE,F1_VEND1"
	cSql		:= cSql+" FROM " + RetSqlName("SF1 ") +" SF1 LEFT JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F1_FORNECE AND A1_LOJA=F1_LOJA AND SA1.D_E_L_E_T_ =' ')WHERE F1_DOC='"+cDoc1+"'  AND F1_SERIE='"+cSerie+"' AND F1_ESPECIE = 'NCC' AND SF1.D_E_L_E_T_ =' ')TAB "
	cSql		:= cSql+" JOIN " + RetSqlName("SD1") +" SD1 ON (D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_LOJA=F1_LOJA AND SD1.D_E_L_E_T_ = ' '  AND D1_ITEM = '0001')"
	cSql		:= cSql+" JOIN " + RetSqlName("SFP") +" SFP ON (FP_SERIE=F1_SERIE AND SFP.D_E_L_E_T_ =' ') "
	cSql		:= cSql+" AND F1_FILIAL='" + xFilial("SF1") + "' "
	cSql		:= cSql+" Order By F1_DOC"

	/*If __CUSERID = '000000'
	Aviso("GTAPRECG",cQuery,{'ok'},,,,,.t.)
	EndIf*/

	TCQuery cSql New Alias "VW_PIMP"

	cNomCli:= ""

	Count To nTotal
	ProcRegua(nTotal)
	VW_PIMP->(DbGoTop())

	if ! VW_PIMP->(EoF())
		if ( val(VW_PIMP->FP_LOTE) != 1 .and. val(VW_PIMP->FP_ESPECIE) == 4)
			cF2vend  := GETADVFVAL("SF2","F2_VEND1",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"")

			If !Empty(D1_SERIORI)
				cF2unom := GETADVFVAL("SF2","F2_UNOMCLI",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")
				cF2unit := GETADVFVAL("SF2","F2_UNITCLI",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")
			else
				cF2unom := GETADVFVAL("SA1","A1_NOME   ",XFILIAL("SF1")+VW_PIMP->F1_FORNECE+VW_PIMP->F1_LOJA,1,"erro")
				cF2unit := GETADVFVAL("SA1","A1_UNITFAC",XFILIAL("SF1")+VW_PIMP->F1_FORNECE+VW_PIMP->F1_LOJA,1,"erro")
			ENDIF

			cValfat := 0
			cFac 	:= GETADVFVAL("SF2","F2_DOC",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//No fac
			cAut 	:= GETADVFVAL("SF2","F2_NUMAUT",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//No autorizacion
			cFch 	:= GETADVFVAL("SF2","F2_EMISSAO",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//Fcha emision
			cValfat := GETADVFVAL("SF2","F2_VALFAT",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//valor factura
			cDescon := GETADVFVAL("SF2","F2_DESCONT",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//valor descuento
			cBasimp := GETADVFVAL("SF2","F2_BASIMP1",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//F2_BAS
			cHora := GETADVFVAL("SF2","F2_HORA",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//F2_HORA
			cCodctr := GETADVFVAL("SF2","F2_CODCTR",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")// CODIGO DE CONTROL
			cFechalim := GETADVFVAL("SF2","F2_LIMEMIS",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//FECHA LIMITE DE EMISION
			cTipocambio := GETADVFVAL("SF2","F2_TXMOEDA",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//Tipo de cambio
			cMoeda  := GETADVFVAL("SF2","F2_MOEDA",XFILIAL("SF1")+VW_PIMP->D1_NFORI+VW_PIMP->D1_SERIORI,1,"erro")//Tipo de moneda
			cnfori := VW_PIMP->D1_NFORI
			ccserie := VW_PIMP->D1_SERIORI

			AADD(aDupla,VW_PIMP->F1_FILIAL)		  	//1
			AADD(aDupla,VW_PIMP->F1_SERIE)           //2
			AADD(aDupla,VW_PIMP->F1_DOC)             //3
			AADD(aDupla,VW_PIMP->F1_NUMAUT)          //4 nroautorizacion
			AADD(aDupla,VW_PIMP->F1_EMISSAO)         //5
			AADD(aDupla,cF2unom)            //6  nombre
			AADD(aDupla,cF2unit)            //7  nit cliente
			AADD(aDupla,VW_PIMP->F1_COND)            //8  condicionpago
			AADD(aDupla,VW_PIMP->F1_VALBRUT)         //9
			AADD(aDupla,VW_PIMP->F1_DESCONT)         //10
			AADD(aDupla,VW_PIMP->F1_BASIMP1)  		//11
			AADD(aDupla,VW_PIMP->F1_CODCTR)          //12
			AADD(aDupla,VW_PIMP->FP_DTAVAL)          //13
			AADD(aDupla,nil)				//14
			AADD(aDupla,VW_PIMP->D1_PEDIDO)		    //15 nropedido
			AADD(aDupla,VW_PIMP->A1_MUN)		    	//16
			AADD(aDupla,VW_PIMP->A1_BAIRRO)		    //17
			AADD(aDupla,VW_PIMP->A1_END)		        //18
			AADD(aDupla,VW_PIMP->F1_USRREG)		    //19
			AADD(aDupla,VW_PIMP->F1_FORNECE)		    //20
			AADD(aDupla,VW_PIMP->F1_LOJA)		    //21
			AADD(aDupla,VW_PIMP->F1_ESPECIE)		    //22
			AADD(aDupla,"")			    	//23 ??? FP_SFC
			AADD(aDupla,NIL)			    //24
			AADD(aDupla,cF2vend)			//25
			AADD(aDupla,cFac)		 		//26
			AADD(aDupla,cAut)				//27
			AADD(aDupla,cFch)				//28
			AADD(aDupla,cValfat)			//29 VALFA
			AADD(aDupla,cDescon)			//30 DESCON
			AADD(aDupla,cBasimp)			//31 BASIM
			AADD(aDupla,cHora)			    //32 HORA DATOS DE TRANSCCION
			AADD(aDupla,VW_PIMP->F1_HORA)			//33 HORA
			AADD(aDupla,cCodctr)			//34 CODIGO DE CONTROL DE KLA FACTURA
			AADD(aDupla,cFechalim)	        //35 FECHA LIMITE DE EMISION DE LA FACTURA
			AADD(aDupla,cTipocambio)	    //36 tipo de cambio
			AADD(aDupla,cMoeda)	            //37 tipo de moneda
			AADD(aDupla,VW_PIMP->F1_MOEDA)	        //38 tipo de moneda NCC sf1

			aDetalle:= FatDet (VW_PIMP->F1_DOC,VW_PIMP->F1_SERIE)         	   	//Datos detalle de factura

			aDetail := FatDetNf(aDupla[3],cnfori,ccserie)

			//Aviso("Array IVA",u_zArrToTxt(aDetalle, .T.),{'ok'},,,,,.t.)

			cFilFact := aDupla[1]
			DbSelectArea("SM0")
			SM0->(DBSETORDER(1))
			SM0->(DbSeek(cEmpAnt+cFilFact))

			cDireccion := TexToArray(AllTrim(SM0->M0_ENDENT),29)
			Csucursal := TexToArray(AllTrim("SUCURSAL - "+AllTrim(SM0->M0_CODFIL)),15)
			//		cDireccion := AllTrim(SM0->M0_ENDENT)+"; "+ AllTrim(SM0->M0_CIDENT)
			cTelefono := "Telf: "+AllTrim(SM0->M0_TEL)+If(!Empty(SM0->M0_FAX)," Fax: "+AllTrim(SM0->M0_FAX),"")
			cNombreSucursal := AllTrim(SM0->M0_FILIAL)
			cDepartamento := AllTrim(SM0->M0_CIDENT)+" - Bolivia"

			nAtual := fImpCab(nLinInicial,aDupla,cOrigCop,cDireccion,cTelefono,Csucursal,cNombreSucursal,cDepartamento)

			nDim:=len(aDetail)

			_linAux += nLinAtu
			_nInterLin += _linAux + 10

			For nI:=1 to nDim

				//oPrint:SayAlign(_linAux, 10,""+aDetalle[nI][11], oFontDet, 400, , ,,)
				oPrint:SayAlign(_linAux, 10,"           "+aDetail[nI][2], oFontDet, 400, , ,,)
				oPrint:SayAlign(_nInterLin, 10,"        "+ cValToChar(aDetail[nI][4]), oFontDet, 400, , ,,)//cantidad
				oPrint:SayAlign(_nInterLin, 10,"                               "+FmtoValor(aDetail[nI][5],14,2), oFontDet, 400, , ,,)
				oPrint:SayAlign(_nInterLin, 10,"                                                                "+FmtoValor(aDetail[nI][6],16,2), oFontDet, 400, , ,,)

				if( aDetail[nI][7] == cBonusTes)
					valorBoni  +=  aDetail[nI][6]
					nDescPor += aDetail[nI][8]
				endif

				_linAux:=_linAux+20
				_nInterLin:=_nInterLin+20

			Next nI

			///pie factura original

			_linAux := PieFactf2(_linAux,aDupla,aDescTot)

			//////////

			///PRINT OTRA CABECERA

			oPrint:SayAlign(_linAux, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
			_linAux += (nTamLin * 1)
			oPrint:SayAlign(_linAux, 3,"DETALLE DE LA DEVOLUCION O RESCISION                            " , oFontDet2, 400, , ,,)
			_linAux += (nTamLin * 1)
			oPrint:SayAlign(_linAux, 3,"                        DE SERVICIO                             " , oFontDet2, 400, , ,,)
			_linAux += (nTamLin * 1)
			oPrint:SayAlign(_linAux, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
			_linAux += (nTamLin * 1)
			oPrint:SayAlign(_linAux, 3,"CONCEPTO                                                           " , oFontDet2, 400, , ,,)
			_linAux += (nTamLin * 1)
			oPrint:SayAlign(_linAux, 3,"           CANT                 PRECIO                   TOTAL     " , oFontDet2, 400, , ,,)
			_linAux += (nTamLin * 1)
			oPrint:SayAlign(_linAux, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)

			///////

			nDim2:=len(aDetalle)
			_linAux += 10
			_nInterLin:= 0
			_nInterLin += _linAux + 10

			For nIx:=1 to nDim2

				//oPrint:SayAlign(_linAux, 10,""+aDetalle[nI][11], oFontDet, 400, , ,,)
				oPrint:SayAlign(_linAux, 10,"           "+aDetalle[nIx][2], oFontDet, 400, , ,,)
				oPrint:SayAlign(_nInterLin, 10,"        "+alltrim(FmtoValor(aDetalle[nIx][4],10,0)), oFontDet, 400, , ,,)//cantidad
				oPrint:SayAlign(_nInterLin, 10,"                               "+FmtoValor(aDetalle[nIx][5],14,2), oFontDet, 400, , ,,)
				oPrint:SayAlign(_nInterLin, 10,"                                                                "+FmtoValor(aDetalle[nIx][6],16,2), oFontDet, 400, , ,,)

				if( aDetalle[nIx][7] == cBonustesNCC)
					valorBoniNcc  +=  aDetalle[nIx][6]
					nDescPorNcc += aDetalle[nIx][8]
				endif

				_linAux:=_linAux+20
				_nInterLin:=_nInterLin+20

			Next nIx

			PieFact(_nInterLin,aDupla,aDescTot)
		else
			MSGINFO( "No es permitido imprimir una dosificación con serie manual" , "AVISO:"  )
			lret = .f.
		endif
	Endif

	if lret
		//Se ainda tiver linhas sobrando na página, imprime o rodapé final
		If nLinAtu <= nLinFin
			fImpRod()
		EndIf

		//Mostrando o relatório
		oPrint:Preview()

		For nX := 1 to 10

			If ! File(cArquivo)

				Sleep(500)

			EndIf

		Next nX
	endif

	VW_PIMP->(DbCloseArea())
	RestArea(aArea)

RETURN

Static Function fImpCab(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono,Csucursal,cNombreSucursal,cDepartamento)
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFecVen := ""
	local cNombreCli := TexToArray(aMaestro[6],18)

	cFechaPed := If(!Empty(aMaestro[15]),DTOC(Posicione("SC5",1,xFilial("SC5")+aMaestro[15],"C5_EMISSAO")),"")
	cFechaPed := If(!Empty(aMaestro[15]),DTOC(Posicione("SC5",1,xFilial("SC5")+aMaestro[15],"C5_EMISSAO")),"")

	//Iniciando Página
	oPrint:StartPage()

	//Cabeçalho
	cTexto := "UNION CENTRO"
	oPrint:SayAlign(nLinCab, 70, cTexto, oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 65, "VETERINARIO S.R.L", oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	for i := 1 to len(Csucursal)
		oPrint:SayAlign(nLinCab, 60, ALLTRIM(Csucursal[i]), oFontDet2, 400, , ,,)
		nLinCab += (nTamLin * 1)
	next i

	oPrint:SayAlign(nLinCab, 57, ""+alltrim(cNombreSucursal), oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	for i := 1 to len(cDireccion)
		oPrint:SayAlign(nLinCab, 50, ALLTRIM(cDireccion[i]) , oFontDet2, 400, , ,,)
		nLinCab += (nTamLin * 1)
	next i

	oPrint:SayAlign(nLinCab, 73,cTelefono, oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 65,cDepartamento, oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 80,"NOTA DE", oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 57,"CREDITO - DEBITO", oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab -0.5, 80,cTipo, oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 57,"EDV :   "+ FWLeUserlg("F1_USERLGI") /*USRFULLNAME(SUBSTR(EMBARALHA(cUgistro,1),3,6))*/ , oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 57,"Usuario :   "+cUserName, oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 30,"Venta al por mayor de otros productos", oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 68,"NIT :", oFontDet2, 400, , ,,)
	oPrint:SayAlign(nLinCab, 92, AllTrim(SM0->M0_CGC), oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 30,"NOTA FISCAL No.", oFontDet2, 400, , ,,)
	oPrint:SayAlign(nLinCab, 104,quitZero(aMaestro[3]), oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 25,"AUTORIZACION No.", oFontDet2, 400, , ,,)
	oPrint:SayAlign(nLinCab, 104, aMaestro[4], oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 25," FECHA:   " +DTOC(STOD(aMaestro[5])) + " HORA:  "+ aMaestro[33], oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 65," NIT/CI:" , oFontDet2, 400, , ,,)
	oPrint:SayAlign(nLinCab, 98, aMaestro[7] , oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 25," SEÑOR(ES):      " , oFontDet2, 400, , ,,)
	for i := 1 to len(cNombreCli)
		oPrint:SayAlign(nLinCab, 90,ALLTRIM(cNombreCli[i]) , oFontTitt, 400, , ,,)
		nLinCab += (nTamLin * 1)
	next i
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"     DATOS DE LA TRANSACCION ORIGINAL                            " , oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 65,"FACTURA No.", oFontDet2, 400, , ,,)
	oPrint:SayAlign(nLinCab, 120,quitZero(aMaestro[26]), oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"    AUTORIZACION No.", oFontDet2, 400, , ,,)
	oPrint:SayAlign(nLinCab, 95, aMaestro[27], oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 25," FECHA:   " +DTOC(aMaestro[28]) + " HORA:  "+ aMaestro[32], oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"CONCEPTO                                                           " , oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"           CANT                 PRECIO                   TOTAL     " , oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)

	nLinCab += nTamLin

	nLinAtu := nLinCab
	//Atualizando a linha inicial do relatório
Return

Static Function fImpRod()//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

	//Finalizando a página e somando mais um
	oPrint:EndPage()
	nPagAtu++
Return

//DETALLE NCC DEVOLUCIONES
static function FatDet (cDoc,cSerie) // Datos detalle de factura de devolucion
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea2	:= GetNextAlias()

	Local   cSql		:= "SELECT  B1_COD, B1_DESC,SUM(D1_QUANT)D1_QUANT,B1_UFABRIC, D1_VUNIT, D1_TES,D1_DESC, CASE WHEN D1_VUNIT!=0 THEN SUM(D1_QUANT)*D1_VUNIT ELSE SUM(D1_QUANT)*D1_VUNIT END D1_TOTAL,D1_FILIAL, D1_PEDIDO "
	cSql				:= cSql+"FROM " + RetSqlName("SD1") +" SD1 JOIN	" + RetSqlName("SB1") +" SB1 ON ( D1_COD=B1_COD  AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+" WHERE D1_DOC='"+cDoc+"' AND D1_SERIE='"+cSerie+"' AND D1_ESPECIE='NCC' AND D1_FILIAL = '" + xfilial("SD1") +"'  AND SD1.D_E_L_E_T_=' '  "
	cSql				:= cSql+" GROUP BY B1_COD,B1_DESC,D1_VUNIT,B1_UFABRIC,D1_TES,D1_DESC,D1_FILIAL,D1_PEDIDO "

	//	Aviso("items",cSql,{'ok'},,,,,.t.)

	//	SELECT B1_COD,B1_DESC,D1_LOTECTL,D1_DTVALID,D1_QUANT, D1_VUNIT,CASE WHEN D1_VUNIT!=0 THEN D1_QUANT*D1_VUNIT ELSE D1_QUANT*D1_VUNIT END D1_TOTAL,D1_ITEM
	//	FROM  SD1010 SD1 JOIN SB1010 SB1 ON (D1_DOC='0000000000001' AND D1_SERIE='MO1' AND  D1_COD=B1_COD AND D1_ESPECIE='NF' AND SD1.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' )
	//	ORDER BY D1_ITEM

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea2,.T.,.F.)
	dbSelectArea(NextArea2)
	dbGoTop()
	While !Eof()
		cProducto	:=B1_COD
		cNombre		:=B1_DESC
		/*If Len(AllTrim(D1_DTVALID+D1_DTVALID))>0
		cLote       :="L:"+AllTrim(D1_LOTECTL)+" V:"+ALLTRIM(STRZERO(MONTH(STOD(D1_DTVALID)),2))+ALLTRIM("/")+ALLTRIM(STRZERO(Year(STOD(D1_DTVALID)),4))
		Else
		cLote       := ""
		EndIf*/
		cPedido		:=""
		cItPedido	:=""
		nCant		:= D1_QUANT
		nPrecio		:= D1_VUNIT
		nTotal		:= Round(nCant*nPrecio,2)
		cTES        := D1_TES
		cDescont    := D1_DESC

		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,"")      //3
		AADD(aDupla,nCant)      //4
		AADD(aDupla,nPrecio)    //5
		AADD(aDupla,nTotal)     //6
		AADD(aDupla,cTES)       //7
		AADD(aDupla,cDescont)   //8
		AADD(aDatos,aDupla)     //9
		DbSkip()
	enddo
	#IFDEF TOP
	dBCloseArea(NextArea2)
	#ENDIF
return  aDatos

//DETALLE FACTURA ORIGINAL
static function FatDetNf (cDoc,cnfori,cSerie) // Datos detalle de la factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT B1_COD,B1_DESC,SUM(D2_QUANT) D2_QUANT,D2_TES,SUM(D2_DESCON) D2_DESCON,B1_UFABRIC,CASE WHEN D2_PRUNIT!=0 THEN D2_PRUNIT ELSE D2_PRCVEN END D2_PRUNIT,CASE WHEN D2_PRUNIT!=0 THEN SUM(D2_QUANT)*D2_PRUNIT ELSE SUM(D2_QUANT)*D2_PRCVEN END D2_TOTAL, D2_PEDIDO, D2_FILIAL "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON  D2_COD=B1_COD  AND SB1.D_E_L_E_T_=' '  "
	cSql				:= cSql+" WHERE  D2_DOC='"+cnfori+"' AND D2_SERIE='"+cSerie+"' AND D2_ESPECIE='NF' AND D2_FILIAL = '" + xfilial("SD2") + "' AND SD2.D_E_L_E_T_=' ' "
	cSql				:= cSql+"GROUP BY B1_COD,B1_DESC,D2_PRUNIT,D2_PRCVEN,D2_TES,B1_UFABRIC,D2_PEDIDO,D2_FILIAL "
	cSql				:= cSql+"ORDER BY D2_PEDIDO"
	//	Aviso("items",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	While !Eof()
		cProducto	:= (NextArea)->B1_COD
		cNombre		:=(NextArea)->B1_DESC

		cPedido		:= (NextArea)->D2_PEDIDO
		cItPedido	:= ""
		nCant		:= (NextArea)->D2_QUANT
		nPrecio		:= (NextArea)->D2_PRUNIT
		nTotal		:= Round(nCant*nPrecio,2)
		cTES        := (NextArea)->D2_TES
		cDescont    := (NextArea)->D2_DESCON

		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,"")      //3
		AADD(aDupla,nCant)      //4
		AADD(aDupla,nPrecio)    //5
		AADD(aDupla,nTotal)     //6
		AADD(aDupla,cTES)       //7
		AADD(aDupla,cDescont)   //8
		AADD(aDatos,aDupla)     //9

		DbSkip()
	end do
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
return  aDatos

static function getSize (cDoc,cSerie) // Datos detalle de factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0

	Local   cSql		:= "SELECT "
	cSql				:= cSql+" count(*) tot "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"LEFT JOIN "+ RetSqlName("SC6") +" SC6 ON (C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM) AND SC6.D_E_L_E_T_=' ' "

	//		Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"vwsize",.T.,.F.)
	dbSelectArea("vwsize")
	dbGoTop()

	nNorSize := 280

	nItemSize := vwsize->tot * 6.3

	nTotal := nNorSize + nItemSize

	vwsize->(dBCloseArea())

	/*cSql		:= "SELECT "  ///CASO HUBIERA DESCRIPCIONES SE USARA ESTO
	cSql				:= cSql+" CASE WHEN LEN(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),''))=0 THEN C6_DESCRI "
	cSql				:= cSql+"ELSE C6_DESCRI END B1_DESC "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"LEFT JOIN "+ RetSqlName("SC6") +" SC6 ON (C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM) AND SC6.D_E_L_E_T_=' ' "
	cSql				:= cSql+"ORDER BY D2_PEDIDO,D2_ITEM"
	//		Aviso("",cSql,{'ok'},,,,,.t.)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"vwDESC",.T.,.F.)
	dbSelectArea("vwDESC")
	dbGoTop()
	WHILE !vwDESC->(EOF)
	_nlindet:=mlcount(allTrim(vwDESC->B1_DESC),80)
	+10
	ENDIF*/

return  nTotal

static function getSize2 (cDoc,cSerie) // Datos detalle de factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0

	Local   cSql		:= "SELECT "
	cSql				:= cSql+" count(*) tot "
	cSql				:= cSql+"FROM " + RetSqlName("SD1") +" SD1 JOIN	" + RetSqlName("SB1") +" SB1 ON (D1_DOC='"+cDoc+"' AND D1_SERIE='"+cSerie+"' AND  D1_COD=B1_COD AND D1_ESPECIE='NCC' AND SD1.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "

	//		Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"vwsize2",.T.,.F.)
	dbSelectArea("vwsize2")
	dbGoTop()

	nNorSize := 140

	nItemSize := vwsize2->tot * 6.3

	nTotal := nNorSize + nItemSize

	vwsize2->(dBCloseArea())

	/*cSql		:= "SELECT "  ///CASO HUBIERA DESCRIPCIONES SE USARA ESTO
	cSql				:= cSql+" CASE WHEN LEN(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),''))=0 THEN C6_DESCRI "
	cSql				:= cSql+"ELSE C6_DESCRI END B1_DESC "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"LEFT JOIN "+ RetSqlName("SC6") +" SC6 ON (C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM) AND SC6.D_E_L_E_T_=' ' "
	cSql				:= cSql+"ORDER BY D2_PEDIDO,D2_ITEM"
	//		Aviso("",cSql,{'ok'},,,,,.t.)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"vwDESC",.T.,.F.)
	dbSelectArea("vwDESC")
	dbGoTop()
	WHILE !vwDESC->(EOF)
	_nlindet:=mlcount(allTrim(vwDESC->B1_DESC),80)
	+10
	ENDIF*/

return  nTotal

Static Function PieFactf2(nLinInicial,aMaestro)  /////para NF factura
	Local nTotGral := 0
	local lin := 50
	local sumlin := 40
	local valorImporteBS

	nSubtotal  := aMaestro[29]
	nDescuento := aMaestro[30] + valorBoni
	nDescuento  = nDescuento - nDescPor
	nTotGral   := NOROUND(nSubtotal+nDescuento,2)

	If aMaestro[37] == 1

		oPrint:SayAlign(nLinInicial, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
		nLinInicial += (nTamLin * 1)
		oPrint:SayAlign(nLinInicial, 3,"SUBTOTAL BS.                           ", oFontDet2, 400, , ,,)

		oPrint:SayAlign(nLinInicial, 3,"                                                          "+ FmtoValor(nTotGral,14,2), oFontDet2, 400, , ,,)
		nLinInicial += (nTamLin * 1)
		oPrint:SayAlign(nLinInicial, 3,"DESCUENTOS BS.                         ", oFontDet2, 400, , ,,)

		oPrint:SayAlign(nLinInicial, 3,"                                                          "+FmtoValor(nDescuento,14,2), oFontDet2, 400, , ,,)
		nLinInicial += (nTamLin * 1)
		oPrint:SayAlign(nLinInicial, 3,"TOTAL Bs.                              ", oFontDet2, 400, , ,,)
		oPrint:SayAlign(nLinInicial, 3,"                                                          "+ FmtoValor(aMaestro[31],14,2), oFontTitt, 400, , ,,)

	elseIF aMaestro[37] == 2

		valorImporteBS := FmtoValor(round(xMoeda(aMaestro[31],2,1,,4,0,aMaestro[36]),2),14,2)  //Total Bolivianos

		oPrint:SayAlign(nLinInicial, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
		nLinInicial += (nTamLin * 1)
		oPrint:SayAlign(nLinInicial, 3,"SUBTOTAL $us.                                                       ", oFontDet2, 400, , ,,)

		oPrint:SayAlign(nLinInicial, 3,"                                                          "+ FmtoValor(nTotGral,14,2), oFontDet2, 400, , ,,)
		nLinInicial += (nTamLin * 1)
		oPrint:SayAlign(nLinInicial, 3,"DESCUENTOS $us.                                                       ", oFontDet2, 400, , ,,)

		oPrint:SayAlign(nLinInicial, 3,"                                                          "+FmtoValor(nDescuento,14,2), oFontDet2, 400, , ,,)
		nLinInicial += (nTamLin * 1)
		oPrint:SayAlign(nLinInicial, 3,"TOTAL $us.                                                       ", oFontDet2, 400, , ,,)

		oPrint:SayAlign(nLinInicial, 3,"                                                          "+ FmtoValor(aMaestro[31],14,2), oFontTitt, 400, , ,,)
		nLinInicial += (nTamLin * 1.5)
		oPrint:SayAlign(nLinInicial, 3,"T.C:                                                       ", oFontDet2, 400, , ,,)

		oPrint:SayAlign(nLinInicial, 3,"             "+alltrim(TRANSFORM(aMaestro[36],"@E 9,999,999,999.99")), oFontTitt, 400, , ,,)
		nLinInicial += (nTamLin * 1.5)
		oPrint:SayAlign(nLinInicial, 3,"TOTAL Bs.                                                       ", oFontDet2, 400, , ,,)

		oPrint:SayAlign(nLinInicial, 3,"                                                          "+ valorImporteBS, oFontTitt, 400, , ,,)

	endif

	nLinInicial += (nTamLin * 1.5)
	oPrint:SayAlign(nLinInicial, 3,"    CODIGO DE CONTROL:", oFontDet3, 400, , ,,)
	oPrint:SayAlign(nLinInicial, 125, aMaestro[34], oFontTitt, 400, , ,,)
	nLinInicial += (nTamLin * 1)
	oPrint:SayAlign(nLinInicial, 3,"    FECHA LIMITE DE EMISION:", oFontDet3, 400, , ,,)
	oPrint:SayAlign(nLinInicial, 140, DTOC(aMaestro[35]), oFontTitt, 400, , ,,)

	nLinInicial := nLinInicial + 20

return nLinInicial

Static Function PieFact(nLinInicial,aMaestro,aDesc)
	Local cFecVen := ""
	Local nTotGral := 0
	Local cFile := ""
	Local nLin := 00.0
	local lin := 10
	local i
	local sumlin := 10
	local cDocument := TexToArray("''ESTE DOCUMENTO FISCAL CONTRIBUYE AL DESARROLLO DE NUESTRO PAÍS. EL USO ILÍCITO ES SANCIONADO PENALMENTE''",40)
	local cLey := TexToArray(U_GetExFis(aMaestro[2],aMaestro[1]),45)
	local texto
	local valorBsLiteral
	local valorImporteBS
	local valorSubtotal
	local valorDescuento
	local descuentoTotal := 0

	If aMaestro[38] == 1
		texto := TexToArray("Son: "+Extenso(aMaestro[11],.F.,1)+" BOLIVIANOS ",40)
	elseIF aMaestro[38] == 2
		valorBsLiteral := 	round(xMoeda(aMaestro[11],2,1,,4,0,aMaestro[36]),2)
		//xMoeda(aMaestro[11],2,1,,2,0,aMaestro[26])///OK LATER
		texto := TexToArray("Son: "+Extenso(valorBsLiteral,.F.,1)+" BOLIVIANOS (T/C: "+ alltrim(TRANSFORM(aMaestro[36],"@E 9,999,999,999.99")) + ")",40)
	endif

	nSubtotal  := aMaestro[11]

	nDescuento := aMaestro[10] + valorBoniNcc

	nDescuento  = nDescuento - nDescPorNcc

	nTotGral   := NOROUND(nSubtotal+nDescuento,2)

	IF aMaestro[38] == 1

		oPrint:Say(nLinInicial                         ,20,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )
		//oPrint:Say(nLinInicial + 2870, 0100, aMaestro[19] ,oFont12 ) //Usuario que generó la factura
		oPrint:Say(nLinInicial + (lin := lin + 0)      ,20,"SUBTOTAL Bs.                                              " , oFontDet2 )	//SUBTOTAL
		oPrint:Say(nLinInicial +  lin                  ,20,"                                                      "+ FmtoValor(nTotGral,14,2) ,oFontDet2,,,,1 ) //Total General
		oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"DESCUENTOS Bs.                                            " , oFontDet2 ) 													//Codigo Control
		oPrint:Say(nLinInicial +  lin                  ,20,"                                                      "+ FmtoValor(nDescuento,14,2) ,oFontDet2,,,,1 ) //Descuentos
		oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"TOTAL Bs.                                                 " , oFontDet2 ) 													//Codigo Control
		oPrint:Say(nLinInicial +  lin                  ,20,"                                                      "+ FmtoValor(nSubtotal,14,2) ,oFontTitt,,,,1 )  //Total Bolivianos

		oPrint:Say(nLinInicial + (lin := lin + 70)     ,20,"Monto Base P/Debito-                                            ",oFontDet2 )
		oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"Credito Fiscal Bs.                                        ",oFontDet2 )
		oPrint:Say(nLinInicial +  lin                  ,20,"                                                      "+ FmtoValor(round(aMaestro[11],2),14,2),oFontDet2,,,,1 )  //Total Bolivianos

	elseIF aMaestro[38] == 2

		valorImporteBS := FmtoValor(round(xMoeda(aMaestro[11],2,1,,4,0,aMaestro[36]),2),14,2)  //Total Bolivianos

		oPrint:Say(nLinInicial                         ,20,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )
		//oPrint:Say(nLinInicial + 2870, 0100, aMaestro[19] ,oFont12 ) //Usuario que generó la factura
		oPrint:Say(nLinInicial + (lin := lin + 0)      ,20,"SUBTOTAL $us.                                             " , oFontDet2 )	//SUBTOTAL
		oPrint:Say(nLinInicial +  lin                  ,20,"                                                      "+ FmtoValor(nTotGral,14,2) ,oFontDet2,,,,1 ) //Total General
		oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"DESCUENTOS $us.                                           " , oFontDet2 ) 													//Codigo Control
		oPrint:Say(nLinInicial +  lin                  ,20,"                                                      "+ FmtoValor(nDescuento,14,2) ,oFontDet2,,,,1 ) //Descuentos
		oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"TOTAL $us.                                                " , oFontDet2 ) 													//Codigo Control
		oPrint:Say(nLinInicial +  lin                  ,20,"                                                      "+ FmtoValor(nSubtotal,14,2) ,oFontTitt,,,,1 )  //Total Bolivianos

		oPrint:Say(nLinInicial + (lin := lin + 30)     ,20,"Monto Base P/Debito-                                            ",oFontDet2 )
		oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"Credito Fiscal Bs.                                        ",oFontDet2 )
		oPrint:Say(nLinInicial +  lin                 , 20,"                                                      "+ valorImporteBS ,oFontTitt,,,,1 )  //Total Bolivianos

	endIf

	for i := 1 to len(texto)
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 20, ALLTRIM(texto[i]),oFontDet2 ) //Total  Escrito
	next i

	IF aMaestro[38] == 1
		cImporteDes := (aMaestro[11] * 0.13)
	elseif aMaestro[38] == 2
		cImporteDes := (xMoeda(aMaestro[11],2,1,,2,0,aMaestro[36]) * 0.13)
	endif

	oPrint:Say(nLinInicial + (lin := lin + 20)     ,20,"Monto Efectivo del Credito                                      ",oFontDet2 )
	oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"o Debito(13% del Importe                                        ",oFontDet2 )
	oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"Total Devuelto) Bs.                                         ",oFontDet2 )
	oPrint:Say(nLinInicial + lin                   ,20,"                                                      "+ FmtoValor(cImporteDes,14,2),oFontTitt,,,,1 )  //Total Bolivianos

	oPrint:Say(nLinInicial + (lin := lin + 20) ,20,"      CODIGO DE CONTROL:"   ,oFontDet2 )	//Codigo Control
	oPrint:Say(nLinInicial + lin ,135, aMaestro[12]                    ,oFontTitt )	//Codigo Control

	oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"  FECHA LIMITE DE EMISION:"        ,oFontDet2 ) 		//FECHA LIMITE DE EMISION
	oPrint:Say(nLinInicial + lin ,150,DTOC(STOD(aMaestro[13]))        ,oFontTitt ) 		//FECHA LIMITE DE EMISION

	lin := lin + sumlin

	for i := 1 to len(cDocument)
		oPrint:Say(nLinInicial + (lin := lin + sumlin ), 20, ALLTRIM(cDocument[i]),oFontDet2 )
	next i

	lin := lin + sumlin
	for i := 1 to len(cLey)
		oPrint:Say(nLinInicial + (lin := lin + sumlin ), 20 , ALLTRIM(cLey[i]),oFontDet2 )//obtiene la dosificacion libro fiscales
	next i

	oPrint:Say(nLinInicial + (lin := lin + sumlin) ,20,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )

Return

Static Function FechVcto(cFil,cNroDoc,cPrefijo,cCliente,cLoja)
	Local cFechVcto := ""
	Local 	NextArea	:= GetNextAlias()

	Local cSql	:= "SELECT TOP 1 E1_VENCREA "
	cSql		:= cSql+" FROM " + RetSqlName("SE1") +" SE1 "
	cSql		:= cSql+" WHERE E1_FILIAL='"+cFil+"' AND E1_NUM='"+cNroDoc+"' AND E1_PREFIXO='"+cPrefijo+"' AND E1_CLIENTE='"+cCliente+"' AND E1_LOJA='"+cLoja+"' AND E1_SALDO <> 0 AND SE1.D_E_L_E_T_=' ' "
	cSql		:= cSql+" ORDER BY E1_PARCELA"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	cFechVcto	:= E1_VENCREA

Return cFechVcto

Static Function FmtoValor(cVal,nLen,nDec)
	Local cNewVal := ""
	If nDec == 2
		cOldCfg := __SetPicture("AMERICAN")
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 9,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal

static Function getDescont(cNota,cFilla,cPed) //una linea debería ser
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local acNped := {}

	cQuery := " SELECT "
	cQuery += "   C5_DESC1, C5_DESC2, C5_DESC3, C5_DESC4,C5_DESPESA "
	cQuery += " FROM "
	cQuery += "   " + RetSQLName("SC5") + " SC5 "
	cQuery += " WHERE "
	cQuery += " SC5.D_E_L_E_T_ = ' ' "  // edson
	cQuery += " and C5_FILIAL = '"+cFilla+"' AND C5_NUM = '"+ cPed +"'"

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery New Alias "qrr_SC5"

	While ! qrr_SC5->(EoF())
		AADD(acNped,qrr_SC5->C5_DESC1)
		AADD(acNped,qrr_SC5->C5_DESC2)
		AADD(acNped,qrr_SC5->C5_DESC3)
		AADD(acNped,qrr_SC5->C5_DESC4 )
		nDespesa := qrr_SC5->C5_DESPESA
		qrr_SC5->(DbSkip())
	EndDo

	qrr_SC5->(DbCloseArea())
	RestArea(aArea)

Return acNped

//nQuan cantidad aPerDes - Array de descuentos hay 4 -  nPrunit precio unitario eet
static function getDescPerc(nQuan,aPerDes,nPrunit)
	Local aDesc := {}
	Local nPrUnitari := nPrunit
	Local nTmpDesc := 0 //Descuento al precio unitario 23 - 10% = 2,3
	Local nPrUnAct := 0 //Descuento al precio unitario 23 - 10 = 20,7

	nDestos := len(aPerDes)

	While nDestos > 0
		if aPerDes[nDestos] > 0
			nPrUnAct := nPrUnitari * (aPerDes[nDestos]/100) // 1,15

			nTmpDesc := nPrUnitari - nPrUnAct // 21,85

			nPrUnitari := nTmpDesc
			nDescont := nPrUnAct*nQuan // nahim quitando redondeo
			if lDespesUsada
				nDescont += nDespesa
				lDespesUsada := .F.
			endif

			aadd(aDesc,nDescont)
		else
			aadd(aDesc,0)
		endif
		nDestos--
	enddo

	if(nDestos == 0)// en caso de que el cliente no cuente con ningun descuento . edson 21/05/2019
		aadd(aDesc,0)
		aadd(aDesc,0)
		aadd(aDesc,0)
		aadd(aDesc,0)
	end if

return aDesc

static Function quitZero(cTexto)
	private aArea     := GetArea()
	private cRetorno  := ""
	private lContinua := .T.

	cRetorno := Alltrim(cTexto)

	While lContinua

		If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
			lContinua := .f.
		EndIf

		If lContinua
			cRetorno := Substr(cRetorno, 2, Len(cRetorno))
		EndIf
	EndDo

	RestArea(aArea)

Return cRetorno

static function UgetBonif(nTes, nProducto, nDoc)
	private cQuery:= ""
	private cTemp		:= getNextAlias()
	private aArea	:= GetArea()
	private aProds:= {}

	cQuery+= "SELECT da1.DA1_PRCVEN , DA1_MOEDA , C5_NUM ,C5_TABELA, sd2.D2_PRUNIT, sd2.D2_QUANT , da1.DA1_PRCVEN * sd2.D2_QUANT as totalBoni "
	cQuery+= "from " + RetSqlName("SC5") + " SC5 "
	cQuery+= "JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery+= "ON sd2.D2_PEDIDO = sc5.C5_NUM "
	cQuery+= "join " + RetSqlName("DA1") + " DA1 "
	cQuery+= "ON da1.DA1_CODTAB = sc5.C5_TABELA "
	cQuery+= "WHERE sd2.D2_TES = '"+nTes+"' "
	cQuery+= "and D2_DOC =  '"+nDoc+"' "
	cQuery+= "and da1.DA1_CODPRO = '"+nProducto+"' "

	//aviso("",cQuery,{'ok'},,,,,.t.)
	//	TCQuery cQuery New Alias "QRY_SEL"

	cQuery:= ChangeQuery(cQuery)
	//	Aviso("",cQuery,{'ok'},,,,,.t.)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTemp, .F., .T.)
	dbSelectArea(cTemp)
	dbGoTop()

	if(cTemp)->(!EOF())

		nValor := (cTemp)->DA1_PRCVEN
		aadd(aProds,nValor)
		aadd(aProds,Round((cTemp)->totalBoni ,2))
		(cTemp)->(dbSkip())

	endif

	RestArea(aArea)

return aProds

Static Function TexToArray(cTexto,nTamLine)
	Local aTexto	:= {}
	Local aText2	:= {}
	Local cToken	:= " "
	Local nX
	Local nTam		:= 0
	Local cAux		:= ""

	aTexto := STRTOKARR ( cTexto , cToken )

	For nX := 1 To Len(aTexto)
		nTam := Len(cAux) + Len(aTexto[nX])
		If nTam <= nTamLine
			cAux += aTexto[nX] + IIF((nTam+1) <= nTamLine, cToken,"")
		Else
			AADD(aText2,cAux)
			cAux := aTexto[nX] + cToken
		Endif
	Next nX

	If !Empty(cAux)
		AADD(aText2,cAux)
	Endif

Return(aText2)
