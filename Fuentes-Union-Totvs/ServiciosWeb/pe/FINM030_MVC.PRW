#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINM030	  บAutor  ณ TDEP	 	   	บFecha ณ   09/01/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava็ใo das informa็๕es complementares na FKดs e SE5      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA /Uni๓n Agronegocios                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FINM030
Local aParam   	:= PARAMIXB
Local xRet      := .T.
Local oSubModel := ""
Local cIdPonto  := ""
Local cIdModel  := ""
Local lIsGrid   := .F.
Local cMsg      := ""
Local cCamposE5	:= ""

If aParam <> NIL
	oSubModel  := aParam[1]		//Objeto do formulแrio ou do modelo, conforme o caso
    cIdPonto   := aParam[2]		//ID do local de execu็ใo do ponto de entrada
    cIdModel   := aParam[3]		//ID do formulแrio
    lIsGrid    := ( Len( aParam ) > 3 )
	
	If cIdPonto == "FORMPOS" // Na valida็ใo total do formulแrio.
		
		If cIdModel == "FK5DETAIL" //Valida็ใo do formulแrio FK5
			
			oModelBxRP 	:= oSubModel:GetModel()
			cCamposE5 	:= AllTrim(oModelBxRP:GetValue('MASTER', 'E5_CAMPOS'))
			
			oFK5		:= oModelBxRP:GetModel("FK5DETAIL")
			oFK6    	:= oModelBxRP:GetModel("FK6DETAIL")
			oFKA		:= oModelBxRP:GetModel("FKADETAIL")
						
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Mov.Bancario /Cobranza (Venta Rแpida)		ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If AllTrim(oFK5:GetValue("FK5_ORIGEM")) $ "RPC|MATA410"		//"RPC|FINA087A"
					
				If !Empty(oFK5:GetValue("FK5_ORDREC")) .AND. !Empty(oFK5:GetValue("FK5_BANCO"))
					If oFK5:GetValue("FK5_TPDOC")=="VL"
							
						__cIdMov := oFKA:GetValue("FKA_IDORIG")
						__cValor := ""
						If Len(aLinSE1)> 0
							For nI := 1 To Len(aLinSE1)
								If aLinSE1[nI][1]==1	//Check Ok
									__cValor := aLinSE1[nI][2] + " - " + aLinSE1[nI][3]	//Prefixo + Numero Tํtulo
									Exit
								Endif
							Next nI
						Endif
							
						If !Empty(__cValor)
							oFK5:SetValue( "FK5_DOC", __cValor ) 	// Novos valores
						Endif
						
					Endif
				Endif
			Endif
			
		Endif
	Endif
		
EndIf

Return(xRet)
