#include "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
 
User Function CN120PED()  
    Local aCab := PARAMIXB[1]
    Local aItm := PARAMIXB[2]
    Local aArea:= GetArea()
    Local Nx   := 0

    For Nx:=1 to Len(aItm)     
            // C7_CC
           /* If (nLin :=aScan(aItm[Nx],{|x|x[1]=="C7_CC"}))>0
                aItm[Nx][nLin][2] := CNB->CNB_CC
            Else
                aAdd(aItm[Nx],{"C7_CC",CNB->CNB_CC,nil})
            EndIf*/
    Next

    RestArea(aArea)
Return({aCab,aItm})
