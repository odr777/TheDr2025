#include "Protheus.ch"

////Bloquear desbloquear linea de credito

user function AFLCR003(cBlq) //VALOR ACTUAL DE LINEA, VLRLIN LIMITE DE LA LINEA
	if SA6->A6_BLOCKED = '1' .and. cBlq = '2' .and. MsgYesNo( "Desea desbloquear y poner vigente la línea de crédito: " + SA6->A6_NUMCON + " ? ")
		RecLock("SA6",.F.)
		SA6->A6_BLOCKED := cBlq
		MsUnLock()
		alert("Linea desbloqueada, ahora está vigente")
	else
		if SA6->A6_BLOCKED = '2' .and. cBlq = '1' .and. MsgYesNo( "Desea bloquear y poner no vigente la línea de crédito: " + SA6->A6_NUMCON + " ? ")
			RecLock("SA6",.F.)
			SA6->A6_BLOCKED := cBlq
			MsUnLock()
			alert("Linea bloqueada, ahora está no vigente")
		endif
	endif
RETURN
