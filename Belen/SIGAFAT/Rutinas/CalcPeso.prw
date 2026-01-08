#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CALCPESO Autor ³ Luiz Alberto        ³ Data ³ 11/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pelo preenchimento dos campos         ±±
				   de Peso Bruto e Peso Liquido do Pedido de Vendas
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Criar Gatilho no Campo C6_QTDVEN igual a U_CALCPESO(M->C6_QUANT)
							 Contra dominio C6_QTDVEN                                   ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function CalcPeso(nValSC5)
Local nPesoBruto := 0
Local nPesoLiqui := 0
Local nTotaCubic := 0
Local nTotaPalle := 0

nPosItem := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_ITEM"})
nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_PRODUTO"})
nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDVEN"})
nPosCubi := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_XXTCUB"})
nPosPale := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_XXTPALE"})
nPosQtdL := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDLIB"})

For _nItem := 1 to Len(aCols)                    
    If ! aCols[_nItem,Len(aHeader)+1]
		 Posicione("SB1",1,xFilial("SB1")+aCols[_nItem,nPosProd],"")
		 Posicione("SB5",1,xFilial("SB5")+aCols[_nItem,nPosProd],"")
		 
       // Posiciona-se no item do pedido atual gravado e efetua o abatimento caso o mesmo já tenha sido atendido parcialmente

		If SC6->(dbSetOrder(2), dbSeek(xFilial("SC6")+aCols[_nItem,nPosProd]+M->C5_NUM+aCols[_nItem,nPosItem]))
			If !Empty(aCols[_nItem,nPosQtdL])
				nPesoLiqui += ((aCols[_nItem,nPosQtdL]) * SB1->B1_PESO)
				//  nPesoBruto += ((aCols[_nItem,nPosQtdL]) * SB1->B1_PBRUT)    
	            // If SB5->(!Eof()) .And. !Empty(SB5->B5__CUBUNE)
				// 	nTotaCubic += Round(SB5->B5__CUBUNE * (aCols[_nItem,nPosQtdL]) ,4)     
				// Endif
	            // If SB5->(!Eof()) .And. !Empty(SB5->B5__CXSPLT)
				// 	nTotaPalle += Round((aCols[_nItem,nPosQtdL])/SB5->B5__CXSPLT,2)
				// Endif
			Else				 
				 nPesoLiqui += ((aCols[_nItem,nPosQtde] - SC6->C6_QTDENT) * SB1->B1_PESO)
				//  nPesoBruto += ((aCols[_nItem,nPosQtde] - SC6->C6_QTDENT) * SB1->B1_PBRUT)    
	            // If SB5->(!Eof()) .And. !Empty(SB5->B5__CUBUNE)
				// 	 nTotaCubic += Round(SB5->B5__CUBUNE * (aCols[_nItem,nPosQtde] - SC6->C6_QTDENT) ,4)     
				// Endif
	            // If SB5->(!Eof()) .And. !Empty(SB5->B5__CXSPLT)
				// 	 nTotaPalle += Round((aCols[_nItem,nPosQtde] - SC6->C6_QTDENT)/SB5->B5__CXSPLT,2)
				// Endif                                                                   
			Endif
		 Else
			If !Empty(aCols[_nItem,nPosQtdL])
			 	nPesoLiqui += (aCols[_nItem,nPosQtdL] * SB1->B1_PESO)
			 	// nPesoBruto += (aCols[_nItem,nPosQtdL] * SB1->B1_PBRUT)
			 	// nTotaCubic += aCols[_nItem,nPosCubi]
			 	// nTotaPalle += aCols[_nItem,nPosPale]
			Else
			 	nPesoLiqui += (aCols[_nItem,nPosQtde] * SB1->B1_PESO)
			 	// nPesoBruto += (aCols[_nItem,nPosQtde] * SB1->B1_PBRUT)
			 	// nTotaCubic += aCols[_nItem,nPosCubi]
			 	// nTotaPalle += aCols[_nItem,nPosPale]
			Endif
		 Endif
    EndIf
Next

// M->C5_PBRUTO := nPesoBruto
M->C5_PESOL  := nPesoLiqui       
// M->C5_XXTCUB := nTotaCubic
// M->C5_XXTPALE:= nTotaPalle
GetDRefresh() 
Return nValSC5


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CALCEMBA Autor ³ Luiz Alberto        ³ Data ³ 01/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pelo preenchimento dos campos         ±±
				   de QUANTIDADE NO PEDIDO DE VENDA COM BASE NA QTDE EMBALAGEM 
				   DO PRODUTO GRUPO QUIMICOS
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ JOFEL                                        ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function CalcEmba(nQtde)
nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_PRODUTO"})
nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDVEN"})

If M->C5_TIPO = 'N'
	If SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aCols[n,nPosProd]))
		If AllTrim(SB1->B1_GRUPO) == "06" // Grupo de Quimicos
			If !Empty(SB1->B1_QE) // Quantidade da Embalagem do Produto
				If Mod(aCols[n,nPosQtde],SB1->B1_QE) <> 0
					MsgStop("Atencao para este Material Apenas Multiplos de " + Str(SB1->B1_QE,3))
					nQtde := SB1->B1_QE
				Endif               
			Endif
		Endif
	Endif                    
	GetDRefresh() 
EndIf

Return nQtde

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CALCCUB Autor ³ Luiz Alberto        ³ Data ³ 23/09/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pelo preenchimento dos campos         ±±
				   de Total de Cubicagem do Item de Venda 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ JOFEL                                        ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function CalcCub()
Local nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_PRODUTO"})
Local nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDVEN"})                  

Local nTotCub := 0.0000

If SB5->(dbSetOrder(1), dbSeek(xFilial("SB5")+aCols[n,nPosProd])) .And. !Empty(SB5->B5__CUBUNE)
	nTotCub := Round(SB5->B5__CUBUNE * (aCols[n,nPosQtde]) ,4)
Endif                    
GetDRefresh() 

Return nTotCub


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CALCPAL Autor ³ Luiz Alberto        ³ Data ³ 23/09/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pelo preenchimento dos campos         ±±
				   de Total de Pallets do Item de Venda 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ JOFEL                                        ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function CalcPal()
Local nPosProd := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_PRODUTO"})
Local nPosQtde := ASCAN(aHeader, {|aVal| Alltrim(aVal[2]) == "C6_QTDVEN"})                   
Local nTotPal := 0.0000

If SB5->(dbSetOrder(1), dbSeek(xFilial("SB5")+aCols[n,nPosProd])) .And. !Empty(SB5->B5__CXSPLT)
	nTotPal := Round((aCols[n,nPosQtde])/SB5->B5__CXSPLT,2)
Endif                    
GetDRefresh() 

Return nTotPal

// B5__CUBUNE CUBICAGEM EX         
// B5__CUBPLC CUBICAGEM PALLET


