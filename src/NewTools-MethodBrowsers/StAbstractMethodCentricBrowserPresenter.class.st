"
I am an abstract class for browsers centered around messages such as class `MessageBrowser` or class `VersionBrowser`.
"
Class {
	#name : 'StAbstractMethodCentricBrowserPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'textConverter',
		'toolbarPresenter',
		'methodList'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'accessing' }
StAbstractMethodCentricBrowserPresenter class >> defaultPreferredExtent [

	^ 900 @ 600
]

{ #category : 'testing' }
StAbstractMethodCentricBrowserPresenter class >> isAbstract [ 
	 ^self name = #StAbstractMethodCentricBrowserPresenter
]

{ #category : 'initialization' }
StAbstractMethodCentricBrowserPresenter >> initialize [

	textConverter := self newTextConverter.
	super initialize
	
]

{ #category : 'initialization' }
StAbstractMethodCentricBrowserPresenter >> initializePresenters [

	methodList := self newMethodList.
	toolbarPresenter := self newMethodToolbar
		messageList: methodList;
		yourself
]

{ #category : 'private - testing' }
StAbstractMethodCentricBrowserPresenter >> isMethodDefinition: anItem [
	"an item can be nil, a compiled method, or a ring object. Whereas a ring object can be a ring method or comment definition.
	 Some operations are only valid for compiled methods or ring object that are a method definitions"

	anItem ifNil: [ ^ false ].
	
	"assume it is a compiled method or ring method definition"
	^ (anItem isRingObject and: [ anItem isMethod and: [ anItem compiledMethod isNotNil ] ])
		or: [  anItem isCompiledMethod ]
]

{ #category : 'accessing' }
StAbstractMethodCentricBrowserPresenter >> methodList [
	
	^ methodList
]

{ #category : 'initialization' }
StAbstractMethodCentricBrowserPresenter >> newMethodList [
	
	^ self instantiate: StMethodListPresenter
]

{ #category : 'initialization' }
StAbstractMethodCentricBrowserPresenter >> newMethodToolbar [

	^ self instantiate: StMethodToolbarPresenter
]

{ #category : 'private - factory' }
StAbstractMethodCentricBrowserPresenter >> newTextConverter [

	^ DiffSourceMethodConverter new
]

{ #category : 'api' }
StAbstractMethodCentricBrowserPresenter >> selectedMethod [
	^ methodList selectedMethod
]

{ #category : 'accessing' }
StAbstractMethodCentricBrowserPresenter >> textConverter [
	^ textConverter
]

{ #category : 'accessing' }
StAbstractMethodCentricBrowserPresenter >> textConverter: aTextConverter [
	textConverter := aTextConverter method: self textConverter method
]
