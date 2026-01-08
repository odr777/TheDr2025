

/*/{Protheus.doc} User Function ACTTS9
    Actualiza tipo de saldo 9 a 1 cuando hay diferencia de cambio
    @type  Function
    @author user
    @since 06/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ACTTS9()
Local aAreaCtb	:= GetArea()
Local cTpSaldo	:= CT2->CT2_TPSALD
Local cDebito	:= CT2->CT2_DEBITO
Local cCredito	:= CT2->CT2_CREDIT
Local nValor	:= CT2->CT2_VALOR
Local cSequen	:= CT2->CT2_SEQUEN
Local cLp		:= CT2->CT2_LP
Local cSegofi	:= CT2->CT2_SEGOFI
Local cSublote	:= CT2->CT2_SBLOTE
Local dData		:= CT2->CT2_DATA
Local cxFilial	:= CT2->CT2_FILIAL
local lCambio := .F.
nRecnoCt2 := CT2->(RECNO())// GUARDO
If ALLTRIM(cLp)== "" .AND. cTpSaldo=="9"
	dbSelectArea("CT2")
	DbSetOrder(12)
	If dbSeek(cxFilial+cSegofi+cSublote)
		// If CT2->CT2_LP == "610" 
		// 	cEsFat := "T"
		// Else
		// 	cEsFat := "F"
		// EndIf 
		
		While CT2->(!Eof()) .and. (cxFilial+cSegofi+cSublote == CT2->CT2_FILIAL+CT2->CT2_SEGOFI+CT2->CT2_SBLOTE)
			
			cTpSaldo	:= CT2->CT2_TPSALD
			cDebito		:= CT2->CT2_DEBITO
			cCredito	:= CT2->CT2_CREDIT
			nValor		:= CT2->CT2_VALOR
			cSequen		:= CT2->CT2_SEQUEN
			cLp			:= CT2->CT2_LP
			cSegofi		:= CT2->CT2_SEGOFI
			cSublote	:= CT2->CT2_SBLOTE
			dData		:= CT2->CT2_DATA
		
			
			//AVISO("Tipo de Saldo", "El tipo de saldo :"+" "+cTpSaldo, { "Aceptar" }, 1)
			//AVISO("Tipo de Saldo", "El tipo de saldo :"+" "+cSequen, { "Aceptar" }, 1)
			//AVISO("Tipo de Saldo", "El tipo de saldo :"+" "+cDebito, { "Aceptar" }, 1)
			//AVISO("VALOR", "VALOR :"+cvaltochar(transform(nValor,"99,999,999.99")), { "Aceptar" }, 1)
			
			RecLock("CT2",.F.)
				CT2->CT2_TPSALD := "1"
			CT2->(MsUnlock())
			lCambio := .t.
			dbSkip()
		EndDO
	EndIF
EndIf
if lCambio // si hace el seek
	dbgoto(nRecnoCt2)
endif

RestArea(aAreaCtb)

Return 
