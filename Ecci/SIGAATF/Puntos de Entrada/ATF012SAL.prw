#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATFA012  บAutor   ณNahim Terrazas	    บ Data ณ  23/01/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Adicionando cuales tipos de registros en la SN3 son 	  	  บฑฑ
ฑฑบ          ณ permitidos digitar en tupla							      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ECCI\BOLIVIA                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ATF012SAL()
//Local aConfig  := aClone(ParamIxb[1])
Local aNewConf := {}
	
	/*
	aNewConf[x][1] = Tipo de Activo
	aNewConf[x][2] = Tipo de Saldo
	aNewConf[x][3] = M้todo de Depreciaci๓n
	*/
	
	//Para permitir todas las combinaciones se sugiere asignar el valor "*" en las posiciones 2 y 3:
	//Ejemplo:
	//aAdd(aNewConf,	{"10|12|13|14|15|16|17" , "*" , "*"})
	//aAdd(aNewConf,	{"01|02|03|04|05|06|07|11" , "*" , "*"})
    //aAdd(aNewConf,	{"09|08" , "*" ,"*" })

	aAdd(aNewConf,	{"10|12|13|14|15|16|17" , "*" , "*"})
//	aAdd(aNewConf,	{"01|02|03|04|05|06|07|11" , "1|" , "1|7|5"}) - S๓lamente opci๓n 1 y 5   - NTP 23/01/2020
	aAdd(aNewConf,	{"01|02|03|04|05|06|07|11" , "1|" , "1|5"})
	aAdd(aNewConf,	{"09|08" , "1|" ,"1|" })
	
Return aClone(aNewConf)
