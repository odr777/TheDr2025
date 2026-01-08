#include "TOTVS.CH"

User Function TATTCHEK()

	local respuesta := .T.
	Local oDlg, oChkBox1,oChkBox2,oChkBox3,oChkBox4
	Local lCheck1 := .F.
	Local lCheck2 := .F.
	Local lCheck3 := .F.
	Local lCheck4 := .F.
	Local cArray := {}

	DEFINE DIALOG oDlg TITLE "Tipo Atención" FROM 180,180 TO 500,600 PIXEL

	@ 10,10 CHECKBOX oChkBox1 VAR lCheck1 PROMPT "SALA" SIZE 60,15 OF oDlg PIXEL
	@ 20,10 CHECKBOX oChkBox2 VAR lCheck2 PROMPT "TELEFONO" SIZE 60,15 OF oDlg PIXEL
	@ 30,10 CHECKBOX oChkBox3 VAR lCheck3 PROMPT "AUSPICIOS" SIZE 60,15 OF oDlg PIXEL
	@ 40,10 CHECKBOX oChkBox4 VAR lCheck4 PROMPT "ND" SIZE 60,15 OF oDlg PIXEL

	@ 100,80  BUTTON btn PROMPT "Confirmar" SIZE 40,15 ;
	ACTION (resp := .T. , oDlg:End()) OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTERED

	if(lCheck1)
		AADD(cArray,'SALA')
	endif
	if (lCheck2)
		AADD(cArray,'TELEFONO')
	endif
	if (lCheck3)
		AADD(cArray,'AUSPICIOS')
	endif
	if (lCheck4)
		AADD(cArray,'ND')
	endif

	If Len(cArray) < 1
		cAtencion := ""
		Help(" ",1,"Aviso",,"Por favor selecionar por lo menos un Tipo Atención",1,0)
		return respuesta
	else
		cAtencion := cArray[1]
		FOR nCount:= 2 TO Len(cArray) Step 1
			cAtencion += "," + cArray[nCount]
		Next
	EndIf

Return respuesta