#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  LIBBOLT  ºAutor  ³Omar Delgadillo ºFecha ³  10/01/2022       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada para modificar valores del informe         º±±
±±º Personalizar nit y razon social en facturas de compra.                º±±
±±º Diferenciar Excento y Tasa Cero hasta que resuelvan vía ticket        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function libbolt()
    // Local cTesCer	:= GetNewPar("MV_UTLIBTC", "")
    cTipo   := paramixb[1]

    // PARA LIBRO DE COMPRAS 
    IF cTipo == "C"
        RecLock("LCV",.f.) 
        
        // TRATAMIENTO RAZON SOCIAL
        IF !EMPTY(ALLTRIM(SF1->F1_UNOMBRE))
            LCV->RAZSOC := ALLTRIM(SF1->F1_UNOMBRE)
        ENDIF

        // TRATAMIENTO NIT
        IF !EMPTY(ALLTRIM(SF1->F1_UNIT))
            LCV->NIT := ALLTRIM(SF1->F1_UNIT)
        ENDIF

        LCV->(MsUnlock())
    ENDIF

    // PARA LIBRO DE VENTAS 
    IF cTipo == "V"
        RecLock("LCV",.f.) 

        IF !EMPTY(ALLTRIM(SF2->F2_UNOMCLI))
            LCV->RAZSOC := ALLTRIM(SF2->F2_UNOMCLI)
        ENDIF

        IF !EMPTY(ALLTRIM(SF2->F2_UNITCLI))
            LCV->NIT := ALLTRIM(SF2->F2_UNITCLI)
        ENDIF

        IF !EMPTY(ALLTRIM(SF2->F2_XCLDOCI))
            // LCV->
        ENDIF
        
        IF !EMPTY(ALLTRIM(SF2->F2_SERIE))
            if SubStr( LCV->CODCTR, 1, 3) <> ALLTRIM(SF2->F2_SERIE)
                 LCV->CODCTR := ALLTRIM(SF2->F2_SERIE) //+ "-" +  LCV->CODCTR
            Endif
            
            //if SubStr(LCV->NUMAUT, 1, 3) <> ALLTRIM(SF2->F2_SERIE)
            //    LCV->NUMAUT := ALLTRIM(SF2->F2_SERIE) + "-" + LCV->NUMAUT
            //Endif
            //LCV->NFISCAL := ALLTRIM(SF2->F2_SERIE) + "-" + ALLTRIM(STR(VAL(LCV->NFISCAL)))
            //LCV->NFORI := ALLTRIM(SF2->F2_SERIE)

        ENDIF

        LCV->(MsUnlock())
    ENDIF
RETURN
