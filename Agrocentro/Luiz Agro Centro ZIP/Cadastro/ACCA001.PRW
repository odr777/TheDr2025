#include "protheus.ch"
#include "ACCA001.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "ApWizard.ch"
#define ENTER Chr(13)+Chr(10)

/*/{Protheus.doc} ACCA001
Cadastro Ano agricola e Periodo de Safra
@type function
@version 1.0
@author Luiz Fael
@since 19/11/2022
@return variant, nill
/*/
User Function ACCA001()
	Local oBrowse
	ZZK->(DBSETORDER(1))
	If ZZK->(RecCount()) == 0
		U_IntePIMS()
	EndIf
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZK")
	oBrowse:SetDescription(STR0001)
	oBrowse:AddLegend( "ZZK_MSBLQL=='1'", "RED"		,STR0002 ) //"Ativo"
	oBrowse:AddLegend( "ZZK_MSBLQL<>'1'", "GREEN" 	, STR0003 ) //"Inativo"
	oBrowse:Activate()
Return Nil

/*/{Protheus.doc} MenuDef
MenuDef cadastro de campanha
@type function
@version 1.0 
@author SAFSERVICE
@since 17/07/2022
/*/
Static Function MenuDef()
/*
1 para Pesquisar
2 para Visualizar
3 para Incluir
4 para Alterar
5 para Excluir
6 para Imprimir
7 para Copiar
5. Nível de acesso
6. Habilita Menu Funcional
*/
	Local aRotina := {}
	aAdd( aRotina, { STR0002 , 'VIEWDEF.ACCA001', 0, 1, 0, NIL } ) //'Pesquisa'
	aAdd( aRotina, { STR0003 , 'VIEWDEF.ACCA001', 0, 2, 0, NIL } ) //"Visualizar"
	aAdd( aRotina, { STR0004 , 'VIEWDEF.ACCA001', 0, 4, 0, NIL } ) //"Alterar"
	aAdd( aRotina, { STR0005 , 'U_IntePIMS'		, 0, 5, 0, NIL } ) //"PIMS"
Return aRotina

/*/{Protheus.doc} ModelDef
ModelDef Cadastro de Campanha
@type function
@version  1.0
@author SAFSERVICE
@since 17/07/2022
/*/
Static Function ModelDef()
	Local oModel
	Local oStruZZK 	:= FWFormStruct( 1, 'ZZK' )
	Local oStruZZL 	:= FWFormStruct( 1, 'ZZL' )
	Local bPre := {|oGridModel, nLine, cAction, cIDField| bGrid(oGridModel, nLine, cAction, cIDField)}
	Local bCommit	:= {||GRAVA()}
	Private nLinha  := 1
	ZZK->(dbSetOrder(1)) //ZZK_FILIAL+ZZK_COD
	oModel:=MPFormModel():New('ACCA001M',/*bPreValidacao*/,,bCommit, /*bCancel*/)
	oModel:AddFields("ZZKMASTER",, oStruZZK )
	oModel:AddGrid("ZZLDETAIL","ZZKMASTER", oStruZZL, /*bLinePre*/,/*bLinePost*/ ,bPre, /* bLinePost*/, /*bLoad*/ )
	oModel:SetRelation('ZZLDETAIL',{{'ZZL_FILIAL','xFilial("ZZL")'},{'ZZL_IDSAF','ZZK_IDSAF'}},ZZL->( IndexKey(3)))
	oModel:SetPrimaryKey( { "ZZK_FILIAL", "ZZK_COD" } )
	oModel:SetDescription(STR0001) //TITULO
	oModel:GetModel( 'ZZKMASTER' ):SetDescription(STR0006) //'Campanha'
	oModel:GetModel( 'ZZLDETAIL' ):SetDescription(STR0007) //'Produção'
	oModel:GetModel( 'ZZLDETAIL' ):SetUniqueLine( { 'ZZL_COD'} )
	oModel:SetVldActivate( { |oModel,nLinha| LINHAS( oModel,nLinha ) } )
	oModel:GetModel( 'ZZLDETAIL' ):SetOptional( .T. )
	oModel:AddRules( 'ZZLDETAIL', 'ZZL_DFIM ', 'ZZLDETAIL', 'ZZK_DINI', 1 )
	oModel:GetModel( 'ZZLDETAIL' ):SetUniqueLine( { 'ZZL_COD' } )
Return oModel


