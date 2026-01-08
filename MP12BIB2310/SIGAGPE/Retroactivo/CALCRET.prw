#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SUMASRD บAutor  ณFRANZ BASCOPE          บFecha ณ  20/04/18 บฑฑ
ฑฑบPrograma  ณ SUMASRD บAutor  ณDENAR TERRAZAS         บFecha ณ  20/04/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.  ณ Cแlculo de Retroactivo								 	      บฑฑ
ฑฑบ       ณ 									     				      บฑฑ
ฑฑบVariab.ณ ออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบ       ณ C__ROTEIRO -> Procedimiento que se estแ procesando		      บฑฑ
ฑฑบ       ณ CPERIODO -> Periodo que se estแ procesando		              บฑฑ
ฑฑบ       ณ CNUMPAG -> Numero de pago que se estแ procesando              บฑฑ
ฑฑบ       ณ CPROCESSO -> Proceso que se estแ procesando		              บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบModif.    ณ Omar Delgadillo ณ 28.05.25 ณ Corregir error en cแlculo de  บฑฑ
ฑฑบ          ณ bono de antiguedad cuando el BA es prorrateado			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function CALCRET(cRA_FILIAL, cRA_MAT)
	Local aArea		:= getArea()
	Local aInret 	:= RVINRETRO()
	Local cPerActual:= CPERIODO//Periodo que se estแ procesando
	Local cPerRET	:= SUBSTR(cPerActual, 1, 4) + STRZERO(VAL(SUBSTR(C__ROTEIRO, 3)), 2, 0)
	// Local nAnho		:= val(SUBSTR(cPerActual, 1, 4))-1
	Local nValInfo	:= 0
	Local cRotFOL	:= 'FOL'//Procedimiento de Planilla de Sueldos
	Local cPDBonoAnt:= FGETCODFOL("0671")//Concepto de Bono de Antiguedad
	Local cPDHabBas	:= FGETCODFOL("0031")//Concepto de Haber bแsico
	Local cPDDomini	:= FGETCODFOL("0779")//Concepto de Dominical
	Local cPDHE		:= "040"//Concepto de Horas Extras
	Local cPDHNMas	:= "041"//Concepto de Horas Nocturnas(Recargo Nocturno) - Masculino
	Local cPDHNFem	:= "047"//Concepto de Horas Nocturnas(Recargo Nocturno) - Femenino
	Local cFilialPer:= U_getFilialPeriodoRet(cRA_MAT,cPerRET)
	Local nX		:= 1
	Local nHabBasico:= 0//Haber bแsico del funcionario en el periodo al que se va a aplicar el retroactivo
	Local nDiasTrab	:= 0//Dias trabajados del funcionario en el periodo al que se va a aplicar el retroactivo
	Local nNuevoHB	:= 0//Variable utilizada para almacenar el nuevo Haber bแsico
	Local nPorcentaje := 0
	Local lIncrHB	:= .T.//Variable que define si se incrementa el Haber bแsico o NO
	Local i			:= 1

	Local nDiasDom		:= 0//Numero de domingos
	Private nValorDom	:= 0//Valor del dominical
	Private dDataRef	:= LastDate(STOD(cPerActual + "01"))//Ultimo dia del mes

	//Porcentaje de Incremento | Viene de la pregunta RETROACT
	nIncrSal		:= MV_PAR01 / 100
	nSMN			:= MV_PAR02 / 100

	If(nIncrSal <= 0 .AND. nSMN <= 0)
		return
	EndIf
	nMinimoActual	:= VAL(ALLTRIM(Posicione("RCC",1,xFilial('RCC')+'S005'+'    '+'      '+'001',"RCC_CONTEU")))

	nDiasTrab		:= GetAdvFVal("SRD", "RD_HORAS", cFilialPer + cRA_MAT + cPerRET + cPerRET + cPDHabBas ,3, 0)//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
	nHabBasico		:= GetAdvFVal("SRD", "RD_VALOR", cFilialPer + cRA_MAT + cPerRET + cPerRET + cPDHabBas ,3, 0)//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
	If(nHabBasico <= 0 .OR. nDiasTrab <= 0)
		cPDHabBas 	:= FGETCODFOL("0048")//Concepto de Haber bแsico en finiquito
		nDiasTrab	:= GetAdvFVal("SRD", "RD_HORAS", cFilialPer + cRA_MAT + cPerRET + cPerRET + cPDHabBas ,3, 0)//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
		nHabBasico	:= GetAdvFVal("SRD", "RD_VALOR", cFilialPer + cRA_MAT + cPerRET + cPerRET + cPDHabBas ,3, 0)//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC

		If(nHabBasico <= 0 .OR. nDiasTrab <= 0)
			return
		ELSE
			cRotFOL	:= 'FIN'
		ENDIF
	EndIf

	if(nDiasTrab < 30 )//Si NO trabaj๓ el mes completo
		nHabBasico:= nHabBasico / nDiasTrab * 30
	EndIf

	If(nIncrSal <= 0)//Si no hay Incremento salarial
		if(nHabBasico >= nMinimoActual)//Si el salario del funcionario ya es mayor al nuevo SMN
			lIncrHB:= .F.
		EndIf
		nRA_SALARIO	:= GetAdvFVal("SRA", "RA_SALARIO", cRA_FILIAL + cRA_MAT, 1, 0)//Obtiene el salario del funcionario
		dRA_DEMISSA	:= GetAdvFVal("SRA", "RA_DEMISSA", cRA_FILIAL + cRA_MAT, 1, CTOD("  /  /    "))//Obtiene la fecha de despido del empleado
		If(!Empty(dRA_DEMISSA))//Si el funcionario estแ despedido
			nNuevoHB 	:= nMinimoActual
		Else
			nNuevoHB 	:= nRA_SALARIO//nMinimoActual
		EndIf
		nPorcentaje	:= nSMN
	Else
		nNuevoHB := (nHabBasico * nIncrSal) + nHabBasico
		nPorcentaje:= nIncrSal
		if(nNuevoHB < nMinimoActual)
			nNuevoHB := nMinimoActual
			nPorcentaje:= nSMN
		EndIf
	EndIf

	aListaPD	:= {}
	aListaPer	:= {}
	aVal		:= {}
	aHoras		:= {}
	aCC			:= {}
	aSEM		:= {}
	aPD			:= {}
	aProces		:= {}
	aSeq		:= {}

	//Validamos que los conceptos no est้n en la tabla de incidencias(RGB)
	for i := 1 to Len(aInret)//Recorremos los conceptos para no tomar en cuenta los que se encuentran en la tabla de Incidencias (RGB)
		cPDRGB:= GetAdvFVal("RGB", "RGB_PD", cRA_FILIAL + cRA_MAT + cPerActual + C__ROTEIRO + CNUMPAG + aInret[i],6,"")//RGB_FILIAL+RGB_MAT+RGB_PERIOD+RGB_ROTEIR+RGB_SEMANA+RGB_PD
		If( EMPTY(cPDRGB) )//Si NO lo encuentra en Incidencias(RGB)
			AADD(aListaPD, aInret[i])
		EndIf
	next i

	if(Len(aListaPD) < 1)//Si no hay conceptos para calcular retroactivo
		return
	EndIf

	//DOMINICAL
	nDiasDom	:= GetAdvFVal("SRD", "RD_HORAS", cFilialPer + cRA_MAT + cPerRET + cPerRET + cPDDomini ,3, 0)//RD_FILIAL+RD_MAT+RD_PERIODO+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
	If(nDiasDom > 0)
		if(!lIncrHB)//Si no incrementa Haber Bแsico NO debe incrementar Dominical
			nValorDom:= 0
		Else
			nValorDom:= calculaDOM(cRA_FILIAL, cRA_MAT, (nNuevoHB - nHabBasico), nDiasDom)
		EndIf
	EndIf

	dbSelectArea("SRD")
	dbSetOrder(5)//RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA
	dbseek(cFilialPer + cRA_MAT + CPROCESSO + cRotFOL + cPerRET)
	WHILE !EOF() .AND. SRD->RD_MAT == cRA_MAT .AND. SRD->RD_PERIODO == cPerRET;
			.AND. SRD->RD_PROCES == CPROCESSO .AND. SRD->RD_ROTEIR == cRotFOL

		for nX := 1 to len(aListaPD)
			if(SRD->RD_PD == aListaPD[nX])
				AADD (aListaPer, SRD->RD_PERIODO)
				AADD (aVal, SRD->RD_VALOR)
				AADD (aHoras, SRD->RD_HORAS)
				AADD (aCC, SRD->RD_CC)
				AADD (aSEM, SRD->RD_SEMANA)
				AADD (aPD, SRD->RD_PD)
				AADD (aProces, SRD->RD_PROCES)
				AADD (aSeq, SRD->RD_SEQ)
			endif
		next nX

		SRD->(dbSkip())

	ENDDO
	SRD->(dbclosearea())
	nListPER := 1
	DBSELECTAREA("SRC")
	while nListPER <= len(aListaPer)
		if val(aListaPer[nListPER]) >= val(cPerRET) .AND. val(aListaPer[nListPER]) < val(cPerActual)

			nVal:= aVal[nListPER]

			If(aPD[nListPER] == cPDHabBas)//Haber bแsico
				nVal	:= nNuevoHB - nHabBasico
				if(nDiasTrab < 30 )//Si NO trabaj๓ el mes completo
					nVal:= nVal / 30 * nDiasTrab
				EndIf
				nValInfo:= nPorcentaje
				if(!lIncrHB)//Si no incrementa Haber Bแsico
					nVal	:= 0
				EndIf
			ElseIf(aPD[nListPER] == cPDBonoAnt)//Bono de Antiguedad
				nVal	:= calculaBA(aVal[nListPER], nMinimoActual, aHoras[nListPER], nDiasTrab, cRotFOL)
				nValInfo:= nSMN
			ElseIf(aPD[nListPER] == cPDHE)//Horas Extras
				if(!lIncrHB)//Si no incrementa Haber Bแsico NO debe incrementar Horas Extras
					nVal	:= 0
				Else
					nVal	:= calculaHE(aHoras[nListPER], (nNuevoHB - nHabBasico))
				EndIf
				nValInfo:= nPorcentaje
			ElseIf(aPD[nListPER] $ (cPDHNMas + "|" + cPDHNFem))//Horas Nocturnas
				if(!lIncrHB)//Si no incrementa Haber Bแsico NO debe incrementar Horas Nocturnas
					nVal	:= 0
				Else
					nVal	:= calculaHN(cRA_FILIAL, cRA_MAT, aHoras[nListPER], (nNuevoHB - nHabBasico), aPD[nListPER])
				EndIf
				nValInfo:= nPorcentaje
			ElseIf(aPD[nListPER] == cPDDomini)//Dominical
				nVal	:= nValorDom
				nValInfo:= nPorcentaje
			Else
				nVal	:= nVal * nPorcentaje
				nValInfo:= nPorcentaje
			EndIf
			nValInfo	:= nValInfo * 100
			//dAdmissa	:= Posicione("SRA", 1, cRA_FILIAL + cRA_MAT, "RA_ADMISSA")
			//nAdmision	:= Val(SUBSTR(DTOS(dAdmissa),1 ,4))
			IF nVal > 0 //.AND. nAdmision<= nAnho
				ReClock("SRC",.T.)
				SRC-> RC_MAT	:= cRA_MAT
				SRC-> RC_FILIAL	:= cRA_FILIAL
				SRC-> RC_PD		:= aPD[nListPER]
				SRC-> RC_HORAS	:= aHoras[nListPER]
				SRC-> RC_VALINFO:= nValInfo
				SRC-> RC_VALOR	:= nVal
				SRC-> RC_DTREF	:= dDataRef
				SRC-> RC_DATA	:= dDataRef
				SRC-> RC_SEMANA	:= aSEM[nListPER]
				SRC-> RC_CC		:= aCC[nListPER]
				SRC-> RC_PROCES	:= aProces[nListPER]
				SRC-> RC_PERIODO:= cPerActual
				SRC-> RC_ROTEIR	:= C__ROTEIRO//C__ROTEIRO -> Procedimiento que se estแ procesando

				SRC->(MSUNLOCK())	
			endif
		endif
		nListPER++
	enddo
	SRC->(dbclosearea())
	restArea(aArea)
