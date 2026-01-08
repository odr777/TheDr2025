
#include "protheus.ch"
#INCLUDE "FWEVENTVIEWCONSTS.CH"

// #Define ENTER Chr (10) + Chr (13)   SALTO DE LÍNEA (RETORNO DE CARRO + AVANCE DE LÍNEA)
#Define ENTER "<BR>"  // SALTO DE LÍNEA (RETORNO DE CARRO + AVANCE DE LÍNEA)


/*
Nahim Terrazas 22/07/2020

Ponto-de-Entrada: MT120GRV - Continuar ou não a inclusão, alteração ou exclusão

Ciabol - Envío de Mail al incluirse los pedidos de compra

*/

user function MT120GRV()

    Local aArea	  := GetArea()
    Local cNum    := PARAMIXB[1]
    Local lInclui := PARAMIXB[2]
    Local lAltera := PARAMIXB[3]
    Local lExclui := PARAMIXB[4]
    Local lRet    := .T.
    Local cSuc    := ""
    Local cProv   := ""
    Local cNProv  := ""
    Local cCC     := ""
    Local cCVal   := ""
    Local cObs    := ""
    Local cObsm   := ""

    if (lInclui)// inclusión.
        // enviar un evento
        cEventID := "062"

        // Seleccionar tabla de pedidos
        DBSELECTAREA("SC7")
        SC7->(DbSetOrder(1))
        SC7->(dbSeek(xFilial("SC7")+cNum))

        // Recupera valores
        // cSuc   := Posicione("SC7",1,XFilial("SC7")+cNum+"0001","C7_FILIAL")
        // cProv  := Posicione("SC7",1,XFilial("SC7")+cNum+"0001","C7_FORNECE")
        // cNProv := Posicione("SC7",1,XFilial("SC7")+cNum+"0001","C7_UNOME")
        // cCC    := Posicione("SC7",1,XFilial("SC7")+cNum+"0001","C7_CC")
        // cCVal  := Posicione("SC7",1,XFilial("SC7")+cNum+"0001","C7_CLVL")
        // cObs   := Posicione("SC7",1,XFilial("SC7")+cNum+"0001","C7_OBS")
        // cObsm  := Posicione("SC7",1,XFilial("SC7")+cNum+"0001","C7_OBSM")
        cSuc   := C7_FILIAL
        cProv  := C7_FORNECE
        cNProv := C7_UNOME
        cCC    := C7_CC
        cCVal  := C7_CLVL
        cObs   := C7_OBS
        cObsm  := C7_OBSM

        //	EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,"",ctitulo,cMesagem,.T.)
        cMessagem := " <H3>SE HA INCLUIDO EL PEDIDO DE COMPRA: " + cNum + "</H3>" + ENTER
        if (AllTrim(cSuc)<>"")
            cMessagem += " SUCURSAL        : " + cSuc + ENTER
        endif
        if (AllTrim(cProv)<>"")
            cMessagem += " PROVEEDOR       : " + cProv + " " + cNProv + ENTER
        endif
        if (AllTrim(cCC)<>"")
            cMessagem += " CENTRO DE COSTO : " + cCC + ENTER
        endif
        if (AllTrim(cCVal)<>"")
            cMessagem += " CLASE DE VALOR  : " + cCVal + ENTER
        endif
        if (AllTrim(cObs)<>"")
            cMessagem += " OBSERVACIONES 1 : " + cObs + ENTER
        endif
        if (AllTrim(cObsm)<>"")
            cMessagem += " OBSERVACIONES 2 : " + cObsm + ENTER
        endif
        cMessagem += " EN ESPERA DE APROBACION " + ENTER
        EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,""/*cCargo*/,"Nuevo pedido de compra nro: "+ cNum,cMessagem,.T.)
        U_EnviarMail("fcastillo@ciabol.com.bo","fercman@me.com", "SISTEMA TOTVS: Se creo un Pedido de Compra",nil,cMessagem)
        MSGINFO( "Mensaje enviado a los correos definidos", "INFORMACION" )
        // ALERT("enviado")
    endif

    restArea(aArea)

return lRet
