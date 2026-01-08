#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"
#Include "TopConn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA570SCX  ºAutor  ³ERICK ETCHEVERRY º Data ³  04/12/2023    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PUNTO DE ENTRADA PARA CORREGIR CAJA CHICA ENTRE FILIALES    º±±
±±º          ³ AL EXISTIR UNA REPOSICION Y UN SOLO REGISTRO DEVUELTO      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FA570SCX()
	Local aArea 	:= GetArea()
	Local nX
    Local nTotComp := paramixb[1] 
    Local cSEUFil := ""

	IF(FUNNAME()$'FINA570')

		///MIRAMOS LA ULTIMA SECUENCIA
		cSeqCxa := Fa570SeqAtu( SET->ET_CODIGO )

		////LO QUE SE SELECCIONO DE LAS FILIALES A REVISAR
		If Type( "aSelFil" ) <> "A"
			aSelFil := {xFilial( "SEU" , cFilAnt ) }
		EndIf

		For nX := 1 To Len(aSelFil)
			cSEUFil += "'" + FWxFilial("SEU",aSelFil[nX] ) + "',"
		Next Nx

		cSEUFil := SubStr(cSEUFil,1,Len(cSEUFil)-1)

		cQuery := " SELECT EU_FILIAL, EU_TIPO, EU_DTDIGIT, EU_CAIXA, EU_SEQCXA, EU_NROADIA, EU_VALOR, EU_BAIXA, EU_STATUS, EU_CODAPRO, R_E_C_N_O_ "
		cQuery += " FROM " + RetSqlName( "SEU" )
		cQuery += " WHERE EU_FILIAL IN ("+cSEUFil+") "
		cQuery += " AND EU_CAIXA = '"+ SET->ET_CODIGO +"' "     ////EU_CAIXA O ET_CODIGO
		cQuery += " AND EU_SEQCXA >= '"+cSeqCxa+"' "
		cQuery += " AND D_E_L_E_T_ <> '*' "
		cQuery += " ORDER BY EU_FILIAL, EU_SEQCXA, R_E_C_N_O_ "

		cQuery := ChangeQuery(cQuery)

		cAliasWrk := GetNextAlias()

		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasWrk, .T., .T.)

        DbSelectArea(cAliasWrk)

		DbGoTop()
		Count To nTotReg  //solo cuando hay un registro 10 da el problema
		DbGoTop()

        cAliasTmp := cAliasWrk

        if (cAliasTmp)->(!Eof())

            if nTotReg == 1 .and. (cAliasTmp)->EU_TIPO == "10" .or. (cAliasTmp)->EU_TIPO == "92"

                nTotRep := (cAliasTmp)->EU_VALOR //1160

                nTotComp = nTotComp - nTotRep

            endif
        
        endif

	ENDif

	RestArea(aArea)

return nTotComp
