#Include "RwMake.ch"
#Include "TopConn.ch"
/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ  OCDATEC  บAutor  ณWalter Alvarez       Fecha 07/12/2010	   ฑฑ
				PlanPag  บModificado  ณErick Etcheverry  บ Date 04/04/2017 ฑฑ
						 บModificado  ณwico2k			 บ Date 07/07/2022 ฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑDescripcion Factura de acreedor Plan de Pagos                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIMA	                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user Function PlanPag(cCli,cDoc,cEmissao)

 //Local oReport    
// Local nOrdem := 0
 Local wnrel   := "PlanPag" // Nome default do relat๓rio em disco
 //Local tamanho := "M"
 //Local titulo  := OemToAnsi("ORDEN DE NACIONALIZACION Rev.1") //"Pick-List  (Expedicao)"
 Local cDesc1  := OemToAnsi("PLAN DE PAGOS") //"Emisso de produtos a serem separados pela expedicao, para"
 Local cDesc2  := OemToAnsi("") //"determinada faixa de pedidos."
 Local cDesc3  := ""
 Local cString := "SE1" // Alias do arquivo principal do relat๓rio para o uso de filtro
 PRIVATE cPerg   := nil // Nome da pergunte a ser exibida para o usuแrio Nota de ingreso a inventario.
 
 PRIVATE aReturn  := {"Zebrado", 1,"Administracion", 2, 2, 1, "",1} //"Zebrado"###"Administracao" // Array com as informa็๕es para a tela de configura็ใo da impressใo
 PRIVATE nomeprog := "PlanPag" //Nome do programa do relat๓rio
 PRIVATE nLastKey := 0 //Utilizado para controlar o cancelamento da impressใo do relat๓rio.
 PRIVATE nBegin   := 0
 PRIVATE aLinha   := {} //Array que contem informa็๕es para a impressใo de relat๓rios cadastrais
 PRIVATE li       := 15 //Controle das linhas de impressใo. Seu valor inicial ้ a quantidade mแxima de linhas por pแgina utilizada no relat๓rio.
 PRIVATE limite   := 132 //Quantidade de colunas no relat๓rio (80, 132, 220).
 PRIVATE lRodape  := .F.
 PRIVATE m_pag    :=1    //Controle do n๚mero de pแginas do relat๓rio.  
 PRIVATE titulo   :="PLAN DE PAGOS"

 PRIVATE cabec1   := ""
 PRIVATE cabec2   := ""
 PRIVATE tamanho  := "M" 

 aOrd :={}
		 
//ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO
//Pergunte(cPerg,.F.)		 
 wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
 
 If nLastKey == 27
  dbClearFilter()
  Return
 Endif
 
 SetDefault(aReturn,cString)
 
 If nLastKey == 27
  dbClearFilter()
  Return
 Endif
 
 RptStatus({|lEnd| OCDAT1(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3,cCli,cDoc,cEmissao)},Titulo)  

 
Return
    
//------------------------------------------------------
Static  Function OCDAT1(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3,cCli,cDoc,cEmissao)
 
/*If FindFunction("TRepInUse") .And. TRepInUse()
   	alert("r4")
Else   
    fImpInforme()        
    alert("r3")
EndIf  */ 
  fImpInforme(cCli,cDoc,cEmissao)         
 
	If aReturn[5] = 1
	  Set Printer TO
	  dbCommitAll()
	  OurSpool(wnrel)
	 EndIf
	 MS_FLUSH()  
	
Return NIL



Static Function fImpInforme(cCli,cDoc,cEmissao)
//Local nTotalcant    := 00.0
//Local nTotalval    := 00.0
nOrdem:=aReturn[8]

//msgInfo("Cliente: " + cvaltochar(cCli) + "," + "Doc: " + cvaltochar(cDoc) + "/ " + cvaltochar(cEmissao))    
//"+RetSqlName("SYA")+" SYA On B1_UPROCE=YA_CODGI "

