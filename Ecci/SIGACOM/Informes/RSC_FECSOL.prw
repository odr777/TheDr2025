#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ CxPGla  º Autor ³ Amby Arteaga Rivero   º Data ³  28/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Reporte de Solicitudes con fecha de Solicitud, fecha de      º±±
±±º          ³ necesidad y fecha de entrega del proveedor (SC, PC y Remito)	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                        	        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#DEFINE C1FILIAL  1
#DEFINE C1NUM     2
#DEFINE C1ITEM    3
#DEFINE C1PRODUTO 4
#DEFINE C1DESCRI  5
#DEFINE C1UM      6
#DEFINE C1EMISSAO 7
#DEFINE C1DATPRF  8
#DEFINE C1QUANT   9
#DEFINE C7DATPRF  10
#DEFINE C7QUANT   11
#DEFINE C7PRECO   12
#DEFINE C7TOTAL   13
#DEFINE C7OBS     14
#DEFINE A2NOME    15
#DEFINE C7NUM     16
#DEFINE C7ITEM    17
#DEFINE D1DOC     18
#DEFINE D1ITEM    19
#DEFINE D1EMISSAO 20
#DEFINE D1QUANT   21
#DEFINE D1VUNIT   22
#DEFINE D1TOTAL   23
#DEFINE C7MOEDA   24
#DEFINE C7TXMOEDA 25
#DEFINE C7EMISSAO 26
#DEFINE C7TIPCOM  27
#DEFINE C7FORNECE 28
#DEFINE A2PAIS    29
#DEFINE YADESCR   30
#DEFINE C7CODTAB  31
#DEFINE D1LOTECTL 32
#DEFINE D1ITEMCTA 33
#DEFINE B1TIPO    34
#DEFINE X5DESCRI  35
#DEFINE F1NATUREZ 36
#DEFINE F1SERIE   37
#DEFINE F1UNOME 38
#DEFINE C7UNLIMAT 39
#DEFINE C7TIPO    40
#DEFINE C7CC	  41
#DEFINE UOBSERV	  42
#DEFINE C7ITEMCTA	  43
#DEFINE C7UCLASPR	  44
#DEFINE D1DTDIGIT 45
#DEFINE CODNATUREZ 46


User Function RSC_FECSOL()
	Local oReport
	
	If FindFunction("TRepInUse") .And. TRepInUse()
//	pergunte("RGtoImport",.T.)
		CargarPerg()
	
	Pergunte("RSC_FECS",.F.)
	
	
		oReport := ReportDef()
		oReport:PrintDialog()
	Endif
Return Nil

