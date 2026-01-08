
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PE   ³ MT161CPO 	³Autor³ Erick Etcheverry/Mauro Welzel ³Data 02/07/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE  Adiciona items personalizados en productos e items de ³±±
±±productos en analiza cotizacionÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±³ Uso      ³ SIGACOM   Crea el campo precio unitario±±±±±±±±±±±±±±±±±±±±±±                                           
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT161CPO()

	Local aPropostas := PARAMIXB[1] // Array com os dados das propostas dos Fornecedores
	Local aItens := PARAMIXB[2] // Array com os dados da grid "Produtos"
	Local aCampos := {"C8_PRECO"} // Array com os campos adicionados na grid "Item da Proposta"
	Local aCposProd := {"C8_PRECO"} // Array com os campos adicionados na grid "Produtos"
	Local aRetorno := {}
	Local nX := 0
	Local nY := 0
	Local nZ := 0
	local nPrec:= 0
	local aPrec[len(aItens)]
	local cFornece
	local cLoja
	local cPropos
	local nX
	Local nY
	Local nZ
	Local nn
	aArea := GetArea()

	//Aviso("Array proposta",u_zArrToTxt(aPropostas, .T.),{'ok'},,,,,.t.)

	For nX := 1 To Len(aPropostas)
		For nY := 1 To Len(aPropostas[nX])
			For nZ := 1 To Len(aPropostas[nX][nY])//cabecera items
				if len(aPropostas[nX][nY][1]) > 0
					cFornece := aPropostas[nX,nY,1,1 ]
					cLoja := aPropostas[nX,nY,1,2 ]
					cPropos := aPropostas[nX,nY,1,2 ]
				endif
					
					 // sino quiere decir que hay un array vacio
				//next nn
				/**/

			next nZ
			
					For nn := 1 To Len(aPropostas[nX][nY][2])	
						//ALERT(Len(aPropostas[nX][nY][2]))
						if len(aPropostas[nX][nY][1]) > 0
							//AJUSTE EET 03/09/18
							//                                         NUMCOTIZACION. FORNCE                 -  TIENDA LOJA            - PRODUTO                - ITEM COTI                 - PROPOSTA
							nPrec := Posicione("SC8",10,xFilial("SC8")+ SC8->C8_NUM + aPropostas[nX,nY,1,1 ] + aPropostas[nX,nY,1,2 ] +aPropostas[nX,nY,2,1,3] + aPropostas[nX,nY,2,1,2] + aPropostas[nX,nY,1,4 ]  ,"C8_PRECO" )
							AADD(aPropostas[nX][nY][2][nn],nPrec)
						else
							AADD(aPropostas[nX][nY][2][nn],0)
						endif
					next nn
			
			Next nY
	Next nX
	//Aviso("Array proposta",u_zArrToTxt(aPropostas, .T.),{'ok'},,,,,.t.)

	///alert(len(aItens))/*
	For nX := 1 To Len(aItens)
		AADD(aItens[nX],TRANSFORM(aPrec[nX],"@E 999,999.99"))
	Next nX

	AADD(aRetorno,aPropostas)
	AADD(aRetorno,aCampos)
	AADD(aRetorno,aItens)
	AADD(aRetorno,aCposProd)

Return aRetorno