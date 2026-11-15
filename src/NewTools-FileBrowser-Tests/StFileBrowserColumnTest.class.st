"
I test the columns of the file table of the file dialogs (`StFileBrowserAbstractColumn` and its subclasses).

## Responsibility:

- Check the order of the columns and the columns a file dialog shows by default.
- Check that the icon and name columns are always shown.
- Check what the name, size and date columns display.

## Collaborators:

- `StFileBrowserAbstractColumn` and its subclasses: the column classes under test.
- `StFileNavigationSystemPresenter` and `StFileSystemPresenter`: the presenters whose file table uses the columns.
"
Class {
	#name : 'StFileBrowserColumnTest',
	#superclass : 'TestCase',
	#category : 'NewTools-FileBrowser-Tests-Columns',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Columns'
}

{ #category : 'tests' }
StFileBrowserColumnTest >> testColumnsAreSortedByPriority [

	self
		assert: (StFileBrowserAbstractColumn columns collect: [ :each | each title ] as: Array)
		equals: #( '' 'Name' 'Date Modified' 'Date Created' 'Date Last Opened' 'Size' 'Rights' )
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testDateFormat [

	self
		assert: (StFileBrowserDateColumn formatOn: (DateAndTime
					  year: 2026
					  month: 11
					  day: 5
					  hour: 9
					  minute: 7
					  second: 0))
		equals: '5 Nov 2026 09:07'
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testFileDialogsShowTheDefaultColumns [

	self
		assert: (self titlesOfFileTableOf: (StFileSystemPresenter on: StFileSystemModel new) fileNavigationSystem)
		equals: #( '' 'Name' 'Date Modified' 'Size' 'Rights' )
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testIconAndNameColumnsAreAlwaysShown [

	| navigation |
	navigation := StFileNavigationSystemPresenter on: StFileSystemModel new.
	navigation columns: { StFileBrowserSizeColumn }.
	self assert: (self titlesOfFileTableOf: navigation) equals: #( '' 'Name' 'Size' )
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testIconColumnIsAnImageColumn [

	self assert: StFileBrowserIconColumn column class identicalTo: SpImageTableColumn.
	self assert: StFileBrowserSizeColumn column class identicalTo: SpStringTableColumn
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testMissingDateFormat [

	self assert: (StFileBrowserDateColumn formatOn: nil) equals: 'N/A'
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testMissingSizeFormat [

	self assert: (StFileBrowserSizeColumn formatOn: nil) equals: 'N/A'
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testNameColumnShowsTheBasename [

	self assert: (StFileBrowserNameColumn evaluateOn: 'my/path/something.exe' asFileReference) equals: 'something.exe'
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testSizeFormat [

	self assert: (StFileBrowserSizeColumn formatOn: 1500) equals: '1.50 kB'
]

{ #category : 'tests' }
StFileBrowserColumnTest >> testSizeOfADirectoryIsZero [

	| directory |
	directory := (FileSystem memory / 'dir') ensureCreateDirectory.
	self assert: (StFileBrowserSizeColumn evaluateOn: directory) equals: 0
]

{ #category : 'helpers' }
StFileBrowserColumnTest >> titlesOfFileTableOf: aNavigationPresenter [
	"Answer the titles of the columns of the file table. SpEasyColumnViewPresenter does not answer its columns, so go through its content view."

	^ aNavigationPresenter fileReferenceTable contentView columns collect: [ :each | each title ] as: Array
]
