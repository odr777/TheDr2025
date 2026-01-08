#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  LIBBOLT  ºAutor  ³Omar Delgadillo ºFecha ³  10/01/2022       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada para  modificar el informe RCV (Registro   º±±
±±º          ³de compras y ventas).                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MERCANTIL LEON                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function libbolt()
    cTipo := paramixb[1]

    // PARA LIBRO DE COMPRAS 
    IF cTipo == "C"
        RecLock("LCV",.f.)

        IF !EMPTY(ALLTRIM(SF1->F1_UNOMBRE))
            LCV->RAZSOC := SF1->F1_UNOMBRE
        ENDIF

        IF !EMPTY(ALLTRIM(SF1->F1_UNIT))
            LCV->NIT := SF1->F1_UNIT
        ENDIF

        LCV->(MsUnlock())
    ENDIF

    // PARA LIBRO DE VENTAS 
    IF cTipo == "V"
        RecLock("LCV",.f.) 

        IF LCV->DESCONT > 0
            LCV->VALCONT := LCV->VALCONT - LCV->DESCONT
            LCV->SUBTOT := LCV->SUBTOT - LCV->DESCONT
            LCV->DESCONT := 0
        ENDIF

        IF !EMPTY(ALLTRIM(SF2->F2_UNOMCLI))
            LCV->RAZSOC := SF2->F2_UNOMCLI
        ENDIF

        IF !EMPTY(ALLTRIM(SF2->F2_UNITCLI))
            LCV->NIT := SF2->F2_UNITCLI            
        ENDIF
        
        LCV->(MsUnlock())
    ENDIF
RETURN
