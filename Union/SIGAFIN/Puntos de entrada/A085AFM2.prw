#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A085AFM2  ³ Autor ³ ERICK ETCHEVERRY	    ³ Data ³ 03.01.13 ³±±
±±³Fun‡„o   Modified Erick Etcheverry			        ³ Data ³ 03.01.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ PE despues de generar la op y contabilidachi               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A085AFM2(	)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Exclusivo:  Especifico uniao					              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A085AFM2()
	Local aArea    := GetArea()
	Local aDatos:= ParamIxb[1]
	Private aOrdPag := {}
	Private cOrPag

	if UPPER(funname()) $ "FINA085A"
		//Aviso("ADATO",u_zArrToTxt(aDatos, .T.),{'ok'},,,,,.t.)
		for i:= 1 to len(aDatos)
			cOrpag := aDatos[i][1]
			dbSetOrder(1)
			SEK->(DbGoTop())

			if SEK->(dbSeek(xFilial("SEK")+cOrpag+"CP"))
				//alert("Entrada")
				//aviso("Array IVA",SEK->EK_ORDPAGO+SEK->EK_TIPODOC+SEK->EK_TIPO+cvaltochar(SEK->EK_VALOR)+SEK->EK_FORNECE,{'ok'},,,,,.t.)
				//aviso("Array IVA",cOrpag+"CP"+"CH "+cValtochar(aDatos[i][5])+aDatos[i][2],{'ok'},,,,,.t.)
				WHILE SEK->(!EOF()) .AND. SEK->EK_ORDPAGO == cOrpag
					if SEK->EK_TIPODOC == "CP" .AND. SEK->EK_TIPO == "CH " .AND. SEK->EK_VALOR == aDatos[i][5];
					.AND. SEK->EK_FORNECE == aDatos[i][2]
						AADD(aOrdPag,{SEK->EK_ORDPAGO,SEK->EK_ORDPAGO,SEK->EK_BANCO,SEK->EK_AGENCIA,SEK->EK_CONTA,SEK->EK_NUM})
						//Aviso("Array IVA",u_zArrToTxt(aOrdPag, .T.),{'ok'},,,,,.t.)
						u_IMPCHEAUT(aOrdPag)
					endif
					SEK->(DBSKIP())
				ENDDO
			endif
		next i

	ENDIF

Return