return


/**
* @author: Franz Bascope / Denar Terrazas Parada
* @since: 20/04/2018
* @description: Funci๓n que obtiene la sucursal del empleado en el periodo enviado.
*/
user function getFilialPeriodoRet(cMat,cPer)
	Local aArea	:= getArea()
	Local StrSql:= ""
	Local cRet	:= ""

	StrSql:= "SELECT TOP 1 RD_FILIAL FROM" + RETSQLNAME('SRD')+ " WHERE D_E_L_E_T_ = ' ' AND RD_PERIODO ='"+cPer+"'"
	StrSql+= " AND RD_MAT='"+cMat+"'"
	StrSql+= " AND RD_ROTEIR in ('FOL','FIN')"
	StrSql+= " ORDER BY RD_PD"
	StrSql := ChangeQuery(StrSql)

	If Select("SQLF") > 0  //En uso
		SQLF->(DbCloseArea())
	End

	dbUseArea(.T.,'TOPCONN', TCGenQry(,,StrSql),"SQLF", .F., .T.)

	dbSelectArea("SQLF")
	dbGoTop()

	If SQLF->(!Eof())
		cRet:= SQLF->(RD_FILIAL)
	endif
	SQLF->(dbCloseArea())
	restArea(aArea)
return cRet

/**
* @author: Denar Terrazas Parada
* @since: 20/04/2018
* @description: Funcion que retorna una lista de los conceptos a los que se debe aplicar el retroactivo
*/
static function RVINRETRO()
	Local aArea		:= getArea()
	Local aLista 	:= {}
	dbSelectArea("SRV")
	dbSetOrder(1)
	SRV->(dbgotop())
	WHILE !EOF()
		if(SRV->RV_COMPL_ == 'S')
			AADD (aLista,SRV->RV_COD)
		endif
		SRV->(dbSkip())
	ENDDO
	SRV->(dbclosearea())
	restArea(aArea)
