


/*/{Protheus.doc} User Function ASIORDPG
    Asiento contable que verifica si se está comprando dólares al banco. 
    (utiliza la tasa de cambio del cliente.) 
    @type  Function
    @author user
    @since 28/01/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ASIORDPG()
    nRetorno := 0
    IF SEK->EK_TIPODOC$"CP" .AND. AllTrim(SEK->EK_TIPO)$"EF|TF" 
        if SEK->EK_TXMOE02 <> RecMoeda(SEK->EK_EMISSAO,2) .and. SEK->EK_MOEDA == "1" // Pago en Bolivianos - Caso se está comprando dólar del banco más caro
            // ntaxaNormal := RecMoeda(SEK->EK_EMISSAO,2)
            nValDolarOriG  :=  SEK->EK_VALOR / SEK->EK_TXMOE02
            // n :=  SEK->EK_VALOR  /ntaxaNormal
            nRetorno := ROUND(nValDolarOriG * RecMoeda(SEK->EK_EMISSAO,2),2)
        Else
            nRetorno := IIF(SEK->EK_TIPODOC$"CP" .AND. AllTrim(SEK->EK_TIPO)$"EF|TF",SEK->EK_VLMOED1,0 )
        ENDIF
    ENDIF
Return nRetorno
