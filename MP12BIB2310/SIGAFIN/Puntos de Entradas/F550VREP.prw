#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'TOPCONN.CH'

/*    
    Jorge Saavedra
    04/12/2021
    P.E. para Seleccionar el banco donde se quiere hacer la devolucion de saldos
*/
USER FUNCTION F550VREP
Local _aDatos := ParamIxb



Return _aDatos[1]


