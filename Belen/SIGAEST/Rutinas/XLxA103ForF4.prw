#INCLUDE "RWMAKE.CH"                                      
#INCLUDE "MATA103.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ForF4 ³ Autor ³ Edson Maricate        ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de importacao de Pedidos de Compra.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103Pedido()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function XLxA103ForF4(lUsaFiscal)

Local nSldPed		:= 0
Local nOpc			:= 0
Local nCntFor		:= 0
Local naCols        := 0
Local nPosQUANT		:= 0
Local nPosVUNIT		:= 0
Local nPosTOTAL		:= 0
Local cSavScr		:= ""
Local cSavCur		:= ""
Local cSavCor		:= ""
Local cQuery        := ""
Local cAliasSC7     := "SC7"
Local lClass		:= .F.
Local lQuery        := .F.
/*
Local bSavSetKey	:= SetKey(VK_F4,Nil)
Local bSavKeyF5     := SetKey(VK_F5,Nil)
Local bSavKeyF6     := SetKey(VK_F6,Nil)
Local bSavKeyF7     := SetKey(VK_F7,Nil)
Local bSavKeyF8     := SetKey(VK_F8,Nil)
Local bSavKeyF9     := SetKey(VK_F9,Nil)
Local bSavKeyF10    := SetKey(VK_F10,Nil)
Local bSavKeyF11    := SetKey(VK_F11,Nil)
*/
Local bSavSetKey
Local bSavKeyF5 
Local bSavKeyF6 
Local bSavKeyF7 
Local bSavKeyF8 
Local bSavKeyF9 
Local bSavKeyF10
Local bSavKeyF11

Local bWhile
Local cVariavel		:= ReadVar()
Local cChave		:= ""
Local cCadastro		:= ""
Local aArea			:= GetArea()
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSC7		:= SC7->(GetArea())
Local aCopia		:= aClone(aCols[1])
Local aStruSC7      := SC7->(dbStruct())
Local aF4For		:= {}
Local nF4For		:= 0
Local oOk			:= LoadBitMap(GetResources(), "LBOK")
Local oNo			:= LoadBitMap(GetResources(), "LBNO")
Local aButtons		:= { {'PESQUISA',{||A103VisuPC(aRecSC7[oListBox:nAt])},OemToAnsi(STR0059)} } //"Visualiza Pedido"
Local oDlg,oListBox,cListBox
Local cNomeFor		:= ''
Local aRecSC7		:= {}
Local lZeraCols		:= .T.
Local cItem			:= StrZero(1,Len(SD1->D1_ITEM))
Local aTitCampos    := {}
Local aConteudos    := {}
Local aUsCont       := {}
Local aUsTitu       := {}
Local bLine         := { || .T. }
Local cLine         := ""
Local lMa103F4I     := ExistBlock('MA103F4I')
Local lMa103F4H     := ExistBlock('MA103F4H')
Local nLoop         := 0
Local nX			:= 0
Local nI			:= 0
Local lMt103Vpc     := ExistBlock("MT103VPC")
Local lRet103Vpc    := .T.
Local lContinua     := .T.
Local lMoedaIgual	:= .T.
Local aMoedaAux		:= {}
Local cFiltraQry    := ""
Local lFiltraQry    := .F.
Local aPrvEnt		:= {}
cPeT := LocxPET(43)
cPe	:=	LocxPE(43)
lFiltraQry := If(!Empty(cPe) .Or. !Empty(cPet),.T.,.F.)
Private lUsaFiscal	:= .T.
cTipo := 'N'
//If !Pergunte("DTTR01"+Space(4),.T.)
//   Return
//End

//alert("Entro")

