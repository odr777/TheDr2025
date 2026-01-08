
User Function DL200BRW()
Local aQueryOMS     := PARAMIXB

			AAdd( aQueryOMS ,{"PED_UOBS" , ,"Observación"} ) //
			AAdd( aQueryOMS ,{"PED_UNOMF" , ,"Nombre Cl. Fat."} ) //
			AAdd( aQueryOMS ,{"PED_UCOSEG" , ,"Segmento"} ) //

			AAdd( aQueryOMS ,aQueryOMS[6] )
			aQueryOMS[6] := {"PED_ULOCAL" , ,"Almacén"}

			// cambiando 13 por 19
			lug13 := aQueryOMS[13]
			lug19 := aQueryOMS[19]
//			AAdd( aQueryOMS ,aQueryOMS[13] )
			aQueryOMS[13] := lug19
			aQueryOMS[19] := lug13

//aQueryOMS
//			AAdd( aQueryOMS ,{"PED_ULOCAL" , ,"Almacén"} ) //
//ADel( aQueryOMS, 6 )

//Aviso("DL200TRB",u_zArrToTxt(aQueryOMS ),{"Ok"},,,,,.T.)

Return aQueryOMS