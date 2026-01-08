#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPE  ณ MT410INC บAutor  ณErick Etcheverry บFecha ณ  11/12/17 			  บฑฑ
ฑฑ						   Nahim Terrazas 	 Fecha    10/01/18			  นฑฑ
ฑฑ						   Erick Etcheverry  Fecha    09/02/18			  นฑฑ
ฑฑบDesc.     ณ Ejecutado despu้s de la grabaci๓n de la informaci๓n		  บฑฑ
ฑฑบDesc.     ณ de un Pedido de Venta		 							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function MT410INC()
	Local aArea := GetArea()
	Local nOpc := 3
	Local nPosProy := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PROJPMS"})
	Local nPosTask := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_TASKPMS"})
	Local nPosData := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG" })
	Local nPosValor := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR" })
	Local lN := 1
	Local cQuery

	If(FUNNAME()=="PMSA600")
		Do while lN <= Len(aCols)
			_cProy:= aCols[lN][nPosProy]
			_cTask := aCols[lN][nPosTask]
			_cData := aCols[lN][nPosData]
			_cValIt:= aCols[lN][nPosValor]

			cRevisa := AF8->AF8_REVISA
			cTot := Posicione("AF9",1,xFilial("AF9")+ _cProy+ cRevisa + _cTask,"AF9_CUSTO")//valor total
			nCantTot:= Posicione("AF9",1,xFilial("AF9")+ _cProy+ cRevisa + _cTask,"AF9_QUANT")// Cantidad total

			// Nahim obtiene la ultima cantidad del proyecto
			cQuery := " SELECT AFF_QUANT "
			cQuery += " From " + RetSqlName("AFF") + " AFF,"
			cQuery += " ("
			cQuery += " SELECT MAX(AFF_DATA) AS AFF_DATA "
			cQuery += " From " + RetSqlName("AFF") + " AFF"
			cQuery += " Where D_E_L_E_T_ <> '*' "
			cQuery += " AND AFF_PROJET LIKE  '" + _cProy + "'"
			cQuery += " AND AFF_TAREFA LIKE  '" + _cTask + "'"
			cQuery += " AND AFF_REVISA LIKE  '" + cRevisa + "'"
			cQuery += " ) as AFF2"
			cQuery += " Where D_E_L_E_T_ <> '*' AND AFF.AFF_DATA = AFF2.AFF_DATA"
			cQuery += " AND AFF_PROJET LIKE  '" + _cProy + "'"
			cQuery += " AND AFF_TAREFA LIKE  '" + _cTask + "'"
			cQuery += " AND AFF_REVISA LIKE  '" + cRevisa + "'"
			cQuery += " AND AFF.D_E_L_E_T_<>'*' "
			
			//Aviso("",cQuery,{"Ok"},,,,,.T.)
			
			If Select("SQ") > 0  //Preguntamos si esta en uso
				SQ->(DbCloseArea())
			End
			TcQuery cQuery New Alias "SQ"
			dbSelectArea("SQ")
			dbGoTop()
			nNumero := SQ->AFF_QUANT // cantidad ultimo anterior

			cPercent := (_cValIt* 100) / cTot // obtiene el porcentaje actual
			nPercAF9:= (nNumero/nCantTot) // obtiene cantidad anterior para porcentaje
			nPerc := 0 // porcentaje total a incluir
			
			if nNumero <> 0
				nPerc := cPercent + (nPercAF9*100)
			else
				nPerc := cPercent
			endif

			nPerc := ROUND(nPerc, 2)

			// 3-Inclusao , 4-Alterar , 5-ExcluirLocal
			aRotAut := {}
			aAdd( aRotAut, { "AFF_PROJET" ,_cProy,} )   //obrigat๓rio
			aAdd( aRotAut, { "AFF_REVISA" , cRevisa,} )   //obrigat๓rio
			aAdd( aRotAut, { "AFF_DATA", _cData,} ) //obrigat๓rio
			aAdd( aRotAut, { "AFF_TAREFA" ,_cTask,} )   //obrigat๓rio
			aAdd( aRotAut, { "AFF_PERC" ,nPerc,} )  //obrigat๓rio
			aAdd( aRotAut, { "AFF_HORAI" ,"00:00",} )
			aAdd( aRotAut, { "AFF_HORAF","00:00",} )

			PMSA311Aut(aRotAut,nOpc)
			lN++
		Enddo
	EndIf
	RestArea(aArea)
return