#include "TOTVS.ch"

/*/{Protheus.doc} SM0Cab
Função para impressão da sys_company
@type function
@version 1.0
@author Luiz Fael
@since 27/01/2023
@param cEmpresa, character, param_Empresa
@param cFilAnt, character, param_Filial
@return variant, return_Matriz com dados da sys_company
/*/
User Function SM0Cab(cCodComp,cCodFil)
	Local MVLOGODIR		:= Alltrim(SuperGetMv("MV_LOGODIR",,"\Logo\"))
	Local MVLOGODEF		:= Alltrim(SuperGetMv("MV_LOGODEF",,"AGROCENTRO SA"))
	Local MVLOTIPO		:= Alltrim(SuperGetMv("MV_LTIPO"  ,,".PNG"))
	Local aRet 			:= {}
	Local aEmpresa		:= {}
	Local aCampos		:= {}
	Local aTit 			:= {}
	Local cSM0Campos	:= ''
	Local nX 			:= 0
	Local cTitulo 		:= ''
	Local cArqivo 		:= ''
	cSM0Campos	:= 'M0_CODIGO;M0_CODFIL;M0_FILIAL;M0_NOME;M0_NOMECOM;M0_FULNAME;M0_TEL;M0_FAX;M0_EQUIP;M0_TPINSC;'
	cSM0Campos	+= 'M0_CGC;M0_CEI;M0_INSC;M0_INSCM;M0_ENDENT;M0_COMPENT;M0_BAIRENT;M0_CIDENT;M0_ESTENT;M0_CEPENT;'
	cSM0Campos	+= 'M0_CODMUN;M0_ENDCOB;M0_COMPCOB;M0_BAIRCOB;M0_CIDCOB;M0_ESTCOB;M0_CEPCOB;M0_CNAE'

	aCampos 	:= StrToArray(cSM0Campos,';')
	aEmpresa   	:= FWSM0Util():GetSM0Data(cCodComp, cCodFil , aCampos )
	cArqivo 	:= StrTran(Alltrim(aEmpresa[05][02]), ".", "" )
	IF !FILE(MVLOGODIR+cArqivo+MVLOTIPO)
		cArqivo := MVLOGODEF
	EndIf
	MVLOGO 	:= MVLOGODIR+cArqivo+MVLOTIPO
	aTit 	:= SM0TIT(aTit)
	For nX := 1 to Len(aEmpresa)
		If  cPaisLoc == "ARG" .OR. cPaisLoc == "BOL"
			cTitulo	:= Alltrim(aTit[nX][02])
		ElseIf cPaisLoc == 'EUA'
			cTitulo	:= Alltrim(aTit[nX][03])
		Else
			cTitulo	:= Alltrim(aTit[nX][01])
		EndIf
		If nX == 1
			aadd(aRet,{'M0_LOGO',MVLOGO,cTitulo,'C','0001'})
		Else	
			aadd(aRet,{aEmpresa[nX][01],aEmpresa[nX][02],cTitulo,'C',StrZero(nX,4)})
		EndIf 
	Next nX
	FWfreeArray(aTit)
	FWfreeArray(aEmpresa)
	FWfreeArray(aCampos)
Return(aRet)

/*/{Protheus.doc} SM0TIT
Titulos dos campos sys_company
@type function
@version 1.0
@author Luiz Fael
@since 27/01/2023
@param aTit, array, Com titulos Vazio
@return variant, Array aTit Com titulos
/*/
Static Function SM0TIT(aTit)
	aadd(aTit,{"Logotipo"			,"Logotipo"			,"Logotipo"})			//aTit[01][02]
	aadd(aTit,{"Empresa"			,"Empresa"			,"Empresa"})			//aTit[02][02]
	aadd(aTit,{"Cod.Fil"			,"Cod.Fil"			,"Cod.Fil"})			//aTit[03][02]
	aadd(aTit,{"Filial"				,"Filial"			,"Filial"})				//aTit[04][02]
	aadd(aTit,{"Nome"				,"Nome"				,"Nome"})				//aTit[05][02]
	aadd(aTit,{"Comercial"			,"Comercial"		,"Comercial"})			//aTit[06][02]
	aadd(aTit,{"Razão Social"		,"Razão Social"		,"Razão Social"})		//aTit[07][02]
	aadd(aTit,{"Telefone"			,"Telefone"			,"Telefone"})			//aTit[08][02]
	aadd(aTit,{"Fax"				,"Fax"				,"Fax"})				//aTit[09][02]
	aadd(aTit,{"Equip"				,"Equip"			,"Equip"})				//aTit[10][02]
	aadd(aTit,{"Tipo INSC"			,"Tipo INSC"		,"Tipo INSC"})			//aTit[11][02]
	aadd(aTit,{"CNPJ"				,"CNPJ"				,"CNPJ"})				//aTit[12][02]
	aadd(aTit,{"CEI"				,"CEI"				,"CEI"})				//aTit[13][02]
	aadd(aTit,{"INSC"				,"INSC"				,"INSC"})				//aTit[14][02]
	aadd(aTit,{"Endereço Entrega"	,"Endereço Entrega"	,"Endereço Entrega"})	//aTit[16][02]
	aadd(aTit,{"Comp.Entrega"		,"Comp.Entrega"		,"Comp.Entrega"})		//aTit[17][02]
	aadd(aTit,{"Bairro Entrega"		,"Bairro Entrega"	,"Bairro Entrega"})		//aTit[18][02]
	aadd(aTit,{"Cidade Entrega"		,"Cidade Entrega"	,"Cidade Entrega"})		//aTit[19][02]
	aadd(aTit,{"Estado Entega"		,"Estado Entega"	,"Estado Entega"})		//aTit[20][02]
	aadd(aTit,{"CEP Entrega"		,"CEP Entrega"		,"CEP Entrega"})		//aTit[21][02]
	aadd(aTit,{"Minicípio Entrega"	,"Minicípio Entrega","Minicípio Entrega"})	//aTit[22][02]
	aadd(aTit,{"Endereça Cobrança"	,"Endereça Cobrança","Endereça Cobrança"})	//aTit[23][02]
	aadd(aTit,{"Comp.Entrega"		,"Comp.Entrega"		,"Comp.Entrega"})		//aTit[24][02]
	aadd(aTit,{"Bairro Cobrança"	,"Bairro Cobrança"	,"Bairro Cobrança"})	//aTit[25][02]
	aadd(aTit,{"Cidade Cobrança"	,"Cidade Cobrança"	,"Cidade Cobrança"})	//aTit[26][02]
	aadd(aTit,{"Estado Cobrança"	,"Estado Cobrança"	,"Estado Cobrança"})	//aTit[27][02]
	aadd(aTit,{"CEP Cobrança"		,"CEP Cobrança"		,"CEP Cobrança"})		//aTit[28][02]
	aadd(aTit,{"CNAE"				,"CNAE"				,"CNAE"})				//aTit[29][02]
Return(aTit)
