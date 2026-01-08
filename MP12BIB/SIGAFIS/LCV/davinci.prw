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
User Function DaVinci(cLivro,cFilIni,cFilFim) //DaVinci

Local aArea	:= GetArea()
Local aTpNf		:= &(GetNewPar("MV_DAVINC1","{}"))

Local cCpoPza	:= GetNewPar("MV_DAVINC2","")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
Local cCpoDta   := GetNewPar("MV_DAVINC3","")		//Campo da tabela SF1: que contem a Data de Poliza de Importacion
Local lOrdem	:= GetNewPar("MV_DAVINC4",.T.)     //Indica se arquivo sera ordenado por Emissao ou Entrada sendo F=Emissao e T=Entrada
Local lPeriodoOK := (FunName()<>"MATA950")
Local lProc	:= .T.

Default cFilIni	:=xFilial("SF3")
Default cFilFim	:=xFilial("SF3")

GeraTemp(cLivro)

If lPeriodoOK
//If lPeriodoOK .or. BOL3Per()

    If cPaisLoc == "BOL" .And. LocBol() 
    
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³Verifica a existencia dos parametros/campos                    ³
    	//³Caso esses itens nao existam, nao sera efetuado o processamento³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    	If Len(aTpNf) == 0 
    		lProc := .F.
    		Help(" ",1,"MV_DAVINC1")
    	Endif
    	If Empty(cCpoPza) 
    		lProc := .F.   
    		Help(" ",1,"MV_DAVINC2")
    	Endif
    	If Empty(cCpoDta)
    		lProc := .F.
    		Help(" ",1,"MV_DAVINC3")
    	Endif
    	
    	If lProc
    		ProcLivro(cLivro,cFilIni,cFilFim)
    	Endif
    Endif

EndIf

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
Default cLivro:= "V"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Temporario LCV - Livro de Compras e Vendas IVA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aStru,{"NUMSEQ"	 ,"C",006,0})
AADD(aStru,{"TIPONF"	 ,"C",001,0})
AADD(aStru,{"NIT"		 ,"C",013,0})
AADD(aStru,{"RAZSOC"	 ,"C",150,0})
AADD(aStru,{"NFISCAL" ,"C",018,0})
AADD(aStru,{"POLIZA"	 ,"C",016,0}) 
AADD(aStru,{"NUMAUT"	 ,"C",015,0})
AADD(aStru,{"EMISSAO" ,"D",008,0}) 
AADD(aStru,{"VALCONT" ,"N",010,2})
AADD(aStru,{"EXPORT"  ,"N",014,2})
AADD(aStru,{"EXENTAS" ,"N",010,2})
AADD(aStru,{"TAXAZERO","N",010,2})
AADD(aStru,{"SUBTOT"  ,"N",010,2})
AADD(aStru,{"DESCONT" ,"N",010,2})
AADD(aStru,{"BASEIMP" ,"N",010,2})
AADD(aStru,{"VALIMP"	 ,"N",010,2})
AADD(aStru,{"STATUSNF","C",001,0})
AADD(aStru,{"CODCTR"  ,"C",017,0})
AADD(aStru,{"DATAORD" ,"C",008,0})
AADD(aStru,{"DTNFORI" ,"D",008,0}) 
AADD(aStru,{"NFORI"   ,"C",018,0})
AADD(aStru,{"AUTNFORI","C",015,0})
AADD(aStru,{"VALNFORI","N",010,2})

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
Local cCpoPza	:= GetNewPar("MV_DAVINC2","")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
Local cCpoDta   := GetNewPar("MV_DAVINC3","")		//Campo da tabela SF1: que contem a Data de Poliza de Importacion
Local lOrdem	:= GetNewPar("MV_DAVINC4",.T.)     //Indica se arquivo sera ordenado por Emissao ou Entrada sendo F=Emissao e T=Entrada
Local cChave	  := ""
Local cArqInd	  := ""
Local nNumSeq  := 0
Local nDescont := 0
Local lCalcLiq := .f.
Local dDtNFOri  := CTOD("")
Local cNFOri    := ""
Local cAutNFOri := ""
Local nValNFOri := 0
Local lProcLiv  := .t.
Local aCposIsen := {}
Local nInd      := 0

Default cFilIni	:=xFilial("SF3")
Default cFilFim	:=xFilial("SF3")

