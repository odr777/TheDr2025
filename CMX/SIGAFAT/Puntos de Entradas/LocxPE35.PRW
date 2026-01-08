#INCLUDE "PROTHEUS.CH"

/*
08/01/2019 


PROGRAMA:	LOCXPE35
Nahim Terrazas

Punto de entrada que permite obtener campos desde el remito a la NCC al jalarlo

*/

User Function LOCXPE35()
	//	ALERT("LOCXPE35")
	IF FUNNAME()== "MATA465N"
		nDescEsp := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } ) // Trae Descuento
		aCols[Len(aCols)][nDescEsp] := SD1->D1_VALDESC//  jalar remito SD1->D1_VALDESC
		nFacOri := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_NFORI'     } ) // Trae NCC
		aCols[Len(aCols)][nFacOri] := SD1->D1_NFORI//  jalar remito SD1->D1_VALDESC
		nSeriori := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_SERIORI'     } )
		aCols[Len(aCols)][nSeriori] := SD1->D1_SERIORI//  jalar remito SD1->D1_VALDESC
		nItemOri := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_ITEMORI'     } )
		aCols[Len(aCols)][nItemOri] := SD1->D1_ITEMORI//  jalar remito SD1->D1_VALDESC
	ENDIF
	//	aCOLS[Len(aCols)][Alltrim(aHeader[nDescEsp][2]) == "D1_VALDESC"] := SD1->D1_VALDESC
	//	aCOLS[Len(aCols)][Alltrim(aHeader[nI][2]) == "D1_VALDESC"] := SD1->D1_VALDESC
Return(.T.)