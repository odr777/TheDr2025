#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"
#INCLUDE "FWEVENTVIEWCONSTS.CH"       
#INCLUDE "RWMAKE.CH"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPE  ³ MT410INC ºAutor  ³Erick Etcheverry ºFecha ³  11/12/17 			  º±±
±±						   Nahim Terrazas 	 Fecha    10/01/18			  ¹±±
±±						   Erick Etcheverry  Fecha    09/02/18			  ¹±±
±±ºDesc.     ³ Ejecutado después de la grabación de la información		  º±±
±±ºDesc.     ³ de un Pedido de Venta		 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT410INC()
	Local aArea := GetArea()
	Local nOpc := 3
	Local nPosProy := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PROJPMS"})
	Local nPosTask := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_TASKPMS"})
	Local nPosData := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG" })
	Local nPosValor := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR" })
	Local lN := 1
	Local nccPedido := 1
	Local cQuery
	if (inclui)
		aCentroCosto := BUSCC(SC5->C5_NUM)
		nTotalPEdVis := U_GETPEDTOT(SC5->C5_NUM,SC5->C5_CLIENTE) //
		RecLock("SC5",.F.)
		Replace 	C5_UTOTPED      With nTotalPEdVis
		MsUnlock()

		IF !EMPTY(aCentroCosto)
			// conout("contiene valor")
			cPedNum := SC5->C5_NUM 
			//*****Ejecutar esto para que coloque el valor
			DbSelectArea("SC6") 
			SC6->(dbGoTop())
			dbsetOrder(1)
			//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			dbseek(xFIlial("SC6")+SC5->C5_NUM)
			While SC6->( !Eof() ) .and. SC5->C5_NUM == SC6->C6_NUM 
				// cpedido:=aItem2[i][1]
				// aItem2[i][1]:=cCusto
				//alert (aItem2[i][1])
				// conout("WHILE valor")
				// conout(aCentroCosto[nccPedido])
				RecLock("SC6",.F.) // EDITANDO
					Replace SC6->C6_CCUSTO 	 With aCentroCosto[nccPedido]
					
				SC6->(MsUnLock())
				SC6->(dbSkip())
				// posicionarte
				//__aCols[nCCusto] :=cCusto	 	
				nccPedido++
            End
			dbCloseArea("SC6")
			//******
		else	
			// conout("no encontro")
			DbSelectArea("AGG")
			conout(AGG->AGG_PEDIDO)
		ENDIF
	endif
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
			aAdd( aRotAut, { "AFF_PROJET" ,_cProy,} )   //obrigatório
			aAdd( aRotAut, { "AFF_REVISA" , cRevisa,} )   //obrigatório
			aAdd( aRotAut, { "AFF_DATA", _cData,} ) //obrigatório
			aAdd( aRotAut, { "AFF_TAREFA" ,_cTask,} )   //obrigatório
			aAdd( aRotAut, { "AFF_PERC" ,nPerc,} )  //obrigatório
			aAdd( aRotAut, { "AFF_HORAI" ,"00:00",} )
			aAdd( aRotAut, { "AFF_HORAF","00:00",} )

			PMSA311Aut(aRotAut,nOpc)	
			lN++
		Enddo
	EndIf
//	ALERT("MT410INC -novo")
	cEventID := "062"
//	EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,"",ctitulo,cMesagem,.T.)
	cMessagem := "Se ha incluido el Pedido de venta: " + CVALTOCHAR(C5_NUM)
	EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,""/*cCargo*/,"Nuevo pedido de venta nro: "+ CVALTOCHAR(C5_NUM),cMessagem,.T.)

	RestArea(aArea)
return



STATIC FUNCTION BUSCC(cPedido)//,cQuant)
LOCAL cQuery:=''
LOCAL aItem:= {}

	cQuery := "SELECT AGG_CC"
	cQuery += " FROM " + RetSqlName("AGG") + " AGG "
	//cQuery += " INNER JOIN " + RetSqlName("ACQ") + " ACQ ON (ACQ_FILIAL=ACR_FILIAL AND ACQ_CODREG=ACR_CODREG) "
	cQuery += " WHERE AGG_FILIAL = '"+XFILIAL("AGG")+"'" 
	cQuery += " AND AGG_PEDIDO = '"+cPedido+"'"
	//cQuery += " AND ACQ_QUANT = '"+alltrim(str(cQuant))+"'"
	cQuery += " AND AGG.D_E_L_E_T_=' '"
	

	//ÀÄÄÄÄÄÄÄÄ Saca el Query de la consulta
	//aviso("",cQuery,{'ok'},,,,,.t.)
	//Aviso("PEdido ",cQuery,{'ok'},,,,,.t.) // NTP Prueba
	
	If !Empty(Select("TRB"))
		dbSelectArea("TRB")
		dbCloseArea()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³ Executa query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	TcQuery cQuery New Alias "TRB"
	dbSelectArea("TRB")
	dbGoTop()
	
	while !EOF()
		aadd(aItem,TRB->AGG_CC)
		dbSkip()
	EndDo
	
	//aItem :={TRB->ACR_CODPRO,TRB->ACR_LOTE}
	
RETURN(aItem)
