#INCLUDE "Protheus.ch"
/*
+------------------+---------------------------------------------------------+
!Modulo            ! Diversos                                                !
+------------------+---------------------------------------------------------+
!Nome              ! fRMoeda                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Função para retornar a descricao e o valor da taxa da   !
!                  ! moeda informada                                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 03/01/2011                                              !
+------------------+---------------------------------------------------------+
*/
User Function fRMoeda(nMoeda)
    Local nValor  := 1
    Local aMoedas := {}
    Local aRetorno:= {}
    Local nCodMoe := 0
    Local lAchou  := .F.
    Local i       
    Local oError := ErrorBlock({|e|MsgAlert("Mensagem de Erro: " +chr(10)+ e:Description)})                 
    
    aMoedas := StrTokArr("1=Bolivianos|2=Dolares   |3=UFVs      |4=Euros     ","|")                          
    
    Begin Sequence      
        For i := 1 to len(aMoedas)
            nCodMoe  := Int(Val(Substr(Alltrim(aMoedas[i]),1,1)))
            if(nCodMoe==nMoeda)
                aadd(aRetorno,{Substr(aMoedas[i],at("=",aMoedas[i])+1,10),RecMoeda(dDataBase,StrZero(nMoeda,2))})
                lAchou := .T.
                exit
            Endif
        Next    
    
        if lAchou==.F.
            aadd(aRetorno,{"MONEDA INEXISTENTE",0.00})
        Endif
    End Sequence

    ErrorBlock(oError)
    
Return(aRetorno)

