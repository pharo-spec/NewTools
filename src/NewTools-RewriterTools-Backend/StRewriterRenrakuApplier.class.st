"
I am a class that is in charge to apply a rule, that is represented in an object `RTRuleHolder` to a set of methods.

I use the Renraku engine for applying the transformation rules.
"
Class {
	#name : #StRewriterRenrakuApplier,
	#superclass : #StRewriterAbstractApplier,
	#category : #'NewTools-RewriterTools-Backend-Core'
}

{ #category : #api }
StRewriterRenrakuApplier class >> calculateAllChangesForRules: aRulesCollection [

	| allSystemMethods |
	allSystemMethods := (self packageOrganizer packages flatCollect: [:each | each classes])
		flatCollect: [ :each | each methods] as: Set.

	^ self calculateChangesForClasses: allSystemMethods asSet transformationRules: aRulesCollection
]

{ #category : #api }
StRewriterRenrakuApplier class >> calculateChangesForClasses: methods transformationRules: rules [

	| critiques changes |
	critiques := self obtainCritiquesOf: methods forRules: rules.
	"At this point you have a collection of critiques. Each critique can tell you which rule created it, and which target it criticizes.
	As the critiques are 'smart', the type you have here (node replace critiques) can give you change compatible with the ChangesBrowser or RewriteChangesBrowser."
	changes := critiques collect: [: each | each change].
	^ changes
]

{ #category : #private }
StRewriterRenrakuApplier class >> obtainCritiquesOf: methods forRules: ruleHolderCollection [

	"This is a way to obtain the same changes array as obtainChanges:forRule: method. But, here this is done without an RBClassEnvironment and ReSmalllintChecker. Because those two classes inherits from RB rules and will be eventually will be deprecated."

	"Take the methods and apply the rule on each of them (in fact on their nodes).
Take a look on ReCriticEngine for some automation ideas. Also take a look at CompiledMethod >> #critiques"

	| methodsAsSet critiques rewriteNode |
	"Extract all the methods from the needed classes.
	asSet message is needed because sometimes can return duplicated methods of the same classes."
	methodsAsSet := methods asSet.
	critiques := OrderedCollection new.
	rewriteNode := ReNodeRewriteRule new.
	ruleHolderCollection do: [ :aRuleHolder |
		aRuleHolder isRuleForMethod
			ifTrue: [ rewriteNode addMatchingMethod: aRuleHolder lhs rewriteTo: aRuleHolder rhs ]
			ifFalse: [ rewriteNode addMatchingExpression: aRuleHolder lhs rewriteTo: aRuleHolder rhs ] ].
	methodsAsSet do: [ :method |
		| rulesCritiques |
		"We need to run the rule for each method and combine resulting critiques.
		In fact rewrite rules check AST nodes. So, we need to run the rule for every AST node of the method and combine the results."
		rulesCritiques := method ast allChildren flatCollect: [ :node | rewriteNode check: node ].

			"This is a hack. Resulting critiques will tell they reffer to a single AST node.
			But, as the rewriting functionality requires actual method instances, we go over each critique and reassign the source entity to the method."
		rulesCritiques do: [ :critique | critique sourceAnchor initializeEnitity: method ].
		critiques addAll: rulesCritiques ]
	displayingProgress: [ :method | 'Running critics on: ' , method methodClass name ].
	^ critiques
]

{ #category : #private }
StRewriterRenrakuApplier class >> obtainCritiquesOfAllMethodsForRules: ruleHolderCollection [

	| methods |
	methods := (self packageOrganizer packages flatCollect: #classes) flatCollect: #methods.
	^ self obtainCritiquesOf: methods forRules: ruleHolderCollection
]