return aLista

/**
* @author: Denar Terrazas Parada
* @since: 25/05/2021
* @description: Funcion que calcula el valor de las horas extras
* @parameters:	nCantHE -> Cantidad de Horas Extras
* 				nSalario -> Salario del funcionario para realizar el cแlculo
*/
static function calculaHE(nCantHE, nSalario)
	Local aArea		:= getArea()
	Local nRet		:= 0
	Local nDias		:= 30//Cantidad de dias por mes(mes contable)
	Local nHoras	:= 8//Cantidad de horas por dํa
	Local nFactor	:= 2
	Local nBaseHE	:= nSalario + nValorDom//Salario + Dominical

	nRet:= (nBaseHE / nDias / nHoras * nFactor * nCantHE)

	restArea(aArea)

return nRet

/**
* @author: Denar Terrazas Parada
* @since: 04/06/2021
* @description: Funcion que calcula el valor de las horas nocturnas
* @parameters:	cFil -> Sucursal del funcionario
*				cMat -> Matricula del funcionario
*				nCantHN -> Cantidad de Horas Nocturnas
* 				nSalario -> Salario del funcionario para realizar el cแlculo
*				cCodSrv -> Codigo del concepto de Horas Nocturnas
*/
static function calculaHN(cFil, cMat, nCantHN, nSalario, cCodSrv)
	Local aArea		:= getArea()
	Local nRet		:= 0
	Local nBaseRN	:= nSalario + nValorDom//Salario + Dominical

	nHoraMes:= GetAdvFVal("SRA", "RA_HRSMES", cFil + cMat, 1, 0)

	nPercent := IF (( nPercent := POSSRV(cCodSrv, SRA->RA_FILIAL, "RV_PERC") ) = 0,1,nPercent / 100)

	nRet := nBaseRN / nHoraMes * nPercent * nCantHN

	restArea(aArea)

