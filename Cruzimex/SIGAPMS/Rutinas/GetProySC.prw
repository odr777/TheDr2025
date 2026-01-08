#Include 'Protheus.ch'
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetProyectoSC  ºAutor  ³TdeP  º Data ³           05/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que carga automaticamente los datos para PMS en base º±±
±±º          ³al Item Contable a la Rutina Solicitud de Compras           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA110 Disparador C1_ITEMCTA                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetProySC
Local nPosItem   	:= aScan(aHeader,	{|x| Alltrim(x[2]) == "C1_ITEM"		})
Local nPosProducto  := aScan(aHeader,	{|x| Alltrim(x[2]) == "C1_PRODUTO"	})
Local nPosQtd   	:= aScan(aHeader,	{|x| Alltrim(x[2]) == "C1_QUANT"	})
Local nPosItemCta   := aScan(aHeader,	{|x| Alltrim(x[2]) == "C1_ITEMCTA"	})
Local aHeaderPMS  	:= GetaHeader("AFG",,,,,.T.)
Local nPosTarefaPMS := aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFG_TAREFA"	})
Local nPosQTSEGPMS  := aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFG_QTSEGU"	})
Local nPosTRTPMS   	:= aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFG_TRT"		})
Local nPosAlias   	:= aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFG_ALI_WT"	})
Local nPosRecno   	:= aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFG_REC_WT"	})

Local nPosRevisionPMS   := aScan(aHeaderPMS,{|x| Alltrim(x[2]) == "AFG_REVISA"})
Local nPosItemPMS   
Local aColsPMS    	:= {}
Local cValorCampo 	:= &(ReadVar())
Local cAliasPMS		:= GetNextAlias()
Local nPos			:= n
local ny
	
		
		nPosItemPMS   := aScan(aRatAFG,{|x| x[1] == aCols[nPos][nPosItem]})

		/*
		IF EMPTY(aCols[nPos][nPosItemCta]) .AND. .F.	//EDUAR 03/06/2014
			If nPosItemPMS > 0
				aADD(aRatAFG,{aCols[nPos][nPosItem], aClone(aColsPMS)})				
				aDel(aRatAFG,1)
				aSize(aRatAFG,len(aRatAFG)-1)
			Endif
			Return cValorCampo
		END
        */
		If nPosItemPMS > 0
			aColsPMS	:= aClone(aRatAFG[nPosItemPMS][2])
		Else
			nLenHeader := Len(aHeaderPMS)
			aadd(aColsPMS,Array(nLenHeader+1))
			For ny := 1 to nLenHeader
				If Trim(aHeaderPMS[ny,2]) == "AFG_ITEM"
					aColsPMS[1,ny] := "01"
				ElseIf AllTrim(aHeaderPMS[ny,2]) $ "AFG_ALI_WT | AFG_REC_WT"
					If AllTrim(aHeaderPMS[ny,2]) == "AFG_ALI_WT"
						aColsPMS[1,ny] := "AFG"
					ElseIf AllTrim(aHeaderPMS[ny,2]) == "AFG_REC_WT"
						aColsPMS[1,ny] := 0
					EndIf
				Else
					aColsPMS[1,ny] := CriaVar(aHeaderPMS[ny,2])
				EndIf
				aColsPMS[1,nLenHeader+1] := .F.
			Next ny
		End		

	BeginSql Alias cAliasPMS
				
		SELECT  AF8_PROJET,AF9_TAREFA,AF8_REVISA FROM 
		%table:AF9% AF9
		INNER JOIN
		%table:AF8% AF8 
		ON AF9_PROJET=AF8_PROJET AND AF9_REVISA=AF8_REVISA
		WHERE 
		AF9_FILIAL = %xFilial:AF9%
		AND AF8_FILIAL = %xFilial:AF8%
		AND AF9.%NotDel%           	
		AND AF8.%NotDel%
		AND AF9_ITEMCC=%Exp:aCols[nPos][nPosItemCta]%
		
	EndSQL	

//cQuery:=GetLastQuery()
//aviso("",cQuery[2],{'ok'},,,,,.t.)
//MemoWrite("\query_ctxcbxcl.sql",cQuery[2])
	
	//EDUAR 04/06/2014
	If Empty(aCols[nPos][nPosItemCta])		
		nxPosAFG  := Ascan(aRatAFG,{|x|x[1]==aCols[n][nPosItem]})
		If nxPosAFG > 0 
			aColsPMS[1][Len(aHeaderPMS)+1] := .T.	//Apagar item
		Endif
	Else
		If aColsPMS[1][Len(aHeaderPMS)+1]
			aColsPMS[1][Len(aHeaderPMS)+1] := .F.  //Habilitando o item apagado
		Endif
//		Alert('GetProySC->'+(cAliasPMS)->AF8_PROJET)
		aColsPMS[1][1]				:= (cAliasPMS)->AF8_PROJET
		//aColsPMS[1][1]				:= Transform((cAliasPMS)->AF8_PROJET,x3Picture("AFG_PROJET"))
		aColsPMS[1][nPosTarefaPMS]	:= (cAliasPMS)->AF9_TAREFA//transform(,x3Picture("AFN_TAREFA"))
		aColsPMS[1][3]				:= aCols[nPos][nPosQtd]// transform(aCols[n][nPosQtd],x3Picture("AFN_QUANT"))
		//aColsPMS[1][nPosSTOCKPMS]	:= Transform(1,x3Picture("AFG_ESTOQU"))
		aColsPMS[1][nPosQTSEGPMS]	:= 0 //transform(0,x3Picture("AFN_QTSEGU"))
		aColsPMS[1][nPosTRTPMS]		:= Transform("",x3Picture("AFG_TRT"))
		aColsPMS[1][nPosRevisionPMS]:= Transform((cAliasPMS)->AF8_REVISA,x3Picture("AFG_REVISA"))//REVISION
	Endif
	
	If nPosItemPMS > 0
		aRatAFG[nPosItemPMS][2]	:= aClone(aColsPMS)
	Else
		aADD(aRatAFG,{aCols[nPos][nPosItem], aClone(aColsPMS)})
	End

Return cValorCampo