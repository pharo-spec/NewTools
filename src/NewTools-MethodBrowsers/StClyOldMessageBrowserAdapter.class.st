Class {
	#name : 'StClyOldMessageBrowserAdapter',
	#superclass : 'Object',
	#instVars : [
		'messages',
		'title',
		'autoSelect',
		'refreshingBlock',
		'openedBrowser'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'tools registration' }
StClyOldMessageBrowserAdapter class >> beDefaultBrowser [
	<script>
	
	self registerToolsOn: Smalltalk tools
]

{ #category : 'opening' }
StClyOldMessageBrowserAdapter class >> browse: methods [
	
	^ self new
		messages: methods;
		open
]

{ #category : 'opening' }
StClyOldMessageBrowserAdapter class >> browse: methods title: aString [

	^ self new
		messages: methods;
		title: aString;
		open
]

{ #category : 'opening' }
StClyOldMessageBrowserAdapter class >> browse: methods title: aString highlight: aSelectString [

	^ self new
		messages: methods;
		title: aString;
		autoSelect: aSelectString;
		open
]

{ #category : 'opening' }
StClyOldMessageBrowserAdapter class >> browseClasses: classes [

	^ StClyQueryBrowser openOn: (ClyConstantQuery returning: classes)
]

{ #category : 'opening' }
StClyOldMessageBrowserAdapter class >> browseImplementorsOf: aSymbol inNameResolver: methodContext [

	^ StClyQueryBrowser openOn: (ClyMessageImplementorsQuery of: aSymbol)
]

{ #category : 'opening' }
StClyOldMessageBrowserAdapter class >> browseSendersOf: aSymbol [

	^ StClyQueryBrowser openOn: (ClyMessageSendersQuery of: aSymbol)
]

{ #category : 'instance creation' }
StClyOldMessageBrowserAdapter class >> on: aNavigationEnvironment systemScope: aScope [ 
	
	^ StClyQueryBrowser on: aNavigationEnvironment systemScope: aScope
]

{ #category : 'tools registration' }
StClyOldMessageBrowserAdapter class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]"

	registry register: self as: #messageList
]

{ #category : 'accessing' }
StClyOldMessageBrowserAdapter >> autoSelect [

	^ autoSelect
]

{ #category : 'accessing' }
StClyOldMessageBrowserAdapter >> autoSelect: anObject [

	autoSelect := anObject
]

{ #category : 'opening' }
StClyOldMessageBrowserAdapter >> close [

	openedBrowser ifNil: [ ^ self ].
	openedBrowser close
]

{ #category : 'highlighting' }
StClyOldMessageBrowserAdapter >> highlight [ 
	
	^ self autoSelect
]

{ #category : 'highlighting' }
StClyOldMessageBrowserAdapter >> highlight: aString [ 
	
	self autoSelect: aString
]

{ #category : 'initialization' }
StClyOldMessageBrowserAdapter >> initialize [

	super initialize.
	title := 'MessageBrowser'
]

{ #category : 'accessing' }
StClyOldMessageBrowserAdapter >> messages [

	^ messages
]

{ #category : 'accessing' }
StClyOldMessageBrowserAdapter >> messages: anObject [
	messages := anObject
]

{ #category : 'opening' }
StClyOldMessageBrowserAdapter >> open [
	| query methods comments |

	methods := messages
		select: [:each | (each isRingObject and: [ each isMethod ]) or: [ each isCompiledMethod  ] ]
		thenCollect: [ :each | each compiledMethod ].
	comments := messages
		select: [:each | each isRingObject and: [ each isComment  ]]
		thenCollect: [ :each | ClyClassComment of: each realParent ].
	query := StClyOldMessageBrowserQuery named: title with: methods asOrderedCollection, comments.
	query
		criteriaString: autoSelect;
		criteriaBlock: refreshingBlock.

	openedBrowser := StClyQueryBrowser openOn: query.
	
	^ openedBrowser
]

{ #category : 'accessing' }
StClyOldMessageBrowserAdapter >> refreshingBlock [
	^ refreshingBlock
]

{ #category : 'accessing' }
StClyOldMessageBrowserAdapter >> refreshingBlock: anObject [
	refreshingBlock := anObject
]

{ #category : 'accessing' }
StClyOldMessageBrowserAdapter >> title [
	^ title
]

{ #category : 'accessing' }
StClyOldMessageBrowserAdapter >> title: anObject [
	title := anObject
]
