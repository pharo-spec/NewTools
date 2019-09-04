"
My responsibility is to provide dialog for SAVING files.
"
Class {
	#name : #FDSaveFileDialog,
	#superclass : #FDFileDialogPresenter,
	#instVars : [
		'extensionMather'
	],
	#classVars : [
		'Matcher'
	],
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #examples }
FDSaveFileDialog class >> example [ 	
	<example>
		^ self new openDialogWithSpec
]

{ #category : #'as yet unclassified' }
FDSaveFileDialog class >> exampleExtension [
	<example>
	^ self extension: '*.jpg'
]

{ #category : #accessing }
FDSaveFileDialog class >> extension: aExtensionMatcher [
	"example 
		you want to save png File 
			FDSaveFileDialog extension: 'jpg'
	"

	^ self new
		extension: aExtensionMatcher;
		openDialogWithSpec;
		yourself
]

{ #category : #'class initialization' }
FDSaveFileDialog class >> initialize [ 
	Matcher := '*'
]

{ #category : #initialization }
FDSaveFileDialog >> connectPresenters [
	| ec |
	super connectPresenters.
	(ec := EntryCompletion new)
		dataSourceBlock: [ :text | fileNavigationSystem currentDirectory children collect: #basename ];
		filterBlock: [ :opt :text |opt beginsWith: text ].
	fileNavigationSystem nameText entryCompletion: ec
]

{ #category : #'api-customization' }
FDSaveFileDialog >> extension: anExtensionMatcher [
	extensionMather := anExtensionMatcher
]

{ #category : #api }
FDSaveFileDialog >> initialTitle [
	^ 'Save As'
]

{ #category : #initialization }
FDSaveFileDialog >> initialize [
	super initialize.
	extensionMather := Matcher
]

{ #category : #accessing }
FDSaveFileDialog >> selectedEntry [
	| entry proceed |
	entry := fileNavigationSystem currentDirectory /fileNavigationSystem nameText text.
	(fileNavigationSystem nameText text includes: extensionMather)
		ifFalse: [ entry := entry
				, ((extensionMather copyReplaceAll: '*' with: '') ) ].
	proceed := false.
	entry exists
		ifTrue: [ proceed := UIManager default
				proceed:
					('File named "{1}" already exists. Do you want to overwrite it?'
						format: {entry printString}) ].
	^ proceed
		ifTrue: [ entry ]
		ifFalse: [ nil ]
]
