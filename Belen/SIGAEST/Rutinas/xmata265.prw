/*#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXMATA265  บAutor  ณNahim Terrazas      บ Data ณ  14/03/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo para processamento do Endere็amento               	 บฑฑ
ฑฑบ          ณBOLIVIA		                                              บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#Include "RwMake.CH"
#include "tbiconn.ch"

/*NOTA IMPORTANTE
LA FUNCION SE VE AFECTADA POR INICIALIZADORES ESTมNDAR Y/O DISPARADORES 
*/

User Function XMATA265(cProducto,cNUmSeq,cLocaliz,cNumSerie,nQuant,nsegum,cAlmDes)

	Local aCabSDA    := {}
	Local aItSDB         := {}
	Local _aItensSDB := {}
	Private	lMsErroAuto := .F.


	aAdd(aCabSDA, {"DA_PRODUTO" ,alltrim(cProducto),Nil})
	aAdd(aCabSDA, {"DA_NUMSEQ"  ,alltrim(cNUmSeq),Nil})
	aItSDB := {{"DB_ITEM"	  ,"0001" ,Nil},;
	{"DB_LOCAL"   ,cAlmDes	,Nil},;
	{"DB_LOCALIZ" ,alltrim(cLocaliz),Nil},;
	{"DB_NUMSERI" ,alltrim(cNumSerie),Nil},;
	{"DB_DATA"	  ,dDataBase ,Nil},;
	{"DB_QTSEGUM" ,nsegum ,Nil},;
	{"DB_QUANT"  ,nQuant		,Nil}}
	aadd(_aItensSDB,aitSDB)
	
	
	//Executa o endere็amento do item

	MsExecAuto({|x,y,Z| MATA265(x,y,Z)}, aCabSDA,_aItensSDB, 3)
	
	If lMsErroAuto
		MostraErro()
	Else
		MsgAlert("Processamento Ok!")
	Endif
Return


