#INCLUDE 'RWMAKE.CH'

User Function A143GRVA()

RETURN
ALERT('A143GRVA')

If PARAMIXB[1] == 6 //"Gerar Documentos de Entrada"

   ALERT('ATUALIZANDO CUSTOS NO DOCUMENTO DE ENTRADA')

   //Processando CUSTOS de TODAS as faturas de GASTOS do process
   SB1->(DbSetOrder(1))
   SD1->(DbSetOrder(1))
   SF1->(DbSetOrder(5))
   SF1->(DBGOTOP())
   If SF1->(DbSeek(xFilial('SF1')+PARAMIXB[2]))
      While SF1->(F1_FILIAL+F1_HAWB) == xFilial('SF1')+PARAMIXB[2]
            If F1_TIPODOC == "13"  //FATURA DE GASTOS
               
               alert('FATURA GASTOS')
               DbSelectArea('SD1')
               SD1->(DBGOTOP())
               If SD1->(DbSeek(xFilial('SD1')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
                  While SD1->(D1_FILIAL+D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA) == xFilial('SD1')+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

                        If SB1->(DbSeek(xFilial('SB1')+SD1->D1_COD))
                           RecLock('SD1', .F.)
                           SD1->D1_UPERGA   := SB1->B1_UPERGA //Porcentage GA
                           SD1->D1_UCUSORI1 := SD1->D1_CUSTO  //Custo Original Mon 1
                           SD1->D1_UCUSORI2 := SD1->D1_CUSTO2 // Custo Original Mon 2
                           SD1->D1_CUSTO    := (SD1->D1_CUSTO*SB1_UPERGA)/100  //Novo Custo Item - Moeda 1   
                           SD1->D1_CUSTO2   := (SD1->D1_CUSTO2*SB1_UPERGA)/100 //Novo Custo Item - Moeda 2   
                           SD1->(MsUnlock())
                        End   
                        SD1->(DbSkip()) 

                  END
               END
            END
            SF1->(DbSkip()) 
         END
      END   
   END

ALERT(PARAMIXB[2])

Return
