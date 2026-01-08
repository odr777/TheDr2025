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
±±ºPrograma  ³  FactLocal  ºAutor  ³ERICK ETCHEVERRY º 	 Date 0/04/2020   º±±
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

User Function FactLocal(cxNro1,cxNro2,cxSerie,nLinInicia,cOrigCop)
	LOCAL cString		:= "SF2"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Factura"
	LOCAL cDesc1	    := "Factura de venta Bolivia"
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

	Processa({ |lEnd| MOVD3CONF("Impresion de movimientos internos",cxNro1,cxSerie)},"Imprimindo , aguarde...") ////configuraciones de impresion
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg,cxNro1,cxSerie,nLinInicia,cOrigCop)},titulo)

Return

Static Function MOVD3CONF(Titulo,cDoc,cSerie)
	Local cFilename := 'movinterno'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zfact" + dToS(date()) + "_" + alltrim(SUBSTR(TIME(), 1, 2))+ alltrim(SUBSTR(TIME(), 4, 2)) + alltrim(SUBSTR(TIME(), 7, 2)) + cvaltochar(Randomize( 1, 100 )) + cvaltochar(Randomize( 1, 100 ))

	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., cCaminho, .T., , @oPrint, "", , , , .T.)
	//FErase( cCaminho+cArquivo+".pdf" )
	oPrint:cPathPDF := cCaminho
	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetLandscape()
	oPrint:SetPaperSize(0, getSize(cDoc,cSerie) , 215.9)///largo x ancho     milimetros

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
	private nDespesa // nahim Terrazas 18/04/2019
	private lDespesUsada := .T. // nahim Terrazas 22/04/2019
	private valorBonificacion := 0.0
	private nDescPor := 0.0
	private cUgistro := ""
	private cBonusTes  := SuperGetMv("MV_BONUSTS")

	//private oDelete := delFiles():new()
	//alert("")
	If Select("VW_PIMP") > 0
		dbCloseArea()
	Endif

	cQuery	:= "SELECT F2_FILIAL,F2_REFTAXA,F2_REFMOED,F2_SERIE,F2_DOC,F2_NUMAUT,F2_EMISSAO,F2_UNOMCLI,F2_UNITCLI,F2_COND,F2_VALBRUT F2_VALFAT,ROUND(F2_DESCONT,2) F2_DESCONT,F2_BASIMP1,F2_CODCTR,FP_DTAVAL,F2_USRREG,D2_PEDIDO,A1_MUN, A1_BAIRRO,A1_END"
	cQuery		:= cQuery+",F2_CLIENTE,F2_LOJA,F2_ESPECIE,F2_VEND1,D2_REMITO,D2_SERIREM,D2_CLIENTE,D2_COD,D2_ITEM,D2_FILIAL,D2_LOJA,F2_HORA,E4_DESCRI,F2_MOEDA,F2_TXMOEDA,A3_NOME , A3_NREDUZ,A1_UNOMFAC, F2_USERLGI "
	cQuery		:= cQuery+" FROM " + RetSqlName("SF2 ") +" SF2 JOIN " + RetSqlName("SA1") +" SA1 ON (A1_COD=F2_CLIENTE  AND SA1.D_E_L_E_T_ =' ' AND A1_LOJA=F2_LOJA ) "
	cQuery		:= cQuery+" JOIN " + RetSqlName("SD2") +" SD2 ON (D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_LOJA=F2_LOJA AND D2_ITEM='01' AND SD2.D_E_L_E_T_ =' ') "
	cQuery		:= cQuery+" JOIN " + RetSqlName("SFP") +" SFP ON (FP_FILUSO=F2_FILIAL AND FP_SERIE=F2_SERIE AND SFP.D_E_L_E_T_ =' ') "
	cQuery		:= cQuery+" JOIN " + RetSqlName("SE4") +" SE4 ON (E4_CODIGO = F2_COND)"
	cQuery		:= cQuery+" JOIN " + RetSqlName("SA3") +" SA3 ON (A3_COD = F2_VEND1)"
	cQuery		:= cQuery+" WHERE (F2_DOC BETWEEN '"+cDoc1+"' AND '"+cDoc1+ "' ) AND F2_SERIE='"+cSerie+"' AND SF2.D_E_L_E_T_ =' ' AND F2_ESPECIE='NF'"
	cQuery		:= cQuery+" AND F2_FILIAL='" + xFilial("SF2") + "' "
	cQuery		:= cQuery+" Order By F2_DOC"

	/*If __CUSERID = '000000'
	Aviso("GTAPRECG",cQuery,{'ok'},,,,,.t.)
	EndIf*/

	TCQuery cQuery New Alias "VW_PIMP"
	cNomCli:= ""
	cUgistro := USRFULLNAME(SUBSTR(EMBARALHA(VW_PIMP->F2_USERLGI,1),3,6))
	If !Empty(VW_PIMP->D2_REMITO)
		cPedid:= GETADVFVAL("SD2","D2_PEDIDO",VW_PIMP->D2_FILIAL+VW_PIMP->D2_SERIREM+VW_PIMP->D2_REMITO,17,"erro")
		cNomCli:= Posicione("SC5",1,xFilial("SC5")+cPedid,"C5_UNOMCLI")
	else
		cPedid := VW_PIMP->D2_PEDIDO
		if !empty(cPedid)
			cNomCli:= Posicione("SC5",1,xFilial("SC5")+cPedid,"C5_UNOMCLI")
		else
			cNomCli:=VW_PIMP->A1_UNOMFAC
		endif
	ENDIF

	Count To nTotal
	ProcRegua(nTotal)
	VW_PIMP->(DbGoTop())

	if !EMPTY(alltrim(VW_PIMP->F2_UNITCLI))/// sin nit
		if(!EMPTY(VW_PIMP->F2_NUMAUT))

			if ! VW_PIMP->(EoF())

				AADD(aDupla,VW_PIMP->F2_FILIAL)		  	//1
				AADD(aDupla,VW_PIMP->F2_SERIE)           //2
				AADD(aDupla,VW_PIMP->F2_DOC)             //3
				AADD(aDupla,VW_PIMP->F2_NUMAUT)          //4
				AADD(aDupla,VW_PIMP->F2_EMISSAO)         //5
				AADD(aDupla,cNomCli)         //6
				AADD(aDupla,VW_PIMP->F2_UNITCLI)         //7
				AADD(aDupla,VW_PIMP->F2_COND)            //8
				AADD(aDupla,VW_PIMP->F2_VALFAT)          //9
				AADD(aDupla,VW_PIMP->F2_DESCONT)         //10
				AADD(aDupla,VW_PIMP->F2_BASIMP1)  		//11
				AADD(aDupla,VW_PIMP->F2_CODCTR)          //12
				AADD(aDupla,VW_PIMP->FP_DTAVAL)          //13
				AADD(aDupla,NIL)		        //14	//	AADD(aDupla,F2_UNROIMP)		    //14
				AADD(aDupla,cPedid)		        //15
				AADD(aDupla,VW_PIMP->A1_MUN)		    	//16
				AADD(aDupla,VW_PIMP->A1_BAIRRO)		    //17
				AADD(aDupla,VW_PIMP->A1_END)		        //18	//	AADD(aDupla,A1_UDIRFAC)		    //18
				AADD(aDupla,VW_PIMP->F2_USRREG)		    //19
				AADD(aDupla,VW_PIMP->F2_CLIENTE)		    //20
				AADD(aDupla,VW_PIMP->F2_LOJA)		    //21
				AADD(aDupla,VW_PIMP->F2_ESPECIE)		    //22
				AADD(aDupla,NIL)			    //23	//	AADD(aDupla,FP_SFC)			    //23
				AADD(aDupla,NIL)			    //24	//	AADD(aDupla,F2_UAUTPRC)			//24
				AADD(aDupla,VW_PIMP->F2_VEND1)			//25
				AADD(aDupla,VW_PIMP->F2_REFTAXA)			//26
				AADD(aDupla,VW_PIMP->F2_REFMOED)			//27
				AADD(aDupla,VW_PIMP->F2_HORA)			//28
				AADD(aDupla,VW_PIMP->E4_DESCRI)          //29
				AADD(aDupla,VW_PIMP->F2_MOEDA)           //30
				AADD(aDupla,VW_PIMP->F2_TXMOEDA)         //31
				AADD(aDupla,VW_PIMP->A3_NREDUZ)          //32

				aDetalle := FatDet (VW_PIMP->F2_DOC,VW_PIMP->F2_SERIE)                	   	//Datos detalle de factura

				//Aviso("Array IVA",u_zArrToTxt(aDetalle, .T.),{'ok'},,,,,.t.)

				nCantReg := len(aDetalle)//cantidad de registros

				cFilFact := aDupla[1]
				DbSelectArea("SM0")
				SM0->(DBSETORDER(1))
				SM0->(DbSeek(cEmpAnt+cFilFact))

				cDireccion := TexToArray(AllTrim(SM0->M0_ENDENT),29)
				Csucursal := TexToArray(AllTrim("SUCURSAL - "+AllTrim(SM0->M0_CODFIL)),15)
				cTelefono := "Telf.: "+AllTrim(SM0->M0_TEL)
				cNombreSucursal := AllTrim(SM0->M0_FILIAL)
				cDepartamento := AllTrim(SM0->M0_CIDENT)+" - Bolivia"

				nAtual := fImpCab(nLinInicial,aDupla,cOrigCop,cDireccion,cTelefono,Csucursal,cNombreSucursal,cDepartamento)

				//carga descuentos en array de descuento
				nDim:=len(aDetalle)
				For nA:=1 to nDim
					nDes1 = nDes1 + aDetalle[nA][7]
					nDes2 = nDes2 + aDetalle[nA][8]
					nDes3 = nDes3 + aDetalle[nA][9]
					nDes4 = nDes4 + aDetalle[nA][10]
				Next
				///array descuentos
				aadd(aDescTot,nDes1)
				aadd(aDescTot,nDes2)
				aadd(aDescTot,nDes3)
				aadd(aDescTot,nDes4)

				///printando items

				_linAux += nLinAtu
				_nInterLin += _linAux + 10

				For nI:=1 to nDim   //los productos lineas

					/*if( aDetalle[nI][12] == cBonusTes) //viendo si es tes bonificacion
					aProds := UgetBonif(aDetalle[nI][12],aDetalle[nI][1],aDetalle[nI][14])  //paso tes producto documento factura
					if !empty(aProds)
					oPrint:SayAlign(_linAux, 10,""+aDetalle[nI][11], oFontDet, 400, , ,,)
					oPrint:SayAlign(_linAux, 10,"           "+aDetalle[nI][2], oFontDet, 400, , ,,)
					oPrint:SayAlign(_nInterLin, 10,"        "+  cValToChar(aDetalle[nI][4]), oFontDet, 400, , ,,)//cantidad
					oPrint:SayAlign(_nInterLin, 10,"                               "+FmtoValor(aProds[1],14,2), oFontDet, 400, , ,,) ///precio
					oPrint:SayAlign(_nInterLin, 10,"                                                                "+FmtoValor(aProds[2],14,2), oFontDet, 400, , ,,) ////total
					nAuxboni := aProds[1]
					valorBonificacion  +=  nAuxboni
					nDescPor += aDetalle[nI][13]
					endif
					else*/  ///lo que trajo del query
					oPrint:SayAlign(_linAux, 10,""+aDetalle[nI][11], oFontDet, 400, , ,,)
					oPrint:SayAlign(_linAux, 10,"           "+aDetalle[nI][2], oFontDet, 400, , ,,)
					oPrint:SayAlign(_nInterLin, 10,"        "+ cValToChar(aDetalle[nI][4]), oFontDet, 400, , ,,)//cantidad
					oPrint:SayAlign(_nInterLin, 10,"                               "+FmtoValor(aDetalle[nI][5],14,2), oFontDet, 400, , ,,)
					oPrint:SayAlign(_nInterLin, 10,"                                                                "+FmtoValor(aDetalle[nI][6],14,2), oFontDet, 400, , ,,)

					//endif

					_linAux:=_linAux+20
					_nInterLin:=_nInterLin+20

					_nlindet:=mlcount(allTrim(aDetalle[nI][2]),_tamdesc)

					If _nlindet > 1
						For nIb := 2 To  _nlindet

							oPrint:Say(_nInterLin,320,memoline(aDetalle[nI][2],_tamdesc,nIb),oFont08)  //Descripcion
							_nInterLin:=_nInterLin+10
						Next nIb
					EndIf

				Next nI

				PieFact(_nInterLin,aDupla,aDescTot)

			Endif
		ELSE
			MSGINFO("Código de Dosificación Invalido para imprimir la Factura")
		endif
	else
		MSGINFO("Factura sin NIT es Invalida para imprimir")
	endif

	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod()
	EndIf

	//Mostrando o relatório
	oPrint:Preview()

	For nX := 1 to 10

		If ! File(cArquivo)

			Sleep(400)

		EndIf

	Next nX

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
	local cNombreEDV := "EDV :  "+aMaestro[32]

	//Iniciando Página
	oPrint:StartPage()

	//Cabeçalho
	cTexto := "UNION CENTRO"
	oPrint:SayAlign(nLinCab, 70, cTexto, oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 65, "VETERINARIO S.R.L", oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	for i := 1 to len(Csucursal)
		oPrint:SayAlign(nLinCab, 60, ALLTRIM(Csucursal[i]), oFontTitt, 400, , ,,)
		nLinCab += (nTamLin * 1)
	next i
	oPrint:SayAlign(nLinCab, 57, ""+alltrim(cNombreSucursal), oFontTitt, 400, , ,,)
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
	oPrint:SayAlign(nLinCab, 57,"FACTURA", oFontDet2, 400, , ,,)
	oPrint:SayAlign(nLinCab -0.5, 100,cTipo, oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 57,"EDV :   "+ FWLeUserlg("F2_USERLGI") /*USRFULLNAME(SUBSTR(EMBARALHA(cUgistro,1),3,6))*/ , oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 57,"Usuario :   "+cUserName, oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 68,"NIT :   "+AllTrim(SM0->M0_CGC), oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 30,"FACTURA No.   "+quitZero(aMaestro[3]), oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 25,"AUTORIZACION No.  "+ aMaestro[4], oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 30,"Venta al por mayor de otros productos", oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 25," FECHA:   " +DTOC(STOD(aMaestro[5])) + " HORA:  "+ aMaestro[28], oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 65," NIT/CI: " + aMaestro[7] , oFontTitt, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 28," SEÑOR(ES):      " , oFontDet2, 400, , ,,)
	for i := 1 to len(cNombreCli)
		oPrint:SayAlign(nLinCab, 90,ALLTRIM(cNombreCli[i]) , oFontTitt, 400, , ,,)
		nLinCab += (nTamLin * 1)
	next i
	oPrint:SayAlign(nLinCab, 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", oFontDet3, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"FAB       CONCEPTO                                                         " , oFontDet2, 400, , ,,)
	nLinCab += (nTamLin * 1)
	oPrint:SayAlign(nLinCab, 3,"        CANT                  PRECIO                   TOTAL   " , oFontDet2, 400, , ,,)
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
static function FatDet (cDoc,cSerie) // Datos detalle de factura
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	cLote		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT B1_COD, CASE WHEN LEN(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), C6_UDESCLA)),''))=0 THEN C6_DESCRI ELSE C6_DESCRI END B1_DESC, "
	cSql				:= cSql+"SUM(D2_QUANT) D2_QUANT, SUM(D2_DESCON) D2_DESCON,D2_TES ,  B1_UFABRIC,"
	cSql				:= cSql+"CASE WHEN D2_PRUNIT !=0 THEN D2_PRUNIT ELSE D2_PRCVEN END D2_PRUNIT,"
	cSql				:= cSql+"CASE WHEN D2_PRUNIT!=0 THEN SUM(D2_QUANT)*D2_PRUNIT ELSE SUM(D2_QUANT)*D2_PRCVEN END D2_TOTAL, "
	cSql				:= cSql+"D2_PEDIDO , D2_DOC ,D2_FILIAL  "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON (D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND  D2_COD=B1_COD AND D2_ESPECIE='NF' AND SD2.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' ) "
	cSql				:= cSql+"LEFT JOIN "+ RetSqlName("SC6") +" SC6 ON (C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM) AND SC6.D_E_L_E_T_=' ' "
	cSql				:= cSql+"GROUP BY B1_COD,C6_DESCRI,C6_UDESCLA,D2_PRUNIT,D2_PRCVEN,D2_TES,B1_UFABRIC,D2_PEDIDO,D2_DOC,D2_FILIAL "
	cSql				:= cSql+"ORDER BY D2_PEDIDO"

	//		Aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	cPedc5 := ""
	aDescon := {}

	While !Eof()
		if cPedc5 <> D2_PEDIDO
			aDescon := getDescont(D2_DOC,D2_FILIAL,D2_PEDIDO)
		endif
		cPedc5 := D2_PEDIDO

		cProducto	:=B1_COD
		cNombre		:=B1_DESC

		cPedido		:= D2_PEDIDO
		nCant		:= D2_QUANT
		nPrecio		:= D2_PRUNIT
		nTotal		:= Round(nCant*nPrecio,2)
		cFab        := B1_UFABRIC
		cTES        := D2_TES
		cDescont    := D2_DESCON
		ndocument   := D2_DOC
		aPerc := getDescPerc(nCant,aDescon,nPrecio) //Descuentos

		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,cLote)      //3
		AADD(aDupla,nCant)      //4
		AADD(aDupla,nPrecio)    //5
		AADD(aDupla,nTotal)     //6
		AADD(aDupla,aPerc[1])     //7 desc 1 usados de cliente
		AADD(aDupla,aPerc[2])     //8 desc 2
		AADD(aDupla,aPerc[3])     //9 desc 3
		AADD(aDupla,aPerc[4])     //10 desc 4 usados otros
		AADD(aDupla,cFab)        //11
		AADD(aDupla,cTES)        //12
		AADD(aDupla,cDescont)    //13
		AADD(aDupla,ndocument)    //14

		AADD(aDatos,aDupla)

		nValor := round( (nPrecio * nCant ), 2)

		if( D2_TES == cBonusTes)
			valorBonificacion  +=  nValor
			nDescPor += D2_DESCON
		endif
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

	nItemSize := vwsize->tot * 6.2

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

	If aMaestro[30] == 1
		texto := TexToArray("Son: "+Extenso(aMaestro[11],.F.,1)+" BOLIVIANOS ",40)
	elseIF aMaestro[30] == 2
		valorBsLiteral := ROUND(xMoeda(aMaestro[11],2,1,aMaestro[5],3,0,aMaestro[26]),2)
		//xMoeda(aMaestro[11],2,1,,2,0,aMaestro[26])///OK LATER
		texto := TexToArray("Son: "+Extenso(valorBsLiteral,.F.,1)+" BOLIVIANOS (T/C: "+ alltrim(TRANSFORM(aMaestro[31],"@E 9,999,999,999.99")) + ")",40)
	end if

	nSubtotal  := aMaestro[9]   ///valfat
	//	alert(nSubtotal)
	nDescuento := aMaestro[10] + valorBonificacion   ///descuento + bonificacion
	nDescuento  = nDescuento - nDescPor
	//	alert(aMaestro[10])
	//	alert(nDescuento)
	nTotGral   := NOROUND(nSubtotal+nDescuento,2)
	//	alert(nTotGral)
	//	alert(aMaestro[26])
	//
	If aMaestro[30] == 1

		oPrint:Say(nLinInicial                        , 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )
		oPrint:Say(nLinInicial + lin                  , 3,"SUBTOTAL Bs.                                          "            ,oFontDet2 )
		oPrint:Say(nLinInicial + lin                  , 3,"                                                             "+FmtoValor(nTotGral,14,2) ,oFontDet2,,,,1 )  // subtotal boliviano
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"DESCUENTOS Bs.                                     "            ,oFontDet2 )
		oPrint:Say(nLinInicial + lin                  , 3,"                                                              "+FmtoValor(nDescuento,14,2) ,oFontDet2,,,,1 )	//descuentos boliviano
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"TOTAL BS.                                             "           ,oFontDetN9 )
		oPrint:Say(nLinInicial + lin                  , 3,"                                                                     "+FmtoValor(aMaestro[11],14,2) ,oFontDetN9,,,,1)  //Total bolivianos
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )

		//	xMoeda(aMaestro[11],1,2,,2,1,aMaestro[26])

		oPrint:Say(nLinInicial + (lin := lin + 50)    , 3,"Importe base para                                     "            ,oFontDetN9 )
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"Credito fiscal.                          Bs.           "            ,oFontDetN9 )
		oPrint:Say(nLinInicial + lin                  , 3,"                                                                     "+FmtoValor(ROUND(aMaestro[11],2),14,2) ,oFontDetN9,,,,1)  //Total Bolivianos

		lin := lin + 30
		for i := 1 to len(texto)
			oPrint:Say(nLinInicial + (lin := lin + sumlin), 3, ALLTRIM(texto[i]),oFontDetN9 ) //Total  Escrito
		next i

	elseIF aMaestro[30] == 2

		valordescuento := FmtoValor(xMoeda(nDescuento,2,1,aMaestro[5],4,0,aMaestro[26]),14,2)
		valorSubtotal := FmtoValor(ROUND(xMoeda(nTotGral,2,1,aMaestro[5],3,0,aMaestro[26]),2),14,2)
		valorImporteBS := FmtoValor(ROUND(xMoeda(aMaestro[11],2,1,aMaestro[5],3,0,aMaestro[26]),2),14,2)

		//		alert(aMaestro[26])
		//		alert(valorImporteBS)

		oPrint:Say(nLinInicial                        , 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )
		oPrint:Say(nLinInicial + lin                  , 3,"SUBTOTAL $us.                                         "            ,oFontDet2 )
		oPrint:Say(nLinInicial + lin                  , 3,"                                                             "+FmtoValor(nTotGral,14,2) ,oFontDet2,,,,1 )  // subtotal dolar
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"DESCUENTOS $us.                                    "               ,oFontDet2 )
		oPrint:Say(nLinInicial + lin                  , 3,"                                                              "+FmtoValor(nDescuento,14,2)  ,oFontDet2,,,,1 )	//descuentos dolar
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"TOTAL $us.                                            "            ,oFontDetN9 )
		oPrint:Say(nLinInicial + lin                  , 3,"                                                                     "+FmtoValor(aMaestro[11],14,2) ,oFontDetN9,,,,1)  //Total dolar
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )

		//	xMoeda(aMaestro[11],1,2,,2,1,aMaestro[26])

		oPrint:Say(nLinInicial + (lin := lin + 5)    , 3,"Importe base para                                     "            ,oFontDetN9 )
		oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"Credito fiscal.                           Bs.           "            ,oFontDetN9 )
		oPrint:Say(nLinInicial + lin                  , 3,"                                                                    "+valorImporteBS ,oFontDetN9,,,,1)  //Total Bolivianos

		lin := lin + 10
		for i := 1 to len(texto)
			oPrint:Say(nLinInicial + (lin := lin + sumlin), 3, ALLTRIM(texto[i]),oFontDetN9 ) //Total  Escrito
		next i

	end if

	If aMaestro[8]=="001"
		cFecVen := DTOC(STOD(aMaestro[5]))
	Else
		cFecVen := FechVcto(aMaestro[1],aMaestro[3],aMaestro[2],aMaestro[20],aMaestro[21])
		If !Empty(cFecVen)
			cFecVen := DTOC(STOD(cFecVen))
		Else
			cFecVen := DTOC(STOD(aMaestro[5]))
		EndIf
	EndIf

	oPrint:Say(nLinInicial + (lin := lin + 10)    , 3,"VCTO:      "            ,oFontDet2 )
	oPrint:Say(nLinInicial + lin                  , 3,"                    "+ cFecVen  ,oFontDet2,,,,1)
	oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"CONDPAGO:  "            ,oFontDet2 )
	oPrint:Say(nLinInicial + lin                  , 3,"                          "+ aMaestro[29] ,oFontDet2,,,,1)

	oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )
	oPrint:Say(nLinInicial + (lin := lin + 10)    , 3,"      CODIGO DE CONTROL:      "                                        ,oFontDet2 )	//Codigo Control
	oPrint:Say(nLinInicial +  lin                 , 3,"                                                   "+aMaestro[12]                    ,oFontDetN9 )	//Codigo Control
	oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"      FECHA LIMITE DE EMISION:    "                                 ,oFontDet2 ) 		//FECHA LIMITE DE EMISION
	oPrint:Say(nLinInicial +  lin                 , 3,"                                                             "+DTOC(STOD(aMaestro[13])),oFontDetN9 ) 		//FECHA LIMITE DE EMISION

	If aMaestro[30] == 1
		qr := AllTrim(SM0->M0_CGC) +"|"  			                       //NIT EMPRESA
		qr += AllTrim(quitZero(aMaestro[3])) +"|" 	                       //NUMERO DE FACTURA
		qr += AllTrim(aMaestro[4]) +"|"                                    //NUMERO DE AUTORIZACION
		qr += DTOC(STOD(aMaestro[5])) +"|"                                 //FECHA DE EMISION
		qr += AllTrim(Transform(nTotGral,"@E 99,999,999,999.99")) +"|"     //MONTO TOTAL CONSIGNADO EN LA FACTURA
		qr += AllTrim(Transform(aMaestro[11],"@E 99,999,999,999.99")) +"|" //IMPORTE BASE PARA CREDITO FISCAL
		qr += AllTrim(aMaestro[12]) +"|"                                   //CODIGO DE CONTROL
		qr += AllTrim(aMaestro[7]) +"|"                    			  	   //NIT DEL COMPRADOR
		qr += "0.00" +"|"                                                     //IMPORTE ICE/ IEHD / TASAS
		qr += "0.00" +"|"                                                     //IMPORTE POR VENTAS NO GRAVADAS O GRAVADAS A TASA CERO
		qr += "0.00" +"|"                                                     //IMPORTE NO SUJETO A CREDITO FISCAL
		qr += AllTrim(Transform(aMaestro[10],"@E 99,999,999,999.99"))      //DESCUENTOS, BONIFICACIONES Y REBAJAS OBTENIDAS
	elseIF aMaestro[30] == 2
		qr := AllTrim(SM0->M0_CGC) +"|"  			                       //NIT EMPRESA
		qr += AllTrim(quitZero(aMaestro[3])) +"|" 	                       //NUMERO DE FACTURA
		qr += AllTrim(aMaestro[4]) +"|"                                    //NUMERO DE AUTORIZACION
		qr += DTOC(STOD(aMaestro[5])) +"|"                                 //FECHA DE EMISION
		qr += Alltrim(valorSubtotal)  +"|"                                          //MONTO TOTAL CONSIGNADO EN LA FACTURA
		qr += Alltrim(valorImporteBS) +"|"                                          //IMPORTE BASE PARA CREDITO FISCAL
		qr += AllTrim(aMaestro[12]) +"|"                                   //CODIGO DE CONTROL
		qr += AllTrim(aMaestro[7]) +"|"                    			  	   //NIT DEL COMPRADOR
		qr += "0.00" +"|"                                                     //IMPORTE ICE/ IEHD / TASAS
		qr += "0.00" +"|"                                                     //IMPORTE POR VENTAS NO GRAVADAS O GRAVADAS A TASA CERO
		qr += "0.00" +"|"                                                     //IMPORTE NO SUJETO A CREDITO FISCAL
		qr += AllTrim(valordescuento)                                      //DESCUENTOS, BONIFICACIONES Y REBAJAS OBTENIDAS
	endif
	/*cFile = u_TDEPQR(qr) //llama al qrtdep
	oPrint:SayBitmap(nLinInicial + (lin := lin + 100), 280,cFile,300,300)*/

	oPrint:QRCode(nLinInicial + (lin := lin + 135),45,qr, 120)
	lin := lin + 20

	for i := 1 to len(cDocument)
		oPrint:Say(nLinInicial + (lin := lin + sumlin ), 3, ALLTRIM(cDocument[i]),oFontDetN9 ) //Total  Escrito
	next i

	for i := 1 to len(cLey)
		oPrint:Say(nLinInicial + (lin := lin + sumlin ), 3 , ALLTRIM(cLey[i]),oFontDet )//obtiene la dosificacion libro fiscales
	next i

	oPrint:Say(nLinInicial + (lin := lin + sumlin), 3,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" ,oFontDet3 )
	oPrint:Say(nLinInicial + (lin := lin + 10)    , 3,"           NO SE ACEPTAN DEVOLUCIONES                            " ,oFontDet2 )
	oPrint:Say(nLinInicial + (lin := lin + 10)    , 3,"                                                     "+aMaestro[20]+"-"+aMaestro[21]+"-"+aMaestro[2],oFontDet2 )
	oPrint:Say(nLinInicial + (lin := lin + 20), 3,"." ,oFontDet)
	valorBonificacion = 0.0
	nDescPor = 0.0

Return

Static Function FechVcto(cFil,cNroDoc,cPrefijo,cCliente,cLoja)
	Local cFechVcto := ""
	Local 	NextArea	:= GetNextAlias()

	Local cSql	:= "SELECT TOP 1 E1_VENCREA "
	cSql		:= cSql+" FROM " + RetSqlName("SE1") +" SE1 "
	cSql		:= cSql+" WHERE E1_FILIAL='"+cFil+"' AND E1_NUM='"+cNroDoc+"' AND E1_PREFIXO='"+cPrefijo+"' AND E1_CLIENTE='"+cCliente+"' AND E1_LOJA='"+cLoja+"' AND SE1.D_E_L_E_T_=' ' "
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

	cQuery:= ChangeQuery(cQuery)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTemp, .F., .T.)
	dbSelectArea(cTemp)
	dbGoTop()

	if(cTemp)->(!EOF())

		nValor := (cTemp)->DA1_PRCVEN
		aadd(aProds,nValor)    ///precio
		aadd(aProds,Round((cTemp)->totalBoni ,2))  ////total
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
