#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410TOK  ºAutor  ³Nain Terrazas     ºFecha ³  14/11/2022   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Que permite realizar validaciones por TODO el         º±±
±±º          ³ Pedido de Venta                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil León: Validar TES y C5_DOCGER para Venta Futura  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function MT410TOK()
Local lRet		:= .T.
Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" 	})
Local nl
Local nk

/*
  For nl := 1 To Len(aHeader)
      If aHeader[nl, 2] == "C6_PRODUTO"
      	 nPosProd := nl
      	 Exit
      EndIf
  Next
*/

  For nl := 1 To Len(aCols)
    
      //cProdCom := GetAdvFVal("SB1","B1_UCOMPLE",xFilial("SB1")+aCols[nl,nPosProd],1,"")
      //lTesOK:= .T. 
      cTESPed  := GDFieldGet("C6_TES"    ,nl,.F.,aHeader,aCols)

      IF M->C5_DOCGER == '3' .AND. cTESPed != '800' .and. !GdDeleted(nl)
        Aviso("TES No valida",'TES No valida para este Tipo de Documento a Generar. Producto: '+ GDFieldGet("C6_PRODUTO",nl,.F.,aHeader,aCols), {"Ok"}, , "Atencion")
        lRet		:= .F.
      ELSEIF M->C5_DOCGER != '3' .AND. cTESPed == '800' .and.!GdDeleted(nl)
        Aviso("TES No valida",'TES No valida para este Tipo de Documento a Generar. Producto: '+ GDFieldGet("C6_PRODUTO",nl,.F.,aHeader,aCols), {"Ok"}, , "Atencion")
        lRet		:= .F.
      ENDIF
  Next
return lRet

/*
User Function MT410TOK()
Local lRet, aSB1, aDA1, nPrecio 
Local nL, nCol, nColLoc, nColQtd, lFalta
                
  aSB1 := SB1->(GetArea())
  aDA1 := DA1->(GetArea())
              
  // Identifica a coluna do codigo do produto
  nCol    := 0            
  nColLoc := 0  
  nColQtd := 0
  For nl := 1 To Len(aHeader)
      If aHeader[nl, 2] == "C6_PRODUTO"
      	 nCol := nl
      EndIf
      
      If trim(aHeader[nl, 2]) == "C6_LOCAL"
      	 nColLoc := nl
      EndIf      
      
      If trim(aHeader[nl, 2]) == "C6_PRCVEN"
      	 nColQtd := nl
      EndIf      
  Next
  
  MsgStop( "Periodo ya Ingresado")          
      
  lFalta := .F.
  For nL := 1 To Len(aCols)
                   
      nPrecio := 0           
      dbSelectArea("DA1")
      dbSetOrder(1)
      If ( MsSeek(xFilial() + "007"+ aCols[nL, nCol],.F.) )
   	     dbSelectArea("DA1")
	     dbSetOrder(1)
	     If MsSeek(xFilial() +"007"+ aCols[nL, nCol], .F.)
		    nPrecio :=  DA1->DA1_PRCVEN //(SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QACLASS - SB2->B2_QEMP)
 	     EndIf
      EndIf	
      
      If aCols[nl, nColQtd] <= nPrecio
         lFalta := .T.
         lRet   := .F.
      EndIf      
  Next
                
  If lFalta
     If MsgNoYes("¡Precio Inferio al Costo!" + Chr(13) + Chr(13) + "Desea continuar ?", "¡Precio Invalido!")
        lRet := .T.
     EndIf
  EndIf
  
Return(lRet)
*/
