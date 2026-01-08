#include "totvs.ch"
#include "adprint.ch"

/*/{Protheus.doc} COL020
Impressão de Despaho
@type function
@version 1.0
@author Luiz Fael
@since 03/02/2023
@return variant, return_Nill
/*/
User Function COL020()
	Local nFila		:= 950
	Local cNf 		:= 'depacho'+Alltrim(SC5->C5_NUM)
	Local nX 		:= 0
	Local oPrn
	Local oProcess
	Private OTEXT
	Private oLx
	DEFINE FONT oFontA6  	NAME "Arial" SIZE 0,06 OF oPrn
	DEFINE FONT oFontAB6 	NAME "Arial" SIZE 0,06 OF oPrn BOLD
	DEFINE FONT oFontA7  	NAME "Arial" SIZE 0,07 OF oPrn
	DEFINE FONT oFontAB7 	NAME "Arial" SIZE 0,07 OF oPrn BOLD
	DEFINE FONT oFontA8  	NAME "Arial" SIZE 0,08 OF oPrn
	DEFINE FONT oFontAB8 	NAME "Arial" SIZE 0,08 OF oPrn BOLD
	DEFINE FONT oFontA9  	NAME "Arial" SIZE 0,09 OF oPrn
	DEFINE FONT oFontAB9 	NAME "Arial" SIZE 0,09 OF oPrn BOLD
	DEFINE FONT oFontA10  	NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oFontAB10 	NAME "Arial" SIZE 0,10 OF oPrn BOLD
	DEFINE FONT oFontA11  	NAME "Arial" SIZE 0,11 OF oPrn
	DEFINE FONT oFontAB11 	NAME "Arial" SIZE 0,11 OF oPrn BOLD
	DEFINE FONT oFontA12  	NAME "Arial" SIZE 0,12 OF oPrn
	DEFINE FONT oFontAB12 	NAME "Arial" SIZE 0,12 OF oPrn BOLD
	DEFINE FONT oFontA14  	NAME "Arial" SIZE 0,14 OF oPrn
	DEFINE FONT oFontAB14 	NAME "Arial" SIZE 0,14 OF oPrn BOLD
	DEFINE FONT oFontA16  	NAME "Arial" SIZE 0,16 OF oPrn
	DEFINE FONT oFontAB16  	NAME "Arial" SIZE 0,16 OF oPrn BOLD
	DEFINE FONT oFontA20  	NAME "Arial" SIZE 0,20 OF oPrn
	DEFINE FONT oFontAB20  	NAME "Arial" SIZE 0,20 OF oPrn BOLD
	DEFINE FONT oFontABI22 	NAME "Arial" SIZE 0,22 OF oPrn ITALIC BOLD
	MV_PAR4 		:= IIf(right(MV_PAR4,1) != "\",MV_PAR4+"\",MV_PAR4)
	nFila 			:= 950
	oPrn 			:= FWMSPrinter():New( cNf + ".pdf",6,.T., , .T.)
	oPrn:cPathPDF 	:= MV_PAR4
	oPrn:CPrinter 	:= "PDF"
	oPrn:SetResolution(72) //Dado grava do campo
	oPrn:SetPortrait()
	oPrn:SetPaperSize(9)  // Hoja A4
	//oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
	aRemitos:= getRemitos()
	for nX:= 1 to Len(aRemitos)
		// SEQUENCIA DE IMPRESSÃO
		oPrn:StartPage()
		// Inicia a Impressão da NF
		oProcess := MsNewProcess():New( {|lEnd| ImpSeq(oProcess,oPrn,aRemitos[nX]) } , "Imprimindo Remito..." , "Ordem de Venta..." )
		oProcess:Activate()
		oPrn:EndPage()
	next nX
	//MsProcTxt('Aguarde Gravando '+cNf) //"Processando Prestador "
	oPrn:Preview()
	FreeObj(oPrn)
	FreeObj(oProcess)
Return()

/**
* @author: Denar Terrazas Parada
* @since: 05/05/2023
* @description: Funcion que retorna los remitos que tiene el pedido.
*/
Static Function getRemitos()
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local cAliasQry		:= GetNextAlias()
	Local cQuery		:= ""

	cQuery += "SELECT DISTINCT SF2.F2_DOC "
	cQuery += "FROM " + RetSQLName("SC5") + " SC5 "
	cQuery += "    INNER JOIN " + RetSQLName("SD2") + " SD2 "
	cQuery += "		     ON (SD2.D2_FILIAL = '" +MV_PAR1+ "' "
	cQuery += "			 AND SD2.D2_PEDIDO = '" +MV_PAR2+ "' "
	cQuery += "			 AND SD2.D_E_L_E_T_ = ' ')  "
	cQuery += "    INNER JOIN " + RetSQLName("SF2") + " SF2 "
	cQuery += "		    ON (SF2.F2_FILIAL   = SD2.D2_FILIAL "
	cQuery += "			AND SF2.F2_DOC   	= SD2.D2_DOC    "
	cQuery += "			AND SF2.F2_SERIE 	= SD2.D2_SERIE  "
	cQuery += "			AND SF2.D_E_L_E_T_ = ' ')
	cQuery += "WHERE "
	cQuery += " 		SC5.C5_FILIAL     = '" +MV_PAR1+ "' "
	cQuery += "         AND SC5.C5_NUM    = '" +MV_PAR2+ "' "
	//cQuery += "         AND (SC5.C5_NOTA   = 'REMITO' OR SC5.C5_NOTA<>'')  "
	cQuery += "         AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SF2.F2_DOC"

	//aviso("Query",cQuery,{'Ok'},,,,,.t.)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

	While (cAliasQry)->( !EOF() )
		AADD(aRet, (cAliasQry)->F2_DOC)
		(cAliasQry)->( DBSKIP() )
	Enddo

	restArea(aArea)

Return aRet

/*/{Protheus.doc} ImpSeq
Sequencia de Impressao
@type function
@version 1.0
@author Luiz Fael
@since 04/01/2023
@return variant, Nill
/*/
Static Function ImpSeq(oProcess,oPrn,cDoc)
	Local aNF_Print		:= {}	//aSF2[02] Nota Fiscal
	Local aClient_Print	:= {}	//aSF2[03] Cliente
	Local aVend_Print	:= {}	//aSF2[06] Vendedor
	Local aTrans_Print	:= {}	//Transportadora
	Local aSF2			:= {}
	Local aSD2			:= {}
	Local aEmp 			:= U_SM0Cab(cEmpAnt,cFilAnt)
	Local nLinha		:= 20
	Local nRegua 		:= 7
	U_COL011(oProcess,oPrn,@aSF2,@aSD2, cDoc) //Dado grava do campo
	If Len(aSF2)  == 0
		MsgStop("¡Erro:Sem dados Despacho! ")
	Else
		If Len(aSF2[05]) == 0
			MsgStop("¡Erro:Sem dados Cliente! ")
		Else
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			aNF_Print		:= aSF2[02]		//aSF2[02] Nota Fiscal
			aClient_Print	:= aSF2[03]		//aSF2[03] Cliente
			aVend_Print		:= aSF2[06]		//aSF2[06] Vendedor
			aTrans_Print	:= aSF2[07]		//Transportadora
			oProcess:SetRegua1(nRegua)
			PrintHead(oProcess,oPrn,@nLinha,aNF_Print,aClient_Print,aEmp,aTrans_Print)
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			PrintLine(oProcess,oPrn,@nLinha,aSD2,aNF_Print,aClient_Print,aEmp,aVend_Print) //Dado grava do campo
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			PrintRodape(oProcess,oPrn,@nLinha,aClient_Print,aNF_Print)
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
		EndIf
	EndIf
	FwFreeArray(aNF_Print)
	FwFreeArray(aClient_Print)
	FwFreeArray(aVend_Print)
	FwFreeArray(aTrans_Print)
	FwFreeArray(aSF2) //Dado grava do campo
	FwFreeArray(aSD2) //Dado grava do campo
	FwFreeArray(aEmp)
Return

/*/{Protheus.doc} PrintHead
IMPRIME CABECHALHO
FWMsPrinter(): Box ( < nRow>, < nCol>, < nBottom>, < nRight>, [ cPixel] ) -->
Nome	Tipo		Descrição											Obrigatório
nRow	Numérico	Indica a coordenada vertical em pixels.				X	
nCol	Numérico	Indica a coordenada horizontal em pixels.			X	
nBottom	Numérico	Indica a posição do objeto em relação ao rodapé.	X	
nRight	Numérico	Indica a posição do objeto à direita.				X	
cPixel	Caracter	Expessura da linha em pixels. Default é "-2"	
FWMsPrinter(): Cmtr2Pix ( [ nLinha], [ nCol] ) 
nLinha	Numérico	Indica a linha que será calculada.
nCol	Numérico	Indica a coluna que será calculada.
nCol1 := 10
nRow1 := 10
oPrinter:Cmtr2Pix( nCol1, nRow1)
//Resultado//
nCol1  := 1107.08955224
nRow1 := 1107.26600985
@type function
@version 1.0
@author Luiz Fael
@since 15/12/2022
@param nLinha, numeric, linha de impressão
@param aSF2, array, matriz de dados SF2
@param aSD2, array, matriz de dados SD2
@return variant, nill
/*/
Static Function PrintHead(oProcess,oPrn,nLinha,aNF_Print,aClient_Print,aEmp,aTrans_Print)
	Local cTexto 		:= ''
	Local cCli_Cod 		:= ''
	Local cCli_Loj 		:= ''
	Local cBar 			:= ''
	Local cMun 			:= ''
	Local cEst 			:= ''
	oProcess:SetRegua2(7)
	//+-------------------------------------+
	//¦ Impressao do Cabecalho da N.F.      ¦
	//+-------------------------------------+
	fDetProd(oProcess,oPrn,@nLinha,{},aNF_Print,{},aEmp,4)
	cCli_Cod := 'Cod.' + U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_COD'		,aClient_Print,3)
	cCli_Loj := 		 U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_LOJA'		,aClient_Print,3)
	cCli_Loj := IIf(!Empty(cCli_Loj),'-'+cCli_Loj,'')
	cTexto 	 := cCli_Cod+cCli_Loj
	oPrn:Box(nLinha+20,0090,nLinha+350,2200)
	oProcess:IncRegua2("Cabec ...")
	//-----------------------------------------------------------------//
	U_fSayDado(oPrn,@nLinha,0130,080,oFontA16,/*/cTit/*/											  		,'A1_NOME'	  	,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0130,050,oFontA16,cTexto												  		,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1710,000,oFontA16,'Fecha'												  		,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1960,000,oFontA16,': '											  				,'F2_EMISSAO'	,aNF_Print,2) //Dado grava do campo
	oProcess:IncRegua2("Cabec ...")
	cTexto 	:= 'Dirección: '
	cTexto 	+= Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_END'			,aClient_Print,3))
	cBar 	:= Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_BAIRRO'		,aClient_Print,3))
	cTexto 	+= IIf (!Empty(cBar),','+cBar,'')
	cMun 	:= Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_MUN'			,aClient_Print,3))
	cTexto 	+= IIf (!Empty(cMun),','+cMun,'')
	cEst 	:= Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_EST'			,aClient_Print,3))
	cTexto 	+= IIf (!Empty(cEst),','+cEst,'')
	U_fSayDado(oPrn,@nLinha,0130,050,oFontA16,cTexto		,/*/cCampo/*/	,/*/aDados/*/	,9)
	cTexto := 'Zona: '
	cTexto += Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_REGIAO'		,aClient_Print,3)+',')
	U_fSayDado(oPrn,@nLinha,1710,000,oFontA16,cTexto		,/*/cCampo/*/	,/*/aDados/*/	,9)
	//-----------------------------------------------------------------------------------------------------------------
	U_fSayDado(oPrn,@nLinha,0130,050,oFontA16,'Transportadora',/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0410,000,oFontA16,': '			 ,'A4_NOME'		,aTrans_Print	,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1710,000,oFontA16,'Placa'	 	 ,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1960,000,oFontA16,': '	 		 ,'DA3_PLACA'	,aTrans_Print	,2) //Dado grava do c
	U_fSayDado(oPrn,@nLinha,0130,050,oFontA16,'Vehículo'	 ,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0290,000,oFontA16,': '	 		 ,'DA3_COD'	,aTrans_Print	,2) //Dado grava do c
	U_fSayDado(oPrn,@nLinha,1000,000,oFontA16,'Conductor' 	 ,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1190,000,oFontA16,': '	 		 ,'DA4_NOME'	,aTrans_Print	,2) //Dado grava do c
	oProcess:IncRegua2("Cabec ...")
	nLinha += 050
Return(.T.)


/*/{Protheus.doc} PrintLine
Impressão do Produto
@type function
@version 1.0
@author Luiz Fael
@since 09/01/2023
@param oProcess, object, Objeto
@param oPrn, object, Objeto impressao
@param nLinha, numeric, Linha
@param aSD2, array, matrix de dados
@return variant, Nill
/*/
Static Function PrintLine(oProcess,oPrn,nLinha,aSD2,aNF_Print,aClient_Print,aEmp,aVend_Print) //Dado grava do campo
	Local nX 			:= 0
	Local nY 			:= 0
	Local aProd_Print   := {}
	Local cTexto 		:= ''
	For nX:= 1 to Len(aSD2) //Dado grava do campo
		aProd_Print   := aSD2[nX]
		If nX == 1
			fDetProd(oProcess,oPrn,@nLinha,aProd_Print,aNF_Print,aClient_Print,aEmp,1)
		EndIf
		fDetProd(oProcess,oPrn,@nLinha,aProd_Print,aNF_Print,aClient_Print,aEmp,2)
		U_fSayDado(oPrn,@nLinha,0100,035		,oFontA11,/*/titulo/*/										,'D2_ITEM'	,aProd_Print,2) //Dado grava do campo			
		U_fSayDado(oPrn,@nLinha,0225,000		,oFontA11,/*/titulo/*/										,'D2_COD'	,aProd_Print,2) //Dado grava do campo			
		cDesc_Pro 	:= U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'B1_DESC'	,aProd_Print,3)
		cLocal 		:= U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'D2_LOCAL'	,aProd_Print,3)
		cLocal		:= TRIM(IIF(LEN(cLocal) > 16, SUBSTR( cLocal, 1, 16), cLocal)) + "..."
		If Len(cDesc_Pro) > 40
			For nY := 1 to Len(cDesc_Pro) step(40)
				If nY == 1
					cTexto := Alltrim(SubStr(cDesc_Pro,nY,40))
					U_fSayDado(oPrn,@nLinha,0600,000		,oFontA11,cTexto			,/*/cCampo/*/	,/*/aDados/*/,9)
					U_fSayDado(oPrn,@nLinha,1325,000		,oFontA11,/*/titulo/*/	,'B1_UM'		,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,1425,000		,oFontA11,/*/titulo/*/	,'D2_QUANT'		,aProd_Print,2) //Dado grava do campo
					U_fSayDado(oPrn,@nLinha,1625,000		,oFontA11,cLocal			,/*/cCampo/*/	,/*/aDados/*/,9) //Dado grava do campo
					U_fSayDado(oPrn,@nLinha,1975,000		,oFontA11,/*/titulo/*/	,'D2_LOTECTL'	,aProd_Print,2) //Dado grava do campo
				Else
					cTexto := Alltrim(SubStr(cDesc_Pro,nY,40))
					If !Empty(cTexto)
						fDetProd(oProcess,oPrn,@nLinha,aProd_Printa,aNF_Print,aClient_Print,aEmp,3)
						U_fSayDado(oPrn,@nLinha,0600,030,oFontA11,cTexto,/*/cCampo/*/,/*/aDados/*/,9)
					EndIf
				EndIf
			Next nY
		Else
			cTexto := Alltrim(SubStr(cDesc_Pro,nY,40))
			U_fSayDado(oPrn,@nLinha,0600,000		,oFontA11,cTexto			,/*/cCampo/*/	,/*/aDados/*/,9)
			U_fSayDado(oPrn,@nLinha,1325,000		,oFontA11,/*/titulo/*/	,'B1_UM'		,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,1425,000		,oFontA11,/*/titulo/*/	,'D2_QUANT'		,aProd_Print,2) //Dado grava do campo
			U_fSayDado(oPrn,@nLinha,1625,000		,oFontA11,cLocal			,/*/cCampo/*/	,/*/aDados/*/,9) //Dado grava do campo
			U_fSayDado(oPrn,@nLinha,1975,000		,oFontA11,/*/titulo/*/	,'D2_LOTECTL'	,aProd_Print,2) //Dado grava do campo
		Endif
		If nLinha >= 2360
			oPrn:Line(nLinha+013,0090,nLinha+013,2200)//primeita linha'CODIGO xxxxxxxx'
			oPrn:EndPage()
			oPrn:StartPage()
			fDetProd(oProcess,oPrn,@nLinha,{},aNF_Print,{},aEmp,4)
			fDetProd(oProcess,oPrn,@nLinha,aProd_Printa,aNF_Print,aClient_Print,aEmp,1)
		EndIf
	Next nX
	oPrn:Line(nLinha+014,0090,nLinha+014,2198)//primeita linha'CODIGO xxxxxxxx'
	oPrn:Box(nLinha+030,0090,nLinha+150,2200)
	//cTexto := 'Glosa: '+Alltrim(SC5->C5_UOBSERV)
	cTexto := 'Glosa: '+Alltrim(SC5->C5_UOBSREM) // Imprime Glosa remito
	U_fSayDado(oPrn,@nLinha,00130,080	,oFontA16,cTexto			,/*/cCampo/*/	,/*/aDados/*/,9)
	nLinha += 080
	PrintVend(oProcess,oPrn,nLinha,aVend_Print)
	nLinha += 080
	FwFreeArray(aProd_Print)
