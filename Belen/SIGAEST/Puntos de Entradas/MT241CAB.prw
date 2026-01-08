#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MT241CAB    ³ Autor ³Erick Etcheverry     ³ Data ³16.01.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Carga en la cabecera de movimientos el campo de descripcion ³±±
±±³ del centro de costo													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT241CAB()
	Local oNewDialog  := PARAMIXB[1]
	Local aCp:={}

	oNewDialog:aControls[8]:blostfocus:= {||lDescCusto(@oNewDialog,@aCp)}

return (aCp)

STATIC Function lDescCusto(oDlgo,aCpp)
	Local nPosCtaSa 	:= aScan( aHeader,{|z| Alltrim(Upper(z[2]))=="D3_XCTASA" })
	Local nPosCod 	:= aScan( aHeader,{|z| Alltrim(Upper(z[2]))=="D3_COD" })

	if !empty(cCC)
		dbSelectArea("CTT")
		dbSetOrder(1)

		If MsSeek(xFilial("CTT")+cCC)

			For nX := 1 To Len(aCols)
				dbSelectArea("SB1")
				dbSetOrder(1)

				If MsSeek(xFilial("SB1")+aCols[nX][nPosCod])

					IF CTT->CTT_NORMAL == "1" //GASTO
						aCols[nX][nPosCtaSa]:= SB1->B1_XCTASAG
					ELSEIF CTT->CTT_NORMAL == "2" //COSTO INGRESO
						aCols[nX][nPosCtaSa]:= SB1->B1_XCTASAC
					ENDIF

				ENDIF
				SB1->(dbclosearea())
			Next

			oDlgo:Refresh()
			oGet:oBrowse:Refresh() ///ACTUALIZA ACOLS
		endif
		CTT->(dbclosearea())

	endif

Return .T.