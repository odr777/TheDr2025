#include "totvs.ch"
#include "xcampfun.ch"

/*/{Protheus.doc} DIniFim
Valida data Campanha ou Produção
@type function
@version 1.0
@author Luiz Fael
@since 29/11/2022
@param dIni, date, data inicio
@param dFim, date, data fim
@return variant, logico .T. OU .F.
/*/
User Function DIniFim(dIni,dFim)
	Local aArea     := GetArea()
	Local lRet      := .T.
	Local cTitulo   := ''
	local aMsg  	:= {}
	Local aSolu 	:= {}

	If dIni> dFim
		cTitulo	:= STR0003 //'Data Inicio'
		lRet := .F.
		aMsg  	:= {STR0005} //'Inválido'
		aSolu 	:= {STR0009} // 'Informar una data inicial menor que a data final'
		ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
	EndIf
	If dFim < dIni
		lRet := .F.
		cTitulo	:= STR0004 //'Data Fim'
		aMsg  	:= {STR0005} //'Invalido'
		aSolu 	:= {STR0010} //'Informe uma data final maior que a data inicial'
		ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
	EndIf
	If dFim == dIni
		lRet := .F.
		cTitulo	:= STR0006 //'Data Inico e Fim'
		aMsg  	:= {STR0005} //"Invalido
		aSolu 	:= {STR0007} //'Data inicia e final não pode ser iguais'
		ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
	EndIf
	RestArea(aArea)
	FwFreeArray(aMsg)
	FwFreeArray(aSolu)
Return(lRet)


/*/{Protheus.doc} CodCamp
Valida Campanha 
@type function
@version 1.0
@author Luiz Fael
@since 29/11/2022
@param cCamp, character, Codigo campanha
@return variant, return_Logico .T. .F.
/*/
User Function CodCamp(cCamp)
	Local aArea     := GetArea()
	Local lRet      := .T.
	Local cTitulo	:= STR0001 //"Campanha"
	local aMsg  	:= {}
	Local aSolu 	:= {}
	default cCamp   := ''
	default cProd   := ''

	ZZK->(dbSetOrder(1)) //ZZK_FILIAL+ZZK_COD
	If ZZK->(dbSeek(xFilial('ZZK')+cCamp))
		If ZZK->ZZK_MSBLQL == '1'
			lRet 	:= .F.
			aMsg  	:= {STR0005} //'Inválido'
			aSolu 	:= {STR0011} //'Campanha Bloqueada!'
			ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
		Else
			lRet := U_DIniFim(ZZK->ZZK_DINI,ZZK->ZZK_DFIM)
			If !lRet
				RecLock("ZZK",.F.)
				ZZK->ZZK_MSBLQL := '1'
				ZZK->(MsUnlock())
				aMsg  	:= {STR0005} //'Inválido'
				aSolu 	:= {STR0008} //'Perido de Data Vencido!'
				ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
			EndIf
		EndIf
	Else
		lRet 	:= .F.
		aMsg  	:= {STR0005} //'Inválido'
		aSolu 	:= {STR0013} //'Não foi localizado o codigo (ZZK)!'
		ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
	EndIf
	RestArea(aArea)
	FwFreeArray(aMsg)
	FwFreeArray(aSolu)
Return(lRet)

/*/{Protheus.doc} PerProd
Valida Periodo Produção
@type function
@version 1.0
@author Luiz Fael
@since 29/11/2022
@param cCamp, character, Codigo campanha
@param cProd, character, Codigo produçãp
@return variant, return_Logico .T. .F.
/*/
User Function PerProd(cCamp,cProd)
	Local aArea     := GetArea()
	Local lRet      := .T.
	Local cTitulo	:= STR0002 //"Periodo de Produção"
	local aMsg  	:= {}
	Local aSolu 	:= {}
	default cCamp   := ''
	default cProd   := ''

	If !Empty(cCamp)
		ZZL->(dbSetOrder(1)) //ZZK_FILIAL+ZZK_COD
		If ZZL->(dbSeek(xFilial('ZZL')+cProd))
			If ZZL->ZZL_MSBLQL == '1'
				lRet 	:= .F.
				aMsg  	:= {STR0005} //'Inválido'
				aSolu 	:= {STR0012} //'Periodo de Produção Bloqueado!'
				ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
			Else
				lRet := U_DIniFim(ZZL->ZZL_DINI,ZZL->ZZL_DFIM)
				If !lRet
					RecLock("ZZL",.F.)
					ZZL->ZZL_MSBLQL := '1'
					ZZL->(MsUnlock())
					aMsg  	:= {STR0005} //'Inválido'
					aSolu 	:= {STR0008} //'Perido de Data Vencido!'
					ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
				EndIf
			EndIf
		Else
			lRet 	:= .F.
			aMsg  	:= {STR0005} //'Inválido'
			aSolu 	:= {STR0019} //'Não foi localizado o codigo (ZZL)!'
			ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
		EndIf
	Else
		lRet 	:= .F.
		aMsg  	:= {STR0005} //'Inválido'
		aSolu 	:= {STR0014} //'Informe o Codigo da Campanha!'
		ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
	EndIf
	RestArea(aArea)
	FwFreeArray(aMsg)
	FwFreeArray(aSolu)
