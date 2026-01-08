#Include 'Protheus.ch'
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetProyecto  บAutor  ณTdeP  บ Data ณ  05/03/17              บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma que carga automaticamente los datos para PMS en base บฑฑ
ฑฑบ          ณal Item Contable a las rutinas de Factura de Entrada y Remitoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA102N                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function copiQuant(nPos)
Local nPosItem   := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEM"})
Local nPosProducto   := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD"})
Local nPosQtd   := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT"})
Local nPosItemCta   := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMCTA"})
Local nPosRemito   := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_REMITO"})
Local nPosTes   := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_TES"})
Local aHeaderPMS  := GetaHeader("AFN",,,,)
Local nPosTarefaPMS   := aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFN_TAREFA"})
Local nPosSTOCKPMS   := aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFN_ESTOQU"})
Local nPosQTSEGPMS   := aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFN_QTSEGU"})
Local nPosTRTPMS   := aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFN_TRT"})
Local nPosRevisionPMS   := aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFN_REVISA"})
Local nPosItemPMS   
Local aColsPMS    := {}
Local cValorCampo :=&(ReadVar())
Local cAliasPMS:=GetNextAlias()
		
		if Empty(nPos)
			nPos:=n
		End
		
		nPosItemPMS   := aScan(aRatAFN,{|x| x[1] == aCols[nPos][nPosItem]})
		IF len(aRatAFN[nPos][2]) <> 0
			aRatAFN[nPos][2][1][3] := aCols[nPos][nPosQtd]
		endif
			// SD1->D1_QUANT 
		// If FUNNAME()=='MATA101N'
		// 	If !EMPTY(aCols[nPos][nPosRemito])
		// 		RETURN cValorCampo
		// 	eND
		// End 
		
		// IF EMPTY(aCols[nPos][nPosItemCta])
		// 	If nPosItemPMS > 0
		// 		aDel(aRatAFN,1)
		// 		aSize(aRatAFN,len(aRatAFN)-1)
		// 	End
		// 	RETURN cValorCampo
		// END
		
		// If nPosItemPMS > 0
		// 	aColsPMS	:= aClone(aRatAFN[nPosItemPMS][2])
		// Else
		// nLenHeader := Len(aHeaderPMS)
		// aadd(aColsPMS,Array(nLenHeader+1))
		// For ny := 1 to nLenHeader
		// 	If Trim(aHeaderPMS[ny,2]) == "AFN_QUANT" .and. aCols[nPos][nPosQtd] <> aHeaderPMS[ny,4]
		// 		aColsPMS[ny,4] := aCols[nPos][nPosQtd] // "01"
		// 	endif
		// 	// ElseIf AllTrim(aHeaderPMS[ny,2]) $ "AFN_ALI_WT | AFN_REC_WT"
		// 	// 	If AllTrim(aHeaderPMS[ny,2]) == "AFN_ALI_WT"
		// 	// 		aColsPMS[1,ny] := "AFN"
		// 	// 	ElseIf AllTrim(aHeaderPMS[ny,2]) == "AFN_REC_WT"
		// 	// 		aColsPMS[1,ny] := 0
		// 	// 	EndIf
		// 	// Else
		// 	// 	aColsPMS[1,ny] := CriaVar(aHeaderPMS[ny,2])
		// 	// EndIf
		// 	// aColsPMS[1,nLenHeader+1] := .F.
		// Next ny
		// End		
	
// 	BeginSql Alias cAliasPMS
				
// 		SELECT  AF8_PROJET,AF9_TAREFA,AF8_REVISA FROM 
// 		%table:AF9% AF9
// 		INNER JOIN
// 		%table:AF8% AF8 
// 		ON AF9_PROJET=AF8_PROJET AND AF9_REVISA=AF8_REVISA
// 		WHERE 
// 		AF9_FILIAL = %xFilial:AF9%
// 		AND AF8_FILIAL = %xFilial:AF8%
// 		AND AF9.%NotDel%           	
// 		AND AF8.%NotDel%
// 		AND AF9_ITEMCC=%Exp:aCols[nPos][nPosItemCta]%
		
// 	EndSQL
	
	
// //	aColsPMS[1][1]:= transform((cAliasPMS)->AF8_PROJET,x3Picture("AFN_PROJET"))
// 	aColsPMS[1][1]:= (cAliasPMS)->AF8_PROJET
// 	aColsPMS[1][nPosTarefaPMS]:= (cAliasPMS)->AF9_TAREFA//transform(,x3Picture("AFN_TAREFA"))
// 	aColsPMS[1][3]:= aCols[nPos][nPosQtd]// transform(aCols[n][nPosQtd],x3Picture("AFN_QUANT"))
// 	aColsPMS[1][nPosSTOCKPMS]:= transform(1,x3Picture("AFN_ESTOQU"))
// 	aColsPMS[1][nPosQTSEGPMS]:= 0 //transform(0,x3Picture("AFN_QTSEGU"))
// 	aColsPMS[1][nPosTRTPMS]:= transform("",x3Picture("AFN_TRT"))
// 	aColsPMS[1][nPosRevisionPMS]:= transform((cAliasPMS)->AF8_REVISA,x3Picture("AFN_REVISA"))//REVISION

// 	If nPosItemPMS > 0
// 		If GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+aCols[nPos][nPosTes],1,"")=="N"
// 			aRatAFN[nPosItemPMS][2]	:= aClone(aColsPMS)
// 		else
// 			aDel(aRatAFN,1)
// 			aSize(aRatAFN,len(aRatAFN)-1)
// 		End
// 	Else
// 		If GetAdvFVal("SF4","F4_ESTOQUE",xFilial("SF4")+aCols[nPos][nPosTes],1,"")=="N"
// 			aADD(aRatAFN,{aCols[nPos][nPosItem],aColsPMS})
// 		End
// 	End

Return 
