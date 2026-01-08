#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "Protheus.ch"                                
#INCLUDE "TBICONN.CH"
// #INCLUDE "FWPrintSetup.ch"

#DEFINE IMP_SPOOL 2
                        

user function FactQR()
//Private oPrinter   

local nline:=10   

Local aArPrint	:= {} 
Local aRegSl1	:= {}     
Local varlong	:= 0     
Private oPrinter   
//////////*********PRIMERO
Private nTotImps	:= 0		//Total de impostos
Private nX			:= 0		//Contador de for
Private aTesImpInf	:= {}		//TES
Private aRegSF2		:= {}		//Registros do SF2
Private aRegSL1		:= {}		//Registros do SL1
Private nY			:= {}		//Contador de For
Private nL1ValISS	:= 0		//Total ValorIss
Private nL1ValIcm	:= 0		//Total valor ICM
Private aDadosTef	:= {}
Private nTotc		:= 250		// antes estaba ,500
Private _nTotal		:= 0
Private cperg		:= PADR("FAC010",10)
Private aRegs		:= {}     

/////////*********SEGUNDO
//Local aArPrint	:= {} 
//Local aRegSl1		:= {}     
//Local varlong		:= 0     
Private nPagina		:= 0  
Private cSC5Tvent
Private cC5NUM
Private cPedido
Private cF2EMISSAO
Private nCTPTAXA
Private cDoc
Private cSerie
Private cCliente
Private cTienda
Private nLinea		:= 42
Private totalf		:= 0
Private totalfin	:= 0
Private descon		:= 0 
private preco1
private preco
private taxam
private vendedor  
private subt
private qr // para mandar el string del QR

Private oQrCode


//Private oPrint
aAdd(aRegs,{cPerg,"01","Factura de         ?","Factura de              ?","Factura de             ?","mv_ch1","C",13,0,0,"G","","mv_par01", "","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Factura Hasta      ?","Factura Hasta           ?","Factura Hasta          ?","mv_ch2","C",13,0,0,"G","","mv_par02", "","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Serie              ?","Serie                   ?","Serie                  ?","mv_ch3","C",03,0,0,"G","","mv_par03", "","","","","","","","","","","","","","",""})


//inicio solange
             
