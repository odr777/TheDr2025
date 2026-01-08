#include 'protheus.ch'

/*/{Protheus.doc} deletarFiles
(long_description)
@author ETCHEVERRY-PC
@since 31/03/2017
@version 1.0
@example
(examples)
Objeto que carga rutas de archivos
@see (links_or_references)
/*/
class delFiles 
	data aDados
	method new() constructor 
	method setFile(cFile)
	method getFiles()
endclass

/*/{Protheus.doc} new
Metodo construtor
@author ETCHEVERRY-PC
@since 31/03/2017 
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method new() class delFiles
	::aDados := {}
return Self

method setFile(cFile) class delFiles
	aadd(::aDados,cFile)
return

method getFiles() class delFiles
	local aFile := {}
	aFile := ::aDados
return aFile