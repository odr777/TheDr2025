#Include "PROTHEUS.Ch"
#Include "RwMake.ch"
#Include "TopConn.ch"


/*/{Protheus.doc} User Function comcobob
    LLama comprobante contable de COBROS DIVERSOS 
    @type  Function
    @author user
    @since 29/03/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function comcobob()
    
    if pergunte("FIR087",.t.)// llama para que digite el nro del cobro.
        dbSelectArea("SEL")
        DbSetOrder(8)
        if DbSeek(xFilial("SEL") + MV_PAR03 + MV_PAR01) //verifico el recibo X
            dbSelectArea("CT2") 
            dbSetOrder(15) // CT2_FILIAL+CT2_DIACTB+CT2_NODIA
            if dbSeek(SEL->EL_FILIAL+SEL->EL_DIACTB + SEL->EL_NODIA)
                M->DDATALANC := CT2->CT2_DATA
                M->CLOTE := CT2->CT2_LOTE
                M->cSubLote := CT2->CT2_SBLOTE
                M->CDOC := CT2->CT2_DOC
                U_CtbcR070()
            else
                alert("No se encontró el asiento contable.")
            ENDIF
        else
            alert("No se encontró el Recibo.")
        endif
    endif
Return 