Return(lRet)

/*/{Protheus.doc} IntePIMS
Integração PIMS
@type function
@version 1.0
@author Luiz Fael
@since 29/11/2022
@return variant, Nill
/*/
User Function IntePIMS()
	Local aPar 		:= {}
	Local cLin15	:= ''
	Local cLin16	:= ''
	Local cLin17	:= ''
	Local cLin18	:= ''
	Local cLin19	:= ''
	Local cLin20	:= ''
	//'ARG/COS/COL/CHI/PER'
	//'RUS'
	//'PTG/ANG'
	//'BR'
	//'EUA'
	If __LANGUAGE == "SPANISH"
		cLin15	:=	'Rutina para la integración de la Campaña y'
		cLin16	:=	'Período de la Producción. '
		cLin17	:=	'La integración actualiza los períodos (fecha de inicio y finalización),'
		cLin18	:=	'Cuando el período de campaña ha expirado,los períodos de producción'
		cLin19	:=	'se bloquearán'
		cLin20	:=	'Confirme la integración <OK> Cancelar <Cancelar>'
	ElseIf __LANGUAGE == "ENGLISH"
		cLin15	:=	'Routine for integration of the Campaign period '
		cLin16	:=	'and the production period.'
		cLin17	:=	'The integration updates the periods (start and end date), from the '
		cLin18	:=	'Campaign and production period. When the campaign period '
		cLin19	:=	'is expired, the production periods will be blocked.'
		cLin20	:=	'Confirm the integration <OK> Cancel <Cancel>'
	Else    //cPaisLoc $ 'BR'
		cLin15	:=	'Rotina para integração do período de Campanha '
		cLin16	:=	'e do período de produção.'
		cLin17	:=	'A integração atualiza os períodos (data início e fim), da '
		cLin18	:=	'campanha e do período de produção. Quando o período da campanha '
		cLin19	:=	'estiver vencido, o(s) períodos de produção serão bloqueado(s).'
		cLin20	:=	'Confirme a integração <OK> Cancele <Cancela>'
	EndIf
	aAdd(aPar,{9,cLin15,300,08,.T.})
	aAdd(aPar,{9,cLin16,300,08,.T.})
	aAdd(aPar,{9,cLin17,300,08,.T.})
	aAdd(aPar,{9,cLin18,300,08,.T.})
	aAdd(aPar,{9,cLin19,300,08,.T.})
	aAdd(aPar,{9,cLin20,300,08,.T.})
	If ParamBox(aPar,STR0015,,,,,,,,"INTPIMS",.F., .F.) //'Integração PIMS'
		Processa({|| U_PIMS() },STR0016,,.T.) //'Gerando Integração PIMS...'
	EndIf
	FwFreeArray(aPar)
Return

