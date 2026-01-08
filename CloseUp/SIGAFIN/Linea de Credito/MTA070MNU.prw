#include "Protheus.ch"

user function MTA070MNU()

// AADD(aRotina,{"Añadir Activo x LC", {||ExecBlock("AFLCR001",.F.,.F.)},0,2,0,.F.})   //"IncluirActivoxLC"

AADD(aRotina,{"Incluir Activo x LC", "U_AFLCR001",0,2,0,.T.})   //"IncluirActivoxLC"/
AADD(aRotina,{"Retirar Activo de LC", "U_AFLCR002",0,2,0,.F.})   //"ExcluirActivoxLC" 
AADD(aRotina,{"Visualizar Activos de LC", "U_AFLCR004",0,2,0,.F.})   //"VisualizarActivoxLC" 
AADD(aRotina,{"Habilitar LC", "U_AFLCR003('2')",0,2,0,.F.} )    //"Habilitar LC"
AADD(aRotina,{"Bloquear LC", "U_AFLCR003('1')",0,2,0,.F.} )    //"Bloquear LC"
AADD(aRotina,{"Imprimir Linea", "U_IMPLINC",0,2,0,.F.} )
AADD(aRotina,{"Imprimir Garantias", "U_IMPGARA",0,2,0,.F.} )
return