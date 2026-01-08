#include "Protheus.ch"
#include "TOTVS.ch"
user Function getLC()

	Local  nprasf

	Private cBanco := Space(3)

	Private cAgencia := Space(5)

	Private cNumcon := Space(10)

	Private cLinea := Space(18)

	Private oDlg

	nprasf = 0

	if (nprasf==1)
		return
	endif

	//Private lAcepto := .F.

	if M->EH_ULINEA == "1"
		M->EH_XCOD :=""
		M->EH_XAGENCI := ""
		M->EH_XNUMCON := ""

		Define MSDIALOG oDlg FROM 65,000 To 230,400 Title "LINEAS DE CREDITO" PIXEL

		@ 01,003 To 80,130 Label "Seleccione la línea de crédito del prestamo" Of oDlg PIXEL

		@ 10,008 SAY "Linea" SIZE 30,10 Of oDlg PIXEL

		@ 10,040 MSGET cLinea F3 "SA6LC" VALID getdatos() SIZE 80,10 Of oDlg PIXEL

		@ 25,008 SAY "Codigo" SIZE 30,10 Of oDlg PIXEL

		@ 25,040 MSGET cBanco F3  SIZE 50,10 Of oDlg PIXEL

		@ 37,008 SAY "Agencia" SIZE 30,10 Of oDlg PIXEL

		@ 37,040 MSGET cAgencia F3  SIZE 50,10 Of oDlg PIXEL

		@ 49,008 SAY "Cuenta bancaria" SIZE 30,20 Of oDlg PIXEL

		@ 49,040 MSGET cNumcon  SIZE 50,10 Of oDlg PIXEL

		DEFINE SBUTTON FROM 57,090 Type 1 Action If((!Empty(cLinea)),(nOpca := 1,oDlg:End()),HELP(" ",1,"OBRIGAT",,SPACE(45),3,0)) ENABLE PIXEL OF oDlg

		Activate Dialog oDlg CENTERED

		//alert(cBanco)
		M->EH_XCOD := cBanco
		M->EH_XAGENCI := cAgencia
		M->EH_XNUMCON := cNumcon
	elseif M->EH_ULINEA == "2"
		M->EH_XCOD :=""
		M->EH_XAGENCI := ""
		M->EH_XNUMCON := ""
	else
		M->EH_XCOD :=""
		M->EH_XAGENCI := ""
		M->EH_XNUMCON := ""		
	endif
	
	

return cBanco

static function getdatos()
	cBanco   := Posicione("SA6",1,Xfilial("SA6")+cLinea,"A6_COD")
	//alert(cBanco)
	cAgencia := Posicione("SA6",1,Xfilial("SA6")+cLinea,"A6_AGENCIA")
	cNumcon  := Posicione("SA6",1,Xfilial("SA6")+cLinea,"A6_NUMCON")
	oDlg:Refresh()
	lret:=!Empty(cBanco).and.!Empty(cAgencia).and.!Empty(cNumcon)
return lRet