//Plan de Pagos con Anticipo (registro nuevo)
cQuery := " SELECT A1_NOME,A1_COD ,A1_CGC A1_UCARNET,E1_PARCELA,E1_NUM,CASE WHEN E1_MOEDA = 2 THEN E1_VALOR*E1_TXMOEDA ELSE E1_VALOR END E1_VALOR,E1_VENCTO,E1_VENCREA,A1_LOJA,CASE WHEN E1_MOEDA = 2 THEN E1_SALDO*E1_TXMOEDA ELSE E1_SALDO END E1_SALDO"
cQuery += " FROM " + RETSQLNAME ("SA1") + " A1 " 
cQuery += " INNER JOIN " + RETSQLNAME ("SE1") + " E1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA"
cQuery += " WHERE A1.D_E_L_E_T_<>'*' AND E1.D_E_L_E_T_<>'*'"
cQuery += " AND A1_COD= '"+ cCli +"' "
cQuery += " AND E1_NUM= '"+ cDoc +"' "
cQuery += " AND E1_EMISSAO= '"+ DTOS(cEmissao) +"' "
cQuery += " AND E1_PARCELA <> ' ' "
cQuery += " AND E1_PREFIXO LIKE 'MO%' "
cQuery += " ORDER BY E1_VENCTO"

TCQUERY cQuery NEW ALIAS "PLAN"

If PLAN->E1_NUM = ' '
	PLAN->(DbCloseArea()) 

	//Plan de Pagos con Anticipo (registro antiguo)
	cQuery := " SELECT A1_NOME,A1_COD ,A1_CGC A1_UCARNET,E1_PARCELA,E1_NUM,CASE WHEN E1_MOEDA = 2 THEN E1_VALOR*E1_TXMOEDA ELSE E1_VALOR END E1_VALOR,E1_VENCTO,E1_VENCREA,A1_LOJA,CASE WHEN E1_MOEDA = 2 THEN E1_SALDO*E1_TXMOEDA ELSE E1_SALDO END E1_SALDO"
	cQuery += " FROM " + RETSQLNAME ("SA1") + " SA1 " 
	cQuery += " INNER JOIN " + RETSQLNAME ("SE1") + " SE1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND E1_CLIENTE = '"+ cCli +"' "
	cQuery += " WHERE SA1.D_E_L_E_T_ = ' ' AND SE1.D_E_L_E_T_ = ' ' "
	cQuery += " AND E1_EMISSAO= '"+ DTOS(cEmissao) +"' "	
	cQuery += " AND E1_NUM LIKE '%#"+ ALLTRIM(STR(VAL(cDoc))) +".' "
	cQuery += " AND E1_PARCELA <> ' ' "
	cQuery += " OR E1_NUM LIKE '%#"+ ALLTRIM(STR(VAL(cDoc))) +"' "
	cQuery += " AND E1_PREFIXO = 'MOD' "
	cQuery += " ORDER BY E1_VENCTO"

	TCQUERY cQuery NEW ALIAS "PLAN"
EndIf

If PLAN->E1_NUM = ' '
	PLAN->(DbCloseArea()) 

	//Plan de Pagos sin Anticipo
	cQuery := " SELECT A1_NOME,A1_COD ,A1_CGC A1_UCARNET,E1_PARCELA,E1_NUM,CASE WHEN E1_MOEDA = 2 THEN E1_VALOR*E1_TXMOEDA ELSE E1_VALOR END E1_VALOR,E1_VENCTO,E1_VENCREA,A1_LOJA,CASE WHEN E1_MOEDA = 2 THEN E1_SALDO*E1_TXMOEDA ELSE E1_SALDO END E1_SALDO"
	cQuery += " FROM " + RETSQLNAME ("SA1") + " A1 " 
	cQuery += " INNER JOIN " + RETSQLNAME ("SE1") + " E1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA"
	cQuery += " WHERE A1.D_E_L_E_T_<>'*' AND E1.D_E_L_E_T_<>'*'"
	cQuery += " AND A1_COD= '"+ cCli +"' "
	cQuery += " AND E1_NUM= '"+ cDoc +"' "
	cQuery += " AND E1_EMISSAO= '"+ DTOS(cEmissao) +"' "
	cQuery += " ORDER BY E1_VENCTO"

	TCQUERY cQuery NEW ALIAS "PLAN"
EndIf

If __CUSERID = '000000' .OR. cUserName = 'nterrazas' .OR. cUserName = 'jbravo'
	Aviso("Query PlanPag",cQuery,{'ok'},,,,,.T.)
