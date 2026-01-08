#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ PRESUPUESTO  ºAutor  ³Amby Arteaga Rivero Fecha 14/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Imprime el Presupuesto de Venta                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLOFI                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function PRESUPUESTO()

 Local oReport                                                                                 
 Local nOrdem 	:= 0
 Local wnrel   	:= "PRESUP" // Nome default do relatório em disco
 Local cDesc1  	:= OemToAnsi("Presupuesto") //"Emiss„o de produtos a serem separados pela expedicao, para"
 Local cDesc2  	:= OemToAnsi("") //"determinada faixa de presupuesto."
 Local cDesc3  	:= ""
 Local cString 	:= "SCK" // Alias do arquivo principal do relatório para o uso de filtro
 PRIVATE cPerg	:= "NOPED" // Nome da pergunte a ser exibida para o usuário.
 
 PRIVATE aReturn  := {"Zebrado", 1,"Administracion", 2, 2, 1, "",1} //"Zebrado"###"Administracao" // Array com as informações para a tela de configuração da impressão
 PRIVATE nomeprog := "PRESUP" //Nome do programa do relatório
 PRIVATE nLastKey := 0 //Utilizado para controlar o cancelamento da impressão do relatório.
 PRIVATE nBegin   := 0
 PRIVATE aLinha   := {} //Array que contem informações para a impressão de relatórios cadastrais
 PRIVATE li       := 0 //Controle das linhas de impressão. Seu valor inicial é a quantidade máxima de linhas por página utilizada no relatório.
 PRIVATE limite   := 132 //Quantidade de colunas no relatório (80, 132, 220).
 PRIVATE lRodape  := .F.
 PRIVATE m_pag    := 1    //Controle do número de páginas do relatório.  
 PRIVATE titulo   := "PRESUPUESTO DE VENTA"
 PRIVATE nomeprog := "PRESUPUESTO"
 PRIVATE cabec1   := ""
 PRIVATE cabec2   := ""
 PRIVATE Tamanho  := "M"
 PRIVATE cUsrReg  := "" 
 PRIVATE _nTipoCambio := 1
 
 aOrd :={}		 
 ValidPerg(cPerg)	// CARGAMOS LAS PREGUNTAS POR CODIGO		 
 
 GraContPert()
   
 If funname() == 'MATA415'
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

cQuery := "SELECT DISTINCT CJ_NUM,CJ_CLIENTE,A1_NOME,A1_CGC,CJ_EMISSAO,CJ_VALIDA,A1_END,CJ_MOEDA,CJ_TXMOEDA,CJ_CONDPAG,E4_DESCRI,"
cQuery += "CJ_UVEND,A3_NOME,CJ_DESC1,CJ_ULUGENT,CJ_UTPOENT,CJ_UOBSERV,CJ_USRREG,CJ_COTCLI, " 
cQuery += "CK_ENTREG,CK_ITEM,CK_PRODUTO,CK_UESPECI,CK_UM,CK_QTDVEN,CK_PRCVEN,CK_VALOR,CK_OBS,B1_PESO*CK_QTDVEN B1_PESBRU,B1_UDESCMA " //EL_BANCO,EL_VALOR,EL_DTVCTO,
cQuery += "From " + RetSqlName("SCJ") + " SCJ "     
cQuery += "Inner Join " + RetSqlName("SCK") + " SCK on CJ_NUM=CK_NUM and CJ_FILIAL=CK_FILIAL  "   
cQuery += "Inner Join " + RetSqlName("SA1") + " SA1 on A1_COD=CJ_CLIENTE "  
cQuery += "Inner Join " + RetSqlName("SA3") + " SA3 on A3_COD=CJ_UVEND " 
cQuery += "Inner Join " + RetSqlName("SB1") + " SB1 on B1_COD=CK_PRODUTO "   
cQuery += "Inner Join " + RetSqlName("SE4") + " SE4 on E4_CODIGO=CJ_CONDPAG "//AND CJ_filial=E4_filial "  
//cQuery += "left outer Join " + RetSqlName("SEL") + " SEL on EL_PREFIXO=CJ_SERIE  AND EL_NUMERO=CJ_NUM AND EL_CLIORIG=A1_COD AND rtrim(ltrim(EL_TIPO))='NF' " 
//cQuery += "Left outer Join " + RetSqlName("SZB") + " SZB on zb_local=CK_local and CK_FILIAL=ZB_FILIAL"
cQuery += " WHERE CJ_FILIAL Between '"+trim(XFILIAL("SCJ"))+"' AND '"+trim(XFILIAL("SCJ"))+"'"
cQuery += " and CJ_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
cQuery += " and CJ_NUM Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
cQuery += " and SCJ.D_E_L_E_T_=' ' and SCK.D_E_L_E_T_=' ' AND E4_FILIAL='"+ xfilial('SE4') +"' and SE4.D_E_L_E_T_=' ' and SA1.D_E_L_E_T_=' 'and SA3.D_E_L_E_T_=' ' and SB1.D_E_L_E_T_=' '"

