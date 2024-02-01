Class {
	#name : 'StClyOldMessageBrowserQuery',
	#superclass : 'ClyConstantMethodQuery',
	#instVars : [
		'extraMethods',
		'criteriaString',
		'criteriaBlock'
	],
	#category : 'NewTools-MethodBrowsers-Calypso',
	#package : 'NewTools-MethodBrowsers-Calypso'
}

{ #category : 'accessing' }
StClyOldMessageBrowserQuery >> criteriaBlock [
	^ criteriaBlock
]

{ #category : 'accessing' }
StClyOldMessageBrowserQuery >> criteriaBlock: anObject [
	criteriaBlock := anObject
]

{ #category : 'accessing' }
StClyOldMessageBrowserQuery >> criteriaString [
	^ criteriaString
]

{ #category : 'accessing' }
StClyOldMessageBrowserQuery >> criteriaString: anObject [
	criteriaString := anObject asString
]

{ #category : 'tools decoration' }
StClyOldMessageBrowserQuery >> decorateResultMethodEditor: aMethodEditor [

	criteriaString ifNil: [ ^self ].

	aMethodEditor selectStringAsInMessageBrowser: criteriaString
]

{ #category : 'accessing' }
StClyOldMessageBrowserQuery >> highlightElement [
	
	^ self criteriaString
]

{ #category : 'initialization' }
StClyOldMessageBrowserQuery >> initialize [
	super initialize.
	extraMethods := IdentitySet new
]

{ #category : 'execution' }
StClyOldMessageBrowserQuery >> installedMethods [

	| onlyMethods actualMethods |
	onlyMethods := methods select: [ :each | each isCompiledMethod ].

	actualMethods := self filterInstalledMethods: onlyMethods, extraMethods.
	^actualMethods, (methods reject: [ :each | each isCompiledMethod ])
]

{ #category : 'testing' }
StClyOldMessageBrowserQuery >> selectsMethod: aMethod [
	| result |
	(super selectsMethod: aMethod) ifTrue: [ ^true ].
	criteriaBlock ifNil: [ ^false ].

	extraMethods removeAllSuchThat: [ :each |
		each calypsoEnvironmentType checkCalypsoItem: each isEqualTo: aMethod].

	result := criteriaBlock value: aMethod.
	result ifTrue: [ extraMethods add: aMethod ].
	^result
]
