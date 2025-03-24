local CloseCodes = {
    ["3000"] = "Shutdown",
    ["3010"] = "ZombieConnection",
    ["3024"] = "ResumeClosingOldConnection",
    ["3064"] = "TestingFinished",
    ["3065"] = "Resharded",
    ["3066"] = "ReIdentifying",
    ["1000"] = "NormalClosure",
    ["1001"] = "GoingAway",
    ["4002"] = "DecodeError",
    ["4003"] = "NotAuthenticated",
    ["4004"] = "AuthenticationFailed",
    ["4005"] = "AlreadyAuthenticated",
    ["4007"] = "InvalidSeq",
    ["4008"] = "Ratelimited",
    ["4009"] = "SessionTimedOut",
    ["4010"] = "InvalidShard",
    ["4011"] = "ShardingRequired",
    ["4012"] = "InvalidApiVersion",
    ["4013"] = "InvalidIntents",
    ["4014"] = "DisallowedIntents"
}

return function(code: number?): string
    return CloseCodes[tostring(code)] or "UnknownCloseCode"
end