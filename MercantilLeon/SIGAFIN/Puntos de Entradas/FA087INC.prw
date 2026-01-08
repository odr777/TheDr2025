#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA087INC  ºAutor  ³EDUAR ANDIA TAPIA   ºFecha ³  03/16/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Para grabar el Banco en Cobranzas Diversas            º±±
±±º          ³ en Campo personalizado EL_UBANCO                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HP Medical                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA087INC()
/*
Local nPosBco       := AScan(aHeader,{|x|Alltrim(x[2])=="EL_BANCO"}) 
   
If !Empty(SEL->EL_BANCO)
	_cBcoDiv:=SEL->EL_BANCO
End
Reclock("SEL",.F.)
SEL->EL_UBANCO:= _cBcoDiv  
SEL->(MsUnlock())

//+-------------------------------------------------------------------------------------+
//¦ Gerar registro no SE1 se sao cheques ou pagtos sem movimentação imediata.    ¦
//+-------------------------------------------------------------------------------------+
/*
SE1->(DbSetOrder(2))
If SE1->(DbSeek(xFilial("SE1")+cCliente+cLoja+SEL->EL_PREFIXO+SEL->EL_NUMERO+;
	SEL->EL_PARCELA+SEL->EL_TIPODOC))
	RecLock("SE1",.F.)
Else
	RecLock("SE1",.T.)
Endif
SE1->E1_FILIAL := xFilial("SE1")
SE1->E1_SERREC := SEL->EL_SERIE
SE1->E1_RECIBO := SEL->EL_RECIBO
SE1->E1_PREFIXO:= SEL->EL_PREFIXO
SE1->E1_NUM    := SEL->EL_NUMERO
MsUnLock()	
*/                 
                     
//IIF(SA6->A6_UFISCAL='1','01','02')
  /*                  
Alert("E5_EL_PREFIXO : '"+SE5->E5_PREFIXO + "' / '" + SEL->EL_PREFIXO+"'")
Alert("E5_EL_NUMERO : '"+SE5->E5_NUMERO + "' / '" + SEL->EL_NUMero+"'")
Alert("Banco: '"+SEL->EL_BANCO+"'")
SA6->(DbSetOrder(1))
SA6->(DbSeek(xFilial()+SEL->(EL_BANCO+EL_AGENCIA+EL_CONTA)))
RecLock("SE1",.F.)
SE1->E1_UFISCAL := "0"+SA6->A6_UFISCAL
MsUnLock()	
RecLock("SE5",.F.)
SE5->E5_BANCO	:= "0"+SA6->A6_UFISCAL
MsUnLock()
*/
Return