#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"                                                                                                                                     
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR777  ³ Autor ³ Amby Arteaga Rivero   ³ Data ³ 12.07.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pick-List (Expedicao)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR777(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mercantil LEON - SAnta Cruz                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PickList()
Local wnrel   := "MATR777"
Local tamanho := "M"
Local titulo  := ANSITOOEM("Pick-List") //"Pick-List  (Expedicao)"
Local cDesc1  := ANSITOOEM("Emision de Productos") //"Emiss„o de produtos a serem separados pela expedicao, para"
Local cDesc2  := ANSITOOEM("") //"determinada faixa de pedidos."
Local cDesc3  := ""
Local cString := "SC6"
Local cPerg   := "MTR777"

PRIVATE aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 } //"Zebrado"###"Administracao"
PRIVATE nomeprog := "MATR777"
PRIVATE nLastKey := 0
PRIVATE nBegin   := 0
PRIVATE aLinha   := {}
PRIVATE limite   := 140
PRIVATE lRodape  := .F.
PRIVATE m_pag    := 1
PRIVATE nCantReg := 50          
PRIVATE nContReg := 0           
Private nTipo    := 15

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaSX1(cPerg)
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                      ³
//³ mv_par01  De Pedido                                       ³
//³ mv_par02  Ate Pedido                                      ³
//³ mv_par03  Imprime pedidos ? 1 - Estoque                   ³
//³                             2 - Credito                   ³
//³                             3 - Estoque/Credito           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                     
//---------------------------
cTime := TIME() // Resultado: 10:37:17
cHora := SUBSTR(cTime, 1, 2) // Resultado: 10
cMinutos := SUBSTR(cTime,  4, 2) // Resultado: 37
cSegundos := SUBSTR(cTime, 7, 2) // Resultado: 17
                           