ca100for:="      " //MV_PAR01
cLoja   :="  " //MV_PAR02
m->f1_moeda:=m->f2_moeda
cFilialmi := xFilial("SC7")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lContinua

	If MaFisFound("NF") .Or. !lUsaFiscal
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o aCols esta vazio, se o Tipo da Nota e'     ³
		//³ normal e se a rotina foi disparada pelo campo correto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipo == "N"
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial()+cA100For+cLoja)
			cNomeFor	:= SA2->A2_NOME

			#IFDEF TOP

				If lFiltraQry
					cFiltraQry	:= ""
					If !Empty(cPet)
						cFiltraQry	+=	ExecTemplate(cPet,.F.,.F.)
					EndIf
					If !Empty(cPe)
						cFiltraQry	+=	Iif(!Empty(cFiltraQry)," AND ","")+ExecBlock(cPe,.F.,.F.)
					EndIf
					If ValType(cFiltraQry) <> 'C'
						cFiltraQry	:=	''
					Endif	
				EndIf

				dbSelectArea("SC7")
				If TcSrvType() <> "AS_CAMBIO_NT_400"

					lQuery    := .T.
					cAliasSC7 := "QRYSC7"

					cQuery := "SELECT SC7.*,SC7.R_E_C_N_O_ RECSC7, C7_QUJE B2_QATU FROM "
					cQuery += RetSqlName("SC7") + " SC7, " + RetSqlName("SD1") + " SD1, " + RetSqlName("SB2") + " SB2 "
					cQuery += "WHERE SC7.C7_NUM = SD1.D1_PEDIDO AND SC7.C7_ITEM = SD1.D1_ITEMPC AND SC7.C7_PRODUTO = SB2.B2_COD AND SB2.B2_LOCAL LIKE 'M%' AND SD1.D1_FILIAL = '"+xFilEnt(xFilial("SC7"))+"' "
					// SB2.B2_QATU > 0 "
					// cQuery += "C7_FILIAL = '"+xFilEnt(xFilial("SC7"))+"' AND " // ORIGINAL
//					cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND " // ORIGINAL
//					cQuery += "C7_FORNECE = '"+cA100For+"' AND "
//					If ( lConsLoja )
//						cQuery += "C7_LOJA = '"+cLoja+"' AND "
//					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os Pedidos Bloqueados e Previstos.                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery += "AND D1_TES IN('300', '301') AND SD1.D1_FILIAL = SB2.B2_FILIAL AND "
					// C7_TIPO = '1' AND C7_TPOP <> 'P' AND " //NTC Para que salgan todos
					If SuperGetMV("MV_RESTNFE") == "S" 
						cQuery += "C7_CONAPRO <> 'B' AND "
					EndIf
			  		cQuery += "SC7.C7_QUJE > 0 AND B2_QATU > 0 AND "
					cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "
//					cQuery += "SC7.C7_NUM > '4     ' AND "

					cQuery += "SC7.D_E_L_E_T_ = ' '"
										
