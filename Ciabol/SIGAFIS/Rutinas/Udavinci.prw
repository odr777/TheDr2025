#Include "Protheus.Ch"
/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DaVinci   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Preparacao do meio-magnetico para o software DaVinci-LCV,   ³±±
±±³          ³geracao dos Livros de Compra e Vendas IVA.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UDaVinci(cLivro,cFilIni,cFilFim)

Local aArea	:= GetArea()
Local aTpNf		:= &(GetNewPar("MV_DAVINC1","{}"))

Local cCpoPza	:= GetNewPar("MV_DAVINC2","")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
Local cCpoDta   := GetNewPar("MV_DAVINC3","")		//Campo da tabela SF1: que contem a Data de Poliza de Importacion
Local lOrdem	:= GetNewPar("MV_DAVINC4",.T.)     //Indica se arquivo sera ordenado por Emissao ou Entrada sendo F=Emissao e T=Entrada

Local lProc	:= .T.
Default cFilIni	:=xFilial("SF3")
Default cFilFim	:=xFilial("SF3")


GeraTemp(cLivro)

If cPaisLoc == "BOL" .And. LocBol()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a existencia dos parametros/campos                    ³
	//³Caso esses itens nao existam, nao sera efetuado o processamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aTpNf) == 0 
		lProc := .F.
		Help(" ",1,"MV_DAVINC1")
	Endif
	If Empty(cCpoPza) .Or. SF1->(FieldPos(cCpoPza)) == 0 
		lProc := .F.
		Help(" ",1,"MV_DAVINC2")
	Endif
	If Empty(cCpoDta) .Or. SF1->(FieldPos(cCpoDta)) == 0
		lProc := .F.
		Help(" ",1,"MV_DAVINC3")
	Endif
	
	If lProc
		ProcLivro(cLivro,cFilIni,cFilFim)
	Endif
Endif

RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GeraTemp   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Gera arquivos temporarios                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTemp(cLivro)

Local aStru	:= {}
Local cArq	:= ""
Local nTam := 10
Default cLivro:= "V"

If SF3->(FieldPos("F3_NIT")) > 0
	nTam :=TamSx3("F3_NIT")[1]
Else
	If cLivro == "C"
	   nTam :=TamSx3("A2_CGC")[1]
	Else
	   nTam :=TamSx3("A1_CGC")[1]
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Temporario LCV - Livro de Compras e Vendas IVA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aStru,{"TIPONF"	,"C",001,0})
AADD(aStru,{"NUMSEQ"	,"C",006,0})
AADD(aStru,{"NIT"		,"C",nTam,0})
AADD(aStru,{"RAZSOC"	,"C",255,0})
AADD(aStru,{"NFISCAL"	,"C",012,0})
AADD(aStru,{"POLIZA"	,"C",020,0}) 
AADD(aStru,{"NUMAUT"	,"C",015,0})
AADD(aStru,{"EMISSAO"	,"D",008,0}) 
AADD(aStru,{"VALCONT"	,"N",014,2})
AADD(aStru,{"ICE"		,"N",014,2})
AADD(aStru,{"EXENTAS"	,"N",014,2})
AADD(aStru,{"SUBTOT"	,"N",014,2})
AADD(aStru,{"EXPORT"	,"N",014,2})
AADD(aStru,{"TAXAZERO"	,"N",014,2})
AADD(aStru,{"DESCONT"	,"N",014,2})
AADD(aStru,{"BASEIMP"	,"N",014,2})
AADD(aStru,{"VALIMP"	,"N",014,2})
AADD(aStru,{"STATUSNF"	,"C",001,0})
AADD(aStru,{"CODCTR"	,"C",014,0})
AADD(aStru,{"DATAORD"	,"C",008,0})

cArq := CriaTrab(aStru)
dbUseArea(.T.,__LocalDriver,cArq,"LCV")

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ProcLivro  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa o Livro de Compras e Vendas IVA                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcLivro(cLivro,cFilIni,cFilFim)

