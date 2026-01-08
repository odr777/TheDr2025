// BIBLIOTECAS NECESSÁRIAS
#Include "TOTVS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A415LIOK  ºAutor  ³NTC        ºFecha ³  21/11/22            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Validación por línea en Presupuestos                  º±±
±±º          ³ Para Mercantil León se debe evitar que pongan la TES de	  º±±
±±º          ³ Entrega Futura 800 ni 801                                  º±±
±±º          ³  - Replica los descuentos del 1er Pedido al 2do Pedido     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil León                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// FUNÇÕES PRINCIPAIS
User Function A415LIOK()
    Local lValid    := .T.                    // CONTROLE DE VALIDAÇÃO
    Local cAliasSCK := aHeaderSCK[1][9]       // ITENS DA TABELA SCK
//    Local cAliasSCL := aHeaderSCL[1][9]       // ITENS DA TABELA SCL

//    Local aAreaSCK  := (cAliasSCK)->GetArea() // ARMAZENA A ÁREA CORRENTE DA SCK
    
//    Local aAreaSCL  := (cAliasSCL)->GetArea() // ARMAZENA A ÁREA CORRENTE DA SCL

//Alert("A415LIOK:"+((cAliasSCK)->CK_TES))
    // EXEMPLO DE VALIDAÇÃO NA TABELA SCK
    If  ((cAliasSCK)->CK_TES) $ GetNewPar("MV_UTESFUTURA","800|801")
    //If (AllTrim((cAliasSCK)->CK_PRODUTO) == "PRDT0001")
        lValid := .F.
        Help(NIL, NIL, "PE A415LIOK", NIL, "TES Incorrecta",;
            1, 0, NIL, NIL, NIL, NIL, NIL, {"Utilice otra TES"})
    EndIf

    // EXEMPLO DE VALIDAÇÃO NA TABELA SCJ
    /*
    If (CJ_TIPOCLI =="J" .Or. AllTrim(CJ_PROSPE) == "PRP002")
        lValid := .F.
        Help(NIL, NIL, "SCJ_PROSPCT_DENIED", NIL, "Prospect ou Tipo do Cliente não permitido",;
            1, 0, NIL, NIL, NIL, NIL, NIL, {"Entre em contato com o responsável de faturamento."})
    EndIf
    */
    // EXEMPLO DE VALIDAÇÃO NA TABELA SCL
    /*
    If (AllTrim((cAliasSCL)->CL_PRODUTO) == "PRDT0005")
        lValid := .F.
        Help(NIL, NIL, "SCL_PRDT_DENIED", NIL, "Produto Indisponível",;
            1, 0, NIL, NIL, NIL, NIL, NIL, {"Utilize outro produto."})
    EndIf
    */
    // RESTAURA O ESTADO ANTERIOR
    //RestArea(aAreaSCK)
    //RestArea(aAreaSCL)
Return (lValid)
