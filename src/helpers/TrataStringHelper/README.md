# TrataStringHelper

A classe `TrataStringHelper` foi desenvolvida para oferecer uma interface simples e flexível no tratamento e manipulação de cadeias de caracteres. Ela atua como um motor de processamento de texto, permitindo desde saneamentos simples até substituições complexas de caracteres especiais.

A classe `TrataStringHelper`pode ser usada, por exemplo, para complementar a substituição de caracteres especiais que funções como a FWNoAccent não tratam, ou se tiver a necessidade de trocar um código por outro em um texto, enfim, o limite para seus usos será a necessidade e a imaginação de quem vai utilizada, de como poder utilizá-la resolver sua "dor". 

## Funcionalidades Principais

Substituição de caracteres especiais com distintas regras de substituição:
- Pode definir diferentes configuradores para diferentes tarefas.
- Substituição em massa de ocorrências de texto baseada em regras pré-definidas.
- Os configuradores podem ter distintas origens de dados, como arquivos, parâmetros, valores fixos, etc. A ideia é a comunidade criar vários configuradores e contribuir para o projeto. Um configurador é apenas uma classe que "siga a estratégia" de uma classe configuradora, que é possuir um método chamado GetConfig e que retorno um objeto JSON que contenha um atributo chamado "caracteres", que por sua vez é um array de objetos que possuam 2 atributos, o "de" e o "para".

Em resumo, a classe `TrataStringHelper` utiliza uma simmplificação do "design pattern" Strategy, onde a "estratégia" ou "contrato" é que os configuradores tenham um método chamado GetConfig que retorna um objeto JSON com as regras de substituição.

## Estrutura de Configuradores

O grande diferencial desta classe é a sua arquitetura baseada em **Configuradores**. Localizados na subpasta `configuradores`, estes arquivos definem os conjuntos de regras (de/para) que a classe deve aplicar.

Em resumo, utiliza uma simplificação do "design pattern" Strategy, onde os configuradores devem possuir um método GetConfig, que devolva um objeto JSON com as regras de substituição. 

Este objeto JSON deve ter um atributo chamado "caracteres", que será um array de outros objetos JSON que contenham os atributos "de" e "para". Abaixo está um exemplo:

```json
{
    "caracteres": [
		{"de": "Ð", "para": "D"},
        {"de": "ý", "para": "y"},
        {"de": "ÿ", "para": "y"}
	]
}
```
O exemplo acima resolve caracteres que a função FWNoAccent não reconhece e por isto não os substitui.

### Como funcionam os Configuradores
Cada configurador representa um conjunto específico de substituições. Isso permite que a lógica de "o que substituir" seja separada da lógica de "como processar", garantindo que a classe principal permaneça íntegra enquanto novas regras são adicionadas.

Como citado acima, basta ser uma classe que implemente o método GetConfig e que retorne um objeto JSON com as regras de substituição, conforme detalhado acima. 

A origem das regras fica a critério do programador, no projeto já tem alguns configuradores, um por exemplo, lê um JSON com as caracteristicas acima, sem fazer tratamentos ( a classe `JSONConfig`, presente no fornte \configuradores\json_config.prw, que recebe o caminho do json em seu construtor), outra classe de configurador já existente é a `CSVChrConfig`, que está no fonte \configuradores\csv_chr_config.prw, que recebe o caminho de um CSV no seu construtor, mas trabalha de utra forma, esperando um CSV de 2 colunas, onde na primeira coluna tem o código ASCII do valor "de" e na segunda coluna o código ASCII do valor "para".

Fiquem a vontade para criar novos configuradores que leiam as configurações de arquivos Texto com os mais diversos formatos, CSV's com outras estruturas e outras regras, de XML's, que não leiam dados de nenhum local, mas internamente já contemplem as regras para um caso que possa ser interessante para os demais programadores da comunidade, enfim, a imagninação é o limite.

### Contribuição com Novos Configuradores
Este projeto é colaborativo e encoraja a criação de novos padrões de tratamento. Se você possui uma necessidade específica (ex: um padrão para nomes de arquivos ou uma regra para um ERP específico), você pode:

1. Criar um novo arquivo de configuração dentro da pasta `configuradores`.
2. Seguir o padrão de implementação das classes existentes na pasta.
3. Submeter um Pull Request com o novo configurador.

## Exemplo de Uso

A classe é instanciada e alimentada com um ou mais configuradores, processando o texto de entrada conforme as regras registradas.

1. Instancie a classe `TrataStringHelper`.
2. Defina quais configuradores deseja utilizar.
3. Chame o método de para processar os tratamentos passando a string a ser tratada ( método `TrataStr`).


## Exemplo de uso:
```
#include "totvs.ch"

User Function Teste()
	Local oTrataStr		:= TrataStringHelper():New()
	Local cFileCSV		:= "\meu_path\regras.csv"
	Local cFileJSON		:= "\meu_path\regras.json"
	Local cTextoOrig	:= ""
	Local cTextoTransf	:= ""
	Local oCSVChrCfg
	Local oJSONCfg

	If File(cFileCSV)
		oCSVChrCfg := CSVChrConfig():New(cFileCSV)
		oTrataStr:AddConfigurador(oCSVChrCfg)
	EndIf

	If File(cFileJSON)
		oJSONCfg := JSONConfig():New(cFileJSON)
		oTrataStr:AddConfigurador(oJSONCfg)
	EndIf
	
	cTextoOrig := "Este é um texto com os caracteres " + Chr(208) + ", " + Chr(253) + " e " + Chr(255) + " ."
	cTextoOrig += "Ficou_b-o-m,_mas pode melhorar_muito com a ajuda_da_comunidade."
	cTextoTransf := oTrataStr:TrataStr(cTextoOrig)
	
Return
```

Um detalhe interessante é que o método AddConfigurador "implementa" o "conceito" de `fluent interface`, que permite realizar as chamadas ao método em cadeia.

Por exemplo: 
```
Em vez de fazer 
oTrataStr:AddConfigurador(oCSVChrCfg)
e 
oTrataStr:AddConfigurador(oJSONCfg)
Em duas linhas separadas

Pode-se fazer em uma única linha, como no exemplo abaixo:
oTrataStr:AddConfigurador(oCSVChrCfg):AddConfigurador(oJSONCfg)
```

## Como Contribuir

Para contribuir especificamente com esta classe ou com a pasta de configuradores, utilize o fluxo padrão de Fork e Pull Request detalhado na raiz deste repositório. Certifique-se de que novos configuradores possuam nomes descritivos e documentação interna sobre quais caracteres ou padrões estão sendo tratados.


## Agradecimentos

Agradecimento ao amigo Claudio Donizete ( [@claudiosdonizete](https://github.com/claudiosdonizete) ), que necessitava realizar o tratamento de strings e cuja dúvida era se teria alguma função ou classe do padrão que faria tal tratamento. Como não encontramos na documentação online algo no padrão para atender o caso, concluimos que teria que fazer muitas operações utilizando as funções padrão diretamente no código, de modo que não seria algo reaproveitável. Dai surgiu a ideia de criar uma classe para fazê-lo. Além da dúvida inicial, também colaborou na conceitualização do projeto.