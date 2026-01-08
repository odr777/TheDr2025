#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgram   ณF1_UCORREL  บAuthor ณMauricio Salazar, Nahim Terrazad  บ Date ณ  29/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que genera el codigo del correlativo en base al    บฑฑ
ฑฑบ          ณ mayor numero de registro +1						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUse       ณ        Mercantil Leon                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F1_UCORREL()
Local _cQuery 
Local _cCodigo :=""
Local i


		
		_cQuery := " SELECT MAX (cast( F1_UCORREL AS INT)) F1_UCORREL"
		_cQuery += " From " + RetSqlName("SF1")  
		_cQuery += " Where D_E_L_E_T_ <> '*' "
        _cQuery += " and F1_ESPECIE = 'RCN'"

	//	Aviso("",_cQuery,{"Ok"},,,,,.T.)
		If Select("SQ") > 0  //En uso
		   SQ->(DbCloseArea())
		   
		End
		
		TcQuery _cQuery New Alias "SQ"
		
 
  		_cNumero := alltrim(SQ->F1_UCORREL)
	    _nNumero := (F1_UCORREL)
		_nNumero++	
		i := 6
		_cNumero := STRZERO(_nNumero, i, 0)
		
//alert (_nNumero)		
//alert (_cNumero)
Return cvaltochar(_cNumero)
