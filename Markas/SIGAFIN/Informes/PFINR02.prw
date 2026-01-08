#INCLUDE "PROTHEUS.ch"
#INCLUDE "rwmake.ch"       
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบExecblock ณ PFINR02  บ Autor ณ MARCELO CAMPOS     บ Data ณ  03/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Imprime Recibo de Recebimento do Contas a Receber          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Projeto 0007 - Petroluz (Financeiro)                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/   

User Function PFINR02(_aParames)

	Default _aParames := {}
	
	Private _nE5RECNO:= 0

	Private oFont, cCode
	//5o parametro - negrito
	//10o parametro - underline
	private oFont  := TFont():New( "Arial",,15,,.f.,,,,,.f. )
	private oFont3 := TFont():New( "Arial",,13,,.t.,,,,,.f. )
	private oFontxx:= TFont():New( "Arial",,12,,.t.,,,,,.f. )
	private oFontxy:= TFont():New( "Arial",,14,,.f.,,,,,.f. )
	private oFont5 := TFont():New( "Arial",,11,,.f.,,,,,.f. )
	private oFont5n:= TFont():New( "Arial",,10,,.t.,,,,,.f. )
	private oFont17:= TFont():New( "Arial",,10,,.f.,,,,,.f. )
	private oFont9 := TFont():New( "Arial",,8,,.f.,,,,,.f. )
	private oFont1 := TFont():New( "Times New Roman",,28,,.t.,,,,,.f. )
	private oFont2 := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
	private oFont4 := TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	private oFont7 := TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
	private oFont11:= TFont():New( "Times New Roman",,18,,.t.,,,,,.t. )
	private oFont6 := TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )
	private oFont8 := TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
	private oFont10:= TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
	private oFont12:= TFont():New( "Arial",,16,,.t.,,,,,.t. )
	private oFont16:= TFont():New( "Arial",,16,,.t.,,,,,.f. )

	//Setando a Impressora e criando o Objeto Grแfico oPrn
	Private cPerg := Padr("FINR02",10)
	
	IF .T.//ALLTRIM(FUNNAME()) = "PFINR02"
		//Valida a Pergunta
		ValidPerg()
		Pergunte(cPerg,.T.)

		//Montando a Tela de Dialogo	
		@ 200,1 TO 380,380 DIALOG o_dlg TITLE OemToAnsi("Recibo de Recebimento (CR)")
		@ 02,10 TO 080,180
		@ 10,018 Say OemToAnsi("Esta rotina imprime o Recibo de Recebimento.")
		@ 18,018 Say OemToAnsi("")
		@ 26,018 Say OemToAnsi( ALLTRIM(SM0->M0_NOME) + " - " + ALLTRIM(SM0->M0_FILIAL) )       
		@ 34,018 Say OemToAnsi("Usuแrio.: " + SUBSTR(cUSUARIO, 7,15))
		@ 65,040 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
		@ 65,070 BMPBUTTON TYPE 01 ACTION RptStatus({|| RunReport()},"Recibo de Recebimento")
		@ 65,100 BMPBUTTON TYPE 02 ACTION Close(o_dlg)
		@ 65,130 BMPBUTTON TYPE 11 ACTION oPrn:Setup()
		Activate Dialog o_dlg Centered
	ELSE
		//Executa a impressao do recibo apos a baixa do titulo a pagar.
		ValidPerg()
		If Empty(_aParames)
			Pergunte(cPerg,.F.)	
			mv_par01 := SE1->E1_CLIENTE
			mv_par02 := SE1->E1_CLIENTE
			mv_par03 := SE1->E1_NATUREZ		
			mv_par04 := SE1->E1_NATUREZ
			mv_par05 := StoD('20000101')//SE5->E5_DATA
			mv_par06 := StoD('20991231')//SE5->E5_DATA
			mv_par07 := ""
			mv_par08 := "ZZZZ"
			mv_par09 := SE5->E5_BANCO
			mv_par10 := SE1->E1_NUM
			mv_par11 := SE1->E1_NUM
			mv_par12 := ''
			_nE5RECNO:= 0 //SE5->(Recno())
			RptStatus({|| RunReport()},"Recibo de Recebimento")
		Else
			Pergunte(cPerg,.F.)
			mv_par01  := _aParames[1] //SE1->E1_CLIENTE
			mv_par02  := _aParames[2] //SE1->E1_CLIENTE
			mv_par03  := _aParames[3] //SE1->E1_NATUREZ		
			mv_par04  := _aParames[4] //SE1->E1_NATUREZ
			mv_par05  := _aParames[5] //SE5->E5_DATA
			mv_par06  := _aParames[6] //SE5->E5_DATA
			mv_par07  := _aParames[7] //""  Lote de
			mv_par08  := _aParames[8] //"ZZZZ" Lote Ate
			mv_par09  := _aParames[9] //SE5->E5_BANCO   Banco
			mv_par10  := _aParames[10] //SE1->E1_NUM   Titulo De
			mv_par11  := _aParames[11] //SE1->E1_NUM   Titulo Ate
			mv_par12  := ''
			_nE5RECNO := 0
			RptStatus({|| RunReport()},"Recibo de Recebimento")
		EndIf
			
	ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRACAR002  บAutor  ณMicrosiga           บ Data ณ  06/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                     