Return

/*/{Protheus.doc} PrintRodape
Rodape
@type function
@version 1.0
@author Luiz Fael
@since 09/01/2023
@param oProcess, object, Objeto
@param oPrn, object, Objeto
@param nLinha, numeric, Linha
@param aClient_Print, array, Dados
@param aNF_Print, array, Dados
@return variant, Nill
/*/
Static Function PrintRodape(oProcess,oPrn,nLinha,aClient_Print,aNF_Print)
	nLinha += 030
	oPrn:Box(nLinha,0090,nLinha+190,2200)
	oPrn:Line(nLinha,0798,nLinha+190,0798)
	oPrn:Line(nLinha,1498,nLinha+190,1498)
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,'Elaborado ',/*/cCampo/*/,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,'Autorizado',/*/cCampo/*/,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,'Cliente   ',/*/cCampo/*/,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0130,080,oFontA12,'_____/_____/_____ ________________________',/*/cCampo/*/,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,'_____/_____/_____ ________________________',/*/cCampo/*/,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,'_____/_____/_____ ________________________',/*/cCampo/*/,/*/aDados/*/,9)
Return

/*/{Protheus.doc} fDetProd
Linha e Box
@type function
@version 1.0
@author Luiz Fael
@since 09/01/2023
@param oProcess, object, Objeto Impressao
@param oPrn, object, Objet
@param nLinha, numeric, Linha
@param aSD2, array, param_matrx de dados
@param nOpc, numeric, Opção
@return variant, return_Nill
/*/
Static Function fDetProd(oProcess,oPrn,nLinha,aProd_Print,aNF_Print,aClient_Print,aEmp,nOpc)
	Local 	MVQRSITE		:= Alltrim(SuperGetMv("MV_QRSITE",,'https://agrocentro.com.bo/'))
	Local	cTitulo  		:= ''
	Local	cCampana 		:= ''
	Local	cCamProd 		:= ''
	Local	cTexto   		:= ''
	If nOpc == 4
		oPrn:SayBitmap(0040,0090,aEmp[01][02],0500,0200 )//,0536,0250 )
		oPrn:QRCode(0250,2000,MVQRSITE,0050)
		U_fSayDado(oPrn,@nLinha,0900,150,oFontA20,'NOTA DE DESPACHO'														,/*/cCampo/*/	,/*/aDados/*/,9)
		cCampana := 'Campaña'//U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/			,'F2_CAMPDES' 	,aNF_Print	 ,3)
		If !Empty(cCampana)
			cTitulo  := 'Campaña'
			cCampana := 'Campaña'//U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/			,'F2_CAMPDES' 	,aNF_Print	 ,3)
			cCamProd := GetAdvFVal("ZZK", "ZZK_DESC", xFilial("ZZK") + SC5->C5_CAMPANA, 1, "")//ZZK_FILIAL+ZZK_COD	//U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'F2_CAMPROD' ,aNF_Print,3)				
			cTitulo  := PadC(cTitulo ,100)
			cCampana := Alltrim(cCampana)+' - '+Alltrim(cCamProd)
			cCampana := PadC(cCampana,100)
			U_fSayDado(oPrn,@nLinha,0550,040,oFontA16,cTitulo											  	,/*/cCampo/*/,/*/aDados/*/,9)
			U_fSayDado(oPrn,nLinha ,0550,040,oFontA16,cCampana											  	,/*/cCampo/*/,/*/aDados/*/,9)
			nLinha += 0120
			//----------------------SM0 EMPRESA-----------------------------------------------------------------------------------------------------
			cTexto := AllTrim(FWFilialName(cEmpAnt,cFilAnt,1))
			U_fSayDado(oPrn,@nLinha,0100,000,oFontAB16,cTexto												  		,/*/cCampo/*/	,/*/aDados/*/,9)
			cTexto := 	U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/			,'F2_DOC'	 	,aNF_Print	 ,3)
			U_fSayDado(oPrn,@nLinha,1780,000,oFontAB16,cTexto														,/*/cCampo/*/	,/*/aDados/*/,9)
			cTexto := AllTrim(aEmp[16][02])
			cTexto += IIf(!Empty(aEmp[17][02]),','+AllTrim(aEmp[17][02]),'')
			cTexto += IIf(!Empty(aEmp[18][02]),','+AllTrim(aEmp[18][02]),'')
			cTexto += IIf(!Empty(aEmp[19][02]),','+AllTrim(aEmp[19][02]),'')
			cTexto += IIf(!Empty(aEmp[21][02]),','+AllTrim(aEmp[21][02]),'')
			U_fSayDado(oPrn,@nLinha,0100,030,oFontA10,cTexto												  		,/*/cCampo/*/	,/*/aDados/*/,9)
			//--------------------------------------------------------------------------------------------------------------------------------------
		EndIf
		nLinha += 020
	ElseIf nOpc == 1
		oPrn:Box( nLinha,0090,nLinha+055,2200)
		oPrn:Line(nLinha,0200,nLinha+055,0200)//primeita linha'CODIGO xxxxxxxx'
		oPrn:Line(nLinha,0575,nLinha+055,0575)//primeita linha'DESCRIPCION xxxxxxxxxxxxxxxxxx'
		oPrn:Line(nLinha,1300,nLinha+055,1300)//primeita linha'UN.'
		oPrn:Line(nLinha,1400,nLinha+055,1400)//primeita linha'CANTIDAD x'
		oPrn:Line(nLinha,1600,nLinha+055,1600)//primeita linha'Alacen'
		oPrn:Line(nLinha,1950,nLinha+055,1950)//primeita linha'Lote'
		oPrn:Line(nLinha,2200,nLinha+055,2200)//primeita linha
		U_fSayDado(oPrn,@nLinha,0098,030,oFontA11,/*/cTit/*/			,'D2_ITEM'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,0225,000,oFontA11,/*/cTit/*/			,'D2_COD'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,0600,000,oFontA11,/*/cTit/*/			,'D2_DESC'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1325,000,oFontA11,'Un'				,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,1425,000,oFontA11,/*/cTit/*/			,'D2_QUANT'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1625,000,oFontA11,/*/cTit/*/			,'D2_LOCAL'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1975,000,oFontA11,/*/cTit/*/			,'D2_LOTECTL'	,aProd_Print,1) //titulo do campo
		nLinha += 020
	ElseIf nOpc == 2 .or. nOpc == 3
		nQtd := 044
		If nOpc == 3
			nQtd := 025
		EndIf
		oPrn:Line(nLinha+006,0090,nLinha+nQtd,0090)//primeita linha'CODIGO xxxxxxxx'
		oPrn:Line(nLinha+006,0200,nLinha+nQtd,0200)//primeita linha'CODIGO xxxxxxxx'
		oPrn:Line(nLinha+006,0575,nLinha+nQtd,0575)//primeita linha'DESCRIPCION xxxxxxxxxxxxxxxxxx'
		oPrn:Line(nLinha+006,1300,nLinha+nQtd,1300)//primeita linha'UN.'
		oPrn:Line(nLinha+006,1400,nLinha+nQtd,1400)//primeita linha'CANTIDAD'
		oPrn:Line(nLinha+006,1600,nLinha+nQtd,1600)//primeita linha'Almacen'
		oPrn:Line(nLinha+006,1950,nLinha+nQtd,1950)//primeita linha'Lote'
		oPrn:Line(nLinha+006,2200,nLinha+nQtd,2200)//primeita linha'Lote'
	EndIf