If cLivro == "C"	//Compras

	cTop := "F3_FILIAL >= '" + cFilIni + "' AND F3_FILIAL <= '" + cFilFim + "' AND SUBSTRING(F3_CFO,1,1) < '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "' AND F3_ESPECIE = 'NF'"
	cDbf := "F3_FILIAL >= '" + cFilIni + "' .AND. F3_FILIAL <= '" + cFilFim + "' .AND.  SUBSTRING(F3_CFO,1,1) < '5' .AND. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "' .AND. ALLTRIM(F3_ESPECIE) == 'NF'"

	cTop += " AND F3_RECIBO <> '1'"
	cDbf += " .AND. F3_RECIBO <> '1'"
	
	SF1->(dbSetOrder(1))
	If !lOrdem
		cArqInd := CriaTrab(Nil,.F.)
		LCV->(DbCreateIndex(cArqInd + OrdBagExt(),"DATAORD",{|| DATAORD}))
	Endif
	
ElseIf cLivro == "V"	//Vendas
			
	cTop := "F3_FILIAL >= '" + cFilIni + "' AND F3_FILIAL <= '" + cFilFim + "' AND SUBSTRING(F3_CFO,1,1) >= '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02)+ "' AND F3_ESPECIE = 'NF'"
	cDbf := "F3_FILIAL >= '" + cFilIni + "' .AND. F3_FILIAL <= '" + cFilFim + "' .AND.   SUBSTRING(F3_CFO,1,1) >= '5' .AND. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "' .AND. ALLTRIM(F3_ESPECIE) == 'NF'"

Else // Notas de Credito/Debito Compras

    cTop := "F3_FILIAL >= '" + cFilIni + "' AND F3_FILIAL <= '" + cFilFim + "' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "' AND "
    cTop += "F3_ESPECIE <> 'NF' AND " 

    If cLivro=="CDC"
        cTop += "F3_TIPOMOV = 'V' 
    Else
        cTop += "F3_TIPOMOV = 'C' 
    EndIf
                         
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aImp com as informacoes dos impostos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SFB")
dbSetOrder(1)
dbGoTop()

