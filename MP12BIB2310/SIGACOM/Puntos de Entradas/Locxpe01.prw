#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} User Function nomeFunction
   Punto de Entrada para Agregar un botón en el toolbar al PC MATA120
   pedido de compra
   @type pe
   @author user
   @since 26/08/2021
   @version version
   @param param_name, param_type, param_descr
   @return return_var, return_type, return_description
   @example
   (examples)
   @see (links_or_references)
   /*/

User Function LOCXPE01
Local _aButton:={}
Local aEnt:={}
Local nOpcX := 0                                                  

If FwIsAdmin() .and. SuperGetMV("MV_UACTAVI",.F.,.F.) //Si perteneces al grupo de Administradores y El parámetro de aviso de PE está activado
   Aviso("MV_UACTAVI","MV_UACTAVI Activo - ProcName: "+ProcName(),{'ok'},,,,,.t.)
ENDIF

if aCfgNF[1] == 54
   _aButton := {{'bmpord1',{|| U_XLxA462TN()}, " Sol. Almacén", "  Sol. Almacén"}}
end


Return(_aButton)
