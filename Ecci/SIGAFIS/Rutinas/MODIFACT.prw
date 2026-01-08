#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} User Function modifact
    editar factura de compra.
    @type  Function
    @author user
    @since 02/08/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

user function MODIFACT()
	LOCAL cFechaFis := DTOS(GETMV("MV_DATAFIS"))   //fecha de cierre fiscal
	Local cExprFilTop := "F1_EMISSAO > '" + cFechaFis + "' AND F1_ESPECIE = 'NF' "
	private aCfgNF := MontaCfgNf(10,{""},.T.)  // et  monta array a visualizar
	Private cCadastro := "Factura"
	
	Private aRotina := {{"Alterar","U_ALTERFAT()",0,4}}
	
	
	dbSelectArea("SF1")
	dbSetOrder(1)
	//SET FILTER TO E1_SALDO>0
	AADD(aRotina,{"Visualiza","LocxDlgNF(aCfgNF,2)",0,2})//et  compras LocxNF.prw function visualiza 
	MBrowse( 6 , 1 , 22 , 75 , "SF1" , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL;
	 , NIL , NIL , NIL , NIL , NIL , cExprFilTop ) 
	 
return
