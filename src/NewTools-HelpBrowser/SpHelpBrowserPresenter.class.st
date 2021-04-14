"
I'm the equivalent of the old HelpBrowser but written in Spec2.
I manage doc that are expressed as methods of certain classes but contrary to the old 
help browser I managed documentation written using Microdown.
"
Class {
	#name : #SpHelpBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'loadedTopicList',
		'helpText',
		'textOutput',
		'syntaxHelper',
		'textInput',
		'helpTopicCache',
		'rootTopic'
	],
	#category : #'NewTools-HelpBrowser'
}

{ #category : #specs }
SpHelpBrowserPresenter class >> defaultSpec [

	 ^ SpBoxLayout newTopToBottom
			add: (SpPanedLayout newLeftToRight
				add: #loadedTopicList;
				add: #textOutput;
				yourself);
			yourself
]

{ #category : #examples }
SpHelpBrowserPresenter class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #examples }
SpHelpBrowserPresenter class >> openOn: aHelpTopic [
	"Open the receiver on the given help topic or any other object that can be transformed into
	 a help topic by sending #asHelpTopic."
	"SpHelpBrowser openOn: SystemHelp"
	
	^self new
		rootTopic: aHelpTopic;
		openWithSpec;
		yourself
]

{ #category : #initialization }
SpHelpBrowserPresenter >> connectPresenters [
 
	loadedTopicList
		whenSelectionChangedDo: [ :selection | 
					| text |
					text := selection selectedItem contents.
					text ifNotNil: [ self render: text ]].
]

{ #category : #utils }
SpHelpBrowserPresenter >> dummyHelp [

	^  '# Empty Help
	This a dummy help.'
]

{ #category : #actions }
SpHelpBrowserPresenter >> helpTopic [
	
	^ helpTopicCache ifNil: [ helpTopicCache := SystemHelp asHelpTopic ]
]

{ #category : #initialization }
SpHelpBrowserPresenter >> initialExtent [
	^ 800@600
]

{ #category : #initialization }
SpHelpBrowserPresenter >> initializePresenters [

	super initializePresenters.
	loadedTopicList := self newTree.
	loadedTopicList 
		roots: { self helpTopic };
		children: [ :aNode | aNode subtopics ];
		display: [ :each | each title ].
	
	"Using a morph container as the output because a text presenter is intended to receive 
	 strings, not instances of Text (the fact that it works now is just casual, and will 
	 be removed in the future)"
	textOutput := self newMorph
		morph: (RubScrolledTextMorph new 
			hResizing: #spaceFill; 
			vResizing: #spaceFill;
			in: [ :this | this textArea readOnly: true ];
			yourself);
		yourself.
]

{ #category : #utils }
SpHelpBrowserPresenter >> morphWriter [ 
		
	^ PRRichTextComposer new
]

{ #category : #utils }
SpHelpBrowserPresenter >> parser [ 
	^ MicroDownParser
]

{ #category : #utils }
SpHelpBrowserPresenter >> render: aString [

	| document text |
	aString 
		ifNil: [ text := self dummyHelp ]
		ifNotNil: [ text := aString ].
	 document := [ self parser parse: text ] 
							on: MicParsingError
							do: [ :ex | textOutput morph setText: text. ^ self ].
	textOutput morph setText: (self morphWriter start: document asPillar) 
]

{ #category : #accessing }
SpHelpBrowserPresenter >> rootTopic [

	^ rootTopic
]

{ #category : #accessing }
SpHelpBrowserPresenter >> rootTopic: anObject [

	rootTopic := anObject
]

{ #category : #initialization }
SpHelpBrowserPresenter >> title [
	^ 'Help Topic Browser'
]
