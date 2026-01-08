#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTCNFDV    ºAutor  ³EDUAR ANDIA       º Data ³  08/05/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o custo de devolução de venda, se não houver a     º±±
±±º          ³ nota original, devolve o custo atual.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\ Union Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTCNFDV
Local aArea 	:= GetArea()
Local lCusFifo	:= PARAMIXB[1]
Local aCusto 	:= PARAMIXB[2]
Local nCusto	:= 0
Local nMoneda	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso NCC sea Manual (Sin Factura)                   		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(SD1->D1_ESPECIE) $ "NCC"
	If Empty(SD1->D1_NFORI) .AND. Empty(SD1->D1_REMITO)
		If GETNEWPAR("MV_X330NCC",.T.)
			
			If aCusto[1] <= 0 .AND. SD1->D1_QUANT > 0
				
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
				nMoneda := If(!Empty(SB1->B1_MCUSTD),Val(SB1->B1_MCUSTD),1)
				nCusto	:= SB1->B1_CUSTD * SD1->D1_QUANT
				nCusto	:= xMoeda(nCusto,nMoneda,1,SD1->D1_DTDIGIT,6)	//Custo en BS
				
				aCusto[1] := nCusto
				aCusto[2] := xMoeda(nCusto,1,2,SD1->D1_DTDIGIT,6)
				aCusto[3] := xMoeda(nCusto,1,3,SD1->D1_DTDIGIT,6)
				aCusto[4] := xMoeda(nCusto,1,4,SD1->D1_DTDIGIT,6)
				aCusto[5] := xMoeda(nCusto,1,5,SD1->D1_DTDIGIT,6)
				MsUnLock()
			Endif
			//Aviso("Array MTCNFDV: "+SD1->D1_COD,u_zArrToTxt(aCusto, .T.),{"Ok"},,,,,.T.)
		Endif
	Endif
Endif

RestArea(aArea)
Return(aCusto)
