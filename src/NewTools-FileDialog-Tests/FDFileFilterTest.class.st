Class {
	#name : #FDFileFilterTest,
	#superclass : #FDTest,
	#category : #'NewTools-FileDialog-Tests'
}

{ #category : #tests }
FDFileFilterTest >> testDefaultFilterShouldReturnEveryTimeTrue [
	| beforeFilter defaultFilter |
	beforeFilter := root children.
	defaultFilter := FDDefaultFilter new.
	self
		assert:
			(root children
				select: [ :fileReference | defaultFilter predicate: fileReference ])
		equals: beforeFilter
]

{ #category : #tests }
FDFileFilterTest >> testHiddenFilter [
	| hiddenFilter |
	hiddenFilter := FDHidenFilter new.
	self
		assert:
			((root children select: [ :item | hiddenFilter predicate: item ])
				collect: #basename) asSet
		equals:
			{'sth.ext' . 'banana.jpg' . 'sth.aaa' . 'patate.png' . 'dir.ext'.
			'dir'} asSet
]

{ #category : #tests }
FDFileFilterTest >> testJPGFilterShouldFilterOnlyJPGFile [
	| filterBis |
	filterBis := FDDotJPGFilter new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis predicate: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.jpg') or: [ item isDirectory ] ])
]

{ #category : #tests }
FDFileFilterTest >> testPNGFilterShouldFilterOnlyPNGFile [
	| filterBis |
	filterBis := FDDotPNGFilter new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis predicate: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.png' )or:[ item isDirectory]  ])
]
