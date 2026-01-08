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
	Local oNewDialog  := PARAMIXB[1] //objeto de tela
	Local aCp:=Array(1,2)//array con campos customizados

	aCp[1][1]="D3_UOBSERV" //campo a añadir
	aCp[1][2]= SPACE(100) //tamaño del campo

	//aControls devuelve el array con todos los objetos de la clase padre de las janelas "TSrvObject"
	//ALERT(SD3->D3_DOC)
	//oNewDialog:aControls[1] el objeto tiene varios objetos en la posicion 1 tenemos el que necesitamos
	IF PARAMIXB[2] == 1 // si es inclusion
		oNewDialog:bWhen:= {||lDescCusto(@oNewDialog,@aCp)}//le pido que cuando pierda el foco me devuelva algo		
	EndIf

	IF PARAMIXB[2] == 2 .or. 4 == PARAMIXB[2] //SI ES VISUALIZAR
		//lDescCusto(@oNewDialog,@aCp)
		aCp[1][2] := SD3->D3_UOBSERV

		@ 0.4,52.5 SAY "Observaciones" of oNewDialog //"Centro de Custo"
		@ 0.3,57.8 MSGET aCp[1][2]  SIZE 120,08 of oNewDialog //WHEN .f.
	EndIf

	IF PARAMIXB[2] == 3 // si es inclusion
		oNewDialog:bWhen:= {||lDescCusto(@oNewDialog,@aCp)}//le pido que cuando pierda el foco me devuelva algo
		@ 0.4,52.5 SAY "Observaciones" of oNewDialog//"Centro de Custo"
		@ 0.3,57.8 MSGET aCp[1][2]  SIZE 120,08 of oNewDialog //WHEN .f.
	EndIf

return (aCp)
//Funcion para disparar al msget customizado arriba ->disparador
STATIC Function lDescCusto(oDlgo,aCpp)//cCondicao,oDescCusto,cDescCusto,oGetDados)
	
	/////verificar para el correlativo
	if !empty(cTM)
		cDoc := u_SERMOVIN(cTm) //correlativo documento
		cDocumento := cDoc
		//oDlgo:Refresh()
	endif

Return .T.