//aviso("",cQuery,{'ok'},,,,,.t.)		

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MemoWrite("Pptowal.sql",cQuery)  
TCQUERY cQuery NEW ALIAS "Presupto"

//nReg	:=	Presupto->(RECNO())

nVias:=1 
For _nCont:=1 to nVias
	Presupto->(DbGoTop())
 	//Presupto->(DbGoTo(nReg))
	nTotalcant	:= 00.0
	nTotalval  	:= 00.0
	   
	moneda	:=	""  
	glosa	:=	""  
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	fImpCab() // IMPRIME LA CABECERA  
	
  	//li 	:= 19
  	j	:= 1    
  	moneda := 0    
 	//D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL
 	While Presupto->(!EOF()) 
		@ li,02 PSAY Presupto->CK_ITEM
		@ li,06 PSAY Presupto->CK_PRODUTO
    	If (SubStr(Presupto->CK_UESPECI,40,1) == " " .OR. SubStr(Presupto->CK_UESPECI,46,1) == " ")
    		@ li,17 PSAY Left(Presupto->CK_UESPECI,40)
    	Else																	
    		@ li,17 PSAY Left(Presupto->CK_UESPECI,40)+"-"																	
    	EndIf																	
    	@ li,60 PSAY Presupto->CK_UM    
    	@ li,64 PSAY Transform(Presupto->CK_QTDVEN,'@E 9,999,999')										
    	If empty(Presupto->CJ_EMISSAO)
      		@ li,73 PSAY XMOEDA(Presupto->CK_PRCVEN,Presupto->CJ_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.9999"											
      		@ li,88 PSAY XMOEDA(Presupto->CK_VALOR,Presupto->CJ_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.99"
    	Else
      		@ li,73 PSAY XMOEDA(Presupto->CK_PRCVEN,Presupto->CJ_MOEDA,MV_PAR07,stod(Presupto->CJ_EMISSAO)) Picture "@E 99,999,999.9999"											
      		@ li,88 PSAY XMOEDA(Presupto->CK_VALOR,Presupto->CJ_MOEDA,MV_PAR07,stod(Presupto->CJ_EMISSAO)) Picture "@E 99,999,999.99"  
    	Endif
    	@ li,103 PSAY Left(Presupto->B1_UDESCMA,30)
    	If empty(Presupto->CJ_EMISSAO)
       		nTotalval:=nTotalval + XMOEDA(Presupto->CK_VALOR,Presupto->CJ_MOEDA,MV_PAR07,DDATABASE)
    	Else           
       		nTotalval:=nTotalval + XMOEDA(Presupto->CK_VALOR,Presupto->CJ_MOEDA,MV_PAR07,stod(Presupto->CJ_EMISSAO))
    	Endif
    	If Len(AllTrim(Presupto->CK_UESPECI)) > 40
    		li++
    		@ li,16 PSAY Right(Presupto->CK_UESPECI,40)																	
    	EndIf
    	If Len(AllTrim(Presupto->CK_OBS)) > 0
    		li++
    		@ li,16 PSAY Left(Presupto->CK_OBS,40)																	
    	EndIf
    	If Len(AllTrim(Presupto->CK_OBS)) > 40
    		li++
    		@ li,16 PSAY Right(Presupto->CK_OBS,40)																	
    	EndIf
    	moneda :=Presupto->CJ_moeda  
    	li++   
    	j++ 
    	Presupto->(dbSkip())   
 	End     
 	@ li,02 PSAY REPLICATE('_',130)          
 	If moneda<>0	
  		total( nTotalval,moneda,MV_PAR07,LI )	
 	Endif
Next nVias 
Presupto->(DbCloseArea())

Return
 


Static Function fImpCab()
// cUsuario:=RetCodUsr() 
// nomusuario:=Subst(cUsuario,7,13)
 dFecha := STOD(Presupto->CJ_EMISSAO)
 dFechaVal := STOD(Presupto->CJ_VALIDA)
 li := 6
 // uvc_direc := Posicione("SM0",1,substr(cnumemp,1,2)+dba->dba_filial,"M0_ENDENT") 
 @ li,02 PSAY "Fecha: " + CValToChar(DAY(dFecha))+ " DE " + UPPER(dFechaToMes(dFecha)) + " DE " + CValToChar(YEAR(dFecha))  //ffechalatin(Presupto->CJ_EMISSAO) 
 @ li,80 PSAY "Numero: " + substr(Presupto->CJ_NUM,1,14)
 li++
 @ li,02 PSAY "Cliente: " + AllTrim(Presupto->CJ_CLIENTE) + " - " + AllTrim(Presupto->A1_NOME)
 @ li,80 PSAY "N.I.T.: " + Presupto->A1_CGC
  li++
 @ li,02 PSAY "Direccion: " + Presupto->A1_END
 _nTipoCambio = POSICIONE("SM2",1,Presupto->CJ_EMISSAO,"M2_MOEDA2")
 @ li,80 PSAY "T.C.: " + TRANSFORM(_nTipoCambio,"@E 99.99")   
 li++
 @ li,02 PSAY "Vendedor: " +  substr(Presupto->A3_NOME,1,50) 
 @ li,80 PSAY "PM: " +  CValToChar(Presupto->CJ_DESC1) + "%" 
 li++
 @ li,02 PSAY REPLICATE('_',130)  
 li++
 @ li,02 PSAY "Validez de la Oterta: " + cValToChar(dFechaVal - dFecha)+ " DIAS (HASTA: " + ffechalatin(Presupto->CJ_VALIDA) +")" 
 @ li,80 PSAY "Forma de Pago: " + Presupto->E4_DESCRI // Iif(Presupto->CJ_CONDPAG=="002","CONTADO","CREDITO")//
 li++
 @ li,02 PSAY "Tiempo de Entrega: " + Presupto->CJ_UTPOENT  
 @ li,80 PSAY "Moneda del Presupuesto: " + Iif(Presupto->CJ_MOEDA == 1, "BOLIVIANOS","DOLARES") 
 li++
 @ li,02 PSAY "Lugar de Entrega: " + Presupto->CJ_ULUGENT
 @ li,80 PSAY "Cotizacion Cliente: " + Presupto->CJ_COTCLI
 li++
 @ li,02 PSAY "Observación: " + Presupto->CJ_UOBSERV  
 li++
 @ li,02 PSAY REPLICATE('_',130)  
 li++
 @ li,02 PSAY "It."  
 @ li,06 PSAY "Codigo" 						
 @ li,16 PSAY "Descripción" 																	
 @ li,59 PSAY "U/M."												
 @ li,68 PSAY "Cant."	
 @ li,81 PSAY "Precio"												
 @ li,94 PSAY "Total"	
 @ li,103 PSAY "Marca" 																	
 li++																		
 @ li,02 PSAY REPLICATE('_',130)    												
 li += 2																		
 cUsrReg := Presupto->CJ_USRREG
Return		 

Static function total( _nTotalVal,moneda,cambio,li)
/*mone:=""	  
if cambio=1
 mone:="Bs."
else
 mone:="$Us" 	
endif 
 */
 li++      
 @ li,75 PSAY "Total Bs. " //+ mone 
 @ li,87 Psay If(moneda == 1,_nTotalVal,(_nTotalVal * _nTipoCambio)) Picture "@E 99,999,999.99"      // Total
 li++      
 @ li,75 PSAY "Total $Us. " //+ mone 
 @ li,87 Psay If(moneda == 2,_nTotalVal,(_nTotalVal / _nTipoCambio)) Picture "@E 99,999,999.99"      // Total
 li++     
 @ li,02 PSAY "NOTA.- AL MOMENTO DE HACER SU COMPRA POR FAVOR EXIGIR SU FACTURA" 
 li++
 @ li,02 PSAY REPLICATE('_',130)    												
 If _nTotalVal +50000 > 50000 
	 li++     
	 @ li,60 PSAY "IMPORTANTE" 
	 li++     
	 @ li,60 PSAY "----------"
	 li++     
	 @ li,20 PSAY "ESTIMADO CLIENTE:"
	 li++    
	 @ li,20 PSAY "TODA COMPRA MAYOR A BS. 50,000.00 SE DEBE CANCELAR CON CHEQUE O "  
	  li++    
	 @ li,20 PSAY "DEPOSITO EN CUENTA BANCARIA Y EL DEPOSITANTE DEBE SER EL MISMO DE LA FACTURA."   
	 li++    
	 @ li,20 PSAY AllTrim(GetMv("MV_UBCODES"))    
	 li++    
	 @ li,40 PSAY AllTrim(GetMv("MV_UBCOBOL"))  
	 @ li,70 PSAY AllTrim(GetMv("MV_UBCODOL"))   
	 li++    
	 @ li,20 PSAY AllTrim(GetMv("MV_UBCODE2"))    
	 li++    
	 @ li,40 PSAY AllTrim(GetMv("MV_UBCOBO2"))  
	 @ li,70 PSAY AllTrim(GetMv("MV_UBCODO2"))   
	 li++    
	 @ li,20 PSAY AllTrim(GetMv("MV_UBCODE3"))    
	 li++    
	 @ li,40 PSAY AllTrim(GetMv("MV_UBCOBO3"))  
	 @ li,70 PSAY AllTrim(GetMv("MV_UBCODO3"))   
	 li++    
	 @ li, 88 PSAY "LA GERENCIA"   
	 li++
	 @ li,02 PSAY REPLICATE('_',130)    												
 EndIf
 li++
 @ li,02 PSAY "MERCANTIL LEON SRL NO SE HACE RESPONSABLE POR LOS DAÑOS CAUSADOS EN EL TRANSPORTE"    												
 li++
 @ li,14 PSAY "UNA VEZ PASADA LA VALIDEZ DE OFERTA, POR FAVOR CONFIRMAR EXISTENCIA DE STOCK." 
 @ 63,02 PSAY PADC("Contacto: " + AllTrim(cUsrReg) + "   |   E-Mail: " + UsrRetMail(cCodUser(cUsrReg)),130)
 @ 64,02 PSAY REPLICATE('_',130)    												
 @ 65,02 PSAY PADC("Av. Viedma No. 51  -  Telf.: 32-6174/33-1447/36-4244  -  Fax: 36-8672",130)   												


Return

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
aAdd(aRegs,{"05","De Nro. Ppto            :","mv_ch5","C",20,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"06","A Nro. Ppto             :","mv_ch6","C",20,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"",""})
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
   SX1->X1_CNT01 := SCJ->CJ_FILIAL       //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"02"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_FILIAL          //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End               

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"03"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SCJ->CJ_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   

If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"04"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := dtoc(SCJ->CJ_EMISSAO)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
                                   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"05"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_NUM        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
  
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"06"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := SCJ->CJ_NUM        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End   
If SX1->(DbSeek(alltrim(cPerg)+Space(5)+"07"))
   Reclock("SX1",.F.)
   SX1->X1_CNT01 := str(SCJ->CJ_MOEDA)        //Variable publica con sucursal en uso
   SX1->(MsUnlock())
End 
Return

Static Function dFechaToMes(dFecha)
nMes :=  Val(AllTrim(SubStr(DTOC(dFecha),4,5))) 
cMes := ""
Do Case
	Case nMes==01 	; cMes := "enero"
	Case nMes==02	; cMes := "febrero"
	Case nMes==03   ; cMes := "marzo"	
	Case nMes==04	; cMes := "abril"
	Case nMes==05	; cMes := "mayo"
	Case nMes==06	; cMes := "junio"
	Case nMes==07	; cMes := "julio"
	Case nMes==08	; cMes := "agosto"
	Case nMes==09	; cMes := "septiembre"
	Case nMes==10	; cMes := "octubre"
	Case nMes==11	; cMes := "noviembre"
	Case nMes==12	; cMes := "diciembre"
EndCase    
Return(cMes)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Función que me retorna el Código de Usuario                    ³ 
// Amby Arteaga Rivero - 16/09/2015                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function cCodUser(cNomeUser)
	Local _IdUsuario:= ""
/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
  ±±³  ³ PswOrder(nOrder): seta a ordem de pesquisa   ³±±
  ±±³  ³ nOrder -> 1: ID;                             ³±±
  ±±³  ³           2: nome;                           ³±±
  ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
  	PswOrder(2)
  	If pswseek(cNomeUser,.t.)
  		_aUser      := PswRet(1)
  		_IdUsuario  := _aUser[1][1]      // Código de usuario 
  	Endif  

Return(_IdUsuario)