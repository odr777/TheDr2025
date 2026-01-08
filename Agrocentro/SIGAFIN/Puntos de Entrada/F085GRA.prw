#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  F085GRA   บ Autor ณ Erick etcheverryบ Fecha ณ  11/04/17      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescripcion ณ Punto de Entrada que ejecuta al momento realizar la Ordenบฑฑ
ฑฑบ          ณ  de Pago - con la Opcion Pago Automatico                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณBIB                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER Function F085GRA
	Local aArea    := GetArea()

	If type("cGlosaCon") <> "U"
		SEK->(DbSetOrder(1))
		If SEK->(DbSeek(xFilial("SEK")+cOrdPago,.F.))
			while !EOF() .AND. SEK->EK_FILIAL == xFilial("SEK") .AND. SEK->EK_ORDPAGO == cOrdPago
				Reclock("SEK",.F.)
				EK_UGLOSA := cGlosaCon
				MsUnlock()
				SEK->(DBSkip())
			enddo
			saveGlSE5(cOrdPago)
		EndIf
	EndIf

	//Borra Glosa
	if type("cGlosaCon") <> "U"
		cGlosaCon := NIL
		FreeObj(cGlosaCon)
	endif

	RestArea( aArea )

Return

/**
* @author: Denar Terrazas Parada
* @since: 01/08/2022
* @description: Funci๓n que graba la glosa en la tabla SE5
*/
Static Function saveGlSE5(cOrdPago)
	Local aArea     := GetArea()
	Local CTIPPAGO  := "P"//Indica que es un pago(P)
	Local cProctra	:= ""

	DbSelectArea("SE5")
	SE5->( DbSetOrder(8) )//E5_FILIAL+E5_ORDREC+E5_SERREC
	If(SE5->( DbSeek(xFilial("SE5") + cOrdPago) ))
		While !EOF() .AND. SE5->E5_FILIAL == xFilial("SEK") .AND. SE5->E5_ORDREC == cOrdPago
			If( TRIM(SE5->E5_RECPAG) == CTIPPAGO )//Si es pago
				Reclock("SE5",.F.)
				E5_UGLOSA := cGlosaCon
				MsUnlock()
				iif (Empty(SE5->E5_PROCTRA),,cProctra:=SE5->E5_PROCTRA)
			EndIf
			SE5->(DBSkip())
		Enddo

		iif (Empty(cProctra),,SaveGlITF(cProctra)) // VERIFICA LOS ITF  
		
	EndIf
	SE5->(DbCloseArea())

	RestArea( aArea )
Return

Static Function SaveGlITF(cProcTra)
	Local aArea     := GetArea()
	cUpdate := "UPDATE " + "SE5010" + " SET " + "E5_UGLOSA" + " = '" + cGlosaCon + "' WHERE E5_PROCTRA = '" + cProcTra + "'AND E5_BANCO= '" + cBanco + "' AND E5_AGENCIA= '" + cAgencia + "' AND E5_CONTA= '" + cConta + "'AND E5_TIPODOC='IT' AND D_E_L_E_T_='' "    						
	If TcSqlExec(cUpdate) < 0 
		//conout("ERRO AO ATUALIZAR:["+cUpdate+']')
		aLERT ('No actualizo Glosa ITF')
	EndIf


	RestArea( aArea )
Return
