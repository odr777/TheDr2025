

#Include "Protheus.ch"


/*/{Protheus.doc} 
    Ponto de entrada para editar los botones 
    En este caso utilizado para ocultar el botón Anular cuando el usuario no es administrador.
    @type  User Function
    @author Nahim Terrazas
    @since 19/10/2020
    @version version 1.1
    /*/
    


User Function FA088BTN()

Local aTeste := paramixb


    If !(FWIsAdmin( __cUserID ) ) .and. aTeste[3][1] == "Anular" // verifica si el usuario no es administrador
        // MsgStop(' O usuário ' + __cUserID + ' não pertence ao grupo de administradores!')
        // Return
        // aTeste[3] := aTeste[4]
        // aTeste[4] := aTeste[5]
        // ASize(aTeste,Len(aTeste)-1)                          // Ajusta Array
        // aTeste[3][1] := "-"
        aTeste[3][2] := "ALERT('Acción no disponible para el usuario.')"

    Endif
    // ADEL(aTeste,3) // deletando el tercer elemento de la lista.

    // aAdd(aTeste,{'Texto do Item','Nova_funcao( )',0,5 })

Return aTeste
