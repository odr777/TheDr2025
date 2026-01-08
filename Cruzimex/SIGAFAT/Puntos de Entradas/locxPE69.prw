#INCLUDE "PROTHEUS.CH"

/*
08/01/2019 
PROGRAMA:	LOCXPE69
P.E. Necesario para poder utilizar el P.E. (LOCXPE35)
 
*/

User Function LOCXPE69()

//	IF FUNNAME()== "MATA465N"
//		nDescEsp := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } ) // Trae Descuento
//		aCols[Len(aCols)][nDescEsp] := SD1->D1_VALDESC//  jalar remito SD1->D1_VALDESC
//		nFacOri := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_NFORI'     } ) // Trae NCC
//		aCols[Len(aCols)][nFacOri] := SD1->D1_NFORI//  jalar remito SD1->D1_VALDESC
//		nSeriori := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_SERIORI'     } )
//		aCols[Len(aCols)][nSeriori] := SD1->D1_SERIORI//  jalar remito SD1->D1_VALDESC
//		nItemOri := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_ITEMORI'     } )
//		aCols[Len(aCols)][nItemOri] := SD1->D1_ITEMORI//  jalar remito SD1->D1_VALDESC
//	ENDIF
	//	nDescEsp := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } )
	//	aCols[1][nDescEsp] := 1234//  jalar remito SD1->D1_VALDESC
	//	aCOLS[Len(aCols)][Alltrim(aHeader[nDescEsp][2]) == "D1_VALDESC"] := SD1->D1_VALDESC
	//	aCOLS[Len(aCols)][Alltrim(aHeader[nI][2]) == "D1_VALDESC"] := SD1->D1_VALDESC
Return(.T.)