Static Function ReportDef()
	Local oReport  
	Local oSection
	Local cPerg
	Local nTam, nTamVal, cPictVal, nTamComp
	cPerg := ("RSC_FECS")
	
	nTam	:= 130
	nTamVal	:= TamSX3("C7_TOTAL")[1]
	cPictVal	:= PesqPict("SC7","C7_TOTAL")
	nTamComp := 20
	oReport := TReport():New("RSCFECSOL","SOLICITUDES CON FECHA SOLICITUD, NECESIDAD Y DE ENTREGA",cPerg,{|oReport| ReportPrint(oReport,nTamVal)},"Este programa tiene como objetivo imprimir el estado de las solicitudes "+"de acuerdo con los parametros indicados por el usuario")
	
	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.	
	
	pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01  	      	// Tipo de Reporte                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection := TRSection():New(oReport,"SOLICITUD_COMPRA",,)

		TRCell():New(oSection,"C1_NUM","SC1","Nro.SC") 
		TRCell():New(oSection,"C1_ITEM","SC1","Item")
		TRCell():New(oSection,"C1_PRODUTO","SC1","Producto")
		TRCell():New(oSection,"C1_DESCRI","SC1","Descripcion",,40,.F.,)
		TRCell():New(oSection,"C1_UM","SC1","U/M")
		TRCell():New(oSection,"B1_TIPO","SB1","Tipo")
		TRCell():New(oSection,"X5_DESCRI","SX5","Descr.Tipo")
		TRCell():New(oSection,"C1_EMISSAO","SC1","Fch Emision",PesqPict("SC1","C1_EMISSAO"),10,.F.,)
		TRCell():New(oSection,"C1_DATPRF","SC1","Necesidad",PesqPict("SC1","C1_DATPRF"),10,.F.,)
		TRCell():New(oSection,"C1_QUANT","SC1","Cnt Pedida")
		TRCell():New(oSection,"C7_TIPCOM","SC7","Tipo Compra")
		TRCell():New(oSection,"C7_EMISSAO","S71","Fch Emis.",PesqPict("SC7","C7_EMISSAO"),10,.F.,)
		TRCell():New(oSection,"C7_DATPRF","SC7","Fch Entrega",PesqPict("SC7","C7_DATPRF"),10,.F.,)
		TRCell():New(oSection,"C7_QUANT","SC7","Cnt Comprada")
		TRCell():New(oSection,"C7_PRECO","SC7","Prc.Unitario")
		TRCell():New(oSection,"C7_TOTAL","SC7","Valor Total",cPictVal,nTamVal,.F.,)
		TRCell():New(oSection,"C7_OBS","SC7","Observacion",,40,.F.,)
		TRCell():New(oSection,"C7_TIPO","SC7","Tipo Pedido")
		TRCell():New(oSection,"C7_FORNECE","SC7","Cod.Prov")
		TRCell():New(oSection,"A2_NOME","SA2","Proveedor",,40,.F.,)
		TRCell():New(oSection,"A2_PAIS","SA2","Pais")
		TRCell():New(oSection,"YA_DESCR","SYA","Desc.Pais")
		TRCell():New(oSection,"C7_CC","SC7","CC")
		TRCell():New(oSection,"C7_NUM","SC7","Nr.PedCompra") 
		TRCell():New(oSection,"C7_ITEM","SC7","It.Ped")
		TRCell():New(oSection,"C7_CODTAB","SC7","L.Precio")
		TRCell():New(oSection,"F1_NATUREZ","SF1","Cod Naturaleza")
		TRCell():New(oSection,"ED_DESCRIC","SED","Naturaleza") 
		TRCell():New(oSection,"F1_SERIE","SF1","Serie") 
		TRCell():New(oSection,"D1_DOC","SD1","Doc Remito") 
		TRCell():New(oSection,"D1_ITEM","SD1","It.Rem")
		TRCell():New(oSection,"D1_EMISSAO","SD1","Fch Remito",PesqPict("SD1","D1_EMISSAO"),10,.F.,)
		TRCell():New(oSection,"C7_MOEDA","SC7","Mon")
		TRCell():New(oSection,"C7_TXMOEDA","SC7","Tasa Moneda",PesqPict("SC7","C7_TXMOEDA"),TamSX3("C7_TXMOEDA")[1],.F.,) 
		TRCell():New(oSection,"D1_LOTECTL","SD1","Lote")
		TRCell():New(oSection,"D1_ITEMCTA","SD1","Item Cta")
		TRCell():New(oSection,"D1_QUANT","SD1","Cnt Remito")
		TRCell():New(oSection,"C7_UNLIMAT","SD1","List. Materiales")
		TRCell():New(oSection,"C7_UCLASPR","SD1","Clase Prod")
		TRCell():New(oSection,"D1_UOBSERV","SD1","RCN Observaciones")
		TRCell():New(oSection,"C7_ITEMCTA","SC7","Item cta ped")
		TRCell():New(oSection,"D1_DTDIGIT","SD1","Fec Digit.",PesqPict("SD1","D1_EMISSAO"),10,.F.,)
		TRCell():New(oSection,"D1_VUNIT","SD1","Valor Unit.")
		TRCell():New(oSection,"D1_TOTAL","SD1","Valor Total",cPictVal,nTamVal,.F.,)
		

Return oReport
 	
Static Function ReportPrint(oReport,nTamVal)
	Local oSection  := oReport:Section(1)
	Local aDados[47]
	Local nPos
	Local cLinha
	Local cString     := "SC1"
	Local dDtChave          := CTOD(SPACE(8))
	Local cArqTrab, cChave
	Local dDataMoeda := dDataBase
	Local lQuery:=.F.
	Local lRABaixado:=.F.
	Local lEstorno := .F.
	Local cChaveSeq := ""
	Local cDeCliente,cAteCliente,nConsidera,dDataDe,dDataAte,nEvaluar,nSaldos,cDeModalid,cAteModalid,nMoeda  
	lOcal cAliasQry := ""
	Private cTipos  // Usada por la funcion FinrTipos().
	