wnrel := cHora + cMinutos + cSegundos // Cambiando el nombre del Informe a guardar
//---------------------------
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,.F.,.T.,Tamanho,,.F.)
//wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)
If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C777Imp(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,@cDesc2,@cDesc3)},Titulo) 

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C777IMP  ³ Autor ³ Flavio Luiz Vicco     ³ Data ³ 30.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR777                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C777Imp(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,cDesc3)
Local cabec1	 := "Nro. Pedido: " + SC5->C5_NUM + "  Cliente: " + SC5->C5_CLIENTE+'-'+SC5->C5_LOJACLI + " - " +POSICIONE('SA1',1,XFILIAL('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),'A1_NOME') + "Despacho: " + Iif(SC5->C5_DOCGER == '1'," Interno",Iif(SC5->C5_DOCGER == '2',"Externo",""))+" Emisión PV:" + DTOC(SC5->C5_EMISSAO)
Local cabec2 	 := OemToAnsi("Codigo          Descripcion Producto                     UM  Ctd Vendida      Precio       Monto      Alm   Ubicacion       Lote ") //"Codigo          Desc. do Material              UM Quantidade  Amz Endereco       Lote      SubLote  Validade   Potencia    Pedido"
Local lFirst 	 := .T.
Local cbtxt      := SPACE(10)
Local cbcont	 := 0
Local lQuery     := .F.
Local cEndereco  := ""
Local nQtde      := 0
Local cAliasNew  := "SC6"     
Local _nDescuento := 0           
Local _cCodKit := GETNEWPAR("MV_CODKIT",'KIT')
#IFDEF TOP
	Local aStruSC9   := {}
	Local cName      := ""
	Local cQryAd     := ""
	Local nX         := 0
#ELSE
	Local cFilter    := ""
	Local cKey 	     := ""
#ENDIF

titulo := ANSITOOEM("PICK-LIST") //"PICK-LIST" 
IF SELECT('SC6') > 0           //Verifica se o alias OC esta aberto
   SC6->(DbCloseArea())       //Fecha o alias OC
END
#IFDEF TOP
	lQuery := .T.
	cQuery := "SELECT R_E_C_N_O_,C6_NUM,C6_QTDVEN,"
	cQuery += "C6_FILIAL,C6_QTDVEN,C6_QTDEMP, C6_PRODUTO, C6_LOCAL, "
	cQuery += "C6_LOTECTL, C6_POTENCI,C6_PRCVEN,C6_VALOR,"
	cQuery += "C6_NUMLOTE, C6_DTVALID, C6_LOCALIZ, C6_DESCRI,C6_DESCONT,C6_VALDESC,C6_TES,C6_BLQ "
	cQuery += cQryAd
	cQuery += " FROM "
	cQuery += RetSqlName("SC6") //+ " SC6 "
	cQuery += " WHERE C6_FILIAL  = '"+xFilial("SC6")+"'"
	cQuery += " AND  C6_NUM >= '"+mv_par01+"'"
	cQuery += " AND  C6_NUM <= '"+mv_par02+"'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY C6_FILIAL,C6_NUM,C6_ITEM,C6_LOJA,C6_PRODUTO,C6_LOTECTL,"
	cQuery += " C6_NUMLOTE,C6_DTVALID"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cString,.T.,.T.)
#ELSE          
	dbSelectArea(cString)
	cIndexSC9 := CriaTrab(nil,.F.)
	cKey :="C6_FILIAL+C6_NUM++C6_ITEM+C6_PRODUTO"
	cFilter := "C6_NUM  = '" + xFilial("SC6") + "' .And. "
	cFilter += "C6_NUM >= '"+mv_par01+"' .And. "
	cFilter += "C6_NUM <= '"+mv_par02+"'"

 	IndRegua(cString,cIndexSC9,cKey,,cFilter,STR0008) //"Selecionando Registros..."
	dbSetIndex(cIndexSC9+OrdBagExt())

#ENDIF
_nContIt:=0
_nPag:=1
_nTotal:=0
SetRegua(RecCount())
(cString)->(dbGoTop())
avalimp(132)
//Setprc(0,0)
SET DEVICE TO PRINT
li:=PROW()
li:=CabHP()

While (cString)->(!Eof())
	If lEnd
		@PROW()+1,001 Psay "Cancelado por el Operador" //"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	If !lQuery
		IncRegua()
	EndIf

   	If _nContIt >= nCantReg
       _nPag++
	   If _nPag > 1
          @ li,00 PSAY REPLICATE('_',limite) 
          li+=2
	      @ li, 000 PSAY PadC("****** CONTINUA EN LA PAGINA: "+ALLTRIM(STR(_nPag,2))+"*******", limite)
	      li=100                                     
	   End         
	   
	   li:=CabHP()
	   _nContIt := 0
	Endif
	

	If EMPTY((cAliasNew)->C6_BLQ) 
		nContReg += 1
		SB1->(dbSeek(xFilial("SB1")+(cAliasNew)->C6_PRODUTO))
		@ li, 00 Psay nContReg	Picture "@E 999"
		@ li, 04 Psay alltrim((cAliasNew)->C6_PRODUTO)	Picture "@!"
	    @ li, 16 PSAY SB1->B1_ESPECIF  Picture "@!"
		@ li, 98 Psay SB1->B1_UM   				Picture "@!"
		@ li,101 Psay (cAliasNew)->C6_LOCAL
		@ li,106 Psay (cAliasNew)->(C6_QTDVEN)	Picture "@E 9,999,999.99"
		@ li,119 Psay "____________________"               
				     			
	//	If Select("KIT") > 0
	//	   KIT->(DbCloseArea())
	//	End                      
			    
	EndIf
	li+=1
	_nContIt++                

	_cUsuario:= Substr(CUsuario,7,15)
	#IFNDEF TOP
	  //	SDC->(dbSkip())
	//EndDo
	#ENDIF
	(cString)->(dbSkip())
EndDo  

li-=1
If _nPag > 0 
	If li >= 60
      _nPag++
       li++
       @ li,00 PSAY REPLICATE('_',limite) 
       li+=2
	   @ li, 000 PSAY PadC("****** CONTINUA EN LA PAGINA: "+ALLTRIM(STR(_nPag,2))+"*******", limite)
	   li=100
	   li:=CabHP()                                     
	EndIf
	li++       
	@ li, 00 PSAY REPLICATE('_',limite)
	li+=5
	@li,010 PSAY "		      __________________________________        ________________________         ___________________"
	li+=1
	@li,008 PSAY "                    RecIbido Por:                           Firma                  Documento Identidad"
	li+=2
	@li,000 PSAY REPLICATE('_',limite)
	li+=1                             
	@li, 000 PSAY "Impreso Por: " + Upper(_cUsuario)	

	_cUser := Embaralha(SC5->C5_USERLGI,1)
	_cUsuarioA := If (!Empty(_cUser),Subs(_cUser,1,15),"")

 	@li, 050 PSAY "Elaborado por: "+SC5->C5_USRREG

   SETPRC(0,0)
 End

SC6->(DbCloseArea()) 

SET DEVICE TO SCREEN
If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
EndIf                                                                                
SetpgEject(.F.)
MS_FLUSH()

Return NIL                                  
                                                                                 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³Autor  ³ Flavio Luiz Vicco     ³ Data ³ 30.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATR777                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)
