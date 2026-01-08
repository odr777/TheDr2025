#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  OCDATEC  ºAutor  ³Walter Alvarez       Fecha 04/12/2010
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion nota de venta                                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DATEC                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function NOTAPED()

 Local oReport                                                                                 
 Local nOrdem 	:= 0
 Local wnrel   	:= "NOPED" // Nome default do relatório em disco
 Local cDesc1  	:= OemToAnsi("Nota de Venta") //"Emiss„o de produtos a serem separados pela expedicao, para"
 Local cDesc2  	:= OemToAnsi("") //"determinada faixa de pedidos."
 Local cDesc3  	:= ""
 Local cString 	:= "SC6" // Alias do arquivo principal do relatório para o uso de filtro
 PRIVATE cPerg	:= "NOPED" // Nome da pergunte a ser exibida para o usuário.
 
 PRIVATE aReturn  := {"Zebrado", 1,"Administracion", 2, 2, 1, "",1} //"Zebrado"###"Administracao" // Array com as informações para a tela de configuração da impressão
 PRIVATE nomeprog := "NOPED" //Nome do programa do relatório
 PRIVATE nLastKey := 0 //Utilizado para controlar o cancelamento da impressão do relatório.
 PRIVATE nBegin   := 0
 PRIVATE aLinha   := {} //Array que contem informações para a impressão de relatórios cadastrais
 PRIVATE li       := 15 //Controle das linhas de impressão. Seu valor inicial é a quantidade máxima de linhas por página utilizada no relatório.
 PRIVATE limite   := 132 //Quantidade de colunas no relatório (80, 132, 220).
 PRIVATE lRodape  := .F.
 PRIVATE m_pag    :=1    //Controle do número de páginas do relatório.  
 PRIVATE titulo   :="NOTA DE VENTA"
 PRIVATE nomeprog := "NOTAPED"
 PRIVATE cabec1   := ""
 PRIVATE cabec2   := ""
 PRIVATE tamanho  := "M" 
 
 aOrd :={}		 
 ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO		 
 
 GraContPert()
   
 If funname() == 'MATA410'
	Pergunte(cPerg,.F.)   
 Else
	Pergunte(cPerg,.T.)         
 Endif
 
 wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
 
 If nLastKey == 27
  DbClearFilter()
  Return
 Endif
 
 SetDefault(aReturn,cString)
 
 If nLastKey == 27
  DbClearFilter()
  Return
 Endif 
 RptStatus({|lEnd| OCDAT1(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo)  
 
Return
    
//------------------------------------------------------
Static  Function OCDAT1(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3) 
	fImpInforme()         
	If aReturn[5] = 1
		Set Printer TO
	  	DbCommitAll()
	  	OurSpool(wnrel)
	EndIf
	MS_FLUSH()  	
Return NIL



Static Function fImpInforme()

Local nTotalcant	:= 00.0
Local nTotalval    	:= 00.0

nOrdem := aReturn[8]       

cQuery := "Select distinct C5_NUM,C5_CLIENTE,C5_DATA1,C5_DATA2,C5_DATA3,C5_DATA4,C5_EMISSAO,C5_CONDPAG, A3_NOME,C6_ENTREG,C5_PARC1,C5_PARC2,C5_PARC3,C5_PARC4,"
cQuery += "C6_ITEM,C6_PRODUTO,C6_QTDVEN,C6_PRCVEN,C6_VALOR,A1_NOME,C6_DESCRI ,C5_TXMOEDA,C5_moeda,E4_DESCRI " //EL_BANCO,EL_VALOR,EL_DTVCTO,
cQuery += "From " + RetSqlName("SC5") + " SC5 "     
cQuery += "Inner Join " + RetSqlName("SC6") + " SC6 on C5_NUM=C6_NUM and C5_filial=C6_filial  "   
cQuery += "Left outer Join " + RetSqlName("SA1") + " SA1 on A1_COD=C5_CLIENTE "  
cQuery += "Left outer Join " + RetSqlName("SA3") + " SA3 on A3_COD=C5_VEND1 " 
cQuery += "Left outer Join " + RetSqlName("SB1") + " SB1 on B1_COD=C6_PRODUTO "   
cQuery += "Left outer Join " + RetSqlName("SE4") + " SE4 on E4_CODIGO=C5_CONDPAG "//AND C5_filial=E4_filial "  
//cQuery += "left outer Join " + RetSqlName("SEL") + " SEL on EL_PREFIXO=C5_SERIE  AND EL_NUMERO=C5_NUM AND EL_CLIORIG=A1_COD AND rtrim(ltrim(EL_TIPO))='NF' " 
//cQuery += "Left outer Join " + RetSqlName("SZB") + " SZB on zb_local=C6_local and C6_FILIAL=ZB_FILIAL"
cQuery += " WHERE C5_FILIAL Between '"+trim(XFILIAL("SC5"))+"' AND '"+trim(XFILIAL("SC5"))+"'"
cQuery += " and C5_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
cQuery += " and C5_NUM Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
cQuery += " and SC5.d_e_l_e_t_=' ' and SC6.d_e_l_e_t_=' ' AND E4_FILIAL='"+ xfilial('SE4') +"'"//and se4.d_e_l_e_t_=' ' and sel.d_e_l_e_t_=' '" //and sa1.d_e_l_e_t_=' ' and sb1.d_e_l_e_t_=' '

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Aviso("Nota Pedido",cQuery,{'ok'},,,,,.t.)
MemoWrite("NotaPedwal.sql",cQuery)  
TCQUERY cQuery NEW ALIAS "OrdenesCom"


//nReg	:=	OrdenesCom->(RECNO())

nVias:=1 
For _nCont:=1 to nVias
	OrdenesCom->(DbGoTop())
 	//OrdenesCom->(DbGoTo(nReg))
	nTotalcant	:= 00.0
	nTotalval  	:= 00.0
	   
	moneda	:=	""  
	glosa	:=	""  
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	fImpCab() // IMPRIME LA CABECERA  
	
  	li 	:= 19
  	j	:= 1    
  	moneda := 0    
 	//D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL
 	While OrdenesCom->(!EOF()) 
		@ li,02 PSAY OrdenesCom->C6_PRODUTO
    	//@ li,15 PSAY OrdenesCom->B1_UFRU				
    	@ li,40 PSAY Left(OrdenesCom->C6_DESCRI,34)																	
    	//@ li,75 PSAY OrdenesCom->C6_ANOSGAR Picture '99'    
    	@ li,79 PSAY Transform(OrdenesCom->C6_QTDVEN,'@E 99,999')										
    	//@ li,86 PSAY SUBSTR(OrdenesCom->ZB_NOMALM,1,15)	 '
   		//cNomeAlm := Posicione("SZB", 1, + cCodigo, "B1_DESC")
    	If empty(OrdenesCom->C5_EMISSAO)
      		@ li,103 PSAY XMOEDA(OrdenesCom->C6_PRCVEN,OrdenesCom->C5_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.99"											
      		@ li,120 PSAY XMOEDA(OrdenesCom->C6_VALOR,OrdenesCom->C5_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.99"
    	Else
      		@ li,103 PSAY XMOEDA(OrdenesCom->C6_PRCVEN,OrdenesCom->C5_MOEDA,MV_PAR07,stod(OrdenesCom->C5_EMISSAO)) Picture "@E 99,999,999.99"											
      		@ li,120 PSAY XMOEDA(OrdenesCom->C6_VALOR,OrdenesCom->C5_MOEDA,MV_PAR07,stod(OrdenesCom->C5_EMISSAO)) Picture "@E 99,999,999.99"  
    	Endif
    	//@ li, 148 Psay XMOEDA(_nTotalVal,moneda,cambio,DDATABASE) Picture "@E 99,999,999.99"      // Total 
   		//Alert(OrdenesCom->C5_MOEDA)
    	If empty(OrdenesCom->C5_EMISSAO)
     		//alert("PAso 1") 
       		nTotalval:=nTotalval + XMOEDA(OrdenesCom->C6_VALOR,OrdenesCom->C5_MOEDA,MV_PAR07,DDATABASE)
    	Else           
      		//alert("Paso 2") 
       		nTotalval:=nTotalval + XMOEDA(OrdenesCom->C6_VALOR,OrdenesCom->C5_MOEDA,MV_PAR07,stod(OrdenesCom->C5_EMISSAO))
    	Endif
    	moneda :=OrdenesCom->C5_moeda  
    	glosa:=""//OrdenesCom->C5_UGLOSA 
  		//alert("entro al while")
    	li++   
    	j++ 
    	OrdenesCom->(dbSkip())   
 	End     
 	@ li,02 PSAY REPLICATE('_',130)          
 	//total( nTotalval)
 	If moneda<>0	
  		total( nTotalval,moneda,MV_PAR07,LI,glosa )	
 	Endif
Next nVias 
OrdenesCom->(DbCloseArea())

Return
 


Static Function fImpCab()
//SetPrc(0,0)                
cUsuario:=RetCodUsr() 
nomusuario:=Subst(cUsuario,7,13)

 // @ 007,50 PSAY "ORDEN DE NACIONALIZACION "    
 // @ 007,80 PSAY "Rev.1"   
 // _cEmp:=cfuncao()       
 // alert(cnumemp)
 // uvc_direc := Posicione("SM0",1,substr(cnumemp,1,2)+dba->dba_filial,"M0_ENDENT") 
 //@ 006,02 PSAY "DATEC Ltda."  
 @ 006,02 PSAY "Pedido de Venta: " + substr(OrdenesCom->C5_NUM,1,14)
 @ 007,02 PSAY "Vendedor: " +  substr(OrdenesCom->A3_NOME,1,50) 
 @ 007,50 PSAY "Forma de Pago: " + OrdenesCom->E4_DESCRI
 @ 007,90 PSAY "Fecha: " + ffechalatin(OrdenesCom->C5_EMISSAO) 
 @ 008,02 PSAY "Cliente: " + substr(OrdenesCom->A1_NOME,1,30)
 @ 008,49 PSAY "T.C.:: " + TRANSFORM(POSICIONE("SM2",1,OrdenesCom->C5_EMISSAO,"M2_MOEDA2"),"@E 99.99")   
 // @ 007,02 PSAY "DUI:"
 // @ 009,02 PSAY "Observaciones Vendedor: "  + OrdenesCom->C5_UGLOSA
 //@ 009,02 PSAY "Flujo: " + OrdenesCom->C5_UNROFLU
 @ 009,49 PSAY "Vcto. Gral.: "  + ffechalatin(OrdenesCom->C6_ENTREG)
 @ 010,02 PSAY "Nota: " //+ OrdenesCom->F2_DOC
 @ 011,02 PSAY "Medio de Pago       Banco        Nro. Doc.        Monto          F. Vcto.: "  
 //@ 012,02 PSAY OrdenesCom->C5_URFPAG1  
 @ 012,52 PSAY OrdenesCom->C5_PARC1  
 @ 012,67 PSAY ffechalatin(OrdenesCom->C5_DATA1)
 //@ 013,02 PSAY OrdenesCom->C5_URFPAG2  
 //@ 013,52 PSAY OrdenesCom->C5_PARC2  
 @ 013,67 PSAY ffechalatin(OrdenesCom->C5_DATA2) 
 //@ 014,02 PSAY OrdenesCom->C5_URFPAG3  
 //@ 014,52 PSAY OrdenesCom->C5_PARC3 
 @ 014,67 PSAY ffechalatin(OrdenesCom->C5_DATA3) 
 //@ 015,02 PSAY OrdenesCom->C5_URFPAG4  
 @ 015,52 PSAY OrdenesCom->C5_PARC4  
 @ 015,67 PSAY ffechalatin(OrdenesCom->C5_DATA4)  
 @ 016,02 PSAY REPLICATE('_',130)  
// ITEM	No. DE FACTURA	PROVEEDOR	DESCRIPCION/FACTURA	DESCRIPCION COMERCIAL	PAIS ORIGEN	Nº PARTE	CANT.	PRE. UNIT.	TOTAL
 @ 017,02 PSAY "Codigo"  
 @ 017,14 PSAY "No.de Parte" 						
 @ 017,40 PSAY "Descripción" 																	
 @ 017,72 PSAY "Gar."	   
 @ 017,79 PSAY "Cant."												
 @ 017,85 PSAY "Alm."	
 @ 017,108 PSAY "Precio"												
 @ 017,125 PSAY "Total"																			
 @ 018,02 PSAY REPLICATE('_',130)    												
 
Return		 

Static function total( _nTotalVal,moneda,cambio,li,glosa)
mone:=""	  
if cambio=1
 mone:="$Bs"
else
 mone:="$Us" 	
endif 
 
 li:=li+3      
 @ li, 105 PSAY "Sub-Total " 
 @ li, 115 Psay _nTotalVal Picture "@E 99,999,999.99"      // Total
 @ li, 130 PSAY mone
 li++
 @ li, 105 PSAY "%  Descuento "
 li++
 @ li, 105 PSAY "Mto. Descuento " 
 li++              
 @ li, 105 PSAY "Total " 
 @ li, 115 Psay _nTotalVal Picture "@E 99,999,999.99"      // Total     
// @ li, 115 Psay XMOEDA(_nTotalVal,moneda,cambio,DDATABASE) Picture "@E 99,999,999.99"      // Total 
 @ li, 130 PSAY mone
 li:=li+5
 @ li, 04 PSAY "OBSERVACION: NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES"
 li++
 //@ li, 04 PSAY "Esta Nota de Venta se sujeta a las Politicas y Procedimientos de DATEC LTDA."  
 //li++   
 //alert(glosa)
 //@ li, 04 PSAY glosa

 //@ li, 148 Psay _nTotalVal Picture "@E 99,999,999.99" 
 li:=li+10     
 @ li, 04 PSAY "________________" 
 @ li, 35 PSAY "_____________" 
 @ li, 65 PSAY "_____________"
 @ li, 95 PSAY "_____________"
 li++    
 @ li, 04 PSAY "Administración"  
 @ li, 35 PSAY "Deposito"   
 @ li, 65 PSAY "Vendedor"    
 @ li, 95 PSAY "Cliente"   
return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ValidPerg ºAutor  ³ Walter Alvarez ³  04/11/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas do SX1                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{"01","De Sucursal             :","mv_ch1","C",2,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,"SM0",""})
aAdd(aRegs,{"02","Hasta Sucursal          :","mv_ch2","C",2,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,"SM0",""})
aAdd(aRegs,{"03","De Fecha de Emisión     :","mv_ch3","D",08,0,0,"G","mv_par03",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"04","A Fecha de Emisión      :","mv_ch4","D",08,0,0,"G","mv_par04",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"05","De Nro. Nota                :","mv_ch5","C",20,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"06","A Nro. Nota                 :","mv_ch6","C",20,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"07","Moneda                  :","mv_ch7","N",1,0,1,"C","mv_par07","BOLIVIANO"       ,"DOLAR"            ,""        ,""     ,"",""})

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
   SX1->X1_CNT01 := SC5->C5_FILIAL       //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_FILIAL          //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End               

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SC5->C5_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SC5->C5_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
                                   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_NUM        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SC5->C5_NUM        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"07"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := str(SC5->C5_MOEDA)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End 
Return