//	oSection:Cell("C1_FILIAL"):SetBlock( { || aDados[C1FILIAL] })
	oSection:Cell("C1_NUM"):SetBlock( { || aDados[C1NUM] })
	oSection:Cell("C1_ITEM"):SetBlock( { || aDados[C1ITEM] })
	oSection:Cell("C1_PRODUTO"):SetBlock( { || aDados[C1PRODUTO] })
	oSection:Cell("C1_DESCRI"):SetBlock( { || aDados[C1DESCRI] })
	oSection:Cell("C1_UM"):SetBlock( { || aDados[C1UM] })
	oSection:Cell("B1_TIPO"):SetBlock( { || aDados[B1TIPO] })
	oSection:Cell("X5_DESCRI"):SetBlock( { || aDados[X5DESCRI] })
	oSection:Cell("C1_EMISSAO"):SetBlock( { || aDados[C1EMISSAO] })
	oSection:Cell("C1_DATPRF"):SetBlock( { || aDados[C1DATPRF] })
	oSection:Cell("C1_QUANT"):SetBlock( { || aDados[C1QUANT] })
	oSection:Cell("C7_TIPCOM"):SetBlock( { || aDados[C7TIPCOM] })
	oSection:Cell("C7_EMISSAO"):SetBlock( { || aDados[C7EMISSAO] })
	oSection:Cell("C7_DATPRF"):SetBlock( { || aDados[C7DATPRF] })
	oSection:Cell("C7_QUANT"):SetBlock( { || aDados[C7QUANT] })
	oSection:Cell("C7_PRECO"):SetBlock( { || aDados[C7PRECO] })
	oSection:Cell("C7_TOTAL"):SetBlock( { || aDados[C7TOTAL] })
	oSection:Cell("C7_OBS"):SetBlock( { || aDados[C7OBS] })
	oSection:Cell("C7_FORNECE"):SetBlock( { || aDados[C7FORNECE] })
	oSection:Cell("A2_NOME"):SetBlock( { || aDados[A2NOME] })
	oSection:Cell("C7_CC"):SetBlock( { || aDados[C7CC] })
	oSection:Cell("A2_PAIS"):SetBlock( { || aDados[29] })
	oSection:Cell("YA_DESCR"):SetBlock( { || aDados[YADESCR] })
	oSection:Cell("C7_NUM"):SetBlock( { || aDados[C7NUM] })
	oSection:Cell("C7_ITEM"):SetBlock( { || aDados[C7ITEM] })
	oSection:Cell("C7_CODTAB"):SetBlock( { || aDados[C7CODTAB] })
	oSection:Cell("F1_NATUREZ"):SetBlock( { || aDados[CODNATUREZ] })
	oSection:Cell("ED_DESCRIC"):SetBlock( { || aDados[F1NATUREZ] })
	oSection:Cell("F1_SERIE"):SetBlock( { || aDados[F1SERIE] })
	oSection:Cell("D1_DOC"):SetBlock( { || aDados[D1DOC] })
	oSection:Cell("D1_ITEM"):SetBlock( { || aDados[D1ITEM] })
	oSection:Cell("D1_EMISSAO"):SetBlock( { || aDados[D1EMISSAO] })
	oSection:Cell("C7_MOEDA"):SetBlock( { || aDados[C7MOEDA] })
	oSection:Cell("C7_TXMOEDA"):SetBlock( { || aDados[C7TXMOEDA] })
	oSection:Cell("D1_LOTECTL"):SetBlock( { || aDados[D1LOTECTL] })
	oSection:Cell("D1_ITEMCTA"):SetBlock( { || aDados[D1ITEMCTA] })
	oSection:Cell("D1_QUANT"):SetBlock( { || aDados[D1QUANT] })
	oSection:Cell("D1_UOBSERV"):SetBlock( { || aDados[UOBSERV] })
	oSection:Cell("C7_ITEMCTA"):SetBlock( { || aDados[C7ITEMCTA] })
	oSection:Cell("C7_UCLASPR"):SetBlock( { || aDados[C7UCLASPR] })
	oSection:Cell("D1_VUNIT"):SetBlock( { || aDados[D1VUNIT] })
	oSection:Cell("D1_TOTAL"):SetBlock( { || aDados[D1TOTAL] })
    oSection:Cell("C7_UNLIMAT"):SetBlock( { || aDados[C7UNLIMAT] })
	oSection:Cell("D1_DTDIGIT"):SetBlock( { || aDados[D1DTDIGIT] })
	oSection:Cell("C1_DESCRI"):SetLineBreak(.T.)		//Salto de linea para la descripcion
	oSection:Cell("C7_OBS"):SetLineBreak(.T.)		//Salto de linea para la observacion
	oSection:Cell("A2_NOME"):SetLineBreak(.T.)		//Salto de linea para el proveedor
	
	cQuery:= " SELECT DECODE(C7_UCLASPR, '1', 'Estruct.','2', 'Comerciales','3', 'Consumos','4', 'Servicios','5','Bienes Pat.','6','Insumos','7','Recursos','8','Manos de obra',' ') C7_UCLASPR , "
	cQuery+= " C1_FILIAL,C1_NUM,C1_ITEM,C1_PRODUTO,C1_DESCRI,C1_UM,C1_EMISSAO,C1_DATPRF,C1_QUANT,C7_DATPRF,C7_UNLIMAT,C7_QUANT,C7_PRECO, C7_CC,C7_TOTAL,C7_OBS,C7_NUM,C7_ITEM,C7_MOEDA,C7_TXMOEDA,C7_TIPO, C7_EMISSAO,C7_FORNECE,C7_CODTAB,C7_UTIPCOM,C7_ITEMCTA, "
	cQuery+= " A2_PAIS,A2_NOME,F1_NATUREZ, F1_SERIE,D1_DTDIGIT,D1_DOC,D1_ITEM,D1_EMISSAO,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_LOTECTL,D1_ITEMCTA,D1_TP,D1_UOBSERV "
	cQuery+= " FROM "+ RetSQLname('SC1') + " SC1 LEFT JOIN "+ RetSQLname('SC7') + " SC7 "
	cQuery+= " ON C1_FILIAL=C7_FILIAL AND C1_NUM=C7_NUMSC AND C1_ITEM=C7_ITEMSC AND C1_EMISSAO BETWEEN '" + Dtos(mv_par01) + "' AND '" + Dtos(mv_par02) + "' "
	cQuery+= " LEFT JOIN "+ RetSQLname('SA2') + " SA2 ON C1_FORNECE = A2_COD AND C1_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	cQuery+= " LEFT JOIN "+ RetSQLname('SD1') + " SD1 ON C1_FILIAL=D1_FILIAL AND C7_NUM=D1_PEDIDO AND C7_ITEM=D1_ITEMPC AND C7_FORNECE=D1_FORNECE AND C7_LOJA=D1_LOJA AND D1_ESPECIE = 'RCN' AND SD1.D_E_L_E_T_ = ' ' AND D1_TP BETWEEN '" +(mv_par03)+ "' AND '"+(mv_par04)+"'"
	cQuery+= " LEFT JOIN "+ RetSQLname('SF1') + " SF1 ON C1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE = F1_SERIE AND SF1.D_E_L_E_T_ = ' ' AND F1_NATUREZ BETWEEN '" +(mv_par05)+ "' AND '"+(mv_par06)+"'"
	cQuery+= " AND SC1.D_E_L_E_T_ = ' ' AND SC7.D_E_L_E_T_ = ' ' "
	cQuery+= " ORDER BY C1_NUM,C1_ITEM"
	
	
	cQuery := ChangeQuery(cQuery)
	
	TCQUERY cQuery NEW ALIAS "TMP"	
	
	If __CUSERID = '000000' .OR. cUserName = 'nterrazas'
		AVISO("RSC_FECSOL",cQuery,{"ok"},,,,,.t.)
	EndIf

	IF TMP->(!EOF()) .AND. TMP->(!BOF())
		TMP->(dbGoTop())                            
	end

	m_pag:=1
	oSection:Init()
	aFill(aDados,nil)
	
	oReport:SetMeter(TMP->(RecCount()))
	nTotCantSol := 0
	nTotCantCom := 0
	nTotalCom := 0
	nTotCantRem := 0
	nTotalRem := 0
	
	While TMP->(!Eof()) 
	#IFDEF TOP
		lQuery:=.T.
