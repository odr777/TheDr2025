user function SE5FI080
	Local cCamposE5 := PARAMIXB[1]

	if funname() $ "FINA450"
		If Type("cxGloCom")=="C"
			cCamposE5 += ",{'E5_UGLOSA'   , '"+cxGloCom   +"' }"
		ENDIF
	endif
return cCamposE5
