#INCLUDE 'PROTHEUS.CH'


user function M410STTS()

LOCAL cQry := ''
LOCAL nx   := 0

IF !INCLUI .AND. !ALTERA
    
    cQry := "SELECT * "
	cQry += "FROM SC6010 "
	cQry += "WHERE C6_NUM =  '" + C5_NUM + "' AND C6_FILIAL = '" + xFilial("SC6") + "' " 
	
    dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TTT",.F.,.T.)
    dbselectarea("TTT")
    DbGoTop()

    WHILE !TTT->(EOF())
        IF TTT->C6_XRECE1 > 0 
            SE1->(DBGOTO(TTT->C6_XRECE1))
            reclock("SE1",.F.)
            SE1->E1_XNVOVEN := CTOD('  /  /    ')
            SE1->E1_XINTER := ''
            msunlock()
        ENDIF    
        TTT->(DbSkip())
         
    ENDDO
    TTT->(DbCloseArea())
ENDIF

IF ALTERA

    FOR nx := 1 TO LEN(acols)

        IF acols[nx,len(acols[nx])] 

            cQry := "SELECT * "
	        cQry += "FROM SC6010 "
	        cQry += "WHERE C6_NUM =  '" + C5_NUM + "' AND C6_ITEM = '" + acols[nx,1] + "' AND C6_FILIAL = '" + xFilial("SC6") + "' " 
	
            dbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TTT",.F.,.T.)
            dbselectarea("TTT")
            DbGoTop()

            IF !TTT->(EOF())
                IF TTT->C6_XRECE1 > 0 
                    SE1->(DBGOTO(TTT->C6_XRECE1))
                    reclock("SE1",.F.)
                    SE1->E1_XNVOVEN := CTOD('  /  /    ')
                    SE1->E1_XINTER := ''
                    msunlock()
                ENDIF
            ENDIF        
    
        ENDIF
    NEXT nx
    TTT->(DbCloseArea())
ENDIF

RETURN 
