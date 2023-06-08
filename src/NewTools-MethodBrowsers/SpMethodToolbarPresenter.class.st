"
A MethodToolbar is xxxxxxxxx.

self example
"
Class {
	#name : #SpMethodToolbarPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'method',
		'browseButton',
		'usersButton',
		'sendersButton',
		'implementorsButton',
		'versionButton',
		'dropList'
	],
	#category : #'NewTools-MethodBrowsers-Base'
}

{ #category : #examples }
SpMethodToolbarPresenter class >> example [

	<sampleInstance>
	| example |
	
	example := self new.
	example
		method: SpButtonPresenter >> #state:;
		method: nil;
		extent: 550 @ 100;
		open.
	^ example
]

{ #category : #specs }
SpMethodToolbarPresenter class >> title [

	^ 'Toolbar'
]

{ #category : #api }
SpMethodToolbarPresenter >> addItemLabeled: aString do: aBlock [

	dropList 
		addItemLabeled: aString 
		do: aBlock
]

{ #category : #private }
SpMethodToolbarPresenter >> browseMethod [

	self method ifNil: [ ^ self ].

	self systemNavigation browse: self method
]

{ #category : #layout }
SpMethodToolbarPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		spacing: 3;
		borderWidth: 3;
		add: browseButton;
		add: usersButton;
		add: sendersButton;
		add: implementorsButton;
		add: versionButton;
		add: dropList;
		yourself
]

{ #category : #api }
SpMethodToolbarPresenter >> emptyDropList [
	
	dropList emptyList
]

{ #category : #private }
SpMethodToolbarPresenter >> implementorsMethod [

	self method ifNil: [ ^ self ].
	
	self systemNavigation browseAllImplementorsOf: self method selector
]

{ #category : #initialization }
SpMethodToolbarPresenter >> initializePresenters [

	(browseButton := self newButton) 
		label: 'Browse'; 
		action: [ self browseMethod ].
	(usersButton := self newButton) 
		label: 'Users'; 
		action: [ self usersMethod ].
	(sendersButton := self newButton) 
		label: 'Senders'; 
		action: [ self sendersMethod ].
	(implementorsButton := self newButton) 
		label: 'Implementors'; 
		action: [ self implementorsMethod ].
	(versionButton := self newButton) 
		label: 'Version'; 
		action: [ self versionMethod ].
	dropList := self newDropList
]

{ #category : #accessing }
SpMethodToolbarPresenter >> method [
	^ method
]

{ #category : #accessing }
SpMethodToolbarPresenter >> method: aMethod [

	method := aMethod
]

{ #category : #accessing }
SpMethodToolbarPresenter >> replaceVersionWithLabel: aString action: aBlock [

	versionButton 
		label: aString;
		action: aBlock
]

{ #category : #api }
SpMethodToolbarPresenter >> selectFirst [

	dropList selectIndex: 1
]

{ #category : #private }
SpMethodToolbarPresenter >> sendersMethod [

	self method ifNil: [ ^ self ].
	
	self systemNavigation browseAllSendersOf:  self method selector
]

{ #category : #initialization }
SpMethodToolbarPresenter >> setModelBeforeInitialization: aMethod [

	self method: aMethod
]

{ #category : #private }
SpMethodToolbarPresenter >> usersMethod [

	self method ifNil: [ ^ self ].
	self method methodClass ifNil: [ ^ self ].
	
	self systemNavigation browseAllUsersOfClassOrTrait: self method methodClass
]

{ #category : #private }
SpMethodToolbarPresenter >> versionMethod [

	self method ifNil: [ ^ self ].
	  
	self systemNavigation browseVersionsOf: self method
]