Local aHelpPor01 := {"Informe o numero do pedido inicial a ser ",    "considerado na selecao."}
Local aHelpEng01 := {"Enter the initial order number to be taken in","consideration."}
Local aHelpSpa01 := {"Digite el numero del pedido inicial que debe ","considerarse en la seleccion."}
Local aHelpPor02 := {"Informe o numero do pedido final a ser ",    "considerado na selecao."}
Local aHelpEng02 := {"Enter the final order number to be taken in","consideration."}
Local aHelpSpa02 := {"Digite el numero del pedido final que debe ","considerarse en la seleccion."}
Local aHelpPor03 := {"Seleciona a condicao do pedido de compras a",    "ser impressa."}
Local aHelpEng03 := {"Select the purchase order terms to print.",      ""}
Local aHelpSpa03 := {"Elija la condicion del pedido de compras que se","debe imprimir."}
PutSX1(cPerg,"01","De pedido ?",       "¿De pedido ?",       "From order ?","mv_ch1","C",6,0,0,"G","","","","","mv_par01","","","","",      "","","","","","","","","","","","",aHelpPor01,aHelpEng01,aHelpSpa01)
PutSX1(cPerg,"02","Ate pedido ?",      "¿A pedido ?",        "To order ?",  "mv_ch2","C",6,0,0,"G","","","","","mv_par02","","","","zzzzzz","","","","","","","","","","","","",aHelpPor02,aHelpEng02,aHelpSpa02)
//PutSX1(cPerg,"03","Pedidos liberados?","¿Pedidos Aprobados?","orders ?",    "mv_ch3","N",1,0,3,"C","","","","","mv_par03","Estoque","Stock","Inventory","","Credito","Credito","Credit","Credito/Estoque","Credito/Stock","Credit/Invent.","","","","","","",aHelpPor03,aHelpEng03,aHelpSpa03)
//if(FUNNAME()== 'MATA410')
   SX1->(DbSetOrder(1))
If SX1->(DbSeek(cPerg+Space(4)+'01'))               
   RecLock('SX1',.F.)
   SX1->X1_CNT01 := SC5->C5_NUM
   SX1->(MsUnlock())
End
If SX1->(DbSeek(cPerg+Space(4)+'02'))
   RecLock('SX1',.F.)
   SX1->X1_CNT01 := SC5->C5_NUM
   SX1->(MsUnlock())
End
//End
Return     

