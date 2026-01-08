#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT340B2   ºAutor  ³TdeP Totvs Bolivia    º Data ³ 09/03/2019º±±
±±					        ºAjuste ³ º Data ³ º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Considera B7_UCOSTO como ref. para Custo de produtos inventariados º±±
±±º          ³                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLIVIA                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT340B2()
Local _cArea:=GetArea()

//If dtoc(DDATABASE) > '20190601'
//	Alert("Se está corriendo el PE MT340B2 para la carga inicial que ajustará los costos, no debe correr este PE si es después de esto")
//EndIf

//_nCusto:=Posicione('SB1',1,XFILIAL('SB1')+SD3->D3_COD,"B1_CUSTD")
//_nCusto:=Posicione('SB7',1,XFILIAL('SB7')+SD3->(DTOS(D3_EMISSAO)+D3_COD+D3_LOCAL+D3_LOCALIZ+D3_NUMSERI+D3_LOTECTL+D3_NUMLOTE)+SPACE(LEN(SB7->B7_CONTAGE)),"B7_UCOSTO")

_nCusto:= SB7->B7_UCOSTO

RecLock('SD3',.F.)
SD3->D3_CUSTO1 := _nCusto
SD3->D3_CUSTO2 := xMoeda(SD3->D3_CUSTO1,1,2,DDATABASE)
SD3->D3_CUSTO3 := xMoeda(SD3->D3_CUSTO1,1,3,DDATABASE)
SD3->D3_CF := SUBSTR(SD3->D3_CF, 1, 2)+'6'
SD3->(MsUnlock())

reclock("SB2", .F.)	
SB2->B2_CM1:= _nCusto/SD3->D3_QUANT
SB2->B2_CM2:= xMoeda(_nCusto/SD3->D3_QUANT,1,2,DDATABASE)
SB2->B2_CM3:= xMoeda(_nCusto/SD3->D3_QUANT,1,3,DDATABASE)
SB2->B2_VATU1:= SB2->B2_CM1 * SD3->D3_QUANT 
SB2->B2_VATU2:= SB2->B2_CM2 * SD3->D3_QUANT    
SB2->B2_VATU3:= SB2->B2_CM3 * SD3->D3_QUANT
SB2->(msunlock())

//Alert("Terminó PE MT340B2:"+SB7->B7_COD)

RestArea(_cArea)
Return
