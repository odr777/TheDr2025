

#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*/{Protheus.doc} User Function MC030GRV
    graba información en la tabla de kardex
    @type  Function
    @author user
    @since 08/06/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function MC030GRV()

Local aTrbP		:=ParamIxb[3]
Local cAliasTmp	:=ParamIxb[1]
//Custo gerencial Brasil
(cAliasTmp)->TESDESCRI	:=	aTrbP[13]
(cAliasTmp)->CFODESCRI 	:=	aTrbP[14]

//KDX->CQUANTBR 	:=	aTrbP[16]

//Custo gerencial PP                   
// (cAliasTmp)->CMEDIOG	:=aTrbP[17]
// (cAliasTmp)->CTOTALG	:=aTrbP[18]
//KDX->CQUANT	:=aTrbP[20]

Return( Nil )


