#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLOCXPE35.PRW.บAutor  ณNain Terrazas-TdeP    บFecha ณ16/05/13บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE para obtener Descripcion 								   ฑฑ
ฑฑ del producto en una Factura de Entrada, desde el remito a la factura    ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LOCXPE35()

Local aArea := GetArea()
Local nPosDESC := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_UDESC"})
Local nPosCOD := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
Local nPosTes := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})
Local nPosPerDes := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_DESC"})
Local nPosValDes := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_VALDESC"})
Local nPosItem := N
Local lN := 1

If alltrim(Funname()) == "MATA101N" .and. nPosItem <> 0
	Do while lN <= Len(aCols)
		_cProd:= aCols[lN][nPosCOD]//CODIGO PRODUCTO
		_cDesc	:= Posicione("SB1",1,xFilial("SB1")+ _cProd,"B1_DESC")
		aCols[lN][nPosDesc] := _cDesc
		if aCols[lN][nPosTes] $ "220" //tes es consignacion?
			aCols[lN][nPosPerDes] := 0
			aCols[lN][nPosValDes] := 0
		endif
		
		lN++
	Enddo
Endif

RestArea(aArea)
return