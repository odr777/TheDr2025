#include 'protheus.ch'
#include 'parmtype.ch'

// trae campo importacion
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MT120ISC  ºAutor  ³Erick 				 º Data ³  14/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³trae campo solicitud de compras EN EL PC					  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIB									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT120ISC()
    Local nDdatprf := aScan(aHeader, {|x| AllTrim(x[2]) == "C7_DATPRF"})
	Local nX
	cCodNatu := SC1->C1_NATUREZ
	For nX := 1 To Len(aHeader)
		Do Case
			Case Trim(aHeader[nX][2]) == "C7_UESPECI"
			aCols[n][nX] := Posicione("SB1",1,xFilial("SB1")+  SC1->C1_PRODUTO ,"B1_ESPECIF")  //SC1->C1_UHAWB  // aCols[n][4]//Producto cod
			Case Trim(aHeader[nX][2]) == "C7_UESPEC2"
			aCols[n][nX] := Posicione("SB1",1,xFilial("SB1")+ SC1->C1_PRODUTO ,"B1_UESPEC2")//SC1->C1_UDESCRI  // aCols[n][4]//Producto cod
			Case Trim(aHeader[nX][2]) == "C7_UCODFAB"
			aCols[n][nX] := Posicione("SB1",1,xFilial("SB1")+  SC1->C1_PRODUTO ,"B1_UCODFAB")
            Case Trim(aHeader[nX][2]) == "C7_UDTPAGO"
            aCols[n][nX] := U_CLCDTPAG(cCondicao,aCols[n][nDdatprf])
            Case Trim(aHeader[nX][2]) == "C7_UDTPAG2"
            aCols[n][nX] := U_CLCDTPA2(cCondicao,aCols[n][nDdatprf])
		EndCase
	Next nX
    u_RUTFILC7()
return
