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
 PRIVATE limite   := 200 //Quantidade de colunas no relatório (80, 132, 220).
 PRIVATE lRodape  := .F.
 PRIVATE m_pag    :=1    //Controle do número de páginas do relatório.  
 PRIVATE titulo   :="NOTA DE VENTA"
 PRIVATE nomeprog := "NOTAPED"
 PRIVATE cabec1   := ""
 PRIVATE cabec2   := ""
 PRIVATE Tamanho  := "G" 
 PRIVATE cUsrReg  := "" 
 PRIVATE _nTipoCambio := 1
 
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

cQuery := "Select distinct C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_FECENT,C5_CONDPAG,C5_DESC1,C5_UNOMCLI,C5_UNITCLI,C5_ULUGENT,"
cQuery += "C5_UTPOENT,C5_UNUCOCL,C5_PBRUTO,C5_TRANSP,C5_COTACAO,C5_UOBSERV,C5_USRREG,A3_NOME,"
cQuery += "C6_ENTREG,C6_ITEM,B1_UCODFAB,C6_PRODUTO,C6_LOCAL,NNR_DESCRI,NNR_UDIREC,C6_UM, C6_QTDVEN,C6_PRCVEN,C6_VALOR,"
cQuery += "A1_NOME,A1_CGC,A1_END,C6_DESCRI,C6_UESPECI ,C5_TXMOEDA,C5_MOEDA,E4_DESCRI " //EL_BANCO,EL_VALOR,EL_DTVCTO,
cQuery += "From " + RetSqlName("SC5") + " SC5 "     
cQuery += "Inner Join " + RetSqlName("SC6") + " SC6 on C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL  "   
cQuery += "Inner Join " + RetSqlName("SA1") + " SA1 on A1_COD=C5_CLIENTE "  
cQuery += "Inner Join " + RetSqlName("SA3") + " SA3 on A3_COD=C5_VEND1 " 
cQuery += "Inner Join " + RetSqlName("SB1") + " SB1 on B1_COD=C6_PRODUTO "   
cQuery += "Inner Join " + RetSqlName("SE4") + " SE4 on E4_CODIGO=C5_CONDPAG "//AND C5_filial=E4_filial "  
cQuery += "Inner Join " + RetSqlName("NNR") + " NNR on NNR_CODIGO=C6_LOCAL " 
//cQuery += "Left outer Join " + RetSqlName("SZB") + " SZB on zb_local=C6_local and C6_FILIAL=ZB_FILIAL"
cQuery += " WHERE C5_FILIAL Between '"+trim(XFILIAL("SC5"))+"' AND '"+trim(XFILIAL("SC5"))+"'"
cQuery += " and C5_EMISSAO Between '"+DTOS(mv_par03)+"' and '"+DTOS(mv_par04)+"'"
cQuery += " and C5_NUM Between '"+trim(mv_par05)+"' and '"+trim(mv_par06)+"'"
cQuery += " and SC5.D_E_L_E_T_=' ' and SC6.D_E_L_E_T_=' ' AND E4_FILIAL='"+ xfilial('SE4') +"' and SB1.D_E_L_E_T_=' ' and SA3.D_E_L_E_T_=' '" //and sa1.d_e_l_e_t_=' ' and sb1.d_e_l_e_t_=' '

//aviso("",cQuery,{'ok'},,,,,.t.)		

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MemoWrite("NotaPedwal.sql",cQuery)  
TCQUERY cQuery NEW ALIAS "OrdenesCom"

