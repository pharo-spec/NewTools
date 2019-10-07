"
I'm an util to convert a shortcut into the representation used in a platform (they change, as the shortcut themselves are different sometimes)

TODO: This is not for Spec exlusive usage, we need promote StShortcutPrinter to its own package.

"
Class {
	#name : #StShortcutPrinter,
	#superclass : #OSPlatformVisitor,
	#instVars : [
		'shortcut'
	],
	#classVars : [
		'SymbolTable'
	],
	#category : #'NewTools-Core-Utils'
}

{ #category : #private }
StShortcutPrinter class >> createSymbolTable [

	^ Dictionary newFromPairs: { 
		#Cmd. 		(Character value: 16r2318) asString.
		#Meta. 	(Character value: 16r2318) asString.
		#Alt. 		(Character value: 16r2325) asString. 
		#Ctrl.  	(Character value: 16r2303) asString. 
		#Shift. 	(Character value: 16r21E7) asString.
		#Enter. 	(Character value: 16r23ce) asString }
]

{ #category : #private }
StShortcutPrinter class >> symbolTable [

	^ SymbolTable ifNil: [ SymbolTable := self createSymbolTable ]
]

{ #category : #private }
StShortcutPrinter class >> symbolTableAt: anObject ifAbsent: aBlock [

	^ self symbolTable 
		at: anObject 
		ifAbsent: aBlock
]

{ #category : #'instance creation' }
StShortcutPrinter class >> toString: aShortcut [

	^ self new
		shortcut: aShortcut;
		visit
]

{ #category : #accessing }
StShortcutPrinter >> shortcut: aShortcut [

	shortcut := aShortcut
]

{ #category : #private }
StShortcutPrinter >> shortcutModifiers [
	| modifiers |
	
	modifiers := (shortcut spModifier asString substrings: '+') collect: #trimBoth.
	"Ensure shift is first"
	((modifiers includes: 'Shift') 
		and: [ modifiers first ~= 'Shift' ])
		ifTrue: [ modifiers := (modifiers copyWithout: 'Shift') copyWithFirst: 'Shift' ].
	
	^ modifiers		
]

{ #category : #visiting }
StShortcutPrinter >> visitGeneric: aPlatform [
	
	^ String streamContents: [ :stream |
		self shortcutModifiers
			do: [ :each | stream << each ]
			separatedBy: [ stream << '+' ].
		stream << '+'.
		stream << shortcut spCurrentCharacter asUppercase ]
	
]

{ #category : #visiting }
StShortcutPrinter >> visitMacOS: aPlatform [
	| keyParts symbols |

	keyParts := self shortcutModifiers.
	symbols := keyParts 
		inject: ''
		into: [ :s :each | 
			s, (self class symbolTableAt: each ifAbsent: [ each capitalized ]) ].
		
	^ symbols, (shortcut spCurrentCharacter asString capitalized)
]
