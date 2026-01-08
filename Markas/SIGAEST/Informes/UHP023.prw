#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ HP023    º Autor ³ AP6 IDE            º Data ³  20/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ IMPRIME A NOTA DE EGRESO/INGRESO/CANJE                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function UHP023(_cDoc,_nMoneda)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Local cFunName := UPPER(Alltrim(FunName()))

PRIVATE cDesc1      := "Este programa tiene el objetivo de imprimir el informe "
PRIVATE cDesc2      := "de acuerdo con los parametros informados por el usuario."
PRIVATE cDesc3      := "Nota de Engreso/Ingreso"
PRIVATE cPict       := ""
PRIVATE titulo		:= ""
PRIVATE nLin       	:= 80

PRIVATE Cabec1      := ""
PRIVATE Cabec2      := ""
PRIVATE imprime     := .T.
PRIVATE aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "MODII" //"HP023" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "HP015"+Space(5)
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "MODII"  //"HP023" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString 	:= "SD3"

Private lCanje 		:= .F.

 If  SubStr(SD3->D3_CF,1,2) == "PR" .Or. Subs(SD3->D3_CF,3,1)$"2457"
	Alert("Este NO es un documento de Movimiento Interno")
 	Return
 Endif
Perg()
If Alltrim(Upper(FunName())) == 'MATA241'
   If SX1->(DbSeek(cPerg+'01'))
      Reclock('SX1',.F.)
      X1_CNT01 := SD3->D3_DOC
      SX1->(MsUnlock())
   End
Endif

//-----------------------------------
//Para imprimir Al grabar el documento.
//Cuando se inclui uno nuevo.
If Inclui 
   If SX1->(DbSeek(cPerg+'01'))
      Reclock('SX1',.F.)
      X1_CNT01 := cDocumento
      SX1->(MsUnlock())
   End
Endif

