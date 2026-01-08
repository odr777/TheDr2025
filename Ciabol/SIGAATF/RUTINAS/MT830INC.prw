	#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"

//REGISTRA ORDEN DE SEGUIMIENTO DE CONTADOR DEL BIEN

user function MT830INC(aItDCols)

	//					aAdd(aItem,{"D1_UHRINIE",nxUhin		,Nil})//6
	//					aAdd(aItem,{"D1_UHRFINE",nxUhfi		,Nil})//7
	//					aAdd(aItem,{"D1_UHORAEQ",nxUhra		,Nil})//8
	//					aAdd(aItem,{"D1_COD"	,cxProd		,Nil})//1
	//					aAdd(aItem,{"D1_UDTPTD",dxUdtptd	,Nil})//10
	//					aAdd(aItem,{"D1_CC"		,cxCCost	,Nil})//15
	//					aAdd(aItem,{"D1_CLVL"	,cxClVl	,Nil})//16
	//					aAdd(aItem,{"D1_ITEMCTA",cxItCta	,Nil})//14
	//					aAdd(aItem,{"D1_UNROPTD",cxUPtd		,Nil})//9
	
	for i:= 1 to len(aItDCols)
		// inc830t(aItDCols[i][6][2],;
		// aItDCols[i][7][2],;
		// aItDCols[i][8][2],;
		// aItDCols[i][1][2],;
		// aItDCols[i][10][2],;
		// aItDCols[i][15][2],;
		// aItDCols[i][16][2])
		getATF(aItDCols[i][16][2],XFILIAL("SD3"))// Busca posiciona sobre el b
		cCodBien = VW_ATF->N3_CBASE
		cItem = VW_ATF->N3_ITEM

		dbSelectArea("STP")
		dbSetOrder(1)
		STP->( dbGoBottom() )
		cOrdem  := STP->TP_ORDEM
		cCodBem := POSICIONE("ST9",8,XFILIAL("ST9")+cCodBien+cItem,"T9_CODBEM")

		MNTA830FIF(cCodBem,;
		aItDCols[i][7][2],;
		aItDCols[i][10][2],;
		aItDCols[i][20][2],;
		aItDCols[i][16][2])
		// MNTA830FIF(cBemInF,nCONT1V,dDTLEIV,cHORA1V,cCcD1)
	next i

return

static function inc830t(nUhrinie,nUhrfine,nUhoraeq,cCodProd,dUdtptd,cCcD1,cClval)

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
//			nPosCnt := nPosCnt + nUhrfine - nUhrinie  
//			nAcumCnt := nAcumCnt + nUhrfine - nUhrinie
			nDif := nUhrfine - nPosCnt
			if nDif > 0 // sólo si existe diferencia positiva
				nPosCnt := nPosCnt + nDif   // NTP 13/01/2020 
				nAcumCnt := nAcumCnt + nDif // NTP 13/01/2020
				
			else // Si es menor no debería considerar modificar el contador
				nPosCnt := nPosCnt // NTP 13/01/2020
				nAcumCnt := nAcumCnt // NTP 13/01/2020
			endif
			
			if nPosCnt >= nLimCnt
				nVirCnt++
				nPosCnt := (nPosCnt - nLimCnt)
			endif

			//cOrdem  := PADL(nOrdem,'0')
			cOrdem:= Soma1(cOrdem)
			// TP_FILIAL+TP_CODBEM+DTOS(TP_DTORIGI)+DTOS(TP_DTLEITU)+TP_HORA
			DbSelectArea("STP")
			dbSetOrder(2)
			if DbSeek(xFilial("STP")+cCodBem+DTOS(dUdtptd)) // si encuentra muestra mensaje que no se puede registrar
				Alert("El Bien " + cCodBem + " Ya tiene movimientos registrados en fecha " +DTOS(dUdtptd) )
			endif
			//REGISTRA ORDEN DE SEGUIMIENTO DE CONTADOR DEL BIEN
			DbSelectArea("STP")
			RecLock("STP",.T.)
			Replace TP_ORDEM    With cOrdem
			Replace TP_PLANO    With '000000'
			Replace TP_SEQUENCE With 0
			Replace TP_FILIAL   With xFIlial('STP')
			Replace TP_CODBEM   With cCodBem
			Replace TP_DTLEITU  With dUdtptd
			Replace TP_DTORIGI  With dUdtptd
			Replace TP_DTREAL   With dDataBase
			Replace TP_DTULTAC  With dUdtptd
			Replace TP_SITUACA  With "L"
			Replace TP_TERMINO  With "S"
			Replace TP_POSCONT  With nPosCnt
			Replace TP_ACUMCON  With nAcumCnt
			Replace TP_VARDIA   With nUhoraeq
			Replace TP_VIRACON  With nVirCnt
			Replace TP_TIPOLAN  With 'C'
			Replace TP_TEMCONT  With 'S'
			Replace TP_USULEI   With cUserName
			Replace TP_HORA     With substr(Time(),1,5)
			Replace TP_CCUSTO   With cCcD1
			MsUnlock()

			dbSelectArea("ST9")
			//dbSelectArea("ST9") ACTUALIZA CONTADOR DEL BIEN
			ST9->(RecLock("ST9",.F.))
			ST9->T9_POSCONT := nPosCnt
			ST9->T9_CONTACU := nAcumCnt
			//				ST9->T9_LIMICON := nLimCnt
			ST9->T9_VIRADAS := nVirCnt
			ST9->T9_DTULTAC := dDtUltAc
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



