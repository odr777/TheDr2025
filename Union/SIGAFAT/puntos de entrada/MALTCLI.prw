USER FUNCTION MALTCLI

	//MSGSTOP("estas en el punto de entrada antes de Modificar NEW NEW cliente")          

	Local cFechaHora  := ""	
	cQryD2 := " SELECT 	SUBSTRING(CONVERT(VARCHAR(12), GETDATE(), 103),7,4)+ "
	cQryD2 += " 		SUBSTRING(CONVERT(VARCHAR(12), GETDATE(), 103),4,2)+ "
	cQryD2 += " 		SUBSTRING(CONVERT(VARCHAR(12), GETDATE(), 103),1,2)+' '+ "
	cQryD2 += " 		SUBSTRING(CONVERT(VARCHAR(15), GETDATE(), 114),1,5) FechaHora "
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQryD2	), "QRYD2", .F., .T. )
	QRYD2->(dbGoTop())
	cFechaHora := ALLTRIM(QRYD2->FechaHora)
	QRYD2->(dbCloseArea())


	
	Reclock('SA1',.F.)                           
	Replace A1_UCMUSR With SUBSTR(CUSERNAME,1,15)	
	//Replace A1_UCMFEC With StrZero(Year(DDATABASE),4)+StrZero(MONTH(DDATABASE),2)+StrZero(Day(DDATABASE),2)+" "+SUBSTR(TIME(), 1, 5) //FECHA DEL SERV DATABASE
	Replace A1_UCMFEC With cFechaHora	
	

	
	SA1->(MsUnlock())		



RETURN .T.