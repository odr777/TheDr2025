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

User Function ALTDATAL()

    Local dDataLanc     := paramixb[1]
    Local cRotina       := paramixb[2]
    Local cAreaFecha    

    if cRotina == "MATA101N" 
        cAreaFecha := GetArea()
        if empty(CT5->CT5_LANPAD)
            if (CT2->CT2_LP $ "655|656") 
                dDataLanc :=  SF1->F1_DTDIGIT   
            endif
        elseif (CT5->CT5_LANPAD $ "655|656")
            dDataLanc := SF1->F1_DTDIGIT
        Endif
        RestArea(cAreaFecha)
    ENDIF

    if cRotina $ "MATA467N|MATA486"
        cAreaFecha := GetArea() 
        if !empty(CT5->CT5_LANPAD)
            if (CT5->CT5_LANPAD == "630") 
                dDataLanc := SF2->F2_DTDIGIT   
            endif
        endif

        if !empty(CT2->CT2_LP)
            if (CT2->CT2_LP == "630") 
                dDataLanc := SF2->F2_DTDIGIT   
            endif
        endif

        if !empty(CTK->CTK_LP)
            if (CTK->CTK_LP == "630") 
                dDataLanc := SF2->F2_DTDIGIT   
            endif
        Endif
        RestArea(cAreaFecha)
    ENDIF
    
    if cRotina == "FINA088" 
        cAreaFecha := GetArea()
        if empty(CT5->CT5_LANPAD)
            if (CT2->CT2_LP == "576") 
                SEL->(dbGoTo(VAL(CV3->CV3_RECORIG))) 
                dDataLanc := SEL->EL_DTDIGIT    
            endif
        elseif (CT5->CT5_LANPAD == "576")
            SEL->(dbGoTo(VAL(CV3->CV3_RECORIG))) 
            dDataLanc := SEL->EL_DTDIGIT 
        Endif
        RestArea(cAreaFecha)
    ENDIF

    if cRotina == "FINA086" 
        cAreaFecha := GetArea()
        if !empty(CT5->CT5_LANPAD)
            if (CT5->CT5_LANPAD == "571")
                SEK->(dbGoTo(VAL(CV3->CV3_RECORIG))) 
                dDataLanc := SEK->EK_DTDIGIT  
            endif
        endif

        if !empty(CT2->CT2_LP)
            if (CT2->CT2_LP == "571") 
                SEK->(dbGoTo(VAL(CV3->CV3_RECORIG))) 
                dDataLanc := SEK->EK_DTDIGIT  
            endif
        endif

        if !empty(CTK->CTK_LP)
            if (CTK->CTK_LP == "571") 
                SEK->(dbGoTo(VAL(CV3->CV3_RECORIG))) 
                dDataLanc := SEK->EK_DTDIGIT 
            endif
        Endif
        RestArea(cAreaFecha)
    ENDIF

Return dDataLanc
