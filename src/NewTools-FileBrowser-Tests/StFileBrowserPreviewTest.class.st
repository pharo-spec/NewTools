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
