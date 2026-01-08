#include 'protheus.ch'
#include 'parmtype.ch'

user function asi01(cRoteir)
	Local cCuenta := 'X.X.X.X'
	if cRoteir == "FOL"
		cCuenta := u_asiFOL()
	elseif cRoteir == 'PRV'
		cCuenta := u_asiPRV()
	else
		ALERT("Proceso incorrecto.")
	endif 
return cCuenta

user function asiFOL()
	Local cCuenta := 'X.X.X.X'
	Local cCargo := SUBSTR(SRA->RA_CARGO,1,2)
	Local cMODirecta := POSICIONE("SRJ", 1, xFilial("SRJ")+SRA->RA_CODFUNC, "RJ_MAOBRA" )
	if cCargo <> ""
		if cMODirecta = "D"	// Mano de Obra Directa
			DO CASE
				CASE cCargo=="GD"
					cCuenta := "511112101"
				CASE cCargo=="IG"
					cCuenta := "511112102"
				CASE cCargo=="AD"
					cCuenta := "511122106"
				CASE cCargo=="TM"
					cCuenta := "511112103"
				CASE cCargo=="MM"
					cCuenta := "511112104"
				CASE cCargo=="CH"					
					cCuenta := "511112105"
				CASE cCargo=="OB"
					cCuenta := "511112106"
				OTHERWISE
					ALERT("Cód. de Cargo " + cCargo + " de la matrícula " + SRA->RA_MAT + " no contemplado en configuración del asiento. Actualizar fuente asi01.prw")
			ENDCASE
		else				// Mano de Obra Indirecta
			DO CASE
				CASE cCargo=="GD"
					cCuenta := "511122101"
				CASE cCargo=="IG"
					cCuenta := "511122102"
				CASE cCargo=="AD"
					cCuenta := "511122106"
				CASE cCargo=="TM"
					cCuenta := "511122103"
				CASE cCargo=="MM"
					cCuenta := "511122104"
				CASE cCargo=="CH"					
					cCuenta := "511122105"
				CASE cCargo=="OB"
					cCuenta := "511122109"
				OTHERWISE
					ALERT("Cód. de Cargo " + cCargo + " de la matrícula " + SRA->RA_MAT + " no contemplado en configuración del asiento. Actualizar fuente asi01.prw")
			ENDCASE
		endif
	else
		ALERT("La matricula " + SRA->RA_MAT + " no tiene asignado un cargo por tanto no será considerada en el asiento contable.")	
	endif 
return cCuenta

user function asiPRV()
	Local cCuenta := 'X.X.X.X'
	Local cCargo := SUBSTR(SRA->RA_CARGO,1,2)
	if cCargo <> ""
		DO CASE
			CASE cCargo=="GD"
				cCuenta := "511112501"
			CASE cCargo=="IG"
				cCuenta := "511112502"
			CASE cCargo=="AD"
				cCuenta := "521001104"
			CASE cCargo=="TM"
				cCuenta := "511112503"
			CASE cCargo=="MM"
				cCuenta := "511112504"
			CASE cCargo=="CH"
				cCuenta := "511112505"
			CASE cCargo=="OB"
				cCuenta := "511112506"
			OTHERWISE
				ALERT("Cód. de Cargo " + cCargo + " de la matrícula " + SRA->RA_MAT + " no contemplado en configuración del asiento. Actualizar fuente asi01.prw")
		ENDCASE
	else
		ALERT("La matricula " + SRA->RA_MAT + " no tiene asignado un cargo por tanto no será considerada en el asiento contable.")	
	endif 
return cCuenta
