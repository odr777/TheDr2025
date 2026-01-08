#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ LocxPE37  º Autor ³ Erick Etcheverry 	   º Data ³  28/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ajusta cuotas por pagar a fecha de embarque despacho         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function LocxPE37()
	Local aDuplOri := paramixb

	if funname() $ "MATA143"
		if !empty(alltrim(SF1->F1_HAWB)) .AND. ALLTRIM(SF1->F1_NFORIG) == '' .and. ALLTRIM(SF1->F1_SERORIG) == ''
			dFecha = STOD(dtaEmbarq(SF1->F1_HAWB))//fecha inicial
			dFechaAct = STOD(dtaEmbarq(SF1->F1_HAWB))//fecha vencto actualizada

			i= 1
			nData = 0
			if !empty(dFecha)
				DbSelectArea("SE2")
				SE2->(dbSetOrder(1))
				IF SE2->(dbSeek(SF1->F1_FILIAL+SF1->F1_SERIE+SF1->F1_DOC))
					While SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC == SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
						if i == 1//saca la diferencia una vez de los dias de diferencia
							nData = DateDiffDay(SE2->E2_EMISSAO,SE2->E2_VENCTO)
						endif
						RecLock("SE2",.F.)
						Replace SE2->E2_EMISSAO With dFecha//las cuotas empiezan con la fecha de embarque
						Replace SE2->E2_VENCTO With DaySum(dFechaAct,nData)//el vencimiento es el embarque mas la diferencia
						Replace SE2->E2_VENCREA With DaySum(dFechaAct,nData)//el vencimiento es el embarque mas la diferencia
						Replace SE2->E2_VENCORI With DaySum(dFechaAct,nData)//el vencimiento es el embarque mas la diferencia
						Replace SE2->E2_EMIS1 With dDataBase

						MsUnlock()
						dFechaAct = SE2->E2_VENCTO// actualizamos el vencimiento
						i++
						DbSkip()
					ENDDO
				endif

			endif
		ENDIF
	endif
return

static function dtaEmbarq(cPoliz)
	Local cQuery	:= ""

	If Select("VW_DTEMB") > 0
		dbSelectArea("VW_DTEMB")
		dbCloseArea()
	Endif

	cQuery := "	SELECT DBA_DT_EMB "
	cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
	cQuery += " JOIN " + RetSqlName("DBA") + " DBA "
	cQuery += " ON DBA_HAWB = F1_HAWB AND F1_FILIAL = DBA_FILIAL AND DBA.D_E_L_E_T_ = '' "
	cQuery += " WHERE F1_HAWB = '" + cPoliz + "' "
	cQuery += " AND F1_SERORIG = '' AND F1_NFORIG = '' "
	cQuery += " AND SF1.D_E_L_E_T_ = '' "

	TCQuery cQuery New Alias "VW_DTEMB"

return VW_DTEMB->DBA_DT_EMB