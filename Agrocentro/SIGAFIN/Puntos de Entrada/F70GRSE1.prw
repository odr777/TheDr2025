
#include "totvs.ch"

USER FUNCTION F70GRSE1()
	////ADICIONAR FUNNAME
	if funname() $ "FINA450"
		If Type("cxGloCom")=="C"
			RecLock("SE5", .F.)
			SE5->E5_UGLOSA := cxGloCom
			SE5->(MsUnLock())

			cxGloCom := NIL
			FreeObj(cxGloCom)
		endif
	endif

RETURN