/*/{Protheus.doc} PIMS
Rotina de Ingegração PIMS
@type function
@version 1.0
@author Luiz Fael
@since 29/11/2022
@return variant, Logico .T. .F.
/*/
User Function PIMS()
	Local 	aDados		:= {}
	Local   cIniFile 	:= GetAdv97()
	Local   nX			:= 0
	Local 	cMSBLQL 	:= '2'
	Local   cQuery		:= ''
	Local 	ZZLCOD		:= ''
	Private MVPIMSBAS	:= SuperGetMV('MV_PIMSBAS'	,.F.,'MSSQL7/PINS')
	Private MVPIMIP		:= SuperGetMV('MVPIMIP'		,.F.,'105.0.0.207')
	Private nOrbo		:= AdvConnection()

	cProtect  := GetPvProfString("TopConnect","ProtheusOnly","0",cInIfile )
	IF cProtect == "1"
		cProtect := "@@__@@"    //Assinatura para o TOP
	Else
		cProtect := ""
	Endif
	TcConType("TCPIP")
	nConn := TCLink(cProtect+"@!!@"+MVPIMSBAS,MVPIMIP)
	If nConn < 0
		MsgAlert(STR0017) //'Erro Conexão com a base de dados do PIMS'
		TcSetConn(nOrbo)
		TcUnLink(nConn)
		Return
	EndIf
	TcSetConn(nConn)
    /*/
	Tabela pims: SAFRA
	ID_SAFRA
	CD_SAFRA - Código do Ano Agrícola
	DE_SAFRA - Descrição do Ano Agrícola
	ID_SAFRA - Ano Agrícola
    /*/
	cQuery +=	"SELECT "
	cQuery +=	"			SAFRA.DE_SAFRA 		"					//	aDados[nX][01] 	'Desc.Campanha'
	cQuery +=	"			,SAFRA.DT_INI_SAFRA	"					//	aDados[nX][02]	'Dat.Inic.Camp'
	cQuery +=	"			,SAFRA.DT_FIM_SAFRA	"					//	aDados[nX][03]	'Dat.Fim.Camp.'
	cQuery +=	"			,SAFRA.LAST_UPDATE	as 'LASUPANO'	"	//	aDados[nX][04]	'Dat.Upd.     '
	cQuery +=	"			,SAFRA.CHANGED_BY	as 'CHAANO'		"	//	aDados[nX][05]	'Upd.Por.Camp.'
	cQuery +=	"			,SAFRA.ID_SAFRA		as 'IDANO'		"	//	aDados[nX][06]	'ID.Cod.Camp. '
	cQuery +=	"			,PERIO.ID_SAFRA   	as 'IDPERIODO'	"	//	aDados[nX][07]	'ID.Cod.Prod. '
	cQuery +=	"			,PERIO.DA_PER_SAFRA	"					//	aDados[nX][08]	'Descr.Prod.  '
	cQuery +=	"			,PERIO.DE_PER_SAFRA	"					//	aDados[nX][09]	'Nome Prod.   '
	cQuery +=	"			,PERIO.DT_INI_PER	"					//	aDados[nX][10]	'Dat.Pr.Inicio'
	cQuery +=	"			,PERIO.DT_FIM_PER	"					//	aDados[nX][11]	'Dat.Pr.Final.'
	cQuery +=	"			,PERIO.FG_EXPORTA	"					//	aDados[nX][12]	'Exportar     '
	cQuery +=	"			,PERIO.FG_INVESTIMENTO	"				//	aDados[nX][13]	'Investir     '
	cQuery +=	"			,PERIO.ID_PERIODOSAFRA	"				//	aDados[nX][14]	'ID.Per.Camp. '
	cQuery +=	"			,PERIO.ID_OCUPACAO	"					//	aDados[nX][15]	'Ocupação     '
	cQuery +=	"			,PERIO.LAST_UPDATE	as 'LASUPCAM'	"	//	aDados[nX][16]	'Dat.Upd.     '
	cQuery +=	"			,PERIO.CHANGED_BY	as 'CHACAM'		"	//	aDados[nX][17]	'Upd.Por.Prod.'
	cQuery +=	"	FROM [PIMSMCQUA].dbo.PERIODOSAFRA PERIO	"
	cQuery +=	"	INNER JOIN [PIMSMCQUA].dbo.SAFRA  SAFRA	"
	cQuery +=	"			ON(PERIO.ID_SAFRA = SAFRA.ID_SAFRA )	"

	aDados := JurSql(cQuery,{'DE_SAFRA','DT_INI_SAFRA','DT_FIM_SAFRA','LASUPANO','CHAANO','IDANO','IDPERIODO','DA_PER_SAFRA',;
		'DE_PER_SAFRA','DT_INI_PER','DT_FIM_PER','FG_EXPORTA','FG_INVESTIMENTO','ID_PERIODOSAFRA',;
		'ID_OCUPACAO','LASUPCAM','CHACAM'})
	TcSetConn(nOrbo)
	TcUnLink(nConn)
	ZZK->(dbSetOrder(2)) //ZZK_IDSAF
	ZZL->(dbSetOrder(3)) //ZZL_IDSAF

	ProcRegua(Len(aDados))

	For nX := 1 TO Len(aDados)
		cMSBLQL := '2'
		IncProc(STR0018+Alltrim(aDados[nX][01])) //'Processando: '
		//Data da Campanha
		If  Date() < aDados[nX][02] .or. Date() > aDados[nX][03]  //'Dat.Inic.Camp' 'Dat.Fim.Camp.'
			cMSBLQL := '1'
		EndIf
		aDados[nX][06] := Alltrim(STR(aDados[nX][06]))
		If ZZK->(dbSeek(aDados[nX][06]))
			RecLock("ZZK",.F.)
		Else
			RecLock("ZZK",.T.)
		EndIf
		ZZK->ZZK_FILIAL	:= xFilial('ZZK')
		ZZK->ZZK_COD   	:= GetSx8Num("ZZK","ZZK_COD")
		ZZK->ZZK_DESC  	:= Alltrim(aDados[nX][01])					//adados[nX][01]	'Desc.Campanha'
		ZZK->ZZK_DINI  	:= aDados[nX][02]							//adados[nX][02]	'Dat.Inic.Camp'
		ZZK->ZZK_DFIM  	:= aDados[nX][03]							//adados[nX][03]	'Dat.Fim.Camp.'
		ZZK->ZZK_LASTUP	:= aDados[nX][04]							//adados[nX][04]	'Dat.Upd.     '
		ZZK->ZZK_CHAGBY	:= Alltrim(aDados[nX][05])					//adados[nX][05]	'Upd.Por.Camp.'
		ZZK->ZZK_IDSAF 	:= Alltrim(aDados[nX][06])					//adados[nX][06]	'ID.Cod.Camp. '
		ZZK->ZZK_MSBLQL	:= cMSBLQL
		ZZK->(MsUnlock())
		If cMSBLQL <> '1'
			If Date() < aDados[nX][10]  .and. Date() > aDados[nX][11] //PERIO.DT_INI_PER PERIO.DT_FIM_PER
				cMSBLQL := '1'
			EndIf
		EndIf
		aDados[nX][07] := Alltrim(STR(aDados[nX][07]))
		adados[nX][15] := Alltrim(STR(aDados[nX][15]))
		adados[nX][14] := Alltrim(STR(aDados[nX][14]))
		ZZLCOD := fNumProd(adados[nX][07])
		If ZZL->(dbSeek(aDados[nX][07])) 	//adados[nX][07]	PERIO.ID_SAFRA
			RecLock("ZZL",.F.)
		Else
			RecLock("ZZL",.T.)
		EndIf
		ZZL->ZZL_FILIAL	:= 	xFilial('ZZL')
		ZZL->ZZL_COD   	:=	ZZLCOD
		ZZL->ZZL_DESC  	:=	adados[nX][08]						//adados[nX][08]	PERIO.DA_PER_SAFRA
		ZZL->ZZL_DINI  	:= 	adados[nX][10]						//adados[nX][10]	PERIO.DT_INI_PER
		ZZL->ZZL_DFIM  	:=	adados[nX][11]						//adados[nX][11]	PERIO.DT_FIM_PER
		ZZL->ZZL_IDOCUP	:=	adados[nX][15]						//adados[nX][15]	PERIO.ID_OCUPACAO
		ZZL->ZZL_IDPER 	:=	adados[nX][14]						//adados[nX][14]	PERIO.ID_PERIODOSAFRA
		ZZL->ZZL_IDSAF	:=	adados[nX][07]						//adados[nX][07]	PERIO.ID_SAFRA
		ZZL->ZZL_LASTUP	:= 	aDados[nX][16]						//adados[nX][16]	PERIO.LAST_UPDATE
		ZZL->ZZL_CHAGBY	:= 	Alltrim(aDados[nX][17])				//adados[nX][17]	PERIO.CHANGED_BY
		ZZL->ZZL_MSBLQL	:=  cMSBLQL
		ZZL->(MsUnlock())
	Next nX
