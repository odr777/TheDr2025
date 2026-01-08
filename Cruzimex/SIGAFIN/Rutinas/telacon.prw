#include 'protheus.ch'


	
user function TelaCon()
	Local retorno:= ParamIxb[1]
			
	if type("cNombreCli") == "U"// existe variable cNombreCli
		public cNombreCli := Space(40) // declarando variable publica 
		public oCliente
	
		@045 , 180 SAY "Recibo a nombre" Size 050,015 Pixel  Of oPanelTop  //"Serie/Recibo"
		@043 , 225 MSGET  oCliente var cNombreCli Size 075,08 Pixel Of oPanelTop	//"Nome"
				
		//oPanelTop:Refresh()
		
	endif	

return  retorno
