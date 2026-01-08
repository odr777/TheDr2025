#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#Include "TopConn.ch"

/*/{Protheus.doc} User Function BUSCTBCO
    Busca cuenta banco Origen
    @type  Function
    @author user
    @since 14/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function BUSCTBCO()
    Local aArea 	 := GetArea()
    // aBancAnt := getPrBan()
    // cRespBco := ""
    // GetAdvFVal("SB2","B2_QATU",xFilial("SB2") + cProducto + cLocal,1,"")
    cRespBco :=   GetAdvFVal("SA6","A6_CONTA",XFILIAL("SA6") + cBancOri,1,"")
    If type("cBancOri") <> "U"
		cBancOri := NIL
		FreeObj(cBancOri)
	Endif
    restArea(aArea)

Return cRespBco


static function getPrBan()
    Local aArea 	 := GetArea()
    aBancAnt := {}
	OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
		SELECT E1_PORTADO,E1_AGEDEP,E1_CONTA FROM %Table:SE1% SE1
		WHERE R_E_C_N_O_ = %exp:SE1->(RECNO())%
	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
    	AADD(aBancAnt,(OrdenConsul)->E1_PORTADO)      
    	AADD(aBancAnt,(OrdenConsul)->E1_AGEDEP)      
    	AADD(aBancAnt,(OrdenConsul)->E1_CONTA)      
    endif
    (OrdenConsul)->(DbCloseArea())
return aBancAnt
