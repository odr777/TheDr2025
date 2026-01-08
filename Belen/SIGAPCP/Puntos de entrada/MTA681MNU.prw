#include 'protheus.ch'
#include 'parmtype.ch'
#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410MNU  ºAutor  ³TdeP			   ºFecha ³  08/10/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Que permite adicionar aRotinas en la Pantalla de      º±±
±±º          ³ Pedido de Venta.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA681MNU()
	aadd(aRotina,{'Imprimir Etiqueta','U_buscaSA3()' , 0 , 2,0,NIL})
Return

user function buscaSA3()
	lEnconSD3 := .F.
	aAreaSDB := SDB->(GetArea())
	aAreaSDA := SDA->(GetArea())
	aAreaSD3 := SD3->(GetArea())
	aArea := GetArea("SDB")
	dbSelectArea("SD3")
	dbSetOrder(1)
	dbSeek(xFilial("SD3")+SH6->H6_OP+SH6->H6_PRODUTO)

	While SD3->(!EOF()) .And. xFilial("SD3")+SH6->(H6_OP+H6_PRODUTO) == SD3->(D3_FILIAL+D3_OP+D3_COD)
		If SD3->D3_IDENT == SH6->H6_IDENT .And. SD3->D3_CF == "PR0" .And. SD3->D3_ESTORNO <> "S"
			//			GravaSBC(SH6->H6_OP,SH6->H6_OPERAC,SH6->H6_RECURSO,"MATA680",SD3->D3_NUMSEQ,SH6->H6_IDENT)
			lEnconSD3 := .T.
			Exit
		EndIf
		SD3->(dbSkip())
	EndDo
	if lEnconSD3 // Encuentra movimiento en la SD3
		dbSelectArea('SDB')
		dbSetOrder(1)
		if DbSeek(xFilial("SDB")+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_NUMSEQ+SD3->D3_DOC)
			U_T50CODBAR(SDB->DB_NUMSERI)

		else

			alert("Producto no ubicado. (favor realizar la ubicación del mismo)")
			dbSelectArea('SDA')
			dbSetOrder(1)
			if DbSeek(xFilial("SDA")+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_NUMSEQ+SD3->D3_DOC)
				ALERT("LOCALIZANDO")
				cProduto := SD3->D3_COD
				cNumseq := SD3->D3_NUMSEQ
				cSerieCorr := U_CORSERUN()
				//				cSerieCorr := "PI200000071"
				nQtapun2 := SDA->DA_QTDORI2
				//u_XMATA265(cProduto,cNumseq,"A",cSerieCorr,1,nQtapun2)
				u_XMATA265(SD3->D3_COD,SD3->D3_NUMSEQ,"A",U_CORSERUN(),SDA->DA_QTDORI,SDA->DA_QTDORI2,SDA->DA_LOCAL)
			endif
		endif
	else // no encuentra el movimiento
		alert("no se encontró movimiento en la SD3")
	endif
	RestArea(aAreaSDB)
	RestArea(aAreaSDA)
	RestArea(aAreaSD3)

return

