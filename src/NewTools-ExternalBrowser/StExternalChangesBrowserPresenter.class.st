Class {
	#name : #StExternalChangesBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'changes',
		'codePane',
		'changeSet',
		'selectAllButton',
		'deselectAllButton',
		'fileInSelectedButton'
	],
	#category : #'NewTools-ExternalBrowser'
}

{ #category : #examples }
StExternalChangesBrowserPresenter class >> browseRecentLog [
	<example>
	
	^ self openOnStream: SourceFiles changesFileStream
]

{ #category : #specs }
StExternalChangesBrowserPresenter class >> defaultSpec [
	<spec: #default>
	self flag: #fixme. 
	"how to avoid hardcoding 24"
	^ SpBoxLayout 
		newTopToBottom 
				add: #changes;
				add: 
					(SpBoxLayout 
						newLeftToRight
						add: #selectAllButton;
						add: #deselectAllButton;
						add: #fileInSelectedButton; yourself )
				height: 24 ;
				add: #codePane; 
		yourself
]

{ #category : #examples }
StExternalChangesBrowserPresenter class >> example1 [
	<example>
	
	self new openWithSpec

]

{ #category : #examples }
StExternalChangesBrowserPresenter class >> example2 [
	<example>
	
	self openOn: Smalltalk changesFile fullName
]

{ #category : #'file service' }
StExternalChangesBrowserPresenter class >> fileReaderServicesForFile: fullName suffix: suffix [
	<fileService>
	| services |
	services := OrderedCollection new.
	(ExternalBrowserPresenter sourceFileSuffixes includes: suffix) |
	('changes' = suffix) | (suffix = '*')
		ifTrue: [ services add: self serviceBrowseCSOrSTFile ].
	^services
]

{ #category : #'instance creation' }
StExternalChangesBrowserPresenter class >> openOn: changeSetName [

	self new
		changeSetName: changeSetName;
		openWithSpec
]

{ #category : #'instance creation' }
StExternalChangesBrowserPresenter class >> openOnFileName: aFileName [

	self new
		changeSetName: aFileName;
		openWithSpec
]

{ #category : #'instance creation' }
StExternalChangesBrowserPresenter class >> openOnStream: aStream [

	| widget |
	widget := self new.
	widget changes items: (CodeImporter chunksFromStream: aStream).
	widget openWithSpec	
]

{ #category : #'tool registry' }
StExternalChangesBrowserPresenter class >> registerToolsOn: registry [

	registry register: self as: #changeList 
]

{ #category : #'file service' }
StExternalChangesBrowserPresenter class >> serviceBrowseCSOrSTFile [
	"Answer a service for opening a changelist browser on a file"

	^ (SimpleServiceEntry 
		provider: self 
		label: 'Changelist browser'
		selector: #openOnStream:
		description: 'Open a changelist tool on this file'
		buttonLabel: 'Changes')
		argumentGetter: [ :stream | stream readStream ]
]

{ #category : #'file service' }
StExternalChangesBrowserPresenter class >> services [
	"Answer potential file services associated with this class"

	^ { self serviceBrowseCSOrSTFile }
]

{ #category : #icons }
StExternalChangesBrowserPresenter class >> taskbarIconName [
	"Answer the icon for the receiver in a task bar."

	^#smallSaveIcon
]

{ #category : #menu }
StExternalChangesBrowserPresenter >> buildMenu: aMenu [

	aMenu
		add: 'File in all selected'
		target: self
		selector: #fileIn:
		argumentList: { changes selectedItems }.
	
	aMenu
		addToggle: 'Compare method to current'
		target: self
		selector: #compareToCurrent:
		getStateSelector:nil
		enablementSelector: #canCompareToCurrent
		argumentList: { changes selectedItem }.

	^ aMenu
]

{ #category : #menu }
StExternalChangesBrowserPresenter >> canCompareToCurrent [

	| aMethodDeclaration |
	(changes selectedItems size = 1) ifFalse: [ ^ false ].
	((aMethodDeclaration := changes selectedItem) isMethodDeclaration) ifFalse: [  ^ false ].
	
	( aMethodDeclaration existsBehavior) ifFalse: [ ^ false ].
	^ aMethodDeclaration targetClass includesSelector: aMethodDeclaration methodSelector
	
]

{ #category : #accessing }
StExternalChangesBrowserPresenter >> changeDescription: change [

	^ change description
]

{ #category : #accessing }
StExternalChangesBrowserPresenter >> changeSetName: aFileName [

	changeSet := CodeImporter fileNamed: aFileName.
	changeSet parseChunks.
	changes items: changeSet codeDeclarations.
]

{ #category : #accessing }
StExternalChangesBrowserPresenter >> changes [

	^ changes
]

{ #category : #accessing }
StExternalChangesBrowserPresenter >> codePane [

	^ codePane
]

{ #category : #menu }
StExternalChangesBrowserPresenter >> compareToCurrent: aMethodDeclaration [

	| class sourceString |
	class := aMethodDeclaration targetClass.
	sourceString := (class >> aMethodDeclaration methodSelector) sourceCode.
	UIManager default
		openComparisonFrom: aMethodDeclaration contents
		to: sourceString
		belongingTo: class
		from: aMethodDeclaration
		labeled: 'Current'
		inWindowLabeled: 'Comparison to Current Version'
]

{ #category : #initialization }
StExternalChangesBrowserPresenter >> connectPresenters [
	super connectPresenters.
	changes whenSelectionChangedDo: [ :selection | selection selectedItem  
														ifNotNil: [ codePane text: selection selectedItem contents ] ].
	changes contextMenu: [ :menu :shifted | self buildMenu: menu ].
	selectAllButton action: [ changes selectAll ].
	deselectAllButton action: [ changes resetSelection ].
	fileInSelectedButton action: [ self fileIn: changes selectedItemsSorted ]
]

{ #category : #accessing }
StExternalChangesBrowserPresenter >> deselectAllButton [

	^ deselectAllButton
]

{ #category : #menu }
StExternalChangesBrowserPresenter >> fileIn: aCodeDeclaration [

	aCodeDeclaration do: [:each | each import]
]

{ #category : #accessing }
StExternalChangesBrowserPresenter >> fileInSelectedButton [

	^ fileInSelectedButton
]

{ #category : #initialization }
StExternalChangesBrowserPresenter >> initialExtent [

	^ 500@600
]

{ #category : #initialization }
StExternalChangesBrowserPresenter >> initializePresenters [

	
	changes := self newList.
	changes display: [ :elem | self changeDescription: elem ].
	changes beMultipleSelection.

	selectAllButton := self newButton.
	selectAllButton
		label: 'select all'.

	deselectAllButton := self newButton.
	deselectAllButton
		label: 'deselect all'.
		
	fileInSelectedButton := self newButton.
	fileInSelectedButton
		label: 'file in selected'.

	codePane := self newCode.
]

{ #category : #initialization }
StExternalChangesBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Change Browser'
]

{ #category : #accessing }
StExternalChangesBrowserPresenter >> selectAllButton [

	^ selectAllButton
]
