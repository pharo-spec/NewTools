"
With the old model (it will not work soon). 
```
(StFontChooserPresenter on: FontChooser new) openWithSpec
```

```
(StFontChooserPresenter on: FontChooser new) 
	setter: #menuFont:;
	getter: #menuFont;
	openWithSpec
```

For example to work on a subset of fonts, provide a specific font chooser as follows:

```
(StFontChooserPresenter on: NewFontChooserModel newWithDefaultFamilies) openWithSpec
```


It should probably be used as follows but I'm not sure. 

```
StandardFonts menuFont: (StFontChooser on: FontChooser new) openWithSpec
```

The old way to open the font chooset is 
```
To open the old font chooser morph

FontChooser
 openWithWindowTitle: 'Choose the Menu Font'
 for: StandardFonts
 setSelector: #menuFont:
 getSelector: #menuFont
```

Then I will have to study

```
FreeTypeFontSelectorDialogWindow new open
```

"
Class {
	#name : #StFontChooserPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'fontFamilyList',
		'fontStyleList',
		'fontSizeList',
		'currentFontStyleIndex',
		'currentFontStyleValue',
		'fontSize',
		'languageList',
		'renderingResult',
		'buttonBar',
		'setterSymbol',
		'getterSymbol',
		'target'
	],
	#category : #'NewTools-FontChooser'
}

{ #category : #specs }
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
		add: #renderingResult;
		yourself
			
]

