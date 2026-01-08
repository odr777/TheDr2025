#include 'protheus.ch'
#include 'parmtype.ch'



/*/{Protheus.doc} User Function ChkBlqMo
    Verifica si el Cliente tiene deudas morosas.
    @type  Function
    @author Nahim Terrazas
    @since 22/09/2020
    @version 1.1
    @param CLIENTE, LOJA, MUESTRA ALERT
    @return Logic T - Bloqueo 
    @return Logic F - No hay Bloqueo
     U_ChkBlqMo(M->C5_CLIENTE,M->C5_LOJACLI,.T.) 
    /*/
user function CHKBLQMO(cClie,cLoja,lMostraAlert)
    Local _cArea:=GetArea()
    local lBloquea := .F.
    Local cContenido:=&(ReadVar())
    default cClie := M->C5_CLIENTE
    default cLoja := M->C5_LOJACLI
    default lMostraAlert := .T.
    cQrySE1  := GetNextAlias()
    cRisco := POSICIONE("SA1",1,xFilial("SA1")+cClie+cLoja,"A1_RISCO") // posicione
    nRisco := 0 // días Riesgo
    if cRisco <> "A"
        nRisco := GetNewPar("MV_RISCO" + alltrim(cRisco),0)
    endif 
    nTomCuenta := dDataBase - nRisco // riesgo de ventas considera día actual - los días de gracias
    BeginSql alias cQrySE1
			SELECT ISNULL(SUM(CASE WHEN E1_TIPO = 'RA ' THEN E1_SALDO*E1_TXMOEDA-1 ELSE E1_SALDO*E1_TXMOEDA END),0) E1_SALDO, ISNULL(MIN(CASE WHEN E1_TIPO = 'RA' THEN '29991231' ELSE E1_VENCTO END), '29991231') E1_VENCTO
			FROM %table:SE1% SE1
			WHERE SE1.D_E_L_E_T_ = ' '
			And E1_CLIENTE = %Exp:cClie%
			And E1_LOJA = %Exp:cLoja%
			And E1_TIPO IN('NF ','RA ', 'CH')
			And E1_SALDO > 0
            and E1_VENCTO <=  %Exp:nTomCuenta%
    EndSql
            // 01/12/20        03/12/2020 
    // cDebug := GetLastQuery()[2]
    // Aviso("CPA",cDebug,{'ok'},,,,,.t.)

// 2. CLIENTE BLOQ.POR LIMITE CREDITO
// •	Según Valor - A1_LC
// 3. CLIENTE BLOQ.POR VCTO LIM.CREDITO
// •	Según fecha - A1_VENCLC


    if (cQrySE1)->( !Eof() ) .and. cRisco <> "A" // Nahim Terrazas 22/09/2020
        // dFecVcto := StoD((cQrySE1)->E1_VENCTO)
        // GetAdvFVal("SM2","M2_MOEDA" +ALLTRIM(CVALTOCHAR(i)) ,dtos(date()))
        // nTaxaMoeda  := GetAdvFVal("SM2","M2_MOEDA" + CVALTOCHAR(SA1->A1_MOEDALC) ,dtos(date()))
        
        
        if SA1->A1_MOEDALC == 2
            nLineaCred := xmoeda(SA1->A1_LC,2,1) // convierto a bs
        else
            nLineaCred := SA1->A1_LC // convierto a bs
        endif 
        if cRisco == "E" // verifica si el saldo es mayor a la LC
            if M->C5_CONDPAG <> '001'  // condición de pago al crédito
                lBloquea := .T. //L CLIENTE TIENE DEUDAS MOROSAS"
                if lMostraAlert
                    ApMsgAlert("VENTA AL CREDITO RESTRINGIDA","VENTA AL CREDITO RESTRINGIDA")
                    return cContenido
                else
                    return "VENTA AL CREDITO RESTRINGIDA"
                endif
            else // Si es contado no hay problema.
                if lMostraAlert
                    return cContenido
                else
                    return nil
                endif
            endif
        endif  
        // nLineaCred - SA1->A1_SALDUP  < 0// verifica que el cliente tenga saldo

        if (cQrySE1)->E1_SALDO > 0 // verifica si el saldo es mayor a la LC
            lBloquea := .T. //L CLIENTE TIENE DEUDAS MOROSAS"
            if lMostraAlert
                ApMsgAlert("CLIENTE BLOQUEADO POR MORA","CLIENTE BLOQUEADO POR MORA")
                return cContenido
            else
                return "CLIENTE BLOQUEADO POR MORA"
            endif
        elseif  nLineaCred - SA1->A1_SALDUP  < 0// verifica que el cliente tenga saldo
            lBloquea := .T. //L CLIENTE TIENE DEUDAS MOROSAS"
            if lMostraAlert
                ApMsgAlert("CLIENTE BLOQ.POR LIMITE CREDITO","CLIENTE BLOQ.POR LIMITE CREDITO")
                return cContenido
            else
                return "CLIENTE BLOQUEADO POR MORA"
            endif
        elseif  (SA1->A1_VENCLC - DDATABASE  ) < 0 // verifica que la fecha de vencimiento sea menor que la fecha actual
            lBloquea := .T. //L CLIENTE TIENE DEUDAS MOROSAS"
            //        20200503          20200505
            if lMostraAlert
                ApMsgAlert("CLIENTE BLOQ.POR VCTO LIM.CREDITO","CLIENTE BLOQ.POR VCTO LIM.CREDITO")
                return cContenido
            else
                return "CLIENTE BLOQUEADO POR MORA"
            endif
        else // no tiene bloqueos
            if lMostraAlert
                return cContenido
            else
                return nil
            endif
        EndIf
    endif
    if lMostraAlert
        return cContenido
    endif
Return nil
