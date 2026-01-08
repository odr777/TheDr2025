
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} User Function corrCli
    
    Obtiene el correlativo del código de cliente
    
    @type  Function
    @author Nahim Terrazas
    @since 05/11/2020
    @version version 1
    /*/
User Function corrCli()
	Local cNextAlias := GetNextAlias()

	BeginSQL Alias cNextAlias
        SELECT MAX(A1_COD) + 1 correlativo
		FROM %table:SA1% SA1
		WHERE SA1.%notdel% 
		AND A1_COD NOT LIKE '%[a-z]%'
        AND ISNUMERIC(A1_COD) = 1
	EndSQL

    
	(cNextAlias)->( DbGoTop() )

	If (cNextAlias)->( !Eof() ) // caso exista correlativo
        return_var := StrZero((cNextAlias)->correlativo,6)
        // alert(return_var)
    else
        return_var := '000001'
    endif 

Return return_var