AADD(aImp,{"IVA",""})
While !SFB->(Eof())
    nPos := aScan(aImp,{|x| SFB->FB_CODIGO $ x[1]})
    If nPos > 0
        aImp[nPos,2] := SFB->FB_CPOLVRO
    Else        

        If cLivro$"C|V"

            If Empty(aScan(aCposIsen,{|x| SFB->FB_CPOLVRO $ x[1]})) .and. (SFB->FB_CPOLVRO # aImp[1,2])
                AAdd(aCposIsen,{SFB->FB_CPOLVRO,SF3->(FieldPos("F3_VALIMP"+SFB->FB_CPOLVRO))}) 
            EndIf               
               
        EndIf
        
    Endif
    dbSkip()
Enddo
aSort(aImp,,,{|x,y| x[2] < y[2]})

nPosIVA := Ascan(aImp,{|imp| imp[1] == "IVA"})

AAdd(aImp[nPosIVA],SF3->(FieldPos("F3_BASIMP"+aImp[nPosIVA][2])))		//Base de Calculo
AAdd(aImp[nPosIVA],SF3->(FieldPos("F3_VALIMP"+aImp[nPosIVA][2])))		//Valor do Imposto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria Query / Filtro                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF3->(dbSetOrder(1))
FsQuery(aAlias,1,cTop,cDbf,SF3->(IndexKey()))

dbSelectArea("SF3")
While !Eof()

    If (cLivro$"V|C")   // Livro de Venda e ou Compra 
        lProcLiv := .t.
    ElseIf !Empty(SF3->F3_DTCANC)  // Livro de Vendas/Compras Deb/Cred Canceladas
        lProcLiv := Iif(cLivro=="VDC",.f.,.t.)
    Else    
            
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Pesquisa documento de origem somente para os livros de "Vendas Deb/Cre" e "Compras Deb/Cred" ³
        //³e que nao estiverem cancelados.                                                              ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If ( cChave <> SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA ) .and. Empty(SF3->F3_DTCANC)   // Compras Debito/Credito
            lProcLiv := PesqDocOri(@dDtNFOri,@cNFOri,@cAutNFOri,@nValNFOri,cFilIni,cLivro=="CDC")
        EndIf

    EndIf

    If lProcLiv
        
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³Como podem existir mais de um SF3 para um mesmo documento, deve ser aglutinado³
    	//³gerando apenas uma linha no arquivo magnetico.                                ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If Empty(cChave) .Or. cChave <> SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA
    	
            lCalcLiq := ( Posicione("SFC",2,xFilial("SFC")+SF3->F3_TES+"IVA","FC_LIQUIDO") == "S" ) 

            If SF3->F3_TIPOMOV == "C"	//Compras(C) 
                If !Empty(cFilIni) .and. !Empty(xFilial("SF1"))
                    SF1->(dbSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
                Else
                    SF1->(dbSeek(xFilial("SF1")+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
                EndIf
            ElseIf SF3->F3_TIPOMOV == "V"   //Vendas 
                If !Empty(cFilIni) .and. !Empty(xFilial("SF2"))
                    SF2->(dbSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
                Else
                    SF2->(dbSeek(xFilial("SF2")+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
                EndIf
            
            Endif
    		
            If !Empty(SF3->F3_NIT)
                cNIT := SF3->F3_NIT
            Else
                If SF3->F3_TIPOMOV == "C"  //Compras(C) 
                    cNIT	:= Posicione("SA2",1,xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA),"A2_CGC")
                Else
                    cNIT	:= Posicione("SA1",1,xFilial("SA1")+SF3->(F3_CLIEFOR+F3_LOJA),"A1_CGC")
                Endif
            EndIf
    		
            If !Empty(SF3->F3_RAZSOC)
                cRazSoc	:= SF3->F3_RAZSOC
            Else
                If SF3->F3_TIPOMOV == "C"  //Compras(C) 
                    cRazSoc	:= Posicione("SA2",1,xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA),"A2_NOME")
                Else
                    cRazSoc	:= Posicione("SA1",1,xFilial("SA1")+SF3->(F3_CLIEFOR+F3_LOJA),"A1_NOME")
                Endif
            EndIf
    	
    		//Ú Tipo de Factura ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    		//³1-Compras para Mercado Interno com destino a atividades gravadas     ³
    		//³2-Compras para Mercado Interno com destino a atividades nao gravadas ³
    		//³3-Compras sujeitas a proporcionalidade                               ³
    		//³4-Compras para Exportacoes                                           ³
    		//³3-Compras tanto para o Mercado Interno como para Exportacoes         ³
    		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If (nPos := aScan(aTpNf,{|x| Alltrim(SF3->F3_SERIE) $ x[1]})) > 0
                cTpNf := aTpNf[nPos][2]
            Else
                cTpNf := "1"
            Endif
    
            RecLock("LCV",.T.)
    
            LCV->TIPONF	:= cTpNf
            LCV->NUMSEQ  := StrZero(++nNumSeq,6)
            LCV->NIT		:= cNIT
            LCV->RAZSOC	:= cRazSoc
            LCV->NFISCAL	:= SF3->F3_NFISCAL
            LCV->EMISSAO	:= SF3->F3_EMISSAO

            If	cLivro == "C"

                nDescont := xMoeda(SF1->F1_DESCONT,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA )
                
                If !lOrdem
                    LCV->DATAORD := Dtos(SF3->F3_EMISSAO)
                EndIf
    			
                If !Empty(SF1->&(cCpoPza))		//Numero da Poliza de Importacion
                    LCV->POLIZA		:= SF1->&(cCpoPza)
                    LCV->NFISCAL    := "0"
                Endif
                If !Empty(SF1->&(cCpoDta))		//Data da Poliza de Importacion
                    LCV->EMISSAO	:= SF1->&(cCpoDta)
                Endif
    		
            ElseIf cLivro == "V"
                nDescont := 0
            EndIf

            LCV->NUMAUT   := SF3->F3_NUMAUT
            LCV->STATUSNF	:= IIf(!Empty(SF3->F3_DTCANC),IIf(SF3->F3_STATUS$"EN",SF3->F3_STATUS,"A"),"V")	//NF Valida / Anulada / Extraviada ou Não utilizada
            LCV->CODCTR	:= SF3->F3_CODCTR
            
            If LCV->STATUSNF=="V"
                        
                LCV->DTNFORI  := dDtNFOri
                LCV->NFORI    := cNFOri
                LCV->AUTNFORI := cAutNFOri
                LCV->VALNFORI := nValNFOri
                 
            EndIf
                    		
        Else
            RecLock("LCV",.F.)
        Endif

        LCV->VALCONT += SF3->F3_VALCONT
        
        If SF3->(FieldGet(aImp[nPosIVA][4])) > 0        
            LCV->BASEIMP += SF3->(FieldGet(aImp[nPosIVA][3]))		//Base de Calculo
            LCV->VALIMP  += SF3->(FieldGet(aImp[nPosIVA][4]))		//Valor do Imposto
        ElseIf cLivro=="V"
            LCV->TAXAZERO += SF3->(FieldGet(aImp[nPosIVA][3]))   //IVA com taxa zero
        EndIf            

        If cLivro$"C|V"
        
            For nInd:=1 To Len(aCposIsen)
                LCV->EXENTAS += Iif(aCposIsen[nInd][2]>0,SF3->(FieldGet(aCposIsen[nInd][2])),0)
            Next            

            If cLivro=="V" .AND. Empty(SF3->(FieldGet(aImp[nPosIVA][3])))
                LCV->EXPORT += SF3->F3_EXENTAS
            EndIf
            
            If cLivro=="C" .AND. (SF3->F3_EXENTAS > 0)
                LCV->EXENTAS += SF3->F3_EXENTAS
            EndIf
                                
        EndIf
        
        cChave := SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA
    
    EndIf
    
    dbSelectArea("SF3")
    dbSkip()
	
    If lProcLiv
     
        If cLivro$"C|V" .and. cChave <> SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA 
        
            LCV->DESCONT := Iif(lCalcLiq,nDescont,0)
            
            If cLivro=="C"
                LCV->SUBTOT := Iif(!Empty(LCV->BASEIMP),(LCV->VALCONT-LCV->EXENTAS),(LCV->BASEIMP+LCV->DESCONT))
            Else
                LCV->SUBTOT := LCV->VALCONT-LCV->EXENTAS-LCV->EXPORT-LCV->TAXAZERO-LCV->VALIMP
            EndIf                        

        EndIf
        
        LCV->(MsUnlock())

    EndIf
    
Enddo

FsQuery(aAlias,2)

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³PesqDocOri   ³ Autor ³ Marco Aurelio - Mano    ³ Data ³15/12/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Pesquisa a esxistencia de documento original para Notas de       ³±±
±±³          ³Debito/Credito                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PesqDocOri(ExpD1,ExpC1,ExpC2,ExpC3)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpD1 = Data de emissao do documento original                    ³±±
±±³          ³ExpC1 = Numero do documento original                             ³±±
±±³          ³ExpC2 = Numero de autorizacao do documento original              ³±±
±±³          ³ExpC3 = Valor da do documento original                           ³±±
±±³          ³ExpC4 = Codigo da filial inical selecionada nos parametros       ³±±
±±³          ³ExpL4 = Determina a tabela a ser considerada de acordo com       ³±±
±±³          ³        o Livro a ser impresso ou gerado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Livros - Bolivia                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/          
Static Function PesqDocOri(dDtNFOri,cNFOri,cAutNFOri,nValNFOri,cFilIni,lTabSF2)
Local cQuery   := ""    // Auxiliar para execucao de query para insercao de registros
Local lRet     := .f.   // Conteudo de retorno
Local cArqTmp  := GetNextAlias()
Local cFilSD1  := ""
Local cFilSF2  := ""

cFilSF1 := If(!Empty(cFilIni) .and. !Empty(xFilial("SF1")),SF3->F3_FILIAL,xFilial("SF2"))
cFilSF2 := If(!Empty(cFilIni) .and. !Empty(xFilial("SF2")),SF3->F3_FILIAL,xFilial("SF2"))
cFilSD1 := If(!Empty(cFilIni) .and. !Empty(xFilial("SD1")),SF3->F3_FILIAL,xFilial("SD1"))
cFilSD2 := If(!Empty(cFilIni) .and. !Empty(xFilial("SD2")),SF3->F3_FILIAL,xFilial("SD1"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Colunas a serem exibidas como resultado da query ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTabSF2
    cQuery := "SELECT F2_DOC, F2_EMISSAO, F2_NUMAUT, F2_VALFAT, F2_MOEDA, F2_TXMOEDA  FROM "
Else
    cQuery := "SELECT F1_DOC, F1_EMISSAO, F1_NUMAUT, F1_VALBRUT, F1_MOEDA, F1_TXMOEDA  FROM "
EndIf    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tabela do filtro ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(SF3->F3_ESPECIE) $ "NCC|NDE|NDP|NCI" 
    cQuery += RetSqlName("SD1")+" SD1 " // Tabela de Itens de Compra
    
    If lTabSF2
        cQuery += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON D1_FILIAL = '"+cFilSF2+"' AND F2_CLIENTE = D1_FORNECE AND F2_LOJA = D1_LOJA AND F2_DOC = D1_NFORI AND F2_SERIE = D1_SERIORI AND SF2.D_E_L_E_T_ <> '*'"
    Else
        cQuery += "INNER JOIN "+RetSqlName("SF1")+" SF1 ON D1_FILIAL = '"+cFilSF1+"' AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND F1_DOC = D1_NFORI AND F1_SERIE = D1_SERIORI AND SF1.D_E_L_E_T_ <> '*'"
    EndIf
        
Else
    cQuery += RetSqlName("SD2")+" SD2 " // Tabela de Itens de Saida

    If lTabSF2
        cQuery += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON D2_FILIAL = '"+cFilSF2+"' AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_DOC = D2_NFORI AND F2_SERIE = D2_SERIORI AND SF2.D_E_L_E_T_ <> '*'"
    Else
        cQuery += "INNER JOIN "+RetSqlName("SF1")+" SF1 ON D2_FILIAL = '"+cFilSF1+"' AND F1_FORNECE = D2_CLIENTE AND F1_LOJA = D2_LOJA AND F1_DOC = D2_NFORI AND F1_SERIE = D2_SERIORI AND SF1.D_E_L_E_T_ <> '*'"
    EndIf

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Condicoes para filtro ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(SF3->F3_ESPECIE) $ "NCC|NDE|NDP|NCI" 
    cQuery += "WHERE "
    cQuery += "D1_FILIAL  = '"+cFilSD1+"' AND "
    cQuery += "D1_FORNECE = '"+SF3->F3_CLIEFOR+"' AND "
    cQuery += "D1_LOJA  = '"+SF3->F3_LOJA+"' AND "
    cQuery += "D1_DOC  = '"+SF3->F3_NFISCAL+"' AND "
    cQuery += "D1_SERIE  = '"+SF3->F3_SERIE+"' AND "
    cQuery += "D1_NFORI <> ' '  AND "
    cQuery += "SD1.D_E_L_E_T_ = ' ' "
Else
    cQuery += "WHERE "
    cQuery += "D2_FILIAL  = '"+cFilSD2+"' AND "
    cQuery += "D2_CLIENTE = '"+SF3->F3_CLIEFOR+"' AND "
    cQuery += "D2_LOJA  = '"+SF3->F3_LOJA+"' AND "
    cQuery += "D2_DOC  = '"+SF3->F3_NFISCAL+"' AND "
    cQuery += "D2_SERIE  = '"+SF3->F3_SERIE+"' AND "
    cQuery += "D2_NFORI <> ' '  AND "
    cQuery += "SD2.D_E_L_E_T_ = ' ' "
EndIf
                             
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTmp,.T.,.T.)

If lTabSF2
    TcSetField(cArqTmp,"F2_EMISSAO","D",8,0)
    TCSetField(cArqTmp,"F2_VALFAT","N",TamSX3("F2_VALFAT")[1],TamSX3("F2_VALFAT")[2])
Else
    TcSetField(cArqTmp,"F1_EMISSAO","D",8,0)
    TCSetField(cArqTmp,"F1_VALBRUT","N",TamSX3("F1_VALBRUT")[1],TamSX3("F1_VALBRUT")[2])
EndIf    

(cArqTmp)->(dbGoTop())

If !(cArqTmp)->(EOF())

    lRet := .t.
     
    If lTabSF2
        
        dDtNFOri  := (cArqTmp)->F2_EMISSAO   
        cNFOri    := (cArqTmp)->F2_DOC 
        cAutNFOri := (cArqTmp)->F2_NUMAUT
        nValNFOri := Round(NoRound(xMoeda((cArqTmp)->F2_VALFAT,(cArqTmp)->F2_MOEDA,1,(cArqTmp)->F2_EMISSAO,,(cArqTmp)->F2_TXMOEDA )),2) 

    Else

        dDtNFOri  := (cArqTmp)->F1_EMISSAO   
        cNFOri    := (cArqTmp)->F1_DOC 
        cAutNFOri := (cArqTmp)->F1_NUMAUT
        nValNFOri := Round(NoRound(xMoeda((cArqTmp)->F1_VALBRUT,(cArqTmp)->F1_MOEDA,1,(cArqTmp)->F1_EMISSAO,,(cArqTmp)->F1_TXMOEDA )),2) 
    
    EndIf
    
EndIf

(cArqTmp)->(dbCloseArea())

Return lRet

