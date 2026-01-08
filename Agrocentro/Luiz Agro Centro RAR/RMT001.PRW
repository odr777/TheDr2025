#include "protheus.ch"
#include "adprint.ch"
#include "RPTDEF.CH"
#include "FWPrintSetup.ch

User Function RMT001()
	Local nFila		:= 950
	Local cNf 		:= Alltrim(SC5->C5_SERIE)+Alltrim(SC5->C5_NOTA)
	local oPrn
	Local oProcess
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
	// SEQUENCIA DE IMPRESSÃO
	oPrn:StartPage()
	// Inicia a Impressão da NF
	oProcess := MsNewProcess():New( {|lEnd| ImpSeq(oProcess,oPrn) } , "Imprimindo Remito..." , "Ordem de Venta..." )
	oProcess:Activate()
	oPrn:EndPage()
	oPrn:Preview()
	FreeObj(oPrn)
	FreeObj(oProcess)
Return()

/*/{Protheus.doc} ImpSeq
Sequencia de Impressao
@type function
@version 1.0
@author Luiz Fael
@since 04/01/2023
@return variant, Nill
/*/
Static Function ImpSeq(oProcess,oPrn)
	Local aPed_Print	:= {}	//aSF2[01] Ordem de venta
	Local aNF_Print		:= {}	//aSF2[02] Nota Fiscal
	Local aClient_Print	:= {}	//aSF2[03] Cliente
	Local aImp_print	:= {}	//Impostos
	Local aFatur_Print	:= {}	//Valor fatura
	Local aVend_Print	:= {}	//aSF2[06] Vendedor
	Local aTrans_Print	:= {}	//Transportadora
	Local aDup_Print	:= {}	//Duplicatas
	Local nLinha		:= 20
	Local aSF2			:=  {}
	Local aSD2			:=  {}
	Local nRegua 		:= 7
	Local aEmp 			:= {}

	U_RMTDados(oProcess,oPrn,@aSF2,@aSD2) //Dado grava do campo
	If Len(aSF2)  == 0
		MsgStop("¡Erro:Sem dados Remito! ")
	Else
		If Len(aSF2[05]) == 0
			MsgStop("¡Erro:Sem dados Cliente! ")
		Else
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			aPed_Print		:= aSF2[01] 	//aSF2[01] Ordem de venta
			aNF_Print		:= aSF2[02]		//aSF2[02] Nota Fiscal
			aClient_Print	:= aSF2[03]		//aSF2[03] Cliente
			aImp_print		:= aSF2[04] 	//Impostos
			aFatur_Print	:= aSF2[05] 	//Valor fatura
			aVend_Print		:= aSF2[06]		//aSF2[06] Vendedor
			aTrans_Print	:= aSF2[07]		//Transportadora
			aDup_Print		:= aSF2[08]		//Duplicatas
			If Len(aPed_Print) <> 0
				nRegua ++
			EndIf
			If Len(aVend_Print) <> 0
				nRegua ++
			EndIf
			If Len(aDup_Print) <> 0
				nRegua ++
			EndIf
			aEmp := U_getEmp()
			oProcess:SetRegua1(nRegua)
			PrintHead(oProcess,oPrn,@nLinha,aNF_Print,aClient_Print,aPed_Print,aEmp)
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			If Len(aPed_Print) <> 0
				oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
				PrintPed(oProcess,oPrn,@nLinha,aPed_Print)
			EndIf
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			If Len(aVend_Print) <> 0
				oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
				PrintVend(oProcess,oPrn,@nLinha,aVend_Print)
			EndIf
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			If Len(aTrans_Print) <> 0
				oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
				PrintTransp(oProcess,oPrn,@nLinha,aTrans_Print,aNF_Print,aPed_Print)
			EndIf
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			If Len(aDup_Print) <> 0
				oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
				PrintDup(oProcess,oPrn,@nLinha,aDup_Print)
			EndIf
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			PrintLine(oProcess,oPrn,@nLinha,aSD2,aNF_Print,aClient_Print,aPed_Print,aEmp) //Dado grava do campo
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
			PrintRodape(oProcess,oPrn,@nLinha,aFatur_Print,aClient_Print,aNF_Print)
			oProcess:IncRegua1("Imprimindo Ordem de Venda " + Alltrim(SC5->C5_NUM) + "...")
		EndIf
	EndIf
	FwFreeArray(aPed_Print)
	FwFreeArray(aNF_Print)
	FwFreeArray(aClient_Print)
	FwFreeArray(aImp_print)
	FwFreeArray(aFatur_Print)
	FwFreeArray(aVend_Print)
	FwFreeArray(aTrans_Print)
	FwFreeArray(aDup_Print)
	FwFreeArray(aSF2) //Dado grava do campo
	FwFreeArray(aSD2) //Dado grava do campo
Return

