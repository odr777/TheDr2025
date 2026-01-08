//Bibliotecas
#Include "Protheus.ch"
#Include "TopCOnn.ch"

/*-----------------------------------------------------------------------------------*
| P.E.:  A650ADCOL                                                                  |
| Desc:  Função que exclui linha da tela de componentes da OP                       |
| Nahim Terrazas - P.E Utilizado para modificar el almacén a la hora de hacer la Or.|
| de Producción 13/05/2019															|
| Link:  http://tdn.totvs.com/display/public/mp/A650ADCOL+-+Gera+empenhos+de+SC%27s |
*-----------------------------------------------------------------------------------*/

User Function A650ADCOL()
	Local aArea    := GetArea()
	//	Local aAreaB1  := SB1->(GetArea())
	Local nLinAtu  := Len(aCols)
	Local cCodProd := SG1->G1_COMP //ParamIXB[1]
	nPosLocal  :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL"})
	//Se for uma linha válida
	If nLinAtu > 0
		//        DbSelectArea('SB1')
		//        SB1->(DbSetOrder(1))
		
		//Posiciona no Produto
		If SB1->(DbSeek(FWxFilial('SB1') + cCodProd))
			If !empty(SB1->B1_ULOCOMP)// == 'XXX'
				//Marca a linha como excluída
				//                aSav650[3]
				aCols[nLinAtu][nPosLocal] := SB1->B1_ULOCOMP //SC2->C2_LOCAL //aSav650[3]//c[nLinAtu,4]// .T.
			EndIf
		EndIf
	EndIf

	//	RestArea(aAreaB1)
	RestArea(aArea)
Return