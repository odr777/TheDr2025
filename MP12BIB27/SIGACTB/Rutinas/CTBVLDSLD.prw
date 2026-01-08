#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"

#DEFINE CRLF 		Chr(13)+Chr(10)
#DEFINE MODIFICAR	4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBVldSld	    ºAutor  ³EDUAR ANDIA     º Data ³  02/01/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE valida se os saldos básicos serão atualizados na        º±±
±±º          ³ gravação da rotina Lançamentos Contábeis Automáticos.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia                                					  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBVldSld
Local _lAtSldCT7 := ParamIxb[1]
Local _lAtSldCT3 := ParamIxb[2]
Local _lAtSldCT4 := ParamIxb[3]
Local _lAtSldCTI := ParamIxb[4]
Local aArea 	 := GetArea()
Local lRet 		 := .F.
Local aAreaTMP 	 := ""

If (_lAtSldCT7 .or. _lAtSldCT3 .or. _lAtSldCT4 .or. _lAtSldCTI)
	lRet := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza a Conta Diferença (Débito vs Crédito)              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(Funname()$"CTBA211|CTBA101")
	aAreaTMP 	 := TMP->(GetArea())
	AtuCtaDif()
	RestArea(aAreaTMP)
Endif

lRet := .F.	//Falso para Actualizar el saldo de las cuentas

RestArea(aArea)
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuCtaDif 	ºAutor  ³EDUAR ANDIA    º Data ³  03/01/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que atualiza Conta de Diferença (Débito vs Crédito) º±±
±±º          ³                                                 			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia 				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuCtaDif
Local nRecTMP	:= 0
Local cCtbCenc	:= GetNewPar( "MV_CTBCENC", '' )
Local cCtbCend	:= GetNewPar( "MV_CTBCEND", cCtbCenc )
Local aRet 		:= QuebraParam(cCtbCenc)

If !Empty(cCtbCenc)
	
	dbSelectArea("TMP")
	nRecTMP := TMP->(Recno())
	dbGoTop()
	While TMP->(!Eof())
		
		If !TMP->CT2_FLAG .AND. TMP->CT2_DC <> "4"		
			//Aviso("CT105CHK","CT2_LINHA: " +TMP->CT2_LINHA +CRLF + "CT2_LP: " +TMP->CT2_LP + CRLF +"CT2_DEBITO: " +TMP->CT2_DEBITO +CRLF +"CT2_CREDIT: " + TMP->CT2_CREDIT,{"OK"})
			
			If Empty(TMP->CT2_LP)
				
				If TMP->CT2_DC $ "1|3"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Encontró registro correspondiente a Dif.Precio              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ								
					If AllTrim(TMP->CT2_DEBITO) $ aRet[1]
						aRet := QuebraParam(cCtbCend)
											
						RecLock("TMP",.F.)						
						TMP->CT2_DEBITO := aRet[1]
						/*
						TMP->CT2_CCD    := aRet[2]
						TMP->CT2_ITEMD  := aRet[3]
						TMP->CT2_CLVLDB := aRet[4]
						*/
						TMP->(MsUnLock())
					Endif
				Endif
			Endif
		Endif
		
		TMP->(dbSkip())
	EndDo
	TMP->(MsGoTo(nRecTMP))
Endif

Return
