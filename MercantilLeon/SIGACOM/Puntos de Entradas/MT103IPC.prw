#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT103IPC  บAutor  ณJorge Saavedra     	บ Data ณ  01/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. ณPunto de entrada para Actualizar campos en el Remito de Entrada บฑฑ
ฑฑบ      ณdespues de seleccionar Pedidos de Compras 							บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  BASE BOLIVIA   	                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function MT103IPC()
Local nPosItemCta	:= 0
Local nItem			:= ParamIxB[1]
          

Local nPosQuant    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_QUANT'})
Local nPosVunit    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_VUNIT'})
Local nPosTotal    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TOTAL'})
Local nPosTes    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TES'})
Local nPosCfis    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_CF'})
Local nPosPeso    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_PESO'})

_nPosDesc 	:= Ascan(aHeader, {|x|Alltrim(x[2])=="D1_UDESC"})
_nPosCod 	:= Ascan(aHeader, {|x|Alltrim(x[2])=="D1_COD"})
nX = PARAMIXB[1]   


_cProd:= aCols[nX][_nPosCod]

_cDesc	:= Posicione("SB1",1,xFilial("SB1")+ _cProd,"B1_DESC")
aCols[nX][_nPosDesc] := _cDesc 

If aCols[nX][nPosPeso] <> 0
	_nPeso := aCols[nX][nPosQuant] * Posicione("SB1", 1, xFilial("SB1")+GDFIELDGET("D1_COD", nX), "B1_PESO")
	aCols[nX][nPosPeso] := _nPeso
EndIf

If GetNewPar("MV_UVERCOS",.T.).AND.U_VerGrpUsr(GetNewPar("MV_UGRVECO","000000|000000")) 
 	IF UPPER(FUNNAME()) $ "MATA102N" //.AND. CUSERNAME $ U_TABCPOLst("SELECT DISTINCT","ZA_RESP","SZA","","","","|") // LISTA DE ENCARGADOS DE ALMACEN DE SZA
 		//:::::: mascara para columnas:::::

 		//  aheader[nPosQuant,6]:=  "U_ValTotal()" //para validar cantidad tecleada
    
 		aHeader[nPosVunit,3]:="@E ***,***,***,***.*****  "//D1_VUNIT de esta forma el usuario vera un *                          
 		// aheader[nPosVunit,6]:=".F." //no modificable 
  
 		aHeader[nPosTotal,3]:="@E **,***,***,***.** "//D1_TOTAL de esta forma el usuario vera un *
 		//aheader[nPosTotal,6]:=".F." //no modificable
    
 		//aHeader[nPosTes,3]:="@E * " // D1_TES
 		//aHeader[nPosCfis,3]:="@E * " // D1_CF

 		ofldrodape:lvisiblecontrol:=.F. // oculta folders
 	ENDIF  
end

Return Nil

