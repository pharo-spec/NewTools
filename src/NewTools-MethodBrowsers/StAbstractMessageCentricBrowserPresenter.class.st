"
I am an abstract class for browsers centered around messages such as class `MessageBrowser` or class `VersionBrowser`.
"
Class {
	#name : 'StAbstractMessageCentricBrowserPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'messageList',
		'textConverter',
		'toolbarPresenter'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'testing' }
StAbstractMessageCentricBrowserPresenter class >> isAbstract [ 
	 ^self name = #StAbstractMessageCentricBrowserPresenter
]

{ #category : 'initialization' }
StAbstractMessageCentricBrowserPresenter >> initialize [

	textConverter := self newTextConverter.
	super initialize
	
]

{ #category : 'initialization' }
StAbstractMessageCentricBrowserPresenter >> initializePresenters [

	messageList := self newMessageList.
	toolbarPresenter := self newMessageToolbar
]

{ #category : 'initialization' }
StAbstractMessageCentricBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter initialExtent: 900@600
]

{ #category : 'private - testing' }
StAbstractMessageCentricBrowserPresenter >> isMethodDefinition: anItem [
	"an item can be nil, a compiled method, or a ring object. Whereas a ring object can be a ring method or comment definition.
	 Some operations are only valid for compiled methods or ring object that are a method definitions"

	anItem ifNil: [ ^ false ].
	
	"assume it is a compiled method or ring method definition"
	^ (anItem isRingObject and: [ anItem isMethod and: [ anItem compiledMethod isNotNil ] ])
		or: [  anItem isCompiledMethod ]
]

{ #category : 'initialization' }
StAbstractMessageCentricBrowserPresenter >> newMessageList [
	
	^ self instantiate: StMessageListPresenter
]

{ #category : 'initialization' }
StAbstractMessageCentricBrowserPresenter >> newMessageToolbar [

	^ self instantiate: StMethodToolbarPresenter
]

{ #category : 'private - factory' }
StAbstractMessageCentricBrowserPresenter >> newTextConverter [

	^ DiffSourceMethodConverter new
]

{ #category : 'api' }
StAbstractMessageCentricBrowserPresenter >> selectedMessage [
	^ messageList selectedMessage
]

{ #category : 'accessing' }
StAbstractMessageCentricBrowserPresenter >> textConverter [
	^ textConverter
]

{ #category : 'accessing' }
StAbstractMessageCentricBrowserPresenter >> textConverter: aTextConverter [
	textConverter := aTextConverter method: self textConverter method
]
