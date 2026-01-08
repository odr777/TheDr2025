

#Include "Protheus.ch"


/*/{Protheus.doc} 
    Ponto de entrada para editar los botones 
    En este caso utilizado para ocultar el botón Anular cuando el usuario no es administrador.
    @type  User Function
    @author Nahim Terrazas
    @version version 1.1 
    /*/

User Function FA088BTN()
	Local aTeste := paramixb
	If !(Upper(CUSERNAME) $ Upper(SuperGetMv("MV_XBORCOB",.F.,CUSERNAME))) .and. aTeste[4][1] == "Borrar" // verifica si el usuario no es administrador
		aTeste[4][2] := "ALERT('Acción no disponible para el usuario.')"
	Endif
Return aTeste
 