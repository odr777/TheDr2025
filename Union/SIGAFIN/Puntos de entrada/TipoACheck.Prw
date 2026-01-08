#include "TOTVS.CH"

User Function Tipo_Titulo()

	DEFINE DIALOG oDlg TITLE "Exemplo TCheckBox" FROM 180,180 TO 550,700 PIXEL
	lCheck := .T.    // Usando New

	//	oCheck1 := TCheckBox():New(01,01,'CheckBox 001',{||lCheck},oDlg,100,210,,,,,,,,.T.,,,)
	//	oCheck2 := TCheckBox():New(11,01,'CheckBox 002',{||lCheck},oDlg,100,210,,,,,,,,.T.,,,)
	oCheck1 := TCheckBox():New(01,01,'SALA',,oDlg,100,210,,,,,,,,.T.,,,)
	oCheck2 := TCheckBox():New(11,01,'TELEFONO',,oDlg,100,210,,,,,,,,.T.,,,)
	oCheck3 := TCheckBox():New(21,01,'AUSPICIOS',,oDlg,100,210,,,,,,,,.T.,,,)
	oCheck4 := TCheckBox():New(31,01,'ND',,oDlg,100,210,,,,,,,,.T.,,,)
	
	// Usando Create
	//	oCheck6 := TCheckBox():Create( oDlg,{||lCheck},61,01,'CheckBox 006',100,210,,,,,,,,.T.,'CheckBox 006',,)
	//	oCheck7 := TCheckBox():Create( oDlg,{||lCheck},71,01,'CheckBox 007',100,210,,,,,,,,.T.,'CheckBox 007',,)

	ACTIVATE DIALOG oDlg CENTERED

Return lCheck