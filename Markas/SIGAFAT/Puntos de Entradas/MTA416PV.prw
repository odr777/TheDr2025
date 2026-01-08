#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA416PV  ºAutor  ³Jorge Saavedra      ºFecha ³  22/06/153   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Executado apos o preenchimento do aCols na Baixa      º±±
±±º          ³ do Orcamento de Vendas.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIMA SRL                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function MTA416PV()
	Local nI 		:= PARAMIXB 
	Local nPReserva := aScan(aHeadC6,{|x| AllTrim(x[2])=="C6_RESERVA"	})
	Local nPQtdVen 	:= aScan(aHeadC6,{|x| AllTrim(x[2])=="C6_QTDVEN"	})
	Local nPQtdLib 	:= aScan(aHeadC6,{|x| AllTrim(x[2])=="C6_QTDLIB"	})
		
	_aCols[nI][nPQtdLib] 	:= _aCols[nI][nPQtdVen]
	//_aCols[nI][nPReserva] 	:= BusReserva(SCJ->CJ_NUM, SCK->CK_FILENT)
	M->C5_VEND1		:= SCJ->CJ_UVEND
	M->C5_UNOMCLI   := SCJ->CJ_XNOME 
	M->C5_XTIPDOC   := SCJ->CJ_XTIPDOC
	M->C5_UNITCLI   := SCJ->CJ_XNITCLI
	M->C5_XCLDOCI   := SCJ->CJ_XCLDOCI
	M->C5_XEMAIL	:= SCJ->CJ_XEMAIL
return