/*/{Protheus.doc} PrintHead
IMPRIME CABECHALHO
@type function
@version 1.0
@author Luiz Fael
@since 15/12/2022
@param nLinha, numeric, linha de impressão
@param aSF2, array, matriz de dados SF2
@param aSD2, array, matriz de dados SD2
@return variant, nill
/*/
Static Function PrintHead(oProcess,oPrn,nLinha,aNF_Print,aClient_Print,aPed_Print,aEmp)
	Local cTexto 		:= ''
	Local cCli_Cod 		:= ''
	Local cCli_Loj 		:= ''
	Local cEnd_Cli 		:= ''
	Local cEndCob_Cli 	:= ''
	Local cCamProd		:= ''
	Local cM0ENDENT 	:= ''
	Local cSite			:= 'https://agrocentro.com.bo/'

	oProcess:SetRegua2(7)
	//Local lRVTF2	:= ExistBlock("RVTA" )
	//{'E1_VENCTO'	,aDup_Printli[nX][08]	,Alltrim(GetSx3Cache('E1_VENCTO'	,cTITPais))}
	//U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/,/*/cAlias/*/,/*/cCampo/*/,/*/aDados/*/,/*/nOpc/*/)
	//+-------------------------------------+
	//¦ Impressao do Cabecalho da N.F.      ¦
	//+-------------------------------------+
	//oPrn:Line(0230,0100,0230,2200)
	//oPrn:Box(0650,0900,0870,2200)
	oPrn:SayBitmap(0040,0090, "\system\agrocentro.png",0500,0200 )//,0536,0250 )
	oPrn:QRCode(0250,2000,cSite,0050)
	nLinha := 250
	cTexto := U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'F2_TIPOREM'	,aNF_Print,3)	
	cTexto += U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'F2_SERIE'	 	,aNF_Print,3)
	cTexto := Alltrim(cTexto)
	cTexto += U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'F2_DOC'	 	,aNF_Print,3)
	U_fSayDado(oPrn,@nLinha,0100,060,oFontA16,cTexto												,/*/cCampo/*/	,/*/aDados/*/,9)
	cTexto := "Campaña: "
	cTexto += U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'F2_CAMPDES' 	,aNF_Print,3)
	cTexto := Alltrim(cTexto)
	cCamProd := U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'F2_CAMPROD' ,aNF_Print,3)
	If !Empty(cCamProd)
		cTexto += ' - '+cCamProd
	Endif
	cTexto := Alltrim(cTexto)
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA16,cTexto											  	,/*/cCampo/*/,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1710,000,oFontA16,/*/cTit/*/										  	,'F2_EMISSAO',aNF_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1960,000,oFontA16,': '											  		,'F2_EMISSAO',aNF_Print,2) //Dado grava do campo
	oProcess:IncRegua2("Cabec ...")
	//-----------------------------------------------------------------//
	If Alltrim(SM0->M0_ENDENT) == Alltrim(SM0->M0_ENDCOB)
		oPrn:Box(nLinha+30,0090,nLinha+300,2200)
	Else
		oPrn:Box(nLinha+30,0090,nLinha+400,2200)
	Endif
	cTexto := ' '+Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/,'M0_FILIAL'	,aEmp,3))	
	U_fSayDado(oPrn,@nLinha,0130,080,oFontAB12,'AGRO CENTRO S/A'									  		,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0400,000,oFontAB10,cTexto												  		,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/											  		,'C5_DOCGER'	,aPed_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0950,000,oFontA12,': '												  			,'C5_DOCGER'	,aPed_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/											  		,'C5_TIPOREM'	,aPed_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '												  			,'C5_TIPOREM'	,aPed_Print,2) //Dado grava do campo
	cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'M0_ENDENT'	,aEmp,3))	
	cM0ENDENT := cTexto
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,'Direccion'											  	  	,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '+cTexto									  				,/*/cCampo/*/	,/*/aDados/*/,9)
	cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'M0_BAIRENT'	,aEmp,3))	
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,'Bairro'												  		,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '+cTexto									  				,/*/cCampo/*/	,/*/aDados/*/,9)
	cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'M0_ESTENT'	,aEmp,3))	
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,'Provincia'												  	,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0950,000,oFontA12,': '+cTexto									  				,/*/cCampo/*/	,/*/aDados/*/,9)	
	cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'M0_CIDENT'	,aEmp,3))	
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,'Municipio'												  	,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '+cTexto									  				,/*/cCampo/*/	,/*/aDados/*/,9)	
	cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'M0_CEPENT'	,aEmp,3))	
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,'CP'                            					  			,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '+cTexto									  				,/*/cCampo/*/	,/*/aDados/*/,9)	
	cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'M0_TEL'		,aEmp,3))	
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,'Telefono'											 		,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0950,000,oFontA12,': '+cTexto									  				,/*/cCampo/*/	,/*/aDados/*/,9)
	oProcess:IncRegua2("Cabec ...")
	//---------------------------------------------------------------------------------------------------------------------------------------//
	cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'M0_ENDCOB'	,aEmp,3))	
	If  cM0ENDENT <> cTexto
		U_fSayDado(oPrn,@nLinha,0130,060,oFontA12,'Cob.Dire.'												,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '+cTexto												,/*/cCampo/*/	,/*/aDados/*/,9)
		cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/,'M0_COMPCOB'	,aEmp,3))	
		U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,'Cob.Compl.'												,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,0950,000,oFontA12,': '+cTexto												,/*/cCampo/*/	,/*/aDados/*/,9)
		cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/,'M0_BAIRCOB'	,aEmp,3))	
		U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,'Cob.Bairro'												,/*/cAlias/*/,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '+cTexto												,/*/cAlias/*/,/*/cCampo/*/	,/*/aDados/*/,9)	
		cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/,'M0_ESTCOB'	,aEmp,3))	
		U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,'Cob.Prov.'												,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '+cTexto												,/*/cCampo/*/	,/*/aDados/*/,9)	
		cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/,'M0_CIDCOB'	,aEmp,3))	
		U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,'Cob.Muni.'                        						,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,0950,000,oFontA12,': '+cTexto												,/*/cCampo/*/	,/*/aDados/*/,9)		
		cTexto := Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/,'M0_CEPCOB'	,aEmp,3))	
		U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,'Cob.CP'													,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '+cTexto												,/*/cCampo/*/	,/*/aDados/*/,9)	
	EndIf
	oProcess:IncRegua2("Cabec ...")
	U_fSayDado(oPrn,@nLinha,0130,040,oFontAB12,'CNPJ'										  				,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0300,000,oFontAB12,': '+cTexto													,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0800,000,oFontAB12,'CEI'										  				,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0950,000,oFontAB12,': '+cTexto													,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1500,000,oFontAB12,'INSC'										  				,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,1700,000,oFontAB12,': '+cTexto													,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0130,040,oFontAB12,'INSCM'									  					,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0300,000,oFontAB12,': '+cTexto													,/*/cCampo/*/	,/*/aDados/*/,9)	
	nLinha += 020
	oProcess:IncRegua2("Cabec ...")
	oPrn:Box(nLinha+20,0090,nLinha+278,2200)
	U_fSayDado(oPrn,@nLinha,0130,060,oFontAB12,/*/cTit/*/											  		,'A1_NOME'	  	,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/											  		,'C5_TIPOCLI'	,aPed_Print	  ,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '												  			,'C5_TIPOCLI'	,aPed_Print   ,2) //Dado grava do campo
	cEnd_Cli 	:= U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/  		,'A1_EST'		,aClient_Print,3)
	cEndCob_Cli := U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/  		,'A1_EST'		,aClient_Print,3)
	cCli_Cod := 'Cod.' + U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_COD'		,aClient_Print,3)
	cCli_Loj := 		 U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'A1_LOJA'		,aClient_Print,3)
	cCli_Loj := IIf(!Empty(cCli_Loj),'-'+cCli_Loj,'')
	cTexto 	 := cCli_Cod+cCli_Loj
	oProcess:IncRegua2("Cabec ...")
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,cTexto												  		,/*/cCampo/*/		,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0350,000,oFontA12,/*/cTit/*/										  			,'A1_END'			,aClient_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0500,000,oFontA12,': '												  			,'A1_END'			,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/											  		,'A1_BAIRRO'		,aClient_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '												  			,'A1_BAIRRO'		,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,/*/cTit/*/											  		,'A1_EST'			,aClient_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '												  			,'A1_EST'			,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/											  		,'A1_MUN'			,aClient_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0950,000,oFontA12,': '												  			,'A1_MUN'			,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/											  		,'A1_CEP'			,aClient_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '												  			,'A1_CEP'			,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,/*/cTit/*/											  		,'A1_INSCR'			,aClient_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '												  			,'A1_INSCR'			,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/											  		,'A1_CGC'			,aClient_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0950,000,oFontA12,': '												  			,'A1_CGC'			,aClient_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/										  	  		,'A1_TEL'			,aClient_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '											  	  			,'A1_TEL'			,aClient_Print,2) //Dado grava do campo
	oProcess:IncRegua2("Cabec ...")
	If Alltrim(cEnd_Cli) <> Alltrim(cEndCob_Cli)
		U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,/*/cTit/*/										  		,'A1_ENDCOB'		,aClient_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '											  			,'A1_ENDCOB'		,aClient_Print,2) //Dado grava do campo
	EndIf
	oProcess:IncRegua2("Cabec ...")
	nLinha += 085
