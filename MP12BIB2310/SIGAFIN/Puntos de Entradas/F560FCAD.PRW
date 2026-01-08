#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*    
    Jorge Saavedra
    04/12/2021
    P.E. para gravacoes complementares do SE5
*/


User Function F560FCAD()

local aArea := getArea()
Private _cBanco
Private _cAgencia
Private _cCuenta

If AllTrim(FunName())=="FINA550"	
			_cBancoTmp := SET->(ET_BANCO+'|'+ET_AGEBCO+'|'+ET_CTABCO) 
			IF SeleccionarBanco(SET->ET_BANCO,SET->ET_AGEBCO,SET->ET_CTABCO) == 1
				RecLock("SET",.F.)
					SET->ET_XBCOTEM := 	_cBancoTmp			
				MsUnLock()
			ELSE
				RecLock("SET",.F.)
					SET->ET_XBCOTEM := 	""			
				MsUnLock()
				MSGINFO("El proceso continuara con el banco "+ CRLF+ " que tenia configurada la caja chica por defecto","Atencion")
			END
EndIf

    restArea(aArea)

Return .F.



Static Function SeleccionarBanco(_cBanco,_cAgencia,_cCuenta)
Local oAgencia
Local oBanco
Local oButton1
Local oButton2
Local oCuenta
Local oFont1 := TFont():New("Palatino Linotype",,020,,.T.,,,,,.T.,.T.)
Local oFont2 := TFont():New("Century Gothic",,018,,.T.,,,,,.F.,.F.)
Local oFont3 := TFont():New("Century Gothic",,018,,.F.,,,,,.F.,.F.)
Local oSay1
Local oSay11
Local oSay2
Local oSay5
Local nOpca:=0
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "CAJA CHICA" FROM 000, 000  TO 250, 360 COLORS 0, 16777215 PIXEL

    @ 004, 033 SAY oSay1 PROMPT "DEVOLUCION DE SALDOS" SIZE 225, 017 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 028, 013 SAY oSay2 PROMPT "BANCO" SIZE 055, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 049, 013 SAY oSay5 PROMPT "AGENCIA" SIZE 037, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 101, 081 BUTTON oButton1 PROMPT "&Guardar" SIZE 038, 014 OF oDlg FONT oFont2 PIXEL ACTION (nOpca := 1, oDlg:End())
    @ 101, 129 BUTTON oButton2 PROMPT "&Cancelar" SIZE 038, 013 OF oDlg FONT oFont2 PIXEL ACTION (nOpca := 2, oDlg:End())
    @ 070, 013 SAY oSay11 PROMPT "CUENTA" SIZE 034, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 030, 067 MSGET oBanco VAR _cBanco SIZE 072, 012 OF oDlg COLORS 0, 16777215 FONT oFont3  F3 "SA6" PIXEL
    @ 049, 067 MSGET oAgencia VAR _cAgencia SIZE 072, 012 OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL READONLY
    @ 068, 067 MSGET oCuenta VAR _cCuenta SIZE 072, 012 OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL READONLY

  ACTIVATE MSDIALOG oDlg CENTERED

    IF nOpca == 1
		RecLock("SET",.F.)
			SET->ET_BANCO:= 	_cBanco			
			SET->ET_AGEBCO:= 	_cAgencia 			
			SET->ET_CTABCO:= 	_cCuenta			
		MsUnLock()
    END

Return nOpca

