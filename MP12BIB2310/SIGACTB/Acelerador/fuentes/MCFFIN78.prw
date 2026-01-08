#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³MCFFIN78  ³ Autor ³ Totvs                ³ Data ³ 03/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Retorna valor para el asiento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Microsiga Argentina....                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

//--------------------------------------------------
// USADA EN REVERSION LINEA 576 
//-------------------------------------------------             
User Function MCFFIN78(nMoneda)

Local dDataAnt := dDatabase
Local nRet     := 0                   
Local nTxMonOri:= 0
Local nTxMonDes:= 0
Local nMoedaTit:= 0

dDatabase := SEL->EL_DTDIGIT      
nMoedaTit := VAL(SEL->EL_MOEDA)                                                                        
nValor    := ABS(SEL->EL_VALOR)
IF nMoedaTit <= 5
   nTxMonOri := IIF(nMoedaTit>1 ,&("SEL->EL_TXMOE"+STRZERO(nMoedaTit,2)),U_TraeMoneda(VAL(SEL->EL_MOEDA)))
ELSE
   nTxMonOri := U_TraeMoneda(VAL(SEL->EL_MOEDA))
ENDIF   

Do case
    
	Case nMoneda == 1
	    nRet      := (nValor  * nTxMonOri)

	Case nMoneda > 1 .and. nMoneda <= 5  
	    nTxMonDes := &("SEL->EL_TXMOE"+STRZERO(nMoneda,2))
	    nRet      := (nValor  * nTxMonOri)/ nTxMonDes

	Case nMoneda >= 6   
	    nTxMonDes := U_TraeMoneda(nMoneda)
	    nRet      := (nValor  * nTxMonOri)/ nTxMonDes

Endcase

dDatabase:=dDataAnt
Return ( nRet )   