Return(.T.)

/*/{Protheus.doc} PrintPed
Imprime ordem de Venda
@type function
@version 1.0
@author Luiz Fael
@since 21/12/2022
@param oPrn, object, Objeto
@param nLinha, numeric, linha
@param aPed, array, matriz Pedido
@return variant, Nill
/*/
Static function PrintPed(oProcess,oPrn,nLinha,aPed_Print)
	Local cTit 		:= 'Ordem de Venta'
	Local cTpFre_Trasnp := U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/   ,'C5_TPFRETE'  ,aPed_Print	,3)	
	oProcess:SetRegua2(3)
	cTpFre_Trasnp := IIf(cTpFre_Trasnp=='C',": Emitente",": Cliente")
	oPrn:Box(nLinha+030,0090,nLinha+200,2200)
	U_fSayDado(oPrn,@nLinha,0130,060,oFontA12,cTit					,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0360,000,oFontA12,/*/cTit/*/			,'C5_NUM'		,aPed_Print  ,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0500,000,oFontA12,/*/cTit/*/			,'C5_TPFRETE'	,aPed_Print  ,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0630,000,oFontA12,Alltrim(cTpFre_Trasnp),/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0950,000,oFontA12,/*/cTit/*/			,'C5_TIPO'		,aPed_Print  ,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1120,000,oFontA12,': '					,'C5_TIPO'		,aPed_Print  ,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/			,'C5_CONDPAG'	,aPed_Print  ,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1650,000,oFontA12,': '					,'C5_CONDPAG'	,aPed_Print  ,2) //Dado grava do campo
	oProcess:IncRegua2("Ordem ...")
	oPrn:Box(nLinha+030,0090,nLinha+150,0950)
	oPrn:Box(nLinha+030,0949,nLinha+150,2200)
	oProcess:IncRegua2("Ordem ...")
	U_fSayDado(oPrn,@nLinha,0130,060,oFontA12,/*/cTit/*/			,'C5_MENPAD'	,aPed_Print,1) //titulo do campo
	//U_fSayDado(oPrn,@nLinha,0300,000,oFontA12,': '				,'C5_MENPAD'	,aPed_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1000,000,oFontA12,/*/cTit/*/			,'C5_MENNOTA'	,aPed_Print,1) //titulo do campo
	//U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '				,'C5_MENNOTA'	,aPed_Print,2) //Dado grava do campo
	nLinha += 080
	oProcess:IncRegua2("Ordem ...")
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
	nLinha += 035
