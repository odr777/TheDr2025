/*/{Protheus.doc} User Function VALDA1I
    Realiza la validación para que no se incluya otro Producto.
    OM010QRY - en esta función se filtran los productos en la lista de precio.
    @type  
    @author user
    @since 17/11/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function VALDA1I()
    
// DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
    oModel  := FWModelActive()
    // FWFORMGRIDMODEL():GetLine()
    cEncontro :=  GetAdvFVal("DA1","DA1_CODPRO",xfilial("DA1") +oModel:GetValue("DA0MASTER","DA0_CODTAB")+ M->DA1_CODPRO, 1,"")     
                //GetAdvFVal("SB1", "B1_RASTRO",xFilial("SB1") +aCols[n]t[nPosCOD]              , 1,"") 

    oModelGrid := oModel:GetModel( "DA1DETAIL" ) // obtener el modelo del grid
    nTotLin := oModelGrid:Length( .F. ) // obtenes el TOTAL de lineas del grid
                                                   
    lRetorno := empty(cEncontro) .or. oModelGrid:GetLine() <> nTotLin  // si NO encontró está vacio y no está incluyendo  
    if !lRetorno
        alert("Código de producto ya incluido")
    endif
Return lRetorno
