Class {
	#name : 'StFileFilterTest',
	#superclass : 'StAbstractFilterTest',
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'accessing' }
StFileFilterTest >> actualClass [
	^ StFileFilter
]

{ #category : 'tests' }
StFileFilterTest >> testFilterExtensions [
	self
		assert: ((filter files: root children withExtensions: #(aaa)) collect: #basename) asSet
		equals:
			(Set
				with: 'dir'
				with: 'dir.ext'
				with: '.hidden-dir'
				with: 'sth.aaa')
]

{ #category : 'tests' }
StFileFilterTest >> testFilterMatching [
	self
		assert: ((filter files: root children matching: #('*th.e*' '*dd*')) collect: #basename) asSet
		equals:
			(Set
				with: 'dir'
				with: 'dir.ext'
				with: '.hidden-dir'
				with: '.hidden'
				with: 'sth.ext')
]

{ #category : 'tests' }
StFileFilterTest >> testFoldersOnly [
	self
		assert: ((filter directoriesOnly: root children) collect: #basename) asSet
		equals: (Set with: 'dir' with: 'dir.ext' with: '.hidden-dir')
]

{ #category : 'tests' }
StFileFilterTest >> testHiddenFiles [

	self
		assert:
		((filter noHiddenFiles: root children) collect: #basename) asSet
		equals: (Set
				 with: 'dir'
				 with: 'dir.ext'
				 with: 'sth.ext'
				 with: 'sth.aaa'
				 with: 'banana.jpg'
				 with: 'patate.png')
]

{ #category : 'tests' }
StFileFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: (root children select: #isFile)
]
