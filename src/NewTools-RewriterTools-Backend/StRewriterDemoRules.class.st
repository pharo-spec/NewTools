"
I am a class that creates some demo rules to be used as rule examples
"
Class {
	#name : 'StRewriterDemoRules',
	#superclass : 'Object',
	#category : 'NewTools-RewriterTools-Backend-DefaultRule',
	#package : 'NewTools-RewriterTools-Backend',
	#tag : 'DefaultRule'
}

{ #category : 'api' }
StRewriterDemoRules class >> defaultRule [

	| lhs rhs inputCode |
	lhs := '(`@receiver collect: `@arg) flattened'.
	rhs := '`@receiver flatCollect: `@arg'.
	inputCode := '(RBBrowserEnvironment default packages collect: #classes) flattened'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs pharoCode: inputCode
]

{ #category : 'api' }
StRewriterDemoRules class >> demoRules [
 
	^ (Pragma allNamed: #rewriterRule) collect: [ :prg | prg method valueWithReceiver: nil]
]

{ #category : 'rules' }
StRewriterDemoRules class >> removeAssignmentWithoutEffectRule [
	<rewriterRule>
	
	| lhs rhs ruleName |
	lhs := '`var := `var'.
	rhs := ''.
	ruleName := 'Remove assignment without effect'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> removeEqualsInAssertRule [
	<rewriterRule>
	
	| lhs rhs ruleName |
	lhs := '`@receiver assert: `@arg equals: true'.
	rhs := '`@receiver assert: `@arg'.
	ruleName := 'Remove equals in assert'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> removeIfNilRule [
	<rewriterRule>
	
	| lhs rhs ruleName |
	lhs := '`@receiver ifNil: [ nil ] ifNotNil: `@arg'.
	rhs := '`@receiver ifNotNil: `@arg'.
	ruleName := 'Remove unnecessary ifNil:'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> replaceAssertToAssertEmptyRule [
	<rewriterRule>
	
	| lhs rhs ruleName |
	lhs := '`@receiver assert: `@arg isEmpty'.
	rhs := '`@receiver assertEmpty: `@arg'.
	ruleName := 'Replace assert to assert empty'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> replaceCharacterTabAsStringToStringTabRule [
	<rewriterRule>
	
	| lhs rhs ruleName |
	lhs := 'Character tab asString'.
	rhs := 'String tab'.
	ruleName := 'Replace Character tab asString to String tab'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> replaceCollectFlattenToFlatCollectRule [
	<rewriterRule>
	
	| lhs rhs ruleName |
	lhs := '(`@receiver collect: `@arg) flattened'.
	rhs := '`@receiver flatCollect: `@arg'.
	ruleName := 'Replace collect: flatten to flatCollect:'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> replaceDenyDenyEmptyRule [
	<rewriterRule>
	
	| lhs rhs ruleName |
	lhs := '`@receiver select: [ :`each |
	| `@temps |
	``@.Statements.
	``@object not ]'.
	rhs := '`@receiver denyEmpty: `@arg'.
	ruleName := 'Replace deny: isEmpty to denyEmpty:'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> replaceSelectToRejectRule [
	<rewriterRule>
	
	| lhs rhs ruleName |
	lhs := '`@receiver select: [ :`each |
	| `@temps |
	``@.Statements.
	``@object not ]'.
	rhs := '`@receiver reject: [ :`each |
	| `@temps |
	``@.Statements.
	``@object ]'.
	ruleName := 'Replace select to reject'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> simpliflyConditionalToIsEmptyRule [
	<rewriterRule>

	| lhs rhs ruleName |
	lhs := '`@receiver ifEmpty: [ true ] ifNotEmpty: [ false ]'.
	rhs := '`@receiver isEmpty'.
	ruleName := 'Simplify conditional to isEmpty'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> simpliflyToIfEmptyIfNotEmptyRule [
	<rewriterRule>

	| lhs rhs ruleName |
	lhs := '`@receiver isEmpty ifTrue: `@arg ifFalse: `@arg2'.
	rhs := '`@receiver ifEmpty: `@arg ifNotEmpty: `@arg2'.
	ruleName := 'Simplify to ifEmpty: ifNotEmpty:'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]

{ #category : 'rules' }
StRewriterDemoRules class >> simplifyToIfNilIfNotNilRule [

	| lhs rhs ruleName |
	lhs := '`@receiver isNil
	ifTrue: `@arg
	ifFalse: `@arg2'.
	rhs := '`@receiver ifNil: `@arg ifNotNil: `@arg2'.
	ruleName := 'Simplify to ifNil: ifNotNil:'.
	^ StRewriterRuleHolder lhs: lhs rhs: rhs name: ruleName
]
