Class {
	#name : 'StBreadcrumbPresenterTest',
	#superclass : 'StFileBrowserTestCase',
	#instVars : [
		'breadcrumb'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'helpers' }
StBreadcrumbPresenterTest >> linkLabeled: aString [

	^ self links detect: [ :each | each label = aString ]
]

{ #category : 'helpers' }
StBreadcrumbPresenterTest >> links [

	^ breadcrumb path presenters select: [ :each | each isKindOf: SpLinkPresenter ]
]

{ #category : 'helpers' }
StBreadcrumbPresenterTest >> openedPathWidget [

	breadcrumb open.
	self currentWorld doOneCycle.
	^ breadcrumb path adapter widget
]

{ #category : 'helpers' }
StBreadcrumbPresenterTest >> pressInTextField: aCharacter [

	breadcrumb pathTextInput adapter
		keyDown: aCharacter
		shift: false
		meta: false
		control: false
		option: false
]

{ #category : 'running' }
StBreadcrumbPresenterTest >> setUp [

	super setUp.
	breadcrumb := StPathBreadcrumbPresenter new
]

{ #category : 'helpers' }
StBreadcrumbPresenterTest >> shownTexts [

	^ (breadcrumb path adapter widget allMorphs select: [ :each | each isKindOf: StringMorph ])
		  collect: [ :each | each contents asString ]
		  as: Array
]

{ #category : 'running' }
StBreadcrumbPresenterTest >> tearDown [

	breadcrumb withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testAcceptingAFileKeepsEditing [

	| chosen |
	chosen := nil.
	breadcrumb whenFolderChosenDo: [ :folder | chosen := folder ].
	breadcrumb beginEditing.
	breadcrumb acceptPath: (root / 'sth.ext') fullName.
	self assert: breadcrumb isEditing.
	self assert: chosen isNil
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testAcceptingAMissingFolderKeepsEditing [

	| chosen |
	chosen := nil.
	breadcrumb currentDirectory: root.
	breadcrumb whenFolderChosenDo: [ :folder | chosen := folder ].
	breadcrumb beginEditing.
	breadcrumb acceptPath: (root / 'missing') fullName.
	self assert: breadcrumb isEditing.
	self assert: chosen isNil.
	self assert: breadcrumb currentDirectory equals: root
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testAcceptingAnExistingFolderAnnouncesIt [

	| chosen |
	chosen := nil.
	breadcrumb whenFolderChosenDo: [ :folder | chosen := folder ].
	breadcrumb beginEditing.
	breadcrumb acceptPath: (root / 'dir') fullName.
	self assert: chosen equals: root / 'dir'
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testAcceptingAnExistingFolderStopsEditing [

	breadcrumb beginEditing.
	breadcrumb acceptPath: (root / 'dir') fullName.
	self deny: breadcrumb isEditing.
	self assert: breadcrumb currentDirectory equals: root / 'dir'
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testCancelEditingRestoresTheCurrentDirectory [

	breadcrumb currentDirectory: root.
	breadcrumb beginEditing.
	breadcrumb pathTextInput text: 'some/thing/typed'.
	breadcrumb cancelEditing.
	self deny: breadcrumb isEditing.
	self assert: breadcrumb pathTextInput text equals: root fullName
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testChangingTheCurrentDirectoryKeepsTheWidget [

	| widget |
	breadcrumb currentDirectory: root.
	widget := self openedPathWidget.
	breadcrumb currentDirectory: root / 'dir'.
	self assert: breadcrumb path adapter widget identicalTo: widget
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testChangingTheCurrentDirectoryUpdatesTheShownLinks [

	breadcrumb currentDirectory: root.
	self openedPathWidget.
	breadcrumb currentDirectory: root / 'dir'.
	self currentWorld doOneCycle.
	self assert: (self shownTexts last: 3) equals: #( 'fd-test' '/' 'dir' )
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testClickingALinkAnnouncesItsFolder [

	| chosen |
	chosen := nil.
	breadcrumb currentDirectory: root / 'dir'.
	breadcrumb whenFolderChosenDo: [ :folder | chosen := folder ].
	(self linkLabeled: 'fd-test') performAction.
	self assert: chosen equals: root
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testClickingALinkShowsItsFolder [

	breadcrumb currentDirectory: root / 'dir'.
	(self linkLabeled: 'fd-test') performAction.
	self assert: breadcrumb currentDirectory equals: root
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testCurrentDirectory [

	breadcrumb currentDirectory: root.
	self assert: breadcrumb currentDirectory equals: root
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testEditButtonStartsEditing [

	breadcrumb editButton click.
	self assert: breadcrumb isEditing
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testEditButtonWhileEditingAcceptsTheTypedPath [

	breadcrumb currentDirectory: root.
	breadcrumb beginEditing.
	breadcrumb pathTextInput text: (root / 'dir') fullName.
	breadcrumb editButton click.
	self assert: breadcrumb currentDirectory equals: root / 'dir'.
	self deny: breadcrumb isEditing
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testEditingKeepsTheWidget [

	| widget |
	breadcrumb currentDirectory: root.
	breadcrumb open.
	self currentWorld doOneCycle.
	widget := breadcrumb adapter widget.
	breadcrumb beginEditing.
	self assert: breadcrumb adapter widget identicalTo: widget
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testEditingShowsTheTextFieldInsteadOfTheLinks [

	breadcrumb beginEditing.
	self assert: (breadcrumb layout presenters includes: breadcrumb pathTextInput).
	self deny: (breadcrumb layout presenters includes: breadcrumb path)
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testIsNotEditingAtFirst [

	self deny: breadcrumb isEditing
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testLinksEndWithTheCurrentDirectory [

	breadcrumb currentDirectory: root / 'dir'.
	self assert: ((self links last: 2) collect: [ :each | each label ] as: Array) equals: #( 'fd-test' 'dir' )
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testNotEditingShowsTheLinksInsteadOfTheTextField [

	self assert: (breadcrumb layout presenters includes: breadcrumb path).
	self deny: (breadcrumb layout presenters includes: breadcrumb pathTextInput)
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testPressingReturnAcceptsTheTypedPath [

	breadcrumb currentDirectory: root.
	breadcrumb open.
	breadcrumb beginEditing.
	breadcrumb pathTextInput text: (root / 'dir') fullName.
	self pressInTextField: Character cr.
	self deny: breadcrumb isEditing.
	self assert: breadcrumb currentDirectory equals: root / 'dir'
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testRoot [
	"This test does not work on windows because root works differently on windows. We should review if this test makes sense on windows or not."

	OSPlatform current isWindows ifTrue: [ self skipOnPharoCITestingEnvironment ].
	breadcrumb currentDirectory: FileLocator root.
	breadcrumb open.
	self assert: breadcrumb path presenters size equals: 1
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testTextFieldShowsTheCurrentDirectory [

	breadcrumb currentDirectory: root.
	self assert: breadcrumb pathTextInput text equals: root fullName
]
