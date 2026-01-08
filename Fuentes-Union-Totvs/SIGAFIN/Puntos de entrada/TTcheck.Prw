#include "TOTVS.CH"

User Function TTcheck()

	local resp := .T.
	Local oDlg, oChkBox1,oChkBox2,oChkBox3,oChkBox4,oChkBox5,oChkBox6
	Local lCheck1 := .F.
	Local lCheck2 := .F.
	Local lCheck3 := .F.
	Local lCheck4 := .F.
	Local lCheck5 := .F.
	Local lCheck6 := .F.
	Local cArray := {}

	DEFINE DIALOG oDlg TITLE "Tipo Titulo" FROM 180,180 TO 500,600 PIXEL

	@ 10,10 CHECKBOX oChkBox1 VAR lCheck1 PROMPT "NF" SIZE 60,15 OF oDlg PIXEL
	@ 20,10 CHECKBOX oChkBox2 VAR lCheck2 PROMPT "NCC" SIZE 60,15 OF oDlg PIXEL
	@ 30,10 CHECKBOX oChkBox3 VAR lCheck3 PROMPT "NCV" SIZE 60,15 OF oDlg PIXEL
	@ 40,10 CHECKBOX oChkBox4 VAR lCheck4 PROMPT "NDC" SIZE 60,15 OF oDlg PIXEL
	@ 50,10 CHECKBOX oChkBox5 VAR lCheck5 PROMPT "NDV" SIZE 60,15 OF oDlg PIXEL
	@ 60,10 CHECKBOX oChkBox6 VAR lCheck6 PROMPT "RA" SIZE 60,15 OF oDlg PIXEL

	@ 100,80  BUTTON btn PROMPT "Confirmar" SIZE 40,15 ;
	ACTION (resp := .T. , oDlg:End()) OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTERED

	if(lCheck1)
		AADD(cArray,'NF')
	endif
	if (lCheck2)
		AADD(cArray,'NCC')
	endif
	if (lCheck3)
		AADD(cArray,'NCV')
	endif
	if (lCheck4)
		AADD(cArray,'NDC')
	endif
	if (lCheck5)
		AADD(cArray,'NDV')
	endif
	if (lCheck6)
		AADD(cArray,'RA')
	endif

	If Len(cArray) < 1
		cTitulo := ""
		Help(" ",1,"Aviso",,"Por favor selecionar por lo menos un Tipo Titulo",1,0)
		return resp
	else
		cTitulo := cArray[1]
		FOR nCount:= 2 TO Len(cArray) Step 1
			cTitulo += "," + cArray[nCount]
		Next
	EndIf

Return resp
