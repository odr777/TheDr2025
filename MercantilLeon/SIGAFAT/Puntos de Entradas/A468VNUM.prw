#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³A468VNUM  ºAuthor ³Erick Etcheverry	   Date ³  02/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida la serie al generar facturas						  º±±
±±º        		 	 		  	 	 	 	 	 	 	  		  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB  UNION                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function A468VNUM()
	Local lRet := PARAMIXB[2] //  Nahim Terrazas 25/05/2020
	Local aNfs := PARAMIXB[3] ///FACTURAS A GENERARSE
	Local aAreaVnum := GetArea()
	Local i
	Local j
	Local k

	///PREPARAR O GENERAR NOTA
	IF FUNNAME() $ "MATA461" .OR. FUNNAME() $ "MATA468N"

		if len(aNfs) > 0

			if !LPEDIDOS ///si esta geneRANDO DESDE REMITO entra

				MSGINFO("No se permite facturar desde un remito" , "AVISO:"  )
				RestArea(aAreaVnum)
				return .f.

			ENDif

			/*ADICION ERICK PARA VALIDAR TES AL GENERAR FACTURAS*/
			dbSelectArea("SC9")

			for i:= 1 to len(aNfs)

				j := 1
				cxFaser := alltrim(aNfs[i][3])///serie factura actual puede haber varias

				///TIENE ITEMS VARIOS?
				for j:= 1  to len(aNfs[i][2]) ///RECNOS SC9
					k := 1
					nRecnoSC9 := aNfs[i][2][j]
					SC9->(dbGoto(nRecnoSC9))

					//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
					cxTes := GetAdvFVal("SC6", "C6_TES", xFilial("SC6") +SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO ,1, "")
					cxPedido := SC9->C9_PEDIDO

					/////CAMPO TIENE ALGO
					///SI TIENE VALIDAMOS QUE LA SERIE ESTE EN LA TES

					cSerieTES = alltrim(GetAdvFVal("SF4", "F4_USERIE", xFilial("SF4") + cxTes ,1, ""))

					if EMPTY(cSerieTES)

						alert( "La TES: " + cxTes + " no tiene una serie configurada en los tipos entrada salida. Pedido: " + cxPedido)
						RestArea(aAreaVnum)
						return .f.

					else

						aSeriesTES := {}

						aSeriesTES := STRTOKARR(cSerieTES, "|")

						if len(aSeriesTES) > 0

							nPos := ASCAN(aSeriesTES, { |x| ALLTRIM(x) == ALLTRIM(cxFaser) })///vemos todas las series para esa TES

							if nPos == 0
								alert("No es permitida esta TES: " + cxTes + " para la serie: " + ALLTRIM(cxFaser) + " verificar pedido: " + cxPedido )
								RestArea(aAreaVnum)
								return .f.
							endif

						endif

					endif

				next j

			next i
		endif

	ENDIF

	RestArea(aAreaVnum)

return lRet