Return

/*/{Protheus.doc} PrintVend
Imprime Vendedores
@type function
@version 1.0
@author Luiz Fael
@since 20/12/2022
@param aVend, array, aVend
@return variant, Nill
/*/
Static function PrintVend(oProcess,oPrn,nLinha,aVend_Print)
	Local nX	:= 0
	Local nSoma	:= nLinha+040
	Local nTam 	:= 0
	Local cTit 	:= 'Vendedor'
	Local nCol 	:= 0
	Local nQtd	:= 000
	nTam  := Len(aVend_Print)
	nTam  := nTam/2
	If nTam < 1
		nTam := 1
	EndIf
	If nTam <> 0
		For nX:=1  to nTam
			If nCol == 2
				nCol := 1
			EndIf
			If !Empty(aVend_Print[nX][01][02]) .and. nCol == 1
				nSoma += 050
				nCol ++
			EndIf
		Next nX
	EndIf
	oPrn:Box(nLinha+020,0090,nSoma+40,2200)
	U_fSayDado(oPrn,@nLinha,0130,060,oFontA12,cTit,/*/cCampo/*/,/*/aDados/*/,9)
	nCol := 1
	oProcess:SetRegua2(Len(aVend_Print))
	For nX:=1 to Len(aVend_Print)
		oProcess:IncRegua2("Vendedor ...")
		If nCol == 1
			If !Empty(aVend_Print[nX][01][02])
				U_fSayDado(oPrn,@nLinha,0300,nQtd,oFontA12,Alltrim(aVend_Print[nX][01][02]),/*/cCampo/*/,/*/aDados/*/,9)
				U_fSayDado(oPrn,@nLinha,0500,000,oFontA12,Alltrim(aVend_Print[nX][02][02]) ,/*/cCampo/*/,/*/aDados/*/,9)
				nQtd	:= 040
				nCol ++
			EndIf
		Else
			If !Empty(aVend_Print[nX][01][02])
		  		U_fSayDado(oPrn,@nLinha,1200,000,oFontA12,Alltrim(aVend_Print[nX][01][02]),/*/cCampo/*/,/*/aDados/*/,9)
				U_fSayDado(oPrn,@nLinha,1650,000,oFontA12,Alltrim(aVend_Print[nX][02][02]),/*/cCampo/*/,/*/aDados/*/,9)
				nCol := 1
			EndIf
		EndIf
	Next nX
	nLinha += 050
Return
