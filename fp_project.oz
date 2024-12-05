declare

fun {ProcessString S}
    case S of H|T then 
        if H == "fun" then 
            Vars= {AddVars T}
             {FuncDefinition 2} 
            Vars
        end
    end
end

fun {FuncDefinition L}
    0
end

fun {AddVars Vars}
    case Vars of H|T then
        if H == "=" then nil
        else H|{Test T} 
        end
    end
end


local
L = "fun square x = x*x
square square 3" 
    
C K in

    C = {String.tokens L & }
    K= {ProcessString C}
    {Show K}

end