//		aDados[C1FILIAL] := TMP->C1_FILIAL
		aDados[C1NUM] := TMP->C1_NUM
		aDados[C1ITEM] := TMP->C1_ITEM
		aDados[C1PRODUTO] := TMP->C1_PRODUTO
		aDados[C1DESCRI] := TMP->C1_DESCRI
		aDados[C1UM] := TMP->C1_UM
		aDados[B1TIPO] := GetAdvFVal("SB1","B1_TIPO",xFilial("SB1")+TMP->C1_PRODUTO,1," ")
		aDados[X5DESCRI] := GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"02"+aDados[B1TIPO],1," ")
		aDados[C1EMISSAO] := RIGHT(TMP->C1_EMISSAO,2)+"/"+SUBSTR(TMP->C1_EMISSAO,5,2)+"/"+LEFT(TMP->C1_EMISSAO,4)
		aDados[C1DATPRF] := RIGHT(TMP->C1_DATPRF,2)+"/"+SUBSTR(TMP->C1_DATPRF,5,2)+"/"+LEFT(TMP->C1_DATPRF,4)
		aDados[C7CC] := TMP->C7_CC
		aDados[C1QUANT] := TMP->C1_QUANT
		aDados[C7TIPCOM] := If(TMP->C7_UTIPCOM=="L","Local",If(TMP->C7_UTIPCOM=="I","Importación",If(TMP->C7_UTIPCOM=="S","Servicio",If(TMP->C7_UTIPCOM=="T","Transporte","No definido"))))
		aDados[C7EMISSAO] := RIGHT(TMP->C7_EMISSAO,2)+"/"+SUBSTR(TMP->C7_EMISSAO,5,2)+"/"+LEFT(TMP->C7_EMISSAO,4)
		aDados[C7DATPRF] := RIGHT(TMP->C7_DATPRF,2)+"/"+SUBSTR(TMP->C7_DATPRF,5,2)+"/"+LEFT(TMP->C7_DATPRF,4)
		aDados[C7QUANT] := TMP->C7_QUANT
		aDados[C7PRECO] := TMP->C7_PRECO
		aDados[C7TOTAL] := TMP->C7_TOTAL
		aDados[C7OBS] := TMP->C7_OBS
		aDados[C7FORNECE] := TMP->C7_FORNECE
		aDados[A2PAIS] := TMP->A2_PAIS
		aDados[YADESCR] := GetAdvFVal("SYA","YA_DESCR",xFilial("SYA")+TMP->A2_PAIS,1," ")
		aDados[A2NOME] := TMP->A2_NOME
		aDados[C7NUM] := TMP->C7_NUM
		aDados[C7ITEM] := TMP->C7_ITEM
		aDados[C7CODTAB] := TMP->C7_CODTAB
		aDados[CODNATUREZ] := TMP->F1_NATUREZ
		aDados[F1NATUREZ] := GetAdvFVal("SED","ED_DESCRIC",xFilial("SED")+TMP->F1_NATUREZ,1," ")
		aDados[F1SERIE] := TMP->F1_SERIE
