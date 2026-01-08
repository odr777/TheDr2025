#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'TBICONN.CH'
#Include 'TopConn.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Funcao    ³ vldLsNgr  ³ Autor ³ Denar Terrazas  ³ Data ³ 16/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcion que valida si el empleado se encontraba en    ³±±
±±³          ³ la lista negra.                                       ³±±
±±³          ³ Validacion de Usuario aplicada al campo "RA_RG"       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ecci                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

user function vldLsNgr()
	
	Local aArea		:= getArea()
	Local cQryAux	:= ""
	Local cCi		:= M->RA_RG
	Local lRet		:= .T.
	
	cQryAux := ""
	cQryAux += "SELECT RA_XLISN FROM " + RetSqlName("SRA") + " WHERE RA_RG = '" + cCi + "'" 

	cQryAux := ChangeQuery(cQryAux)

	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal

	QRY_AUX->(DbGoTop())
	If QRY_AUX->(!Eof())
		If(ALLTRIM(QRY_AUX->RA_XLISN) == 'S')
			alert("Este empleado se encuentra en la lista negra")
			lRet:= .F.
		endIf
	endif
	
	QRY_AUX->(dbCloseArea())
	
	restArea(aArea)
	
return lRet