Return


/*/{Protheus.doc} PrintTransp
Imprime Trasnportadora 
@type function
@version 1.0
@author Luiz Fael
@since 26/12/2022
@param aTrans_Print, array, Dados Transportadora
@return variant, Nill
/*/
Static Function PrintTransp(oProcess,oPrn,nLinha,aTrans_Print,aNF_Print,aPed_Print)
	Local nSoma := nLinha+180
	oProcess:SetRegua2(4)
	oProcess:IncRegua2("Transp ...")
	oPrn:Box(nLinha,0090,nSoma,2200)
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,'Trasnportadora'     	,/*/cCampo/*/	,/*/aDados/*/,9)
	U_fSayDado(oPrn,@nLinha,0350,000,oFontA12,/*/cTit/*/			,'A4_NOME'		,aTrans_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/			,'A4_END'		,aTrans_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0990,000,oFontA12,': '					,'A4_END'		,aTrans_Print,2) //Dado grava do campo
	oProcess:IncRegua2("Transp ...")
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,/*/cTit/*/			,'A4_MUN'		,aTrans_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0350,000,oFontA12,': '					,'A4_MUN'		,aTrans_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/			,'A4_EST'		,aTrans_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0990,000,oFontA12,': '					,'A4_EST'		,aTrans_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/			,'A4_VIA'		,aTrans_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '					,'A4_VIA'		,aTrans_Print,2) //Dado grava do campo
	//-------------------------------------------------------------------------------------------------------//
	oProcess:IncRegua2("Transp ...")
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,/*/cTit/*/			,'A4_CGC'			,aTrans_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0350,000,oFontA12,': '					,'A4_CGC'			,aTrans_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/			,'A4_TEL'			,aTrans_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0990,000,oFontA12,': '					,'A4_TEL'			,aTrans_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/			,'F2_VOLUME1'		,aNF_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '					,'F2_VOLUME1'		,aNF_Print,2) //Dado grava do campo
	//-----------------------------------------------------------------------------------------------------//
	oProcess:IncRegua2("Transp ...")
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,/*/cTit/*/			,'F2_ESPECI1'		,aNF_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0350,000,oFontA12,': '					,'F2_ESPECI1'		,aNF_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/			,'C5_PBRUTO'  		,aPed_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0990,000,oFontA12,': '					,'C5_PBRUTO'		,aPed_Print,2) //Dado grava do campo
	nLinha += 030
	oProcess:IncRegua2("Transp ...")
Return

