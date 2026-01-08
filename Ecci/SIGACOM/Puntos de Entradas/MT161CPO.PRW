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
//	Local aCampos := {"C8_PRECO","C8_XPRODAL"} // Array com os campos adicionados na grid "Item da Proposta"
//	Local aCposProd := {"C8_PRECO","C8_XPRODAL"} // Array com os campos adicionados na grid "Produtos"
	Local aCampos := {"C8_QUANT","C8_XPRODAL"} // Array com os campos adicionados na grid "Item da Proposta" NTP 12/12/2019 Producto alternativo
	Local aCposProd := {"C8_QUANT","C8_XPRODAL"} // Array com os campos adicionados na grid "Produtos" NTP 12/12/2019 Producto alternativo
	Local aRetorno := {}
	Local nX := 0
	Local nY := 0
	Local nZ := 0
	local nPrec:= 0
	local aPrec[len(aItens)]
	local cFornece
	local cLoja
	local cPropos
	aArea := GetArea()

	//Aviso("Array proposta",u_zArrToTxt(aPropostas, .T.),{'ok'},,,,,.t.)
	
	For nX := 1 To Len(aPropostas)
		For nY := 1 To Len(aPropostas[nX])
			// For nZ := 1 To Len(aPropostas[nX][nY])//cabecera items
			// 	if len(aPropostas[nX][nY][1]) > 0
			// 		cFornece := aPropostas[nX,nY,1,1 ]
			// 		cLoja := aPropostas[nX,nY,1,2 ]
			// 		cPropos := aPropostas[nX,nY,1,2 ]
			// 	endif

			// 	// sino quiere decir que hay un array vacio
			// 	//next nn
			// 	/**/

			// next nZ

			For nn := 1 To Len(aPropostas[nX][nY][2])
				//ALERT(Len(aPropostas[nX][nY][2]))
				if len(aPropostas[nX][nY][1]) > 0
					//AJUSTE EET 03/09/18
					//                                         NUMCOTIZACION. FORNCE                 -  TIENDA LOJA            - PRODUTO                - ITEM COTI                 - PROPOSTA
					nPrec := Posicione("SC8",10,xFilial("SC8")+ SC8->C8_NUM + aPropostas[nX,nY,1,1 ] + aPropostas[nX,nY,1,2 ] +aPropostas[nX,nY,2,nn,3] + aPropostas[nX,nY,2,nn,2] + aPropostas[nX,nY,1,4 ] ,"C8_QUANT")
					AADD(aPropostas[nX][nY][2][nn],nPrec)
					// NTP 12/12/19 Producto alternativo
					AADD(aPropostas[nX][nY][2][nn],SC8->C8_XPRODAL)
//					AADD(aPropostas[nX][nY][2][nn],Posicione("SC8",10,xFilial("SC8")+ SC8->C8_NUM + aPropostas[nX,nY,1,1 ] + aPropostas[nX,nY,1,2 ] +aPropostas[nX,nY,2,1,3] + aPropostas[nX,nY,2,1,2] + aPropostas[nX,nY,1,4 ]  ,"C8_XPRODAL" ))
				else
					AADD(aPropostas[nX][nY][2][nn],0)
					// NTP 12/12/19 Producto alternativo
					AADD(aPropostas[nX][nY][2][nn],0)
				endif
			next nn
			/*Nahim Adicionando cambio 08/03/2021*/
			if len(aPropostas[nX][nY][2][2]) % 2  == 0 // si no aumenta sale error al tickear.
				aadd(aPropostas[nX][nY][2][1],"-")
				aadd(aPropostas[nX][nY][2][2],"-")
			endif
			/*Nahim Finaliza*/
		Next nY
	Next nX
	//Aviso("Array proposta",u_zArrToTxt(aPropostas, .T.),{'ok'},,,,,.t.)

	///alert(len(aItens))/*
	For nX := 1 To Len(aItens)
		AADD(aItens[nX],TRANSFORM(aPrec[nX],"@E 999,999.99"))
		//		AADD(aItens[nX],TRANSFORM(aPrec[nX],"@E 999,999.99"))
		// NTP 12/12/19 Producto alternativo
		AADD(aItens[nX],Posicione("SC8",1,SC8->(C8_FILIAL+C8_NUM)+aItens[nX][10]+aItens[nX][11]+aItens[nX][12]+aItens[nX][13],"C8_XPRODAL"))
	Next nX

	AADD(aRetorno,aPropostas)
	AADD(aRetorno,aCampos)
	AADD(aRetorno,aItens)
	AADD(aRetorno,aCposProd)

Return aRetorno