MemoWrite("\query_ocp.sql",cQuery)  

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

					For nX := 1 To Len(aStruSC7)
						If aStruSC7[nX,2]<>"C"
							TcSetField(cAliasSC7,aStruSC7[nX,1],aStruSC7[nX,2],aStruSC7[nX,3],aStruSC7[nX,4])
						EndIf
					Next nX

					bWhile := {|| (cAliasSC7)->(!Eof())}

			Else
			#ENDIF

				dbSelectArea("SC7")
				dbSetOrder(3) // dbSetOrder(9) //ORIGINAL
				If ( lConsLoja )
					cChave := cA100For+CLOJA
				Else
					cChave := cA100For
				EndIf
				//MsSeek(xFilEnt(cFilial)+cChave,.T.) //ORIGINAL
				
				MsSeek(cFilialmi+cChave,.T.)

				//bWhile := {|| (cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial) == (cAliasSC7)->C7_FILIAL .And. ;  //ORIGINAL
				bWhile := {|| (cAliasSC7)->(!Eof()) .And. cFilialmi == (cAliasSC7)->C7_FILIAL .And. ;
					cA100For == (cAliasSC7)->C7_FORNECE .And. ;
					IIf(lConsLoja,CLOJA==(cAliasSC7)->C7_LOJA,.T.)}

				#IFDEF TOP
				Endif
				#ENDIF

			While Eval(bWhile)

				#IFNDEF TOP

					If lFiltraQry
						cFiltraQry := ""
						cPet	:= LocxPEt(43)
						cFiltraQry += ExecTemplate(cPet,.F.,.F.)
						cPe	:= LocxPE(43)
						cFiltraQry += Iif(!Empty(cFiltraQry)," .AND. ","")+Execblock(cPe,.F.,.F.)
					Else

						cFiltraQry := "AlwaysTrue()"		
					Endif

				#ELSE
					cFiltraQry := "AlwaysTrue()"	
				#ENDIF
				
				If &(cFiltraQry)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o Saldo do Pedido de Compra                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSldPed := (cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se nao h  residuos, se possui saldo em abto e   ³
					//³ se esta liberado por alcadas se houver controle.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lQuery
						If (SuperGetMV("MV_RESTNFE") == "S" .And. (cAliasSC7)->C7_CONAPRO == "B") .Or. ;
						   (cAliasSC7)->C7_TPOP == "P" .Or. !Empty((cAliasSC7)->C7_RESIDUO)
							dbSkip()
							Loop
						EndIf
                    Endif							
						                                                
					If (nSldPed > 0.00) //.And. Empty(SC7->C7_RESIDUO) )
		
						nF4For := aScan(aF4For,{|x|x[2]==(cAliasSC7)->C7_LOJA .And. x[3]==(cAliasSC7)->C7_NUM})
					
						If ( nF4For == 0 )

							aConteudos := {}
							aAdd(aConteudos, .F.) //-- 01
							aAdd(aConteudos, (cAliasSC7)->C7_LOJA) //-- 02
							aAdd(aConteudos, (cAliasSC7)->C7_NUM) //-- 03
							aAdd(aConteudos, DtoC((cAliasSC7)->C7_EMISSAO)) //-- 04
							aAdd(aConteudos, If((cAliasSC7)->C7_TIPO==2, 'AE', 'PC')) //-- 05
							aAdd(aConteudos, AllTrim(GetMV('MV_MOEDA' + AllTrim(Str(Max((cAliasSC7)->C7_MOEDA,1)))))) //-- 06
							If (cAliasSC7)->(FieldPos('C7_PROVENT')) > 0 //-- Soh adiciona o 7o elemento se o campo existir na base de dados
								aAdd(aConteudos, (cAliasSC7)->C7_PROVENT) //-- 07
							EndIf
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Ponto de Entrada para adicionar Colunas na consulta F4 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
							If lMa103F4I
								If ValType(aUsCont:= ExecBlock('MA103F4I', .F., .F. )) == 'A'
									aEval(aUsCont, {|x| aAdd( aConteudos, x )})
								EndIf
							EndIf
  */							
							aAdd(aF4For , aConteudos)
							aAdd(aRecSC7, If(lQuery, (cAliasSC7)->RECSC7, Recno()))
						EndIf
					EndIf
				EndIf	
				(cAliasSC7)->(dbSkip())
			EndDo
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os dados na Tela                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If ( !Empty(aF4For) )
				aTitCampos := {}
				aAdd(aTitCampos, ' ') //-- 01
				aAdd(aTitCampos, OemToAnsi(STR0060)) //"Loja" //-- 02
				aAdd(aTitCampos, OemToAnsi(STR0061)) //"Pedido" //-- 03
				aAdd(aTitCampos, OemToAnsi(STR0039)) //"Emissao" //-- 04
				aAdd(aTitCampos, OemToAnsi(STR0062)) //"Origem" //-- 05
				aAdd(aTitCampos, OemToAnsi(STR0111)) //"Moeda" //-- 06
				If (cAliasSC7)->(FieldPos('C7_PROVENT')) > 0 //-- Soh adiciona o 7o elemento se o campo existir na base de dados
					aAdd(aTitCampos, AllTrim(RetTitle('C7_PROVENT'))) //"Moeda" //-- 07
				EndIf

				cLine := '{' //-- >>Inicio da String
				
				cLine += 'If(aF4For[oListBox:nAt, 01], oOk, oNo)' //-- 01
				cLine += ', aF4For[oListBox:nAT, 02]' //-- 02
				cLine += ', aF4For[oListBox:nAT, 03]' //-- 03
				cLine += ', aF4For[oListBox:nAT, 04]' //-- 04
				cLine += ', aF4For[oListBox:nAT, 05]' //-- 05
				cLine += ', aF4For[oListBox:nAT, 06]' //-- 06
				If (cAliasSC7)->(FieldPos('C7_PROVENT')) > 0 //-- Soh adiciona o 7o elemento se o campo existir na base de dados
					cLine += ', aF4For[oListBox:nAT, 07]' //-- 07
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada para definir os Titulos das Colunas adicionadas via ponto de entrada MA103F4I ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
				If lMA103F4H
					If ValType(aUsTitu:=ExecBlock('MA103F4H', .F., .F. )) == 'A'
						For nLoop := 1 To Len( aUsTitu )
							aAdd(aTitCampos, aUsTitu[nLoop])
							cLine += ', aF4For[oListBox:nAT, ' + AllTrim( Str( nLoop + If((cAliasSC7)->(FieldPos('C7_PROVENT'))>0, 7, 6) ) ) + ']'
						Next nLoop
					EndIf
				EndIf
      */
				cLine += ' }' //-- <<Final da String

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta dinamicamente o bline do CodeBlock                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				bLine := &( "{ || " + cLine + " }" )


				DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi(STR0024+" - <F5> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra"

				oListBox := TWBrowse():New( 27,4,243,80,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
				oListBox:SetArray(aF4For)
				oListBox:bLDblClick := { || aF4For[oListBox:nAt,1] := !aF4For[oListBox:nAt,1] }
				oListBox:bLine := bLine

//				@ 15  ,4   SAY OemToAnsi(STR0028) Of oDlg PIXEL SIZE 47 ,9 //"Fornecedor"
//				@ 14  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oDlg PIXEL SIZE 120,9


				ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)


				If ( nOpc == 1 )  

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta Array somente com os pedidos selecionados para validacao da moedados pedidos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				    For nI := 1 To Len(aF4For)    
				    	If aF4For[nI][1]
				    		AAdd(aMoedaAux,aF4For[nI])
				    	EndIf
				    Next nI		
			   /*	    
				    If Len(aMoedaAux) > 0
					    For nJ := 1 To Len(aMoedaAux)
					       	If aMoedaAux[nJ][6] <> AllTrim(GetMV("MV_MOEDA" + AllTrim(Str(Max(M->F1_MOEDA,1)))))
					       		If FunName() == "MATA102N"
						   			Alert(STR0143 + STR0144 + AllTrim(RetTitle("FL_REMITO")) + ".")
						   		ElseIf	FunName() == "MATA101N"              
						   			Alert(STR0143 + STR0145)
						   		EndIf	
						   		Exit
						   	EndIf
						Next nI		
					EndIf
				 */	                           
					For nx	:= 1 to Len(aF4For)
						If aF4For[nx][1] // .and. aF4For[nx][6] == AllTrim(GetMV("MV_MOEDA" + AllTrim(Str(Max(M->F1_MOEDA,1)))))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciona Fornecedor                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dbSelectArea("SA2")
							dbSetOrder(1)
							MsSeek(xFilial()+cA100For+cLoja)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciona Pedido de Compra                               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dbSelectArea("SC7")
							//dbSetOrder(9) // ORIGINAL
							dbSetOrder(1)
							cSeek := ""
//NT							cSeek += cFilialmi+cA100For
							cSeek += cFilialmi
//NT							cSeek += aF4For[nx][2]+aF4For[nx][3]
							cSeek += aF4For[nx][3]+"0001    "
//msgalert("cFilialmi:"+cFilialmi+"cA100For:"+cA100For+" aF4For[nx][2]+aF4For[nx][3]:"+aF4For[nx][2]+aF4For[nx][3]) //03000010 01000024y01000017
							MsSeek(cSeek)
							If lZeraCols
								aCols		:= {}
								lZeraCols	:= .F.
								MaFisClear()
							EndIf
							If SF1->(FieldPos("F1_PROVENT")) > 0 .And. SC7->(FieldPos("C7_PROVENT")) > 0 
								M->F1_PROVENT:= Iif(Len(aPrvEnt) > 1," ", SC7->C7_PROVENT)
							EndIf
							dbSelectArea("SC7")							
							//dbSetOrder(14) //ORIGINAL
							dbSetOrder(1)
//							alert(cSeek+"-SC7:"+SC7->C7_FILIAL+C7_NUM)
//msgalert("SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM"+SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM) //" "
							//While ( !Eof() .And. SC7->C7_FILENT+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM==; //ORIGINAL
							//While ( !Eof() .And. SC7->C7_FILIAL+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM==;
							While ( !Eof() .And. SC7->C7_FILIAL+C7_NUM+"0001    "==;
									cSeek )
//alert(cSeek+"-SC7:"+SC7->C7_FILIAL+C7_NUM)
								#IFNDEF TOP
	
									If lFiltraQry
										cFiltraQry := ""
										cPet := LocxPEt(43)
										cFiltraQry += ExecTemplate(cPet,.F.,.F.)
										cPe	:= LocxPE(43)
										cFiltraQry += Iif(!Empty(cPet)," AND ","")+Execblock(cPe,.F.,.F.)
									Else
										cFiltraQry := "AlwaysTrue()"		
									Endif
		
								#ELSE
									cFiltraQry := "AlwaysTrue()"	
								#ENDIF
								If &(cFiltraQry)
									nSldPed := SC7->C7_QUJE-SC7->C7_QTDACLA //ORIGINAL
									If (nSldPed > 0.00) //.And. Empty(SC7->C7_RESIDUO) )
										U_LxA2103SC7ToCols(SC7->(RecNo()),,nSlDPed,cItem)
										cItem := Soma1(cItem)
									EndIf
								Endif

								dbSelectArea("SC7")
								dbSkip()
							EndDo
						EndIf
					Next
					If lUsaFiscal
						Eval(bListRefresh)
						Eval(bDoRefresh)
					EndIf
				EndIf
			Else
				Help(" ",1,"A103F4")
			EndIf
		Else
			Help('   ',1,'A103TIPON')
		EndIf
	Else
		Help('   ',1,'A103CAB')
	EndIf

Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integrida dos dados de Entrada                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	dbSelectArea(cAliasSC7)
	dbCloseArea()
	dbSelectArea("SC7")
Endif
/*
SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
*/
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Atualiza o browse de quantidade de produtos.³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
//oGetDados:oBrowse:Refresh()

AtuLoadQt(.T.)

RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aArea)
Return(.T.)
                                                        



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103SC7ToaCols³ Autor ³ Edson Maricate    ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Carrega os dados do Pedido no item especificado.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Void A103SC7ToaCols(ExpN1,ExpC1)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 : Numero do registro do SC7                           ³±±
±±³          ³ExpN2 : Item da NF                                          ³±±
±±³          ³ExpN3 : Saldo do Pedido                                     ³±±
±±³          ³ExpC4 : Item a ser carregado no aCols ( D1_ITEM )           ³±±
±±³          ³ExpL5 : Indica se os dados da Pre-Nota devem ser preservados³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LxA2103SC7ToCols(nRecSC7,nItem,nSalPed,cItem,lPreNota,aRateio)

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local aRefSC7   := MaFisSXRef("SC7")
Local nX        := 0
Local nCntFor	:= 0
Local lRateioPC := SuperGetMv("MV_NFEDAPC")
Local nValItem	:= 0
Local cTipConv := GetNewPar("MV_ALTTXNF",'1')
Local nTaxaNf	:= 0   
Local nTaxaPed	:= 0
Private lPreNota := .F.
Private aRateio  := {0,0,0}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final("Atualizar SIGACUS.PRW !!!")
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final("Atualizar SIGACUSB.PRX !!!")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia do item                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nItem == Nil .Or. nItem > Len(aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem de uma linha em branco no aCols.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCols,Array(Len(aHeader)+1))
	For nX := 1 to Len(aHeader)
		If Trim(aHeader[nX][2]) == "D2_ITEM"
			aCols[Len(aCols)][nX] 	:= IIF(cItem<>Nil,cItem,StrZero(1,Len(SD1->D2_ITEM)))
		ElseIf ( aHeader[nX][10] <> "V") .Or. Trim(aHeader[nX][2]) == "D2_ITEMMED"
			aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2],.T.)
		EndIf
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
	Next nX
	nItem := Len(aCols)
