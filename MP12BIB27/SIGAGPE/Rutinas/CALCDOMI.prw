#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"

#DEFINE SEMANHO		52		//Semanas al anho
#DEFINE HORADIA		8		//Horas trabajadas al dia

/**
*
* @author: Denar Terrazas Parada
* @since: 01/04/2019
* @description: Función que devuelve el calculo dominical
* @parametro: nSalario -> Salario del empleado
* 			  nHoraSem -> Horas trabajadas por semana del empleado
* 			  nDomPag  -> Numero de domingos a ser pagados
* 			  nDomDesc -> Numero de domingos a ser descontados
* @Retorno: array tamaño 2
*			array[1]-> Pago dominical
*			array[2]-> Descuento dominical
*/

user function CALCDOMI(nSalario, nHoraSem, nDomPag, nDomDesc)
	Local nSemMes	:= NOROUND((SEMANHO/12), 2)
	Local nFactor	:= NOROUND((nHoraSem * nSemMes), 2)
	Local nVlDomin	:= 0
	Local nVlFalDom	:= 0
	Local aRet		:= {}
	
	nVlDomin	:= (nSalario / nFactor) * HORADIA * nDomPag
	nVlFalDom	:= (nSalario / nFactor) * HORADIA * nDomDesc
	AADD(aRet, nVlDomin)
	AADD(aRet, nVlFalDom)
	
return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³BONODMC  ºAuthor Nahim Terrazas 07/11/2017   			  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± obtiene los dias de Bono Dominical que se debe pagar a trabajador      ¹±±
±±ºUse       ³        Generico Bolivia                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function BONODMC(cMatricula,cPeriodo, nTotDom)
Local aArea:= getArea()

	_cQuery := " SELECT DOMIN - COUNT(*) as resultado"
	_cQuery += " FROM "
	_cQuery += " ( "
	_cQuery += " SELECT DISTINCT DATEPART(WK, SUBSTRING(PH_DATA,5,2)+'/'+SUBSTRING(PH_DATA,7,2)+'/'+SUBSTRING(PH_DATA,1,4)) SEMANA, " + cvaltochar(nTotDom) + " DOMIN"
	_cQuery += " From " + RetSqlName("SPH") + " SPH, " + RetSqlName("RCF") + " RCF, " + RetSqlName("SP9") + " SP9 "
	_cQuery += " Where SPH.D_E_L_E_T_ = ' ' "
	_cQuery += " and RCF.D_E_L_E_T_ = ' ' "
	_cQuery += " and SP9.D_E_L_E_T_ = ' ' "
	_cQuery += " and PH_PERIODO = RCF_PER "
	_cQuery += " and PH_PD = P9_CODIGO "
	_cQuery += " and PH_MAT LIKE '"+ cMatricula +"' "
	_cQuery += " and PH_PERIODO LIKE '"+ cPeriodo +"' "
	_cQuery += " and P9_IDPON IN('009N', '010A', '008A', '007N') "
	_cQuery += " ) A "
	_cQuery += " GROUP BY DOMIN "

	//		Aviso("",_cQuery,{"Ok"},,,,,.T.)
	If Select("SQ") > 0  //En uso
		SQ->(DbCloseArea())
	End
	TcQuery _cQuery New Alias "SQ"
	nValor := SQ->resultado
	If Empty(nValor)
		_cQ2 := "SELECT RCF_DIADSR "
		_cQ2 += "FROM " + RetSqlName("RCF") + " RCF "
		_cQ2 += "WHERE D_E_L_E_T_ = ' ' "
		_cQ2 += "AND RCF_PER LIKE '"+ cPeriodo +"' "
		_cQ2 += "AND RCF_MODULO = 'PON' "

		If Select("Q2") > 0  //En uso
			Q2->(DbCloseArea())
		End
		TcQuery _cQ2 New Alias "Q2"
		nValor := Q2->RCF_DIADSR
	Endif
	//	SQ->(DbCloseArea())
	//	Q2->(DbCloseArea())
	restArea(aArea)
Return nValor
