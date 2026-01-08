#Include 'Protheus.ch'

User Function MT131AI()
    Local aItem := {}
    
	DbSelectArea("SN1")
	SN1->(DbSetOrder(2))
	If SN1->(DbSeek(xFilial("SN1")+SC1->C1_XCHAPA))
        aAdd( aItem, {'cAtf', '1'} )
		aAdd( aItem, {'cDescric', SN1->N1_DESCRIC} )
        aAdd( aItem, {'cXMarca', SN1->N1_XMARCA} )
        aAdd( aItem, {'cXModel', SN1->N1_XMODEL} )
        aAdd( aItem, {'cXSerie', SN1->N1_XSERIE} )
        aAdd( aItem, {'It.cXNumPar', SC1->C1_XNUMPAR} )
    Else
        aAdd( aItem, {'cAtf', '2'} )
		aAdd( aItem, {'cDescric', 'N/A'} )
        aAdd( aItem, {'cXMarca', 'N/A'} )
        aAdd( aItem, {'cXModel', 'N/A'} )
        aAdd( aItem, {'cXSerie', 'N/A'} )   
        aAdd( aItem, {'It.cXNumPar', SC1->C1_XNUMPAR} )
    EndIf

return aItem

