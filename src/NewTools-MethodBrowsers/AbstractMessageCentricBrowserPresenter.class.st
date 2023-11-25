"
I am an abstract class for browsers centered around messages such as class `MessageBrowser` or class `VersionBrowser`.
"
Class {
	#name : 'AbstractMessageCentricBrowserPresenter',
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
AbstractMessageCentricBrowserPresenter class >> isAbstract [ 
	 ^self name = #AbstractMessageCentricBrowserPresenter
]

{ #category : 'initialization' }
AbstractMessageCentricBrowserPresenter >> initialize [

	textConverter := self newTextConverter.
	super initialize
	
]

{ #category : 'initialization' }
AbstractMessageCentricBrowserPresenter >> initializePresenters [

	messageList := self newMessageList.
	toolbarPresenter := self newMessageToolbar
]

{ #category : 'initialization' }
AbstractMessageCentricBrowserPresenter >> initializeWindow: aWindowPresenter [
	| winExtent |
	
	winExtent := RealEstateAgent standardWindowExtent.
	aWindowPresenter initialExtent: (900 min: winExtent x) @ (550 min: winExtent y)
]

{ #category : 'private - testing' }
AbstractMessageCentricBrowserPresenter >> isMethodDefinition: anItem [
	"an item can be nil, a compiled method, or a ring object. Whereas a ring object can be a ring method or comment definition.
	 Some operations are only valid for compiled methods or ring object that are a method definitions"

	anItem ifNil: [ ^ false ].
	
	"assume it is a compiled method or ring method definition"
	^ (anItem isRingObject and: [ anItem isMethod and: [ anItem compiledMethod isNotNil ] ])
		or: [  anItem isCompiledMethod ]
]

{ #category : 'initialization' }
AbstractMessageCentricBrowserPresenter >> newMessageList [
	
	^ self instantiate: MessageListPresenter
]

{ #category : 'initialization' }
AbstractMessageCentricBrowserPresenter >> newMessageToolbar [

	^ self instantiate: SpMethodToolbarPresenter
]

{ #category : 'private - factory' }
AbstractMessageCentricBrowserPresenter >> newTextConverter [

	^ DiffSourceMethodConverter new
]

{ #category : 'api' }
AbstractMessageCentricBrowserPresenter >> selectedMessage [
	^ messageList selectedMessage
]

{ #category : 'accessing' }
AbstractMessageCentricBrowserPresenter >> textConverter [
	^ textConverter
]

{ #category : 'accessing' }
AbstractMessageCentricBrowserPresenter >> textConverter: aTextConverter [
	textConverter := aTextConverter method: self textConverter method
]