EndIf

oGetDados:lNewLine:=.F.
dbSelectArea("SC7")
MsGoto(nRecSC7)

dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+SC7->C7_PRODUTO)

dbSelectArea("SF4")
dbSetOrder(1)
MsSeek(xFilial()+SC7->C7_TES)

If SF1->(FieldPos("F1_PROVENT")) > 0.And. SC7->(FieldPos("C7_PROVENT")) > 0
	M->F1_PROVENT:= SC7->C7_PROVENT
EndIf
If SC7->(!Eof())
	cCondicao := SC7->C7_COND
	If MaFisFound()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia a Carga do item nas funcoes MATXFIS  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaFisIniLoad(nItem)
		nTaxaNF		:= Iif(MaFisRet(,'NF_TXMOEDA')==0,Recmoeda(dDatabase,M->F1_MOEDA),MaFisRet(,'NF_TXMOEDA'))
		nTaxaPed	:= Iif(cTipConv=='1',Iif(SC7->C7_TXMOEDA=0,RecMoeda(SC7->C7_EMISSAO,SC7->C7_MOEDA),SC7->C7_TXMOEDA),RecMoeda(dDatabase,SC7->C7_MOEDA))
		nValItem:= xMoeda(LxA103CReaj(SC7->C7_REAJUST,lReajuste),SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3('D2_PRCVEN')[2],nTaxaPed,nTaxaNF)
		If M->F2_MOEDA==1
