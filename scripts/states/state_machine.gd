class_name StateMachine extends Node

var state_dict: Dictionary[StringName, State] = {}
@export var initial_state: State
@onready var curr_state: State = initial_state

## Initializes and gathers all child nodes
func _ready() -> void:
	assert(initial_state, "%s: State machine needs inital state!" % self.name)
	
	#await owner.ready
	var children: Array[Node] = self.get_children()
	for node: Node in children:
		assert(node is State, "%s: All children of a state machine must be States" % self.name)
		state_dict[node.name] = node # add to dict for lookup
		node.transition.connect(transition) # add transition func to signal
	curr_state.enter()


func _process(delta: float) -> void:
	curr_state.process(delta)


func _physics_process(delta: float) -> void:
	curr_state.physics_process(delta)


func _input(event: InputEvent) -> void:
	curr_state.input(event)


func transition(next_state: StringName) -> void:
	curr_state.exit()
	curr_state = state_dict[next_state]
	curr_state.enter()
