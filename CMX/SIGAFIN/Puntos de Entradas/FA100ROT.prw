#Include "Protheus.ch"
#Include "Rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA100ROT  ºAutor  ³EDUAR ANDIA		º Data ³  20/03/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE adiciona novas rotinas no Browse de Mov.Bancario 		  º±±
±±º          ³ Contables                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLIVIA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA100ROT
Local aRotina 	:= aClone(PARAMIXB[1])
Local lTrfMoe	:= GetNewPar("MV_XTRFCX",.T.)
Local nPosTra 	:= 0
Local nPosEst 	:= 0

If lTrfMoe
	nPosTra := aScan(aRotina,{|x| Upper(AllTrim(x[2])) == "FA100TRAN"})
	nPosEst := aScan(aRotina,{|x| Upper(AllTrim(x[2])) == "FA100EST"})
	If nPosTra > 0
		aRotina[nPosTra,1] := "Transferencia Bancaria"
		aRotina[nPosTra,2] := "U_xfa100tran()"
	Endif
//	If nPosEst > 0
//		aRotina[nPosEst,1] := "Reversión de Transferencia"
//		aRotina[nPosEst,2] := "U_xfa100Est()"
//	Endif	
	Aadd(aRotina,{"Legenda","F100Legenda", 0 , 2, ,.F.})
	Aadd(aRotina,{"Calculo Manual ITF","U_calmanITF()", 0 , 2, ,.F.})
	Aadd(aRotina,{"Reversión Manual ITF","U_desmanITF()", 0 , 2, ,.F.})
Endif

Return(aRotina)