//---------------------------------------------------------------------------------------------------------
Static Function CabHP()
//SetPrc(0,0)    
li := 1
//@ li,00 PSAY CHR(27)+'x'+'0'
@ li,00 PSAY CHR(15)+Chr(27)+Chr(71)+SM0->M0_NOMECOM  //"M E R C A N T I L ''L E O N''"
@ li, 125 PSAY 'Pagina.:' + ALLTRIM(STR(_nPag,2))
@ li+1,000 PSAY PADC(" P I C K - L I S T   ",limite)
@ li+1,108 PSAY OemToAnsi('Fecha de impresión: ')+dtoc(DATE())
@ li+2,108 PSAY OemToAnsi('Hora de impresión: ') + Time()
Titulo := "Nro.       " + AllTrim(SC5->C5_NUM) + " " +  IIf(SC5->C5_MOEDA == 1, "(en Bolivianos)", "(en Dolar)")  
Titulo += "        Tipo Cliente: " + RTRIM(IIF(SC5->C5_TIPOCLI $ '1|2|3','GRAN CONTRIBUYENTE',IIF(SC5->C5_TIPOCLI=='6','EXENTO','')))                           
@ li+3,000 PSAY RTRIM(titulo)
@ li+3,108 PSAY "Sucursal: " + RTRIM(SM0->M0_FILIAL)  //+ Tabela("ZA",C5->C5_LOCAL) + Space(10) + 'Tipo de Movimiento: ' + Posicione('SF5',1,xFilial('SF5')+SD3->D3_TM,'F5_TEXTO')
@ li+4,00 PSAY "Cliente:   " + SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI + " " + ANSITOOEM(RTRIM(Posicione("SA1",1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")))
@ li+4,108 PSAY "TC:" + TRANSFORM(POSICIONE("SM2",1,SC5->C5_EMISSAO,"M2_MOEDA2"),"@E 999.99")  
@ li+5,000 PSAY OemToAnsi("Dirección: "  + Posicione("SA1",1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_END"))
@ li+5,108 PSAY OemToAnsi("Fecha de Emisión:") + DTOC(SC5->C5_EMISSAO)
@ li+6,108 PSAY "Despacho: " + Iif(SC5->C5_DOCGER == '1'," Interno",Iif(SC5->C5_DOCGER == '2',"Externo","Entrega Futura"))
@ li+7,000 PSAY "Vendedor:  " + ANSITOOEM(Posicione("SA3",1,xFilial('SA3')+SC5->C5_VEND1,"A3_NOME"))
                        
cTRemito := ""
If SC5->C5_TIPOREM == "0"
	cTRemito := "Ventas"
Else
	If SC5->C5_TIPOREM == "A"
		cTRemito := "Consignación"
	else
		If SC5->C5_TIPOREM == "R"
			cTRemito := "Reparacion en Gtia"
		EndIf
	EndIf
EndIf

@ li+7,108 PSAY "Tipo Remito:  " + OemToAnsi(cTRemito)

@ li+8,108 PSAY "Cond. De Pago:  " + POSICIONE('SE4',1,XFILIAL('SE4')+SC5->C5_CONDPAGO,'E4_DESCRI')

 @ li+9,02 PSAY REPLICATE('_',130)  
 @ li+10,02 PSAY "Deposito de Entrega: " + SC6->C6_LOCAL + " - " + POSICIONE('NNR',1,XFILIAL('NNR')+SC6->C6_LOCAL,'NNR_DESCRI')
 @ li+10,80 PSAY "Dirección: " + NNR->NNR_UDIREC  
 @ li+11,02 PSAY "Lugar de Entrega: " + SC5->C5_ULUGENT
 @ li+12,02 PSAY "Observación: " + SC5->C5_UOBSERV  

li:=li+13

//Obtendo o campo de Observações
cVar   := ""//SD3->D3_OBS
If !Empty(cVar)      
   @ li,00 PSAY 'Obs.:'
   nLinha := MlCount(cVar,120)
   For i:=1 to nLinha
       cLinha:=  Memoline(cVar,120,i,,.T.)
       @ li,010 PSAY cLinha
       li+=1
   Next i
End

@ li,00 PSAY REPLICATE('_',limite)
li:=li+1
   @ li,00 PSAY "NRO CODIGO      DESCRIPCION ESPECIFICA                                                            UM ALM      CANTIDAD  OBSERVACIONES"
	//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//                      10        20        30        40        50        60        70        80        90        100       110       120
li:=li+1
@ li,00 PSAY REPLICATE('_',limite)
li:=li+1
Return(li)