IF(FUNNAME()=='LOJA701')    
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+Space(4)+'01'))               
   	RecLock('SX1',.F.)                              
   	SX1->X1_CNT01 := SF2->F2_DOC
   	SX1->(MsUnlock())
   End
   If SX1->(DbSeek(cPerg+Space(4)+'02'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  SF2->F2_DOC
    SX1->(MsUnlock())
   END  
   If SX1->(DbSeek(cPerg+Space(4)+'03'))

    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  SF2->F2_SERIE
    SX1->(MsUnlock())
   END   
   
   
   	//Pergunte("NFSIGW",.F.)
   	
   	Private MV_PAR01 := SF2->F2_DOC
   	Private MV_PAR02 := SF2->F2_DOC
   	Private MV_PAR03 := SF2->F2_SERIE
   	Private MV_PAR04 := 2
   	
Else
	//+-------------------------------------------------------------------------+
	//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
	//+-------------------------------------------------------------------------+  
	//Pergunte("NFSIGW",.T.)               // Pergunta no SX1	
	Private MV_PAR01 := SF2->F2_DOC
   	Private MV_PAR02 := SF2->F2_DOC
   	Private MV_PAR03 := SF2->F2_SERIE
   	Private MV_PAR04 := 2
   	cFatIni	:= SF2->F2_DOC
   	cFact	:=  SF2->F2_DOC
	cSer	:= SF2->F2_SERIE   
    
END

	pergunte(cPerg,.F.)//.T.
   
	oFont6TN := TFont():New("Times New Roman",,-11,.T.)	
	oFont16T := TFont():New("Draft",,-09,.F.)
// 	oFont18T := TFont():New("Roman",,14,,.F.)

	If oPrinter == Nil
 		lPreview := .T.
		oPrinter      := FWMSPrinter():New('Factura',6,.F.,,.T.,,,,,.F.) 
  		///***nuevo    
      
      	///***fin nuevo
		oPrinter:SetPortrait()
		oPrinter:Setup()
		oPrinter:SetPaperSize(9)
		oPrinter:SetMargin(05,05,05,05)
		oPrinter:cPathPDF :="C:\"
	EndIf       

 oPrinter:StartPage()
// oPrinter:Box(10,10,400,501)

//cFatIni	:= mv_par01
//cFact	:= mv_par02
//cSer	:= mv_par03   

dbSelectArea("SF2")
dbSetOrder(2)
(dbSeek(xFilial("SF2")+SF2->(F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE)))
cDocum := SF2->F2_DOC

If !(dbSeek(xFilial("SF2")+SF2->(F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE)))     
	Alert("No existe el Documento")
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo sf2 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(aRegSL1,{SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, ;
		SF2->F2_LOJA, SF2->F2_PDV, SF2->F2_NUMAUT, SF2->F2_CODCTR, SF2->F2_LIMEMIS})	
				                  
/*			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de Clientes							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SA1" )
dbSeek( xFilial("SA1")+SF2->F2_CLIENTE )
//cL1_NUM := SL1->L1_NUM
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de Vendedores 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SA3" )
dbSeek( xFilial("SA3")+SF2->F2_VEND1 )
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de Clientes						     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
SF3->(DbSetOrder(4))
SF3->(DbSeek(XFILIAL('SF3')+SF2->(F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE)))
  

		dbselectarea("SE1")
		dbsetorder(1)		// E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA
		dbgotop()
		SE1->(dbseek(xfilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC))
		
		dbselectarea("SB1")
		dbsetorder(1)		// B1_FILIAL+B1_COD
		
		dbselectarea("SA1")
		dbsetorder(1)		// B1_FILIAL+B1_COD
		
		dbselectarea("SD2")
		nIndSD2:=indexord()
		dbsetorder(3)
		
		dbSelectArea("SF2")         
		nIndSF2:=indexord()
		dbSetOrder(1)               
		
		if empty(cFatIni)
			SF2->(dbgotop())
			SD2->(dbgotop())	
		endif
		
		dbSeek(xFilial("SF2")+cFatIni+cSer,.T.)
		
		cFatIni := SF2->F2_DOC


dbSelectArea("SA1")
nLine := 40
titulo := AllTrim(SM0->M0_NOME)//+" IMPORT & EXPORT S.R.L."
lenTit := Len(titulo) 
nCol := medioCol(nTotc,lenTit)
//oPrinter:SAY(nline,nCol,Titulo,oFont6TN, 400, CLR_BLACK)
oPrinter:SAY(40,490,SF2->F2_DOC,oFont6TN,400,CLR_BLACK,CLR_BLACK)//; oPrinter:SkipLine(3.5)

cDia   := SUBS(DTOC(SF2->F2_EMISSAO),1,2)
cAnio  := NtoC(YEAR(SF2->F2_EMISSAO), 10)
cFecha := cDia + " de " + MesExtenso(Month(SF2->F2_EMISSAO)) + " del " + cAnio
oPrinter:SAY(100,90,cFecha,oFont6TN,1000,CLR_BLACK,CLR_BLACK)
nline:=nline+10

titulo := 'De: CIMA S.R.L.'//+" IMPORT & EXPORT S.R.L."
lenTit := Len(titulo) 
nCol := medioCol(nTotc,lenTit)
//oPrinter:SAY(nline,nCol,titulo,oFont6TN, 400, CLR_BLACK)
_DESCTES1:=0
nline:=nline+10

	        dbselectarea("SD2")
			dbseek(xFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			_cPedido:= SD2->D2_PEDIDO
			_cCond	:= Posicione("SC5",1,xFilial("SC5")+_cPedido,"C5_CONDPAG")

			If SA1->(DbSeek(xFilial('SA1')+SF2->(F2_CLIENTE+F2_LOJA)))
	     		//RS Preguntar a Nain si es correcto que saque de ahi el nombre y direccion.
	     		_cCondV	:= GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+SF2->F2_COND,1,"") //RS
				_cNome	:= IF(Empty(SC5->C5_MENNOTA),SA1->A1_NOME,SC5->C5_MENNOTA)
				_cEnd	:= Alltrim(IF(Empty(SC5->C5_MENNOTA),SA1->A1_END,SC5->C5_MENNOTA)+AllTrim(SA1->A1_BAIRRO))
				_cCGC	:= SA1->A1_CGC
				_cVend	:= GetAdvFVal("SA3","A3_NOME",xFilial("SA3")+SC5->C5_VEND1,1,"") //RS
				_cLoc	:= AllTrim(SA1->A1_MUN)
			
				oPrinter:SAY(110,90,ANSITOOEM(_cNome),oFont6TN,1000,CLR_BLACK,CLR_BLACK)
				oPrinter:SAY(110,350,_cCGC,oFont6TN,1000,CLR_BLACK,CLR_BLACK)//; oPrinter:SkipLine(3.5)
			End
	        
			nTotImp		:= (nTotItem:=0)  
			_nValBrut	:= _nValNeto:=0
			_nDescItem	:= 0
			_cPedido	:= ''
			aPrd		:= {}
			while SD2->D2_DOC==SF2->F2_DOC .and. SD2->D2_SERIE==SF2->F2_SERIE .and. SD2->D2_CLIENTE==SF2->F2_CLIENTE .and. SD2->D2_LOJA==SF2->F2_LOJA .and. !eof()
				If (SC6->(dbseek(xFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)))
					_cNome := SC6->C6_DESCRI       
					_cPedido := SD2->D2_PEDIDO
				Else   
					SB1->(dbseek(xFILIAL("SB1")+SD2->D2_COD))
					_cNome := SC6->C6_DESCRI
				EndIf
				_lAchou := .F.
				
				If Len(aPrd) > 0
					For I := 1 to Len(aPrd)
						If aPrd[I,1] == SD2->D2_COD 
							//se nao for bonificacao
							_lAchou := .T.
							If Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_DUPLIC") == "S"
								aPrd[I,4] += SD2->D2_QUANT
								aPrd[I,7] += SD2->(D2_QUANT*D2_PRCVEN)
								aPrd[I,8] += SD2->D2_DESC
								aPrd[I,9] += SD2->D2_TOTAL
							Else
								aPrd[I,5] += SD2->D2_QUANT
							EndIf
						EndIf
					Next          
				EndIf
				
				If !(_lAchou)
					aAdd(aPrd,{SD2->D2_COD, SD2->D2_LOTECTL, _cNome, SD2->D2_QUANT, 0, SD2->(D2_PRCVEN), SD2->(D2_PRCVEN + (D2_DESPESA/D2_QUANT) + (D2_SEGURO/D2_QUANT)), SD2->D2_DESC, SD2->D2_TOTAL,SD2->D2_PEDIDO,SD2->D2_TES,SD2->(D2_PRUNIT),SD2->D2_DESC,SD2->D2_DESCON,SD2->(D2_PRUNIT + (D2_DESPESA/D2_QUANT) + (D2_SEGURO/D2_QUANT))})
	            EndIf
	            
				SD2->(dbskip())
			Enddo

			aSort(aPrd,,,{|x,y| x[1] > y[1]})
			_nValorTesDesc	:= 0   
			_montosparciales:= 0   
			_DESCUENTO		:= 0     
		    _nDesc			:= 0
		    nLin			:= 150
			For I := 1 to len(aPrd)
				oPrinter:SAY(nLin,050,aPrd[I,1],oFont16T,1000,CLR_BLACK,CLR_BLACK)								//Codigo		//RS
				oPrinter:SAY(nLin,090,Transform(aPrd[I,4],"@E 999,999"),oFont16T,1000,CLR_BLACK,CLR_BLACK)		//Cantidad		//RS
				oPrinter:SAY(nLin,160,ANSITOOEM(aPrd[I,3]),oFont16T,1000,CLR_BLACK,CLR_BLACK)					//Descripción	//RS
				If !(aPrd[I,4] $ '700')
					oPrinter:SAY(nLin,400,Transform(aPrd[I,6],"@E 999,999.99"),oFont16T,1000,CLR_BLACK,CLR_BLACK)	//P. Unitario	//RS
					//				oPrinter:SAY(nLin,1840,Transform(aPrd[I,8],"@E 999,999.99"),oFont16T,1000,CLR_BLACK,CLR_BLACK)	//Descuento		//RS
					oPrinter:SAY(nLin,500,Transform(aPrd[I,9],"@E 999,999.99"),oFont16T,1000,CLR_BLACK,CLR_BLACK)	//P. Total		//RS
				end
	
				// descuento
				if (aPrd[I,12] > aPrd[I,6])
					_montosparciales+= round(aPrd[I,4] * aPrd[I,7],2)  // aPrd[I,13] + aPrd[I,14]   
					_nValNeto		:=_nValNeto + round(aPrd[I,4] * aPrd[I,15],2)
					_nDesc			:=_nDesc+ ((aPrd[I,12] - aPrd[I,6]) * aPrd[I,4]  )
				elseif (aPrd[I,12] < aPrd[I,6])
			//		@ nLin,066 PSAY aPrd[I,7] picture "@E 999,999,999.9999"         // en recargo se imprime el precio de venta
			//		@ nLin,084 PSAY round((aPrd[I,4] * aPrd[I,7]),2) picture "@E 999,999,999.99"
				else
			//		@ nLin,066 PSAY aPrd[I,15] picture "@E 999,999,999.9999"
			//		@ nLin,084 PSAY round(aPrd[I,4] *  aPrd[I,15],2) picture "@E 999,999,999.99"
	                _nValNeto:=_nValNeto + round(aPrd[I,4] * aPrd[I,15],2)
				endif
	
				If _cPedido == ''
					_cPedido :=aPrd[I,10] 
				End   
			
				IF POSICIONE('SF4',1,XFILIAL('SF4')+aPrd[I,11],'F4_ESTOQUE')== 'S' .AND. POSICIONE('SF4',1,XFILIAL('SF4')+aPrd[I,11],'F4_DUPLIC')== 'N' .AND. POSICIONE('SF4',1,XFILIAL('SF4')+aPrd[I,11],'F4_GERALF')== '2'
				  	_nDescItem+=aPrd[I,8]
					_nValorTesDesc +=aPrd[I,7]  
					_DESCTES1:= _DESCTES1 + round(aPrd[I,4] * aPrd[I,7],2)
				
				ELSE
					_nValBrut += round(aPrd[I,7],2)
				END
				nLin += 10			
			Next

			cLin := Extenso(xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,SF2->F2_EMISSAO))+ ' ' + UPPER(GETMV('MV_MOEDAP1'))  //Converte valor para moneda 1 e imprime en BS

			oPrinter:SAY(300,460,Transform(SF2->F2_VALMERC,"@E 99,999,999,999.99"),oFont16T,1000,CLR_BLACK,CLR_BLACK)	//Sub total	//RS
			oPrinter:SAY(310,460,Transform(_nDescItem     ,"@E 99,999,999,999.99"),oFont16T,1000,CLR_BLACK,CLR_BLACK)	//Descuento	//RS
			oPrinter:SAY(320,460,Transform(SF2->F2_VALBRUT,"@E 99,999,999,999.99"),oFont16T,1000,CLR_BLACK,CLR_BLACK)	//TOTAL		//RS
			oPrinter:SAY(340,060,Memoline(cLin,70,1),oFont16T,1000,CLR_BLACK,CLR_BLACK)									//I. letras	//RS
			
//			qr := STR(VAL(SF2->F2_DOC),12) +"/"+ SF2->F2_NUMAUT +"/"+SF3->F3_RAZSOC
			qr := AllTrim(SM0->M0_CGC) +"|"+ AllTrim(SM0->M0_NOMECOM) +"|"+ AllTrim(SF2->F2_DOC) +"|"
			qr += AllTrim(SF2->F2_NUMAUT) +"|"+ DTOC(SF2->F2_EMISSAO) +"|"+ AllTrim(Transform(SF2->F2_BASIMP1,"@E 99,999,999,999.99")) +"|"
			qr += AllTrim(SF3->F3_CODCTR) +"|"+ DTOC(SF2->F2_LIMEMIS) +"|"+ "0" +"|"+ "0" +"|"
			qr += AllTrim(ANSITOOEM(_cNome)) +"|"+ If(empty(_cCGC), "0", AllTrim(_cCGC))
			U_QRTDEP(oPrinter,350,50,50,50,qr)
			
			oPrinter:SAY(360,250,SF3->F3_CODCTR			,oFont16T,1000,CLR_BLACK,CLR_BLACK)	//CODIGO DE CONTROL	//RS
			oPrinter:SAY(370,250,DTOC(SF2->F2_LIMEMIS)	,oFont16T,1000,CLR_BLACK,CLR_BLACK)	//F. LIMITE EMISION	//RS



// oPrinter:Say( 50, 20, "TESTE", oFont6TN, 400, CLR_HRED)
         
 oPrinter:EndPage()


 If lPreview
      oPrinter:Preview()
 EndIf                      

 FreeObj(oPrinter)
 oPrinter := Nil   
 
 return



Static Function medioCol(nTotCol,nLenTit)
//nTotCol := nTotCol * 3
//lenTit := lenTit * 3
nMulti := 2
If nLenTit >=20 .AND. nLenTit < 30
	nMulti := 3.5
ElseIf nLenTit >=30 .AND. nLenTit < 40
	nMulti := 4
ElseIf nLenTit >=40 .AND. nLenTit < 50
	nMulti := 4.2
ElseIf nLenTit >= 50
	nMulti := 4.5
Endif
nTotM := nTotCol / 2
nTitM := nLenTit * nMulti
nCol := nTotM - nTitM

Return nCol