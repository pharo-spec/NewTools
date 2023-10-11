Class {
	#name : 'StFBFileFilterTest',
	#superclass : 'StFBAbstractFilterTest',
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'accessing' }
StFBFileFilterTest >> actualClass [
	^ StFBFileFilter
]

{ #category : 'tests' }
StFBFileFilterTest >> testFilterExtensions [
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
StFBFileFilterTest >> testFilterMatching [
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
StFBFileFilterTest >> testFoldersOnly [
	self
		assert: ((filter directoriesOnly: root children) collect: #basename) asSet
		equals: (Set with: 'dir' with: 'dir.ext' with: '.hidden-dir')
]

{ #category : 'tests' }
StFBFileFilterTest >> testHiddenFiles [

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
StFBFileFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: (root children select: #isFile)
]
