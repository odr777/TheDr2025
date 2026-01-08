#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F50PERGUNT  ºAutor  ³EDUAR ANDIA		  º Data ³ 24/06/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Configuração de perguntes via ExecAuto    º±±
±±º          ³ (Rotina FINA050)                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolívia\ ECCI S.r.l.                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F50PERGUNT()
Local aArea 	:= GetArea()
Local nPosTp	:= 0
Local cTipo		:= ""
// Local cProvImp	:= GetNewPar("MV_XPRIVA","00000301")	//Fornecedor+Loja
Local cProvImp	:= GetNewPar("MV_XPRIVA","00000100")	//Fornecedor+Loja IVA
Local cProvIT	:= GetNewPar("MV_XPRIT","00000101")	//Fornecedor+Loja IT
Local cProvITR	:= GetNewPar("MV_XPRITR","00000102")	//Fornecedor+Loja ITR
Local cProvIUR	:= GetNewPar("MV_XPRIUER","00000103")	//Fornecedor+Loja IUE Retenciones
Local nPosProv	:= 0
Local nPosLoja	:= 0
Local nPosHist	:= 0
Local XSTR001	:= "Formulario incorrecto."

If Len(aAutoCab) > 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Modificando Título a Pagar (FISA032) 		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(Funname()) $ "FISA032"

		// Define Tipo = NF
		If (nPosTp := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_TIPO"})) > 0 .And. !Empty(aAutocab[nPosTp,2])
			cTipo := If(ValType(aAutocab[nPosTp,2]) == "C", aAutocab[nPosTp,2], "")			
			aAutocab[nPosTp,2] := "NF "		//Tipo			
		EndIf
		
		//Define Fornecedor+Loja
		Do Case
			Case nXForms == 1		//Fornecedor+Loja IVA
				If !Empty(cProvImp)
					SA2->(DbSetOrder(1))
					If SA2->(DbSeek(xFilial("SA2")+cProvImp))
						If (nPosProv := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_FORNECE"})) > 0 .And. !Empty(aAutocab[nPosProv,2])
							aAutocab[nPosProv,2] := SubStr(	cProvImp,1,TamSX3('A2_COD')[1])							//Fornecedor
						EndIf
						If (nPosLoja := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_LOJA"})) > 0 .And. !Empty(aAutocab[nPosLoja,2])
							aAutocab[nPosLoja,2] := SubStr(	cProvImp,TamSX3('A2_COD')[1]+1,TamSX3('A2_LOJA')[1])	//Loja
						EndIf
					Endif
				Endif

			Case nXForms == 2		//Fornecedor+Loja IT
				If !Empty(cProvIT)
					SA2->(DbSetOrder(1))
					If SA2->(DbSeek(xFilial("SA2")+cProvIT))
						If (nPosProv := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_FORNECE"})) > 0 .And. !Empty(aAutocab[nPosProv,2])
							aAutocab[nPosProv,2] := SubStr(	cProvIT,1,TamSX3('A2_COD')[1])							//Fornecedor
						EndIf
						If (nPosLoja := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_LOJA"})) > 0 .And. !Empty(aAutocab[nPosLoja,2])
							aAutocab[nPosLoja,2] := SubStr(	cProvIT,TamSX3('A2_COD')[1]+1,TamSX3('A2_LOJA')[1])	//Loja
						EndIf
					Endif
				Endif

			Case nXForms == 3		//Fornecedor+Loja ITR
				If !Empty(cProvITR)
					SA2->(DbSetOrder(1))
					If SA2->(DbSeek(xFilial("SA2")+cProvITR))
						If (nPosProv := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_FORNECE"})) > 0 .And. !Empty(aAutocab[nPosProv,2])
							aAutocab[nPosProv,2] := SubStr(	cProvITR,1,TamSX3('A2_COD')[1])							//Fornecedor
						EndIf
						If (nPosLoja := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_LOJA"})) > 0 .And. !Empty(aAutocab[nPosLoja,2])
							aAutocab[nPosLoja,2] := SubStr(	cProvITR,TamSX3('A2_COD')[1]+1,TamSX3('A2_LOJA')[1])	//Loja
						EndIf
					Endif
				Endif
			Case nXForms == 4		//Fornecedor+Loja IUE Retenciones
				If !Empty(cProvIUR)
					SA2->(DbSetOrder(1))
					If SA2->(DbSeek(xFilial("SA2")+cProvIUR))
						If (nPosProv := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_FORNECE"})) > 0 .And. !Empty(aAutocab[nPosProv,2])
							aAutocab[nPosProv,2] := SubStr(	cProvIUR,1,TamSX3('A2_COD')[1])							//Fornecedor
						EndIf
						If (nPosLoja := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_LOJA"})) > 0 .And. !Empty(aAutocab[nPosLoja,2])
							aAutocab[nPosLoja,2] := SubStr(	cProvIUR,TamSX3('A2_COD')[1]+1,TamSX3('A2_LOJA')[1])	//Loja
						EndIf
					Endif
				Endif
			OtherWise
				MsgAlert(XSTR001) //"Formulario Incorrecto."
		EndCase	
		
		//Define Historial
		Do Case
			Case nXForms == 1		//Historial IVA
				If (nPosHist := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_HIST"})) > 0 .And. !Empty(aAutocab[nPosHist,2])
					aAutocab[nPosHist,2] := "PAGO DE IMPUESTOS IVA"	
				EndIf

			Case nXForms == 2		//Historial IT
				If (nPosHist := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_HIST"})) > 0 .And. !Empty(aAutocab[nPosHist,2])
					aAutocab[nPosHist,2] := "PAGO DE IMPUESTOS IT"	
				EndIf
				
			Case nXForms == 3		//Historial ITR
				If (nPosHist := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_HIST"})) > 0 .And. !Empty(aAutocab[nPosHist,2])
					aAutocab[nPosHist,2] := "PAGO DE IMPUESTOS ITR"	
				EndIf

			Case nXForms == 4		//Historial IUE Retenciones
				If (nPosHist := AScan(aAutocab,{|x|AllTrim(x[1])== "E2_HIST"})) > 0 .And. !Empty(aAutocab[nPosHist,2])
					aAutocab[nPosHist,2] := "PAGO DE IMPUESTOS IUE Retenciones"	
				EndIf
			OtherWise
				MsgAlert(XSTR001) //"Formulario Incorrecto."
		EndCase
		
	Endif
Endif	

RestArea( aArea )
Return
