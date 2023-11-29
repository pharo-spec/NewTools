"
A MethodToolbar is xxxxxxxxx.

self example
"
Class {
	#name : 'StMethodToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'method',
		'browseButton',
		'usersButton',
		'sendersButton',
		'implementorsButton',
		'versionButton',
		'dropList',
		'toolbarPresenter'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'examples' }
StMethodToolbarPresenter class >> example [

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

{ #category : 'specs' }
StMethodToolbarPresenter class >> title [

	^ 'Toolbar'
]

{ #category : 'api' }
StMethodToolbarPresenter >> addItemLabeled: aString do: aBlock [

	dropList 
		addItemLabeled: aString 
		do: aBlock
]

{ #category : 'private' }
StMethodToolbarPresenter >> browseMethod [

	self method ifNil: [ ^ self ].

	self systemNavigation browse: self method
]

{ #category : 'layout' }
StMethodToolbarPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		spacing: 3;
		borderWidth: 3;
		add: toolbarPresenter;
		add: (SpBoxLayout newTopToBottom
				vAlignCenter;
				add: dropList;
				yourself)
			expand: false;
		yourself
]

{ #category : 'api' }
StMethodToolbarPresenter >> emptyDropList [
	
	dropList emptyList
]

{ #category : 'private' }
StMethodToolbarPresenter >> implementorsMethod [

	self method ifNil: [ ^ self ].
	
	self systemNavigation browseAllImplementorsOf: self method selector
]

{ #category : 'initialization' }
StMethodToolbarPresenter >> initializePresenters [

	(browseButton := self newToolbarButton)
		label: 'Browse'; 
		icon: (self iconNamed: #smallSystemBrowser);
		help: 'Browse current selected method';
		action: [ self doBrowseMethod ].
	(usersButton := self newToolbarButton) 
		label: 'References'; 
		icon: (self iconNamed: #smallFind);
		help: 'Browse references of current selected class';
		action: [ self doBrowseUsers ].
	(sendersButton := self newToolbarButton) 
		label: 'Senders'; 
		icon: (self iconNamed: #smallFind);
		help: 'Browse senders of current selected method';
		action: [ self doBrowseSenders ].
	(implementorsButton := self newToolbarButton) 
		label: 'Implementors'; 
		icon: (self iconNamed: #smallFind);
		help: 'Browse implementors of current selected method';
		action: [ self doBrowseImplementors ].
	(versionButton := self newToolbarButton) 
		label: 'Version'; 
		icon: (self iconNamed: #history);
		help: 'Browse versions of current selected method';
		action: [ self doBrowseVersions ].
		
 	toolbarPresenter := self newToolbar
			add: browseButton;
			add: usersButton;
			add: sendersButton;
			add: implementorsButton;
			add: versionButton;
			yourself.
		
	dropList := self newDropList
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> method [
	^ method
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> method: aMethod [

	method := aMethod
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> replaceVersionWithLabel: aString action: aBlock [

	versionButton 
		label: aString;
		action: aBlock
]

{ #category : 'api' }
StMethodToolbarPresenter >> selectFirst [

	dropList selectIndex: 1
]

{ #category : 'private' }
StMethodToolbarPresenter >> sendersMethod [

	self method ifNil: [ ^ self ].
	
	self systemNavigation browseAllSendersOf:  self method selector
]

{ #category : 'initialization' }
StMethodToolbarPresenter >> setModelBeforeInitialization: aMethod [

	self method: aMethod
]

{ #category : 'private' }
StMethodToolbarPresenter >> usersMethod [

	self method ifNil: [ ^ self ].
	self method methodClass ifNil: [ ^ self ].
	
	self systemNavigation browseAllUsersOfClassOrTrait: self method methodClass
]

{ #category : 'private' }
StMethodToolbarPresenter >> versionMethod [

	self method ifNil: [ ^ self ].
	  
	self systemNavigation browseVersionsOf: self method
]