Local aImp		:= {}
Local aAlias	:= {"SF3",""}
Local cTop		:= ""
Local cDbf		:= ""
Local cNIT		:= ""
Local cRazSoc	:= ""
Local cArray	:= GetNewPar("MV_DAVINC1","{}")		//Tipo de Factura: 1-Compras para Mercado Interno;2-Compras para Exportacoes;3-Compras tanto para o Mercado Intero como para Exportacoes
Local aTpNf		:= &cArray
Local cTpNf		:= "1"								//1-Compras para Mercado Interno;2-Compras para Exportacoes;3-Compras tanto para o Mercado Intero como para Exportacoes
Local nPos		:= 0
Local nPosIVA	:= 0
Local nPosICE	:= 0
Local cCpoPza	:= GetNewPar("MV_DAVINC2","")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
Local cCpoDta   := GetNewPar("MV_DAVINC3","")		//Campo da tabela SF1: que contem a Data de Poliza de Importacion
Local lOrdem	:= GetNewPar("MV_DAVINC4",.T.)     //Indica se arquivo sera ordenado por Emissao ou Entrada sendo F=Emissao e T=Entrada
Local lPza		:= SF1->(FieldPos(cCpoPza)) > 0 .And. SF1->(FieldPos(cCpoDta)) > 0
Local cChave	:= ""
Local cArqInd	:= ""

Local lNUMDES   := .F. 
Local lPassag 	:= .F. 
Local lImport   := .F. 

lPassag := cPaisLoc == "BOL" .And. GetNewPar("MV_PASSBOL",.F.) .And.;
						SF3->(FieldPos("F3_COMPANH")) > 0 .And. ;
						SF3->(FieldPos("F3_LOJCOMP")) > 0 .And. ;
						SF3->(FieldPos("F3_PASSAGE")) > 0 .And. ;
						SF3->(FieldPos("F3_DTPASSA")) > 0 .And. ;
						SF1->(FieldPos("F1_COMPANH")) > 0 .And. ;
						SF1->(FieldPos("F1_LOJCOMP")) > 0 .And. ;
						SF1->(FieldPos("F1_PASSAGE")) > 0 .And. ;
						SF1->(FieldPos("F1_DTPASSA")) > 0   

If SF1->(FieldPos("F1_NUMDES")) == 0
	lNUMDES = .F.
Else 
	lNUMDES = .T.
Endif    


Default cFilIni	:=xFilial("SF3")
Default cFilFim	:=xFilial("SF3")




If cLivro == "C"	//Compras
	cTop := "F3_FILIAL >= '" + cFilIni + "' AND F3_FILIAL <= '" + cFilFim + "' AND SUBSTRING(F3_CFO,1,1) < '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "'"
	cDbf := "F3_FILIAL >= '" + cFilIni + "' .AND. F3_FILIAL <= '" + cFilFim + "' .AND.  SUBSTRING(F3_CFO,1,1) < '5' .AND. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "'"
	If SF3->(FieldPos("F3_RECIBO")) > 0
		cTop += " AND F3_RECIBO <> '1'"
		cDbf += " .AND. F3_RECIBO <> '1'"
	EndIf
	SF1->(dbSetOrder(1))
	If !lOrdem
		cArqInd := CriaTrab(Nil,.F.)
		LCV->(DbCreateIndex(cArqInd + OrdBagExt(),"DATAORD",{|| DATAORD}))
	Endif
Else				//Vendas
	cTop := "F3_FILIAL >= '" + cFilIni + "' AND F3_FILIAL <= '" + cFilFim + "' AND SUBSTRING(F3_CFO,1,1) >= '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "'"
	cDbf := "F3_FILIAL >= '" + cFilIni + "' .AND. F3_FILIAL <= '" + cFilFim + "' .AND.   SUBSTRING(F3_CFO,1,1) >= '5' .AND. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "'"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aImp com as informacoes dos impostos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SFB")
