#INCLUDE 'RWMAKE.CH'

User Function LOCXPE15
Local nCusto1, nCusto2
            If SF1->F1_TIPODOC == "10"  .OR. SF1->F1_TIPODOC == "14"   //FATURA FOB - INVOICE OU FATURA DE FLETE
                        If SB1->(DbSeek(xFilial('SB1')+SD1->D1_COD))
                           If SB1->B1_UPERGA > 0
                              If SD1->D1_CUSTO == 0
                                 nCusto1:=Posicione('SB2',1,xFilial('SB2')+SD1->(D1_COD+D1_LOCAL),'B2_CM1')
                                 nCusto2:=SB2->B2_CM2
                              else
                                 nCusto1:=SD1->D1_CUSTO
                                 nCusto2:=SD1->D1_CUSTO2
                              End
                              RecLock('SD1', .F.)
                              SD1->D1_UPERGA   := SB1->B1_UPERGA //Porcentage GA
                              SD1->D1_UCUSOR1 := SD1->D1_CUSTO  //Custo Original Mon 1
                              SD1->D1_UCUSOR2 := SD1->D1_CUSTO2 // Custo Original Mon 2
                              SD1->D1_CUSTO    := (nCusto1*SB1->B1_UPERGA)/100  //Novo Custo Item - Moeda 1   
                              SD1->D1_CUSTO2   := (nCusto2*SB1->B1_UPERGA)/100 //Novo Custo Item - Moeda 2   
                              SD1->(MsUnlock())
                           END
                        END   
            END

RETURN            
