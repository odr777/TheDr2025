#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPE  ³ MT410ALT ºAutor  			  									  º±±
±±						   Nahim Terrazas 	 Fecha    29/04/19			  ¹±±
±±ºDesc.     ³ Verifica si un pedido de venta tiene 		  			  º±±
±±ºDesc.     ³ un pedido de venta en el almacén devoluciones			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function verExDv()
	Local aArea    := GetArea()
	Local cNextAlias := GetNextAlias()
	local cAlmEst := SuperGetMv('MV_UALMDEV',,'DV')
	local cCliente := M->C5_CLIENTE
	BeginSQL Alias cNextAlias
		SELECT * FROM %Table:SC5% SC5 WHERE
		C5_NOTA = '' AND SC5.D_E_L_E_T_ = '' AND C5_CLIENTE LIKE %exp:M->C5_CLIENTE%
		and C5_ULOCAL LIKE  %exp:cAlmEst%
	EndSQL

	(cNextAlias)->( DbGoTop() )
	if !(cNextAlias)->(eof()) // si está vacio signfica que Ok.
		MsgInfo("Este cliente tiene el Pedido " + (cNextAlias)->C5_NUM + " con almacén Devoluciones que no ha sido facturado" )
	endif
	(cNextAlias)->(dbCloseArea())

	RestArea(aArea)
return cCliente