Static Function RunReport()

Local _nLin := 0  
Local _aMotBx := fLisMot() 
Local _nPosMB := 0 
Local _lContinua := .T. 
Local _nTot1  := _nTot2 := _nTot3 := _nTot4 := _nTot5 := _nLin :=  _nRegs := 0   
Local _cQuery := " " 
Private _nPag :=  0
private oPrn   := TMSPrinter():New()     

_cQuery := "SELECT * "
_cQuery += "FROM  " + RetSQLName("SE5") + "  "
_cQuery += "WHERE	 D_E_L_E_T_ != '*'   AND "
_cQuery += 			"E5_FILIAL   = '"+ XFILIAL("SE5") +"'  AND "
_cQuery += 			"E5_CLIFOR   BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' AND "
_cQuery += 			"E5_NUMERO   BETWEEN '"+ MV_PAR10 +"' AND '"+ MV_PAR11 +"' AND "
_cQuery += 			"E5_NATUREZ  BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' AND "
_cQuery += 			"E5_DATA     BETWEEN '"+ DTOS(MV_PAR05) +"' AND '"+ DTOS(MV_PAR06) +"' AND "
_cQuery += 			"E5_LOTE     BETWEEN '"+ MV_PAR07 +"' AND '"+ MV_PAR08 +"' AND " 
_cQuery += 			"E5_BANCO    = '"+  MV_PAR09  +"'  AND  "  
//_cQuery += 			"E5_TIPODOC NOT IN ('DC', 'JR', 'MT','CM', 'D2', 'J2', 'M2', 'C2', 'V2', 'CX', 'CP', 'TL') AND "
_cQuery += 			"E5_RECPAG   = 'R'      AND "
_cQuery += 			"E5_SITUACA  != 'C'     AND "
_cQuery += 			"E5_VALOR    != 0       AND "
_cQuery += 			"E5_NUMCHEQ  NOT LIKE '%*' "
	
	If _nE5RECNO > 0
		_cQuery += " AND R_E_C_N_O_ = "+ ALLTRIM(STR(_nE5RECNO)) +" "
	EndIF
	
	If	Select("TMP") > 0
		DbSelectarea("TMP")
		DbCloseArea()
	EndIf
Aviso("Aviso", _cQuery, {"Ok"},,,,,.t.)
TcQuery _cQuery New alias "TMP"

//Gerando a Regua 
DbSelectArea("TMP")
DbGoTop()              
TMP->(dbEval({|| _nRegs++}))     

//Verificando o Contador
If Empty(_nRegs)
	Aviso("Aviso", "Sem registros para o Relatorio de Recibo de Recebimento !", {"Ok"})
	DBCloseArea()
	Return()
