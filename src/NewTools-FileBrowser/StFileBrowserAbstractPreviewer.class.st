"
I am the root of the previewers of the file dialogs. A previewer builds the presenter shown in the preview pane for the selected file: a picture for an image file, the first characters for a text file, an inspector, or nothing.

## Life cycle: who creates the previewers and who uses them

1. **The navigation presenter has one previewer.** `StFileNavigationSystemPresenter>>previewer` lazily creates its `defaultPreviewer`, a `StFileBrowserAdaptiveContentPreviewer`. The code opening a dialog may choose another one with `aDialog previewer: StFileBrowserInspectPreviewer new` (`StFileDialogPresenter>>previewer:`).
2. **Each selection is previewed in the background.** When the selection of the file table changes, `StFileNavigationSystemPresenter>>filesListAction` stops the previous preview process and forks a new one that sends `previewOn:` with the selected `FileReference`.
3. **I build the presenter.** `previewOn:` answers the presenter of `previewActionOn:` when `canBeUsedOn:` accepts the file (by default, when one of its MIME types, found from its extension, satisfies `matchingMimeType:`), and an empty `SpNullPresenter` otherwise or when anything goes wrong.
4. **The preview pane shows it.** The presenter is given to the `StNoteBookPreviewerPresenter` of the navigation presenter (`pageContent:`).

## Responsibility:

- Tell whether I can preview a file (`canBeUsedOn:`, `matchingMimeType:`).
- Build the presenter previewing a file (`previewActionOn:`), never failing (`previewOn:`).
- Know the previewers that read the file contents (`concreteViewerClasses`).

## Collaborators:

- `StFileNavigationSystemPresenter`: keeps a previewer and asks it to preview the selected file.
- `StNoteBookPreviewerPresenter`: shows the presenter I build.
- `ZnMimeType`: the MIME types of the file, from its extension.
- `SpImagePresenter`, `SpTextPresenter`, `SpNullPresenter`, `StObjectInspectorPresenter`: the presenters my subclasses build.

## Public API and Key Messages

- `previewOn: aFileReference`: the presenter to show, an `SpNullPresenter` when I cannot preview the file.
- `canBeUsedOn: aFileReferenceOrString`: whether I can preview the file.
- `matchingMimeType: aZnMimeType`: whether I handle that MIME type. Subclasses define it.
- `previewActionOn: aFileReference`: builds the presenter. Subclasses define it.
- `StFileBrowserAbstractPreviewer concreteViewerClasses`: the GIF, JPG, PNG and text previewers.
- `StFileBrowserAbstractPreviewer previewerFor: aString`: the first of them that can preview a file name.

## Examples

```smalltalk
StFileBrowserAbstractPreviewer scriptPreviewChangesFile.
```

It opens the preview pane on the changes file of the image. `StFileBrowserPreviewTest` checks what the previewers show.
"
Class {
	#name : 'StFileBrowserAbstractPreviewer',
	#superclass : 'Object',
	#category : 'NewTools-FileBrowser-Previewers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Previewers'
}

{ #category : 'accessing' }
StFileBrowserAbstractPreviewer class >> concreteViewerClasses [
	"Answer a <Collection> of receiver's subclasses which can actually read a <Stream> from a given file"
	
	^ StFileBrowserAbstractPreviewer subclasses difference: { 
			StFileBrowserInspectPreviewer . 
			StFileBrowserNullPreviewer .
			StFileBrowserAdaptiveContentPreviewer }
]

{ #category : 'testing' }
StFileBrowserAbstractPreviewer class >> isAbstract [
	^ self = StFileBrowserAbstractPreviewer
]

{ #category : 'accessing' }
StFileBrowserAbstractPreviewer class >> previewerFor: anExtensionString [
	"Answer a receiver's subclass matching anExtensionString or a null previewer <Class> if not found"
	
	^ self concreteViewerClasses
			detect: [ : class | class new canBeUsedOn: anExtensionString ]
			ifNone: [ StFileBrowserNullPreviewer new ]
]

{ #category : 'script' }
StFileBrowserAbstractPreviewer class >> scriptPreviewChangesFile [
	"Opens the preview pane of the file dialogs on the changes file of the image, as a dialog shows it when the file is selected: the adaptive previewer finds no image previewer for it and shows its first characters as text."

	<example>
	| notebook |
	notebook := StNoteBookPreviewerPresenter new.
	notebook pageContent: (StFileBrowserAdaptiveContentPreviewer new previewOn: FileLocator changes asFileReference).
	^ notebook open
		  title: 'Preview of the changes file';
		  yourself
]

{ #category : 'private' }
StFileBrowserAbstractPreviewer >> basicPreviewOn: aFileReference [
	"Answer a <SpPresenter> suitable to preview the contents of aFileReference"
	
	^ (self canBeUsedOn: aFileReference)
		ifTrue: [ self previewActionOn: aFileReference ]
		ifFalse: [ SpNullPresenter new ]
]

{ #category : 'testing' }
StFileBrowserAbstractPreviewer >> canBeUsedOn: aFileReferenceOrString [

	aFileReferenceOrString ifNil: [ ^ false ].
	aFileReferenceOrString asFileReference mimeTypes ifNil: [ ^ false ] ifNotNil: [ :items | 
		^ items anySatisfy: [ :aZnMimeType | 
			  self matchingMimeType: aZnMimeType ] ]
]

{ #category : 'templateMethod' }
StFileBrowserAbstractPreviewer >> concreteViewerClasses [
	"See class side comment"

	^ self class concreteViewerClasses
]

{ #category : 'testing' }
StFileBrowserAbstractPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	^ self subclassResponsibility 
]

{ #category : 'templateMethod' }
StFileBrowserAbstractPreviewer >> previewActionOn: aFileReference [
	^ self subclassResponsibility
]

{ #category : 'utilities' }
StFileBrowserAbstractPreviewer >> previewOn: aFileReference [

	^ [ self basicPreviewOn: aFileReference ]
		  on: Exception
		  do: [ SpNullPresenter new ]
]
