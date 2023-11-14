"
```
(SpFontChooserPresenter on: FontChooser new) openWithSpec
```

For example to work on a subset of fonts, provide a specific font chooser qs follows:

```
(SpFontChooserPresenter on: NewFontChooser newWithDefaultFamilies) openWithSpec
```
"
Class {
	#name : 'StFontChooserPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'fontFamilyList',
		'fontStyleList',
		'fontSizeList',
		'languageList',
		'previewText'
	],
	#category : 'NewTools-FontChooser',
	#package : 'NewTools-FontChooser'
}

{ #category : 'layout' }
StFontChooserPresenter class >> defaultLayout [ 

	^ SpPanedLayout newTopToBottom
		add: (SpPanedLayout newLeftToRight 
					add: (SpPanedLayout newLeftToRight
						add: #fontFamilyList;
						add: #fontStyleList;
						yourself);
					add: (SpPanedLayout newLeftToRight
						add: #fontSizeList;
						add: #languageList;
						yourself);
					yourself);
		add: #previewText;	
		yourself
			
]

{ #category : 'specs' }
StFontChooserPresenter class >> defaultSpec [ 

	^ SpPanedLayout newTopToBottom
		add: (SpPanedLayout newLeftToRight 
					add: (SpPanedLayout newLeftToRight
						add: #fontFamilyList;
						add: #fontStyleList;
						yourself);
					add: (SpPanedLayout newLeftToRight
						add: #fontSizeList;
						add: #languageList;
						yourself);
					yourself);
		add: (SpScrollableLayout with: #previewText);	
		yourself
			
]

{ #category : 'interface building' }
StFontChooserPresenter class >> pangrams [

	^ OrderedCollection new
		add: 'English' -> 'the quick brown fox jumps over the lazy dog';
		add: 'Bulgarian' -> 'Под южно дърво, цъфтящо в синьо, бягаше малко пухкаво зайче.';
		add: 'Czech' -> 'Příliš žluťoučký kůň úpěl ďábelské ódy.';
		add: 'Chinese' -> '視野無限廣，窗外有藍天
    微風迎客，軟語伴茶';
		add: 'Danish' -> 'Quizdeltagerne spiste jordbær med fløde, mens cirkusklovnen Walther spillede på xylofon.';
		add: 'Dutch' -> 'Pa''s wijze lynx bezag vroom het fikse aquaduct';
		add: 'Esperanto' -> 'Eĥoŝanĝo ĉiuĵaŭde';
		add: 'Estonian' -> 'See väike mölder jõuab rongile hüpata';
		add: 'Finnish' -> 'Viekas kettu punaturkki laiskan koiran takaa kurkki';
		add: 'French' -> 'Voix ambiguë d''un cœur qui au zéphyr préfère les jattes de kiwis';
		add: 'German' -> 'Zwölf Boxkämpfer jagen Viktor quer über den großen Sylter Deich';
		add: 'Greek' -> 'Θέλει αρετή και τόλμη η ελευθερία. (Ανδρέας Κάλβος)';
		add: 'Hebrew' -> 'דג סקרן שט לו בים זך אך לפתע פגש חבורה נחמדה שצצה כך';
		add: 'Hungarian' -> 'Egy hűtlen vejét fülöncsípő, dühös mexikói úr Wesselényinél mázol Quitóban';
		add: 'Italian' -> 'Ma la volpe, col suo balzo, ha raggiunto il quieto Fido.';
		add: 'Japanese' -> 'いろはにほへと ちりぬるを わかよたれそ つねならむ うゐのおくやま けふこえて あさきゆめみし ゑひもせす';
		add: 'Korean' -> '다람쥐 헌 쳇바퀴에 타고파';
		add: 'Latvian' -> 'Sarkanās jūrascūciņas peld pa jūru.';
		add: 'Norwegian' -> 'En god stil må først og fremst være klar. Den må være passende. Aristoteles.';
		add: 'Portugese' -> 'A rápida raposa castanha salta por cima do cão lento.';
		add: 'Brazilian portugese' -> 'A ligeira raposa marrom ataca o cão preguiçoso';
		add: 'Polish' -> 'Pchnąć w tę łódź jeża lub ośm skrzyń fig';
		add: 'Romanian' -> 'Agera vulpe maronie sare peste câinele cel leneş';
		add: 'Russian' -> 'Съешь ещё этих мягких французских булок да выпей же чаю';
		add: 'Serbian (cyrillic)' -> 'Чешће цeђење мрeжастим џаком побољшава фертилизацију генских хибрида.';
		add: 'Serbian (latin)' -> 'Češće ceđenje mrežastim džakom poboljšava fertilizaciju genskih hibrida.';
		add: 'Slovak' -> 'Kŕdeľ šťastných ďatľov učí pri ústí Váhu mĺkveho koňa obhrýzať kôru a žrať čerstvé mäso.';
		add: 'Slovene' -> 'V kožuščku hudobnega fanta stopiclja mizar in kliče 0619872345.';
		add:
				'Spanish'
						->
							'El veloz murciélago hindú comía feliz cardillo y kiwi. La cigüeña tocaba el saxofón detrás del palenque de paja.';
		add: 'Swedish' -> 'Flygande bäckasiner söka hwila på mjuka tuvor';
		add:
				'Thai'
						->
							'เป็นมนุษย์สุดประเสริฐเลิศคุณค่า
    กว่าบรรดาฝูงสัตว์เดรัจฉาน
    จงฝ่าฟันพัฒนาวิชาการ อย่าล้างผลาญฤๅเข่นฆ่าบีฑาใคร
    ไม่ถือโทษโกรธแช่งซัดฮึดฮัดด่า
    หัดอภัยเหมือนกีฬาอัชฌาสัย
    ปฏิบัติประพฤติกฎกำหนดใจ
    พูดจาให้จ๊ะ ๆ จ๋า ๆ น่าฟังเอยฯ';
		add: 'Turkish' -> 'Pijamalı hasta, yağız şoföre çabucak güvendi';
		yourself
]

{ #category : 'events' }
StFontChooserPresenter >> applyChanges [

	self model font: self selectedFont.
	self model onAcceptDo value: self model font
]

{ #category : 'initialization' }
StFontChooserPresenter >> connectPresenters [ 
	
	fontFamilyList 
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem
				ifNotNil: [ :family | 
					self refreshFontStyleList  ] ].
		
	fontStyleList 
		whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: [ self refreshFontSizeList ] ].
		
	fontSizeList 
		whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: [ self updatePreview ] ].

	languageList 
		whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: [ self updatePreview ] ]
]

{ #category : 'accessing' }
StFontChooserPresenter >> fontFamilyList [ 
	
	^ fontFamilyList 

]

{ #category : 'accessing' }
StFontChooserPresenter >> fontSizeList [ 
	
	^ fontSizeList 

]

{ #category : 'accessing' }
StFontChooserPresenter >> fontStyleList [
	^ fontStyleList
]

{ #category : 'initialization' }
StFontChooserPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	
	super initializeDialogWindow: aDialogWindowPresenter.

	aDialogWindowPresenter
		addButton: 'Update' do: [ :presenter | self updateFonts ];
		addDefaultButton: 'Apply' do: [ :presenter | self applyChanges ];
		okAction: [ self applyChanges ].

]

{ #category : 'initialization' }
StFontChooserPresenter >> initializePresenters [ 
	
	fontFamilyList := self newList.
	fontFamilyList display: [ :each | each familyName ].
	
	fontStyleList := self newList.
	fontStyleList display: [ :familyMember |  
			| styleName |
			styleName := familyMember styleName.
			familyMember isSimulatedStyle
				ifTrue: ['(', styleName, ')']
				ifFalse: [styleName] ].
			
	fontSizeList := self newList.
	fontSizeList display: [ :fontSize | fontSize asString padLeftTo: 3 ].
	
	languageList := self newList.
	languageList items: self class pangrams.
	languageList selectIndex: 1.
	languageList display: [ :aPangrams | aPangrams key ]	.
		
	previewText := self newMorph
]

{ #category : 'initialization' }
StFontChooserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter initialExtent: 800@580.
	aWindowPresenter title: self model title
]

{ #category : 'initialization' }
StFontChooserPresenter >> modelChanged [  
	
	self updateWithFont: self model font
]

{ #category : 'accessing' }
StFontChooserPresenter >> previewText [

	"Answer the preview text based on current font."

	| sample i maxLineLength endOfLineCharacters |

	sample := String new writeStream.

	self selectedFont isSymbolFont
		ifFalse: [ | pangram |
			pangram := languageList selectedItem value.
			sample
				nextPutAll: pangram;
				cr;
				nextPutAll: pangram asUppercase;
				cr
			].
	i := 0.

	maxLineLength := 30.
	endOfLineCharacters := '@Z`z'.
	33 to: 255 do: [ :asciiValue | 
		| character |

		character := Character value: asciiValue.
		sample nextPut: character.
		i := i + 1.
		( ( endOfLineCharacters includes: character ) or: [ i = maxLineLength ] )
			ifTrue: [ i := 0.
				sample cr
				]
		].

	^ sample contents
]

{ #category : 'refreshing' }
StFontChooserPresenter >> refreshFontSizeList [
	
	| sizes currentFontSizeValue |
	
	currentFontSizeValue := fontSizeList selectedItem.
	
	sizes := TextStyle pointSizesFor: fontFamilyList selectedItem familyName.
	sizes ifEmpty: [ sizes := 1 to: 256 ].
	
	fontSizeList items: sizes.
	
	"If the currentFontSizeValue is not included in the sizes, we select the first"	
	(sizes includes: currentFontSizeValue)
		ifTrue: [ fontSizeList selectItem: currentFontSizeValue ]
		ifFalse: [ (sizes includes: 10)
			ifTrue: [fontSizeList selectItem: 10] 
			ifFalse: [fontSizeList selectIndex: 1]].
]

{ #category : 'font style list' }
StFontChooserPresenter >> refreshFontStyleList [
								
	| fontStyle toFindName currentFontStyleValue |

	"Keeping current value so we can update the selection"
	currentFontStyleValue := fontStyleList selection selectedItem.
	fontStyleList items: self selectedFontFamily members asSortedCollection.
	
	"If the selection is null we put Regular as the default"
	
	toFindName := currentFontStyleValue 
		ifNil: ['Regular'] 
		ifNotNil: [currentFontStyleValue styleName].
	
	fontStyle := fontStyleList items detect: [ :aFontStyle | 
			aFontStyle styleName = toFindName ] ifNone: [ nil ].
	fontStyle ifNil: [ "could not work when there are not fontStyles"
							fontStyleList selectIndex: 1 ]
				ifNotNil: [ fontStyleList selectItem: fontStyle  ]
]

{ #category : 'accessing' }
StFontChooserPresenter >> selectedFont [
	
	^LogicalFont 
		familyName: self selectedFontFamily familyName 
		pointSize: self selectedFontSize 
		stretchValue: self selectedFontStyle stretchValue
		weightValue: self selectedFontStyle weightValue
		slantValue: self selectedFontStyle slantValue
]

{ #category : 'accessing' }
StFontChooserPresenter >> selectedFontFamily [
	
	^ fontFamilyList selectedItem 
]

{ #category : 'accessing' }
StFontChooserPresenter >> selectedFontSize [
	
	^ fontSizeList selectedItem
]

{ #category : 'accessing' }
StFontChooserPresenter >> selectedFontStyle [
	
	^ fontStyleList selectedItem
]

{ #category : 'initialization' }
StFontChooserPresenter >> title [ 

	^ 'Font Chooser'
]

{ #category : 'events' }
StFontChooserPresenter >> updateFonts [
	
	FreeTypeFontProvider current updateFromSystem.
	self updateWithFont: self selectedFont.

]

{ #category : 'refreshing' }
StFontChooserPresenter >> updatePreview [
	
	previewText morph: (RubEditingArea new
		beWrapped;
		setTextWith: self previewText;
		font: self selectedFont;
		color: Color transparent;
		in: [ :this | this textArea readOnly: true ];
		yourself)
]

{ #category : 'initialization' }
StFontChooserPresenter >> updateWithFont: aFont [

	| initialFamily initialStyle |
	fontFamilyList items: self model fontList.

	initialFamily := fontFamilyList items
		                 detect: [ :e | e familyName = aFont familyName ]
		                 ifNone: [ nil ].

	fontFamilyList selectItem: initialFamily.

	initialStyle := self selectedFontFamily members
		                detect: [ :style | 
			                style weightValue = aFont weightValue and: [ 
				                style stretchValue = aFont stretchValue and: [ 
					                style slantValue = aFont slantValue ] ] ]
		                ifNone: [ nil ].

	fontStyleList selectItem: initialStyle.

	fontSizeList selectItem: aFont pointSize.

	self updatePreview
]
