#include 'protheus.ch'
#include 'parmtype.ch'

user function ExistNIT()
Local lRet:= .T.
Local aArea   := GetArea()  

DbSelectArea("SA1")
DbSetOrder(3)

If SA1->(DbSeek( xFilial("SA1") + M->A1_CGC))
	iF M->A1_CGC <> "0"
		Aviso("Atención","El NIT " + RTRIM(M->A1_CGC) + " ya existe, para el cliente: " + SA1->A1_COD+" - "+ SA1->A1_NOME,{"OK"})
		lRet:=.f.
	END
EndIf
RestArea( aArea )
Return lRet