/*/{Protheus.doc} ViewDef
ViewDef Cadastro de Campnha
@type function
@version  1.0
@author SAFSERVICE
@since 17/07/2022
/*/
Static Function ViewDef()
	Local oView
	Local oStruZZK := FWFormStruct(2, 'ZZK')
	Local oStruZZL := FWFormStruct(2, 'ZZL',{|cCampo|  !AllTRim(cCampo) $ "ZZL_FILIAL" })
	Local oModel 	:= FWLoadModel( 'ACCA001' )
	oView:=FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZZK', oStruZZK, 'ZZKMASTER' )
	oView:AddGrid(  'VIEW_ZZL', oStruZZL, 'ZZLDETAIL' )
	oView:CreateHorizontalBox( 'SUPERIOR', 20 )
	oView:CreateHorizontalBox( 'INFERIOR', 80 )
	oView:SetOwnerView( 'VIEW_ZZK', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZZL', 'INFERIOR' )
Return oView

/*/{Protheus.doc} bGrid
Validação do Grid
@type function
@version 1.0
@author Luiz Fael
@since 29/11/2022
@param oGridModel, object, oGridModel
@param nLine, numeric, Linha do grid
@param cAction, character, Inclusão, Alteração,Exclusão
@param cIDField, character, Campo do grid
@return variant, Nill
/*/
Static Function bGrid(oGridModel, nLine, cAction, cIDField)
	Local lRet 		:= .T.
	Local dIni		:= ctod('  /  /  ')
	Local dFim		:= ctod('  /  /  ')
	If cAction == "SETVALUE" //"ISENABLE" //"CANSETVALUE"
		dIni		:= oGridModel:GetValue("ZZL_DINI")
		dFim		:= oGridModel:GetValue("ZZL_DFIM")
		If cIDField == "ZZL_DINI" .or. cIDField == "ZZL_DFIM"
			lRet := U_DIniFim(dIni,dFim)
		EndIf
	EndIf
Return lRet

/*/{Protheus.doc} LINHAS
Validação da linha no grid
@type function
@version 1.0
@author Luiz Fael
@since 29/11/2022
@param oModel, object, oModel
@param nLinha, numeric, Linha do Grid
@return variant, Nill
/*/
Static Function LINHAS(oModel,nLinha)
	Local oModelZZL		:= oModel:GetModel("ZZLDETAIL")
	Local nOperation 	:= oModel:GetOperation()
	Local nX			:= 0
	Local lRet			:= .T.
	Local aSaveLine		:= FWSaveRows()
	For nX := 1 To oModelZZL:Length()
		oModelZZL:GoLine( nX )
		If nOperation == MODEL_OPERATION_UPDATE
			oModelZZL:IsUpdated()
		EndIf
	Next nX
	FWRestRows( aSaveLine )
Return(lRet)

/*/{Protheus.doc} GRAVA
Gravação ZZK e ZZL
@type function
@version 1.0
@author Luiz Fael
@since 29/11/2022
@return variant, Nill
/*/
Static Function GRAVA()
	Local oModel		:= FWModelActive()
	Local oModelZZK		:= oModel:GetModel('ZZKMASTER')
	Local oModelZZL		:= oModel:GetModel("ZZLDETAIL")
	Local nOper 		:= oModel:GetOperation()
	Local oSTRZZK		:= FWFormStruct( 2, 'ZZK' )
	Local aZZK			:= oSTRZZK:AFIELDS
	Local oSTRZZL		:= FWFormStruct( 2, 'ZZL' )
	Local aZZL			:= oSTRZZL:AFIELDS
	Local nK 			:= 0
	Local nL			:= 0
	Local cZZKIDSAF 	:= oModelZZK:GetValue('ZZK_IDSAF')
	Local nPosKMSBLQL	:= aScan(aZZK, {|x| ALLTRIM(x[1]) == 'ZZK_MSBLQL'})
	Local nPosLCod		:= aScan(aZZL, {|x| ALLTRIM(x[1]) == 'ZZL_COD'})
	Local cMSBLQL
	If nOper == MODEL_OPERATION_UPDATE
		//ZZK->(dbSetOrder(3)) //ZZK_COD
		ZZL->(dbSetOrder(4)) //ZZL_FILIAL+ZZL_IDSAF+ZZZ_COD
		//--------------------------------------------------------------------------------------------------//
		//If ZZK->(dbseek(cZZKIDSAF))
			//--------------------------------------------------------------------------------------------------//
			cMSBLQL	:= oModelZZK:GetValue(aZZK[nPosKMSBLQL][01])
			For nK := 1 To Len(aZZK)
				RecLock("ZZK",.F.)
				If 	!aZZK[nK][01] $ 'ZZK_FILIAL/ZZK_COD/ZZK_DESC/ZZK_IDSAF/ZZK_LASTUP/ZZK_CHAGBY'
					&('ZZK->'+aZZK[nK][01]) := oModelZZK:GetValue(aZZK[nK][01])
				EndIf
				If 	aZZK[nK][01] == 'ZZK_MSBLQL'
					&('ZZK->'+aZZK[nK][01]) := cMSBLQL
				EndIf
				ZZK->(MsUnlock())
			Next nK
			//--------------------------------------------------------------------------------------------------//
			For  nL := 1 To Len(aZZL)
				If 	aZZL[nL][01] == 'ZZL_MSBLQL'
					cZZLCOD := oModelZZL:GetValue(aZZL[nPosLCod][01])
					cZZKIDSAF := PadR( cZZKIDSAF ,Len(ZZK->ZZK_IDSAF) )
					If ZZL->(dbseek(xFilial('ZZL')+cZZKIDSAF+cZZLCOD))
						RecLock("ZZL",.F.)
						IF cMSBLQL <> '1'
							cMSBLQL	:= oModelZZL:GetValue(aZZL[nL][01])
						EndIf
						&('ZZL->'+aZZL[nL][01]) := cMSBLQL
						ZZL->(MsUnlock())
					EndIf
				EndIf
			Next nL
		//EndIf
	EndIf
	FWFormCommit( oModel )
Return(.T.)