EndIf

//Inicializa o Processo de Impressao
oPrn:StartPage()
_nLin := 4000  
SetRegua(_nRegs)
    
DbSelectArea("TMP")
DbGoTop()      

While !Eof()

	IncRegua()  	
	    	
	_cQuery := " SELECT 
	_cQuery += " 	 COUNT(E5_SEQ) AS E5QTD
	_cQuery += " FROM 
	_cQuery += 	 RetSqlName("SE5")
	_cQuery += " WHERE
	_cQuery += "	 E5_FILIAL = '"+xFilial("SE5")+"' AND 
	_cQuery += "	 E5_NUMERO = '"+TMP->E5_NUMERO+"' AND 
	_cQuery += "    E5_SEQ    = '"+TMP->E5_SEQ   +"' AND 
	_cQuery += "	 D_E_L_E_T_ <> '*'
	
		If	Select("TMP2") > 0
			DbSelectarea("TMP2")
			DbCloseArea()
		EndIf
	
	TcQuery _cQuery New alias "TMP2"
	
		If TMP2->E5QTD == 1
			_lContinua := .T.
		Else
			_lContinua := .F.
		EndIf
		
		//Linhas de Impressao
		If	_nLin > 3000	
			//Imprimindo o Rodape
			If	_nTot1 > 0
				ImpRodape()
				//Pulando a Pแgina
			   oPrn:EndPage()    
				//Iniciando nova folha
				oPrn:StartPage()
			EndIf	
			//Imprime o Cabecalho
			_nLin := ImpCabec() 
			//_nLin :=  800           	
		EndIf     
		
	If _lContinua	             
		//Imprindo Linha a Linha
		oPrn:Say( _nLin, 0100, Subs(TMP->E5_DTDIGIT,7,2)+"/"+Subs(TMP->E5_DTDIGIT,5,2)+"/"+Subs(TMP->E5_DTDIGIT,3,2),oFont5,100)
		_Nome :=  AllTrim(TMP->E5_BANCO) + " - " + AllTrim(TMP->E5_CONTA) //POSICIONE("SA1",1, XFILIAL("SA1") + TMP->E5_CLIFOR,"A1_NOME")
		oPrn:Say( _nLin, 0250, SUBSTR(_Nome,1,25)                 ,oFont5,100  )   
		_nPos := aScan(_aMotBx, {|xx| Subs(xx,1,3) == TMP->E5_MOTBX })
			If _nPos <= 0 
				_Nome := ""
			Else
				_Nome := Subs(_aMotBx[_nPos],7,10)
			EndIf
		oPrn:Say( _nLin, 0750, _Nome,oFont5,100  )   
		oPrn:Say( _nLin, 0950, ALLTRIM(STRZERO(TMP->R_E_C_N_O_,6)),oFont5,100  )
		oPrn:Say( _nLin, 1100, SUBSTR(TMP->E5_DOCUMEN,1,6) ,oFont5,100  )
		
		//Val. Parcela
		_nValor := 0 
		_nValor := POSICIONE("SE1",1,XFILIAL("SE1")+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA,"E1_VALOR")
		oPrn:Say( _nLin, 1300, Transform(_nValor ,"@E 9,999,999.99")        ,oFont5,100  )  
		//Totalizando			
		_nTot1 := _nValor
		
		//Val.  Movto.		 	
		oPrn:Say( _nLin, 1500, Transform(TMP->E5_VALOR ,"@E 9,999,999.99")  ,oFont5,100  )
		//Totalizando			
		_nTot2 := _nTot2 + TMP->E5_VALOR
		
		//Val. Acresc.
		_nValor := 0 
		_nValor := TMP->E5_VLJUROS + TMP->E5_VLMULTA + TMP->E5_VLCORRE
		oPrn:Say( _nLin, 1700, Transform(_nValor ,"@E 9,999,999.99")        ,oFont5,100  )
		//Totalizando			
		_nTot3  := _nTot3 + _nValor
		
		//Val. Descon.
		oPrn:Say( _nLin, 1900, Transform(TMP->E5_VLDESCO ,"@E 9,999,999.99"),oFont5,100  )  
		//Totalizando			
		_nTot4  := _nTot4 + TMP->E5_VLDESCO
		
		//Val. Saldo
		_nValor := 0 
		_nValor := _nValor + _nTot1 - _nTot2//POSICIONE("SE1",1,XFILIAL("SE1")+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA,"E1_SALDO")
		oPrn:Say( _nLin, 2100, Transform(_nValor ,"@E 9,999,999.99") ,oFont5,100  )
		
		oPrn:Say( _nLin, 2270, TMP->E5_SEQ, oFont9, 100 )
		
		//Totalizando			
		_nTot5  := _nValor
		
		_nLin := _nLin + 050     
		
	EndIf
	
	//PULANDO O REGISTRO
	DbSelectArea("TMP")
	DbSkip()

