Class {
	#name : 'StExternalBrowserPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'classes',
		'packages',
		'protocols',
		'selectors',
		'method',
		'showClassSide',
		'model',
		'protocol'
	],
	#category : 'NewTools-ExternalBrowser',
	#package : 'NewTools-ExternalBrowser'
}

{ #category : 'public access' }
StExternalBrowserPresenter class >> browseStream: aStream [

	self openOn: (RingChunkImporter fromStream: aStream)
]

{ #category : 'specs' }
StExternalBrowserPresenter class >> defaultSpec [
	<spec: #default>
	
	^ SpPanedLayout newTopToBottom 
		add: (SpPanedLayout newLeftToRight
			add: (SpPanedLayout newLeftToRight 
				add: (SpBoxLayout newTopToBottom
					add: #packages;
					add: #showClassSide expand: false;
					yourself);
				add: #classes;
				yourself);
			add: (SpPanedLayout newLeftToRight 
				add: #protocols;
				add: #selectors ;
				yourself);
			yourself);
		add: #method; 
		yourself
]

{ #category : 'examples' }
StExternalBrowserPresenter class >> example [
	<example>

	self openOn: Smalltalk image
]

{ #category : 'System-FileRegistry' }
StExternalBrowserPresenter class >> fileReaderServicesForFile: fullName suffix: suffix [
	<fileService>

	^ (self sourceFileSuffixes includes: suffix)
		ifTrue: [ Array with: self serviceBrowseCode]
		ifFalse: [ #() ]
]

{ #category : 'instance creation' }
StExternalBrowserPresenter class >> openOn: model [

	^ (self on: model) openWithSpec
]

{ #category : 'System-FileRegistry' }
StExternalBrowserPresenter class >> serviceBrowseCode [
	"Answer the service of opening a file-contents browser"

	^ (SimpleServiceEntry
		provider: self 
		label: 'Code-file browser'
		selector: #browseStream:
		description: 'Open a "file-contents browser" on this file, allowing you to view and selectively load its code'
		buttonLabel: 'Code')
		argumentGetter: [ :file| file readStream]
]

{ #category : 'System-FileRegistry' }
StExternalBrowserPresenter class >> services [
	"Answer potential file services associated with this class"

	^ {self serviceBrowseCode}.
]

{ #category : 'System-FileRegistry' }
StExternalBrowserPresenter class >> sourceFileSuffixes [

	^#('st' 'cs')


]

{ #category : 'accessing' }
StExternalBrowserPresenter >> classes [

	^ classes
]

{ #category : 'structure accessing' }
StExternalBrowserPresenter >> classesOfPackage: aPackage [
	| theClasses |

	theClasses := aPackage classes.
	^ (self showClassSide state
		ifTrue: [ theClasses collect: [:each | each classSide ] ]
		ifFalse: [ theClasses ])
		sorted: #name ascending
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> connectPresenters [
	
	self wirePackages.
	self wireClasses.
	self wireProtocols.
	self wireSelectors.
	
	showClassSide whenChangedDo: [ 
		self refreshClasses: self packages selectedItem ]
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> initializeClassList [
	classes := self newList
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> initializeMethodBodyPane [

	method := self newCode
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> initializePackageList [
	packages := self newList.
	self populatePackages.
	packages display: [ :m | m name ]
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> initializePresenters [

	self initializePackageList.
	self initializeClassList.
	self initializeProtocolList.
	self initializeSelectorList.
	self initializeMethodBodyPane.
	
	showClassSide := self newCheckBox.
	showClassSide label: 'Class side'.
	showClassSide state: false
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> initializeProtocolList [

	protocols := self newList
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> initializeSelectorList [

	selectors := self newList
	
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		initialExtent: self application defaultWindowExtent;
		title: self title
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> method [
	^ method
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> method: anObject [
	method := anObject
]

{ #category : 'structure accessing' }
StExternalBrowserPresenter >> methodFor: aSelector [

	^ (self classes selectedItem methodNamed: aSelector) sourceCode
			
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> model: aModel [

	model := aModel
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> packages [

	^ packages
]

{ #category : 'selection operation' }
StExternalBrowserPresenter >> populatePackages [

	packages items: model packages.
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> protocols [

	^ protocols
]

{ #category : 'structure accessing' }
StExternalBrowserPresenter >> protocolsOfClass: aClass [

	^ aClass protocols sorted
]

{ #category : 'refresh' }
StExternalBrowserPresenter >> refreshClasses: pack [
	self resetClassSelection.
	pack 
		ifNil: [ classes items: #() ] 
		ifNotNil: [ classes items: (self classesOfPackage: pack) asArray]. 

]

{ #category : 'refresh' }
StExternalBrowserPresenter >> resetClassSelection [
	
	self classes unselectAll
]

{ #category : 'refresh' }
StExternalBrowserPresenter >> resetMethodBodyPane [
	self method text: ''
	
]

{ #category : 'refresh' }
StExternalBrowserPresenter >> resetProtocolSelection [

	self protocols unselectAll
]

{ #category : 'refresh' }
StExternalBrowserPresenter >> resetSelectorSelection [
	self selectors unselectAll
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> selectors [
	^ selectors
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> selectors: anObject [
	selectors := anObject
]

{ #category : 'structure accessing' }
StExternalBrowserPresenter >> selectorsOfProtocol: aProtocol [ 
	| theSelectedClass |

	theSelectedClass := self showClassSide state
		ifFalse: [ self classes selectedItem ]
		ifTrue: [ self classes selectedItem classSide ].
	^ ((theSelectedClass methodsInProtocol: self protocols selectedItem) 
		collect: [ :each | each selector ])
		sorted
]

{ #category : 'accessing model' }
StExternalBrowserPresenter >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : 'structure accessing' }
StExternalBrowserPresenter >> showClassDefinition [

	method text:
		(self classes selectedItem definitionString ifNil: [ '' ])
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> showClassSide [

	^ showClassSide
]

{ #category : 'accessing' }
StExternalBrowserPresenter >> title [ 
	^ 'External Package Browser'
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> wireClasses [
	classes
		whenSelectionChangedDo: [ :selection |
			| c |
			c := selection selectedItem. 
			self resetProtocolSelection.
			c 
				ifNil: [ protocols items: #() ] 
				ifNotNil: [ protocols items: (self protocolsOfClass: c).
					         self showClassDefinition ] ]
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> wirePackages [

	packages whenSelectionChangedDo: [ :selection | 
		self refreshClasses: selection selectedItem ].


	
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> wireProtocols [
	protocols
		whenSelectionChangedDo: [ :selection | 
			protocol := selection selectedItem.
			self resetSelectorSelection.
			protocol 
				ifNil: [ selectors items: #() ] 
				ifNotNil: [ selectors items: (self selectorsOfProtocol: protocol) ] ]
]

{ #category : 'initialization' }
StExternalBrowserPresenter >> wireSelectors [
	selectors
		whenSelectionChangedDo: [ :selection |
			| selector |
			selector := selection selectedItem.  
			selector 
				ifNil: [ self resetMethodBodyPane ] 
				ifNotNil: [ 
					method 
						text: (self methodFor: selector);
						beForMethod: self classes selectedItem >> selector ] ]
]