{ #category : #actions }
StFontChooserPresenter >> apply [

	(target isNil or: [ setterSymbol isNil ]) ifTrue: [ ^ self ].			
	self selectedFont ifNotNil: [ :font | target perform: setterSymbol with: self font ].
]

{ #category : #initialization }
StFontChooserPresenter >> connectPresenters [ 
	
	"fontFamilyList 
		whenSelectedDo: [ :family | 
			self storeCurrentFontStyleValue.
			fontStyleList items: family members asOrderedCollection.
			self refreshFontStyleList ]."
		
	fontFamilyList transmitDo: [ self updatePreview ].
	fontStyleList transmitDo: [ self updatePreview ].
	fontSizeList transmitDo: [ self updatePreview ].
	languageList transmitDo: [ self updatePreview ]			
]

{ #category : #'font style list' }
StFontChooserPresenter >> firstFontStyleValue [ 
	"when there is no element that correspond to the previous selection, return the default value"
	
	^ 'Regular'	
				
]

{ #category : #accessing }
StFontChooserPresenter >> fontFamilyList [ 
	
	^ fontFamilyList 

]

{ #category : #accessing }
StFontChooserPresenter >> fontSizeList [ 
	
	^ fontSize

]

{ #category : #accessing }
StFontChooserPresenter >> fontStyleList [

	^ fontStyleList
]

{ #category : #accessing }
StFontChooserPresenter >> for: anObject [
	"Specify which object will see its font modified via the getter and setter symbol selector. "
	
	target := anObject
]

{ #category : #accessing }
StFontChooserPresenter >> getter: aGetterSymbol [
	"This the selector (e.g., menuFont) of the message that will be sent to the object whose font will be modified on apply."
	
	getterSymbol := aGetterSymbol
]

{ #category : #initialization }
StFontChooserPresenter >> initializePresenters [
	<script: '(self on: FontChooser new) openWithSpec'>

	fontFamilyList := self newList.
	fontFamilyList display: [ :each | each familyName ].
	fontFamilyList selectFirst.

	fontStyleList := self newList.
	fontStyleList display: [ :familyMember | 
		| styleName |
		styleName := familyMember styleName.
		familyMember isSimulatedStyle
			ifTrue: [ '(' , styleName , ')' ]
			ifFalse: [ styleName ] ].
	fontStyleList selectFirst.

	fontSizeList := self newList.
	fontSizeList items: self pointSizeList.
	fontSizeList selectItem: 12.
	
	languageList := self newList.
	languageList 
		display: [ :anAssociation | anAssociation key ];
		items: self pangrams; 
		selectFirst.

	renderingResult := self newMorph.

	buttonBar := self newButtonBar.
]

{ #category : #initialization }
StFontChooserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter initialExtent: 900 @ 530.
	aWindowPresenter title: self title
]

{ #category : #initialization }
StFontChooserPresenter >> modelChanged [  
	
	fontFamilyList items: self model fontList.
	fontFamilyList selectIndex: 1.
	

]

{ #category : #private }
StFontChooserPresenter >> pangrams [

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

{ #category : #private }
StFontChooserPresenter >> pointSizeList [
	
	^ (1 to: 256) asOrderedCollection "collect: [ :each | each asString padLeftTo: 3 ]"
]

{ #category : #private }
StFontChooserPresenter >> previewText [
	"Answer the preview text based on current font."
	| font pangram sample lineLength maxLineLength endOfLineCharacters |

	font := self selectedFont.
	font ifNil: [ ^ '' ].
	pangram := self selectedPangram.
	pangram ifNil: [ ^ '' ].
	
	sample := String new writeStream.
	font isSymbolFont ifFalse: [ 
		sample
			nextPutAll: pangram;
			cr;
			nextPutAll: pangram asUppercase;
			cr ].
	
	lineLength := 0.
	maxLineLength := 30.
	endOfLineCharacters := '@Z`z'.
	33 to: 255 do: [ :asciiValue | 
		| character |
		character := Character value: asciiValue.
		sample nextPut: character.
		lineLength := lineLength + 1.
		((endOfLineCharacters includes: character ) or: [ lineLength = maxLineLength ])
			ifTrue: [ 
				lineLength := 0.
				sample cr ] ].

	^ sample contents
]

{ #category : #'font style list' }
StFontChooserPresenter >> refreshFontStyleList [			
	| fontStyle |
	"the display logic displays (Oblique) and the font does not store (Oblique) but Oblique.
	So we have to remove the parentheses if we want to find and select the correct Oblique."
	
	fontStyle := fontStyleList items detect: [ :aFontStyle | 
			| previousWithoutParentheses |
			previousWithoutParentheses := currentFontStyleValue copy.
			previousWithoutParentheses first = $(
				ifTrue: [ previousWithoutParentheses := previousWithoutParentheses copyFrom: 2 to: previousWithoutParentheses size - 1 ].
			aFontStyle styleName = previousWithoutParentheses ] ifNone: [ nil ].
	fontStyle ifNil: [ "could not work when there are not fontStyles"
							fontStyleList selectIndex: 1 ]
				ifNotNil: [ fontStyleList selectItem: fontStyle ]
]

{ #category : #private }
StFontChooserPresenter >> selectedFont [
	
	(fontFamilyList selectedItem isNil 
		or: [ fontSizeList selectedItem isNil ])
		ifTrue: [ ^ nil ].
	
	^ LogicalFont
	familyName: 'Source Code Pro'
	pointSize: 12
	stretchValue: 1 
	weightValue: 400 
	slantValue: 0
]

{ #category : #private }
StFontChooserPresenter >> selectedPangram [
		
	^ languageList selectedItem value
]

{ #category : #accessing }
StFontChooserPresenter >> selector: aSymbol [
	"From this selector we will derive getter and setter (e.g., menuFont: and menuFont) of the message that will be sent to the object whose font will be modified on apply."
	
	setterSymbol := (#':' , aSymbol) asSymbol.
	getterSymbol := aSymbol
]

{ #category : #accessing }
StFontChooserPresenter >> setter: aSetterSymbol [
	"This the selector (e.g., menuFont:) of the message that will be sent to the object whose font will be modified on apply."
	
	setterSymbol := aSetterSymbol
]

{ #category : #'font style list' }
StFontChooserPresenter >> storeCurrentFontStyleValue [ 

	currentFontStyleValue := fontStyleList selection isEmpty
		ifTrue: [ self firstFontStyleValue ]
		ifFalse: [  fontStyleList displayValueFor: (fontStyleList selection selectedItem)]. 
]

{ #category : #initialization }
StFontChooserPresenter >> title [ 

	^ 'Font Chooser'
]

{ #category : #actions }
StFontChooserPresenter >> updateFontList [

	FreeTypeFontProvider current updateFromSystem.
	self refreshFontList.
	self changed:#fontListStrings.
]

{ #category : #private }
StFontChooserPresenter >> updatePreview [

	self selectedFont ifNil: [ ^ self ].

	renderingResult morph: (RubScrolledTextMorph new 
		hResizing: #spaceFill; 
		vResizing: #spaceFill;
		in: [ :this | this textArea readOnly: true ];
		setText: self previewText;
		textFont: self selectedFont;
		yourself).
]
