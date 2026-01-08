#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
	Factura de Entrada
*/
User Function FacEnt()


 Local oReport    
 Local nOrdem  := 0
 Local wnrel   := "UFacEnt" // Nome default do relatorio em disco
 //Local tamanho := "M"
 //Local titulo  := OemToAnsi("ORDEN DE NACIONALIZACION Rev.1") //"Pick-List  (Expedicao)"
 Local cDesc1  := OemToAnsi("Factura de Entrada") //"Emissao de produtos a serem separados pela expedicao, para"
 Local cDesc2  := OemToAnsi("") //"determinada faixa de pedidos."
 Local cDesc3  := ""
 Local cString := "SF1" // Alias do arquivo principal do relatório para o uso de filtro
 PRIVATE cPerg := "FASAL" // Nome da pergunte a ser exibida para o usuário Nota de ingreso a inventario.
 
 PRIVATE aReturn  := {"Zebrado", 1,"Administracion", 2, 2, 1, "",1} //"Zebrado"###"Administracao" // Array com as informações para a tela de configuração da impressão
 PRIVATE nomeprog := "UFacEnt" //Nome do programa do relatório
 PRIVATE nLastKey := 0 //Utilizado para controlar o cancelamento da impressão do relatório.
 PRIVATE nBegin   := 0
 PRIVATE aLinha   := {} //Array que contem informações para a impressão de relatórios cadastrais
 PRIVATE li       := 15 //Controle das linhas de impressão. Seu valor inicial é a quantidade máxima de linhas por página utilizada no relatório.
 PRIVATE limite   := 132 //Quantidade de colunas no relatório (80, 132, 220).
 PRIVATE lRodape  := .F.
 PRIVATE m_pag    := 1    //Controle do número de páginas do relatório.  
 PRIVATE titulo   := "FACTURA DE ENTRADA"

 PRIVATE cabec1   := ""
 PRIVATE cabec2   := ""
 PRIVATE tamanho  := "M" 

 aOrd :={}
		 
 ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO
		 
 
 GraContPert()   
 If UPPER(funname()) == 'MATA101N'
    pergunte(cPerg,.F.)
   
 else
     pergunte(cPerg,.T.)         
 End
 
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
 
 RptStatus({|lEnd| OCDAT1(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)  

 
Return
    
//------------------------------------------------------
Static  Function OCDAT1(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)
 fImpInforme()         
If aReturn[5] = 1
	Set Printer TO
  	dbCommitAll()
  	OurSpool(wnrel)
EndIf
MS_FLUSH()  
Return NIL



Static Function fImpInforme()
Local nTotalcant	:= 00.0
Local nTotalval    	:= 00.0

nOrdem := aReturn[8]

cQuery := "Select Distinct F1_DOC,F1_SERIE,F1_FORNECE,F1_EMISSAO,F1_REMITO, F1_DESCONT, F1_VALMERC, F1_VALBRUT, B1_DESC,A1_NOME,"
cQuery += "D1_ITEM,D1_COD,D1_UM,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_PEDIDO,F1_NUMRA,A2_NOME,F1_MOEDA,E4_DESCRI,YA_DESCR,YA_SIGLA,A2_PAIS,D1_CC,D1_ITEMCTA,F1_NUMAUT,F1_CODCTR,F1_USRREG,D1_TES  "
cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
cQuery += " INNER JOIN " +RetSqlName("SD1") + " SD1 ON F1_DOC = D1_DOC AND F1_FILIAL = D1_FILIAL AND F1_SERIE = D1_SERIE AND SD1.D_E_L_E_T_ <> '*'  AND F1_FORNECE = D1_FORNECE"
cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON RTRIM(LTRIM(B1_COD)) = RTRIM(LTRIM(D1_COD)) AND SB1.D_E_L_E_T_ <> '*'  "
cQuery += " LEFT OUTER JOIN " + RetSqlName("SC7") + " SC7 ON D1_PEDIDO=C7_NUM AND D1_ITEMPC=C7_ITEM AND SD1.D_E_L_E_T_ <> '*' and F1_FILIAL = C7_FILIAL "   
cQuery += " left outer Join " + RetSqlName("SC6") + " SC6 on C6_NUMSC=C7_NUMSC AND C6_ITEMSC=C7_ITEMSC  AND SC6.D_E_L_E_T_ <> '*'  AND LTRIM(RTRIM(C6_NUMSC)) <> ''  AND LTRIM(RTRIM(C6_ITEMSC)) <> '' "   
cQuery += " left outer Join " + RetSqlName("SA1") + " SA1 on A1_COD=C6_CLI and C6_LOJA=A1_LOJA " 
cQuery += " left outer Join " + RetSqlName("SA2") + " SA2 on A2_COD=F1_FORNECE "   
cQuery += " left outer Join " + RetSqlName("SE4") + " SE4 on F1_COND=E4_CODIGO "        
cQuery += " left outer Join " + RetSqlName("SYA") + " SYA on A2_PAIS=YA_CODGI "
cQuery += " WHERE "// F1_FILIAL Between '"+trim(mv_par01)+"' AND '"+trim(mv_par02)+"'" 
cQuery += " F1_EMISSAO Between '"+DTOS(mv_par01)+"' and '"+DTOS(mv_par02)+"'"
cQuery += " AND F1_FORNECE Between '"+mv_par06+"' AND '"+mv_par07+"'"
cQuery += " AND LTRIM(RTRIM(F1_DOC)) Between '"+trim(mv_par03)+"' AND '"+trim(mv_par04)+"'" 
cQuery += " AND upper(F1_SERIE)= upper('"+mv_par05+"') "
cQuery += " AND SF1.D_E_L_E_T_ <> '*' " //and D1_TIPODOC='10' "//" AND E4_FILIAL='11' "//and sa1.d_e_l_e_t_=' ' and sb1.d_e_l_e_t_=' ' "
cQuery += " order by D1_ITEM "

//MemoWrite("SqlUFacEnt.sql",cQuery)
//Alert(cQuery)

TCQUERY cQuery NEW ALIAS "OrdenesCom"
   
 moneda:=""   
 fpag:="" 
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
 fImpCab() // IMPRIME LA CABECERA  
 
 li := 14
 j	:= 1    
 datospie := ""
 datoAnt  := ""
 cValBrut := 0
 cValMerc := 0
 cDescuen := 0	
 While OrdenesCom->(!EOF()) 
   
    If (datoAnt<>OrdenesCom->D1_ITEM)
		
		if li>75
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
 			fImpCab() // IMPRIME LA CABECERA
 			li:=14
		End
		
		@ li,002 PSAY ALLTRIM(OrdenesCom->D1_ITEM)
		@ li,008 PSAY SubStr(ALLTRIM(OrdenesCom->D1_COD),1,10)
					  	
	  	//cPartNum := Posicione('SB1',1,xFilial('SB1')+OrdenesCom->D1_COD,'B1_UFRU') 
	  	//@ li,028 PSAY cPartNum
	  	@ li,018 /*028*/ PSAY SubStr(OrdenesCom->B1_DESC,1,40)																			   
		@ li,060 PSAY OrdenesCom->D1_QUANT	Picture "@E 9,999.99"												
		@ li,070 PSAY OrdenesCom->D1_VUNIT Picture "@E 99,999,999.99"												
		@ li,085 PSAY OrdenesCom->D1_TOTAL Picture "@E 99,999,999.99"
		@ li,100 PSAY alltrim(OrdenesCom->D1_TES)
		@ li,105 PSAY alltrim(OrdenesCom->D1_CC)
		@ li,120 PSAY alltrim(OrdenesCom->D1_ITEMCTA)
		
	  	
		
		nTotalval	:= nTotalval+D1_TOTAL
	    moneda	:= OrdenesCom->F1_MOEDA
	    fpag  	:= OrdenesCom->E4_DESCRI
	    //IBM F-XXX PC N° XXXX PARA CLIENTE AAAAAA
	   // datospie:= Trim(OrdenesCom->A2_NOME)  + " F-" + trim(OrdenesCom->F1_DOC)  + " PC N# " + OrdenesCom->D1_PEDIDO +  " PARA CLIENTE " + OrdenesCom->A1_NOME   
	    li++   
	    j++     
	    datoAnt	:= OrdenesCom->D1_ITEM
	    cValBrut:= OrdenesCom->F1_VALBRUT
	    cValMerc:= OrdenesCom->F1_VALMERC
	    cDescuen:= OrdenesCom->F1_DESCONT
  	EndIf 
    OrdenesCom->(dbSkip())     
 End                        
 
 @ li,02 PSAY REPLICATE('_',130)          
 
 If  Empty(moneda) 
  	Total( nTotalval,1,1,li,fpag,datospie)
 Else
   	Total( nTotalval,moneda,1,li,fpag,datospie)
 Endif	
 OrdenesCom->(DbCloseArea()) 
Return
 

Static Function fImpCab()
 //SetPrc(0,0)                
 cUsuario:=RetCodUsr() 
 nomusuario:=Subst(cUsuario,7,13)


 
 //@ 006,90 PSAY "Fecha: " + ffechalatin(OrdenesCom->f1_EMISSAO) 
 //@ 007,90 PSAY "Hora: " 
 @ 006,02 PSAY "Nro Factura: "  + OrdenesCom->F1_DOC
 @ 006,90 PSAY "Serie: " + OrdenesCom->f1_SERIE
 
 @ 007,02 PSAY "Proveedor: "+Substr(OrdenesCom->A2_NOME,1,40)  
 @ 007,90 PSAY "Fecha: " + ffechalatin(OrdenesCom->f1_EMISSAO) 
 @ 008,02 PSAY OemToAnsi("Nro Autorizaci�n: ")  + OrdenesCom->F1_NUMAUT
 @ 008,90 PSAY "Cod.Control: " + OrdenesCom->f1_CODCTR
 @ 009,02 PSAY OemToAnsi("Condici�n Pago: ") + OrdenesCom->E4_DESCRI
 @ 009,90 PSAY "Moneda: " +iif(OrdenesCom->F1_MOEDA=1,'Bolivianos','Dolares')
 //@ 010,02 PSAY "Correlativo: "+OrdenesCom->f1_UCORREL
 @ 010,90 PSAY "Usuario: "+OrdenesCom->F1_USRREG
 
 @ 011,02 PSAY REPLICATE('_',130)  

 @ 012,002 PSAY "#" 
 @ 012,008 PSAY "Producto"  						
 @ 012,018 PSAY OemToAnsi("Descripci�n")
 @ 012,063 PSAY "Cant."
 @ 012,075 PSAY "Precio"													
 @ 012,091 PSAY "Total"												
 @ 012,100 PSAY "TES"
 @ 012,105 PSAY "Centro Costo"																			
 @ 012,120 PSAY "Item Cont."
 
 @ 013,002 PSAY REPLICATE('_',130)    												
 
return		 


Static Function total( _nTotalVal,moneda,cambio,li,fpago,datospie)
 mone := ""	  
 If moneda==1
 	mone := "Bs"
 Else
 	mone := "$Us" 	
 Endif 
 Impuestos := 0
 li:=li+3      
            
 @ li, 105 PSAY "Neto:"
 //@ li, 009 PSAY "Fecha de Vencimiento: " 
 @ li, 115 Psay _nTotalVal Picture "@E 99,999,999.99"
  li++
  
 //@ li, 008 PSAY "Empleado del Dpto de Ventas:
 @ li, 105 PSAY "Impuestos:" 
 @ li, 115 PSAY Impuestos Picture "@E 99,999,999.99"  
 li++                     
 
 @ li, 105 PSAY "Desct:"
 @ li, 115 PSAY cDescuen Picture "@E 99,999,999.99"      // Descuento 
 li++
 
 //@ li, 009 PSAY "Condiciones de Pago: " + fpago
 @ li, 105 PSAY "Total:"                                                          
 @ li, 115 Psay cValBrut Picture "@E 99,999,999.99"      // Total 
 @ li, 130 PSAY mone
 li:=li+2
 
 //@ li, 105 PSAY "Pagado: "
 //li++
 //@ li, 105 PSAY "Saldo pendiente: "
 //li++
 //@ li, 005 PSAY Upper(datospie)
Return



Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//aAdd(aRegs,{"01","De Sucursal         :","mv_ch1","C",02,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,"SM0"	,""})
//aAdd(aRegs,{"02","Hasta Sucursal      :","mv_ch2","C",02,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"SM0"	,""})
aAdd(aRegs,{"01","De Fecha de Emisi�n  :","mv_ch1","D",08,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   	,""})
aAdd(aRegs,{"02","A Fecha de Emisi�n   :","mv_ch2","D",08,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   	,""})
aAdd(aRegs,{"03","De Nro Factura        :","mv_ch3","C",20,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,""	,""})
aAdd(aRegs,{"04","A Nro Factura         :","mv_ch4","C",20,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,""	,""})
aAdd(aRegs,{"05","Serie                 :","mv_ch5","C",03,0,1,"G","mv_par05",""       ,""            ,""        ,""     ,""	,""})
aAdd(aRegs,{"06","De Proveedor			:","mv_ch6","C",06,0,1,"G","mv_par06",""       ,""            ,""        ,""     ,"SA2"	,""})
aAdd(aRegs,{"07","A Proveedor			:","mv_ch7","C",06,0,1,"G","mv_par07",""       ,""            ,""        ,""     ,"SA2"	,""})

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
         SX1->X1_DEFSPA1    := aRegs[i][10]
         SX1->X1_DEFSPA2    := aRegs[i][11]
         SX1->X1_DEFSPA3    := aRegs[i][12]
         SX1->X1_DEFSPA4    := aRegs[i][13]
         SX1->X1_F3       := aRegs[i][14]
         SX1->X1_VALID    := aRegs[i][15]   
         
      MsUnlock()
   Endif
Next

Return    
  
Return

Static Function ffechalatin(sfechacorta)
     
Local ffechalatin:=""             
Local sdia:=substr(sfechacorta,7,2)
Local smes:=substr(sfechacorta,5,2)
Local sano:=substr(sfechacorta,3,2)
ffechalatin := sdia + "/" + smes + "/" + sano
Return(ffechalatin)    



Static Function GraContPert()

SX1->(DbSetOrder(1))
               

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"01"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SF1->F1_EMISSAO)        //Variable publica con Fecha de Emision
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SF1->F1_EMISSAO)        //Variable publica con Fecha Emision
   SX1->(MsUnlock())
End   
                                   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_DOC      //Variable publica con Documento
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_DOC        //Variable publica con Documento
   SX1->(MsUnlock())
End    

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_SERIE        //Variable publica con Serie
   SX1->(MsUnlock())
End

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_FORNECE        //Variable publica con Proveedor
   SX1->(MsUnlock())
End

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"07"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SF1->F1_FORNECE        //Variable publica con Proveedor
   SX1->(MsUnlock())
End
   
Return