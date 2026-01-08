#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValCKPRList ºAutor  ³ERICK ETCHEVERRY	º Data ³  02/12/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función que valida que Precio de Lista no sea modificado   º±±
±±º          ³ por una valor inferior para Moneda Dolar / CK_PRUNIT       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function ValCKPRList()
	Local lRet 		:= .T.
	Local nPrcOld 	:= 0
	Local cCliTab   := M->CJ_CLIENTE
	Local cLojaTab  := M->CJ_LOJA
	Local cLisPrec  := M->CJ_TABELA
	Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="CK_PRODUTO"})
	Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="CK_PRUNIT"})
	Local nQuntC  := aScan(aHeader,{|x| AllTrim(x[2])=="CK_QTDVEN"})
	Local cReadVar 	:= ReadVar()
	Local xConteudo	:= &(cReadVar)
	Local nNewPrLis	:= 0

	If nPPrUnit > 0 // ENCONTRO UNA POSICION PARA TRAER ALGO
		nNewPrLis :=  xConteudo//TMP1->(FieldGet(nPPrUnit))//aCols[n,nPPrUnit]    ///SACA EL PRECIO NUEVO
	Endif

	nPrcOld := A415Tabela(TMP1->(FieldGet(nPProd)),cLisPrec,TMP1->(FieldGet(nQuntC)))  /////precio antiugo  PRDOUTO LISTA QUANTIDADE

	If M->CJ_MOEDA == 2
		If nNewPrLis < nPrcOld
			Aviso("ValPrList","El precio digitado no puede ser menor que la lista de precio",{"OK"})
			lRet := .F.
		EndIf
	Endif
return (lRet)