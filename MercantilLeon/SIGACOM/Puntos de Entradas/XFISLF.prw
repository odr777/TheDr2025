#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFISLF  บAutor  ณJorge Saavedra      บFecha ณ  26/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Punto de entrada que permite la alteraci๓n de referencias Fiscales,บฑฑ
ฑฑบ          ณ                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BASE BOLIVIA                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


user function XFISLF()
Local LRet:= .T.   

Local nPosQuant    
Local nPosVunit    
Local nPosTotal    

Local nPosTes

Local nPosCfis   
// SI ES REMITO DE ENTRADA Y EL USUARIO(logueado) ES RESTRINGIDO
If GetNewPar("MV_UVERCOS",.T.).AND.U_VerGrpUsr(GetNewPar("MV_UGRVECO","000000|000000"))
	//Transferencia entre sucursales - Salida
	If UPPER(FUNNAME()) $ "MATA462TN" 
		U_VerCosto(aCfgNF[1])
	
	end
 	//Remito de Entrada
	IF UPPER(FUNNAME()) $ "MATA102N" 

		nPosQuant    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_QUANT'})
		nPosVunit    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_VUNIT'})
		nPosTotal    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TOTAL'})

		nPosTes    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TES'})

		nPosCfis    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_CF'})



		ofldrodape:lvisiblecontrol:=.F. // oculta folders

		//:::::: mascara para columnas:::::
		aHeader[nPosVunit,3]:="@E ***,***,***,***.*****  "//D1_VUNIT de esta forma el usuario vera un *                          
		// aheader[nPosVunit,6]:=".F." //no modificable 
  
		aHeader[nPosTotal,3]:="@E **,***,***,***.** "//D1_TOTAL de esta forma el usuario vera un *
		//aheader[nPosTotal,6]:=".F." //no modificable
    
	END
end
Return