//13-07-2011			nValItem:= ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+SC7->C7_LOCAL, "B2_CM1"), 2)
			nValItem:= ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO, "B2_CM1"), 2)
		Else
//13-07-2011			nValItem:= ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+SC7->C7_LOCAL, "B2_CM2"), 2)
			nValItem:= ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO, "B2_CM2"), 2)
		endif
		For nX := 1 To Len(aRefSc7)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega os valores direto do SC7.           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Do Case
			Case aRefSC7[nX][2] == "IT_QUANT"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nSalPed,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_PRCUNI"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nValItem,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_VALMERC"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],(nSalPed*nValItem,TamSX3('D2_TOTAL')[2]),nItem)
				Endif
			Case aRefSc7[nX][2] == "IT_DESCONTO"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_VLDESC,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF) ,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_VALEMB"
				MaFisLoad(aRefSc7[nX][2],xMoeda( SC7->C7_VALEMB,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF),nItem)
			Case aRefSc7[nX][2] == "IT_VALIPI"
				MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_VALIPI,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF),nItem)
			Case aRefSc7[nX][2] == "IT_VALICM"
				MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_VALICM,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF),nItem)
			Case aRefSc7[nX][2] == "IT_BASEICM"
				MaFisLoad(aRefSc7[nX][2],xMoeda( SC7->C7_BASEICM,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF),nItem)
			Case aRefSc7[nX][2] == "IT_BASEIPI"
				MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_BASEIPI,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF),nItem)
			Case aRefSc7[nX][2] == "IT_SEGURO" 
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_SEGURO,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF),nItem)
				Else
					aRateio[1] +=xMoeda(SC7->C7_SEGURO,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF )   
				EndIf
			Case aRefSc7[nX][2] == "IT_DESPESA" 
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_DESPESA,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF),nItem)
				Else
					aRateio[2] +=xMoeda(SC7->C7_DESPESA,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF )   
				EndIf
			Case aRefSc7[nX][2] == "IT_FRETE" 
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda( SC7->C7_VALFRE,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF),nItem)
				Else
					aRateio[3] +=xMoeda( SC7->C7_VALFRE,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,,nTaxaPed,nTaxaNF )
				EndIf
			OtherWise
				MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
			EndCase
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega o CF direto do SF4                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SC7->C7_TES)
			MaFisLoad("IT_CF",MaFisCFO(nItem,SF4->F4_CF),nItem)
		EndIf
		MaFisEndLoad(nItem)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os demais campos do Pedido                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCntFor := 1 To Len(aHeader)
		Do Case
		Case Trim(aHeader[nCntFor,2]) == "D2_COD"
			aCols[nItem,nCntFor] := SC7->C7_PRODUTO

		Case Trim(aHeader[nCntFor,2]) == "D2_UDESC"
			aCols[nItem,nCntFor] := SC7->C7_DESCRI
		/* //ORIGINAL
			If !lPreNota
				aCols[nItem,nCntFor] := NoRound(nSalPed*xMoeda( LxA103CReaj(SC7->C7_REAJUST,lReajuste),SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,Max(TamSX3('D2_PRCVEN')[2],TamSX3('D2_TOTAL')[2]),nTaxaPed,nTaxaNF),TamSX3('D2_TOTAL')[2])
			EndIf
*/
		Case Trim(aHeader[nCntFor,2]) == "D2_TES" //.And. !Empty(SC7->C7_TES)
			aCols[nItem,nCntFor] := GETNEWPAR("MV_UTESSAL", "750") //SC7->C7_TES
		Case Trim(aHeader[nCntFor,2]) == "D2_TESENT" //.And. !Empty(SC7->C7_TESENT)
			aCols[nItem,nCntFor] := GETNEWPAR("MV_UTESENT", "250") //SC7->C7_TESENT
		Case Trim(aHeader[nCntFor,2]) == "D2_LOCALIZ" //NUEVO
			IF SF2->F2_FILDEST > '29'
				aCols[nItem,nCntFor] := "GENERICO"
			ENDIF
		Case Trim(aHeader[nCntFor,2]) == "D2_LOCZDES" //NUEVO
			IF M->F2_FILDEST > '29'
				aCols[nItem,nCntFor] := "GENERICO"
			ENDIF
		Case Trim(aHeader[nCntFor,2]) == "D2_PEDIDO"
			aCols[nItem,nCntFor] := SC7->C7_NUM
		Case Trim(aHeader[nCntFor,2]) == "D2_PRCVEN"
			If M->F2_MOEDA==1
