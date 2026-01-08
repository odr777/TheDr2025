#include 'protheus.ch'
#include 'parmtype.ch'

user function GP110APL()
	ALERT(cMatDe + " - " + cMatAte)
	cMatDe := mv_par06
	cMatAte := mv_par07
	ALERT(cMatDe + " - " + cMatAte)
return