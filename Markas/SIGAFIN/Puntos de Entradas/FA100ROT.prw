#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³FA100ROT  ºAuthor ³Erick etcheverry    º Date ³  12/17/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Añade boton al menu de movimientos bancarios		          ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ BASE BOLIVIA                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FA100ROT()
	Local aRotina 	:= aClone(PARAMIXB[1])
	//Local lTrfMoe	:= GetNewPar("MV_XTRFCX",.T.)
	Local nPosTra 	:= 0
	Local nPosEst 	:= 0

	/*nPosTra := aScan(aRotina,{|x| Upper(AllTrim(x[2])) == "FA100TRAN"})
	nPosEst := aScan(aRotina,{|x| Upper(AllTrim(x[2])) == "FA100EST"})
	If nPosTra > 0
	aRotina[nPosTra,1] := "Transferencia Bancaria"
	aRotina[nPosTra,2] := "U_xfa100tran()"
	Endif
	If nPosEst > 0
	aRotina[nPosEst,1] := "Reversión de Transferencia"
	aRotina[nPosEst,2] := "U_xfa100Est()"
	Endif*/
	Aadd(aRotina,{"Impresion","u_impMvBNK()", 0 , 2, ,.F.})

return (aRotina)

user function impMvBNK()
	if SE5->E5_TIPODOC $ 'TR'//Es transferencia
		U_CTRANSFA(SE5->E5_PROCTRA)
	ELSE
		if !empty(SE5->E5_DOCUMEN)
			IF !empty(E5_VENCTO)
				U_UCIFIN01(SE5->E5_DOCUMEN)
			else
				AVISO("Cobro/Pago sin NUMERO DE DOCUMENTO", "Revise el campo E5_DOCUMEN", { "Cerrar" }, 1)
			endif
		else
			AVISO("Cobro/Pago sin NUMERO DE DOCUMENTO", "Revise el campo E5_DOCUMEN", { "Cerrar" }, 1)

		endif
	ENDIF
return