#include "TOTVS.CH"

User Function TipoACheck()



	DEFINE DIALOG oDlg TITLE "Exemplo TCheckBox" FROM 180,180 TO 550,700 PIXEL
	lCheck := .T.    // Usando New
	

	//	oCheck1 := TCheckBox():New(01,01,'CheckBox 001',{||lCheck},oDlg,100,210,,,,,,,,.T.,,,)
	//	oCheck2 := TCheckBox():New(11,01,'CheckBox 002',{||lCheck},oDlg,100,210,,,,,,,,.T.,,,)
	oCheck1 := TCheckBox():New(01,01,'NF',,oDlg,100,210,,,,,,,,.T.,,,)
	oCheck2 := TCheckBox():New(11,01,'NCC',,oDlg,100,210,,,,,,,,.T.,,,)
	oCheck3 := TCheckBox():New(21,01,'NCV',,oDlg,100,210,,,,,,,,.T.,,,)
	oCheck4 := TCheckBox():New(31,01,'NDC',,oDlg,100,210,,,,,,,,.T.,,,)
	oCheck5 := TCheckBox():New(41,01,'NDV',,oDlg,100,210,,,,,,,,.T.,,,)
	oCheck6 := TCheckBox():New(51,01,'RA',,oDlg,100,210,,,,,,,,.T.,,,)
	// Usando Create
	//	oCheck6 := TCheckBox():Create( oDlg,{||lCheck},61,01,'CheckBox 006',100,210,,,,,,,,.T.,'CheckBox 006',,)
	//	oCheck7 := TCheckBox():Create( oDlg,{||lCheck},71,01,'CheckBox 007',100,210,,,,,,,,.T.,'CheckBox 007',,)

	ACTIVATE DIALOG oDlg CENTERED

	cArray := {}
		
	
	
	if(oCheck1:value)	
//		AADD(cArray,'NF')	
	alert("hola")	
//	elseif (oCheck2:"NCC")	
////		AADD(cArray,oCheck2)
//	elseif (oCheck3:value)	
////		AADD(cArray,oCheck3)
//	elseif (oCheck4:value)	
//		AADD(cArray,oCheck4)	
	endif
	
	If Len(cArray) < 1
		cTitulo := ""
		Help(" ",1,"Aviso",,"Por favor selecionar por lo menos un Tipo Titulo",1,0)
		return lOk
	else	
		cTitulo := cArray[1]
		FOR nCount:= 2 TO Len(cArray) Step 1
			cTitulo += "," + cArray[nCount]
		Next
	EndIf	

Return lCheck