return nRet

/**
* @author: Denar Terrazas Parada
* @since: 04/06/2021
* @description: Funcion que calcula el valor del Bono de Antiguedad
* @parameters:	nBAAnterior -> Valor del Bono de Antiguedad que recibi๓ en el periodo pasado(ENE,FEB,MAR o ABR)
* 				nMinimo -> Nuevo salario mํnimo nacional(con incremento)
*				nPorcentaje -> Porcentaje de Bono de Antiguedad que recibi๓ el funcionario en el periodo pasado(ENE,FEB,MAR o ABR)
*				nDiasTrab	-> Numero de dias trabajados en el periodo pasado(ENE,FEB,MAR o ABR)
*/
static function calculaBA(nBAAnterior, nMinimo, nPorcentaje, nDiasTrab, cRotFOL)
	Local aArea		:= getArea()
	Local nRet		:= 0
	Local mNemoBA	:= "M_LPRORRATBA"//Mnemonico->PRORRATEA BONO DE ANTIGUEDAD (RETROACTIVO)

	nRet:= nBAAnterior * nSMN	//nRet:= (nMinimo * 3) * (nPorcentaje / 100)
		
	IF cRotFOL == 'FIN'
		nRet:= nRet / 30 * nDiasTrab
	ELSE	// si es FOL
		lProrratea:= GetAdvFVal("RCA", "RCA_CONTEU", xFilial("RCA") + mNemoBA ,1, ".F.")//RCA_FILIAL+RCA_MNEMON
		lProrratea:= &lProrratea//&->Quita comillas "

		if(lProrratea)//Si prorratea bono de antiguedad con los dํas trabajados
			nRet:= nRet / 30 * nDiasTrab
		EndIf
	ENDIF

	// nRet:= nRet - nBAAnterior

	restArea(aArea)

return nRet

/**
* @author: Denar Terrazas Parada
* @since: 04/06/2021
* @description: Funcion que calcula el valor de los dominicales
* @parameters:	nSalario -> Salario del funcionario para realizar el cแlculo
*				nDomPag -> Numero de Domingos a Pagar
*/
Static Function calculaDOM(cFil, cMat, nSalario, nDomPag)
	Local aArea		:= getArea()
	Local nRet		:= 0
	Local nDomDesc	:= 0
	Local aDom		:= {}

	nHoraSem:= GetAdvFVal("SRA", "RA_HRSEMAN", cFil + cMat, 1, 0)

	if(nHoraSem > 0)
		aDom:= U_CALCDOMI(nSalario, nHoraSem, nDomPag, nDomDesc)
		nRet:= aDom[1]//Valor del dominical
	EndIf

	restArea(aArea)
Return nRet