EndIf

 nTotal	:=0
 nCuotas:=0
 nImpoPa:=0
 nSaldo	:=0
 While PLAN->(!EOF())    
	nTotal	:= nTotal  + PLAN->E1_VALOR
	nImpoPa	:= nImpoPa + (PLAN->E1_VALOR - PLAN->E1_SALDO)
	nSaldo	:= nSaldo  + PLAN->E1_SALDO
	nCuotas++ 
	PLAN->(dbSkip())   
 End     
  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
  
  PLAN->(DbGoTop())  

 // alert(li)
  li :=17
  j:=1    
      
//D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL
 While PLAN->(!EOF())    
 		
 	If (j==1)
 		fImpCab(nTotal,nCuotas) // IMPRIME LA CABECERA
 	End
 //	If (empty(PLAN->E1_PARCELA))
 		 @ li,04 PSAY  strzero(j,2)
 	//else
 		//@ li,04 PSAY PLAN->E1_PARCELA
 	//End
	 //@ li,15 PSAY DTOC(STOD(PLAN->E1_VENCTO)) 						
	@ li,15 PSAY DTOC(STOD(PLAN->E1_VENCREA))
//	@ li,45 PSAY TRANSFORM(PLAN->E1_VALOR,"@E 999,999,999")	//RS
	@ li,35 PSAY TRANSFORM(PLAN->E1_VALOR,"@E 999,999.99")
/*	@ li,60 PSAY TRANSFORM(PLAN->E1_SALDO,"@E 999,999,999")
	 
	 IF(PLAN->E1_SALDO == 0)
	   	@ li,80 PSAY " Cancelado"
	 ELSE
	 	if (DDATABASE>STOD(PLAN->E1_VENCREA))
	 		@ li,80 PSAY " Vencido"												
	 	end
	 	if (DDATABASE<=STOD(PLAN->E1_VENCREA))
	   		@ li,80 PSAY " A Vencer"
	 	end
	 END*/
	@ li,55 PSAY TRANSFORM((PLAN->E1_VALOR - PLAN->E1_SALDO),"@E 999,999.99")
	@ li,77 PSAY TRANSFORM(PLAN->E1_SALDO,"@E 999,999.99")
	 
	
    li++   
    j++ 
    PLAN->(dbSkip())   
 End     
 @ li,02 PSAY REPLICATE('_',130)
 
 li++
 @ li,20 PSAY " T O T A L : Bs"
 @ li,35 PSAY TRANSFORM(nTotal ,"@E 999,999.99")
 @ li,55 PSAY TRANSFORM(nImpoPa,"@E 999,999.99")
 @ li,77 PSAY TRANSFORM(nSaldo ,"@E 999,999.99")
 
 li++
 li++
 li++
 li++
 @ li,52 PSAY "_____________________"
 li++
 @ li,55 PSAY "Firma Cliente"
 
 //total( nTotalval)	
 // total( nTotalval,moneda,MV_PAR07,li,fpag)	
 PLAN->(DbCloseArea()) 
//lert("chau")
Return
 

Static Function fImpCab(nTotal,nCuotas)
 //SetPrc(0,0)                
	cUsuario:=RetCodUsr() 
	nomusuario:=Subst(cUsuario,7,13)

	@ 006,03 PSAY "Modalidad: Financiado" 
	@ 007,03 PSAY "C๓digo Cliente: " + PLAN->A1_COD
	@ 008,03 PSAY "Nombre: " + PLAN->A1_NOME
//@ 009,03 PSAY "Fecha Alta: " + DTOC(POSICIONE('MA7',1,XFILIAL('MA7')+PLAN->(A1_COD+A1_LOJA),'MA7_DATA'))
	@ 009,03 PSAY "Importe: " + TRANSFORM(nTotal,"@E 999,999.99")
	@ 010,03 PSAY "Cantidad Cuotas: " + Alltrim(str(nCuotas))
	@ 011,03 PSAY "Numero Doc: " + PLAN->E1_NUM
	@ 012,03 PSAY "Numero CI: " + PLAN->A1_UCARNET
//	@ 008,02 PSAY Substr(OrdenesCom->YA_SIGLA,1,6)
//	@ 006,90 PSAY "Fecha: " + ffechalatin(OrdenesCom->f1_EMISSAO) 
//	@ 007,90 PSAY "Hora: " 
//	@ 009,60 PSAY "Nro: "  + OrdenesCom->F1_DOC
//	@ 009,02 PSAY "Usuario: "
	@ 014,02 PSAY REPLICATE('_',130)  

	@ 015,03 PSAY "Nro." 
