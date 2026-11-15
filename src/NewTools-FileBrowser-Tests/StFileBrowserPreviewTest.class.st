Class {
	#name : 'StFileBrowserPreviewTest',
	#superclass : 'TestCase',
	#instVars : [
		'previewer'
	],
	#category : 'NewTools-FileBrowser-Tests-Previewers',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Previewers'
}

{ #category : 'helpers' }
StFileBrowserPreviewTest >> memoryFileNamed: aString containing: aContentString [

	| file |
	file := FileSystem memory / aString.
	file writeStreamDo: [ :stream | stream nextPutAll: aContentString ].
	^ file
]

{ #category : 'tests - preview' }
StFileBrowserPreviewTest >> testAdaptivePreviewOfADirectoryIsEmpty [

	| preview |
	preview := StFileBrowserAdaptiveContentPreviewer exampleAdaptive previewOn: (FileSystem memory / 'dir') ensureCreateDirectory.
	self assert: preview class identicalTo: SpNullPresenter
]

{ #category : 'tests - preview' }
StFileBrowserPreviewTest >> testAdaptivePreviewerShowsATextFileAsText [

	| preview |
	preview := StFileBrowserAdaptiveContentPreviewer exampleAdaptive previewOn:
		           (self memoryFileNamed: 'notes.txt' containing: 'hello').
	self assert: preview text equals: 'hello'
]

{ #category : 'tests - preview' }
StFileBrowserPreviewTest >> testConcreteViewerClasses [

	self assertCollection: StFileBrowserAbstractPreviewer concreteViewerClasses hasSameElements: {
			StFileBrowserGIFPreviewer.
			StFileBrowserJPGPreviewer.
			StFileBrowserPNGPreviewer.
			StFileBrowserTextBasedPreviewer }
]

{ #category : 'tests' }
StFileBrowserPreviewTest >> testFindGIFPreviewer [

	self 
		assert: (StFileBrowserAbstractPreviewer previewerFor: '.gif')
		equals: StFileBrowserGIFPreviewer.
		"description: 'It test that the provided parameter should match a PNG previewer'."
		
	self 
		deny: (StFileBrowserAbstractPreviewer previewerFor: '.png')
		equals: StFileBrowserGIFPreviewer.
		"description: 'It test that the provided parameter should not match a JPG previewer'."
]

{ #category : 'tests' }
StFileBrowserPreviewTest >> testFindJPGPreviewer [

	self 
		assert: (StFileBrowserAbstractPreviewer previewerFor: '.jpg')
		equals: StFileBrowserJPGPreviewer.
		"description: 'It test that the provided parameter should match a JPG previewer'."
		
	self 
		deny: (StFileBrowserAbstractPreviewer previewerFor: '.png')
		equals: StFileBrowserJPGPreviewer.
		"description: 'It test that the provided parameter should be an existing file'."
]

{ #category : 'tests' }
StFileBrowserPreviewTest >> testFindPNGPreviewer [

	self 
		assert: (StFileBrowserAbstractPreviewer previewerFor: '.png')
		equals: StFileBrowserPNGPreviewer.
		"description: 'It test that the provided parameter should match a PNG previewer'."
		
	self 
		deny: (StFileBrowserAbstractPreviewer previewerFor: '.jpg')
		equals: StFileBrowserPNGPreviewer.
		"description: 'It test that the provided parameter should not match a JPG previewer'."
]

{ #category : 'tests - preview' }
StFileBrowserPreviewTest >> testImagePreviewerOfATextFileIsEmpty [

	| preview |
	preview := StFileBrowserPNGPreviewer examplePNG previewOn: (self memoryFileNamed: 'notes.txt' containing: 'hello').
	self assert: preview class identicalTo: SpNullPresenter
]

{ #category : 'tests' }
StFileBrowserPreviewTest >> testJPGPPreviewerCanBeUsedOnParameterFileReference [

	previewer := StFileBrowserJPGPreviewer new.
	self assert: (previewer canBeUsedOn: 'pincha.jpg' asFileReference).
]

{ #category : 'tests' }
StFileBrowserPreviewTest >> testJPGPPreviewerCanBeUsedOnParameterString [

	previewer := StFileBrowserJPGPreviewer new.
	self 
		assert: (previewer canBeUsedOn: '.jpg')
		description: 'It test that the previewer matches a provided JPG extension pattern as String'.
		
	self 
		assert: (previewer canBeUsedOn: '.jpeg')
		description: 'It test that the previewer matches a provided JPEG extension pattern as String'.		
]

{ #category : 'tests' }
StFileBrowserPreviewTest >> testPNGPPreviewerCanBeUsedOnParameterFileReference [

	previewer := StFileBrowserPNGPreviewer new.
	self 
		assert: (previewer canBeUsedOn: 'pincha.png' asFileReference)
		description: 'It test that the previewer matches a provided PNG extension pattern as FileReference'.
		
	self 
		deny: (previewer canBeUsedOn: 'pincha.jpg' asFileReference)
		description: 'It test that the previewer does not match a provided JPG extension pattern as FileReference'.		
]

{ #category : 'tests' }
StFileBrowserPreviewTest >> testPNGPreviewerCanBeUsedOnParameterString [

	previewer := StFileBrowserPNGPreviewer new.
	self 
		assert: (previewer canBeUsedOn: '.png')
		description: 'It test that the previewer matches a provided PNG extension pattern as String'.
	
	self deny: (previewer canBeUsedOn: '.jpg')
]

{ #category : 'tests - preview' }
StFileBrowserPreviewTest >> testSampleInstancesAnswerPreviewers [

	{
		StFileBrowserAdaptiveContentPreviewer.
		StFileBrowserGIFPreviewer.
		StFileBrowserJPGPreviewer.
		StFileBrowserPNGPreviewer.
		StFileBrowserTextBasedPreviewer.
		StFileBrowserInspectPreviewer.
		StFileBrowserNullPreviewer } do: [ :class |
			| examples |
			examples := class class methods select: [ :method | method hasPragmaNamed: #sampleInstance ].
			self denyEmpty: examples.
			examples do: [ :method | self assert: (class perform: method selector) class identicalTo: class ] ]
]

{ #category : 'tests' }
StFileBrowserPreviewTest >> testTextPreviewerCanBeUsedOnParameterString [

	previewer := StFileBrowserTextBasedPreviewer new.
	self 
		deny: (previewer canBeUsedOn: '.txt')
		description: 'It test that the provided parameter should be an existing file'.
		
	self 
		deny: (previewer canBeUsedOn: 'non-existant-file-123400.txt')
		description: 'It test that the provided parameter should be an existing file'.
]

{ #category : 'tests - preview' }
StFileBrowserPreviewTest >> testTextPreviewerTruncatesLongFiles [

	| preview |
	preview := StFileBrowserTextBasedPreviewer exampleText previewOn:
		           (self memoryFileNamed: 'long.txt' containing: (String new: 1500 withAll: $a)).
	self assert: (preview text beginsWith: (String new: 1000 withAll: $a)).
	self assert: (preview text endsWith: ' ... truncated ... ')
]
