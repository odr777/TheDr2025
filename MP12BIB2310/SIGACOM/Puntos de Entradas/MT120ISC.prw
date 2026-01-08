#include 'protheus.ch'
#include 'parmtype.ch'

// trae campo importacion
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120ISC  ºAutor  ³Erick 				 º Data ³  14/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³trae campos especifico al jalar la Solicitud de compra	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIB									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT120ISC()
Local nX
If FwIsAdmin() .and. SuperGetMV("MV_UACTAVI",.F.,.F.) //Si perteneces al grupo de Administradores y El parámetro de aviso de PE está activado
   Aviso("MV_UACTAVI","MV_UACTAVI Activo - ProcName: "+ProcName(),{'ok'},,,,,.t.)
ENDIF
For nX := 1 To Len(aHeader)
		Do Case
			Case Trim(aHeader[nX][2]) == "C7_UDESCRI"
			aCols[n][nX] := SC1->C1_UDESCRI  // aCols[n][4]//Producto cod
			Case Trim(aHeader[nX][2]) == "C7_DATPRF"
			aCols[n][nX] := SC1->C1_DATPRF  // aCols[n][4]//Producto cod
		EndCase
	Next nX

return
