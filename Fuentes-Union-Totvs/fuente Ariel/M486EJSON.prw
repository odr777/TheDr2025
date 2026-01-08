#INCLUDE "TOTVS.CH"
 
User Function M486EJSON()
    Local cJson     := PARAMIXB[1]
	Local oJson     := JsonObject():new()
	Local ret       := oJson:fromJson(cJson)

    If ValType(ret) == "U"
        Conout("JsonObject creado con éxito.")
    Else
        Conout("Falla al crear el JsonObject. Error: " + ret)
    Endif

	If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON STD",cJson,{'Ok'},,,,,.t.)
	endif
/*
	If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON OUT",cJson,{'Ok'},,,,,.t.)
	endif
*/
Return cJson