//	@ 015,09 PSAY "Fecha de Vencimiento"  						
	@ 015,10 PSAY "Fecha de Venc. Real"
	@ 015,37 PSAY "Importe Cuota"
//	@ 015,72 PSAY "Estado"	//RS
//	@ 015,61 PSAY "Saldo por Pagar"
//	@ 015,82 PSAY "Estado"
	@ 015,57 PSAY "Importe Pagado"
	@ 015,83 PSAY "Saldo"
 																			
	@ 016,02 PSAY REPLICATE('_',130)    												
return		 
//
//
//Static function total( _nTotalVal,moneda,cambio,li,fpago)
//mone:=""	  
//if cambio=1
// mone:="$Bs"
//else
// mone:="$Us" 	
//endif 
// impuestos:=0
// li:=li+3                 
// @ li, 105 PSAY "Neto: "
// @ li, 009 PSAY "Fecha de Vencimiento: " 
// //@ li, 115 Psay _nTotalVal Picture "@E 99,999,999"      // Total 
// @ li, 115 Psay XMOEDA(_nTotalVal,moneda,cambio,DDATABASE) Picture "@E 99,999,999"   
//  li++
// @ li, 008 PSAY "Empleado del Dpto de Ventas:
// @ li, 105 PSAY "Impuestos: " 
// @ li, 116 PSAY impuestos Picture "@E 99,999"  
//  li++                       
// @ li, 105 PSAY "Total:"   
// @ li, 009 PSAY "Condiciones de Pago: " + fpago
//// @ li, 115 Psay _nTotalVal Picture "@E 99,999,999"      // fTotal  
// @ li, 115 Psay XMOEDA(_nTotalVal,moneda,cambio,DDATABASE) Picture "@E 99,999,999"      // Total 
// @ li, 130 PSAY mone
// li:=li+2
// @ li, 105 PSAY "Pagado: " 
// li++    
// @ li, 105 PSAY "Saldo pendiente: "  
//return

///*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
//ฑฑบPrograma  ณValidPerg บAutor  ณ Walter Alvarez ณ  04/11/2010   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
//*/
//
//Static Function ValidPerg()
//
//Local _sAlias := Alias()
//Local aRegs := {}
//Local i,j
//
//dbSelectArea("SX1")
//dbSetOrder(1)
//cPerg := PADR(cPerg,10)
//
//aAdd(aRegs,{"01","Cliente        :","mv_ch1","C",10,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,"SA1",""})
//aAdd(aRegs,{"02","Factura        :","mv_ch2","C",13,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"",""})
//aAdd(aRegs,{"03","Fecha Emisi๓n        :","mv_ch3","D",08,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,"",""})
//
//dbSelectArea("SX1")
//dbSetOrder(1)
//For i:=1 to Len(aRegs)
//   dbSeek(cPerg+aRegs[i][1])
//   If !Found()
//      RecLock("SX1",!Found())
//         SX1->X1_GRUPO    := cPerg
//         SX1->X1_ORDEM    := aRegs[i][01]
//         SX1->X1_PERSPA   := aRegs[i][02]
//         SX1->X1_VARIAVL  := aRegs[i][03]
//         SX1->X1_TIPO     := aRegs[i][04]
//         SX1->X1_TAMANHO  := aRegs[i][05]
//         SX1->X1_DECIMAL  := aRegs[i][06]
//         SX1->X1_PRESEL   := aRegs[i][07]
//         SX1->X1_GSC      := aRegs[i][08]
//         SX1->X1_VAR01    := aRegs[i][09]
//         SX1->X1_DEFSPA1    := aRegs[i][10]
//         SX1->X1_DEFSPA2    := aRegs[i][11]
//         SX1->X1_DEFSPA3    := aRegs[i][12]
//         SX1->X1_DEFSPA4    := aRegs[i][13]
//         SX1->X1_F3       := aRegs[i][14]
//         SX1->X1_VALID    := aRegs[i][15]   
//         
//      MsUnlock()
//   Endif
//Next
//
//Return    
//  
//Return
