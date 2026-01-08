#include 'protheus.ch'
#include 'parmtype.ch'
//EET SOL ALMACEN
User Function MT105MNU()
	Local aRet := {}
	AADD(aRet,{ 'Imprimir Pedido',"U_BAJSOLA()" , 0 , 5})
	AADD(aRet,{ 'Imprimir Sol. QR',"u_uMATR105(.F.,{SCP->CP_EMISSAO,SCP->CP_NUM})" , 0 , 5})
	// SCP->CP_EMISSAO,SCP->CP_NUM
Return aRet
