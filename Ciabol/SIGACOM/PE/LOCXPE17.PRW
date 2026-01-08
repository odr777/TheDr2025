#INCLUDE "RWMAKE.CH"
#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³LOCXPE17  ºAuthor ³TdeP Horeb          º Date ³  30/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada para la Validacion de las Lineas de los    º±±
±±º          ³Documentos de Entrada y Salida                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ INESCO                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION LOCXPE17
	Local nPosCOD
	Local nPosLote
	Local nPosTES
	Local nPosItem
	Local lRet := .T.

	//ALERT("LOCXPE17")

	IF alltrim(FunName()) $ "MATA102N"

		If !GdDeleted()
			nPosCOD	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_COD"})
			nPosLote	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_LOTECTL"})
			nPosTES	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_TES"})
			nPosLocal	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_LOCAL"})

			IF Posicione("SB1",1,xFilial("SB1")+aCols[n][nPosCOD],"B1_RASTRO") == 'L' .AND. Empty(aCols[n][nPosLote])
				Alert("Producto: " + AllTrim(aCols[n][nPosCOD]) + " NO tiene Asignado un Lote")
				lRet := .F.
			EndIf

		EndIf

		//NT Punto de Entrada para validar que sólo se ingrese remitos con PC
		IF  M->F1_SERIE $ "REM/CER"
			nPosPedido	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_PEDIDO'     } )
			IF empty(aCols[n][nPosPedido])
				alert("No puede ingresar Remito/Certificación sin Pedido de Compras")
				lRet := .F.
			EndIf
		EndIf

		//NT Punto de Entrada para validar que la cantidad del remitos no sea mayor que el PC
		IF  AllTrim(cEspecie) $ 'RCN/RFN'
			nPosPedido	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_PEDIDO'     } )
			nPosItemPC	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_ITEMPC'     } )
			nPosQuant  := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_QUANT'     } )
			IF !empty(aCols[n][nPosPedido])
				aSC7 := GetAdvFVal("SC7",{"C7_QUJE", "C7_QUANT"},xFilial("SC7")+aCols[n][nPosPedido]+aCols[n][nPosItemPC],1,{"",""})
				IF aCols[n][nPosQuant] > aSC7[2]-aSC7[1]
					alert("No puede ingresar cantidad mayor al saldo del Pedido de Compra")
					lRet := .F.
				Endif
			EndIf
		EndIf

		if type("cCorf") == "U"//si no existe
			//alert("Entro")
			public cCorf

			if cCorf == .f.
				If Select("VW_CORREM") > 0
					dbSelectArea("VW_CORREM")
					dbCloseArea()
				Endif

				cDoc = M->F1_DOC

				cQuery := "	SELECT count(*) DATA "
				cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
				cQuery += " WHERE F1_DOC = '" + M->F1_DOC + "' "
				cQuery += " AND F1_SERIE = '" + M->F1_SERIE + "' AND F1_FORNECE = '" + M->F1_FORNECE + "' "
				cQuery += " AND F1_ESPECIE = 'RCN' AND F1_FILIAL = '" + xfilial("SF1") + "' "

				TCQuery cQuery New Alias "VW_CORREM"

				if VW_CORREM ->DATA > 0

					M->F1_DOC = POSICIONE("SX5",1,XFILIAL("SX5")+"01"+M->F1_SERIE,"X5_DESCRI")

					alert("El numero de documento :" + cDoc + " cambio para: " + M->F1_DOC)
				else
					cCorf = .t.
				endif

				VW_CORREM ->(dbCloseArea())

			endif
		endif
	endif

	If Type("cCxCaixa")<>'U'
		iF ALLTRIM(FUNNAME())$"MATA101N" .AND. IsInCallStack("NfTudOk")
			SET->(DbSetOrder(1))
			If SET->(MsSeek(xFilial()+cCxCaixa)) .And. SET->ET_SALDO < nCxValor
				nCxValor:=0
			END
		END
	EndIf

return lRet 