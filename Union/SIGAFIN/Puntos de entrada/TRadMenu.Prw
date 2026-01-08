#include "TOTVS.CH"

User Function TRadMenu()

	local resp := .T.
	Local lCheck1 := .F.
	Local lCheck2 := .F.
	Local lCheck3 := .F.
	Local lCheck4 := .F.
	Local lCheck5 := .F.
	Local cArray := {}
	Private oDlg, oChkBox1,oChkBox2,oChkBox3,oChkBox4,oChkBox5

	DEFINE DIALOG oDlg TITLE "Tipo de Cliente" FROM 180,180 TO 500,600 PIXEL

	@ 10,10 CHECKBOX oChkBox1 VAR lCheck1 PROMPT "DGAN" SIZE 60,15 OF oDlg PIXEL
	@ 20,10 CHECKBOX oChkBox2 VAR lCheck2 PROMPT "DIM" SIZE 60,15 OF oDlg PIXEL
	@ 30,10 CHECKBOX oChkBox3 VAR lCheck3 PROMPT "RETAIL" SIZE 60,15 OF oDlg PIXEL
	@ 40,10 CHECKBOX oChkBox4 VAR lCheck4 PROMPT "DACER" SIZE 60,15 OF oDlg PIXEL
	//	@ 50,10 BUTTON btn PROMPT "Marcar/Desmarcar" SIZE 30,10 OF oDlg PIXEL on CLICK Seleccione(lCheck5)

//	@ 50,10 BUTTON "Marcar" SIZE 40,15 ACTION MsAguarde({|| Seleccione(lCheck5)}) OF oDlg PIXEL
	//	@ 60,10 checkbox oChk var lChkSel PROMPT "Selecionar todos" size 60,07 on CLICK Seleccione(lCheck5)

	@ 100,85  BUTTON btn PROMPT "Confirmar" SIZE 40,15 ;
	ACTION (resp := .T. , oDlg:End()) OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTERED

	if(lCheck1)
		AADD(cArray,'DGAN')
	endif
	if (lCheck2)
		AADD(cArray,'DIM')
	endif
	if (lCheck3)
		AADD(cArray,'RETAIL')
	endif
	if (lCheck4)
		AADD(cArray,'DACER')
	endif

	If Len(cArray) < 1
		nTipo := ""
		Help(" ",1,"Aviso",,"Por favor selecionar por lo menos un Tipo de Cliente",1,0)
		return resp
	else
		nTipo := cArray[1]
		FOR nCount:= 2 TO Len(cArray) Step 1
			nTipo += "," + cArray[nCount]
		Next
	EndIf

Return resp

//Static function Seleccione(lCheck)
//
//	if(lCheck)
//		oChkBox1 := 'LBOK'
//	else
//		oChkBox1 := 'LBNO'
//	end if
//	oDlg:Refresh()
//return

