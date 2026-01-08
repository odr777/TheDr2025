#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M468NGRV  ºAutor  ³TdeP ºFecha ³  12/09/2017     			  º±±
±±º						ºOmar Delgadillo ºFecha ³26/03/2024  			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada que se ejecuta al finalizar la Venta  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIB2310                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M468NGRV()
	
	//ALERT ("M468NGRV: "+Alltrim(FunName()))

	// Nahim adicionado para generar el título en Dólares
	if SC5->C5_MOEDTIT == 2 // sólo si la moneda del título es 2
		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		nTazaMoneda := RecMoeda(dDatabase,2)
		dbSelectArea("SE1")
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+_cSerieFac+_cDoc))
		While !EOF() .And. _cDoc == SE1->E1_NUM .And. _cSerieFac == SE1->E1_PREFIXO
			nValorBascom := SE1->E1_BASCOM1
			nValE1_VLCRUZ := SE1->E1_VLCRUZ
			nValE1Valor:= SE1->E1_VALOR
			nVSaldo := SE1->E1_SALDO
			RecLock("SE1",.F.)
			
			Replace 	E1_MOEDA      With 2
			
			Replace 	E1_TXMOEDA      With nTazaMoneda
			if  SF2->F2_TXMOEDA == 1 // NT 28/03/19
				Replace 	E1_VALOR      With nValE1Valor / nTazaMoneda
				Replace 	E1_SALDO      With nVSaldo / nTazaMoneda
			else
				Replace 	E1_BASCOM1      With nValorBascom / nTazaMoneda
			endif

			MsUnlock()
			SE1->(dbSkip())
		end
		dbCloseArea()
	endif

	If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N" .OR.  Alltrim(FunName()) == "MATA461"   // Generacion de Factura de Ventas
		u_impFactura(SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_ESPECIE)
	ENDIF

	//RestArea(aArea)*/
return

