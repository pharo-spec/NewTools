Class {
	#name : #FDFileFilterTest,
	#superclass : #FDAbstractFilterTest,
	#category : #'NewTools-FileDialog-Tests-UI'
}

{ #category : #accessing }
FDFileFilterTest >> actualClass [
	^ FDFileFilter
]

{ #category : #tests }
FDFileFilterTest >> testFilterExtensions [
	self
		assert: ((filter files: root children withExtensions: #(aaa)) collect: #basename) asSet
		equals:
			(Set
				with: 'dir'
				with: 'dir.ext'
				with: '.hidden-dir'
				with: 'sth.aaa')
]

{ #category : #tests }
FDFileFilterTest >> testFilterMatching [
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

{ #category : #tests }
FDFileFilterTest >> testFoldersOnly [
	self
		assert: ((filter directoriesOnly: root children) collect: #basename) asSet
		equals: (Set with: 'dir' with: 'dir.ext' with: '.hidden-dir')
]

{ #category : #tests }
FDFileFilterTest >> testHiddenFiles [
	self
		assert: ((filter noHiddenFiles: root children) collect: #basename) asSet
		equals:
			(Set
				with: 'dir'
				with: 'dir.ext'
				with: 'sth.ext'
				with: 'sth.aaa')
]

{ #category : #tests }
FDFileFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: (root children select: #isFile)
]
