#include 'protheus.ch'
#include 'parmtype.ch'


//PUnto de entrada que se ejecuta despues de grabar el documento(SF1 y SD1)
//Sirve para actualizar los costos
//--- Jorge Saavedra

USER FUNCTION LOCXPE08
	Local lVenFut	:= FWIsInCallStack("U_GERVTAFUT")

	if funname() $ 'MATA102N' //  quitado a solicitu de Diego estatuti en despacho 19/06/2021
		IF !lVenFut
			U_IMREM()
		ENDIF
	endif

	if funname() $ 'MATA466N' //  quitado a solicitu de Diego estatuti en despacho 19/06/2021
		IF !lVenFut
			U_NCPMLCL(SF2->F2_DOC,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE)
		ENDIF
	endif

	if funname() $ "MATA462TN" .and. aCfgNf[1]==54 ///salida transferencia
		IF EMPTY(SF2->F2_UNROREC)
			RECLOCK( "SF2", .F. )
			SF2->F2_UNROREC := "NO CORRESPONDE"
			MSUNLOCK()
		ENDIF
	endif
/*                          
Local _cArea:=GetArea()
Local nRet := 0
Local cSinal:="+"

If GetNewPar("MV_UACTCOS",.T.)

	DbSelectArea("SD1")
	DbSetOrder(3)
	If (FunName() == 'MATA102N' .OR. (FUNNAME() == 'MATA101N' .AND. SF1->F1_TIPODOC == '13')) .AND. INCLUI
		DbSeek(XFILIAL('SD1')+SF1->(DTOS(F1_EMISSAO)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) )                                                                                                  
		While SD1->(!Eof()).AND. SF1->(DTOS(F1_EMISSAO)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)==SD1->(DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			DbSelectArea("SFC")
			DbSetOrder(1)
			DbSeek(xFilial("SFC")+SD1->D1_TES)
			SFB->(DbSetOrder(1))
			If (SFC->FC_IMPOSTO $ "IVA") .and. SFB->(DbSeek(xFilial("SFB")+SFC->FC_IMPOSTO)) 
			
			
				total:=Round((SD1->D1_TOTAL  - SD1->D1_VALDESC),2)
				nRet :=  XMOEDA(total, SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA )
			
				nflete:=XMOEDA(SD1->D1_VALFRE , SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA )
				nGasto:=XMOEDA(SD1->D1_DESPESA , SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA )
				nSeguro:=XMOEDA(SD1->D1_SEGURO , SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA )
			
		
					/*If "IVAI" $ upper(SFB->FB_FORMSAI)
						If SFB->FB_ALIQ == 10
							nRet -= round( nRet/11,4  )
						ElseIf SFB->FB_ALIQ ==5  
							nRet -= round( nRet/21,4   )
						EndIf	
					Else
						
					EndIf
					*/
					/* nTmpRet:= nRet
					nRet -= round( nRet * SFB->FB_ALIQ / 100 ,4  )
			
				nTmpCosto:= SD1->D1_CUSTO
				nTmpCosto2:= SD1->D1_CUSTO2
				nTmpCosto3:= SD1->D1_CUSTO3
				nTmpCosto4:= SD1->D1_CUSTO4
				nTmpCosto5:= SD1->D1_CUSTO5		  		 
		  
				nRet+=	nGasto + nSeguro	 + nflete  
				
				RecLock("SD1" , .F.)
					D1_BASIMP1:= nTmpCosto
					D1_VALIMP1:= nTmpRet - nRet
					D1_ALQIMP1 := SFB->FB_ALIQ
					D1_CUSTO  := Round( xMoeda( nRet   , 1, 1 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)  
					iF SF1->F1_MOEDA == 2
						D1_CUSTO2 := Round( xMoeda( nRet   , 1 , 2 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ,SF1->F1_TXMOEDA) ,4)
					ELSE                                                                                                          
						D1_CUSTO2 := Round( xMoeda( nRet   , 1 , 2 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)
					END
         
					iF SF1->F1_MOEDA == 3
						D1_CUSTO3 := Round( xMoeda( nRet   , 1 , 3 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ,SF1->F1_TXMOEDA) ,4)
					ELSE                                                                                                          
						D1_CUSTO3 := Round( xMoeda( nRet   , 1 , 3 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)
					END
		 
					iF SF1->F1_MOEDA == 4
						D1_CUSTO4 := Round( xMoeda( nRet   , 1 , 4 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ,SF1->F1_TXMOEDA) ,4) 
					ELSE                                                                                                          
						D1_CUSTO4 := Round( xMoeda( nRet   , 1 , 4 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4) 
					END
		  
					iF SF1->F1_MOEDA == 5
						D1_CUSTO5 := Round( xMoeda( nRet   , 1 , 5 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ,SF1->F1_TXMOEDA) ,4)
					ELSE                                                                                                          
						D1_CUSTO5 := Round( xMoeda( nRet   , 1 , 5 , SF1->F1_EMISSAO, 4 ,SF1->F1_TXMOEDA ) ,4)
					END
		 
		 
				MsUnLock()
	  //	EndIf	

	  			If Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_ESTOQUE") == 'S' 
	  				dbSelectArea("SB2")
	  				dbSetOrder(1)
	  				If !MsSeek(xFilial("SB2")+SD1->D1_COD+SD1->D1_LOCAL, .F.)
	  					//³ Se nao existir , ele cria                             ³
	  					CriaSB2(SD1->D1_COD,SD1->D1_LOCAL)
	  				Else
	  					RecLock("SB2",.F.)
	  				EndIf                    
			
	  				B2_VATU1 := round(B2_VATU1 + SD1->D1_CUSTO - nTmpCosto,4)
	  				B2_VATU2 := round(B2_VATU2 + SD1->D1_CUSTO2 - nTmpCosto2,4)
	  				B2_VATU3 := round(B2_VATU3 + SD1->D1_CUSTO3 - nTmpCosto3,4)
	  				B2_VATU4 := round(B2_VATU4 + SD1->D1_CUSTO4 - nTmpCosto4,4)
	  				B2_VATU5 := round(B2_VATU5 + SD1->D1_CUSTO5 - nTmpCosto5,4)
			
	  				B2_CM1 := round(B2_VATU1/B2_QATU,4)
	  				B2_CM2 := round(B2_VATU2/B2_QATU,4)
	  				B2_CM3 := round(B2_VATU3/B2_QATU,4)
	  				B2_CM4 :=round( B2_VATU4/B2_QATU,4)
	  				B2_CM5 := round(B2_VATU5/B2_QATU,4)
	  				MsUnLock()

	  			END
	  		End
	  	SD1->(DbSkip())
      
	 End            
	EndIf
 End
RestArea(_cArea)
      */
Return
