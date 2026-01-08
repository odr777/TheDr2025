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

        // Tratamiento para las DUA
        IF SF1->F1_SERIE = 'DUA'
            LCV->POLIZA     := LCV->NFISCAL
            LCV->NFISCAL    := '0' 
            LCV->VALCONT    := LCV->VALCONT - LCV->VALIMP
            LCV->SUBTOT     := LCV->VALCONT
            LCV->BASEIMP    := LCV->VALCONT
        ENDIF

        // Tratamiento para IEHD
        IF LCV->VALEHD > 0
            LCV->EXENTAS    -= LCV->VALEHD
            LCV->SUBTOT     += LCV->VALEHD
            LCV->BASEIMP    += LCV->VALEHD
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

        /*IF !EMPTY(ALLTRIM(SF2->F2_XCLDOCI))
            LCV->COMP := AllTrim(SF2->F2_XCLDOCI)
        ENDIF*/

        LCV->(MsUnlock())
    ENDIF
RETURN
