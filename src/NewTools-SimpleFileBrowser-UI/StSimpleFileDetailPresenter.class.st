"
Present file details
"
Class {
	#name : 'StSimpleFileDetailPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'notebook',
		'selectedFile',
		'page'
	],
	#category : 'NewTools-SimpleFileBrowser-UI-Components',
	#package : 'NewTools-SimpleFileBrowser-UI',
	#tag : 'Components'
}

{ #category : 'specs' }
StSimpleFileDetailPresenter class >> defaultSpec [

	^ SpBoxLayout newLeftToRight	 
		add: #notebook;
		yourself
]

{ #category : 'specs' }
StSimpleFileDetailPresenter class >> open [ 
	<script>
	(self new)
		openWithSpec 
]

{ #category : 'initialization' }
StSimpleFileDetailPresenter >> detailText [

	^self newText
		text: self fileContents;
		yourself
]

{ #category : 'initialization' }
StSimpleFileDetailPresenter >> fileContents [ 

	^ selectedFile asFileReference binaryReadStreamDo: [ :stream |
		(ZnCharacterReadStream on: stream encoding: #null) next: 5000 ]
]

{ #category : 'initialization' }
StSimpleFileDetailPresenter >> fileContentsPage [

	^ SpNotebookPage
		title: 'Preview ' , selectedFile label 
		icon: StSimpleIconCache fileIcon
		provider: self detailText 
		 
]

{ #category : 'accessing' }
StSimpleFileDetailPresenter >> hidePage [

	page ifNotNil: [ 
			notebook removePage: page.
			page := nil ]
]

{ #category : 'initialization' }
StSimpleFileDetailPresenter >> initializePresenters [
	
	notebook := self newNotebook
	
]

{ #category : 'accessing' }
StSimpleFileDetailPresenter >> selectedFile [

	^ selectedFile
]

{ #category : 'accessing' }
StSimpleFileDetailPresenter >> selectedFile: anObject [

	selectedFile := anObject
]

{ #category : 'accessing' }
StSimpleFileDetailPresenter >> showFile: anObject [

	self hidePage.
	selectedFile := anObject.		
	anObject ifNil: [ ^ self ].		
	anObject isFile ifFalse: [ ^ self ]. 
	
	page := self fileContentsPage.
	notebook addPage: page.
	notebook selectPage: page.

			
]
