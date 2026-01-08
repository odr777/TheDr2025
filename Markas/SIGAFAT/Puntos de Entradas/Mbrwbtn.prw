#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MbrwBtn  ºAutor  ³ Jorge Saavedra  º Data ³  18/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado ao pressionar qualquer botão    º±±
±±º          ³ no MBrowse                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIMA                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function Mbrwbtn()
	Local aArea := GetArea()
Local lRet := .t.


If FunName() == "MATA410"
   If PARAMIXB[3] == 9    //Selecionado Prepara Documento de Salida
     // PUBLIC cMarca:=" "
      //PUBLIC lInverte    := .F.
   End
   
  /* If PARAMIXB[3] == 12    //Selecionado SERIAL                                  
      If ! ( (Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)) ;		
            .OR. (!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)) )
            //Pedido não está EM ABERTO ou LIBERADO
         Aviso("Pedido de Ventas",'Solamente Pedidos de Ventas ABIERTOS pueden tener Asignacion de SERIES.',{"Ok"},,"Atencion")
		 lRet := .f.  
      End
   End

   If PARAMIXB[3] == 17  .OR. PARAMIXB[3] == 9   //Selecionado GENERAR REMITO O Selecionado Prepara Documento de Salida                            
	
		//Verificando se foi informado Numero Serial para os Itens do PV
		dbSelectArea("SC9")
		dbSetOrder(1)
		dbGotop()
		If dbSeek(xFilial("SC9")+SC5->C5_NUM)
			While SC9->(!EOF()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
			      If Posicione('SB1',1,xFilial('SB1')+SC9->C9_PRODUTO,'B1_USERIE') == 'S'   //Produto con control de Numero Serial
			         If Empty(SC9->C9_NUMSERI) .OR. Empty(SC9->C9_ULOCALI)
				         Aviso("Pedido de Ventas",'Hay items que no fueran asignadas sus SERIES.',{"Ok"},,"Atencion")
						 lRet := .f.   
						 Exit
	                 End
			      End 
			      dbSelectArea("SC9")
			      SC9->(dbSkip())
			End
	    Else
	         Aviso("Pedido de Ventas",'Pedidos de Ventas ABIERTOS. No es posible GENERAR REMITOS.',{"Ok"},,"Atencion")
			 lRet := .f.  
		End
	eND
*/      
    If PARAMIXB[3] == 4    //Selecionado Modificar                 
      //Verificar se PV esta relacionado a um Orçamento - Se sim, não poderá ser modificado.
      _cQuery:="SELECT CK_NUM  FROM " + RetSqlName("SCK")
      _cQuery+=" WHERE CK_NUMPV = '" + SC5->C5_NUM + "' AND D_E_L_E_T_ <> '*'"      
      _cQuery+=" AND CK_FILIAL = '"+SC5->C5_FILIAL+"' " // NTP 16/01/18 - Aumentando filial para no bloquear a otras

      If Select('TRB') > 0
         TRB->(DbCloseArea())
      End
      TCQUERY _cQuery NEW ALIAS 'TRB'
      
      If TRB->(!EOF()) .AND. TRB->(!BOF())
         Aviso("Pedido de Ventas",'Pedido de Ventas no puede ser cambiado. Hacer los cambios en la pantalla de Presupuestos. ' + ;
               CHR(13)+CHR(10)+'Presupuesto no. ' + TRB->CK_NUM,{"Ok"},,"Atencion")
		 lRet := .f.
      End  
      TRB->(DbCloseArea())
   End   
 
End 

If FunName() == "MATA410"
	//PUBLIC cMarca      := "  "
   	//PUBLIC lInverte    := .F.
End 

RestArea(aArea)
return lRet