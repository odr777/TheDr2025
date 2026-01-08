#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OS010BTN  ºAutor  ³Nicolás ºFecha ³  25/11/2019     		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada Para Agregar Botones a la rutina de Regla  º±±
±±º          ³de descuentos.											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FT080MRN()

	Local aButtons := {}
	// Local oGetdados := PARAMIXB[1]
//	Alert('Passou pelo ponto de entrada FT080MRN')
	AAdd(aButtons ,{"Importar csv", {|oModel, oView| U_Importerd(oModel, oView)}, 'Importar csv'})

return aButtons

static function testImp()
	Local nX := 0
	// busco posiciones de producto
	nPosProducto := Ascan(aHeader,{|x| AllTrim(x[2]) == "ACP_CODPRO"})
	nPosDesItem := Ascan(aHeader,{|x| AllTrim(x[2]) == "ACP_PERDES"})
	nItem := Ascan(aHeader,{|x| AllTrim(x[2]) == "ACP_ITEM"})
	/*If Len(aCols) == 1
		For nX := 1 To Len(aHeader)
			If AllTrim(aHeader[nX,2]) == "ACP_ITEM"
				Acols[Len(Acols)][nX] := "221"//StrZero(1,Len(ACP->ACP_ITEM))
			EndIf
		Next nX
	EndIf*/
//	If AllTrim(aHeader[2,2]) == "ACP_ITEM"
//		aadd(Acols,AClone(Acols[1]))
//		nItem
//		Acols[Len(Acols)][nItem] := len(Acols)
//		Acols[Len(Acols)][nPosProducto] := "000003"//StrZero(1,Len(ACP->ACP_ITEM))
//		Acols[Len(Acols)][nPosDesItem] := 10//StrZero(1,Len(ACP->ACP_ITEM))
//		aadd(Acols,AClone(Acols[1]))
//		Acols[Len(Acols)][nItem] := len(Acols)
//		Acols[Len(Acols)][nPosProducto] := "000005"//StrZero(1,Len(ACP->ACP_ITEM))
//		Acols[Len(Acols)][nPosDesItem] := 11//StrZero(1,Len(ACP->ACP_ITEM))
//	EndIf

return
