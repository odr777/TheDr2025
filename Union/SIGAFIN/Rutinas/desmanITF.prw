#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.CH"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ calcmanITF    ¦ Autor ¦ Nahim Terrazas   ¦ Data ¦ 13.06.19 ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Calculo manual ITF (reversion)										  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
user function desmanITF()
	Local cArquivo
	local aAreaBuscar := SE5->(getArea())
	Private cLote := "FINANC"
	lDigita   := .T.
	nBaseITF := 0
	cPadrao := "56A"
	dbSelectArea("SA6")
	dbSetOrder(1)
	dbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
	//	!empty(SE5->E5_PROCTRA)
	//	if SE5->E5_TIPODOC == 'VL' //.and. !empty(SE5->E5_PROCTRA) // caso sólo sea moneda 1 (moneda 2 se realiza en la transferencia)
	//		pergunte("FINA100ITF",.T.)
	// si quiero calcular el ITF debería dividirlo por 0.003
	//		nBaseITF := MV_PAR01 / 0.003
	if MSGYESNO( "Confirmar la reversión del ITF de " + cvaltochar(MV_PAR01) , "Confirmar la transacción"  )
		nHdlPrv := HeadProva( cLote,;
		"FINA100" /*cPrograma*/,;
		Substr( cUsuario, 7, 6 ),;
		@cArquivo )
		FinProcITF( SE5->( Recno() ),5,nBaseITF, .T.,{nHdlPrv,cPadrao,"FINA100","FINA100",cLote},  )
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.) // Essa e a funcao do quadro dos lancamentos.
	ENDIF
	//	else
	//		alert("el ITF ya fue registrado")
	//	endif
	dbclosearea("SA6")
	restArea(aAreaBuscar)
	
return