EndDo

//Fechando a แrea da query
DbSelectarea("TMP")
DbCloseArea()

//Totalizando  
_nLin := _nLin + 020  
oPrn:Line(_nLin,0100,_nLin,2300)
_nLin := _nLin + 010  
oPrn:Say( _nLin, 0100, "TOTAL ==> "    ,oFont16,100  )
oPrn:Say( _nLin, 1300, Transform(_nTot1 ,"@E 9,999,999.99") ,oFont5,100  )
oPrn:Say( _nLin, 1500, Transform(_nTot2 ,"@E 9,999,999.99") ,oFont5,100  )
oPrn:Say( _nLin, 1700, Transform(_nTot3 ,"@E 9,999,999.99") ,oFont5,100  )
oPrn:Say( _nLin, 1900, Transform(_nTot4 ,"@E 9,999,999.99") ,oFont5,100  )
oPrn:Say( _nLin, 2100, Transform(_nTot5 ,"@E 9,999,999.99") ,oFont5,100  )

//Imprimindo o Rodape
ImpRodape()	
//Finaliza a Impressao da Pแgina             
oPrn:EndPage()

oPrn:Preview()
//Libera a Impressora
//MS_FLUSH()               
oPrn:End()
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRACAR002  บAutor  ณMicrosiga           บ Data ณ  06/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpCabec()

