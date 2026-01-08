#include 'protheus.ch'
#include 'TOPCONN.ch'
#include 'parmtype.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ LocxPe16 ³ Autor ³ Jorge Saavedra        ³ Fecha³ 30/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Punto de Entrada paga validar en OK rutinas LocxNF         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis  ³ LocxPe16( void )                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. o .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BASE BOLIVIA                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LOCXPE16()
Local _lRet:= .T.

//Valida que el Valor registro en Caja Chica sea igual al Valor de la Factura de Entrada
IF alltrim(FunName()) $ "MATA101N"
	
	nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'     } )
	nPosTotal  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TOTAL'     } )
	nPosDesc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } )
	
	If upper(M->F1_SERIE)=='CCH'
		nValor:=0
		For nX := 1 To LEN(aCols)
			nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc]	 
		Next nX  
		IF nValor<> nCxValor 
			Alert('El Valor de la Caja Chica NO es igual a la Factura')
			_lRet:= .F.
		END
		
		//--------------- Actualizamos el Nro de Rendicion por Caja Chica -------------------//
		If !Empty(cCxCaixa)
			IF SELECT('Rendicion') > 0           //Verifica se o alias OC esta aberto
	   			Rendicion->(DbCloseArea())       //Fecha o alias OC
			END
			
			cQuery:= "SELECT COUNT(EU_CAIXA)AS NRO FROM " + RetSqlName('SEU') 
			cQuery+= " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO='10'"
			
			TCQUERY cQuery NEW ALIAS "Rendicion"
			
			If Rendicion->(!EOF()) .AND. Rendicion->(!BOF())
			  IF !EMPTY(Rendicion->NRO)
					cCxRendic:=StrZero(Rendicion->NRO,10,0)  
			  END
			END
		End
	End
	                                                                                   
	
End

IF alltrim(FunName()) $ "MATA102N" 
	  nPosProd  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_COD'     } )
	  nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'     } )
	  nPosItem	 	:= Ascan(aHeader,{|x| Alltrim(x[2])=="D1_ITEM"})
	  For nl := 1 To Len(aCols)
      
      cProdCom := GetAdvFVal("SB1","B1_UCOMPLE",xFilial("SB1")+aCols[nl,nPosProd],1,"")
      lProdCom:= .T.  
      IF !Empty(cProdCom) .and.!GdDeleted(nl)
      	For nk := 1 To Len(aCols)
      		IF aCols[nk,nPosProd] $ cProdCom .and.!GdDeleted(nk)
      			lProdCom:= .F.
      			If !(aCols[nk,nPosTes] $'400')
      				_lRet		:= .F.
      					Alert("El Item:" + AllTrim(aCols[n][nPosItem]) +" del Producto: " + AllTrim(aCols[n][nPosProd]) + " NO tiene Asignado el Tipo de Entrada 400")
      			end
      			Exit
      		End
      	Next
      	If lProdCom
      		 _lRet		:= .F.
      		 Aviso("Validación Remito de Entrada",'El Producto: '+ aCols[nl,nPosProd] + ' NO tiene su producto Complementario: '+ cProdCom,{"Ok"},,"Atencion")
      	end
      END
  Next
End

Return _lRet

