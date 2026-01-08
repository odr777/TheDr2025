

/*/{Protheus.doc} User Function F060OK
    punto de entrada para obtener el banco anterior
    @type  Function
    @author user
    @since 15/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function F060OK()
    iTvalido := .t.
    // {cSituacao,cPort060,cAgen060,cConta060,lDesc,cCliente,cTitulo,cSituAnt,cContrato,cPortador}
    cBanDes := ParamIxb[2] // Banco Origen
    cAgeDes := ParamIxb[3] // Banco Origen
    cCtaDes := ParamIxb[4] // Banco Origen
    cNuevSit :=  ParamIxb[1] // situación nueva
    cAntSitu :=  ParamIxb[8] // situación Anterior
    nMonOrigen := GetAdvFVal("SA6","A6_MOEDA",XFILIAL("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,1,"")// moneda origen
    nMonDestino := GetAdvFVal("SA6","A6_MOEDA",XFILIAL("SA6")+cBanDes+cAgeDes+cCtaDes,1,"")// moneda destino
    if nMonOrigen <> nMonDestino
        alert("No se debe Realizar una transferencia entre Banco/Caja con diferentes monedas")
        iTvalido := .f.
    endif
    // IF(SA6->A6_COD $ GetMv("MV_CARTEIR"),SA6->A6_CONTA,IIF(SA6->A6_MOEDA == 1,'11105005','11105007'))
    if cNuevSit == cAntSitu
        if cAntSitu == '0'
            alert("Es necesario cambiar la situación para 'G'")
        endif
        if cAntSitu == 'G' .AND. cBanDes $ GetMv("MV_CARTEIR") // es G entre Carteras
            alert("Es necesario cambiar la situación para '0'")
        endif
        iTvalido := .f.
    endif
    GetAdvFVal("SA6","A6_MOEDA",XFILIAL("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,1,"")
    // IF(SA6->A6_COD $ GetMv("MV_CARTEIR"),SA6->A6_CONTA,IIF(SA6->A6_MOEDA == 1,'11105005','11105007')) ES CAJA  
    // GetAdvFVal("SA6","A6_MOEDA",XFILIAL("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,1,"")
    PUBLIC cBancOri := SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA // GetAdvFVal("SA6","A6_CONTA",XFILIAL("SE1")+aBancAnt[1]+aBancAnt[2]+aBancAnt[3],1,"")
    // cRespBco := GetAdvFVal("SA6","A6_CONTA",XFILIAL("SE1")+aBancAnt[1]+aBancAnt[2]+aBancAnt[3],1,"")
Return iTvalido
