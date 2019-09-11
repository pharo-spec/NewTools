Class {
	#name : #FDNavigationSystemTest,
	#superclass : #FDTestCase,
	#instVars : [
		'dialog'
	],
	#category : #'NewTools-FileDialog-Tests-UI'
}

{ #category : #tests }
FDNavigationSystemTest >> fileListAllMustBeFilterByPNGFIlter [
	self
		assert:
			(dialog fileReferenceTable items
				allSatisfy: [ :fileReference | 
					fileReference isDirectory
						or: [ fileReference basename endsWith: '.png' ] ])
]

{ #category : #running }
FDNavigationSystemTest >> setUp [
	super setUp.
	dialog := FDFileNavigationSystemPresenter new.
	dialog defaultFolder: root
]

{ #category : #tests }
FDNavigationSystemTest >> testCustomizationWhenChangeCollectionOfPreviewerShouldBeSet [
	| previewerUtil |
	previewerUtil := FDPNGPreviewer new.
	dialog previewer: previewerUtil.
	self assert: dialog previewer equals: previewerUtil
]

{ #category : #tests }
FDNavigationSystemTest >> testInitializeCurrentPathTextInputShouldSet [
	self assert: dialog currentDirectory fullName equals: dialog currentPathTextInputPresenter entityText text 
]

{ #category : #tests }
FDNavigationSystemTest >> testInitializeFilterDropListSelectedItemShouldBeDefaultFilter [
	self assert: dialog filtersDropList selectedItem name equals: FDNilFilter new name
]

{ #category : #tests }
FDNavigationSystemTest >> testInitializeShouldOnlySeeNotHiddenFile [
	self
		assertCollection: (dialog fileReferenceTable items collect: #basename)
		hasSameElements: #('dir' 'dir.ext' 'banana.jpg' 'patate.png' 'sth.aaa' 'sth.ext') asOrderedCollection
]

{ #category : #tests }
FDNavigationSystemTest >> testOpenFolder [
	self assert: dialog currentDirectory equals: root.
	dialog openFolder: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'
]

{ #category : #tests }
FDNavigationSystemTest >> testWhenClickAnAfterHistoryButtonIfThereAreHistoryShouldComeBackTheGoodDirectory [
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
FDNavigationSystemTest >> testWhenClickAnBeforeHistoryButtonIfThereAreHistoryShouldComeBackToTheLastDirectoryVisited [
	| itemsBefore |
	itemsBefore := dialog fileReferenceTable items.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	dialog fileReferenceTable doActivateAtIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	self assertCollection: (dialog fileReferenceTable items collect: #basename) hasSameElements: {'klm.jpg' . 'klm.png'}.
	dialog previousButton click.
	self assertCollection: dialog fileReferenceTable items hasSameElements: itemsBefore
]

{ #category : #tests }
FDNavigationSystemTest >> testWhenCurrentDirectoryChangeshouldNewFileDialogOpenOnTheNewDirectory [
	| dirIndex newFileDialog |
	dirIndex := (dialog fileReferenceTable items collect: #basename) indexOf: 'dir'.
	dialog fileReferenceTable selectIndex: dirIndex.
	dialog fileReferenceTable doubleClickAtIndex: dirIndex.
	newFileDialog := FDFileNavigationSystemPresenter new.
	self assert: newFileDialog currentDirectory equals: (root / 'dir') asFileReference
]

{ #category : #tests }
FDNavigationSystemTest >> testWhenCustomizeFilterShouldFilterDropListPresenterIncludeIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {FDNilFilter new . FDJPEGFilter new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self assert: dialog filtersDropList selectedItem name equals: FDNilFilter new name.
	self assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : #tests }
FDNavigationSystemTest >> testWhenCustomizeFilterWithoutDefaultFilterShouldFilterDropListPresenterIncludeDefaultFilterAndSelectIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {FDJPEGFilter new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self assert: dialog filtersDropList selectedItem name equals: FDNilFilter new name.
	self assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : #tests }
FDNavigationSystemTest >> testWhenFilesListSelectionChangedAndIsAPNGShouldpreviewContentPresenterIsNotNil [
	| previewerUtil |
	previewerUtil := FDPNGPreviewer new.
	dialog previewer: previewerUtil.
	self
		should: [ "raise an error because banane.jpg don't respect the jpg format"
			dialog fileReferenceTable
				selectIndex:
					((dialog fileReferenceTable items collect: #basename)
						indexOf: 'patate.png') ]
		raise: Error.
	self
		assert: dialog selectedEntry basename
		equals: 'patate.png'
]

{ #category : #tests }
FDNavigationSystemTest >> testWhenOpenADirectoryShouldDisplayHisChildrenFilterByCurrentFilter [
	dialog filtersDropList selectedIndex: ((dialog filtersDropList listItems collect: #name) indexOf: FDPNGFilter new name).
	self fileListAllMustBeFilterByPNGFIlter.
	dialog fileReferenceTable selectIndex: ((dialog fileReferenceTable items collect: #basename) indexOf: 'dir').
	dialog fileReferenceTable selectIndex: dialog fileReferenceTable selection selectedIndex.
	dialog fileReferenceTable selectIndex: dialog fileReferenceTable selection selectedIndex.
	self fileListAllMustBeFilterByPNGFIlter
]

{ #category : #tests }
FDNavigationSystemTest >> testWhenPathTextInputPresenterAcceptShouldChangeFileListWithTheGoodContent [
	dialog currentPathTextInputPresenter entityText text: dialog currentPathTextInputPresenter entityText text , '/dir/'.
	dialog currentPathTextInputPresenter entityText accept.
	self assertCollection: (dialog fileReferenceTable items collect: #basename) hasSameElements: {'klm.png' . 'klm.jpg'}
]

{ #category : #tests }
FDNavigationSystemTest >> testWhenToggleShowHiddenFileShouldHiddenFileAppear [
	dialog toggleHiddenFiles.
	self
		assertCollection: (dialog fileReferenceTable items collect: #basename) asSet
		hasSameElements: #('.hidden-dir' 'dir' 'dir.ext' '.hidden' 'banana.jpg' 'patate.png' 'sth.aaa' 'sth.ext')
]
