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

User Function MT261CAB()
	Local oNewDialog  := PARAMIXB[1] //objeto de tela
	Local aCp:=Array(2,2)//array con campos customizados
    Local oldArea := GetArea() //-- guarda a area
	Local SD3Area := SD3->(GetArea())

	IF PARAMIXB[3] == 3 // si es inclusion
		oNewDialog:bWhen:= {||lDescCusto(@oNewDialog)}
	EndIf

    RestArea(SD3Area)
	RestArea(oldArea)

return (aCp)

//Funcion para disparar al msget customizado arriba ->disparador
STATIC Function lDescCusto(oDlgo)//cCondicao,oDescCusto,cDescCusto,oGetDados)
	
	/////verificar para el correlativo
	if !empty('000')
		cDoc := u_SERMOVIN('000') //correlativo documento
		cDocumento := cDoc
		//oDlgo:Refresh()
	endif

Return .T.