Local _nLin := 050
Local _cTexto := ""   
Local _cNomeCli := Posicione("SA1",1, xFilial("SA1") + SE1->E1_CLIENTE,"A1_NOME")

	oPrn:Line(_nLin,0100,_nLin,2300)
	_nLin += 010
	//Tem que estar no diretorio SYSTEM
	oPrn:SayBitmap(_nLin,0100,"lgrl"+AllTrim(SM0->M0_CODIGO)+".bmp",0300,0175)
	_nLin += 150
	oPrn:Say(_nLin, 0100, "SIGA/PFINR02/v.P10",oFont17,100)
	_nLin += 035
	oPrn:Say( _nLin, 100,"Emp/Filial.: " + AllTrim(SM0->M0_NOME) + " / " + AllTrim(SM0->M0_FILIAL),oFont3,100  )
	oPrn:Say( _nLin, 800,"RECIBO DE BAIXA - CONTAS A RECEBER (CR)",oFont12,100)
	_nLin += 050
	oPrn:Say( _nLin, 100,"Usuแrio.: " + Alltrim(Subs(cUsuario,7,15)) ,oFont3,100)
	_cData := Subs(DtoS(dDataBase),7,2) + "/" +Subs(DtoS(dDataBase),5,2) + "/" + Subs(DtoS(dDataBase),1,4)
	oPrn:Say( _nLin, 2000,"Data.: " + _cData ,oFont3,100  )
    //linha inicial / coluna / linha final / largura
   _nLin += 050
	oPrn:Line( _nLin,0100,_nLin,2300)
   _nLin += 200
    //linha inicial / coluna / linha final / largura
	//oPrn:Box( 430, 0100, 630, 2200) //Linha
	
	_cTexto := " Recebemos do Sr.(a) "+Alltrim(_cNomeCli)+" a importโncia de R$ "+AllTrim(Transform(SE5->E5_VALOR,"@E 999,999,999.99"))
	_cTexto += " ("+AllTrim(Extenso(SE5->E5_VALOR))+") na data de "+_cData+", referente a aquisi็ใo de Produtos e/ou servi็os da empresa "
	_cTexto += AllTrim(SM0->M0_NOME) + " no valor total de "+AllTrim(Transform(SE1->E1_VALOR,"@E 999,999,999.99"))+ " ("+AllTrim(Extenso(SE1->E1_VALOR))+")."
	_aTexto := JustTexto(Upper(_cTexto),070)
	
		For _nX = 1 to Len(_aTexto)        
			oPrn:Say(_nLin,0200,_aTexto[_nX],oFont,100)
			_nLin += 050
		Next _nX
		
 	//oPrn:Say( 0450, 0200, "N๚mero Baixa" ,oFont3,100  )
	//_Data := SUBSTR(TMP->E5_DTDIGIT,7,2) + "/" +SUBSTR(TMP->E5_DTDIGIT,5,2) + "/" + SUBSTR(TMP->E5_DTDIGIT,1,4)
 	//oPrn:Say( 0450, 0900, "Data Movto : "+ _Data ,oFont3,100  )
 	//oPrn:Say( 0450, 1500, "C/C Banco : "+  MV_PAR09 + "/" + ALLTRIM(TMP->E5_CONTA)  ,oFont3,100  )
	//oPrn:Say( 0550, 0200, "Documento ",oFont3,100  )
	//oPrn:Say( 0550, 1620, "Recebimentos Realizados... ",oFont3,100  )
   _nLin += 200
	oPrn:Say( _nLin, 0900, "RELAวรO DE RECEBIMENTOS REALIZADOS",oFontxx,100)   
	_nLin += 060
	oPrn:Line(_nLin,0100,_nLin,2300)
	_nLin += 010
 	oPrn:Say( _nLin, 0100, "Data Mov." ,oFont5,100  )
 	oPrn:Say( _nLin, 0250, "C/C - Banco " ,oFont5,100  )
 	oPrn:Say( _nLin, 0750, "Tipo Pgto " ,oFont5,100  )
 	oPrn:Say( _nLin, 0950, "Lancto " ,oFont5,100  )
 	oPrn:Say( _nLin, 1100, "Docto " ,oFont5,100  )
 	oPrn:Say( _nLin, 1300, "Val Parcela" ,oFont5,100  )
 	oPrn:Say( _nLin, 1500, "Val  Movto" ,oFont5,100  )
 	oPrn:Say( _nLin, 1700, "Val Acresc" ,oFont5,100  )
 	oPrn:Say( _nLin, 1900, "Val Descon" ,oFont5,100  )
 	oPrn:Say( _nLin, 2100, "Val Saldo" ,oFont5,100  )
    //linha inicial / coluna / linha final / largura
   _nLin += 050
	oPrn:Line(_nLin,0100,_nLin,2300)	
	_nLin += 050
	
	_nPag++  
 
Return(_nLin)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ImpRodapeณ Autor ณ MARCELO CAMPOS        ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Imprime o rodape do formulario e salta para a proxima folhaณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpRodape()

    //Imprimindo o Rodap้

    //linha inicial / coluna / linha final / largura
	oPrn:Line(3100,0100,3100,2300)		
	oPrn:Say(3200, 0100,"Recibo de Recebimento (CR) - " + AllTrim(SM0->M0_NOME),oFont5,100  )
	oPrn:Say(3200, 2020,"Pแgina: " + StrZero(_nPag,2),oFont5,100  )


