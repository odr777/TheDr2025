#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"

//BORRA ORDEN DE SEGUIMIENTO DE CONTADOR DEL BIEN
// Nahim Terrazas 06/12/2019

user function MT830DEL(nUhrinie,nUhrfine,nUhoraeq,dUdtptd,cClval)
	getATF(cClval,xfilial("SF1"))

	cCodBien = VW_ATF->N3_CBASE
	cItem = VW_ATF->N3_ITEM

	dbSelectArea("STP")
	dbSetOrder(1)
	STP->( dbGoBottom() )
	cOrdem  := STP->TP_ORDEM

	// 8, T9_FILIAL+T9_CODIMOB
	//	MIG0CTA015
	//	0001
	//	MIG0CTA0150001

	cCodBem := POSICIONE("ST9",8,XFILIAL("ST9")+cCodBien+cItem,"T9_CODBEM")
	// cCodBem := POSICIONE("ST9",1,XFILIAL("ST9")+cCodBien,"T9_CODBEM")

	// posiciono
	DbSeek(xFilial("ST9")+cCodBem)
	dbSelectArea("ST9")
	dbSetOrder(1)

	if !empty(cCodBem)

		nPosCnt := ST9->T9_POSCONT
		nAcumCnt:= ST9->T9_CONTACU
		nLimCnt := ST9->T9_LIMICON
		nVirCnt := ST9->T9_VIRADAS

		dDtUltAc := dUdtptd
		//		If DbSeek(xFilial("ST9")+cCodBem)
		If ST9->T9_TEMCONT <> "N"
			nPosCnt := nPosCnt + nUhrfine - nUhrinie
			nAcumCnt := nAcumCnt + nUhrfine - nUhrinie

			if nPosCnt >= nLimCnt
				nVirCnt++
				nPosCnt := (nPosCnt - nLimCnt)
			endif

			//cOrdem  := PADL(nOrdem,'0')
			cOrdem:= Soma1(cOrdem)

			//REGISTRA ORDEN DE SEGUIMIENTO DE CONTADOR DEL BIEN
			//TP_FILIAL+TP_CODBEM+DTOS(TP_DTORIGI)+DTOS(TP_DTLEITU)+TP_HORA
			DbSelectArea("STP")
			dbSetOrder(2)
			dbseek(xfilial("STP") + cCodBem + DTOS(dDtUltAc) + DTOS(dDtUltAc))
			STP->(RecLock("STP",.F.))
			STP->(DBDELETE())
			MsUnlock()
			STP->(dbskip(-1))

			IF STP->TP_CODBEM == cCodBem // SI ES QUE ENCUENTRA EL MISMO BIEN
				dDtUltAc := STP->TP_DTLEITU // NTP Busco última actualización del Bien
			else // caso no tenga
				dDtUltAc := cTod("  /  /  ") // NTP Busco última actualización del Bien
			endif

			dbSelectArea("ST9")
			//dbSelectArea("ST9") ACTUALIZA CONTADOR DEL BIEN
			ST9->(RecLock("ST9",.F.))
			ST9->T9_POSCONT := -nPosCnt //resta
			ST9->T9_CONTACU := -nAcumCnt // resta
			//				ST9->T9_LIMICON := nLimCnt
			//			ST9->T9_VIRADAS := -nVirCnt // resta TODO VALIDAR GIROS (CUANDO EL HOROMETRO LLEGA AL FINAL)
			ST9->T9_DTULTAC := dDtUltAc // pide fecha ultimo seguimiento
			MsUnlock()

		Endif
		//		Endif

		MsgInfo( 'Contador actualizado con éxito...', 'SIGAMNT' )
	else
		MsgInfo( 'No se encontro el bien ' + cCodBien + cItem + ', relacionado con el activo ' + VW_ATF->N3_HISTOR, 'SIGAMNT' )
	endif

	VW_ATF->(DbCloseArea())
return

//carga atf
static function getATF(cCvl,cFilla)
	Local cQuery	:= ""

	If Select("VW_ATF") > 0
		dbSelectArea("VW_ATF")
		dbCloseArea()
	Endif

	cQuery := "	SELECT N3_FILIAL,N3_CBASE,N3_ITEM,N3_TIPO,N3_SEQ, N3_HISTOR "
	cQuery += "  FROM " + RetSqlName("SN3") + " SN3 "
	cQuery += "  WHERE N3_CLVL = '" + cCvl + "' "
	cQuery += "  AND N3_FILIAL = '" + cFilla + "' AND SN3.D_E_L_E_T_ = '' "

	TCQuery cQuery New Alias "VW_ATF"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return
