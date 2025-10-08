package policy

default allow := {"decision": false}

drinkType := json.unmarshal(input.context.data.requestBody).DrinkName
token :=  trim_prefix(trim_suffix(input.action.headers.Authorization, "\""), "Bearer ")

# customer ouder dan 16 ==> bier
allow := {"decision": true}  if {
    [headers, payload, _] := io.jwt.decode(token)
	
    # Check resource
	input.resource.id == "/api/bar"
    input.action.name == "POST"
    
    # Check rol and leeftijd
    "customer" in payload.role
    payload.age > 16

    # Check drinkType
    drinkType == "Beer"
}

# customer jonger dan 16 ==> fristi
allow := {"decision": true}  if {
    [headers, payload, _] := io.jwt.decode(token)
	
    # Check resource
	input.resource.id == "/api/bar"
    input.action.name == "POST"
    
    # Check rol and leeftijd
    "customer" in payload.role

    # Check drinkType
    drinkType == "Fristi"
}

# bartender ==> whiskey
allow := {"decision": true}  if {
    [headers, payload, _] := io.jwt.decode(token)
	
    # Check resource
	input.resource.id == "/api/managebar"
    input.action.name == "POST"    
    
    # Check role
    "bartender" in payload.role

    # Check drinkType
    drinkType == "Whiskey"
}
