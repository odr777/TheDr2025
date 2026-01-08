#include 'protheus.ch'
#include 'parmtype.ch'

user function FA087ValBX()
Local aDatos:= PARAMIXB

If __CUSERID = '000000' .OR. cUserName = 'nterrazas' .OR. cUserName = 'jbravo'
	//Alert("FA087ValBX"+TRANSFORM(round(fa070Juros(Max(SE1->E1_MOEDA,1)),2),"@E 999,999,999.99"))
	Alert("FA087ValBX aDatos[2]:"+TRANSFORM(round(aDatos[2],2),"@E 999,999,999.99"))
	//Alert("FA087ValBX aDatos[6]:"+TRANSFORM(round(aDatos[6],2),"@E 999,999,999.99"))
	//Alert("FA087ValBX aLinBaixa[1][2]:"+TRANSFORM(round(aLinBaixa[1][2],2),"@E 999,999,999.99"))
	//Alert("FA087ValBX aLinBaixa[2][2]:"+TRANSFORM(round(aLinBaixa[2][2],2),"@E 999,999,999.99"))
	//alert("FA087ValBX")
Endif

	aDatos[2]:= round(fa070Juros(Max(SE1->E1_MOEDA,1)),2)
	aDatos[6]:= SE1->E1_SALDO+aDatos[2]-aDatos[1]+aDatos[3]	
		
	oLBBaixa:Refresh()
	oValRec:Refresh()

return aDatos