Pergunte(cPerg,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
wnrel := SetPrint(cString,NomeProg,Iif(Alltrim(Upper(FunName())) == 'MATA241',"",cPerg),@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)        

If _cDoc <> nil
	MV_PAR01 := _cDoc
	MV_PAR02 := _nMoneda
EndIf
                                   
                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  20/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _lPri := .T.   
Local _nValor := 0
Local _nTotal := 0                  
Local _cUsuario := ""                              
Local _nCont := 1       
Local nLin

dbSelectArea("SD3")
dbSetOrder(2) //filial + MV_PAR01 + cod
dbSeek(xFilial("SD3")+alltrim(MV_PAR01))

//lCanje := .t.
If SD3->D3_TM >= '500'
	titulo := "EGRESO POR CANJE"
Else
	titulo := "INGRESO POR CANJE"
Endif
                  
Titulo := Rtrim(Titulo) + "  Nr. " + SD3->D3_DOC

cDesc3:=titulo
_nContIt:=80
_nPag:=0

While !EOF() .And. xFilial("SD3")+alltrim(MV_PAR01) == SD3->(D3_FILIAL+alltrim(D3_DOC))
     If SD3->D3_TM <> '499' .AND. SD3->D3_TM <> '999'
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	/*
		If _nLin > 29 // Salto de Página. Neste caso o formulario tem 55 linhas...
	
			If !(_lPri) //nao eh o primeiro cabec
				nLin += 2  
				@nLin,00 PSAY "..."
				SetPrc(0,0)
				nLin := 00
				SetPrc(0,0)
			EndIf
	 		
			_lPri := .T.
			Do Case
				Case MV_PAR02 = 1
					_cMon := "Bolivianos"
				Case MV_PAR02 = 2
					_cMon := "Dolar"
			EndCase
	        
			Cabec1 := "MONEDA : " + _cMon
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   
		Endif         
	*/
	
		If _nContIt > 60  
	       _nPag++
		   If _nPag > 1
	          @ nLin,00 PSAY REPLICATE('-',limite) 
	          nLin+=2
		      @ nLin, 000 PSAY PadC("****** CONTINUA EN LA SIGUIENTE PAGINA *******", 132)
	          nLin+=3
	          @ nLin, 115 PSAY 'Pag.:' + Str(_nPag-1,2) 
	          nLin+=3
	          @ nLin,00 PSAY ''
		   End         
		   
		   nLIn:=CABHP()
		   _nContIt := 0
		Endif
		              
		@nLin,000 PSAY AllTrim(SD3->D3_COD)
		
		//@nLin,017 PSAY SD3->D3_LOTECTL
		cPartNum := SD3->D3_NUMSERI 
		@nLin,017 PSAY cPartNum
		
	    SB2->(dbSetOrder(1))
		SB2->(dbSeek(xFilial("SB2")+SD3->D3_COD+SD3->D3_LOCAL))
		                 
	    dbSelectArea("SD3")  	
		//@nLin,028 PSAY DTOC(D3_DTVALID)
		//@nLin,038 PSAY Left(POSICIONE("SB1",1,XFILIAL("SB1")+SD3->D3_COD,"B1_DESC"),10)
		cProdu := POSICIONE("SB1",1,XFILIAL("SB1")+SD3->D3_COD,"B1_DESC")
		@nLin,038 PSAY Substr(cProdu,1,30)    
		@nLin,080 PSAY SD3->D3_QUANT PICTURE "@E 9,999,999.9999"
		If !lCanje     
			_nValor := xMoeda(iif(empty(SB2->B2_CM2),SD3->D3_CUSTO2,SB2->B2_CM2),2,MV_PAR02,SD3->D3_EMISSAO)
			@nLin,100 PSAY _nValor PICTURE "@E 9,999,999.99"
			@nLin,112 PSAY _nValor * SD3->D3_QUANT PICTURE "@E 999,999,999.99"
		EndIf                                     
		nLin++       
		
		_nCont++
		_nTotal += _nValor * SD3->D3_QUANT
	    _cUsuario:=SD3->D3_USUARIO
	    _nContIt++
	End
	
    dbSelectArea("SD3")  	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

If _nPag > 0
	nLin++       
	@ nLin, 00 PSAY REPLICATE('-',limite)
	nLin++
	@ nLin, 106 PSAY "TOTAL..: "
	@ nLin, 116 PSAY _nTotal PICTURE "@E 9,999,999,999.99"
	nLin+=3
	
	@nLin, 000 PSAY "Elaborado Por: " + Upper(_cUsuario)
	@nLin, 050 PSAY "Entregado Por: "
	@nLin, 090 PSAY "Recebido Por: "

	@ If(nLin < 31,31,62), 115 PSAY 'Pag.:' + Str(_nPag,2) 
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return





Static Function CabHP()
SetPrc(0,0)                  
@ 000,00 PSAY CHR(15)
@ 000,00 PSAY 'NOMBRE DE LA EMPRESA'
@ 001,114 PSAY 'Fecha: '+dtoc(SD3->D3_EMISSAO)
Titulo := "  Nr. " + AllTrim(D3_DOC) + " " + IIf(MV_PAR02 == 1, "(en Bolivianos)", "(en Dolar)") 
@ 002,000 PSAY PADC(titulo,110)
@ 002,114 PSAY 'Hora: ' + Time()
@ 004,00 PSAY "Almacen...: " + SD3->D3_LOCAL +  Space(10) + 'Tipo de Movimiento: ' + Posicione('SF5',1,xFilial('SF5')+SD3->D3_TM,'F5_TEXTO')
/*If lCanje
   @ 005,00 PSAY "Cliente...: " + SD3->D3_CLIENTE+"-"+SD3->D3_LOJACLI + " " + Posicione("SA1",1,xFilial('SA1')+SD3->(D3_CLIENTE+D3_LOJACLI),"A1_NOME")
//else
//   @ 005,00 PSAY "Proveedor.: " + SD3->D3_TM + " " + Posicione("SF5",1,SD3->D3_TM,"F5_TEXTO")
Endif 
*/
nLin:=06
                        
/*
//Obtendo o campo de Observações
cVar   := SD3->D3_OBS
If !Empty(cVar)      
   @ nLin,00 PSAY 'Obs.:'
   nLinha := MlCount(cVar,120)
   For i:=1 to nLinha
       cLinha:=  Memoline(cVar,120,i,,.T.)
       @ nLin,010 PSAY cLinha
       nLin+=1
   Next i
End
  */
  
@ nLin,00 PSAY Replicate("-",132)
nLin+=1
if lCanje
    //@ nLin,00 PSAY "CODIGO          LOTE       VENCTO      PRODUCTO                                         CANTIDAD "
      @ nLin,00 PSAY "CODIGO          NRO.SERIE            PRODUCTO                                         CANTIDAD "
	//             999999 9999999999 9999999999999999999999999999999999999999999999999 99 9,999,999.9999
	//             0123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	//                      10        20        30        40        50        60        70        80    
Else
   //@ nLin,00 PSAY "CODIGO          LOTE       VENCTO       PRODUCTO                                         CANTIDAD        COSTO           TOTAL"
     @ nLin,00 PSAY "CODIGO          NRO.SERIE             PRODUCTO                                         CANTIDAD        COSTO           TOTAL"
	//             999999 9999999999 9999999999999999999999999999999999999999999999999 99 9,999,999.9999 9,999,999.99 9,999,999.99
	//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//                      10        20        30        40        50        60        70        80        90        100       110       120
Endif 
nLin:=nLin+1
@ nLin,00 PSAY REPLICATE('-',limite)
nLin:=nLin+1
Return(nLin)


Static Function Perg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR("RES010",10)
aRegs:={}


aadd(aRegs,{cPerg,"01","Documento: ","Documento:","Documento:","mv_ch1","C",13,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	endif
Next
dbSelectArea(_sAlias)
Return