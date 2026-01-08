#include 'protheus.ch'
#include 'parmtype.ch'
#include "RWMAKE.CH"
#Include "FWMBROWSE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OMS460MNU  ºAutor  ³TdeP			   ºFecha ³  08/10/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Que permite adicionar aRotinas en la Pantalla de      º±±
±±º          ³ Pedido de Venta.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OM460MNU()
	//aadd(aRotina,{'Imp. Nota Venta','U_NOTAPED()' , 0 , 4,0,NIL})
	ADD OPTION aRotina TITLE "Imprimir Documentos" ACTION "U_impdocum(1)"  OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir Doc Con factura" ACTION "U_impdocum(2)"  OPERATION 1 ACCESS 0
	//	aadd(aRotina,{'Imprimir Documentos','impdocum()' , 0 , 4,0,NIL})
Return

user function impdocum(nConFactura)

	AjustaSx1()
	U_OMSRESUM()
	U_OMSDETA()
	// imprime Facturas según
	if nConFactura == 2
		cQrySE1  := GetNextAlias()
		BeginSql alias cQrySE1
			SELECT SC5VF.C5_NOTA F2_DOC, SC5VF.C5_SERIE F2_SERIE FROM %table:SF2% SF2
			LEFT JOIN %table:SD2% SD2 ON D2_DOC = F2_DOC AND SF2.F2_SERIE =SD2.D2_SERIE AND SD2.D_E_L_E_T_ = ''
			LEFT JOIN %table:SC5% SC5 ON SC5.C5_NUM = D2_PEDIDO AND SC5.D_E_L_E_T_ LIKE ''
			LEFT JOIN %table:SC5% SC5VF ON SC5.C5_UPVFUT = SC5VF.C5_NUM AND SC5VF.D_E_L_E_T_ LIKE ''
			WHERE F2_CARGA LIKE %Exp:DAK->DAK_COD% AND  SC5VF.C5_NOTA  IS NOT NULL
			GROUP BY SC5VF.C5_NOTA, SC5VF.C5_SERIE
			UNION
			SELECT SF2.F2_DOC, SF2.F2_SERIE   FROM %table:SF2% SF2
			WHERE F2_CARGA LIKE %Exp:DAK->DAK_COD% AND SF2.D_E_L_E_T_ LIKE ''
			AND SF2.F2_ESPECIE = 'NF '
		EndSql
		while (cQrySE1)->(!Eof())
			// IMPRIME DOCUMENTOS
			U_FactLocal((cQrySE1)->F2_DOC,(cQrySE1)->F2_DOC,(cQrySE1)->F2_SERIE,1)
			(cQrySE1)->(dbSkip())
		enddo
	endif
return

static Function AjustaSx1() // posiciona valores para query preguntas
	//	alert("Pasa AjustaSx1")
	//	alert(DAK->DAK_COD)
	cPerg :="OMR020"+Space(4)
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DAK->DAK_COD
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(cPerg+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DAK->DAK_COD
		SX1->(MsUnlock())
	END

return nil

