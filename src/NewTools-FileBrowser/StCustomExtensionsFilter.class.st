"
I am an extension filter whose extensions and name are given when I am created. Use me to make a file dialog list only the files with your own extensions, for example Pharo images or Microdown documents. `StFileBrowserAbstractFilter` and `StExtensionsFilter` describe how filters are used; here is what is specific to me.

## Responsibility:

- Know the extensions to keep and the basename to display.
- Answer a basename made from the extensions when none is given.

## Collaborators:

- `StFileDialogPresenter`: creates me in `extensions:` and `extensions:named:`, e.g. `StOpenFilePresenter new extensions: #( 'md' ) named: 'Microdown files'`.
- `SpMorphicBackend>>newFileDialogFor:` and the `UITheme` file services: create me from the extensions they receive.
- `StFileNavigationSystemPresenter`: I am not a default filter (`canBeDefault` is false), so it adds me first to its drop list.

## Public API and Key Messages

- `StCustomExtensionsFilter extensions: aCollection`: a filter named after its extensions.
- `StCustomExtensionsFilter extensions: aCollection basename: aString`: a filter with a chosen name.

## Examples

```smalltalk
StCustomExtensionsFilter examplePharoImages.
```

It answers a filter named 'Pharo images (*.image,*.changes)' that keeps `Pharo.image` and `Pharo.changes` (checked by `StCustomExtensionsFilterTest`).

## Internal Representation

- `extensions`: the collection of extension strings, empty by default.
- `basename`: the displayed name; set from the extensions by `extensions:` when nil, and shown as '-' when still nil.
"
Class {
	#name : 'StCustomExtensionsFilter',
	#superclass : 'StExtensionsFilter',
	#instVars : [
		'extensions',
		'basename'
	],
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'testing' }
StCustomExtensionsFilter class >> canBeDefault [

	^ false
]

{ #category : 'examples' }
StCustomExtensionsFilter class >> examplePharoImages [

	<sampleInstance>
	^ self extensions: #( 'image' 'changes' ) basename: 'Pharo images'
]

{ #category : 'accessing - Class' }
StCustomExtensionsFilter class >> extensions: aCollection [

	^ self new
		  extensions: aCollection;
		  yourself
]

{ #category : 'accessing - Class' }
StCustomExtensionsFilter class >> extensions: aCollection basename: aString [

	^ self new
		  basename: aString;
		  extensions: aCollection;
		  yourself
]

{ #category : 'accessing' }
StCustomExtensionsFilter class >> priority [
	^ 20
]

{ #category : 'accessing' }
StCustomExtensionsFilter >> basename [

	^ basename ifNil: [ '-' ]
]

{ #category : 'accessing' }
StCustomExtensionsFilter >> basename: aString [

	basename := aString
]

{ #category : 'accessing' }
StCustomExtensionsFilter >> extensions [

	^ extensions
]

{ #category : 'accessing' }
StCustomExtensionsFilter >> extensions: aCollection [

	extensions := aCollection.
	basename ifNil: [ basename := extensions joinUsing: ', ' ]
]

{ #category : 'initialization' }
StCustomExtensionsFilter >> initialize [

	super initialize.
	extensions := #(  )
]