dbSetOrder(1)
dbGoTop()

AADD(aImp,{"IVA",""})                
AADD(aImp,{"ICE",""})                
While !SFB->(Eof()) 
	nPos := aScan(aImp,{|x| SFB->FB_CODIGO $ x[1]})
	If nPos > 0
		aImp[nPos,2] := SFB->FB_CPOLVRO
	Endif	
	dbSkip()
Enddo                 
aSort(aImp,,,{|x,y| x[2] < y[2]})

nPosIVA := Ascan(aImp,{|imp| imp[1] == "IVA"})
nPosICE := Ascan(aImp,{|imp| imp[1] == "ICE"})

AAdd(aImp[nPosIVA],SF3->(FieldPos("F3_BASIMP"+aImp[nPosIVA][2])))		//Base de Calculo
AAdd(aImp[nPosIVA],SF3->(FieldPos("F3_VALIMP"+aImp[nPosIVA][2])))		//Valor do Imposto

AAdd(aImp[nPosICE],SF3->(FieldPos("F3_BASIMP"+aImp[nPosICE][2])))		//Base de Calculo
AAdd(aImp[nPosICE],SF3->(FieldPos("F3_VALIMP"+aImp[nPosICE][2])))		//Valor do Imposto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria Query / Filtro                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF3->(dbSetOrder(1))
FsQuery(aAlias,1,cTop,cDbf,SF3->(IndexKey()))                                               

_nCont:=0

