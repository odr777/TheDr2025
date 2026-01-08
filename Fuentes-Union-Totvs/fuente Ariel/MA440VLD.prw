#Include "Protheus.ch" 
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"
#include 'parmtype.ch'




User Function MA440SC6()
    Local lRetorno := .T.
    /*Local cArqQry := ParamixbLocal 
    lRet := .F.
    
    If ( (cArqQry)->C6_QTDENT < (cArqQry)->C6_QTDVEN )	
        lRet := .T.
    EndIf    */
    Alert("MA440SC6() ")

Return lRetorno

User Function Ma440VLD ()
    //Local cArqQry := ParamixbLocal 
    Local lRetorno := .F.
    
    //If ( (cArqQry)->C6_QTDENT < (cArqQry)->C6_QTDVEN )	
        lRetorno := .T.
    //EndIf    
    Alert(" Ma440VLD() ")

Return lRetorno
