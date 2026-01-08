#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function GetCorrPlaca
	(Obtener N1_CHAPA)
	@type  Function
	@author wico2k
	@since 17/01/2022
	@version 1.0
	/*/

User Function GetCorrPlaca(cGroup)
Local cGrupoSec := cGroup
Local cGrupoPri := SubStr(cGroup,1,2) + '00'

cNextAlias := GetNextAlias()
BeginSQL Alias cNextAlias
SELECT SUBSTRING(MAX(N1_CHAPA),1,8) Codigo, SUBSTRING(MAX(N1_CHAPA),9,3) + 1  Correlativo FROM %Table:SN1% WHERE %NotDel% AND N1_GRUPO = %Exp:cGrupoSec%
EndSQL

If (cNextAlias)->Correlativo > 1
    cRet := (cNextAlias)->Codigo + StrZero((cNextAlias)->Correlativo,3)
Else
    cSNGPri := GetNextAlias()
    cCodGPri := ""
    BeginSQL Alias cSNGPri
    SELECT NG_XCGPLAC Pri FROM %table:SNG% WHERE %NotDel% AND NG_FILIAL = %xFilial:SNG% AND NG_GRUPO = %Exp:cGrupoPri%
    EndSQL
    cCodGPri := (cSNGPri)->Pri

    cSNGSec := GetNextAlias()
    cCodGSec := ""
    BeginSQL Alias cSNGSec
    SELECT NG_XCGPLAC Sec FROM %table:SNG% WHERE %NotDel% AND NG_FILIAL = %xFilial:SNG% AND NG_GRUPO = %Exp:cGrupoSec%
    EndSQL
    cCodGSec := (cSNGSec)->Sec

    cRet := AllTrim(cCodGPri) + '-' + AllTrim(cCodGSec) + '-001'
EndIf 

Return cRet
