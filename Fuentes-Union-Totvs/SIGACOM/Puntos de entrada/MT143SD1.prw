#include 'protheus.ch'
#include 'parmtype.ch'



user function MT143SD1()
	Local aAitems := Paramixb[1]
	
	//alert(DBB->DBB_TIPONF)
	if DBB->DBB_TIPONF $ "5" .OR. DBB->DBB_TIPONF $ "8"
		aAdd(aAitems[LEN(aAitems)] , {"D1_LOTECTL" , DBC->DBC_ULOTEC  , Nil})
		aAdd(aAitems[LEN(aAitems)] , {"D1_DTVALID" , DBC->DBC_UDTVAL  , Nil})
	endif
	
return aAitems