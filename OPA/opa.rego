package policy

default allow := {"decision": false}

# customer
allow := {"decision": true}  if {
    token :=  trim_prefix(trim_suffix(input.action.headers.Authorization, "\""), "Bearer ")
    [headers, payload, _] := io.jwt.decode(token)
	
    #Check resource
	input.resource.id == "/api/bar"
    input.action.name == "POST"
    
    #Check role
    "customer" in payload.role
}

# bartender
allow := {"decision": true}  if {
    token :=  trim_prefix(trim_suffix(input.action.headers.Authorization, "\""), "Bearer ")
    [headers, payload, _] := io.jwt.decode(token)
	
    # Check resource
	input.resource.id == "/api/managebar"
    input.action.name == "POST"    
    
    # Check role
    "bartender" in payload.role
}
