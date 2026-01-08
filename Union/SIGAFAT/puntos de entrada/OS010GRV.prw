#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'

/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma OS010GRV  บAutor  ณERICK ETCHEVERRY บ   บ Date 07/09/2019   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑDescripcion Luego de grabar libera algunas variable de OM010DA1         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ UNION SRL	                                        	   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ MV_PAR01 ณ Descricao da pergunta1 do SX1                              บฑฑ
ฑฑบ MV_PAR02 ณ Descricao da pergunta2 do SX1                              บฑฑ
ฑฑบ MV_PAR03 ณ Descricao do pergunta3 do SX1                              บฑฑ
ฑฑบ MV_PAR04 ณ Descricao do pergunta4 do SX1                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function OS010GRV()
	Local nTipo := PARAMIXB[1]
	Local nOpc := PARAMIXB[2]  //1 INC   4 ALT   5 DEL
	Local cDepPadre := alltrim(FWFldGet("DA0_DEPTAB")) //codigo padre
	Local cPadreTab := alltrim(FWFldGet("DA0_CODTAB")) //codigo lista

	if nOpc == 4
		if Type("lFilhos") <> "U" //si existe
			lFilhos := nil
			FreeObj(lFilhos)
		endif

		if!empty(cDepPadre) //tiene padre es lista hijo
			upListaPrc(cPadreTab,FWFldGet("DA0_PERLIS"),cDepPadre)
		endif
	endif
return

///actualiza precios en todas las hijas
static Function upListaPrc(cCodTab,nNewPrec,cDepTab)
	Local aArea	:= GetArea()
	Local cQuery := ""
	Local lRet := .f.
	Local nPorcLis := nNewPrec
	Local StrSql:=""

	StrSql:=" UPDATE DA1 "
	StrSql+=" SET DA1.DA1_PRCVEN = (CAST(DA1P.DA1_PRCVEN AS FLOAT) * '" + CVALTOCHAR(nPorcLis) + "'/100) + CAST(DA1P.DA1_PRCVEN AS FLOAT), "
	StrSql+=" DA1.DA1_UPRCVA = DA1.DA1_PRCVEN "
	StrSql+=" FROM " + RETSQLNAME('DA1')+ " DA1 "
	StrSql+=" JOIN " + RETSQLNAME('DA0')+ " DA0 "
	StrSql+=" ON DA0_FILIAL = DA1.DA1_FILIAL AND DA1.DA1_CODTAB = DA0_CODTAB AND DA0.D_E_L_E_T_ = '' AND DA0.DA0_DEPTAB = '" + cDepTab + "'"
	StrSql+=" JOIN " + RETSQLNAME('DA1')+ " DA1P "
	StrSql+=" ON DA1P.DA1_FILIAL = DA1.DA1_FILIAL AND DA1P.DA1_CODPRO = DA1.DA1_CODPRO AND DA1P.DA1_CODTAB = '" + cDepTab + "' AND DA1P.D_E_L_E_T_ = ''"
	StrSql+=" WHERE "
	StrSql+=" DA1.DA1_FILIAL = '" + xfilial("DA1") + "' AND DA1.DA1_CODTAB = '" + cCodTab + "' AND DA1.D_E_L_E_T_ = '' "

	If __CUSERID = '000000'	
								
		Aviso("PRECOLIST",StrSql,{'ok'},,,,,.t.)
	EndIf

	If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
		aviso("ERROR AL ACTUALIZAR EL COSTO EN CQ",StrSql + TCSQLError(),{'ok'},,,,,.t.)
		return .F.
	EndIf

	RestArea(aArea)
Return