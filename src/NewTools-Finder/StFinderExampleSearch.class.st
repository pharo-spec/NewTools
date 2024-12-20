"
Implements a search for given example expressions.

"
Class {
	#name : 'StFinderExampleSearch',
	#superclass : 'StFinderSearch',
	#category : 'NewTools-Finder-Search',
	#package : 'NewTools-Finder',
	#tag : 'Search'
}

{ #category : 'private' }
StFinderExampleSearch >> buildResult: aListOfStMethodFinderSend [

	| results |
	results := OrderedCollection new.

	aListOfStMethodFinderSend do: [ : methodSend |
		| foundResult |

		foundResult := StFinderSelectorResult new content: methodSend.
		results
			detect: [ :elem | 	elem content selector = methodSend selector ]
			ifFound: [ :elem | elem addChild: foundResult ]
			ifNone: [
				| newResult |
				newResult := StFinderExampleResult new
					             content: methodSend;
					             addChild: foundResult;
					             yourself.
				results add: newResult ] ].

	^ results
]

{ #category : 'execution' }
StFinderExampleSearch >> computeDataObjects: aString [

	| data dataObjects |
	(aString includes: $.) ifFalse: [ ^ #(  ) ].
	data := aString trimRight: [ :char |
		        char isSeparator or: [ char = $. ] ].
	
	[
		dataObjects := self parseAsNodes: data.
		dataObjects do: [ : e | e evaluateWithTimeOut: self evaluationTimeout ] ]
	on: OCCodeError , OCRuntimeSyntaxError
	do: [ :e |
		self application inform: 'Error: ' , e messageText.
		^ #(  ) ] .

	dataObjects size < 2 ifFalse: [ ^ dataObjects ].
	self application inform:
		'If you are giving an example of receiver, \args, and result, please put periods between the parts.\Otherwise just type one selector fragment'
			withCRs.
	^ #(  )
]

{ #category : 'execution' }
StFinderExampleSearch >> computeWithMethodFinder: aString [
	"Compute the selectors for the single example of receiver and args, in the very top pane"

	^ (self computeDataObjects: aString) 
		ifNotEmpty: [ : dataObjects | 
			StMethodFinder new 
				findMethodsByExampleInput: dataObjects allButLast 
				andExpectedResult: dataObjects last
				timeout: self evaluationTimeout ]
		ifEmpty: [ Array empty ]
]

{ #category : 'execution' }
StFinderExampleSearch >> evaluationTimeout [
	"Answer a <Number> representing the timeout for individual calls in the receiver's search"

	^ StFinderSettings evaluationTimeout
]

{ #category : 'testing' }
StFinderExampleSearch >> isFinderExampleSearch [

	^ true
]

{ #category : 'information' }
StFinderExampleSearch >> name [
	"Returns the name of the search."

	^ 'Examples'
]

{ #category : 'parsing' }
StFinderExampleSearch >> parseAsNodes: anExpression [

	^ (RBParser parseExpression: '{', anExpression , '}') statements asArray
]

{ #category : 'accessing' }
StFinderExampleSearch >> previewPresenter [

	^ MicrodownPresenter
]

{ #category : 'accessing' }
StFinderExampleSearch >> previewText [
	
	^ StFinderPresenter methodFinderExplanation
]

{ #category : 'accessing' }
StFinderExampleSearch >> search: aString in: aRBBrowserEnvironment [ 
	"Answer a <Collection> of results"
	"ToDo: Evaluate in the context of aRBBrowserEnvironment methodsDo: [ : method |"

	^ self buildResult: (self computeWithMethodFinder: aString)

]

{ #category : 'initialization' }
StFinderExampleSearch >> setSearchStrategyFrom: aDictionary [
	"Set the receiver's search strategy according to aCollection of options"

]

{ #category : 'information' }
StFinderExampleSearch >> updateDefaultPreview: aSpCodePresenter [ 

	aSpCodePresenter text: StFinderPresenter methodFinderExplanation
]

{ #category : 'accessing' }
StFinderExampleSearch >> validSearchOptions [
	"Answer a <Collection> of valid search options for the receiver"
	
	^ #(#deactivateAll)
]