//nReg	:=	OrdenesCom->(RECNO())
colini:= 10
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
	
  	li 	:= 23
  	j	:= 1    
  	moneda := 0    
 	//D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL
 	While OrdenesCom->(!EOF()) 
		@ li,colini PSAY OrdenesCom->C6_ITEM
		@ li,colini+6 PSAY OrdenesCom->C6_PRODUTO
    	//@ li,20 PSAY OrdenesCom->B1_UCODFAB
    	If (SubStr(OrdenesCom->C6_UESPECI,60,1) == " " .OR. SubStr(OrdenesCom->C6_UESPECI,61,1) == " ")
    		@ li,colini+19 PSAY Left(OrdenesCom->C6_UESPECI,60)
    	Else																	
    		@ li,colini+19 PSAY Left(OrdenesCom->C6_UESPECI,60)+"-"																	
    	EndIf																	
    	@ li,colini+83 PSAY OrdenesCom->C6_UM    

    	@ li,colini+88 PSAY Transform(OrdenesCom->C6_QTDVEN,'@E 9,999,999.99')										
    	If empty(OrdenesCom->C5_EMISSAO)
      		@ li,colini+98 PSAY XMOEDA(OrdenesCom->C6_PRCVEN,OrdenesCom->C5_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.99"											
      		@ li,colini+117 PSAY XMOEDA(OrdenesCom->C6_VALOR,OrdenesCom->C5_MOEDA,MV_PAR07,DDATABASE) Picture "@E 99,999,999.99"
    	Else
      		@ li,colini+98 PSAY XMOEDA(OrdenesCom->C6_PRCVEN,OrdenesCom->C5_MOEDA,MV_PAR07,stod(OrdenesCom->C5_EMISSAO)) Picture "@E 99,999,999.999999"											
      		@ li,colini+117 PSAY XMOEDA(OrdenesCom->C6_VALOR,OrdenesCom->C5_MOEDA,MV_PAR07,stod(OrdenesCom->C5_EMISSAO)) Picture "@E 99,999,999.99"  
    	Endif
    	If empty(OrdenesCom->C5_EMISSAO)
       		nTotalval:=nTotalval + XMOEDA(OrdenesCom->C6_VALOR,OrdenesCom->C5_MOEDA,MV_PAR07,DDATABASE)
    	Else           
       		nTotalval:=nTotalval + XMOEDA(OrdenesCom->C6_VALOR,OrdenesCom->C5_MOEDA,MV_PAR07,stod(OrdenesCom->C5_EMISSAO))
    	Endif
    	If Len(AllTrim(OrdenesCom->C6_UESPECI)) > 60
    		li++
    		@ li,colini+18 PSAY AllTrim(Right(OrdenesCom->C6_UESPECI,20))																	
    	EndIf
    	moneda :=OrdenesCom->C5_moeda  
    	glosa:=""//OrdenesCom->C5_UGLOSA 
  		//alert("entro al while")
    	li++   
    	j++ 
    	OrdenesCom->(dbSkip())   
 	End     
 	@ li,colini PSAY REPLICATE('_',limite)          
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
 dFecha := STOD(OrdenesCom->C5_EMISSAO)
 dFechaVen := STOD(OrdenesCom->C6_ENTREG)
 dFechaEnt := STOD(OrdenesCom->C5_FECENT)
 li := 6
 colini:= 10
 @ li,colini PSAY "Fecha: " + CValToChar(DAY(dFecha))+ " DE " + UPPER(dFechaToMes(dFecha)) + " DE " + CValToChar(YEAR(dFecha))  //ffechalatin(Presupto->CJ_EMISSAO) 
 @ li,150 PSAY "Numero: " + substr(OrdenesCom->C5_NUM,1,14)
 li++
 @ li,colini PSAY "Cliente: " + AllTrim(OrdenesCom->C5_CLIENTE) + " - " + AllTrim(OrdenesCom->A1_NOME)
 @ li,150 PSAY "N.I.T.: " + OrdenesCom->A1_CGC
  li++
 @ li,colini PSAY "Direccion: " + OrdenesCom->A1_END
 _nTipoCambio = POSICIONE("SM2",1,OrdenesCom->C5_EMISSAO,"M2_MOEDA2")
 @ li,150 PSAY "T.C.: " + TRANSFORM(_nTipoCambio,"@E 99.99")   
 li++
 @ li,colini PSAY "Vendedor: " +  substr(OrdenesCom->A3_NOME,1,50) 
 @ li,150 PSAY "PM: " +  CValToChar(OrdenesCom->C5_DESC1) + "%" 
 li++
 @ li,colini PSAY REPLICATE('_',limite)  
 li++
 @ li,colini PSAY "Nombre Factura: " + OrdenesCom->C5_UNOMCLI
 @ li,150 PSAY "NIT Factura: " + CVALTOCHAR(OrdenesCom->C5_UNITCLI)   
 li++
 @ li,colini PSAY "Vencimiento General: " + CValToChar(DAY(dFechaVen))+ " DE " + UPPER(dFechaToMes(dFechaVen)) + " DE " + CValToChar(YEAR(dFechaVen))
 @ li,150 PSAY "Forma de Pago: " + Iif(OrdenesCom->C5_CONDPAG=="002","CONTADO","CREDITO")   //OrdenesCom->E4_DESCRI // 
 li++
 @ li,colini PSAY "Fecha de Entrega: " + CValToChar(DAY(dFechaEnt))+ " DE " + UPPER(dFechaToMes(dFechaEnt)) + " DE " + CValToChar(YEAR(dFechaEnt))
 @ li,150 PSAY "Moneda del Pedido: " + Iif(OrdenesCom->C5_MOEDA == 1, "BOLIVIANOS","DOLARES") 
 li++
 @ li,colini PSAY "Ped.Compra Cliente: " + OrdenesCom->C5_UNUCOCL
 @ li,150 PSAY "Peso Bruto: " + TRANSFORM(OrdenesCom->C5_PBRUTO, "@E 999,999.9999")
 li++
 @ li,colini PSAY "Transporte: " + OrdenesCom->C5_TRANSP
 @ li,150 PSAY "Licitación: " + OrdenesCom->C5_COTACAO 
 li++
 @ li,colini PSAY REPLICATE('_',limite)  
 li++
 @ li,colini PSAY "Deposito de Entrega: " + OrdenesCom->C6_LOCAL + " - " + OrdenesCom->NNR_DESCRI
 @ li,80 PSAY "Dirección: " + OrdenesCom->NNR_UDIREC  
 li++
 @ li,colini PSAY "Lugar de Entrega: " + OrdenesCom->C5_ULUGENT
 li++
 @ li,colini PSAY "Observación: " + OrdenesCom->C5_UOBSERV  
 li++
 @ li,colini PSAY REPLICATE('_',limite)  
 li++

 //@ li,02 PSAY REPLICATE('_',130)    												
 @ li,colini PSAY "Item"  
 @ li,colini +6 PSAY "Codigo" 						
// @ li,20 PSAY "Cod-Proveedor" 																	
 @ li,colini + 18 PSAY "Descripción" 																	
 @ li,colini + 82 PSAY "U/M."												
 @ li,colini + 92 PSAY "Cant."	
 @ li,colini + 106 PSAY "Precio"												
 @ li,colini + 124 PSAY "Total"	
 li++																		
 @ li,colini PSAY REPLICATE('_',limite)    												
 li += 2																		
 cUsrReg := OrdenesCom->C5_USRREG
 
Return		 

Static function total( _nTotalVal,moneda,cambio,li,glosa)
/*mone:=""	  
if cambio=1
 mone:="Bs."
else
 mone:="$Us" 	
endif 
*/
	colini := 10
 li++      
 @ li,colini+103 PSAY "Total Bs. " //+ mone 
 @ li,colini+116 Psay If(moneda == 1,_nTotalVal,(_nTotalVal * _nTipoCambio)) Picture "@E 99,999,999.99"      // Total
 li++      
 @ li,colini+103 PSAY "Total $Us. " //+ mone 
 @ li,colini+116 Psay If(moneda == 2,_nTotalVal,(_nTotalVal / _nTipoCambio)) Picture "@E 99,999,999.99"      // Total
 li++
 @ li, colini+02 PSAY "OBSERVACION: NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES"
 li:=li+10     
// @ li, 04 PSAY "________________" 
 @ li, 65 PSAY "_____________" 
 @ li, 95 PSAY "_____________"
 @ li, 125 PSAY "_____________"
 li++    
// @ li, 04 PSAY "Administración"  
 @ li, 68 PSAY "Deposito"   
 @ li, 98 PSAY "Vendedor"    
 @ li, 128 PSAY "Cliente"   
 @ 65,colini PSAY PADC("Contacto: " + AllTrim(cUsrReg) + "   |   E-Mail: " + UsrRetMail(cCodUser(cUsrReg)),130)
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
aAdd(aRegs,{"05","De Nro. Nota            :","mv_ch5","C",20,0,0,"G","mv_par05",""       ,""            ,""        ,""     ,"",""})
aAdd(aRegs,{"06","A Nro. Nota             :","mv_ch6","C",20,0,0,"G","mv_par06",""       ,""            ,""        ,""     ,"",""})
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