#include 'protheus.ch'
#include 'parmtype.ch'

user function A100BL01()
	ALERT("Número de Comprobante (Numero Proceso Transf.): " + SE5->E5_PROCTRA)
	if ALLTRIM(UPPER(FUNNAME())) $ "FINA100"
		if SE5->E5_TIPODOC $ 'TR'
			u_CTRANSFA(SE5->E5_PROCTRA)
		endif
	endif
	
return
