#Include 'Protheus.ch'

/*/{Protheus.doc} MTA131C8
Campo no cabeçalho da cotação
@type function
@version 1.0
@author Luiz Fael
@since 01/11/2022
@return variant, NIll
/*/
User Function MTA131C8()
	Local oModFor   := PARAMIXB[1]
    oModFor:LoadValue("C8_CAMPANA","TSTPE - "+oModFor:GetValue("C1_CAMPANA"))
    oModFor:LoadValue("C1_CAMPDES","TSTPE - "+oModFor:GetValue("C1_CAMPDES"))
    oModFor:LoadValue("C1_CAMPRO","TSTPE  - "+oModFor:GetValue("C1_CAMPRO"))
    oModFor:LoadValue("C1_CAMPROD","TSTPE - "+oModFor:GetValue("C1_CAMPROD"))
Return