Return ()                  


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  08/01/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg

	Local _aArea := GetArea()

	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	//          Grupo/Ordem/Pergunta            /Perg.          /Varavel/Tpo/Tm/Dc/Pre/GSC/Vld/Var01/Def01/Def1Esp/Def1Ing/Cnt01/Var02/Def02/Def2Esp/Def2Ing/Cnt02/Var03/Def03/Def3Esp/Def3Ing/Cnt03/Var04/Def04/Def4Esp/Def4Ing/Cnt04/Var05/Def05/Def5Esp/Def5Ing/Cnt05/F3/GRPSXG/
	aAdd(aRegs,{cPerg,"01","Cliente De"        ,"."  ,"."       ,"mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
	aAdd(aRegs,{cPerg,"02","Cliente Ate"       ,"."  ,"."       ,"mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
	aAdd(aRegs,{cPerg,"03","Natureza De"       ,"."  ,"."       ,"mv_ch3","C",10,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SED","","","",""})
	aAdd(aRegs,{cPerg,"04","Natureza Ate"      ,"."  ,"."       ,"mv_ch4","C",10,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED","","","",""})
	aAdd(aRegs,{cPerg,"05","Data Baixa de"     ,"."  ,"."       ,"mv_ch5","D",08,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Data Baixa Ate"    ,"."  ,"."       ,"mv_ch6","D",08,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Lote De      "     ,"."  ,"."       ,"mv_ch7","C",04,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","Lote Ate      "    ,"."  ,"."       ,"mv_ch8","C",04,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09","Banco da Baixa"    ,"."  ,"."       ,"mv_ch9","C",03,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	aAdd(aRegs,{cPerg,"10","Titulo De    "     ,"."  ,"."       ,"mv_cha","C",06,00,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11","Titulo Ate    "    ,"."  ,"."       ,"mv_chb","C",06,00,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12","Seq. da Baixa "    ,"."  ,"."       ,"mv_chc","C",02,00,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	RestArea(_aArea)
	
Return ()  

Static Function JustTexto(cTextJust,nTamCol)

cTextEdit := cTextJust
aTextResult:={}

nTotLinhas := MlCount(cTextEdit,nTamCol)

For t := 1 To nTotLinhas

	Aadd(aTextResult,MemoLine(cTextEdit,nTamCol,t))
	nCodAsc:=170
	aTextResult[t]:=ALLTRIM(aTextResult[t])
	aTextResult[t]:=STRTRAN(aTextResult[t]," ",CHR(nCodAsc))

		While .T.
		
			If Len(Alltrim(aTextResult[t])) == nTamCol .Or. t == nTotLinhas
				For r := 170 To nCodAsc
					aTextResult[t] := StrTran(aTextResult[t],CHR(r)," ")
				Next r
				Exit
			End
			
			nPosSpaco := At(CHR(nCodAsc),aTextResult[t])
			
				If nPosSpaco > 0
					aTextResult[t] := Subs(aTextResult[t],1,nPosSpaco-1)+Space(2)+;
					Subs(aTextResult[t],nPosSpaco+1,(nTamCol-(nPosSpaco-1)))
					aTextResult[t] := Alltrim(aTextResult[t])
					aTextResult[t] := StrTran(aTextResult[t],CHR(nCodAsc),CHR(nCodAsc+1))
				Else
					nPosSpaco := At(Space(2),aTextResult[t])
					aTextResult[t] := Subs(aTextResult[t],1,nPosSpaco-1)+Space(3)+;
					Subs(aTextResult[t],nPosSpaco+2,(nTamCol-(nPosSpaco-2)))
				End
				
			nCodAsc+=1
		End
Next

Return(aTextResult) 

Static Function fLisMot()

Local _aRet := {}
Local _cAux := ""
Local _cArq := "SIGAADV.MOT"
Local _cLin := ""   
		
	FT_FUse(_cArq)
	FT_FGotop()	
	
		While ( !FT_FEof() )
			_cLin := FT_FREADLN()
				If ( Subs(_cLin,14,1) != "P" )
					Aadd(_aRet, Subs(_cLin,1,3)+" - "+Subs(_cLin,4,10))
				EndIf
			FT_FSkip()
		EndDo
    
    FT_FUse()
	
Return(_aRet)