//		aDados[F1UNOME] := TMP->F1_UNOME
		aDados[D1DOC] := TMP->D1_DOC
		aDados[D1ITEM] := TMP->D1_ITEM
		aDados[D1EMISSAO] := RIGHT(TMP->D1_EMISSAO,2)+"/"+SUBSTR(TMP->D1_EMISSAO,5,2)+"/"+LEFT(TMP->D1_EMISSAO,4)
		aDados[C7MOEDA] := TMP->C7_MOEDA
		aDados[C7TXMOEDA] := TMP->C7_TXMOEDA
		aDados[D1LOTECTL] := TMP->D1_LOTECTL
		aDados[D1ITEMCTA] := TMP->D1_ITEMCTA
		aDados[UOBSERV] := TMP->D1_UOBSERV
		aDados[C7ITEMCTA] := TMP->C7_ITEMCTA
		aDados[C7UCLASPR] := TMP->C7_UCLASPR
		aDados[C7UNLIMAT] := TMP->C7_UNLIMAT
		aDados[D1DTDIGIT] := TMP->D1_DTDIGIT
		aDados[D1QUANT] := TMP->D1_QUANT
		aDados[D1VUNIT] := TMP->D1_VUNIT
		aDados[D1TOTAL] := TMP->D1_TOTAL
	 	nTotCantSol +=	aDados[C1QUANT]
	 	nTotCantCom +=	aDados[C7QUANT]
	 	nTotalCom +=	aDados[C7TOTAL]
	 	nTotCantRem +=	aDados[D1QUANT]
	 	nTotalRem +=	aDados[D1TOTAL]
	 		
		oSection:PrintLine()
	   	aFill(aDados,nil)
	
		TMP->(DbSkip())       // Avanza el puntero del registro en el archivo
	
		#ELSE
		 //	DbSeek(xFilial(cString)+cDeCliFor,.T.)
		#ENDIF
	End
	nRow := oReport:Row()
	oReport:PrintText(Replicate("_",240), nRow, 10) // uDesc)

	oReport:SkipLine()
	
	aDados[C1DESCRI] := "TOTAL GENERAL: "
	aDados[C1QUANT] := nTotCantSol
	aDados[C7QUANT] := nTotCantCom
	aDados[C7TOTAL] := nTotalCom
	aDados[D1QUANT] := nTotCantRem
	aDados[D1TOTAL] := nTotalRem

	oSection:PrintLine()
	aFill(aDados,nil)       
