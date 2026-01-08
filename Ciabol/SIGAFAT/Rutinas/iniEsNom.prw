#include 'protheus.ch'

user function iniEsNom()

	cIni := ""
	if FUNNAME()=="PMSA600"
		cIni := GetAdvFVal("SA1","A1_UNOMFAC",xFilial("SA1")+AF8->AF8_CLIENT+AF8->AF8_LOJA,1,"")
	elseif FUNNAME()=="MATA416"
		cIni := POSICIONE("SA1",1,XFILIAL("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_UNOMFAC")
	endif

return elseif