#include 'protheus.ch'
#include 'parmtype.ch'

user function VerCosto(nTipo)
Local LRet:= .T.   

Local nPosQuant    
Local nPosVunit    
Local nPosTotal    

Local nPosTes

Local nPosCfis   

If GetNewPar("MV_UVERCOS",.T.).AND.U_VerGrpUsr(GetNewPar("MV_UGRVECO","000000|000000")) 
	IF UPPER(FUNNAME()) $ "MATA462TN"
		
		If nTipo == 54
			nPosQuant    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D2_QUANT'})
			nPosVunit    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D2_PRCVEN'})
			nPosTotal    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D2_TOTAL'})
		else
			nPosQuant    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_QUANT'})
			nPosVunit    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_VUNIT'})
			nPosTotal    := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_TOTAL'})
		end

		
		ofldrodape:lvisiblecontrol:=.F. // oculta folders

		//:::::: mascara para columnas:::::
		aHeader[nPosVunit,3]:="@E ***,***,***,***.*****  "//D1_VUNIT de esta forma el usuario vera un *                          
		// aheader[nPosVunit,6]:=".F." //no modificable 
  
		aHeader[nPosTotal,3]:="@E **,***,***,***.** "//D1_TOTAL de esta forma el usuario vera un *
		//aheader[nPosTotal,6]:=".F." //no modificable
    
	END
end	
return &(ReadVar())