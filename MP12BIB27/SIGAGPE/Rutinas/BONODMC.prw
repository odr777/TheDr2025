#Include 'Protheus.ch'
#Include "Topconn.ch"

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
// EJEMPLOS

// U_BONODMC('000179','201709')
// U_BONODMC('000179','201707')
User Function BONODMC(cMatricula,cPeriodo)
		
		_cQuery := " SELECT RCF_DIADSR - COUNT(*) as resultado"
		_cQuery += " FROM "
		_cQuery += " ( "
		_cQuery += " SELECT DISTINCT DATEPART(WK, SUBSTRING(PC_DATA,5,2)+'/'+SUBSTRING(PC_DATA,7,2)+'/'+SUBSTRING(PC_DATA,1,4)) SEMANA, RCF_DIADSR "
		_cQuery += " From " + RetSqlName("SPC") + " SPC, " + RetSqlName("RCF") + " RCF, " + RetSqlName("SP9") + " SP9 "
		_cQuery += " Where SPC.D_E_L_E_T_ = ' ' "
		_cQuery += " and RCF.D_E_L_E_T_ = ' ' "
		_cQuery += " and SP9.D_E_L_E_T_ = ' ' "
		_cQuery += " and PC_PERIODO = RCF_PER "
		_cQuery += " and PC_PD = P9_CODIGO "
		_cQuery += " and PC_MAT LIKE '"+ cMatricula +"' "
		_cQuery += " and PC_PERIODO LIKE '"+ cPeriodo +"' "
		_cQuery += " and P9_IDPON IN('009N', '010A', '008A', '007N') "
		_cQuery += " ) A "
		_cQuery += " GROUP BY RCF_DIADSR "

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
			If Empty(nValor)
				nValor := 4
			endif
		Endif
//		alert(nValor)
//		SQ->(DbCloseArea())
//		Q2->(DbCloseArea())
Return nValor
