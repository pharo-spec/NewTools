"
I preview any entry with an inspector on its `FileReference`. `StFileBrowserAbstractPreviewer` describes how previewers are created and used; the adaptive previewer never chooses me, so the code opening a dialog must ask for me.

## Responsibility:

- Accept every entry, file or folder (`canBeUsedOn:` is always true).
- Build an inspector on the `FileReference` of the entry.

## Collaborators:

- `StFileDialogPresenter>>previewer:`: the code opening a dialog gives me, as `StOpenFilePresenter class>>#examplePreviewer` does.
- `StObjectInspectorPresenter`: the presenter I build.

## Public API and Key Messages

- `previewOn: aFileReference`: inherited.

## Examples

```smalltalk
StFileBrowserInspectPreviewer exampleInspect.
```
"
Class {
	#name : 'StFileBrowserInspectPreviewer',
	#superclass : 'StFileBrowserAbstractPreviewer',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'examples' }
StFileBrowserInspectPreviewer class >> exampleInspect [

	<sampleInstance>
	^ self new
]

{ #category : 'testing' }
StFileBrowserInspectPreviewer >> canBeUsedOn: aFileReference [
	^ true
]

{ #category : 'testing' }
StFileBrowserInspectPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ true
]

{ #category : 'templateMethod' }
StFileBrowserInspectPreviewer >> previewActionOn: aFileReference [
	^ StObjectInspectorPresenter onObject: aFileReference
]
