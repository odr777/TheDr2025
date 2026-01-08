#Include "Protheus.ch"

/*/{Protheus.doc} ValCodGrPlaca
Validación del campo NG_XCGPLAC
@type function
@version 1.0 
@author Federico
@since 16/2/2022
/*/

User Function ValCodGrPlaca
cGrupo := SubStr(M->NG_GRUPO,1,2)
cString := AllTrim(M->NG_XCGPLAC)

If Empty(cString)
    Aviso("Código inválido","Debe registrar Código Grupo Placa",{"OK"})
    Return(.F.)
Else
    cNextAlias := GetNextAlias()
    BeginSQL Alias cNextAlias
    SELECT NG_XCGPLAC FROM %table:SNG% WHERE %NotDel% AND NG_FILIAL = %xFilial:SNG% AND SUBSTRING(NG_GRUPO,1,2) = %Exp:cGrupo% AND NG_XCGPLAC = %Exp:cString%
    EndSQL

    IF !Empty((cNextAlias)->NG_XCGPLAC)
        Aviso("Código inválido", "Ya existe el Código de Grupo, debe cambiar las siglas.",{"OK"})
        Return(.F.)
    EndIf   
EndIf

Return(.T.)
