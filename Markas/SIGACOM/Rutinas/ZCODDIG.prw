#include 'protheus.ch'
#include 'parmtype.ch'

user function ZCODDIG(cCod)
	Local cCodGuictr := ""
	cCod := alltrim(cCod)

	if !empty(cCod) .and. ALLTRIM(UPPER(FUNNAME())) $ "MATA101N"
		if len(cCod) <= 10

			if AT( "-", cCod ) <> 0
				return cCod
			else
				if len(cCod) % 2 != 0
					alert("Codigo de control erroneo")
					return ""
				endif

				cCodGuictr := ""

				nOrig := 0
				for i:= 1 to len(cCod)
					cCodGuictr += SubStr(cCod, i, 1)
					if i == nOrig + 2
						cCodGuictr += "-"
						nOrig:= i
					endif

				next i
				cCodGuictr := SUBSTR(cCodGuictr, 1, len(cCodGuictr)-1)
			endif
		else
			alert("Codigo mal tipeado")
		endif
	endif
return cCodGuictr