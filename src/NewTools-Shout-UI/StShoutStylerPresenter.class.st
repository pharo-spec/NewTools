"
Provides a Spec presenter to preview how a Shout code style would be displayed in the system.
It also allows you to apply the selected style.

```
StShoutStylerPresenter open.
```
"
Class {
	#name : 'StShoutStylerPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'styleListPresenter',
		'buttonBarPresenter',
		'classDefinitionPreviewPresenter',
		'methodPreviewPresenter',
		'themeListPresenter'
	],
	#category : 'NewTools-Shout-UI',
	#package : 'NewTools-Shout-UI'
}

{ #category : 'world menu' }
StShoutStylerPresenter class >> defaultPreferredExtent [

	^ 950 @ 650
]

{ #category : 'world menu' }
StShoutStylerPresenter class >> descriptionText [

	^ 'A tool to select the code style for the system'

]

{ #category : 'world menu' }
StShoutStylerPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: 'Code Styler')
		action: [ self open ];
		order: 35;
		parent: #Tools;
		icon: (self iconNamed: #configuration);
		help: self descriptionText
]

{ #category : 'instance creation' }
StShoutStylerPresenter class >> open [
	<script> 

	^ (self newApplication: StPharoApplication current) open
]

{ #category : 'private' }
StShoutStylerPresenter >> availableStylesPragmas [
	"Answer a <Collection> of <Pragma> each representing a Shout style"

	^ self textStylerClass styleTablePragmas
]

{ #category : 'callbacks' }
StShoutStylerPresenter >> classDefinitionText [

	^ RubScrolledTextMorph new
		wrapped: true;
		setText: (self styledClassDefinitionWith: self selectedStyleTableName);
		color: (self themeBackgroundColor: themeListPresenter selectedItem);
		in: [ :this |
			this textArea
				readOnly: true;
				font: StandardFonts codeFont ];
		yourself
]

{ #category : 'layout' }
StShoutStylerPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 4;
		add: (	SpPanedLayout newLeftToRight 
			positionOfSlider: 20 percent;
			add: (SpPanedLayout newTopToBottom
				positionOfSlider: 30 percent;
				add: themeListPresenter;
				add: styleListPresenter;
				yourself);
			add: (SpPanedLayout newTopToBottom 
				add: classDefinitionPreviewPresenter;
				add: methodPreviewPresenter;
				yourself);
			yourself);
		add: buttonBarPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
StShoutStylerPresenter >> initializeButtonBar [

	buttonBarPresenter := self newButtonBar
		placeAtEnd;
		add: (self newButton
			label: 'Apply';
			icon: (self iconNamed: #smallOk);
			help: 'Apply the selected style';
			action: [ self updatePreferences ];
			yourself);
		add: (self newButton
			label: 'Cancel';
			icon: (self iconNamed: #smallCancel);
			action: [ self delete ];
			yourself);
		yourself
]

{ #category : 'initialization' }
StShoutStylerPresenter >> initializeClassDefinitionPreview [

	classDefinitionPreviewPresenter := self newMorph
		morph: self classDefinitionText;
		yourself
]

{ #category : 'initialization' }
StShoutStylerPresenter >> initializeMethodPreview [

	methodPreviewPresenter := self newMorph
		morph: self methodText;
		yourself
]

{ #category : 'initialization' }
StShoutStylerPresenter >> initializePresenters [

	self 
		initializeThemeList;
		initializeStyleList;
		initializeMethodPreview;
		initializeClassDefinitionPreview;
		initializeButtonBar.
]

{ #category : 'initialization' }
StShoutStylerPresenter >> initializeStyleList [
	"Private - The receiver's style list contains the names of the available code styles in the system"

	styleListPresenter := self newList
		                      headerTitle: 'Styles';
		                      items: self styleNames;
		                      selectItem: self styleName;
		                      whenSelectedItemChangedDo: [ :item | self updatePreview ];
		                      yourself.
]

{ #category : 'initialization' }
StShoutStylerPresenter >> initializeThemeList [
	"Private - The receiver's theme list contains the names of the available theme styles in the system"

	themeListPresenter := self newList.
	themeListPresenter
		headerTitle: 'Themes';
		items: self themePrototypes;
		display: [ : aTheme | aTheme class themeName ];
		selectItem: self theme;
		whenSelectedItemChangedDo: [ :item | self updatePreview ].
]

{ #category : 'callbacks' }
StShoutStylerPresenter >> methodText [

	^ RubScrolledTextMorph new
		wrapped: true;
		setText: (self styledMethodWith: self selectedStyleTableName);
		color: (self themeBackgroundColor: themeListPresenter selectedItem);
		in: [ :this |
			this textArea
				readOnly: true;
				font: StandardFonts codeFont ];
		yourself
]

{ #category : 'private' }
StShoutStylerPresenter >> sampleClass [

	^ OrderedCollection 
]

{ #category : 'private' }
StShoutStylerPresenter >> sampleMethod [
	"#copyReplaceFrom:to:with:"
	
	^  self sampleClass >> #withIndexCollect: "OrderedCollection selectors atRandom"
]

{ #category : 'private' }
StShoutStylerPresenter >> selectedStyleTableName [
	"Answer a <String> with the currently selected style name in the receiver"
	
	^ styleListPresenter selectedItem
]

{ #category : 'private' }
StShoutStylerPresenter >> styleName [
	"Answer a <Collection> of <String> with the available style names"
	
	^ self textStylerClass styleTableName
]

{ #category : 'private' }
StShoutStylerPresenter >> styleNames [
	"Answer a <Collection> of <String> with the available style names"
	
	^ self availableStylesPragmas collect: [ :p | p argumentAt: 1 ]
]

{ #category : 'private' }
StShoutStylerPresenter >> styledClassDefinitionWith: styleName [
	"Answer a <Text> representing the receiver's styled sample class definition"

	^ (self textStylerClass newWithAttributeTableNamed: styleName)
			styledTextFor: self sampleClass definitionString asText
]

{ #category : 'private' }
StShoutStylerPresenter >> styledMethodWith: styleName [
	"Answer a <Text> representing the receiver's styled sample method source"

	^ (self textStylerClass newWithAttributeTableNamed: styleName)
	    style: self sampleMethod sourceCode asText
	    ast: self sampleMethod ast.
	
]

{ #category : 'private' }
StShoutStylerPresenter >> textStylerClass [

	^ SpMorphicCodeTextStyler
]

{ #category : 'private' }
StShoutStylerPresenter >> themeBackgroundColor: aSelectedItemOrNil [

	^ (aSelectedItemOrNil
		ifNil: [ self theme ]
		ifNotNil: [ themeListPresenter selectedItem ]) backgroundColor
]

{ #category : 'private' }
StShoutStylerPresenter >> themePrototypes [
	"Answer a <Collection> of available themes in the system"

	^ UITheme allThemeClasses collect: [ : th | th new ]
]

{ #category : 'callbacks' }
StShoutStylerPresenter >> updatePreferences [
	"Private - Callback for updating global preferences"
	
	UITheme current: themeListPresenter selectedItem.
	SHPreferences setStyleTableNamed: self selectedStyleTableName.
]

{ #category : 'callbacks' }
StShoutStylerPresenter >> updatePreview [

	classDefinitionPreviewPresenter morph: self classDefinitionText.
	methodPreviewPresenter morph: self methodText
]

{ #category : 'initialization' }
StShoutStylerPresenter >> windowIcon [

	^ self iconNamed: #smallWindow
]

{ #category : 'initialization' }
StShoutStylerPresenter >> windowTitle [

	^ 'Code Styler'
]
