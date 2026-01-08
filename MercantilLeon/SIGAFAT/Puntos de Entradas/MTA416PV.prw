#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA416PV ºAutor  ³Nain Terrazasº Data ³23/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada despues de Aprobacion de presupuestoº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercnatil                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA416PV
	Local lBlind:= IsBlind()//Verifica si la conexión con Protheus no posee interface de usuario
	nPosCnt		:= Ascan(_aHeader, {|x|Alltrim(x[2])=="C6_QTDVEN"})
	nPosPro		:= Ascan(_aHeader, {|x|Alltrim(x[2])=="C6_PRODUTO"})
	nPosLoc		:= Ascan(_aHeader, {|x|Alltrim(x[2])=="C6_LOCAL"})
	nPosTes		:= Ascan(_aHeader, {|x|Alltrim(x[2])=="C6_TES"})
	nGetStock   := 0
	lMostroMensaje := .f.
	for _n:=1 to Len(_aCols)
		//	cPaisLoc$"ARG|POR|EUA"
		IF !_aCols[_n][nPosTes] $ '800|501'
			//		nGetStock:= U_GetStockNeg(SCK->CK_PRODUTO, SCK->CK_LOCAL, SCK->CK_QTDVEN)
			nGetStock:= U_GetStockNeg(_aCols[_n][nPosPro], _aCols[_n][nPosLoc], _aCols[_n][nPosCnt])
			IF nGetStock <  _aCols[_n][nPosCnt] .and. SCJ->CJ_XECOMME == 'S' // caso sea ECommerce
				M->C5_DOCGER := '3'
				if !lMostroMensaje
					If(!lBlind)
						aviso("ALERTA PE:MTA416PV",_aCols[_n][nPosPro]+": Este producto NO permite Stock Negativo, Se creará el PV con Entrega Futura",{'ok'},,,,,.t.)
					EndIf
					lMostroMensaje:= .T.
				endif
			elseif nGetStock <  _aCols[_n][nPosCnt]
				if !lMostroMensaje
					If(!lBlind)
						aviso("ALERTA PE:MTA416PV",_aCols[_n][nPosPro]+": Este producto NO permite Stock Negativo, Se creará el PV con Cantidad Menor al Presupuesto",{'ok'},,,,,.t.)
					EndIf
					lMostroMensaje:= .T.
				endif
				_aCols[_n][nPosCnt] := nGetStock
			Endif
			IF nGetStock = 0 .and. SCJ->CJ_XECOMME <> 'S'// sólo si no es E-Commerce
				M->C5_CLIENTE := " "
			Endif
		EndIf
	Next

	if SCJ->CJ_XECOMME == 'S' .and.  M->C5_DOCGER =='3' // caso sea e-commerce y tenga bloque de Stock se va a generar un pedido de venta futura
		for _n:=1 to Len(_aCols)
			_aCols[_n][nPosTes] := '800' // cambia a Entrega futura.
		Next
	endif

	If(!Empty(Trim(SCJ->CJ_XTIPDOC)))
		M->C5_XTIPDOC := SCJ->CJ_XTIPDOC //Tipo Documento Identidad
	EndIf

	If(!Empty(Trim(SCJ->CJ_XEMAIL)))
		M->C5_XEMAIL := SCJ->CJ_XEMAIL //E-Mail Recepción Factura
	EndIf

	If(!Empty(Trim(SCJ->CJ_XTELCLI)))
		M->C5_XTELCLI := SCJ->CJ_XTELCLI //Número de teléfono para recepción de la factura.
	EndIf

	M->C5_NUM := u_GetNextNrPed(M->C5_CONDPAG)
Return
