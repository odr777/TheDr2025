#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³DELCCH	  ºAuthor ³Erick Etcheverry	   Date ³  02/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Borra factura con reposicion CCH							  º±±
±±º        		 	 		  	 	 	 	 	 	 	  		  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB  AGROCENTRO                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DELCCH
	Local aAreaAnt := GetArea()
	Local ddAnt
	Local cxFornec := SF1->F1_FORNECE
	Local cxSerie := SF1->F1_SERIE
	Local cxLoja := SF1->F1_LOJA
	Local cxDoc := SF1->F1_DOC
	Local lXret := .t.

	If upper(SF1->F1_SERIE)=='CCH'

		if MsgYesNo("Esta seguro que desea borrar el documento de caja chica?","DELCCH")

			DbSelectArea("SEU")
			DbSetOrder(7)
			IF MsSeek(xFilial("SEU")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)
				SET->(dbSetOrder(1))
				SET->(MsSeek(xFilial("SET")+SEU->EU_CAIXA))

				IF SET->ET_SITUAC == "1"
					alert("Caja actualmente cerrada, no se realizara el borrado del documento - DELCCH")
					lXret = .f.
				ELSEIf !Empty(SEU->EU_BAIXA) .or. SEU->EU_BAIXA <> Ctod("//") ///si esta bajado que no este

					///VERIFICAMOS PARA NO SOBREPASAR EL VALOR DE LA CAJA CHICA
					nxSaldoCaixa := SET->ET_SALDO   ///SALDO ACTUAL CAIXINHA
					nxVlMovCaixa := SEU->EU_VALOR   ///VALOR DEL MOVIMIENTO DE LA CAJA
					nxValorCaixa := SET->ET_VALOR   ///VALOR MAXIMO CAJA CHICA
					ddAnt := SEU->EU_BAIXA

					IF nxSaldoCaixa+nxVlMovCaixa > nxValorCaixa
						alert("Se sobrepasara el valor de la caja chica, no se borrara el documento - DELCCH")
						lXret = .f.
					else
						/////PREGUNTAR SI NO TIENE UN CIERRE ET SITUAC   == 1     cerrado
						if !fnLfechado(SEU->EU_CAIXA,SEU->EU_DTDIGIT)

							RecLock( "SEU", .F. )
							SEU->EU_BAIXA := Ctod("//")
							MsUnLock()

							//borramos la factura con la CCH
							LocxDlgNF(aCfgNF,4)
						else
							alert("Hay un cierre posterior a la fecha del movimiento, no se podra borrar el documento - DELCCH")
							lXret = .f.
						endif
					endif

				endif

			else
				alert("Caja chica del documento no encontrado - DELCCH")
				lXret = .f.

			endif
		else
			alert("No es un documento de caja chica - DELCCH")
			lXret = .f.
		endif
	endif

	///si no borro
	if lXret
		IF !empty(Posicione("SF1",1,xFilial("SF1")+cxDoc+cxSerie+cxFornec+cxLoja,"F1_DOC"))
			DbSelectArea("SEU")
			DbSetOrder(7)
			IF MsSeek(xFilial("SEU")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE)
				SET->(dbSetOrder(1))
				SET->(MsSeek(xFilial("SET")+SEU->EU_CAIXA))
				RecLock( "SEU", .F. /*lInclui*/ )
				SEU->EU_BAIXA := ddAnt
				MsUnLock()
				alert("Se anulo el borrado del documento - DELCCH")
			ENDIF
		else
			MSGINFO("Se borro correctamente el documento, favor verificar siempre el saldo de la caja chica" , "AVISO DELCCH"  )
		endif
	endif

	RestArea( aAreaAnt)

Return .t.

static function fnLfechado(cxCaixa,dxDigit)
	Local cQuery	:= ""
	Local lRet := .f.
	Local aArea  := GetArea()

	If Select("VW_DTEMB") > 0
		dbSelectArea("VW_DTEMB")
		dbCloseArea()
	Endif

/*
SELECT TOP 1 R_E_C_N_O_ FROM SEU010
WHERE EU_FILIAL = '0000'
AND EU_CAIXA = 'C02'
AND EU_TIPO = '11'
AND upper(EU_HISTOR) LIKE '%DEVOLU%'
AND EU_BAIXA <> ' ' 
AND EU_DTDIGIT >= '20230400'
AND D_E_L_E_T_ = ' '
ORDER BY EU_DTDIGIT
 */


	cQuery := "	SELECT TOP 1 R_E_C_N_O_ "
	cQuery += " FROM " + RetSqlName("SEU") + " SEU "
	cQuery += " WHERE "
	cQuery += " EU_FILIAL = '" + xFilial("SEU") + "' "
	cQuery += " AND EU_CAIXA = '"+cxCaixa+"' "
	cQuery += " AND EU_TIPO = '11' AND EU_BAIXA <> ' ' AND D_E_L_E_T_ = ' ' "
	cQuery += " AND upper(EU_HISTOR) LIKE '%DEVOLU%' "
	cQuery += " AND EU_DTDIGIT >= '"+DTOS(dxDigit)+"' "
	cQuery += " ORDER BY EU_DTDIGIT "

	TCQuery cQuery New Alias "VW_DTEMB"

	if !VW_DTEMB->(EoF())
		lRet := .t.
	endif

	VW_DTEMB->(DbCloseArea())
	RestArea(aArea)

return lRet

