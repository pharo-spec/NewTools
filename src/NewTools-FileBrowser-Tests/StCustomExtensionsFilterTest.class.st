"
I test `StCustomExtensionsFilter`, the extension filter built from the extensions given to a file dialog.

## Responsibility:

- Check that a custom filter keeps the files with its extensions and rejects the others.
- Check the name it displays in the dialog drop list, with and without a given basename.
- Check, through the inherited test, that its class-side examples answer custom filters.

## Collaborators:

- `StCustomExtensionsFilter`: the class under test, built through `StCustomExtensionsFilter class >> #examplePharoImages`.
- `StAbstractFilterTest`: my superclass gives the file fixtures and the example test.
"
Class {
	#name : 'StCustomExtensionsFilterTest',
	#superclass : 'StExtensionsFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StCustomExtensionsFilterTest >> actualClass [

	^ StCustomExtensionsFilter
]

{ #category : 'tests' }
StCustomExtensionsFilterTest >> testName [

	self assert: StCustomExtensionsFilter examplePharoImages name equals: 'Pharo images (*.image,*.changes)'
]

{ #category : 'tests' }
StCustomExtensionsFilterTest >> testNameWithoutBasename [

	self assert: (StCustomExtensionsFilter extensions: #( 'md' )) name equals: 'md (*.md)'
]

{ #category : 'tests' }
StCustomExtensionsFilterTest >> testPredicate [

	filter := StCustomExtensionsFilter examplePharoImages.
	self assert: (filter predicate: (self fileNamed: 'Pharo.image')).
	self assert: (filter predicate: (self fileNamed: 'Pharo.changes')).
	self deny: (filter predicate: (self fileNamed: 'image.png'))
]
