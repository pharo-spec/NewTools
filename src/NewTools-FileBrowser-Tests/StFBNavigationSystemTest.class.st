Class {
	#name : #StFBNavigationSystemTest,
	#superclass : #StFBTestCase,
	#instVars : [
		'dialog'
	],
	#category : #'NewTools-FileBrowser-Tests-UI'
}

{ #category : #tests }
StFBNavigationSystemTest >> fileListAllMustBeFilterByPNGFIlter [
	self
		assert:
			(dialog fileReferenceTable items
				allSatisfy: [ :fileReference | 
					fileReference isDirectory
						or: [ fileReference basename endsWith: '.png' ] ])
]

{ #category : #running }
StFBNavigationSystemTest >> setUp [
	super setUp.
	dialog := StFBFileNavigationSystemPresenter new.
	dialog defaultFolder: root
]

{ #category : #tests }
StFBNavigationSystemTest >> testCustomizationWhenChangeCollectionOfPreviewerShouldBeSet [
	| previewerUtil |
	previewerUtil := StFBPNGPreviewer new.
	dialog previewer: previewerUtil.
	self assert: dialog previewer equals: previewerUtil
]

{ #category : #tests }
StFBNavigationSystemTest >> testInitializeCurrentPathTextInputShouldSet [
	self assert: dialog currentDirectory fullName equals: dialog currentPathTextInputPresenter entityText text 
]

{ #category : #tests }
StFBNavigationSystemTest >> testInitializeFilterDropListSelectedItemShouldBeDefaultFilter [
	self assert: dialog filtersDropList selectedItem name equals: StFBVisibleFilter new name
]

{ #category : #tests }
StFBNavigationSystemTest >> testInitializeShouldOnlySeeNotHiddenFile [

	Smalltalk os isWindows ifTrue: [ 
		self skip:
			'Too hard to make file hidden in Windows, do not test for it' ].
	self
		assertCollection:
		(dialog fileReferenceTable items collect: #basename)
		hasSameElements:
			#( 'dir' 'dir.ext' 'banana.jpg' 'patate.png' 'sth.aaa' 'sth.ext' )
				asOrderedCollection
]

{ #category : #tests }
StFBNavigationSystemTest >> testOpenFolder [
	self assert: dialog currentDirectory equals: root.
	dialog openFolder: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'
]

{ #category : #tests }
StFBNavigationSystemTest >> testWhenClickAnAfterHistoryButtonIfThereAreHistoryShouldComeBackTheGoodDirectory [
	| itemsBefore |
	itemsBefore := dialog fileReferenceTable items.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	dialog fileReferenceTable doActivateAtIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	self assertCollection: (dialog fileReferenceTable items collect: #basename) hasSameElements: {'klm.jpg' . 'klm.png'}.
	dialog previousButton click.
	self assertCollection: dialog fileReferenceTable items hasSameElements: itemsBefore.
	dialog nextButton click.
	self assertCollection: (dialog fileReferenceTable items collect: #basename) hasSameElements: {'klm.jpg' . 'klm.png'}
]

{ #category : #tests }
StFBNavigationSystemTest >> testWhenClickAnBeforeHistoryButtonIfThereAreHistoryShouldComeBackToTheLastDirectoryVisited [
	| itemsBefore |
	itemsBefore := dialog fileReferenceTable items.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	dialog fileReferenceTable doActivateAtIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	self assertCollection: (dialog fileReferenceTable items collect: #basename) hasSameElements: {'klm.jpg' . 'klm.png'}.
	dialog previousButton click.
	self assertCollection: dialog fileReferenceTable items hasSameElements: itemsBefore
]

{ #category : #tests }
StFBNavigationSystemTest >> testWhenCurrentDirectoryChangeshouldNewFileDialogOpenOnTheNewDirectory [
	| dirIndex newFileDialog |
	dirIndex := (dialog fileReferenceTable items collect: #basename) indexOf: 'dir'.
	dialog fileReferenceTable selectIndex: dirIndex.
	dialog fileReferenceTable doubleClickAtIndex: dirIndex.
	newFileDialog := StFBFileNavigationSystemPresenter new.
	self assert: newFileDialog currentDirectory equals: (root / 'dir') asFileReference
]

{ #category : #tests }
StFBNavigationSystemTest >> testWhenCustomizeFilterShouldFilterDropListPresenterIncludeIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {StFBAllFilter new . StFBJPEGFilter new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self assert: dialog filtersDropList selectedItem name equals: StFBAllFilter new name.
	self assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : #tests }
StFBNavigationSystemTest >> testWhenCustomizeFilterWithoutDefaultFilterShouldFilterDropListPresenterIncludeDefaultFilterAndSelectIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {StFBJPEGFilter new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self assert: dialog filtersDropList selectedItem name equals: StFBAllFilter new name.
	self assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : #tests }
StFBNavigationSystemTest >> testWhenFilesListSelectionChangedAndIsAJPGShouldpreviewContentPresenterIsNotNil [

	| previewerUtil |
	previewerUtil := StFBJPGPreviewer new.
	dialog previewer: previewerUtil.

	dialog fileReferenceTable selectIndex:
		((dialog fileReferenceTable items collect: #basename) indexOf:
			 'banana.jpg').
	self assert: dialog selectedEntry basename equals: 'banana.jpg'
]

{ #category : #tests }
StFBNavigationSystemTest >> testWhenOpenADirectoryShouldDisplayHisChildrenFilterByCurrentFilter [
	dialog filtersDropList selectIndex: ((dialog filtersDropList listItems collect: #name) indexOf: StFBPNGFilter new name).
	self fileListAllMustBeFilterByPNGFIlter.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	dialog fileReferenceTable selectIndex: dialog fileReferenceTable selection selectedIndex.
	dialog fileReferenceTable selectIndex: dialog fileReferenceTable selection selectedIndex.
	self fileListAllMustBeFilterByPNGFIlter
]

{ #category : #tests }
StFBNavigationSystemTest >> testWhenPathTextInputPresenterAcceptShouldChangeFileListWithTheGoodContent [

	dialog currentPathTextInputPresenter pathTextChangedTo:
		(dialog currentPathTextInputPresenter entityText text asPath / 'dir')
			pathString.
	self
		assertCollection:
		(dialog fileReferenceTable items collect: #basename)
		hasSameElements: { 'klm.png'. 'klm.jpg' }
]
