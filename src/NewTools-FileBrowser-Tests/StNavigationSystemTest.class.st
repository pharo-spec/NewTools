Class {
	#name : 'StNavigationSystemTest',
	#superclass : 'StFileBrowserTestCase',
	#instVars : [
		'dialog'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'tests' }
StNavigationSystemTest >> fileListAllMustBeFilterByPNGFIlter [
	self
		assert:
			(dialog fileReferenceTable items
				allSatisfy: [ :fileReference | 
					fileReference isDirectory
						or: [ fileReference basename endsWith: '.png' ] ])
]

{ #category : 'running' }
StNavigationSystemTest >> setUp [

	super setUp.
	dialog := StFileNavigationSystemPresenter 
		owner: fileSystemPresenter 
		on: fileSystemModel.
	dialog defaultFolder: root

]

{ #category : 'tests' }
StNavigationSystemTest >> testCustomizationWhenChangeCollectionOfPreviewerShouldBeSet [
	| previewerUtil |
	previewerUtil := StFileBrowserPNGPreviewer new.
	dialog previewer: previewerUtil.
	self assert: dialog previewer equals: previewerUtil
]

{ #category : 'tests' }
StNavigationSystemTest >> testInitializeCurrentPathTextInputShouldSet [
	self assert: dialog currentDirectory fullName equals: dialog currentPathTextInputPresenter entityText text 
]

{ #category : 'tests' }
StNavigationSystemTest >> testInitializeFilterDropListSelectedItemShouldBeDefaultFilter [
	self 
		assert: dialog filtersDropList selectedItem name 
		equals: StVisibleFilter new name
]

{ #category : 'tests' }
StNavigationSystemTest >> testInitializeShouldOnlySeeNotHiddenFile [

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

{ #category : 'tests' }
StNavigationSystemTest >> testOpenFolder [
	self assert: dialog currentDirectory equals: root.
	dialog openFolder: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'
]

{ #category : 'tests' }
StNavigationSystemTest >> testWhenClickAnAfterHistoryButtonIfThereAreHistoryShouldComeBackTheGoodDirectory [
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

{ #category : 'tests' }
StNavigationSystemTest >> testWhenClickAnBeforeHistoryButtonIfThereAreHistoryShouldComeBackToTheLastDirectoryVisited [
	| itemsBefore |
	itemsBefore := dialog fileReferenceTable items.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	dialog fileReferenceTable doActivateAtIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	self assertCollection: (dialog fileReferenceTable items collect: #basename) hasSameElements: {'klm.jpg' . 'klm.png'}.
	dialog previousButton click.
	self assertCollection: dialog fileReferenceTable items hasSameElements: itemsBefore
]

{ #category : 'tests' }
StNavigationSystemTest >> testWhenCurrentDirectoryChangeshouldNewFileDialogOpenOnTheNewDirectory [

	| dirIndex newFileDialog |
	dirIndex := (dialog fileReferenceTable items collect: #basename) indexOf: 'dir'.
	dialog fileReferenceTable selectIndex: dirIndex.
	dialog fileReferenceTable doubleClickAtIndex: dirIndex.
	newFileDialog := StFileNavigationSystemPresenter on: fileSystemModel.
	newFileDialog openOnLastDirectory
		ifTrue: [ self assert: newFileDialog currentDirectory equals: (root / 'dir') asFileReference ]
]

{ #category : 'tests' }
StNavigationSystemTest >> testWhenCustomizeFilterShouldFilterDropListPresenterIncludeIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {StAllFilter new . StJPEGFilter new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self assert: dialog filtersDropList selectedItem name equals: StAllFilter new name.
	self assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : 'tests' }
StNavigationSystemTest >> testWhenCustomizeFilterWithoutDefaultFilterShouldFilterDropListPresenterIncludeDefaultFilterAndSelectIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {StJPEGFilter new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self assert: dialog filtersDropList selectedItem name equals: StAllFilter new name.
	self assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : 'tests' }
StNavigationSystemTest >> testWhenFilesListSelectionChangedAndIsAJPGShouldpreviewContentPresenterIsNotNil [

	| previewerUtil |
	previewerUtil := StFileBrowserJPGPreviewer new.
	dialog previewer: previewerUtil.

	dialog fileReferenceTable selectIndex:
		((dialog fileReferenceTable items collect: #basename) indexOf: 'banana.jpg').
	self assert: dialog selectedEntry basename equals: 'banana.jpg'
]

{ #category : 'tests' }
StNavigationSystemTest >> testWhenOpenADirectoryShouldDisplayHisChildrenFilterByCurrentFilter [
	dialog filtersDropList selectIndex: ((dialog filtersDropList listItems collect: #name) indexOf: StPNGFilter new name).
	self fileListAllMustBeFilterByPNGFIlter.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	dialog fileReferenceTable selectIndex: dialog fileReferenceTable selection selectedIndex.
	dialog fileReferenceTable selectIndex: dialog fileReferenceTable selection selectedIndex.
	self fileListAllMustBeFilterByPNGFIlter
]

{ #category : 'tests' }
StNavigationSystemTest >> testWhenPathTextInputPresenterAcceptShouldChangeFileListWithTheGoodContent [

	dialog currentPathTextInputPresenter pathTextChangedTo:
		(dialog currentPathTextInputPresenter entityText text asPath / 'dir')
			pathString.
	self
		assertCollection:
		(dialog fileReferenceTable items collect: #basename)
		hasSameElements: { 'klm.png'. 'klm.jpg' }
]
