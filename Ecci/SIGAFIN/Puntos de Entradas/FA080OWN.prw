


/*/{Protheus.doc} User Function FA080OWN
    Punto de entrada para que el usuario realice el movimiento bancario mismo que el usuario
    de Cancelar llamado: 11777954.
    @type  Function
    @author Nahim Terrazas
    @since 12/07/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @see (links_or_references)
    /*/
User Function FA080OWN()
    if nOpc1 <> 1 
        nOpc1 := 1
    endif
Return .T.
