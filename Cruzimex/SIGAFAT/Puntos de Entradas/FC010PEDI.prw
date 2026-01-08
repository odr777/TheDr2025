
#include "protheus.ch"
/*
	/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Punto E.  ¦ FC010PEDI   ¦ Autor ¦ Nahim Terrazas ¦ Data ¦ 28.11.19 	  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ P.E para agregar campos de recibo y serie en la consulta	  ¦¦¦
¦¦+de pedidos / Analisis del cliente									  +¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
	
*/

User Function FC010PEDI()
	Local aHeadAux := {}
	Local aStruAux := {}
	aAdd(aHeadAux,{"Recibo","C5_URECIBO","@!",08,0,"","","C","","V" } )
	aAdd(aStruAux,{"C5_URECIBO","C",08,0})
	aAdd(aHeadAux,{"Serie","C5_USERIE","@!",3,0,"","","C","","V" } )
	aAdd(aStruAux,{"C5_USERIE","C",3,0})
Return {aClone(aHeadAux),aClone(aStruAux)}
	