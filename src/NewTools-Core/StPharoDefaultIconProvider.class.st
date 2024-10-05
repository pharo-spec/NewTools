Class {
	#name : 'StPharoDefaultIconProvider',
	#superclass : 'SpPharoThemeIconProvider',
	#instVars : [
		'synonyms'
	],
	#category : 'NewTools-Core-Application',
	#package : 'NewTools-Core',
	#tag : 'Application'
}

{ #category : 'accessing' }
StPharoDefaultIconProvider >> iconNamed: aSymbol [

	^ super iconNamed: (synonyms 
		at: aSymbol 
		ifAbsent: [ aSymbol ])
]

{ #category : 'initialization' }
StPharoDefaultIconProvider >> initialize [

	super initialize. 
	synonyms := Dictionary new.
	self initializeSynonyms
]

{ #category : 'initialization' }
StPharoDefaultIconProvider >> initializeSynonyms [

	synonyms 
		at: #debuggerCopyStack 			put: #smallCopy;
		at: #debuggerDefineEntity 		put: #changeAdd;
		at: #debuggerPeelToFirst 		put: #down;
		at: #debuggerProceed 				put: #go;
		at: #debuggerRestart 				put: #restart;
		at: #debuggerReturn 				put: #refresh;
		at: #debuggerStepInto 			put: #into;
		at: #debuggerStepOver 			put: #over;
		at: #debuggerStepThrough 		put: #through;
		at: #debuggerRunToSelection 	put: #rightSide; 
		at: #debuggerWhereIs 				put: #search
]
