#INCLUDE 'PROTHEUS.CH'

User Function GP650CPO()
	Local aArea  := GetArea()
	Local cDes  
	
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1)) 
	SRA->(DbGoTop())
	
	//Posicionando en la matrícula
	If SRA->(DbSeek(FWxFilial("SRA") + RC1->RC1_MAT))
		// cDes := RC1->RC1_DESCRI + "MAT:" + RC1->RC1_MAT + SRA->RA_NOME
		cDes := Substr(RC1->RC1_MAT + " " + SRA->RA_NOME,1,30) 
		// Alert("GP650CPO: " + cDes)
	
		// RecLock("RC1",.F.)
		RC1->RC1_DESCRI := cDes 
		// MsUnLock()
	EndIf
	
	RestArea(aArea)
Return()