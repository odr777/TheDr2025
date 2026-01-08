#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»Í»±±
±±ºFun‡„o    ³ POCOYO  º Autor ³ Erick Etcheverry    º Data ³  28/08/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ÍÍ±±
±±ºDescri‡„o ³Purcharse Order convertir                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹Í¹±±
±±ºUso       ³ TdeP                                       	            	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function POCOYO()
    Local aArea    := GetArea()
    Local cNum := SC7->C7_NUM
    
    If MsgYesNo( 'Esta seguro de realizar la conversion', 'Conversion a PO' )
        if SC7->C7_QUJE== 0 .And. SC7->C7_QTDACLA == 0 .and. SC7->C7_TIPO == 1 /// si es verde y es pedido
            dbSelectArea("SC7")
            dbSetOrder(1)
            dbSeek(xFilial("SC7")+cNum)

            if !(SC7->(Eof()))
                While !(SC7->(Eof())) .and. cNum == SC7->C7_NUM  //recorriendo todo e items

                    Reclock('SC7',.F.)
                    SC7->C7_TIPO	:= 3
                    SC7->C7_IMPORT	:= "001"
                    SC7->(MsUnlock())

                    SC7->(DbSkip())
                enddo
            endif
            
        else
            MSGINFO("Para convertir el pedido debe estar pendiente(verde)" , "AVISO:"  )
        endif
    ENDIF

    RestArea(aArea)
return
