#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'TOPCONN.CH'

/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DaVinBOL ³ Autor ³Jorge Saavedra    ³ Data ³ 25.07.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Preparacao do meio-magnetico para o software DaVinci-LCV,   ³±±
±±³          ³geracao dos Livros de Compra e Vendas IVA.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUse       ³ BASE BOLIVIA                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DaVinBOL(cLivro)

Local aArea	:= GetArea()
Private nCaja:=""
Private nRendicion:=""
GeraTemp()

If cPaisLoc == "BOL" .And. LocBol()
	ProcLivro(cLivro)
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
Static Function GeraTemp()

Local aStru	:= {}
Local cArq	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Temporario LCV - Livro de Compras e Vendas IVA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aStru,{"TIPONF"	,"C",001,0})
AADD(aStru,{"NIT"		,"C",015,0})
AADD(aStru,{"RAZSOC"	,"C",060,0})
AADD(aStru,{"NFISCAL"	,"C",013,0})
AADD(aStru,{"POLIZA"	,"C",020,0}) 
AADD(aStru,{"NUMAUT"	,"C",015,0})
AADD(aStru,{"EMISSAO"	,"D",008,0}) 
AADD(aStru,{"VALCONT"	,"N",014,2})
AADD(aStru,{"ICE"		,"N",014,2})
AADD(aStru,{"EXENTAS"	,"N",014,2})
AADD(aStru,{"BASEIMP"	,"N",014,2})
AADD(aStru,{"VALIMP"	,"N",014,2})
AADD(aStru,{"STATUSNF"	,"C",001,0})
AADD(aStru,{"CODCTR"	,"C",014,0})
AADD(aStru,{"SERIE"	,"C",003,0})
//AADD(aStru,{"CAJA"	,"C",003,0})
//AADD(aStru,{"REND"	,"C",010,0})

cArq := CriaTrab(aStru)
dbUseArea(.T.,__LocalDriver,cArq,"LCV")
cIndex	:= CriaTrab(Nil,.F.)
IndRegua('LCV',cIndex,'DTOS(EMISSAO)+NIT+NFISCAL+SERIE',,,"Selecionando registros...") 

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
Static Function ProcLivro(cLivro)

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
Local cCpoPza	:= GetNewPar("MV_DAVINC2","")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
Local cCpoDta   := GetNewPar("MV_DAVINC3","")		//Campo da tabela SF1: que contem a Data de Poliza de Importacion
Local cDocumento:=""       
LOcal aDatosCli:={}
//If mv_par06 == 1
	If cLivro == "C"	//Compras
		cTop := "F3_FILIAL = '" + xFilial('SF3') + "' AND SUBSTRING(F3_CFO,1,1) < '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "'"
		cDbf := "F3_FILIAL == '" + xFilial('SF3') + "' .AND. SUBSTRING(F3_CFO,1,1) < '5' .AND. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "'"
	Else				//Vendas
		cTop := "F3_FILIAL = '" + xFilial('SF3') + "' AND SUBSTRING(F3_CFO,1,1) >= '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "'"
		cDbf := "F3_FILIAL == '" + xFilial('SF3') + "' .AND. SUBSTRING(F3_CFO,1,1) >= '5' .AND. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "'"
	Endif 
/*Else
	If cLivro == "C"	//Compras
		cTop := " SUBSTRING(F3_CFO,1,1) < '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "'"
		cDbf := " SUBSTRING(F3_CFO,1,1) < '5' .AND. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "'"
	Else				//Vendas
		cTop := " SUBSTRING(F3_CFO,1,1) >= '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "'"
		cDbf := " SUBSTRING(F3_CFO,1,1) >= '5' .AND. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .AND. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "'"
	Endif 
End*/
  

//Filtro para Desconsiderar TES de Zona Franca     
//If !Empty(GetMV('MV_UCTESZF'))
  // cTop+=" AND F3_TES NOT IN (" + GetMV('MV_UCTESZF') + ") " 
//End                                                       
 //cTop+=" AND F3_EXENTAS = 0  " 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aImp com as informacoes dos impostos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SFB")