//13-07-2011				aCols[nItem,nCntFor]:= ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+SC7->C7_LOCAL, "B2_CM1"), 2)
				aCols[nItem,nCntFor]:= ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO, "B2_CM1"), 2)
			Else
//13-07-2011				aCols[nItem,nCntFor]:= ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+SC7->C7_LOCAL, "B2_CM2"), 2)
				aCols[nItem,nCntFor]:= ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO, "B2_CM2"), 2)
			endif
		Case Trim(aHeader[nCntFor,2]) == "D2_QUANT"
			If !lPreNota
				IF nSalPed > SB2->B2_QATU
//					aCols[nItem,nCntFor] := SB2->B2_QATU
					IF POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO, "B2_QATU") = 0
						IF POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+'02', "B2_QATU") = 0
							aCols[nItem,nCntFor] := POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+'03', "B2_QATU")
						ENDIF
					ENDIF
					nSalPed := SB2->B2_QATU
				else
					aCols[nItem,nCntFor] := nSalPed
				Endif
				IF nSalPed <= 0
					ACOLS[nItem,Len(aHeader)+1]:=.T.
				ENDIF
			EndIf
		Case Trim(aHeader[nCntFor,2]) == "D2_TOTAL"
			If M->F2_MOEDA==1
//13-07-2011				aCols[nItem,nCntFor]:= (nSalPed*ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+SC7->C7_LOCAL, "B2_CM1"), 2))
//				aCols[nItem,nCntFor]:= (nSalPed*ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO, "B2_CM1"), 2))
				aCols[nItem,nCntFor]:= (nSalPed*ROUND(SB2->B2_CM1, 2))
			Else