//	oReport:SkipLine()
	nRow := oReport:Row()
	oReport:PrintText(Replicate("=",240), nRow, 10) // uDesc)
	oReport:IncMeter()
	
	oSection:Finish()
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indice ou consulta(Query)                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP
			TMP->(dbCloseArea())
		#ENDIF
		oReport:EndPage()
//		TMP->(DbSkip())       // Avanza el puntero del registro en el archivo

Return Nil


Static Function CargarPerg()
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR("RSC_FECS",10)
	aRegs:={}
	i:=1
	
	aAdd(aRegs,{"01","Fecha Solicitud Inicial: ","mv_ch1","D",8,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""}) 
	aAdd(aRegs,{"02","Fecha Solicitud Final  : ","mv_ch2","D",8,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""}) 
	aAdd(aRegs,{"03","De Tipo de Producto:","mv_ch3","C",2,0,0,"G","mv_par03",""       ,""        ,""        ,""     ,"02"   ,""})
	aAdd(aRegs,{"04","A Tipo de Producto:","mv_ch4","C",2,0,0,"G","mv_par04",""       ,""        ,""        ,""     ,"02"   ,""})
	aAdd(aRegs,{"05","De Naturaleza:","mv_ch5","C",10,0,0,"G","mv_par05",""       ,""        ,""        ,""     ,"SED"   ,""})
	aAdd(aRegs,{"06","A Naturaleza:","mv_ch6","C",10,0,0,"G","mv_par06",""       ,""        ,""        ,""     ,"SED"   ,""})
	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
	   dbSeek(cPerg+aRegs[i][1])
	   If !Found()
	      RecLock("SX1",!Found())
	         SX1->X1_GRUPO    := cPerg
	         SX1->X1_ORDEM    := aRegs[i][01]
	         SX1->X1_PERSPA   := aRegs[i][02]
	         SX1->X1_VARIAVL  := aRegs[i][03]
	         SX1->X1_TIPO     := aRegs[i][04]
	         SX1->X1_TAMANHO  := aRegs[i][05]
	         SX1->X1_DECIMAL  := aRegs[i][06]
	         SX1->X1_PRESEL   := aRegs[i][07]
	         SX1->X1_GSC      := aRegs[i][08]
	         SX1->X1_VAR01    := aRegs[i][09]
	         SX1->X1_DEFSPA1  := aRegs[i][10]
	         SX1->X1_DEFSPA2  := aRegs[i][11]
	         SX1->X1_DEFSPA3  := aRegs[i][12]
	         SX1->X1_DEFSPA4  := aRegs[i][13]
	         SX1->X1_F3       := aRegs[i][14]
	         SX1->X1_VALID    := aRegs[i][15]
	      MsUnlock()
	   Endif
	Next
Return
