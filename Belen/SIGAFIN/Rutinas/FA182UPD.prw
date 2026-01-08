#Include 'Protheus.ch'
#Include "Topconn.ch"
#include 'parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA182UPD  ºAutor ³Nahim Terrazas º Data ³  15/07/2019      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
A±ºDesc.     ³PUNTO DE ENTRADA que posiciona para contabilizar 			  º±±
±±º           correctamente												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB -BELEN											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA182UPD()
	local nRecMAxNT
	IF SELECT('NTMAXIMO') > 0           //Verifica se o alias OC esta aberto
		NTMAXIMO->(DbCloseArea())       //Fecha o alias OC
	END

	cQuery:= "SELECT MAX(R_E_C_N_O_) RECNO  FROM " + RetSqlName('SEI')  +  " where D_E_L_E_T_ like ' '"
	TCQUERY cQuery NEW ALIAS "NTMAXIMO"
	nRecMAxNT := NTMAXIMO->RECNO

	NTMAXIMO->(DbCloseArea())       //Fecha o alias OC
	SEI->(DBGoto(nRecMAxNT))

return nRecMAxNT //.T.