dbSetOrder(1)
dbGoTop()

AADD(aImp,{"IVA",""})                
While !SFB->(Eof()) 
	If aScan(aImp,{|x| SFB->FB_CODIGO $ x[1]}) > 0
		aImp[aScan(aImp,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
	Endif	
	dbSkip()
Enddo                 
aSort(aImp,,,{|x,y| x[2] < y[2]})

AAdd(aImp[1],SF3->(FieldPos("F3_BASIMP"+aImp[1][2])))		//Base de Calculo
AAdd(aImp[1],SF3->(FieldPos("F3_VALIMP"+aImp[1][2])))		//Valor do Imposto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria Query / Filtro                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF3->(dbSetOrder(1))
//FsQuery(aAlias,1,cTop,cDbf,SF3->(IndexKey()))
FsQuery(aAlias,1,cTop,cDbf,"F3_NFISCAL")

SD2->(DbSetorder(3))
SC5->(DbSetOrder(1))

dbSelectArea("SF3")
While !Eof()              
  if cLivro == "C"  .and. SF3->F3_ESPECIE <> 'NF'           
  else

//    If SF3->F3_STATUS == ' ' .AND. Empty(SF3->F3_DTCANC)    
    If  Empty(SF3->F3_DTCANC)    
       If cLivro == "C"                  

          cNit:=cRazSoc:=""
          If SF3->F3_TIPO <> 'D' 

		     If SF1->(DbSeek(SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
		        cRazSoc := SF1->F1_UNOMBRE
  		        cNIT	   := SF1->F1_UNIT
		     End
		     if !Empty(alltrim(SF3->F3_UNOMBRE))
		     	cRazSoc := alltrim(SF3->F3_UNOMBRE) 		        
		     end
		      if !Empty(alltrim(SF3->F3_UNIT))
		     	cNIT := alltrim(SF3->F3_UNIT) 		        
		     end
             If Empty(cNIT)
		        cNIT	:= Posicione("SA2",1,xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA),"A2_CGC")
		     End       
		     If Empty(cRazSoc)           
    		    cRazSoc	:= Posicione("SA2",1,xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA),"A2_NOME") 
   			  End	
		  Else
             cNit:=cRazSoc:=""
		    /* If SD2->(DbSeek(SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
		        If SC5->(DbSeek(xFilial('SC5')+SD2->D2_PEDIDO))
			       cRazSoc := SC5->C5_UNOMCLI
			       cNIT	  := SC5->C5_UNITCLI
		        End
		     End*/
		     	  aDatosCli:= u_GetNomNit(SF3->F3_NFISCAL,SF3->F3_SERIE, SF3->F3_CLIEFOR, SF3->F3_LOJA,SF3->f3_filial) 
			iF Len(aDatosCli)>0
				cRazSoc := alltrim(aDatosCli[1])
				cNIT	   := aDatosCli[2]
				cDocumento := aDatosCli[4]
			end
		    /* If SF2->(DbSeek(SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
					cRazSoc := alltrim(SF2->F2_UNOMCLI)
					cNIT	   := SF2->F2_UNITCLI
			 End*/  
			 cRazSoc := If(Empty(cRazSoc),Posicione("SA1",1,xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A1_NOME"),cRazSoc)
			 cNIT	:= If(Empty(cNit),Posicione("SA1",1,xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A1_CGC"),cNit)
          End
		    
  	    Else 
  	        If SF3->F3_TIPO <> 'B'        
	            cNit:=cRazSoc:=""
			   /* If SD2->(DbSeek(SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
			       If SC5->(DbSeek(SF3->F3_FILIAL+SD2->D2_PEDIDO))     
				      cRazSoc := SC5->C5_UCNOME
			    	  cNIT	  := SC5->C5_UCNIT
			       End
			    End    
			     If SF2->(DbSeek(SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
					cRazSoc := alltrim(SF2->F2_UNOMCLI)
					cNIT	   := SF2->F2_UNITCLI
				End*/
				  aDatosCli:= u_GetNomNit(SF3->F3_NFISCAL,SF3->F3_SERIE, SF3->F3_CLIEFOR, SF3->F3_LOJA,SF3->f3_filial) 
			iF Len(aDatosCli)>0
				cRazSoc := alltrim(aDatosCli[1])
				cNIT	   := aDatosCli[2]
			end  
				cRazSoc := If(Empty(Alltrim(cRazSoc)),Posicione("SA1",1,xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A1_NOME"),cRazSoc)
				cNIT	:= If(Empty(Alltrim(cNit)),Posicione("SA1",1,xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A1_CGC"),cNit) 
	    	Else
				cRazSoc := Posicione("SA2",1,xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A2_NOME")
				cNIT	:= Posicione("SA2",1,xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA,"A2_CGC") 
	        End
		End
	Else
	   cNIT:='0'
	   cRazSoc:=If(!Empty(SF3->F3_DTCANC),'A N U L A D A','')	    

	   If cRazSoc =='A N U L A D A'
	      //Verificar se há NF Normal generada para el Numero / Serie
	      If U_AnuReutil(SF3->F3_SERIE,SF3->F3_NFISCAL)
			dbSelectArea('SF3')
			SF3->(dbSkip())
	        Loop
	      End
	   End

	Endif                 

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
	_cMoneda:=''
    if cLivro == "V"      
    	iF Len(aDatosCli)>0
    	
			_cMoneda := aDatosCli[3]
		else
			_cMoneda := Posicione('SF2',2,XFILIAL('SF2')+SF3->(F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE),'F2_MOEDA')
		end
    ELSE
      	_cMoneda := Posicione('SF1',1,XFILIAL('SF1')+SF3->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA),'F1_MOEDA')
    End
    
    cNIT:= STR(VAL(cNIT),15)
    
    /*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
		Aviso("DAVINGUC- 1","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
	Endif*/
    
    //Trecho incluso por WCS em 25/FEB/2010 - Para acumular todas as movimentações da NF em uma mesma linha  
	

     // IF LCV->(DbSeek(DTOS(SF3->F3_EMISSAO)+cNIT+STR(VAL(SF3->F3_NFISCAL),12)+SF3->F3_NUMAUT+SF3->F3_CODCTR))
     
    IF LCV->(DbSeek(DTOS(SF3->F3_EMISSAO)+cNIT+STR(VAL(SF3->F3_NFISCAL),13)+SF3->F3_SERIE))
	   RecLock("LCV",.F.)
	   LCV->VALCONT	:= LCV->VALCONT + If(SF3->F3_BASIMP1 > 0,XMOEDA(SF3->F3_BASIMP1,_cMoneda,1,SF3->F3_ENTRADA),SF3->F3_VALCONT)+ SF3->F3_VALOBSE  	
	   
	   /*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 2","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
	   Endif*/
	   
	   LCV->EXENTAS	:= LCV->EXENTAS + SF3->F3_EXENTAS+ SF3->F3_VALOBSE  
	   
	   			
  	   If aImp[1][3] > 0 .AND. SF3->F3_EXENTAS==0
	      LCV->BASEIMP	:= LCV->BASEIMP + XMOEDA(SF3->(FieldGet(aImp[1][3])),_cMoneda,1,SF3->F3_ENTRADA) //SF3->(FieldGet(aImp[1][3]))		//Base de Calculo
	   Endif
	   
	   /*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 3","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
		Endif*/
	   
	   If aImp[1][4] > 0	.AND. SF3->F3_EXENTAS==0
  			LCV->VALIMP	:= LCV->VALIMP + XMOEDA(SF3->(FieldGet(aImp[1][4])),_cMoneda,1,SF3->F3_ENTRADA)  	//Valor do Imposto
	   Endif            
	   /*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 4","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
		Endif*/
		
		
		
	   If cLivro == "C" .And. SF1->(FieldPos(cCpoPza)) > 0 .And. SF1->(FieldPos(cCpoDta)) > 0 
 	  		If LEN(Alltrim(LCV->POLIZA)) >1
 	  			LCV->VALIMP	:= (SF3->(FieldGet(aImp[1][4]))*100)/13 //SF3->(FieldGet(aImp[1][4]))
 		   		LCV->BASEIMP	:= LCV->BASEIMP + (SF3->(FieldGet(aImp[1][4]))*100)/13		//Base de Calculo    
 		     	LCV->VALCONT    := LCV->VALCONT + LCV->BASEIMP
	     	End   
	   End   
	   /*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 5","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
		Endif*/
	   If alltrim( LCV->CODCTR) == '0'
	   		LCV->CODCTR:= SF3->F3_CODCTR
	   eND   
	   IF EMPTY(alltrim(NUMAUT))
	   		LCV->NUMAUT:= SF3->F3_NUMAUT
	   END
	   // Fim do Trecho incluso por WCS em 25/FEB/2010 - Para acumular todas as movimentações da NF em uma mesma linha  
      if (cLivro=="V")
    			LCV->NFISCAL	:= STR(VAL(SF3->F3_NFISCAL),13)
      end
      
    /*  IF (cLivro == "C")
      		VerificaCCH(SF3->F3_NFISCAL,SF3->F3_SERIE,SF3->F3_CLIEFOR,SF3->F3_LOJA)
      		LCV->CAJA	:= nCaja
      		LCV->REND	:= nRendicion      		
      End*/
    Else
                           
		/*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 6","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
		Endif*/
		
		RecLock("LCV",.T.)
		LCV->TIPONF		:= cTpNf
		LCV->NIT		:= cNIT
		LCV->RAZSOC		:= cRazSoc
		LCV->NFISCAL	:= STR(VAL(SF3->F3_NFISCAL),13)
		LCV->POLIZA		:= "0"
		LCV->EMISSAO	:= SF3->F3_EMISSAO
		LCV->NUMAUT		:= SF3->F3_NUMAUT   
		LCV->SERIE 		:= SF3->F3_SERIE
		/*IF (cLivro == "C")
      		VerificaCCH(SF3->F3_NFISCAL,SF3->F3_SERIE,SF3->F3_CLIEFOR,SF3->F3_LOJA)
      		LCV->CAJA	:= nCaja
      		LCV->REND	:= nRendicion      		
      End*/
    	If cLivro == "C" .And. SF1->(FieldPos(cCpoPza)) > 0 .And. SF1->(FieldPos(cCpoDta)) > 0 
  		    If SF3->F3_TIPO <> 'D' 
	   			If !Empty(SF1->&(cCpoPza))		//Numero da Poliza de Importacion
	 	  			LCV->POLIZA		:= SF1->&(cCpoPza)
	 	  			If LEN(Alltrim(SF1->&(cCpoPza))) > 1
 	          		     LCV->NFISCAL	:= '0'
 	           	End         
 	  	   		Endif
			  	If !Empty(SF1->&(cCpoDta))		//Data da Poliza de Importacion
					 LCV->EMISSAO	:= SF1->&(cCpoDta)
		 		Endif
			Else	 	 
				LCV->POLIZA		:= "0"
	 		End
		Endif
    
		/*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 7","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'"+Chr(13)+Chr(10)+"_cMoneda: "+ AllTrim(Str(_cMoneda))+Chr(13)+Chr(10)+"SF3->F3_VALCONT: '"+AllTrim(Str(SF3->F3_VALCONT))+"'"+Chr(13)+Chr(10)+"SF3->F3_ENTRADA: "+DTOC(SF3->F3_ENTRADA)+"'",{"OK"})
			Aviso("DAVINGUC -7.1","SF3->F3_BASIMP1: "+AllTrim(Str(SF3->F3_BASIMP1)),{"OK"})
		Endif*/
//	    If SF3->F3_STATUS == ' ' .AND. Empty(SF3->F3_DTCANC)   
	    If  Empty(SF3->F3_DTCANC)   			
			// 03/10/2011
			If cLivro == "C"
				LCV->VALCONT	:= SF3->F3_VALCONT//If(SF3->F3_BASIMP1 > 0, SF3->F3_BASIMP1, SF3->F3_VALCONT)		   
		   	Else
		   		//LCV->VALCONT	:= SF3->F3_VALCONT// If(SF3->F3_BASIMP1 > 0,XMOEDA(SF3->F3_BASIMP1,_cMoneda,1,SF3->F3_ENTRADA),SF3->F3_VALCONT)
		   		//LCV->VALCONT	:= If(SF3->F3_BASIMP1 > 0,SF3->F3_BASIMP1,SF3->F3_VALCONT)
		   		//LCV->VALCONT	:= SF3->F3_VALCONT
		   		
		   		
		   		//04/11/2011
		   		
		   		nValBruto 	:= 0
		   		nMoneda		:= 0
		   		dFecha	    := dDatabase
		   		aDatosCli:= u_GetNomNit(SF3->F3_NFISCAL,SF3->F3_SERIE, SF3->F3_CLIEFOR, SF3->F3_LOJA,SF3->f3_filial) 
		   		iF Len(aDatosCli)>0
		   			nValBruto := (aDatosCli[4])
		   			dFecha	   := stod(aDatosCli[5])
		   			nMoneda	   := aDatosCli[3]
		   		else
		   		
		   			DbSelectArea('SF2')
		   			SF2->(DbSetOrder(1))
		   			If SF2->(DbSeek(xFilial('SF3')+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR))
		   				While SF2->(!EOF()) .AND. SF2->F2_FILIAL==xFilial('SF3');
										.AND. SF2->F2_DOC==SF3->F3_NFISCAL 	;
										.AND. SF2->F2_SERIE==SF3->F3_SERIE	;
										.AND. SF2->F2_TIPODOC=='01'
							nValBruto 	:= SF2->F2_VALBRUT
							nMoneda		:= SF2->F2_MOEDA
							dFecha		:= SF2->F2_EMISSAO
							Exit							
							SF2->(DbSkip())
						End
					EndIf
				end
                /*If nValBruto > 0 .AND. AllTrim(cMoneda)=='2'
                	nValBruto	:= xMoeda(nValBruto,2,1,dFecha)
                Endif*/
		   		LCV->VALCONT	:= xMoeda(nValBruto,nMoneda,1,dFecha)
		   		
		   	Endif
		   	
		   	LCV->ICE		:= 0
		   	LCV->EXENTAS	:= SF3->F3_EXENTAS
		   
		   	/*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 8","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'"+Chr(13)+Chr(10)+"_cMoneda: "+ AllTrim(Str(_cMoneda))+Chr(13)+Chr(10)+"SF3->F3_VALCONT: '"+AllTrim(Str(SF3->F3_VALCONT))+"'"+Chr(13)+Chr(10)+"SF3->F3_ENTRADA: "+DTOC(SF3->F3_ENTRADA)+"'",{"OK"})
			Endif*/
		   
  		   	If aImp[1][3] > 0
		   		//03/10/2011
				If cLivro == "C"
		   			LCV->BASEIMP	:= 	LCV->VALCONT// SF3->(FieldGet(aImp[1][3]))//Base de Calculo
		  		Else
					//26/10/2011
					//LCV->BASEIMP	:= XMOEDA(SF3->(FieldGet(aImp[1][3])),_cMoneda,1,SF3->F3_ENTRADA)//Base de Calculo
					//LCV->BASEIMP	:= SF3->(FieldGet(aImp[1][3]))	//Base de Calculo
					//LCV->BASEIMP	:= 	LCV->VALCONT
					//04/11/2011
					LCV->BASEIMP	:= 	LCV->VALCONT
		  		Endif
		  		
//   		    LCV->BASEIMP	:= SF3->F3_VALCONT//SF3->(FieldGet(aImp[1][3]))		//Base de Calculo
		   	Endif

		   	/*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 9","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
			Endif*/
		   	If aImp[1][4] > 0
			  // 26/10/2011
			  LCV->VALIMP		:= SF3->F3_VALCONT * 0.13 //SF3->(FieldGet(aImp[1][4]))		//Valor do Imposto
		  	  If cLivro == "V"
		  	  	LCV->VALIMP		:= LCV->BASEIMP * 0.13
		  	  Endif
		  	  //LCV->VALIMP		:= XMOEDA((SF3->F3_VALCONT * 0.13),_cMoneda,1,SF3->F3_ENTRADA)	// XMOEDA(SF3->(FieldGet(aImp[1][4])),_cMoneda,1,SF3->F3_ENTRADA)		//Valor do Imposto
		   	Endif
           
			/*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 10","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
			Endif*/

		   	If cLivro == "C" .And. SF1->(FieldPos(cCpoPza)) > 0 .And. SF1->(FieldPos(cCpoDta)) > 0 
 	  			If LEN(Alltrim(LCV->POLIZA)) > 1
 	  				LCV->VALIMP	:=SF3->(FieldGet(aImp[1][4]))
 		    	    LCV->BASEIMP	:=  (SF3->(FieldGet(aImp[1][4]))*100)/13		//Base de Calculo    
 		        	LCV->VALCONT    := LCV->BASEIMP
	            End   
		   	End
			/*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 11","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
			Endif*/
	    
	    Else
 		   LCV->VALCONT	:= 0
		   LCV->ICE		:= 0
		   LCV->EXENTAS	:= 0
    	   LCV->BASEIMP	:= 0		//Base de Calculo
 	 	   LCV->VALIMP  := 0		//Valor do Imposto
 	 	   /*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 12","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
			Endif*/
    	End
    
		//	LCV->STATUSNF	:= IIf(Empty(SF3->F3_DTCANC),"V","A")	//NF Valida ou Anulada
 		LCV->STATUSNF	:= If(Empty(SF3->F3_DTCANC),"V",'A')	//NF Valida ou Anulada
		LCV->CODCTR		:= If(Empty(SF3->F3_DTCANC),SF3->F3_CODCTR,'0')
	End	
		LCV->CODCTR		:=If(!Empty(LCV->CODCTR),	LCV->CODCTR,'0')	
		
		/*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 13","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
		Endif*/
		
		IF cLivro <> "C"
			If U_VerificaNF(SF3->F3_NFISCAL,SF3->F3_SERIE)
  			   LCV->NIT		:= '0'
			   LCV->RAZSOC	:= 'A N U L A D A'                      
			   LCV->CODCTR	:= '0'
	 		   LCV->VALCONT	:= 0
			   LCV->ICE		:= 0
			   LCV->EXENTAS	:= 0
    		   LCV->BASEIMP	:= 0		//Base de Calculo
 	 		   LCV->VALIMP  := 0		//Valor do Imposto
   			   LCV->STATUSNF:='A'
			End
		End     
		/*If AllTrim(SF3->F3_NFISCAL) == AllTrim("2851839198")
			Aviso("DAVINGUC- 14","LCV->VALCONT: '"+AllTrim(Str(LCV->VALCONT))+"' "+Chr(13)+Chr(10)+"LCV->BASEIMP: '"+AllTrim(Str(LCV->BASEIMP))+"'",{"OK"})
		Endif*/
	LCV->(MsUnlock())
 end
	dbSelectArea("SF3")
	dbSkip()
Enddo

FsQuery(aAlias,2)

Return Nil
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ANUREUTILºAutor  Walter Silva (TOTVS-BOLIVIA)º Data ³21/01/10º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VERIFICA SE FACTURA ANULADA FOI REUTIIZADA.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP11BOL                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USer Function AnuReutil(_cSerie,_cNF)   //Verifica se uma NF Anulada foi Reutilizada - WCS - 20/JAN/2010
Local _cQuery

_cQuery:= "SELECT * FROM " + RetSqlName('SF3')
_cQuery+= " WHERE F3_SERIE = '" + _cSerie + "' AND"
_cQuery+= " F3_NFISCAL = '" + _cNF + "' AND "
_cQuery+= "  "
_cQuery+= " F3_DTCANC = '" + DTOS(CTOD(SPACE(08))) + "' AND "      
_cQuery+= " D_E_L_E_T_ <> '*'"

If SELECT('TRBSF3') > 0
   TRBSF3->(DbCloseArea())
End   
TCQUERY _cQuery NEW ALIAS 'TRBSF3'

If TRBSF3->(!EOF()) .and. TRBSF3->(!BOF())
   //Ha NFs geradas com o mesmo número da Anulada
   Return(.T.)
Else
   Return(.F.)
End      
Return

User Function VerificaNF(_cDoc, _cSerie)
Local _cQuery
                      
_cQuery:= "SELECT * FROM " + RetSqlName('SD1')  
//_cQuery+= "  INNER JOIN " + RetSqlName('SF1') + " ON(F1_DOC=D1_DOC AND F1_SERIE = D1_SERIE AND F1_FILIAL= D1_FILIAL )"
_cQuery+= "  INNER JOIN " + RetSqlName('SF1') + " ON(F1_DOC=D1_DOC AND F1_FORNECE= D1_FORNECE AND F1_LOJA = D1_LOJA AND F1_FILIAL= D1_FILIAL )"
_cQuery+= " WHERE D1_SERIORI = '" + _cSerie + "' AND"
_cQuery+= " D1_NFORI = '" + _cDoc + "' AND "
_cQuery+= " D1_ESPECIE = 'NCC' AND "  
_cQuery+= " D1_SERIE = '"+ 'NC'+RIGHT(CFILANT,1)+"' AND "  
_cQuery+= RetSqlName('SD1') +".D_E_L_E_T_ <> '*' AND "
_cQuery+= RetSqlName('SF1') +".D_E_L_E_T_ <> '*' "


If SELECT('TRBSD1') > 0
   TRBSD1->(DbCloseArea())
End   
TCQUERY _cQuery NEW ALIAS 'TRBSD1'

If TRBSD1->(!EOF()) .and. TRBSD1->(!BOF())
   //Ha NFs geradas com o mesmo número da Anulada           

   IF TRBSD1->D1_TES == '201'
   	   Return(.F.)
   ELSE
       Return(.T.)
   eND
Else             
   Return(.F.)
End      

Return

Static Function VerificaCCH(_cDoc, _cSerie,_cProveedor,_cLoja)
 nCaja:=""
 nRendicion:=""
                      
_cQuery:= "SELECT * FROM " + RetSqlName('SEU')  
//_cQuery+= "  INNER JOIN " + RetSqlName('SF1') + " ON(F1_DOC=D1_DOC AND F1_SERIE = D1_SERIE AND F1_FILIAL= D1_FILIAL )"
//_cQuery+= "  INNER JOIN " + RetSqlName('SF1') + " ON(F1_DOC=D1_DOC AND F1_FORNECE= D1_FORNECE AND F1_LOJA = D1_LOJA AND F1_FILIAL= D1_FILIAL )"
_cQuery+= " WHERE EU_SERCOMP = '" + _cSerie + "' AND"
_cQuery+= " EU_NRCOMP = '" + _cDoc + "' AND "
_cQuery+= " EU_TIPO = '00' AND "  
_cQuery+= " EU_FORNECE = '"+ _cProveedor +"' AND "  
_cQuery+= " EU_LOJA = '"+ _cLoja +"' AND "
//_cQuery+= RetSqlName('SEU') +".D_E_L_E_T_ <> '*' AND "
_cQuery+= RetSqlName('SEU') +".D_E_L_E_T_ <> '*' "


If SELECT('TRBSEU') > 0
   TRBSEU->(DbCloseArea())
End   
TCQUERY _cQuery NEW ALIAS 'TRBSEU'

If TRBSEU->(!EOF()) .and. TRBSEU->(!BOF())
   //Ha NFs geradas com o mesmo número da Anulada           
 	nCaja:=TRBSEU->EU_CAIXA
 	nRendicion:=TRBSEU->EU_NRREND
   
End      

Return
