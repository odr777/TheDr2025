
#include 'protheus.ch'


/*/{Protheus.doc} User Function CTB040GR
    Luego de guardar el item contable se asegura de modificar la tarea y adicionar el mismo
    @type  Function
    @author user
    @since 05/06/2021
    @version Nahim
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
user Function CTB040GR()
	Local _cArea:=GetArea()
    Dbselectarea("AF9")
	Dbsetorder(1)
	// Dbgotop()
    if CTD->CTD_CLASSE == "2" 
        IF Dbseek(xFilial("AF9")+CTD->CTD_XTAREF)// BUSCA AF9
            If Reclock("AF9",.F.)
                Replace AF9->AF9_ITEMCC  With CTD->CTD_ITEM
            Endif
            MSGINFO("Tarea actual con éxito (AF9)","Importante")
        ELSE
            ALERT("Tarea no actualizó centro de costo")
        ENDIF
    ENDIF
	RestArea(_cArea)

return 
