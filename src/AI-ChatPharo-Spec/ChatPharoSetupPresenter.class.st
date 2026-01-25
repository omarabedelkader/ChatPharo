"
First-launch setup wizard for ChatPharo.
* Shows when ChatPharo is first installed or settings are not configured
* Asks for developer ID to verify if user is an authorized developer
* If not a developer, collects basic user information (name, organization)
* Saves configuration to ChatPharoSettings
* **Why** – provides a friendly onboarding experience and developer verification.
```smalltalk
ChatPharoSetupPresenter open.
ChatPharoSetupPresenter openIfNeeded.
"
Class {
	#name : 'ChatPharoSetupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'titleLabel',
		'descriptionLabel',
		'developerIdInput',
		'verifyButton',
		'skipDeveloperButton',
		'userNameInput',
		'userOrganizationInput',
		'saveButton',
		'cancelButton',
		'statusLabel',
		'currentStep',
		'contentContainer',
		'isDeveloperVerified',
		'selectedLevel',
		'levelButtons',
		'tutorialCheckbox'
	],
	#category : 'AI-ChatPharo-Spec-Setup',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Setup'
}

{ #category : 'instance creation' }
ChatPharoSetupPresenter class >> open [
	"Open the setup wizard."

	^ self new open
]

{ #category : 'instance creation' }
ChatPharoSetupPresenter class >> openIfNeeded [
	"Open the setup wizard only if not already configured."

	ChatPharoSettings default isConfigured ifFalse: [
		^ self open ].
	^ nil
]

{ #category : 'instance creation' }
ChatPharoSetupPresenter >> cancelSetup [
	"Cancel the setup without saving. Mark as configured to prevent repeated prompts."

	| settings |
	settings := ChatPharoSettings default.
	settings isConfigured: true.
	self window close
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> createLevelOptionRow: aButton title: aTitle description: aDescription [
	"Create a styled row for a level option with button and description"

	| descLabel |
	descLabel := self newLabel
		label: aDescription;
		yourself.

	^ SpBoxLayout newHorizontal
		spacing: 12;
		add: aButton expand: false;
		add: descLabel expand: true;
		yourself
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 16;
		borderWidth: 20;
		add: titleLabel expand: false;
		add: descriptionLabel expand: false;
		add: contentContainer expand: true;
		add: statusLabel expand: false;
		yourself
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> finishSetup [
	"Save all configuration and optionally launch the tutorial."

	| settings wantsTutorial |
	settings := ChatPharoSettings default.

	"Save user info"
	userNameInput text trimBoth ifNotEmpty: [ :name |
		settings userName: name ].
	userOrganizationInput text trimBoth ifNotEmpty: [ :org |
		settings userOrganization: org ].

	"Save developer status"
	settings isDeveloper: isDeveloperVerified.

	"Save experience level"
	settings userLevel: selectedLevel.

	"Save tutorial preference"
	wantsTutorial := tutorialCheckbox state.
	settings wantsTutorial: wantsTutorial.

	"Mark as configured"
	settings isConfigured: true.

	ChatPharoLogger logSystem: 'User configuration completed'
		details: (Dictionary new
			at: 'isDeveloper' put: isDeveloperVerified;
			at: 'hasName' put: settings userName isNotEmpty;
			at: 'hasOrganization' put: settings userOrganization isNotEmpty;
			at: 'userLevel' put: selectedLevel;
			at: 'wantsTutorial' put: wantsTutorial;
			yourself).

	self inform: 'Configuration saved successfully!'.
	self window close.

	"Launch tutorial if requested"
	wantsTutorial ifTrue: [
		self defer: [ ChatPharoTutorial start ] ]
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> initialize [

	super initialize.
	currentStep := #developer.
	isDeveloperVerified := false.
isDeveloperVerified := false.
	selectedLevel := 'beginner'.
	levelButtons := Dictionary new
]

{ #category : 'initialization' }
ChatPharoSetupPresenter >> initializePresenters [

	super initializePresenters.

	titleLabel := self newLabel
		label: 'Welcome to ChatPharo';
		yourself.

	descriptionLabel := self newLabel
		label: 'Let''s set up your profile. Are you a ChatPharo developer?';
		yourself.

	statusLabel := self newLabel
		label: '';
		yourself.

	contentContainer := SpPresenter new.

	self showDeveloperStep
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'ChatPharo Setup';
		initialExtent: 500@400;
		centered
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> saveUserConfiguration [
	"Save the user configuration and close the wizard."

	| settings |
	settings := ChatPharoSettings default.

	userNameInput text trimBoth ifNotEmpty: [ :name |
		settings userName: name ].

	userOrganizationInput text trimBoth ifNotEmpty: [ :org |
		settings userOrganization: org ].

	settings isDeveloper: isDeveloperVerified.
	settings isConfigured: true.

	ChatPharoLogger logSystem: 'User configuration completed'
		details: (Dictionary new
			at: 'isDeveloper' put: isDeveloperVerified;
			at: 'hasName' put: settings userName isNotEmpty;
			at: 'hasOrganization' put: settings userOrganization isNotEmpty;
			yourself).

	self inform: 'Configuration saved successfully!'.
	self window close
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> selectLevel: aLevelString [
	"Select the given experience level"

	selectedLevel := aLevelString.
	self updateLevelButtonStyles.
	statusLabel label: 'Selected: ', (ChatPharoSettings default userLevelDisplayNameFor: aLevelString)
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> showDeveloperStep [
	"Show the developer verification step."

	| idRow buttonRow |
	currentStep := #developer.

	descriptionLabel label: 'Do you have a ChatPharo Developer ID?'.
	statusLabel label: ''.

	developerIdInput := self newTextInput
		placeholder: 'Enter your Developer ID...';
		yourself.

	verifyButton := self newButton
		label: 'Verify ID';
		icon: (self iconNamed: #glamorousGo);
		action: [ self verifyDeveloperId ];
		yourself.

	skipDeveloperButton := self newButton
		label: 'Skip (I''m not a developer)';
		action: [ self showUserInfoStep ];
		yourself.

	cancelButton := self newButton
		label: 'Cancel';
		action: [ self cancelSetup ];
		yourself.

	idRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: developerIdInput expand: true;
		add: verifyButton expand: false;
		yourself.

	buttonRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: skipDeveloperButton expand: false;
		add: cancelButton expand: false;
		yourself.

	contentContainer layout: (SpBoxLayout newTopToBottom
		spacing: 12;
		add: idRow expand: false;
		add: buttonRow expand: false;
		yourself).

	self layout: self defaultLayout
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> showExperienceLevelStep [
	"Show the experience level selection step."

	| levelContainer buttonRow continueButton backButton beginnerButton intermediateButton advancedButton |
	currentStep := #experienceLevel.

	titleLabel label: 'Your Pharo Experience'.
	descriptionLabel label: 'What is your experience level with Pharo?'.
	statusLabel label: ''.

	"Create level selection buttons with descriptions"
	beginnerButton := self newButton
		label: 'Beginner';
		icon: (self iconNamed: #smallNew);
		help: 'New to Pharo - I am just starting to learn';
		action: [ self selectLevel: 'beginner' ];
		yourself.

	intermediateButton := self newButton
		label: 'Intermediate';
		icon: (self iconNamed: #smallDoIt);
		help: 'Familiar with Pharo basics - I can write simple programs';
		action: [ self selectLevel: 'intermediate' ];
		yourself.

	advancedButton := self newButton
		label: 'Advanced';
		icon: (self iconNamed: #smallSystemBrowser);
		help: 'Experienced Pharo developer - I know the system well';
		action: [ self selectLevel: 'advanced' ];
		yourself.

	levelButtons := Dictionary new
		at: 'beginner' put: beginnerButton;
		at: 'intermediate' put: intermediateButton;
		at: 'advanced' put: advancedButton;
		yourself.

	"Highlight the currently selected level"
	self updateLevelButtonStyles.

	levelContainer := SpBoxLayout newTopToBottom
		spacing: 12;
		add: (self createLevelOptionRow: beginnerButton
			title: 'Beginner'
			description: 'New to Pharo - I am just starting to learn') expand: false;
		add: (self createLevelOptionRow: intermediateButton
			title: 'Intermediate'
			description: 'Familiar with Pharo basics - I can write programs') expand: false;
		add: (self createLevelOptionRow: advancedButton
			title: 'Advanced'
			description: 'Experienced Pharo developer - I know the system well') expand: false;
		yourself.

	continueButton := self newButton
		label: 'Continue';
		icon: (self iconNamed: #glamorousGo);
		action: [ self showTutorialOfferStep ];
		yourself.

	backButton := self newButton
		label: 'Back';
		action: [ self showUserInfoStep ];
		yourself.

	cancelButton := self newButton
		label: 'Cancel';
		action: [ self cancelSetup ];
		yourself.

	buttonRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: backButton expand: false;
		add: continueButton expand: false;
		add: cancelButton expand: false;
		yourself.

	contentContainer layout: (SpBoxLayout newTopToBottom
		spacing: 12;
		add: levelContainer expand: true;
		add: buttonRow expand: false;
		yourself).


	self layout: self defaultLayout
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> showTutorialOfferStep [
	"Show the tutorial offer step."

	| tutorialContainer buttonRow finishButton backButton infoLabel tutorialDescription |
	currentStep := #tutorialOffer.

	titleLabel label: 'ChatPharo Tutorial'.
	descriptionLabel label: 'Would you like a quick tour of ChatPharo?'.
	statusLabel label: ''.

	infoLabel := self newLabel
		label: 'Learn how to get the most out of ChatPharo with our interactive tutorial.';
		yourself.

	tutorialDescription := self newLabel
		label: 'The tutorial covers: starting chats, sending messages, using code suggestions, and more.';
		yourself.

	tutorialCheckbox := self newCheckBox
		label: 'Yes, show me the tutorial after setup';
		state: true;
		yourself.

	tutorialContainer := SpBoxLayout newTopToBottom
		spacing: 16;
		add: infoLabel expand: false;
		add: tutorialDescription expand: false;
		add: tutorialCheckbox expand: false;
		yourself.

	finishButton := self newButton
		label: 'Finish Setup';
		icon: (self iconNamed: #glamorousAccept);
		action: [ self finishSetup ];
		yourself.

	backButton := self newButton
		label: 'Back';
		action: [ self showExperienceLevelStep ];
		yourself.

	cancelButton := self newButton
		label: 'Cancel';
		action: [ self cancelSetup ];
		yourself.

	buttonRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: backButton expand: false;
		add: finishButton expand: false;
		add: cancelButton expand: false;
		yourself.

	contentContainer removeAll.
	contentContainer
		add: tutorialContainer expand: true;
		add: buttonRow expand: false.

	self layout: self defaultLayout
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> showUserInfoStep [
	"Show the user information collection step."

	| nameRow orgRow buttonRow infoLabel continueButton |
	currentStep := #userInfo.

	isDeveloperVerified
		ifTrue: [ descriptionLabel label: 'Developer verified! Please provide your details.' ]
		ifFalse: [ descriptionLabel label: 'Please tell us a bit about yourself (optional).' ].

	statusLabel label: ''.

	infoLabel := self newLabel
		             label: 'This information helps personalize your ChatPharo experience.';
		             yourself.

	userNameInput := self newTextInput
		                 placeholder: 'Your name...';
		                 text: ChatPharoSettings default userName;
		                 yourself.

	userOrganizationInput := self newTextInput
		                         placeholder: 'Organization/Company (optional)...';
		                         text: ChatPharoSettings default userOrganization;
		                         yourself.

	continueButton := self newButton
		label: 'Continue';
		icon: (self iconNamed: #glamorousGo);
		action: [ self showExperienceLevelStep ].

	cancelButton := self newButton
		                label: 'Cancel';
		                action: [ self cancelSetup ];
		                yourself.

	nameRow := SpBoxLayout newHorizontal
		           spacing: 8;
		           add: (self newLabel label: 'Name:') expand: false;
		           add: userNameInput expand: true;
		           yourself.

	orgRow := SpBoxLayout newHorizontal
		          spacing: 8;
		          add: (self newLabel label: 'Organization:') expand: false;
		          add: userOrganizationInput expand: true;
		          yourself.

	buttonRow := SpBoxLayout newHorizontal
		             spacing: 8;
		             add: continueButton expand: false;
		             add: cancelButton expand: false;
		             yourself.

	contentContainer layout: (SpBoxLayout newTopToBottom
		spacing: 12;
		add: infoLabel expand: false;
		add: nameRow expand: false;
		add: orgRow expand: false;
	add: buttonRow expand: false;
		yourself).

	self layout: self defaultLayout
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> updateLevelButtonStyles [
	"Update the visual style of level buttons to show selection"

	levelButtons keysAndValuesDo: [ :level :button |
		level = selectedLevel
			ifTrue: [ button icon: (self iconNamed: #glamorousAccept) ]
			ifFalse: [
				level = 'beginner' ifTrue: [ button icon: (self iconNamed: #smallNew) ].
				level = 'intermediate' ifTrue: [ button icon: (self iconNamed: #smallDoIt) ].
				level = 'advanced' ifTrue: [ button icon: (self iconNamed: #smallSystemBrowser) ] ] ]
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> verifyDeveloperId [
	"Verify the entered developer ID against the remote list."

	| enteredId |
	enteredId := developerIdInput text trimBoth.

	enteredId isEmpty ifTrue: [
		statusLabel label: 'Please enter a Developer ID.'.
		^ self ].

	statusLabel label: 'Verifying...'.
	verifyButton enabled: false.

	[
		| isValid settings |
		isValid := ChatPharoDeveloperConfig verifyDeveloperId: enteredId.

		self defer: [
			verifyButton enabled: true.
			isValid
				ifTrue: [
					isDeveloperVerified := true.
					settings := ChatPharoSettings default.
					settings developerId: enteredId.
					settings isDeveloper: true.
					statusLabel label: 'Developer ID verified successfully!'.
					self showUserInfoStep ]
				ifFalse: [
					statusLabel label: 'Invalid Developer ID. Please try again or skip.' ]
		]
	] fork
]
