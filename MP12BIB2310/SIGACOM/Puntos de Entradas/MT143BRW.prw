#INCLUDE 'RWMAKE.CH'
//Punto de Entrada para Agregar un botón en el Browser al PC MATA120  (Pedido de Compra)

User Function MT143BRW
If FwIsAdmin() .and. SuperGetMV("MV_UACTAVI",.F.,.F.) //Si perteneces al grupo de Administradores y El parámetro de aviso de PE está activado
   Aviso("MV_UACTAVI","MV_UACTAVI Activo - ProcName: "+ProcName(),{'ok'},,,,,.t.)
ENDIF

	AADD(AROTINA, {'Impresión de Gastos Imp.',"U_RGtoImport" , 0 , 5})
	//AADD(AROTINA, {'Impresión gastos previos',"U_IMGAPREV" , 0 , 5})	
	AADD(AROTINA, {'Conocimiento', 	"MsDocument", 0, 4 } )
	//	AADD(AROTINA, {'Imp.PC Ingles',"U_MATR110I" , 0 , 5})
RETURN