/*/{Protheus.doc} PrintDup
Duplicata
@type function
@version 1.0
@author Luiz Fael
@since 29/12/2022
@param oPrn, object, Objeto
@param nLinha, numeric, Linha
@param aDup_Print, array, dados
@return variant, return_Nill
/*/
Static Function PrintDup(oProcess,oPrn,nLinha,aDup_Print)
	Local nX		:= 1
	Local cTit 		:= 'Duplicata'
	Local nSoma 	:= 0
	Local nQtd 		:= 0
	Local aPrint    := {}
	Local dVenci 	:= ''
	nSoma 	:= nLinha
	For nX:=1 to Len(aDup_Print)
		If !Empty(aDup_Print[nX][03][02])
			nSoma 	+= 055
		EndIf
	Next nX
	oPrn:Box(nLinha,0090,nSoma,2200)
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,cTit,/*/cCampo/*/,/*/aDados/*/,9)
	oProcess:SetRegua2(Len(aDup_Print))
	For nX:=1 to Len(aDup_Print)
		aPrint := aDup_Print[nX]
		oProcess:IncRegua2("Dup ...")
		If !Empty(aPrint[nX][02])
			If nX > 1
				nQtd := 040
			EndIf
			U_fSayDado(oPrn,@nLinha,0300,nQtd	,oFontA10,/*/cTit/*/,'E1_NUM'			,aPrint,1) //titulo do campo
			U_fSayDado(oPrn,@nLinha,0450,000	,oFontA10,': '		,'E1_NUM'			,aPrint,2) //Dado grava do campo
			U_fSayDado(oPrn,@nLinha,0750,000	,oFontA10,/*/cTit/*/,'E1_PARCELA'		,aPrint,1) //titulo do campo
			U_fSayDado(oPrn,@nLinha,0835,000	,oFontA10,': '		,'E1_PARCELA'		,aPrint,2) //Dado grava do campo
			U_fSayDado(oPrn,@nLinha,1000,000	,oFontA10,/*/cTit/*/,'E1_TIPO'			,aPrint,1) //titulo do campo
			U_fSayDado(oPrn,@nLinha,1060,000	,oFontA10,': '		,'E1_TIPO'			,aPrint,2) //Dado grava do campo
			U_fSayDado(oPrn,@nLinha,1300,000	,oFontA10,/*/cTit/*/,'E1_VENCTO'		,aPrint,1) //titulo do campo
			dVenci :=  U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/,'E1_VENCTO'		,aPrint,3)
			dVenci :=  dtoc(stod(dVenci))
			U_fSayDado(oPrn,@nLinha,1445,000	,oFontA10,': '+dVenci	,/*/cCampo/*/	,/*/aDados/*/,9)
			U_fSayDado(oPrn,@nLinha,1800,000	,oFontA10,/*/cTit/*/	,'E1_VALOR'		,aPrint,1) //titulo do campo
			U_fSayDado(oPrn,@nLinha,1945,000	,oFontA10,': '			,'E1_VALOR'		,aPrint,2) //Dado grava do campo
		EndIf
	Next nX
	FwFreeArray(aPrint)
	nLinha += 035
