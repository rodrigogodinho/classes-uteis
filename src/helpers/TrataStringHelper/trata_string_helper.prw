#Include "totvs.ch"

/*/{Protheus.doc} TrataStringHelper
Classe para tratar strings
@type class
@author Rodrigo Godinho
@since 22/12/2025
/*/
CLASS TrataStringHelper FROM LongNameClass

	DATA aConfiguradores
	DATA aRegras
	DATA lLoaded

	METHOD New() CONSTRUCTOR
	METHOD AddConfigurador( oConfigurador )
	METHOD LoadConfig()
	METHOD TrataStr( cTexto )
	METHOD LimpaRegras()
	METHOD GetRegras()
	METHOD ProcTexto( cTexto )

ENDCLASS

/*/{Protheus.doc} TrataStringHelper::New
Construtor
@type method
@author Rodrigo Godinho
@since 22/12/2025
@return object, Instância da classe
/*/
METHOD New() CLASS TrataStringHelper
	::aConfiguradores := {}
	::aRegras := {}
	::lLoaded := .F.
Return

/*/{Protheus.doc} TrataStringHelper::AddConfigurador
Adiciona um configurador
@type method
@author Rodrigo Godinho
@since 22/12/2025
@param oConfigurador, object, Configuradoor
@return object, Self para implementar fluent interface
/*/
METHOD AddConfigurador( oConfigurador ) CLASS TrataStringHelper
	// Espera-se que oConfigurador possua método GetConfig() -> JSON com as regras de substituição
	aAdd( ::aConfiguradores, oConfigurador )
// Devolve o Self para o fluent interface, permitindo "encadeiar" a ação de adicionar configuradores
Return Self

/*/{Protheus.doc} TrataStringHelper::LimpaRegras
Limpa as regras
@type method
@author Rodrigo Godinho
@since 22/12/2025
/*/
METHOD LimpaRegras() CLASS TrataStringHelper
	aSize(::aRegras, 0)
	::lLoaded := .F.
Return

/*/{Protheus.doc} TrataStringHelper::GetRegras
Getter das regras
@type method
@author Rodrigo Godinho
@since 22/12/2025
@return array, Array de regras
/*/
METHOD GetRegras() CLASS TrataStringHelper
Return ::aRegras

/*/{Protheus.doc} TrataStringHelper::LoadConfig
Carrega as configurações dos configuradores
@type method
@author Rodrigo Godinho
@since 22/12/2025
@return logical, se carregou pelo menos 1 regra
/*/
METHOD LoadConfig() CLASS TrataStringHelper
	Local nI			:= 0
	Local nJ			:= 0
	Local aCaracteres 	:= {}
	Local oConf
	Local jConfig
	Local jItemCfg

	::LimpaRegras()

	For nI := 1 To Len( ::aConfiguradores )
		oConf := ::aConfiguradores[ nI ]

		If ValType(oConf) == "O" .And. MethIsMemberOf(oConf, "GetConfig", .T.)

			jConfig := oConf:GetConfig()
			If jConfig:HasProperty("caracteres")
				// Espera JSON no formato:
				// { "caracteres": [ {"de": "`", "para": ""}, {"de": "_", "para": " "} ] }
				aCaracteres := jConfig["caracteres"]

				For nJ := 1 To Len( aCaracteres )
					jItemCfg := aCaracteres[ nJ ]
					If jItemCfg:HasProperty("de")
						If !jItemCfg:HasProperty("para")
							jItemCfg["para"] := ""
						EndIf
						aAdd( ::aRegras, jItemCfg )
					EndIf 
				Next
			EndIf
		EndIf
	Next

	::lLoaded := ( Len( ::aRegras ) > 0 )
Return ::lLoaded

/*/{Protheus.doc} TrataStringHelper::TrataStr
Método para tratar e fazer a carga das regras, caso necessário
@type method
@author Rodrigo Godinho
@since 22/12/2025
@param cTexto, character, Texto original
@return character, Texto tratado
/*/
METHOD TrataStr( cTexto ) CLASS TrataStringHelper
	Local cRet	:= ""

	// Garante configuração carregada
	If !::lLoaded
		::LoadConfig()
	EndIf

	If ::lLoaded
		// Aplicação das regras de troca, mas só se tem regras
		cRet := ::ProcTexto( cTexto )
	EndIf

Return cRet

/*/{Protheus.doc} TrataStringHelper::ProcTexto
Faz o tratamento da string
@type method
@author Rodrigo Godinho
@since 22/12/2025
@param cTexto, character, Texto
@return character, Texto tratado
/*/
METHOD ProcTexto( cTexto ) CLASS TrataStringHelper
	Local cRet	:= ""
	Local cDe	:= ""
	Local cPara	:= ""
	Local nI	:= 0

	Default cTexto := ""

	cRet := cTexto

	For nI := 1 To Len( ::aRegras )
		cDe	:= ::aRegras[nI]["de"] 
		cPara := ::aRegras[nI]["para"]
		If ! Empty( cDe )
			cRet := StrTran( cRet, cDe, cPara )
		EndIf
	Next

Return cRet