dbSelectArea("SF3")
While !Eof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Como podem existir mais de um SF3 para um mesmo documento, deve ser aglutinado³
	//³gerando apenas uma linha no arquivo magnetico.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cChave) .Or. cChave <> SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA 
	
		If cLivro == "C"	//Compras
			If !Empty(cFilIni) .and. !Empty(xFilial("SF1"))
				SF1->(dbSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
			Else
				SF1->(dbSeek(xFilial("SF1")+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
			EndIf	
	        cRazSoc  := SF1->F1_UNOMBRE
	        cNIT	 := SF1->F1_UNIT

		    If  EMPTY(cRazSoc).or. EMPTY(cNIT)
			
				If SF3->F3_TIPO == "B" .OR. SF3->F3_TIPOMOV = "V"             
					cRazSoc := Posicione("SA1",1,xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A1_NOME")
					cNIT	:= Posicione("SA1",1,xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A1_CGC") 
					If Empty(cNIT)
						cNIT := Posicione("SA1",1,xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A1_RG") 
					Endif
				Else 
				 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se as informacoes da companhia area estao preenchidas.³
					//³Se sim, os dados no livro devem ser da companhia aerea.        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lPassag .And. !Empty(SF3->F3_COMPANH) .And. !Empty(SF3->F3_LOJCOMP) 
						cRazSoc := Posicione("SA2",1,xFilial("SA2")+SF3->F3_COMPANH+SF3->F3_LOJCOMP,"A2_NOME")
						cNIT	:= Posicione("SA2",1,xFilial("SA2")+SF3->F3_COMPANH+SF3->F3_LOJCOMP,"A2_CGC")
					Else
						// caso tenha uma politica de importacao ela deve ser impressa no lugar da NF
			 			If lNUMDES .And. !Empty(nNUMDES := Posicione("SF1",1,xFilial("SF1")+SF3->F3_NFISCAL,"F1_NUMDES"))
		 					lImport := .T.
		  					cRazSoc := Posicione("SA2",1,xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A2_NOME")
							cNIT	:= Posicione("SA2",1,xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A2_CGC")
						Else 
							cRazSoc := Posicione("SA2",1,xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A2_NOME")
							cNIT	:= Posicione("SA2",1,xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A2_CGC")
						Endif
					Endif
				EndIf

			Endif
	    EndIf
	
		//Ú Tipo de Factura ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³1-Compras para Mercado Interno                              ³
		//³2-Compras para Exportacoes                                  ³
		//³3-Compras tanto para o Mercado Intero como para Exportacoes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nPos := aScan(aTpNf,{|x| Alltrim(SF3->F3_SERIE) $ x[1]})) > 0
			cTpNf := aTpNf[nPos][2]
		Else
			cTpNf := "1"
		Endif

		_nCont+=1

		RecLock("LCV",.T.)

		LCV->NUMSEQ		:= Str(_nCont,6)
		LCV->TIPONF		:= cTpNf
		LCV->NIT		:= cNIT
		LCV->RAZSOC		:= cRazSoc
		LCV->NFISCAL	:= SF3->F3_NFISCAL
		LCV->POLIZA		:= "0"
		LCV->EMISSAO	:= SF3->F3_EMISSAO
		If	cLivro == "C"
			If !lOrdem	
				LCV->DATAORD := Dtos(SF3->F3_EMISSAO)
			EndIf
		EndIf
		LCV->NUMAUT		:= SF3->F3_NUMAUT

		If cLivro == "C" .And. lPza
			If !Empty(SF1->&(cCpoPza)) .and. AllTrim(SF1->&(cCpoPza)) != "0"		//Numero da Poliza de Importacion
				LCV->POLIZA		:= SF1->&(cCpoPza)
				LCV->NFISCAL    := "0" 
			   _nDescFact := 0
			Else
				_nDescFact := SF1->F1_DESCONT   //WCS 26-01-2016  Para permitir imprimir total del descuento
			Endif
			If !Empty(SF1->&(cCpoDta))		//Data da Poliza de Importacion
				LCV->EMISSAO	:= SF1->&(cCpoDta)
			Endif
		Endif
		
		LCV->STATUSNF	:= IIf(!Empty(SF3->F3_DTCANC),IIf(SF3->(FieldPos("F3_STATUS")) > 0,IIf(SF3->F3_STATUS$"EN",SF3->F3_STATUS,"A"),"A"),"V")	//NF Valida / Anulada / Extraviada ou Não utilizada
		LCV->CODCTR		:= SF3->F3_CODCTR
	Else
		RecLock("LCV",.F.)
	Endif

	If Empty(SF1->&(cCpoPza)) .OR. AllTrim(SF1->&(cCpoPza)) == "0"		//Numero da Poliza de Importacion
		LCV->VALCONT	+= SF3->F3_VALCONT - SF3->F3_VALIMP5 + SF1->F1_DESCONT
		LCV->EXENTAS	+= SF3->F3_EXENTAS       
    Else
		If aImp[nPosIVA][3] > 0  
			If	SF3->F3_VALIMP5 == 0
				LCV->VALCONT	+= SF3->(FieldGet(aImp[nPosIVA][3]))		//Base de Calculo
			ElseIf SF3->F3_VALIMP5  >  0	
    	        LCV->VALCONT	+= SF3->F3_VALCONT-SF3->F3_VALIMP5
        	Else
	           LCV->VALCONT	+= 0 
			End	
		Endif
		LCV->EXENTAS	+= 0     
    End

	LCV->SUBTOT	    := LCV->VALCONT - LCV->EXENTAS
	LCV->DESCONT    += _nDescFact
	If aImp[nPosIVA][3] > 0  
		If	SF3->F3_VALIMP5 == 0
			LCV->BASEIMP	+= SF3->(FieldGet(aImp[nPosIVA][3]))		//Base de Calculo
		ElseIf SF3->F3_VALIMP5  >  0	
            LCV->BASEIMP	+= SF3->F3_VALCONT-SF3->F3_VALIMP5
        Else
           LCV->BASEIMP	+= 0 
		End	
	Endif

	If aImp[nPosIVA][4] > 0
		LCV->VALIMP		+= SF3->(FieldGet(aImp[nPosIVA][4]))		//Valor do Imposto
	Endif

	MsUnlock()
    
	cChave := SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA
	
	dbSelectArea("SF3")
	dbSkip()
Enddo

FsQuery(aAlias,2)

Return Nil
