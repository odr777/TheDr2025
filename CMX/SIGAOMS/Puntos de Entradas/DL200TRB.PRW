User Function DL200TRB()

	Local aRet := PARAMIXB

	AADD(aRet,{"PED_UOBS" ,"C",100,0}) //observacion
	AADD(aRet,{"PED_UNOMF" ,"C",80,0}) //observacion
	AADD(aRet,{"PED_UCOSEG" ,"C",6,0}) //observacion
//	If MV_PAR06 == 2
		AADD(aRet,{"PED_ULOCAL" ,"C",20,0}) //almacen 
		
//		Aviso("DL200TRB",u_zArrToTxt(aRet),{"Ok"},,,,,.T.)
//	ENDIF
Return aRet