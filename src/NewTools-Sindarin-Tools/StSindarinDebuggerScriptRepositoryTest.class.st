Class {
	#name : 'StSindarinDebuggerScriptRepositoryTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Sindarin-Tools-Tests',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Tests'
}

{ #category : 'running' }
StSindarinDebuggerScriptRepositoryTest >> setUp [
	super setUp.
	
	StSindarinDebuggerScriptRepositoryAbstract clearScripts.
]

{ #category : 'tests' }
StSindarinDebuggerScriptRepositoryTest >> testAddMultipleScriptsStoresEachCorrectly [
	"We assume that the setup clears the scripts dictionary"

	|name1 name2 code1 code2|
	name1 := '01'.
	code1 := '"code01"'.
	name2 := '02'.
	code2 := '"code02'.
	
	StSindarinDebuggerScriptRepositoryAbstract saveScript: name1 code: code1.
	StSindarinDebuggerScriptRepositoryAbstract saveScript: name2 code: code2.
	
	self assert: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: name1 ).
	self assert: (StSindarinDebuggerScriptRepositoryAbstract loadScript: name1 ) identicalTo: code1 .
	
	self assert: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: name2 ).
	self assert: (StSindarinDebuggerScriptRepositoryAbstract loadScript: name2 ) identicalTo: code2 .

]

{ #category : 'tests' }
StSindarinDebuggerScriptRepositoryTest >> testAddScriptStoresCodeCorrectly [
	"We assume that the setup clears the scripts dictionary"
	
	|scriptName script|
	
	scriptName := 'Script01'.
	script := '"code de script"'.
	
	StSindarinDebuggerScriptRepositoryAbstract saveScript: scriptName code: script .
	
	self assert: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: scriptName).
	self assert: (StSindarinDebuggerScriptRepositoryAbstract loadScript: scriptName ) identicalTo: script .
]

{ #category : 'tests' }
StSindarinDebuggerScriptRepositoryTest >> testClearScriptsEmptiesDictionary [
	"We assume that the setup clears the scripts dictionary"
	
	|scriptName1 scriptName2 script|
	
	scriptName1 := '01'.
	scriptName2 := '02'.
	script := '"code"'.
	
	StSindarinDebuggerScriptRepositoryAbstract saveScript: scriptName1 code: script.
	StSindarinDebuggerScriptRepositoryAbstract saveScript: scriptName2 code: script.
	
	self assert: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: scriptName1).
	self assert: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: scriptName2).
	
	StSindarinDebuggerScriptRepositoryAbstract clearScripts.
	
	self deny: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: scriptName1).
	self deny: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: scriptName2).
]

{ #category : 'tests' }
StSindarinDebuggerScriptRepositoryTest >> testLookupNonexistentScriptReturnsNil [
	"We assume that the setup clears the scripts dictionary"
	
	|notExistingScriptName|
	
	notExistingScriptName := 'Script404'.
	
	self deny: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: notExistingScriptName).
	self assert: ((StSindarinDebuggerScriptRepositoryAbstract loadScript: notExistingScriptName) isNil).
]

{ #category : 'tests' }
StSindarinDebuggerScriptRepositoryTest >> testOverwriteScriptReplacesCode [
	"We assume that the setup clears the scripts dictionary"
	
	|scriptName oldScript newScript|
	scriptName := 'script01'.
	oldScript := '"ancien code de script"'.
	newScript := '"nouveau code de script"'.
	
	StSindarinDebuggerScriptRepositoryAbstract saveScript: scriptName code: oldScript .
	self assert: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: scriptName).
	self assert: (StSindarinDebuggerScriptRepositoryAbstract loadScript: scriptName ) identicalTo: oldScript .
	
	StSindarinDebuggerScriptRepositoryAbstract saveScript: scriptName code: newScript .
	self assert: (StSindarinDebuggerScriptRepositoryAbstract scriptsNames includes: scriptName).
	self assert: (StSindarinDebuggerScriptRepositoryAbstract loadScript: scriptName ) identicalTo: newScript .

]

{ #category : 'tests' }
StSindarinDebuggerScriptRepositoryTest >> testScriptsDictionaryIsInitialized [
	"We assume that the setup clears the scripts dictionary"
	
	self deny: (StSindarinDebuggerScriptRepositoryAbstract scripts isNil).
]
