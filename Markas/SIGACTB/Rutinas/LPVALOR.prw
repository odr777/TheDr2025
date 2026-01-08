#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "Totvs.ch"

#DEFINE CRLF	Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBRDIACTB  ºAutor  ³EDUAR ANDIA		º Data ³  31/01/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función para Obtener el Valor a Contabilizar para un LP	  º±±
±±º          ³                                                   		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia /Unión Agronegocios                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LPVALOR(cLP,cSeq)
Local nRet   := 0

DEFAULT cLP  := ""
DEFAULT cSeq := ""

Do Case
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos a Pagar com Rateio			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case (cLP $ "511|512")
	If Funname()$ "FINA050"
		If VALOR > 0
			nRet := VALOR
			If !Empty(cSeqCv4)
				
				If IsInCallStack("FA050Delet")
					
				Else 
					SE2->(DbSetOrder(6))
					If SE2->(DbSeek(xFilial("SE2")+M->E2_FORNECE+M->E2_LOJA+M->E2_PREFIXO+M->E2_NUM+M->E2_PARCELA+M->E2_TIPO))
					Endif
				Endif
			Endif
		Endif
	Endif
	
	If Funname()$ "CTBAFIN|FINA370"				//off-line
		If VALOR > 0
			If !Empty(CV4->CV4_SEQUEN)
				SE2->(DbSetOrder(16))
				If SE2->(DbSeek(xFilial("SE2")+CV4->CV4_FILIAL+DTOS(CV4->CV4_DTSEQ)+CV4->CV4_SEQUEN))
					nRet := VALOR
				Endif
			Endif
		Endif
	Endif
	
Case (cLP $ "XXX")
OtherWise
	nRet  := 0
EndCase

Return(nRet)