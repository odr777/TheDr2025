#Include "Rwmake.ch"
#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRDVFD1   ºAutor  ³EDUAR ANDIA         º Data ³  03/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Executado ao momento que processa a Mudanca entre os  º±±
±±º          ³ Folders Principais                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLIVIA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRDVFD1
Local lRet 		:= .T.
Local nAntigo   	:= ParamIxb[1]
Local nOpcx		:= ParamIxb[2]
Local nFich_Reg	:= 01	//"Ficha cadastral"
Local nSoc_ECult	:= 02	//"Socio-Economico-Cultural"
Local nDespend	:= 03	//"Dependentes"
Local nTarjetas	:= 04	//"Cartoes"
Local nDoc_Entrg	:= 05	//"Doc.Entregues"
Local nComplFi	:= 01	//"Compl.ficha"
Local Ref_Trab	:= 02	//"Ref. trabalhos"
Local Ref_Tarj	:= 03	//"Ref. cartoes"
Local Ref_Banc	:= 04	//"Ref. bancarias"
Local Ref_Pers	:= 05	//"Ref. pessoais"
Private lAuRet	:= .F.

/*	wico2k 22-3-2022 - Trae problemas en el release 27
If AllTrim(FUNNAME()) == "CRDA010" .And. lPeVfd1	//Archivo de Clientes	
*/
If AllTrim(FUNNAME()) == "CRDA010"	//Archivo de Clientes	
	lPeVfd1  := .F.
	cGruNiv1 := GetNewPar("MV_CRDNVL1",'000000')
	cGruNiv2 := GetNewPar("MV_CRDNVL2",'000003')
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Oculta uma pasta.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if (!U_UserPertGrp(cGruNiv1)); oFolder1:aEnable(nSoc_ECult,lAuRet); EndIf
	oFolder1:aEnable(nDespend,lAuRet)
	oFolder1:aEnable(nTarjetas,lAuRet)
	
//	Titulos dos Folders da Ficha cadastral
	oFolder2:aEnable(Ref_Tarj,lAuRet)
	oFolder2:aEnable(Ref_Banc,lAuRet)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ A pasta continuará visível, porém não será possível selecioná-la. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALTERA
		//RS	Cambiar ("000002") por el grupo establecidos para los vendedores
		If !U_UserPertGrp(cGruNiv2)
			If !U_UserPertGrp(cGruNiv1) .And. ((MA7->MA7_BLOQUE=="3").AND.(MA7->MA7_DATABL+MA7->MA7_PONCRE>dDataBase))
				MsgStop("No se puede modificar el registro","TOTVS")
				lAuRet		 := .F.
				M->MA7_PONPER:= 1
			Else
				lAuRet		 := .T.
				M->MA7_PONPER:= 0
			endIf
			
			
			oFolder1:aEnable(nFich_Reg ,lAuRet)
			oFolder1:aEnable(nDoc_Entrg,lAuRet)
			
			oFolder2:aEnable(nComplFi,lAuRet)	//RS
			oFolder2:aEnable(Ref_Pers,lAuRet)	//RS
			oFolder2:aEnable(Ref_Trab,lAuRet)	//RS
		Else
			oFolder1:aEnable(nFich_Reg ,.T.)
			oFolder1:aEnable(nDoc_Entrg,.F.)
			
			oFolder2:aEnable(nComplFi,.T.)	//RS
			oFolder2:aEnable(Ref_Pers,.F.)	//RS
			oFolder2:aEnable(Ref_Trab,.F.)	//RS			
		EndIf
		
	Endif
	
	oMainwnd:refresh()
Endif
Return(lRet)


/*ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Valida si es Verificador*/
User Function ValVerif()
	Local lRet  := .T. 

	/*	wico2k 22-3-2022 - Trae problemas en el release 27
	If lPeVfd1; lAux := ExecBlock("CRDVFD1",.F.,.F.,{1,2}); EndIf
	*/

Return(lRet)
