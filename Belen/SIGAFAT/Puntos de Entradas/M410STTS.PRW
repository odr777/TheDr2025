


/*/{Protheus.doc} User Function M410STTS
    Función para copiar el pedido de venta (utilizado en este caso obtiene el total.)
    @type  Function
    @author Nahim Terrazas
    @since 21/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function M410STTS()
Local _nOper := PARAMIXB[1]

If _nOper == 6 //Cópia
    nTotalPEdVis := U_GETPEDTOT(SC5->C5_NUM,SC5->C5_CLIENTE)
	RecLock("SC5",.F.)
		Replace 	C5_UTOTPED      With nTotalPEdVis
	MsUnlock()
EndIf
IF verExDv() // VERIFICA SI BLOQUEA O NO SI ES CONTADO y si existe P. V. 009
//	IF verExDv() .AND. (SC5->C5_CONDPAG $ '002|501|502' )  // VERIFICA SI BLOQUEA O NO SI ES CONTADO y si existe P. V. 009
    Replace C5_BLQ  With "1"
    Replace C5_UBLOQDE	with "Bloqueo por saldo en devolución del cliente"		// Agregando descripción de Bloqueo NTP 03/02/2020
ENDIF
Return Nil



static function verExDv()
	Local aArea    := GetArea()
	Local cNextAlias := GetNextAlias()
	local cAlmEst := SuperGetMv('MV_UALMDEV',,'DV')
	local cCliente := M->C5_CLIENTE
	local lBloquea := .F.
	BeginSQL Alias cNextAlias
		SELECT * FROM %Table:SC5% SC5 WHERE
		C5_NOTA = '' AND SC5.D_E_L_E_T_ = '' AND C5_CLIENTE LIKE %exp:M->C5_CLIENTE%
		and C5_ULOCAL LIKE  %exp:cAlmEst%
	EndSQL

	(cNextAlias)->( DbGoTop() )
	if !(cNextAlias)->(eof()) // si está vacio signfica que Ok.
		lBloquea := .T.
		//		MsgInfo("Este cliente tiene el Pedido " + (cNextAlias)->C5_NUM + " con almacén Devoluciones que no ha sido facturado" )
	endif
	(cNextAlias)->(dbCloseArea())

	RestArea(aArea)
return lBloquea
