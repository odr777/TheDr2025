#include 'rwmake.ch'


USER FUNCTION MT113GET
If FwIsAdmin() .and. SuperGetMV("MV_UACTAVI",.F.,.F.) //Si perteneces al grupo de Administradores y El parámetro de aviso de PE está activado
   Aviso("MV_UACTAVI","MV_UACTAVI Activo - ProcName: "+ProcName(),{'ok'},,,,,.t.)
ENDIF
nMoedaSI:=2
RETURN