//---------------------------------------------------------------------
/*/{Protheus.doc} MNTA830FIF
Consist?ncia final do informa contador
@author Inácio Luiz Kolling
@since 27/05/2003
@version P12
@return
/*/
//---------------------------------------------------------------------
static Function MNTA830FIF(cBemInF,nCONT1V,dDTLEIV,cHORA1V,cCcD1)

	Local nX
	Local lRet := .T.
    Local aRet := {}
		// oSTP:setValue("TP_CODBEM" ,cBemInF)
		// oSTP:setValue("TP_POSCONT",nCONT1V)
		// oSTP:setValue("TP_DTLEITU",dDTLEIV)
		// oSTP:setValue("TP_HORA"   ,cHORA1V)

    // If ExistBlock("MNTA8301")
    //     If !ExecBlock("MNTA8301",.F.,.F.)
    //         Return .F.
    //     EndIf
    // EndIf

	vNRCONT1 := {}
	vNRCONT2 := {}
	// Dbselectarea(cTRB33)
	// Dbgotop()
	// If Reccount() > 0
	// 	While !Eof()
	// 		If nCONT1V > 0 .And. nCONT2V > 0
	// 			If (cTRB33)->TC_NREPASS = 4
	// 				Aadd(vNRCONT1,(cTRB33)->TC_COMPONE)
	// 				Aadd(vNRCONT2,(cTRB33)->TC_COMPONE)
	// 			Elseif (cTRB33)->TC_NREPASS = 2
	// 				Aadd(vNRCONT1,(cTRB33)->TC_COMPONE)
	// 			Elseif (cTRB33)->TC_NREPASS = 3
	// 				Aadd(vNRCONT2,(cTRB33)->TC_COMPONE)
	// 			Endif
	// 		Elseif nCONT1V > 0 .And. (cTRB33)->TC_NREPASS = 2
	// 			Aadd(vNRCONT1,(cTRB33)->TC_COMPONE)
	// 		Elseif nCONT2V > 0 .And. (cTRB33)->TC_NREPASS = 3
	// 			Aadd(vNRCONT2,(cTRB33)->TC_COMPONE)
	// 		Endif
	// 		Dbskip()
	// 	End
	// Endif

	Dbselectarea('ST9')
	Dbsetorder(1)
	Dbseek(xFILIAL("ST9")+cBemInF)

	oSTP:= MNTCounter():New()
	oSTP:setOperation(3)

	If nCONT1V > 0
		oSTP:setValue("TP_CODBEM" ,cBemInF)
		oSTP:setValue("TP_POSCONT",nCONT1V)
		// oSTP:setValue("TP_ACUMCONT",nCONT1V)
		oSTP:setValue("TP_DTLEITU",dDTLEIV)
		oSTP:setValue("TP_HORA"   ,cHORA1V)
   EndIf

	// If TIPOACOM2 .And. nCONT2V > 0
	// 	oSTP:setValue("TPP_CODBEM",cBemInF)
	// 	oSTP:setValue("TPP_POSCON",nCONT2V)
	// 	oSTP:setValue("TPP_DTLEIT",dDTLEIV)
	// 	oSTP:setValue("TPP_HORA"  ,cHORA2V)
    // EndIf

	lRet := oSTP:inform(vNRCONT1,vNRCONT2)
	If !lRet .And. !Empty(oSTP:getErrorList())
		cError := oSTP:getErrorList()[1]
		Help(,,'HELP',, cError,1,0)
		MsgInfo( cError, 'SIGAMNT' )
	else
		MsgInfo( 'Contador actualizado con éxito...', 'SIGAMNT' )
	EndIf

Return lRet