//13-07-2011				aCols[nItem,nCntFor]:= (nSalPed*ROUND(POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+SC7->C7_LOCAL, "B2_CM2"), 2))
				aCols[nItem,nCntFor]:= (nSalPed*ROUND(SB2->B2_CM2, 2))
			endif
		Case Trim(aHeader[nCntFor,2]) == "D2_UDESPRO"
			aCols[nItem,nCntFor] := SB1->B1_DESC
		Case Trim(aHeader[nCntFor,2]) == "D2_UPARNUM"
			aCols[nItem,nCntFor] := SB1->B1_UFRU
/* //ORIGINAL
			If !lPreNota
				aCols[nItem,nCntFor] := xMoeda(LxA103CReaj(SC7->C7_REAJUST,lReajuste),SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_PRCVEN")[2],nTaxaPed,nTaxaNF)    
			EndIf
*/
		Case Trim(aHeader[nCntFor,2]) == "D2_ITEMPC"
			aCols[nItem,nCntFor] := SC7->C7_ITEM
		Case Trim(aHeader[nCntFor,2]) == "D2_LOCAL"
//13-07-2011
			If !lPreNota
				IF POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO, "B2_QATU") = 0
					IF POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+'02', "B2_QATU") = 0
						aCols[nItem,nCntFor] := POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+'03', "B2_LOCAL")
					ELSE
						aCols[nItem,nCntFor] := POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO+'02', "B2_LOCAL")
					ENDIF
				ELSE
					aCols[nItem,nCntFor] := POSICIONE("SB2", 1, xFilial()+SC7->C7_PRODUTO, "B2_LOCAL")
				END IF
				IF nSalPed >= SB2->B2_QATU
					aCols[nItem,nCntFor] := SB2->B2_LOCAL
				else
					aCols[nItem,nCntFor] := SC7->C7_LOCAL
				endif
			end if
		Case Trim(aHeader[nCntFor,2]) == "D2_LOCDEST"
			aCols[nItem,nCntFor] := "01"
		Case Trim(aHeader[nCntFor,2]) == "D2_CC"
			aCols[nItem,nCntFor] := SC7->C7_CC
		Case Trim(aHeader[nCntFor,2]) == "D2_ITEMCTA"			// Item Contabil
			aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_ITEMCTA), SB1->B1_ITEMCC, SC7->C7_ITEMCTA )
		Case Trim(aHeader[nCntFor,2]) == "D2_CONTA"				// Conta Contabil
			aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_CONTA), SB1->B1_CONTA, SC7->C7_CONTA )
		Case Trim(aHeader[nCntFor,2]) == "D2_CLVL"				// Classe de Valor
			aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_CLVL), SB1->B1_CLVL, SC7->C7_CLVL )
		Case Trim(aHeader[nCntFor,2]) == "D2_UM"
			aCols[nItem,nCntFor] := SC7->C7_UM
		Case Trim(aHeader[nCntFor,2]) == "D2_SEGUM"
			aCols[nItem,nCntFor] := SC7->C7_SEGUM
		Case Trim(aHeader[nCntFor,2]) == "D2_QTSEGUM"
			If !lPreNota
				aCols[nItem,nCntFor] := SC7->C7_QTSEGUM
			EndIf
		Case Trim(aHeader[nCntFor,2]) == "D2_DESC"
			If !lPreNota
				aCols[nItem,nCntFor] := SC7->C7_DESC
			EndIf
		Case Trim(aHeader[nCntFor,2]) == "D2_VALDESC"
			If !lPreNota
				aCols[nItem,nCntFor] :=xMoeda(SC7->C7_VLDESC,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_VALDESC")[2],nTaxaPed,nTaxaNF)  
			EndIf
		Case Trim(aHeader[nCntFor,2]) == "D2_CODGRP" 	
			aCols[nItem,nCntFor] := SB1->B1_GRUPO
		Case Trim(aHeader[nCntFor,2]) == "D2_CODITE" 	
			aCols[nItem,nCntFor] := SB1->B1_CODITE
		Case Trim(aHeader[nCntFor,2]) == "D2_BASIMP1"
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_BASIMP1,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_BASIMP1")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_BASIMP2"
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_BASIMP2,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_BASIMP2")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_BASIMP3"
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_BASIMP3,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_BASIMP3")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_BASIMP4"    
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_BASIMP4,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_BASIMP4")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_BASIMP5"
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_BASIMP5,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_BASIMP5")[2],nTaxaPed,nTaxaNF)  

		Case Trim(aHeader[nCntFor,2]) == "D2_VALIMP1"
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_VALIMP1,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_VALIMP1")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_VALIMP2"
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_VALIMP2,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_VALIMP2")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_VALIMP3"
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_VALIMP3,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_VALIMP3")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_VALIMP4"    
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_VALIMP4,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_VALIMP4")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_VALIMP5"
			aCols[nItem,nCntFor] :=xMoeda(SC7->C7_VALIMP5,SC7->C7_MOEDA,M->F1_MOEDA,dDatabase,TamSX3("D2_VALIMP5")[2],nTaxaPed,nTaxaNF)  
		Case Trim(aHeader[nCntFor,2]) == "D2_UPEDIDO"
			aCols[nItem,nCntFor] := SC7->C7_NUM
		Case Trim(aHeader[nCntFor,2]) == "D2_UITEMPV"
			aCols[nItem,nCntFor] := SC7->C7_ITEM
		Case Trim(aHeader[nCntFor,2]) == "D2_UITEMPV"
			aCols[nItem,nCntFor] := SC7->C7_ITEM
		EndCase

	Next nCntFor	

	// 1 - utilização a associação automática com o PMS
	// 2 - não utiliza a associação automática com o PMS
	
	// default: não utilizar a associação automática
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizar os arrays do Fiscal (Matxfis)                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaColsToFis(aHeader,aCols,nItem,"MT100",.T.)
Eval(bDoRefresh) //Atualiza o folder financeiro.
Eval(bListRefresh)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Produto possui TE Padrao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If MaFisFound()
	Do Case
	Case Empty(SC7->C7_TES) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_TE"))
		MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),nItem)
		MaFisToCols(aHeader,aCols,,"MT100")	
	Case !Empty(SC7->C7_TES)
		MaFisAlt("IT_TES",SC7->C7_TES,nItem)
		MaFisToCols(aHeader,aCols,,"MT100")	
	EndCase	
EndIf
*/
RestArea(aAreaSB1)
RestArea(aAreaSF4)
RestArea(aAreaSC7)
RestArea(aArea)
Return .T.