Return

/*/{Protheus.doc} fNumProd
Numeração para Periodo Produtivo
@type function
@version 1.0
@author Luiz Fael
@since 30/11/2022
@param IDSAF, variant, IDSAF
@return variant, Char Codigo
/*/
Static Function fNumProd(IDSAF)
	Local cQuery 	:= ''
	Local aCod		:= {}
	Local cNum		:= ''
	cQuery += " SELECT MAX(ZZL.ZZL_COD) as COD "
	cQuery += " FROM "+RetSqlName("ZZL")+" ZZL "
	cQuery += " WHERE "
	cQuery += " ZZL.ZZL_IDSAF = '"+IDSAF+"'"
	cQuery += " AND ZZL.D_E_L_E_T_ = ' '  "
	cQuery += " GROUP BY ZZL.ZZL_COD "
	cQuery += " ORDER BY ZZL.ZZL_COD "
	aCod := JurSql(cQuery,{'COD'})
	If Len(aCod) == 0
		cNum := '001'
	Else
		cNum := StrZero(Val(aCod[1][1])+1,3,0)
	EndIf
	FwFreeArray(aCod)
Return(cNum)

/*/{Protheus.doc} CampDes
Descrição da Campanha, validacao cadastr ZZK e ZZL
@type function
@version 1.0
@author Luiz Fael
@since 01/12/2022
@param cCampo, character, Codigo da Campanha
@return variant, .t. .f.
/*/
User Function CampDes(oNewDialog,cCampana,cCampro,cCampdes,cCamProd)
	Local cTitulo		:= ''
	Local cQuery 		:= ''
	Local aCod			:= {}
	local aMsg  		:= {}
	Local aSolu 		:= {}
	Local lRet 			:= .F.
	default cCampana	:= ''
	default cCampdes	:= ''
	default cCodPro 	:= ''
	default cCamProd	:= ''
	If INCLUI .OR. ALTERA
		iF !Empty(cCampana)
			cQuery += " SELECT "
			cQuery += " ZZK.R_E_C_N_O_ ZZK_REC, "
			cQuery += " ZZL.R_E_C_N_O_ ZZL_REC "
			cQuery += " FROM "+RetSqlName("ZZK")+" ZZK "
			cQuery += " INNER JOIN "+RetSqlName("ZZL")+" ZZL "
			cQuery += " 	ON( ZZL.ZZL_FILIAL = ZZK.ZZK_FILIAL "
			cQuery += 			IIf(!Empty(cCampro), "AND ZZL.ZZL_COD = '"+cCampro+" ' ", "")
			cQuery += " 		AND ZZL.ZZL_IDSAF = ZZK.ZZK_IDSAF "
			cQuery += " 		AND ZZL.D_E_L_E_T_ = ' ') "
			cQuery += " WHERE "
			cQuery += " ZZK.ZZK_FILIAL = '"+xFilial('ZZK')+"' "
			cQuery += " AND ZZK.ZZK_COD = '"+cCampana+"'"
			cQuery += " AND ZZL.D_E_L_E_T_ = ' '  "
			aCod := JurSql(cQuery,{'ZZK_REC','ZZL_REC'})
			If Len(aCod) <> 0
				ZZK->(dbGoto(aCod[1][1]))
				ZZL->(dbGoto(aCod[1][2]))
				lRet := .T.
				cCampdes  := Alltrim(ZZK->ZZK_DESC)
				If !Empty(cCamPro)
					cCamProd := Alltrim(ZZL->ZZL_DESC)
				EndIf
			Else
				cTitulo	:= STR0001 //"Campanha"
				aMsg  	:= {'Codigo da Campanha Não existe','ou não tem Perido de Produção Cadastrado.'}
				aSolu 	:= {'Ente em contato com o Suporte de TI.','Para atualizar o cadastro (ZZK/ZZL).'}
				ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
			EndIf
		Else
			cTitulo	:= STR0001 //"Campanha"
			aMsg  	:= {'Codigo da Campnha nõ foi informado!'}
			aSolu 	:= {'Para proceseguir informe o codigo da Campanha.'}
			ShowHelpDlg(cTitulo,aMsg,Len(aMSG),aSolu,Len(aSolu))
		EndIf
	Else
		lRet := .F.	
	EndIf
	oNewDialog:Refresh()
	FwFreeArray(aMsg)
	FwFreeArray(aSolu)
	FwFreeArray(aCod)
Return(lRet)