Return

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
Static Function PrintLine(oProcess,oPrn,nLinha,aSD2,aNF_Print,aClient_Print,aPed_Print,aEmp) //Dado grava do campo
	Local nX 			:= 0
	Local nY 			:= 0
	Local aProd_Print   := {}
	Local cTexto 		:= ''
	For nX:= 1 to Len(aSD2) //Dado grava do campo
		aProd_Print   := aSD2[nX]
		If nX == 1
			fDetProd(oProcess,oPrn,@nLinha,aProd_Print,aNF_Print,aClient_Print,aPed_Print,aEmp,1)
		EndIf
		fDetProd(oProcess,oPrn,@nLinha,aProd_Print,aNF_Print,aClient_Print,aPed_Print,aEmp,2)
		U_fSayDado(oPrn,@nLinha,0100,035		,oFontA9,/*/titulo/*/										,'D2_ITEM'	,aProd_Print,2) //Dado grava do campo			
		U_fSayDado(oPrn,@nLinha,0155,000		,oFontA9,/*/titulo/*/										,'D2_COD'	,aProd_Print,2) //Dado grava do campo			
		cDesc_Pro 	:= U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'B1_DESC'	,aProd_Print,3)
		If Len(cDesc_Pro) > 28
			For nY := 1 to Len(cDesc_Pro) step(28)
				If nY == 1
					cTexto := Alltrim(SubStr(cDesc_Pro,nY,28))
					U_fSayDado(oPrn,@nLinha,0350,000		,oFontA9,cTexto			,/*/cCampo/*/	,/*/aDados/*/,9)
					U_fSayDado(oPrn,@nLinha,0750,000		,oFontA9,/*/titulo/*/	,'B1_UM'		,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,0795,000		,oFontA9,/*/titulo/*/	,'D2_QUANT'		,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,0940,000		,oFontA9,/*/titulo/*/	,'D2_PRUNIT'	,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,1090,000		,oFontA9,/*/titulo/*/	,'D2_TOTAL'		,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,1250,000		,oFontA9,/*/titulo/*/	,'D2_TES'		,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,1310,000		,oFontA9,/*/titulo/*/	,'D2_CF'		,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,1390,000		,oFontA9,/*/titulo/*/	,'D2_NUMLOTE'	,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,1571,000		,oFontA9,/*/titulo/*/	,'B1_ORIGEM'	,aProd_Print,2) //Dado grava do campo
					U_fSayDado(oPrn,@nLinha,1675,000		,oFontA9,/*/titulo/*/	,'C6_PEDCLI'	,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,1805,000		,oFontA9,/*/titulo/*/	,'B1_PESO'		,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,1935,000		,oFontA9,/*/titulo/*/	,'D2_NFORI'		,aProd_Print,2) //Dado grava do campo			
					U_fSayDado(oPrn,@nLinha,2055,000		,oFontA9,/*/titulo/*/	,'D2_SERIORI'	,aProd_Print,2) //Dado grava do campo
				Else
					cTexto := Alltrim(SubStr(cDesc_Pro,nY,28))
					If !Empty(cTexto)
						fDetProd(oProcess,oPrn,@nLinha,aProd_Printa,aNF_Print,aClient_Print,aPed_Print,aEmp,3)
						U_fSayDado(oPrn,@nLinha,0350,020,oFontA9,cTexto,/*/cCampo/*/,/*/aDados/*/,9)
					EndIf
				EndIf
			Next nY
		Else
			cTexto := Alltrim(SubStr(cDesc_Pro,nY,28))
			U_fSayDado(oPrn,@nLinha,0350,000		,oFontA9,cTexto			,/*/cCampo/*/	,/*/aDados/*/,9)
			U_fSayDado(oPrn,@nLinha,0750,000		,oFontA9,/*/titulo/*/	,'B1_UM'		,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,0795,000		,oFontA9,/*/titulo/*/	,'D2_QUANT'		,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,0940,000		,oFontA9,/*/titulo/*/	,'D2_PRUNIT'	,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,1090,000		,oFontA9,/*/titulo/*/	,'D2_TOTAL'		,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,1250,000		,oFontA9,/*/titulo/*/	,'D2_TES'		,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,1310,000		,oFontA9,/*/titulo/*/	,'D2_CF'		,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,1390,000		,oFontA9,/*/titulo/*/	,'D2_NUMLOTE'	,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,1571,000		,oFontA9,/*/titulo/*/	,'B1_ORIGEM'	,aProd_Print,2) //Dado grava do campo
			U_fSayDado(oPrn,@nLinha,1675,000		,oFontA9,/*/titulo/*/	,'C6_PEDCLI'	,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,1805,000		,oFontA9,/*/titulo/*/	,'B1_PESO'		,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,1935,000		,oFontA9,/*/titulo/*/	,'D2_NFORI'		,aProd_Print,2) //Dado grava do campo			
			U_fSayDado(oPrn,@nLinha,2055,000		,oFontA9,/*/titulo/*/	,'D2_SERIORI'	,aProd_Print,2) //Dado grava do campo			
		Endif
		If nLinha >= 2360
			oPrn:Line(nLinha+013,0090,nLinha+013,2200)//primeita linha'CODIGO xxxxxxxx'
			oPrn:EndPage()
			oPrn:StartPage()
			fDetProd(oProcess,oPrn,@nLinha,aProd_Printa,aNF_Print,aClient_Print,aPed_Print,aEmp,4)
			fDetProd(oProcess,oPrn,@nLinha,aProd_Printa,aNF_Print,aClient_Print,aPed_Print,aEmp,1)
		EndIf
	Next nX
	oPrn:Line(nLinha+014,0090,nLinha+014,2198)//primeita linha'CODIGO xxxxxxxx'
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
@param aFatur_Print, array, Dados
@param aClient_Print, array, Dados
@param aNF_Print, array, Dados
@return variant, Nill
/*/
Static Function PrintRodape(oProcess,oPrn,nLinha,aFatur_Print,aClient_Print,aNF_Print)
	nLinha += 030
	oPrn:Box(nLinha,0090,nLinha+090,2200)
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,/*/cTit/*/			,'F2_FRETE'		,aFatur_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0350,000,oFontA12,': '					,'F2_FRETE'		,aFatur_Print,2) //Dado grava do campo
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/			,'F2_DESPESA'	,aFatur_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0990,000,oFontA12,': '					,'F2_DESPESA'	,aFatur_Print,2) //Dado grava do c			
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/			,'F2_DESCONT'	,aFatur_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '					,'F2_DESCONT'	,aFatur_Print,2) //Dado grava do c	
	U_fSayDado(oPrn,@nLinha,0130,040,oFontA12,/*/cTit/*/			,'F2_SEGURO'	,aFatur_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0350,000,oFontA12,': '					,'F2_SEGURO'	,aFatur_Print,2) //Dado grava do campo	
	U_fSayDado(oPrn,@nLinha,0800,000,oFontA12,/*/cTit/*/			,'F2_VALIMP'	,aFatur_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,0990,000,oFontA12,': '					,'F2_VALIMP'	,aFatur_Print,2) //Dado grava do c
	U_fSayDado(oPrn,@nLinha,1500,000,oFontA12,/*/cTit/*/			,'F2_VALFAT'	,aFatur_Print,1) //titulo do campo
	U_fSayDado(oPrn,@nLinha,1700,000,oFontA12,': '					,'F2_VALFAT'	,aFatur_Print,2) //Dado grava do campo
	//------------------------------------------------------------------------------------------------------------
	nLinha += 020
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
Static Function fDetProd(oProcess,oPrn,nLinha,aProd_Print,aNF_Print,aClient_Print,aPed_Print,aEmp,nOpc)
	Local cSite			:= 'https://agrocentro.com.bo/'
	If nOpc == 1
		oPrn:Box( nLinha,0090,nLinha+055,2200)
		oPrn:Line(nLinha,0150,nLinha+055,0150)//primeita linha'CODIGO xxxxxxxx'
		oPrn:Line(nLinha,0345,nLinha+055,0345)//primeita linha'DESCRIPCION xxxxxxxxxxxxxxxxxx'
		oPrn:Line(nLinha,0745,nLinha+055,0745)//primeita linha'UN.'
		oPrn:Line(nLinha,0790,nLinha+055,0790)//primeita linha'CANTIDAD x'
		oPrn:Line(nLinha,0935,nLinha+055,0935)//primeita linha'Valor Unit. xxx'
		oPrn:Line(nLinha,1085,nLinha+055,1085)//primeita linha'Valor Total xxx'
		oPrn:Line(nLinha,1245,nLinha+055,1245)//primeita linha'TES'
		oPrn:Line(nLinha,1305,nLinha+055,1305)//primeita linha'CF XX'
		oPrn:Line(nLinha,1385,nLinha+055,1385)//primeita linha'Lote xxxxxxxxxxx'
		oPrn:Line(nLinha,1566,nLinha+055,1566)//primeita linha'Origem X'
		oPrn:Line(nLinha,1670,nLinha+055,1670)//primeita linha'Peso Liq. X'
		oPrn:Line(nLinha,1800,nLinha+055,1800)//primeita linha'Peso Brut.X'
		oPrn:Line(nLinha,1930,nLinha+055,1930)//primeita linha'Nf Ori XX'
		oPrn:Line(nLinha,2060,nLinha+055,2060)//primeita linha'Seri Ori '
		U_fSayDado(oPrn,@nLinha,0098,030,oFontA9,/*/cTit/*/			,'D2_ITEM'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,0155,000,oFontA9,/*/cTit/*/			,'D2_COD'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,0350,000,oFontA9,/*/cTit/*/			,'D2_DESC'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,0750,000,oFontA9,'Un'				,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,0795,000,oFontA9,/*/cTit/*/			,'D2_QUANT'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,0940,000,oFontA9,/*/cTit/*/			,'D2_PRUNIT'	,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1090,000,oFontA9,/*/cTit/*/			,'D2_TOTAL'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1250,000,oFontA9,'TES'				,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,1310,000,oFontA9,'CF'				,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,1390,000,oFontA9,/*/cTit/*/			,'D2_NUMLOTE'	,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1571,000,oFontA9,/*/cTit/*/			,'B1_ORIGEM'	,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1675,000,oFontA9,/*/cTit/*/			,'C6_PEDCLI'	,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1805,000,oFontA9,/*/cTit/*/			,'B1_PESO'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1935,000,oFontA9,/*/cTit/*/			,'D2_NFORI'		,aProd_Print,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,2065,000,oFontA9,/*/cTit/*/			,'D2_SERIORI'	,aProd_Print,1) //titulo do campo
		nLinha += 015
	ElseIf nOpc == 2 .or. nOpc == 3
		nQtd := 044
		If nOpc == 3
			nQtd := 034
		EndIf
		oPrn:Line(nLinha+006,0090,nLinha+nQtd,0090)//primeita linha'CODIGO xxxxxxxx'
		oPrn:Line(nLinha+006,0150,nLinha+nQtd,0150)//primeita linha'CODIGO xxxxxxxx'
		oPrn:Line(nLinha+006,0345,nLinha+nQtd,0345)//primeita linha'DESCRIPCION xxxxxxxxxxxxxxxxxx'
		oPrn:Line(nLinha+006,0745,nLinha+nQtd,0745)//primeita linha'UN.'
		oPrn:Line(nLinha+006,0790,nLinha+nQtd,0790)//primeita linha'CANTIDAD x'
		oPrn:Line(nLinha+006,0935,nLinha+nQtd,0935)//primeita linha'Valor Unit. xxx'
		oPrn:Line(nLinha+006,1085,nLinha+nQtd,1085)//primeita linha'Valor Total xxx'
		oPrn:Line(nLinha+006,1245,nLinha+nQtd,1245)//primeita linha'TES'
		oPrn:Line(nLinha+006,1305,nLinha+nQtd,1305)//primeita linha'CF XX'
		oPrn:Line(nLinha+006,1385,nLinha+nQtd,1385)//primeita linha'Lote xxxxxxxxxxx'
		oPrn:Line(nLinha+006,1566,nLinha+nQtd,1566)//primeita linha'Origem X'
		oPrn:Line(nLinha+006,1670,nLinha+nQtd,1670)//primeita linha'Peso Liq. X'
		oPrn:Line(nLinha+006,1800,nLinha+nQtd,1800)//primeita linha'Peso Brut.X'
		oPrn:Line(nLinha+006,1930,nLinha+nQtd,1930)//primeita linha'Nf Ori XX'
		oPrn:Line(nLinha+006,2060,nLinha+nQtd,2060)//primeita linha'Seri Ori '
		oPrn:Line(nLinha+006,2198,nLinha+nQtd,2198)//primeita linha'CODIGO xxxxxxxx'
	ElseIf nOpc == 4
		oPrn:SayBitmap(0040,0090, "G:\Meu Drive\Argentina\Agro Centro\logo\agrocentro.png",0500,0200 )//,0536,0250 )
		oPrn:QRCode(0250,2000,cSite,0050)
		nLinha := 250
		cTexto := U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/				,'F2_TIPOREM',aNF_Print,3)	
		cTexto += U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/				,'F2_SERIE'	 ,aNF_Print,3)
		cTexto := Alltrim(cTexto)
		cTexto += U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/				,'F2_DOC'	 ,aNF_Print,3)
		U_fSayDado(oPrn,@nLinha,0100,060,oFontA16,cTexto											  				,/*/cCampo/*/,/*/aDados/*/,9)
		cTexto := "Campaña: "
		cTexto += U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/				,'F2_CAMPDES' ,aNF_Print,3)
		cTexto := Alltrim(cTexto)
		cCamProd := U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/				,'F2_CAMPROD' ,aNF_Print,3)
		If !Empty(cCamProd)
			cTexto += ' - '+cCamProd
		Endif
		cTexto := Alltrim(cTexto)
		U_fSayDado(oPrn,@nLinha,0800,000,oFontA16,cTexto											  				,/*/cCampo/*/	,/*/aDados/*/	,9)
		U_fSayDado(oPrn,@nLinha,1710,000,oFontA16,/*/cTit/*/										  				,'F2_EMISSAO'	,aNF_Print		,1) //titulo do campo
		U_fSayDado(oPrn,@nLinha,1960,000,oFontA16,': '											  					,'F2_EMISSAO'	,aNF_Print		,2) //Dado grava do campo
		oProcess:IncRegua2("Cabec ...")
		cTexto := ' '+Alltrim(U_fSayDado(/*/oPrn/*/,/*/nLinha/*/,/*/nCol/*/,/*/nQtLin/*/,/*/oFonte/*/,/*/cTit/*/	,'M0_FILIAL'	,aEmp,3))	
		U_fSayDado(oPrn,@nLinha,0100,040,oFontAB12,'AGRO CENTRO S/A'									  			,/*/cCampo/*/	,/*/aDados/*/,9)
		U_fSayDado(oPrn,@nLinha,0400,000,oFontAB10,cTexto												  			,/*/cCampo/*/	,/*/aDados/*/,9)
		oProcess:IncRegua2("Cabec ...")
		U_fSayDado(oPrn,@nLinha,1710,000,oFontAB12,/*/cTit/*/											  			,'A1_NOME'		,aClient_Print,2) //Dado grava do campo
		nLinha += 040
	EndIf
Return


/*/{Protheus.doc} MENSOBSLOC
Mensagem Padrão
@type function
@version 1.0
@author Luiz Fael
@since 09/01/2023
@param nLinha, numeric, Linha
@return variant, Nill
/*/
Static Function MENSOBSLOC(nLinha)
	Local nTamObs:=150
	oPrn:Say(nLinha, 1600, UPPER(SUBSTR(cMensagem,1,nTamObs)) , oFontA12) //Dado grava do campo
	nLinha += 30
	oPrn:Say(nLinha, 1600, UPPER(SUBSTR(cMensagem,151,nTamObs)) , oFontA12) //Dado grava do campo
	nLinha += 30
	oPrn:Say(nLinha, 1600, UPPER(SUBSTR(cMensagem,301,nTamObs)) , oFontA12) //Dado grava do campo
	nLinha += 30
Return

/*/{Protheus.doc} IMPMENPLOC
Imprime Formula
@type function
@version 1.0
@author Luiz Fael
@since 22/12/2022
@param nLinha, numeric, nLinha
@return variant,Nill
/*/
Static Function IMPMENPLOC(nLinha)
	If !Empty(cCod_Mens)
		oPrn:Say(nLinha, 1600, FORMULA(cCod_Mens) , oFontA12) //Dado grava do campo
		nLinha += 30
	Endif
Return
