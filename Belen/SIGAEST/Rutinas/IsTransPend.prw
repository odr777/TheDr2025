#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ISTRANSPENDºAutor  ³EDUAR ANDIA TAPIA  ºFecha ³  05/19/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función boleana que verifica si el documento SF2 es una    º±±
±±º          ³ Transferencia de Salida Pendiente                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IsTransPend
Local lRet	:= .F.
Local _aArea :=	GetArea()
cFilial	:=	F2_FILIAL
cDoc	:=	F2_DOC
cSerie	:=	F2_SERIE
cCliente:=	F2_CLIENTE
cLoja	:=	F2_LOJA
cEspecie:=	F2_ESPECIE

SD2->(DbSetOrder(3))
If SD2->(DbSeek(cFilial+cDoc+cSerie+cCliente+cLoja))
	While SD2->(!EOF()) .AND. SD2->D2_FILIAL== cFilial .AND. SD2->D2_DOC == cDoc .AND. SD2->D2_SERIE == cSerie .AND. SD2->D2_CLIENTE==cCliente .AND. SD2->D2_LOJA==cLoja 
		If SD2->D2_TIPODOC == '54' .AND. SD2->D2_QTDAFAT > 0.AND. SD2->D2_ESPECIE == cEspecie
			lRet	:= .T.
			Exit		
		Endif
	SD2->(DbSkip())
	End
Endif
RestArea(_aArea) 	

Return(lRet)