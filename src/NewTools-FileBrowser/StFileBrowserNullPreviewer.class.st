"
I am the previewer that shows nothing. `StFileBrowserAbstractPreviewer` describes how previewers are created and used.

## Responsibility:

- Accept every entry and build an empty `SpNullPresenter` for it.

## Collaborators:

- `StFileBrowserAbstractPreviewer class>>previewerFor:`: answers me when no previewer matches a file name.

## Public API and Key Messages

- `previewOn: aFileReference`: inherited, always an `SpNullPresenter`.

## Examples

```smalltalk
StFileBrowserNullPreviewer exampleNull.
```
"
Class {
	#name : 'StFileBrowserNullPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'examples' }
StFileBrowserNullPreviewer class >> exampleNull [

	<sampleInstance>
	^ self new
]

{ #category : 'testing' }
StFileBrowserNullPreviewer >> canBeUsedOn: aFileReference [
	^ true
]

{ #category : 'testing' }
StFileBrowserNullPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : 'utilities' }
StFileBrowserNullPreviewer >> previewActionOn: aFileReference [

	^ SpNullPresenter new
]
